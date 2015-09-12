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
let _ = assert(append([2], [1]) = [2;1])
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

let rec clone ((e,n) : 'a * int) : 'a list =
  match n with
  | 0 -> []
  | _ -> e :: clone(e, n-1)

let _ = assert (clone (1, 1) = [1])
let _ = assert (clone (3, 1) = [3])
let _ = assert (clone (72, 3) = [72; 72; 72])
let _ = assert (clone (9, 3) = [9; 9; 9])
let _ = assert (clone ("hello", 3) = ["hello"; "hello"; "hello"])
let _ = assert (clone ("world", 1) = ["world"])
let _ = assert (clone (true, 5) = [true; true; true; true; true])

let rec count ((v,l) : ('a * 'a list)) : int =
	match l with
	| [] -> 0
	| h :: t -> (if h = v then 1 else 0) + count(v, t)

let _ = assert (count (0, [1; 2; 3]) = 0)
let _ = assert (count (5, [1; 2; 3]) = 0)
let _ = assert (count ("hello", ["hello"; "world"]) = 1)
let _ = assert (count (3, [3; 3; 3]) = 3)

let rec reverse (l : 'a list) : 'a list =
	match l with
	| [] -> []
	| h :: t -> append(reverse(t), [h])

let _ = assert (reverse [] = [])
let _ = assert (reverse [1] = [1])
let _ = assert (reverse [1; 2] = [2; 1])
let _ = assert (reverse [1; 2; 3] = [3; 2; 1])
let _ = assert (reverse [1; 4; 2; 3] = [3; 2; 4; 1])
let _ = assert (reverse [true; false] = [false; true])
let _ = assert (reverse ["hello"; "world"] = ["world"; "hello"])

let rec flatten (l: 'a list list) : 'a list =
	match l with
	| [] -> []
	| h :: t -> append(h, flatten(t))

let _ = assert (flatten [[2]; []; [3; 4]] = [2; 3; 4])
let _ = assert (flatten [[]; []; []] = [])
let _ = assert (flatten [["hello"]; ["world"]; []] = ["hello"; "world"])
let _ = assert (flatten [[1; 2]; [4; 5]; [7; 8]] = [1; 2; 4; 5; 7; 8])
let _ = assert (flatten [[]; ["hello"]; []] = ["hello"])
let _ = assert (flatten [[]] = [])
let _ = assert (flatten [[]; []] = [])
let _ = assert (flatten [[]; ["world"]] = ["world"])
let _ = assert (flatten [[17]; [38]] = [17; 38])
let _ = assert (flatten [["hey"; "up"]; ["hello"]] = ["hey"; "up"; "hello"])

let rec tails (l : 'a list) : 'a list list =
	match l with
	| [] -> [[]]
	| h :: t -> l :: tails(t)

let _ = assert (tails [1;2;3] = [[1;2;3];[2;3];[3];[]])
let _ = assert (tails [] = [[]])
let _ = assert (tails [1;2] = [[1;2];[2];[]])
let _ = assert (tails [1] = [[1];[]])
let _ = assert (tails ["hello"; "world"] = [["hello"; "world"];["world"];[]])
let _ = assert (tails [true;false;true] = [[true;false;true];[false;true];[true];[]])

let rec last (l: 'a list) : 'a option =
	match l with
	| [] -> None
	| [x] -> Some x
	| h :: t -> last t

let _ = assert (last [] = None)
let _ = assert (last [1; 3; 2] = Some 2)
let _ = assert (last [1; 2; 3] = Some 3)
let _ = assert (last ["hello"; "world"] = Some "world")
let _ = assert (last [1] = Some 1)
let _ = assert (last ["once"; "told"; "me"; "body"] = Some "body")

let rec longestPrefix (l : 'a list) : 'a list =
	match l with
	| [] -> []
	| [x] -> []
	| h :: t -> h :: longestPrefix(t)

let _ = assert (longestPrefix [1; 2; 3] = [1; 2])
let _ = assert (longestPrefix [] = [])
let _ = assert (longestPrefix ["hello"; "world"] = ["hello"])
let _ = assert (longestPrefix [1] = [])
let _ = assert (longestPrefix [17; 38] = [17])

let rec all (l : 'a list) : bool =
	match l with
	| [] -> true
	| h :: t -> if not h then false else all t

let _ = assert (all [] = true)
let _ = assert (all [true] = true)
let _ = assert (all [false] = false)
let _ = assert (all [true; false] = false)
let _ = assert (all [true; true] = true)

let rec ints (n : int) : 'a list =
	match n with
	| _ when n < 0 -> []
	| 0 -> []
	| _ -> n :: ints(n -1)

let _ = assert (ints 0 = [])
let _ = assert (ints (-1) = [])
let _ = assert (ints 1 = [1])
let _ = assert (ints 2 = [2;1])
let _ = assert (ints 5 = [5;4;3;2;1])

let rec split (l : 'a list) : 'a list * 'a list =
	match l with
	| [] -> ([], [])
	| [x] -> ([x], [])
	| [x; y] -> ([x], [y])
	| h :: x :: y :: t -> (h, x) :: split(y), split(t)

let _ = assert (split [1; 2; 3; 4] = ([1; 3], [2; 4]))
let _ = assert (split [] = ([], []))
let _ = assert (split [1] = ([1], []))
let _ = assert (split [1; 2] = ([1], [2]))
let _ = assert (split [1; 3; 5] = ([1; 5], [3]))
let _ = assert (split [2; 4; 6] = ([2; 6], [4]))