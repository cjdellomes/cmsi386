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
	let getLeft (a, _ : 'a list * 'a list) = a in
	let getTail (l: 'a list) = 
	match l with
	| []-> []
	| h :: t -> t
	in
	match l with
	| [] -> ([], [])
	| [a] -> ([a], [])
	| [a; b] -> ([a], [b])
	| h :: m :: t -> (h :: getLeft(split(t)), m :: getLeft(split(getTail(t))))

let _ = assert (split [1; 2; 3; 4] = ([1; 3], [2; 4]))
let _ = assert (split [] = ([], []))
let _ = assert (split [1] = ([1], []))
let _ = assert (split [1; 2] = ([1], [2]))
let _ = assert (split [1; 3; 5] = ([1; 5], [3]))
let _ = assert (split [2; 4; 6] = ([2; 6], [4]))

let rec int_of_digits (ds : int list) : int =
	let x = 10.0 ** (float_of_int(List.length(ds) - 1)) in
	match ds with
	| [] -> 0
	| h :: t -> (h * int_of_float(x)) + int_of_digits(t)

let _ = assert (int_of_digits [1; 2; 3] = 123)
let _ = assert (int_of_digits [0; 1; 0] = 10)
let _ = assert (int_of_digits [0] = 0)
let _ = assert (int_of_digits [0; 0; 0] = 0)
let _ = assert (int_of_digits [0; 0; 0; 7] = 7)
let _ = assert (int_of_digits [0; 1; 7; 3; 8] = 1738)
let _ = assert (int_of_digits [] = 0)
let _ = assert (int_of_digits [5; 3; 2; 1; 0] = 53210)
let _ = assert (int_of_digits [9; 0; 0] = 900)

let rec chars (s:string) : char list =
	let x = String.length(s) - 1 in
	match String.length(s) with
	| 0 -> []
	| 1 -> [String.get s 0]
	| _ -> append(chars(String.sub s 0 x),[String.get s x])

let _ = assert (chars "asdf" = ['a'; 's'; 'd'; 'f'])
let _ = assert (chars "a" = ['a'])
let _ = assert (chars "abc" = ['a'; 'b'; 'c'])
let _ = assert (chars "1738" = ['1'; '7'; '3'; '8'])
let _ = assert (chars "" = [])
let _ = assert (chars "1a" = ['1';'a'])
let _ = assert (chars "a b" = ['a'; ' '; 'b'])

let rec fibsFrom (n:int) : int list =
	match n with
	| 0 -> [0]
	| 1 -> [1;0]
	| _ -> let x = fibsFrom(n-1) in append([List.nth x 0 + List.nth x 1], x)

let _ = assert (fibsFrom 1 = [1; 0])
let _ = assert (fibsFrom 0 = [0])
let _ = assert (fibsFrom 2 = [1; 1; 0])
let _ = assert (fibsFrom 3 = [2; 1; 1; 0])
let _ = assert (fibsFrom 4 = [3; 2; 1; 1; 0])
let _ = assert (fibsFrom 5 = [5; 3; 2; 1; 1; 0])
let _ = assert (fibsFrom 6 = [8; 5; 3; 2; 1; 1; 0])
let _ = assert (fibsFrom 7 = [13; 8; 5; 3; 2; 1; 1; 0])
let _ = assert (fibsFrom 8 = [21; 13; 8; 5; 3; 2; 1; 1; 0])
let _ = assert (fibsFrom 9 = [34; 21; 13; 8; 5; 3; 2; 1; 1; 0])
let _ = assert (fibsFrom 10 = [55; 34; 21; 13; 8; 5; 3; 2; 1; 1; 0])

let rec palindrome (l : 'a list) : bool =
	match l with
	| [] -> true
	| [x] -> true
	| h :: t -> if Some h = last(l) then palindrome(longestPrefix(t)) else false

let _ = assert (palindrome [1; 2; 3; 2; 1] = true)
let _ = assert (palindrome [] = true)
let _ = assert (palindrome [1; 2; 3] = false)
let _ = assert (palindrome ["h"; "i"] = false)
let _ = assert (palindrome ["y"; "a"; "y"] = true)
let _ = assert (palindrome [1] = true)
let _ = assert (palindrome ["a"] = true)

let fastRev (l : 'a list) : 'a list =
  let rec revHelper (remain, sofar) =
    match remain with
    | [] -> sofar
    | h :: t -> revHelper(t, h :: sofar)
in revHelper(l, [])

let _ = assert (fastRev [] = [])
let _ = assert (fastRev [1] = [1])
let _ = assert (fastRev [1; 2] = [2; 1])
let _ = assert (fastRev [1; 2; 1] = [1; 2; 1])
let _ = assert (fastRev ["a"] = ["a"])
let _ = assert (fastRev ["a"; "b"] = ["b"; "a"])
let _ = assert (fastRev ["a"; "b"; "a"] = ["a"; "b"; "a"])