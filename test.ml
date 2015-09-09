let rec fib (n : int) : int =
  match n with
  | 0 -> 0
  | 1 -> 1
  | _ -> fib(n - 1) + fib(n - 2)

let _ = assert(fib(0) = 0)
let _ = assert(fib(1) = 1)
let _ = assert(fib(2) = 1)
let _ = assert(fib(3) = 2)
let _ = assert(fib(4) = 3)
let _ = assert(fib(5) = 5)
let _ = assert(fib(6) = 8)
let _ = assert(fib(7) = 13)
let _ = assert(fib(8) = 21)
let _ = assert(fib(9) = 34)
let _ = assert(fib(10) = 55)

let rec append ((l1,l2) : ('a list * 'a list)) : 'a list =
  match l1 with
  | [] -> l2
  | h :: t -> h :: append(t, l2)

let _ = assert(append([], []) = [])
let _ = assert(append([1], []) = [1])
let _ = assert(append([], [1]) = [1])
let _ = assert(append([1;2], [3;4]) = [1;2;3;4])
let _ = assert(append([1;2], [1;2]) = [1;2;1;2])
let _ = assert(append([1;2;3], [4;5;6]) = [1;2;3;4;5;6])
let _ = assert(append([1;3;5], [2;4;6]) = [1;3;5;2;4;6])
let _ = assert(append([], [1;3;4;5]) = [1;3;4;5])
let _ = assert(append([], ["hello"; "world"]) = ["hello"; "world"])
let _ = assert(append(["hello"], ["world"]) = ["hello"; "world"])
let _ = assert(append([true], [false]) = [true; false])
let _ = assert(append([], [true]) = [true])
let _ = assert(append([false], []) = [false])