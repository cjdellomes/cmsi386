(* Name: Christopher Dellomes

   UID: 976113672

   Others With Whom I Discussed Things:
   Justin Sanny
   J.B. Morris
   Nick Soffa
   Victor Frolov

   Other Resources I Consulted:
   https://realworldocaml.org/v1/en/html/error-handling.html
   
*)

(* EXCEPTIONS *)

(* This is a marker for places in the code that you have to fill in.
   Your completed assignment should never raise this exception. *)
exception ImplementMe of string

(* This exception is thrown when a type error occurs during evaluation
   (e.g., attempting to invoke something that's not a function).
*)
exception DynamicTypeError of string

(* This exception is thrown when pattern matching fails during evaluation. *)  
exception MatchFailure  

(* TESTING *)

(* We need to be able to test code that might throw an exception. In particular,
   we want to test that it does throw a particular exception when we expect it to.
 *)

type 'a or_exception = Value of 'a | Exception of exn

(* General-purpose testing function. You don't need to use this. I'll provide
   specialized test functions you can use instead.
 *)

let tester (nm : string) (thunk : unit -> 'a) (expected : 'a or_exception) =
  let got = try Value (thunk ()) with e -> Exception e in
  let msg = match (expected, got) with
      (e1,e2)              when e1 = e2   -> "OK"
    | (Value _,  Value _)                 -> "FAILED (value error)"
    | (Exception _, Value _)              -> "FAILED (expected exception)"
    | (_, Exception (ImplementMe msg))    -> "FAILED: ImplementMe(" ^ msg ^ ")"
    | (_, Exception (MatchFailure))       -> "FAILED: MatchFailure"
    | (_, Exception (DynamicTypeError s)) -> "FAILED: DynamicTypeError(" ^ s ^ ")"
    | (_, Exception e)                    -> "FAILED: " ^ Printexc.to_string e
  in
  print_string (nm ^ ": " ^ msg ^ "\n");
  flush stdout

(* EVALUATION *)

(* See if a value matches a given pattern.  If there is a match, return
   an environment for any name bindings in the pattern.  If there is not
   a match, raise the MatchFailure exception.
*)
let rec patMatch (pat : mopat) (value : movalue) : moenv =
  match (pat, value) with
      (* an integer pattern matches an integer only when they are the same constant;
	 no variables are declared in the pattern so the returned environment is empty;
   if pattern does not match value, throw MatchFailure *)
    |  (IntPat(i), IntVal(j)) when i = j -> Env.empty_env()
      (* integer pattern rules apply for booleans *)
    |  (BoolPat(i), BoolVal(j)) when i = j -> Env.empty_env()
      (* wildcards work with integers and booleans *)
    |  (WildcardPat, _) -> Env.empty_env()
      (* variable patterns match with any integer, boolean, and cons types*)
    |  (VarPat(i), j) -> Env.add_binding i j (Env.empty_env())
      (* integer pattern rules apply for nil *)
    |  (NilPat, NilVal) -> Env.empty_env()
      (* cons pattern *)
    |  (ConsPat(a, b), ConsVal(x, y)) -> Env.combine_envs (patMatch a x) (patMatch b y)
    | _ -> raise (MatchFailure)


(* patMatchTest defines a test case for the patMatch function.
   inputs: 
     - nm: a name for the test, for the status report.
     - pat: a mini-OCaml pattern, the first input to patMatch
     - value: a mini-OCaml value, the second input to patMatch
     - expected: the expected result of running patMatch on these inputs.
 *)

let patMatchTest (nm, pat, value, expected) =
  tester ("patMatch:" ^ nm) (fun () -> patMatch pat value) expected

(* Tests for patMatch function. 
      ADD YOUR OWN! 
 *)
let patMatchTests = [
    (* integer literal pattern tests *)
    ("IntPat/1", IntPat 5, IntVal 5,      Value [])
  ; ("IntPat/2", IntPat 5, IntVal 6,      Exception MatchFailure)
  ; ("IntPat/3", IntPat 5, BoolVal false, Exception MatchFailure)
  ; ("IntPat/4", IntPat 5, NilVal,        Exception MatchFailure)
  ; ("IntPat/5", IntPat 5, ConsVal(IntVal(1), NilVal),      Exception MatchFailure)
  ; ("IntPat/6", IntPat 5, ConsVal(BoolVal(true), NilVal),  Exception MatchFailure)

    (* boolean literal pattern tests *)   
  ; ("BoolPat/1", BoolPat true, BoolVal true,  Value [])
  ; ("BoolPat/2", BoolPat true, BoolVal false, Exception MatchFailure)
  ; ("BoolPat/3", BoolPat true, IntVal 0,      Exception MatchFailure)
  ; ("BoolPat/4", BoolPat true, NilVal,           Exception MatchFailure)
  ; ("BoolPat/5", BoolPat true, ConsVal(IntVal(1), NilVal),      Exception MatchFailure)
  ; ("BoolPat/6", BoolPat true, ConsVal(BoolVal(true), NilVal),  Exception MatchFailure)

    (* wildcard pattern *)
  ; ("WildcardPat/1", WildcardPat, IntVal 5,     Value [])
  ; ("WildcardPat/2", WildcardPat, BoolVal true, Value [])

    (* variable pattern *)
  ; ("VarPat/1", VarPat "x", IntVal 5,     Value [("x", IntVal 5)])
  ; ("VarPat/2", VarPat "y", BoolVal true, Value [("y", BoolVal true)])

    (* Nil pattern *)
  ; ("NilPat/1", NilPat, NilVal,       Value [])
  ; ("NilPat/2", NilPat, IntVal 5,     Exception MatchFailure)
  ; ("NilPat/3", NilPat, BoolVal true, Exception MatchFailure)
  ; ("NilPat/4", NilPat, ConsVal(IntVal(1), NilVal),      Exception MatchFailure)
  ; ("NilPat/5", NilPat, ConsVal(BoolVal(true), NilVal),  Exception MatchFailure)

    (* cons pattern *)
  ; ("ConsPat/1", ConsPat(IntPat 5, NilPat), ConsVal(IntVal 5, NilVal), 
     Value [])
  ; ("ConsPat/2", ConsPat(IntPat 5, NilPat), ConsVal(BoolVal true, NilVal), 
     Exception MatchFailure)
  ; ("ConsPat/3", ConsPat(VarPat "hd", VarPat "tl"), ConsVal(IntVal 5, NilVal), 
     Value [("tl", NilVal); ("hd", IntVal 5)])
  ]
;;

(* Run all the tests *)
List.map patMatchTest patMatchTests;;

(* To evaluate a match expression, we need to choose which case to take.
   Here, match cases are represented by a pair of type (mopat * moexpr) --
   a pattern and the expression to be evaluated if the match succeeds.
   Try matching the input value with each pattern in the list. Return
   the environment produced by the first successful match (if any) along
   with the corresponding expression. If there is no successful match,
   raise the MatchFailure exception.
 *)
let rec matchCases (value : movalue) (cases : (mopat * moexpr) list) : moenv * moexpr =
  match cases with
  | [] -> raise (MatchFailure)
  | (i, j) :: t -> (try (patMatch i value, j) with MatchFailure -> matchCases value t)

(* We'll use these cases for our tests.
   To make it easy to identify which case is selected, we make
 *)
let testCases : (mopat * moexpr) list =
  [(IntPat 1, Var "case 1");
   (IntPat 2, Var "case 2");
   (ConsPat (VarPat "head", VarPat "tail"), Var "case 3");
   (BoolPat true, Var "case 4")
  ]

(* matchCasesTest: defines a test for the matchCases function.
   inputs:
     - nm: a name for the test, for the status report.
     - value: a mini-OCaml value, the first input to matchCases
     - expected: the expected result of running (matchCases value testCases).
 *)
let matchCasesTest (nm, value, expected) =
  tester ("matchCases:" ^ nm) (fun () -> matchCases value testCases) expected

(* Tests for matchCases function. 
      ADD YOUR OWN! 
 *)
let matchCasesTests = [
    ("IntVal/1", IntVal 1, Value ([], Var "case 1"))
  ; ("IntVal/2", IntVal 2, Value ([], Var "case 2"))

  ; ("ConsVal", ConsVal(IntVal 1, ConsVal(IntVal 2, NilVal)), 
     Value ([("tail", ConsVal(IntVal 2, NilVal)); ("head", IntVal 1)], Var "case 3"))

  ; ("BoolVal/true",  BoolVal true,  Value ([], Var "case 4"))
  ; ("BoolVal/false", BoolVal false, Exception MatchFailure)
  ]
;;

List.map matchCasesTest matchCasesTests;;

(* "Tying the knot".
   Make a function value recursive by setting its name component.
 *)
let tieTheKnot nm v =
  match v with
  | FunVal(None,pat,def,env) -> FunVal(Some nm,pat,def,env)
  | _                        -> raise (DynamicTypeError "tieTheKnot expected a function")

(* Evaluate an expression in the given environment and return the
   associated value.  Raise a MatchFailure if pattern matching fails.
   Raise a DynamicTypeError if any other kind of error occurs (e.g.,
   trying to add a boolean to an integer) which prevents evaluation
   from continuing.
*)
let rec evalExpr (e : moexpr) (env : moenv) : movalue =
  match e with
    (* an integer constant evaluates to itself *)
  |  IntConst(i) -> IntVal(i)
  |  BoolConst(i) -> BoolVal(i)
  |  Nil -> NilVal
  |  Var(i) -> (try (Env.lookup i env) with Env.NotBound -> raise (DynamicTypeError "dynamic type error"))
    (*BinOp*)
  |  BinOp(e1, op, e2) -> (match ((evalExpr e1 env), op, (evalExpr e2 env)) with
      | (IntVal(x), Plus, IntVal(y)) -> IntVal (x + y)
      | (IntVal(x), Minus, IntVal(y)) -> IntVal (x - y)
      | (IntVal(x), Times, IntVal(y)) -> IntVal (x * y)
      | (IntVal(x), Eq, IntVal(y)) -> BoolVal(x = y)
      | (IntVal(x), Gt, IntVal(y)) -> BoolVal(x > y)
      | (x, Cons, y) -> ConsVal(x, y)
      | _ -> raise (DynamicTypeError "dynamic type error"))
    (*Negate*)
  |  Negate(IntConst(i)) -> IntVal(-i)
  |  Negate(BoolConst(i)) -> BoolVal(not i)
    (*If*)
  |  If(expr1, expr2, expr3) -> (if evalExpr expr1 env = BoolVal(true) then evalExpr expr2 env else evalExpr expr3 env)
    (*Fun*)
  |  Fun(i, j) -> FunVal(None, i, j, env)
    (*FunCall*)
  |  FunCall(i, j) -> (match (evalExpr i env) with
      | FunVal(Some s, pat, expr, e) -> (evalExpr expr (Env.add_binding s (evalExpr i env) (Env.combine_envs e (patMatch pat (evalExpr j env)))))
      | FunVal(None, pat, expr, e) -> (evalExpr expr (Env.combine_envs e (patMatch pat (evalExpr j env))))
      | _ -> raise (DynamicTypeError "dynamic type error"))
    (*Let*)
  |  Let(VarPat(i), IntConst(j), Var(k)) -> IntVal(j)
  |  Let(VarPat(i), BoolConst(j), Var(k)) -> BoolVal(j)
  |  Let(VarPat(i), Nil, Var(k)) -> NilVal
    (*LetRec*)
  |  LetRec(s, i, j) -> (match (evalExpr i env) with
      | FunVal(None, pat, expr, e) -> tieTheKnot s (evalExpr i env)
      | _ -> raise (DynamicTypeError "dynamic type error"))
    (*Match*)
  |  Match(expr, lst) -> (match lst with
      | [] -> raise (MatchFailure)
      | (i, j) :: t -> (try (evalExpr j (Env.combine_envs env (patMatch i (evalExpr expr env)))) with MatchFailure -> evalExpr (Match(expr, t)) env))
  | _ -> raise (DynamicTypeError "dynamic type error")

(* evalExprTest defines a test case for the evalExpr function.
   inputs: 
     - nm: a name for the test, for the status report.
     - expr: a mini-OCaml expression to be evaluated
     - expected: the expected result of running (evalExpr expr [])
                 (either a value or an exception)
 *)
let evalExprTest (nm, expr, expected) = 
  tester ("evalExpr:" ^ nm) (fun () -> evalExpr expr []) expected

(* Tests for evalExpr function. 
      ADD YOUR OWN!
 *)
let evalExprTests = [
    ("IntConst",    IntConst 5,                              Value (IntVal 5))
  ; ("BoolConst",   BoolConst true,                          Value (BoolVal true))
  ; ("Plus",        BinOp(IntConst 1, Plus, IntConst 1),     Value (IntVal 2))
  ; ("BadPlus/1",   BinOp(BoolConst true, Plus, IntConst 1), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadPlus/2",   BinOp(IntConst 1, Plus, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadPlus/3",   BinOp(BoolConst true, Plus, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("Minus",       BinOp(IntConst 5, Minus, IntConst 1),    Value (IntVal 4))
  ; ("BadMinus/1",     BinOp(BoolConst true, Minus, IntConst 1), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadMinus/2",     BinOp(IntConst 1, Minus, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadMinus/3",  BinOp(BoolConst true, Minus, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("Times",       BinOp(IntConst 5, Times, IntConst 1),    Value (IntVal 5))
  ; ("BadTimes/1",     BinOp(BoolConst true, Times, IntConst 1), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadTimes/2",     BinOp(IntConst 1, Times, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadTimes/3",  BinOp(BoolConst true, Times, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("Eq/1",       BinOp(IntConst 5, Eq, IntConst 5),    Value (BoolVal true))
  ; ("Eq/2",       BinOp(IntConst 5, Eq, IntConst 1),    Value (BoolVal false))
  ; ("BadEq/1",     BinOp(BoolConst true, Eq, IntConst 1), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadEq/2",     BinOp(IntConst 1, Eq, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadEq/3",  BinOp(BoolConst true, Eq, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("Gt/1",       BinOp(IntConst 5, Gt, IntConst 5),    Value (BoolVal false))
  ; ("Gt/2",       BinOp(IntConst 5, Gt, IntConst 1),    Value (BoolVal true))
  ; ("BadGt/1",     BinOp(BoolConst true, Gt, IntConst 1), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadGt/2",     BinOp(IntConst 1, Gt, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("BadGt/3",  BinOp(BoolConst true, Eq, BoolConst true), Exception (DynamicTypeError "dynamic type error"))
  ; ("Negate/1",   Negate(IntConst 5), Value (IntVal(-5)))
  ; ("Negate/2",   Negate(BoolConst true), Value (BoolVal(false)))
  ; ("BadNegate",  Negate(Nil), Exception (DynamicTypeError "dynamic type error"))
  ; ("If/1",       If(BoolConst(true), IntConst(5), IntConst(3)), Value(IntVal(5)))
  ; ("If/1",       If(BoolConst(false), IntConst(5), IntConst(3)), Value(IntVal(3)))
  ; ("Let/1",         Let(VarPat "x", IntConst 1, Var "x"),    Value (IntVal 1))
  ; ("Let/2",         Let(VarPat "x", BoolConst true, Var "x"), Value (BoolVal true))
  ; ("BadLet",        Let(VarPat "x", Nil, Var "x"),       Value (NilVal))
  ; ("Fun/1",         FunCall(Fun(VarPat "x", Var "x"), IntConst 5), Value (IntVal 5))
  ; ("Fun/2",         FunCall(Fun(VarPat "y", Var "y"), BoolConst true), Value (BoolVal true))
  ]
;;

List.map evalExprTest evalExprTests;;

(* See test.ml for a nicer way to write more tests! *)
  

