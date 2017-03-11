open Format
open Syntax
open Support.Error
open Support.Pervasive

(* ------------------------   EVALUATION  ------------------------ *)

exception NoRuleApplies

let rec isnumericval t = match t with
    TmZero(_) -> true
  | TmSucc(_,t1) -> isnumericval t1
  | _ -> false

let rec isval t = match t with
    TmTrue(_)  -> true
  | TmFalse(_) -> true
  | t when isnumericval t  -> true
  | _ -> false

let istrue t = match t with
    TmTrue(_) -> true
  | _ -> false

let isfalse t = match t with
    TmFalse(_) -> true
  | _ -> false

let iszero t = match t with
    TmZero(_) -> true
  | _ -> false

let issucc t = match t with
    TmSucc(_, t) -> true
  | _ -> false

let iszero t = match t with
    TmZero(_) -> true
  | _ -> false

let getpred t = match t with
    TmSucc(_, nv) -> nv
  | _ -> t

let rec eval1 t = match t with
    v when isval v ->
        v
  | TmIf(_, t1, t2, t3) when istrue (eval1 t1) && isval (eval1 t2)->
        eval1 t2
  | TmIf(_, t1, t2, t3) when isfalse (eval1 t1) && isval (eval1 t3)->
        eval1 t3
  | TmSucc(fi, t1) when isnumericval (eval1 t1) ->
        TmSucc(fi, eval1 t1)
  | TmPred(_, t1) when iszero (eval1 t1) ->
        TmZero(dummyinfo)
  | TmPred(_, t1) when isnumericval (eval1 t1) ->
        getpred (eval1 t1)
  | TmIsZero(_, t1) when iszero (eval1 t1) ->
        TmTrue(dummyinfo)
  | TmIsZero(_, t1) when isnumericval (eval1 t1) ->
        TmFalse(dummyinfo)
  | _ -> 
        raise NoRuleApplies

let eval t = 
    try eval1 t
    with NoRuleApplies -> t
