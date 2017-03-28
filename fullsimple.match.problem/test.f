/* Examples for testing */

let {x, y, z} = {true, 1, {2}} in z;
let {x, y, z} = {true, 1, {2}} in (lambda x:Nat. x) y;
let {x, y, z} = let x = 1 in {true, x, {2}} in z;
lambda x:Nat. let {x, y} = {true, 1} in x;
let x = 0 in let {y, z} = {1, 2} in x;
let {y, z} = {1, 2} in let y = 3 in y;
