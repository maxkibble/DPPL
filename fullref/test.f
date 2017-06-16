/* Examples for testing */

 lambda x:Bot. x;
 lambda x:Bot. x x; 

 
lambda x:<a:Bool,b:Bool>. x;


lambda x:Top. x;
 (lambda x:Top. x) (lambda x:Top. x);
(lambda x:Top->Top. x) (lambda x:Top. x);


(lambda r:{x:Top->Top}. r.x r.x) 
  {x=lambda z:Top.z, y=lambda z:Top.z}; 


"hello";

unit;

lambda x:A. x;

let x=true in x;

{x=true, y=false}; 
{x=true, y=false}.x;
{true, false}; 
{true, false}.1; 


if true then {x=true,y=false,a=false} else {y=false,x={},b=false};

timesfloat 2.0 3.14159;




lambda x:Bool. x;
(lambda x:Bool->Bool. if x false then true else false) 
  (lambda x:Bool. if x then false else true); 

lambda x:Nat. succ x;
(lambda x:Nat. succ (succ x)) (succ 0); 

T = Nat->Nat;
lambda f:T. lambda x:Nat. f (f x);

/* 18.6.1 */
c = let x = ref 1 in
{get = lambda _:Unit. !x,
inc = lambda _:Unit. x:=succ(!x)};

Counter = {get:Unit->Nat, inc:Unit->Unit};

newCounter =
lambda _:Unit. let x = ref 1 in
{get = lambda _:Unit. !x,
inc = lambda _:Unit. x:=succ(!x)};

ResetCounter = {get:Unit->Nat, inc:Unit->Unit, reset:Unit->Unit};

newResetCounter =
lambda _:Unit. let x = ref 1 in
{get = lambda _:Unit. !x,
inc = lambda _:Unit. x:=succ(!x), reset = lambda _:Unit. x:=1};

CounterRep = {x: Ref Nat};

counterClass = lambda r:CounterRep.
{get = lambda _:Unit. !(r.x),
inc = lambda _:Unit. r.x:=succ(!(r.x))};

newCounter =
lambda _:Unit. let r = {x=ref 1} in
                       counterClass r;

resetCounterClass = lambda r:CounterRep.
      let super = counterClass r in
        {get   = super.get,
         inc   = super.inc,
         reset = lambda _:Unit. r.x:=1};

DecCounter = {get: Unit->Nat, inc: Unit->Unit, reset: Unit->Unit, dec: Unit->Unit};

decCounterClass = lambda r: CounterRep. 
    let super = resetCounterClass r in
      {get = super.get,
       inc = super.inc,
       reset = super.reset,
       dec = lambda _: Unit. r.x := pred(!(r.x))};

/* 18.7.1 */
BackupCounter = {get:Unit->Nat, inc:Unit->Unit, reset:Unit->Unit, backup: Unit->Unit};

BackupCounterRep = {x: Ref Nat, b: Ref Nat};

backupCounterClass = lambda r:BackupCounterRep.
              let super = resetCounterClass r in
                 {get = super.get,
                  inc = super.inc,
                  reset = lambda _:Unit. r.x:=!(r.b), backup = lambda _:Unit. r.b:=!(r.x)};

BackupCounter2 = {get:Unit->Nat, inc:Unit->Unit, reset:Unit->Unit, backup: Unit->Unit,
reset2:Unit->Unit, backup2: Unit->Unit};

BackupCounterRep2 = {x: Ref Nat, b: Ref Nat, b2: Ref Nat};

backupCounterClass2 = lambda r:BackupCounterRep2.
      let super = backupCounterClass r in
         {get = super.get, inc = super.inc,
          reset = super.reset, backup = super.backup, reset2 = lambda _:Unit. r.x:=!(r.b2),
          backup2 = lambda _:Unit. r.b2:=!(r.x)};

/* 18.11.1 */
SetCounter = {get:Unit->Nat, set:Nat->Unit, inc:Unit->Unit};

setCounterClass = lambda r:CounterRep.
  lambda self: Unit->SetCounter.
  lambda _:Unit. 
  {get = lambda _:Unit. !(r.x),
   set = lambda i:Nat. r.x:=i,
   inc = lambda _:Unit. (self unit).set(succ((self unit).get unit))};

InstrCounter = {get:Unit->Nat, set:Nat->Unit, inc:Unit->Unit, accesses:Unit->Nat};

InstrCounterRep = {x: Ref Nat, a: Ref Nat};

instrCounterClass = lambda r:InstrCounterRep.
  lambda self: Unit->InstrCounter. lambda _:Unit.
    let super = setCounterClass r self unit in
      {get = lambda _:Unit. (r.a:=succ(!(r.a)); super.get unit),
       set = lambda i:Nat. (r.a:=succ(!(r.a)); super.set i),
       inc = super.inc,
       accesses = lambda _:Unit. !(r.a)};

ResetInstrCounter = {get:Unit->Nat, set:Nat->Unit,
                     inc:Unit->Unit, accesses:Unit->Nat,
                     reset:Unit->Unit};

resetInstrCounterClass = lambda r:InstrCounterRep.
  lambda self: Unit->ResetInstrCounter. lambda _:Unit.
    let super = instrCounterClass r self unit in 
      {get = super.get,
       set = super.set,
       inc = super.inc,
       accesses = super.accesses,
       reset = lambda _:Unit. r.x:=0};

BackupInstrCounter = 
  {get:Unit->Nat, set:Nat->Unit,
   inc:Unit->Unit, accesses:Unit->Nat, 
   backup:Unit->Unit, reset:Unit->Unit};
   
BackupInstrCounterRep = {x: Ref Nat, a: Ref Nat, b: Ref Nat};

backupInstrCounterClass = lambda r:BackupInstrCounterRep.
  lambda self: Unit->BackupInstrCounter. lambda _:Unit.
    let super = resetInstrCounterClass r self unit in 
      {get = super.get,
       set = super.set,
       inc = super.inc,
       accesses = super.accesses,
       reset = lambda _:Unit. r.x:=!(r.b),
       backup = lambda _:Unit. r.b:=!(r.x)};

newBackupInstrCounter = lambda _:Unit.
  let r = {x=ref 1, a=ref 0, b=ref 0} in
      fix (backupInstrCounterClass r) unit;