let map = List.map
let filter = List.filter
let fold_left = List.fold_left
let fold_right = List.fold_right

let doubleAllPos : int list -> int list =
	map (fun x -> if x > 0 then 2 * x else x)

let _ = assert (doubleAllPos [1;2;-1;4;-3;0] = [2;4;-1;8;-3;0])
let _ = assert (doubleAllPos [0;1;2;3;-1;-2;-3] = [0;2;4;6;-1;-2;-3])
let _ = assert (doubleAllPos [1;-1] = [2;-1])
let _ = assert (doubleAllPos [] = [])
let _ = assert (doubleAllPos [1;-1;500;-27] = [2;-1;1000;-27])

let unzip (l : ('a * 'b) list) : 'a list * 'b list =
	fold_right (fun (x,y) (first_list, second_list) -> (x :: first_list, y :: second_list)) l ([],[])

let _ = assert (unzip [(1,'a');(2,'b')] = ([1;2], ['a';'b']))
let _ = assert (unzip [('a',1);('b',2)] = (['a';'b'],[1;2]))
let _ = assert (unzip [(1,true);(2,false)] = ([1;2],[true;false]))

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

let rec foldn (f : (int -> 'a -> 'a)) (n : int) (b : 'a) : 'a =
	match n with
	| 0 -> b
	| _ -> f n (foldn f (n-1) b)

let _ = assert (foldn (fun x y -> x * y) 5 1 = 5 * 4 * 3 * 2 * 1)
let _ = assert (foldn (fun x y -> x - y) 5 0 = 5 - (4 - (3 - (2 - (1 - 0)))))
let _ = assert (foldn (fun x y -> x + y) 5 0 = 5 + (4 + (3 + (2 + (1 + 0)))))

let clone ((e,n) : 'a * int) : 'a list =
	foldn (fun x y -> let x = e in x :: y) n []

let _ = assert (clone (3, 1) = [3])
let _ = assert (clone (72, 3) = [72; 72; 72])
let _ = assert (clone (9, 3) = [9; 9; 9])
let _ = assert (clone ("hello", 3) = ["hello"; "hello"; "hello"])
let _ = assert (clone ("world", 1) = ["world"])
let _ = assert (clone (true, 5) = [true; true; true; true; true])

let rec map2 (f : ('a -> 'b -> 'c)) (l1 : 'a list) (l2 : 'b list) : 'c list =
	match l1, l2 with
	| [], [] -> []
	| x, [] -> []
	| [], x -> []
	| h1::t1, h2::t2 -> f h1 h2 :: map2 f t1 t2

let _ = assert (map2 (fun x y -> x * y) [1;2;3] [4;5;6] = [1*4; 2*5; 3*6])
let _ = assert (map2 (fun x y -> x + y) [1;2;3] [4;5;6] = [1 + 4; 2 + 5; 3 + 6])
let _ = assert (map2 (fun x y -> x - y) [6;5;4] [3;2;1] = [6 - 3; 5 - 2; 4 - 1])

let zip (l1 : 'a list) (l2 : 'b list) : ('a * 'b) list =
	map2 (fun x y-> (x,y)) l1 l2

let _ = assert (zip [1;2] ['a';'b']  = [(1,'a');(2,'b')])
let _ = assert (zip ['a';'b'] [1;2] = [('a',1);('b',2)])
let _ = assert (zip [1;2] [true;false] = [(1,true);(2,false)])

let encode (l : 'a list) : (int * 'a) list =
	fold_right (fun x y -> (if y = x then + x else (1, x)) :: y) l []

let _ = assert (encode ['a';'a';'a';'b';'c';'c'] = [(3,'a');(1,'b');(2,'c')])
let _ = assert (encode ['a';'a';'b';'b';'a'] = [(2,'a');(2,'b');(1;'a')])
let _ = assert (encode ['a';'b';'c';'a';'a'] = [(1,'a');(1,'b');(1,'c');(2,'a')])
let _ = assert (encode ['a'] = [(1,'a')])
let _ = assert (encode [] = [])
let _ = assert (encode [1;2;2;3;3;3] = [(1,1);(2,2);(3,3)])

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