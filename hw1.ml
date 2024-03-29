(* Name: Christopher Dellomes
   Email: cdellome@lion.lmu.edu
   Student ID: 976113672

   Others With Whom I Discussed Things:
   Peyton Cross
   Trixie Roque
   Victor Frolov
   Justin Sanny

   Other Resources I Consulted:
   https://realworldocaml.org/v1/en/html/lists-and-patterns.html
   http://www.geeksforgeeks.org/write-a-function-to-reverse-the-nodes-of-a-linked-list/
   http://static1.squarespace.com/static/51224b9fe4b0dce195c74e5d/t/51b08a10e4b0f797b965d72d/1370524176424/CopingWithErrors.pdf
   https://ocaml.org/learn/tutorials/basics.html
   http://caml.inria.fr/pub/docs/manual-ocaml/libref/String.html
   http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html
   http://stackoverflow.com/questions/26005545/ocaml-extract-nth-element-of-a-tuple
   
*)

(* NOTE: for full credit, add unit tests for each problem.  You should
   define enough unit tests to provide full test coverage for your
   code; each subexpression should be evaluated for at least one
   test.

   Use OCaml's built-in assert function to define unit tests.
  
   run `ocaml hw1.ml` to typecheck and run all tests.
 *)

let _ = assert (1 = 1)
let _ = assert (not (1 = 0))

(* Problem 1
Write a function to compute the nth Fibonacci number, where
the 0th Fibonacci number is 0, the 1st is 1, and the nth for n > 1 is
the sum of the (n-1)st and (n-2)nd Fibonacci numbers.
 *)

let rec fib (n : int) : int =
  match n with
  | 0 -> 0
  | 1 -> 1
  | _ -> fib(n - 1) + fib(n - 2)

let _ = assert (fib 0 = 0)
let _ = assert (fib 1 = 1)
let _ = assert (fib 2 = 1)
let _ = assert (fib 3 = 2)
let _ = assert (fib 4 = 3)
let _ = assert (fib 5 = 5)
let _ = assert (fib 6 = 8)
let _ = assert (fib 7 = 13)
let _ = assert (fib 8 = 21)
let _ = assert (fib 9 = 34)
let _ = assert (fib 10 = 55)

(* Problem 2	       
Write a function clone of type 'a * int -> 'a list.  The function
takes an item e and a nonnegative integer n and returns a list
containing n copies of e.  
 *)

let rec clone ((e,n) : 'a * int) : 'a list =
  match n with
  | 0 -> []
  | _ -> e :: clone(e, n-1)

let _ = assert (clone (3, 1) = [3])
let _ = assert (clone (72, 3) = [72; 72; 72])
let _ = assert (clone (9, 3) = [9; 9; 9])
let _ = assert (clone ("hello", 3) = ["hello"; "hello"; "hello"])
let _ = assert (clone ("world", 1) = ["world"])
let _ = assert (clone (true, 5) = [true; true; true; true; true])

(* Problem 3
Write a recursive function to get the number of occurrences of an
element in a list. For example, there are 0 occurrences of 5 in [1;2;3].
There are 2 occurrences of 5 in [1;5;5;0].
 *)

let rec count ((v,l) : ('a * 'a list)) : int =
  match l with
  | [] -> 0
  | h :: t -> (if h = v then 1 else 0) + count(v, t)

let _ = assert (count (0, [1; 2; 3]) = 0)
let _ = assert (count (5, [1; 2; 3]) = 0)
let _ = assert (count ("hello", ["hello"; "world"]) = 1)
let _ = assert (count (3, [3; 3; 3]) = 3)

(* Problem 4
Write a function that appends one list to the front of another.    
 *)

let rec append ((l1,l2) : ('a list * 'a list)) : 'a list =
  match l1 with
  | [] -> l2
  | h :: t -> h :: append(t, l2)

let _ = assert (append ([], []) = [])
let _ = assert (append ([1], []) = [1])
let _ = assert (append ([], [1]) = [1])
let _ = assert (append ([1; 2], [3; 4]) = [1; 2; 3; 4])
let _ = assert (append ([1; 2], [1; 2]) = [1; 2; 1; 2])
let _ = assert (append ([1; 2; 3], [4; 5; 6]) = [1; 2; 3; 4; 5; 6])
let _ = assert (append ([1; 3; 5], [2; 4; 6]) = [1; 3; 5; 2; 4; 6])
let _ = assert (append ([], [1; 3; 4; 5]) = [1; 3; 4; 5])
let _ = assert (append ([], ["hello"; "world"]) = ["hello"; "world"])
let _ = assert (append (["hello"], ["world"]) = ["hello"; "world"])
let _ = assert (append ([true], [false]) = [true; false])
let _ = assert (append ([], [true]) = [true])
let _ = assert (append ([false], []) = [false])
    
(* Problem 5
Use append to write a recursive function that reverses the elements in
a list.
 *)

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
    
(* Problem 6
Write a function "tails" of type 'a list -> 'a list list that takes a
list and returns a list of lists containing the original list along
with all tails of the list, from longest to shortest.
 *)	       

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

(* Problem 7
Write a function split of type 'a list -> 'a list * 'a list that
separates out those elements of the given list in odd positions (that
is, the first, third, fifth, etc.) from those in even positions (that
is, the second, fourth, etc.). 
 *)

let rec split (l : 'a list) : 'a list * 'a list =
  let getLeft (a, _ : 'a list * 'a list) = a in
  let _ = assert (getLeft([1],[2]) = [1]) in

  let getTail (l: 'a list) = 
  match l with
  | []-> []
  | h :: t -> t
  in
  let _ = assert (getTail([1]) = []) in

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

(* Problem 8
Flatten a list of lists.
 *)

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
				       
(* Problem 9
Write a function to return the last element of a list. To deal with
the case when the list is empty, the function should return a value of
the built-in option type, defined as follows:

type 'a option = None | Some of 'a
 *)

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

(* Problem 10
Write a recursive function to return the longest prefix of a list --
another list containing all but the last element. For example, the
longest prefix of [1;2;3;4;5] is [1;2;3;4]
 *)

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
	       
(* Problem 11
Write a recursive function that checks whether a list is a
palindrome. A palindrome reads the same forward or backward;
e.g. ["x"; "a"; "m"; "a"; "x"]. Hint: use last and longestPrefix.
 *)
	       
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

(* Problem 12
The naive implementation of fib is wildly inefficient, because it does
a ton of redundant computation.  Perhaps surprisingly, we can make
things much more efficient by building a list of the first n Fibonacci
numbers. Write a function fibsFrom that takes a nonnegative number n
and returns a list of the first n Fibonacci numbers in reverse order
(i.e., from the nth to the 0th).  Recall that the 0th Fibonacci number
is 0, the 1st is 1, and the nth for n > 1 is the sum of the (n-1)st
and (n-2)nd Fibonacci numbers.  You should implement fibsFrom without
writing any helper functions.  A call like (fibsFrom 50) should be
noticeably faster than (fib 50).  Hint: Your function should make only
one recursive call.
 *)

let rec fibsFrom (n : int) : int list =
  match n with
  | 0 -> [0]
  | 1 -> [1; 0]
  | _ -> let x = fibsFrom(n - 1) in append([List.nth x 0 + List.nth x 1], x)

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
	       
(* Problem 13
The naive algorithm for reversing a list takes time that is quadratic
in the size of the argument list.  In this problem, you will implement
a more efficient algorithm for reversing a list: your solution should
only take linear time. Call this function fastRev. The key to fastRev
is that it builds the reversed list as we recurse over the input list,
rather than as we return from each recursive call.  This is similar to
how an iterative version of list reversal, as implemented in a
language like C, would naturally work.

To get the right behavior, your fastRev function should use a local
helper function revHelper to do most of the work.  The helper function
should take two arguments: (1) the suffix of the input list that
remains to be reversed; (2) the reversal of the first part of the
input list.  The helper function should return the complete reversed
list.  Therefore the reversal of an input list l can be performed via
the invocation revHelper(l, []).  I've already provided this setup for
you, so all you have to do is provide the implementation of revHelper
(which is defined as a nested function within fastRev) and invoke it
as listed above.  The call (fastRev (clone(0, 10000))) should be
noticeably faster than (reverse (clone(0, 10000))).
 *)
				       
let fastRev (l : 'a list) : 'a list =
  let rec revHelper (remain, sofar) =
    match remain with
    | [] -> sofar
    | h :: t -> revHelper(t, h :: sofar)
  in
  let _ = assert(revHelper([1;2;3], []) = [3;2;1])
in revHelper(l, [])

let _ = assert (fastRev [] = [])
let _ = assert (fastRev [1] = [1])
let _ = assert (fastRev [1; 2] = [2; 1])
let _ = assert (fastRev [1; 2; 1] = [1; 2; 1])
let _ = assert (fastRev ["a"] = ["a"])
let _ = assert (fastRev ["a"; "b"] = ["b"; "a"])
let _ = assert (fastRev ["a"; "b"; "a"] = ["a"; "b"; "a"])
				       
(* Problem 14
Strings in OCaml do not support pattern matching very well, so it is
sometimes necessary to convert them to something that we can match on
more easily: lists of characters.  Using OCaml's built-in functions
String.get and String.length, write a function chars that converts a
string to a char list.
 *)

let _ = assert (String.get "asdf" 0 = 'a')
let _ = assert (String.length "asdf" = 4)	       

let rec chars (s : string) : char list =
  let x = String.length(s) - 1 in
  match String.length(s) with
  | 0 -> []
  | 1 -> [String.get s 0]
  | _ -> append(chars(String.sub s 0 x),[String.get s x])

let _ = assert (chars "asdf" = ['a'; 's'; 'd'; 'f'])
let _ = assert (chars "" = [])
let _ = assert (chars "a" = ['a'])
let _ = assert (chars "abc" = ['a'; 'b'; 'c'])
let _ = assert (chars "1738" = ['1'; '7'; '3'; '8'])
    
(* Problem 15
Convert a list of digits (numbers between 0 and 9) into an integer.
 *)

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