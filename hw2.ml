(* Name: Christopher Dellomes

   UID: 976113672

   Others With Whom I Discussed Things:
   Victor Frolov
   Peyton Cross
   Justin Sanny
   Trixie Roque
   Mondo Yamaguchi

   Other Resources I Consulted:
   http://caml.inria.fr/pub/docs/manual-ocaml/libref/List.html
   
*)

(* For this assignment, you will get practice with higher-order functions
 * in OCaml.  In a few places below, you are required to implement your
 * functions in a particular way, so pay attention to those directives or
 * you will get no credit for the problem.
 *)

(* Do not use any functions defined in other modules, except for List.map,
 * List.filter, List.fold_left, and List.fold_right. 
 *)

let map = List.map
let filter = List.filter
let fold_left = List.fold_left
let fold_right = List.fold_right

(************************************************************************
 * Problem 1: Using higher-order functions.
 *
 * Implement each function below as a single call to one of map, filter,
 * fold_left, or fold_right.
 ************************************************************************)

(* Problem 1a.
   A function that takes a list as input and returns the same list except 
   with all positive integers doubled in value.  Other integers are
   kept but are unchanged.
 *)

let doubleAllPos : int list -> int list =
   map (fun x -> if x > 0 then 2 * x else x)

let _ = assert (doubleAllPos [1;2;-1;4;-3;0] = [2;4;-1;8;-3;0])
let _ = assert (doubleAllPos [0;1;2;3;-1;-2;-3] = [0;2;4;6;-1;-2;-3])
let _ = assert (doubleAllPos [1;-1] = [2;-1])
let _ = assert (doubleAllPos [] = [])
let _ = assert (doubleAllPos [1;-1;500;-27] = [2;-1;1000;-27])

(* Problem 1b.
   A function that takes a list of pairs and returns a pair of lists.
   The first list contains the first component of each input pair;
   the second list contains the second components.
 *)
   
let unzip (l : ('a * 'b) list) : 'a list * 'b list = 
   fold_right (fun (x,y) (first_list, second_list) -> (x :: first_list, y :: second_list)) l ([],[])

let _ = assert (unzip [(1,'a');(2,'b')] = ([1;2], ['a';'b']))
let _ = assert (unzip [('a',1);('b',2)] = (['a';'b'],[1;2]))
let _ = assert (unzip [(1,true);(2,false)] = ([1;2],[true;false]))
let _ = assert (unzip [(1,2);(3,4)] = ([1;3], [2;4]))

(* Problem 1c.
   Implement the so-called run-length encoding data compression method.
   Consecutive duplicates of elements are encoded as pairs (N, E) where
   N is the number of duplicates of the element E.
 *)

let encode : 'a list -> (int * 'a) list = TODO

let _ = assert (encode ['a';'a';'a';'b';'c';'c'] = [(3,'a');(1,'b');(2,'c')])
let _ = assert (encode ['a';'a';'b';'b';'a'] = [(2,'a');(2,'b');(1;'a')])
let _ = assert (encode ['a';'b';'c';'a';'a'] = [(1,'a');(1,'b');(1,'c');(2,'a')])
let _ = assert (encode ['a'] = [(1,'a')])
let _ = assert (encode [] = [])
let _ = assert (encode [1;2;2;3;3;3] = [(1,1);(2,2);(3,3)])

(* Problem 1d
   The function intOfDigits from Homework 1.
 *)   

let intOfDigits (l : int list) : int =
   fold_left (fun x y -> 10 * x + y) 0 l

let _ = assert (intOfDigits [1; 2; 3] = 123)
let _ = assert (intOfDigits [0; 1; 0] = 10)
let _ = assert (intOfDigits [0] = 0)
let _ = assert (intOfDigits [0; 0; 0] = 0)
let _ = assert (intOfDigits [0; 0; 0; 7] = 7)
let _ = assert (intOfDigits [0; 1; 7; 3; 8] = 1738)
let _ = assert (intOfDigits [] = 0)
let _ = assert (intOfDigits [5; 3; 2; 1; 0] = 53210)
let _ = assert (intOfDigits [9; 0; 0] = 900)

(***********************************************************************
 * Problem 2: Defining higher-order functions.
 ***********************************************************************)

(* Problem 2a.  

   A useful variant of map is the map2 function, which is like map but
   works on two lists instead of one. Note: If either input list is
   empty, then the output list is empty.

   Define map2 function using explicit recursion.

   Do not use any functions from the List module or other modules.
 *)

let rec map2 (f : ('a -> 'b -> 'c)) (l1 : 'a list) (l2 : 'b list) : 'c list =
   match l1, l2 with
   | [], [] -> []
   | x, [] -> []
   | [], x -> []
   | h1::t1, h2::t2 -> f h1 h2 :: map2 f t1 t2

let _ = assert (map2 (fun x y -> x * y) [1;2;3] [4;5;6] = [1*4; 2*5; 3*6])
let _ = assert (map2 (fun x y -> x + y) [1;2;3] [4;5;6] = [1 + 4; 2 + 5; 3 + 6])
let _ = assert (map2 (fun x y -> x - y) [6;5;4] [3;2;1] = [6 - 3; 5 - 2; 4 - 1])

(* Problem 2b.

   Now implement the zip function, which is the inverse of unzip
   above. zip takes two lists l1 and l2, and returns a list of pairs,
   where the first element of the ith pair is the ith element of l1,
   and the second element of the ith pair is the ith element of l2.

   Implement zip as a function whose entire body is a single call to
   map2.
 *)

let zip (l1 : 'a list) (l2 : 'b list) : ('a * 'b) list =
   map2 (fun x y-> (x,y)) l1 l2

let _ = assert (zip [1;2] ['a';'b']  = [(1,'a');(2,'b')])
let _ = assert (zip ['a';'b'] [1;2] = [('a',1);('b',2)])
let _ = assert (zip [1;2] [true;false] = [(1,true);(2,false)])
let _ = assert (zip [1;2] [3;4] = [(1,3);(2,4)])

(* Problem 2c.

   A useful variant of fold_right and fold_left is the foldn function,
   which folds over an integer (assumed to be nonnegative) rather than
   a list. Given a function f, an integer n, and a base case b, foldn
   calls f n times. The input to the first call is the base case b,
   the input to second call is the output of the first call, and so
   on.

   For example, we can define the factorial function as:
   let fact n = foldn (fun x y -> x*y) n 1

   Implement foldn using explicit recursion.
 *)

let rec foldn (f : (int -> 'a -> 'a)) (n : int) (b : 'a) : 'a =
   match n with
   | 0 -> b
   | _ -> f n (foldn f (n-1) b)

let _ = assert (foldn (fun x y -> x * y) 5 1 = 5 * 4 * 3 * 2 * 1)
let _ = assert (foldn (fun x y -> x - y) 5 0 = 5 - (4 - (3 - (2 - (1 - 0)))))
let _ = assert (foldn (fun x y -> x + y) 5 0 = 5 + (4 + (3 + (2 + (1 + 0)))))

(* Problem 2d.
   Implement the clone function from Homework 1 as a single call to
   foldn.
 *)

let clone ((e,n) : 'a * int) : 'a list =
   foldn (fun x y -> let x = e in x :: y) n []

let _ = assert (clone (3, 1) = [3])
let _ = assert (clone (72, 3) = [72; 72; 72])
let _ = assert (clone (9, 3) = [9; 9; 9])
let _ = assert (clone ("hello", 3) = ["hello"; "hello"; "hello"])
let _ = assert (clone ("world", 1) = ["world"])
let _ = assert (clone (true, 5) = [true; true; true; true; true])

(* Problem 2e.
   Implement fibsFrom from Homework1 as a single call to foldn.
 *)

let fibsFrom (n : int) : int list =
   List.tl (foldn (fun x y -> let x = List.nth y 0 + List.nth y 1 in x :: y) n [1;0])

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

(************************************************************************
 * Problem 3: Dictionaries.
 * A dictionary (sometimes also called a map) is a data structure that 
 * associates keys with values (or maps keys to values). A dictionary 
 * supports three main operations:  empty, which returns an empty
 * dictionary; put, which adds a new key-value pair to a given dictionary; 
 * and get, which looks up the value associated with a given key in a
 * given dictionary.  If the given key is already associated with some 
 * value in the dictionary, then put should (conceptually) replace the old
 * key-value pair with the new one.  To handle the case when the given
 * key is not mapped to some value in the dictionary, get will return an
 * option, i.e. either the value None or the value Some v, where v is the
 * value associated with the given key in the dictionary.

 * In this problem we'll explore three different implementations of a 
 * dictionary data structure. It's OK if the types that OCaml infers for some 
 * of these functions are more general than the types we specify. Specifically,
 * the inferred types could use a type variable like 'a in place of a more
 * specific type.
 ************************************************************************)

(* Problem 3a.

   Our first implementation of a dictionary is as an "association
   list", i.e. a list of pairs. Implement empty1, put1, and get1 for
   association lists (we use the suffix 1 to distinguish from other
   implementations below).  As an example of how this representation
   of dictionaries works, the dictionary that maps "hello" to 5 and
   has no other entries is represented as [("hello",5)].

   To get the effect of replacing old entries for a key, put1 should
   simply add new entries to the front of the list, and accordingly
   get1 should return the leftmost value whose associated key matches
   the given key.

   empty1: unit -> ('a * 'b) list
   put1: 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list
   get1: 'a -> ('a * 'b) list -> 'b option
 *)

let empty1 : unit -> ('a * 'b) list = fun () -> []
let _ = assert (empty1 () = [])

let put1 : 'a -> 'b -> ('a * 'b) list -> ('a * 'b) list = fun x y l -> (x,y) :: l
let _ = assert (put1 "hello" 1 [] = [("hello",1)])
let _ = assert (put1 1 2 [(1,2)] = [(1,2);(1,2)])

let get1 : 'a -> ('a * 'b) list -> 'b option =
   let getLeft ((x,y) : ('a * 'b)) : 'a = x in
   let getRight ((x,y) : ('a * 'b)) : 'a = y in
   fun x l -> let a = getRight(List.hd l) in if x = getLeft(List.hd l) then Some a else None

let _ = assert (get1 0 [(0,1)] = Some 1)
let _ = assert (get1 0 [(0,1);(1,2)] = Some 1)

(* Problem 3b.

   Our second implementation of a dictionary uses a new datatype 
   "dict2", defined below.

   dict2 is polymorphic in the key and value types, which respectively
   are represented by the type variables 'a and 'b.  For example, the
   dictionary that maps "hello" to 5 and has no other entries would be
   represented as the value Entry("hello", 5, Empty) and
   would have the type (string,int) dict2.

   Implement empty2, put2, and get2 for dict2.  As above, new entries
   should be added to the front of the dictionary, and get2 should
   return the leftmost match.

   empty2: unit -> ('a,'b) dict2
   put2: 'a -> 'b -> ('a,'b) dict2 -> ('a,'b) dict2
   get2: 'a -> ('a,'b) dict2 -> 'b option
 *)
    
type ('a,'b) dict2 = Empty | Entry of 'a * 'b * ('a,'b) dict2
    
(* Problem 3c

   Conceptually, a dictionary is just a function from keys to values.
   Since OCaml has first-class functions, we can choose to represent
   dictionaries as actual functions.  We define the following type:

   type ('a,'b) dict3 = ('a -> 'b option)

   We haven't seen the above syntax before (note that the right-hand
   side just says ('a -> 'b option) rather than something like Foo of
   ('a -> 'b option)).  Here dict3 is a type synonym: it is just a
   shorthand for the given function type rather than a new type.  As
   an example of how this representation of dictionaries works, the
   following dictionary maps "hello" to 5 and has no other entries:

   (function s ->
    match s with
    | "hello" -> Some 5
    | _ -> None)

   One advantage of this representation over the two dictionary
   implementations above is that we can represent infinite-size
   dictionaries.  For instance, the following dictionary maps all
   strings to their length (using the String.length function):

   (function s -> Some(String.length s))

   Implement empty3, put3, and get3 for dict3.  It's OK if the types
   that OCaml infers for these functions use ('a -> 'b option) in
   place of ('a,'b) dict3, since they are synonyms for one another.

   empty3: unit -> ('a,'b) dict3
   put3: 'a -> 'b -> ('a,'b) dict3 -> ('a,'b) dict3
   get3: 'a -> ('a,'b) dict3 -> 'b option
 *)  

type ('a,'b) dict3 = ('a -> 'b option)

