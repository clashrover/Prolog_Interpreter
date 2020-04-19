type token =
  | Bool of (bool)
  | LP
  | RP
  | LS
  | RS
  | IF
  | EOL
  | AND
  | Exit
  | Identifier of (string)
  | Var of (string)

open Parsing;;
let _ = parse_error;;
# 3 "parser.mly"
	open Interpretor;;
# 19 "parser.ml"
let yytransl_const = [|
  258 (* LP *);
  259 (* RP *);
  260 (* LS *);
  261 (* RS *);
  262 (* IF *);
  263 (* EOL *);
  264 (* AND *);
  265 (* Exit *);
    0|]

let yytransl_block = [|
  257 (* Bool *);
  266 (* Identifier *);
  267 (* Var *);
    0|]

let yylhs = "\255\255\
\002\000\002\000\001\000\001\000\004\000\004\000\005\000\006\000\
\007\000\008\000\008\000\003\000\010\000\010\000\010\000\009\000\
\009\000\000\000\000\000"

let yylen = "\002\000\
\002\000\003\000\003\000\001\000\001\000\001\000\001\000\003\000\
\001\000\001\000\003\000\004\000\001\000\001\000\004\000\001\000\
\003\000\002\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\004\000\000\000\018\000\009\000\000\000\
\005\000\006\000\000\000\019\000\000\000\000\000\000\000\000\000\
\001\000\000\000\000\000\013\000\000\000\000\000\003\000\000\000\
\008\000\002\000\000\000\012\000\000\000\000\000\000\000\017\000\
\011\000\015\000"

let yydgoto = "\003\000\
\006\000\012\000\007\000\008\000\009\000\010\000\011\000\025\000\
\021\000\022\000"

let yysindex = "\007\000\
\001\255\009\255\000\000\000\000\013\255\000\000\000\000\014\255\
\000\000\000\000\016\255\000\000\005\255\007\255\001\255\009\255\
\000\000\009\255\019\255\000\000\017\255\018\255\000\000\021\255\
\000\000\000\000\007\255\000\000\007\255\009\255\020\255\000\000\
\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\023\255\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\254\254\000\000\000\000\255\254\000\000\024\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000"

let yygindex = "\000\000\
\009\000\014\000\254\255\000\000\000\000\000\000\000\000\253\255\
\234\255\000\000"

let yytablesize = 32
let yytable = "\013\000\
\014\000\016\000\014\000\016\000\031\000\014\000\032\000\001\000\
\002\000\004\000\005\000\017\000\018\000\024\000\014\000\013\000\
\019\000\020\000\005\000\028\000\015\000\016\000\027\000\023\000\
\034\000\029\000\033\000\024\000\030\000\007\000\010\000\026\000"

let yycheck = "\002\000\
\003\001\003\001\005\001\005\001\027\000\008\001\029\000\001\000\
\002\000\009\001\010\001\007\001\008\001\016\000\002\001\018\000\
\010\001\011\001\010\001\003\001\007\001\006\001\004\001\015\000\
\005\001\008\001\030\000\030\000\008\001\007\001\007\001\018\000"

let yynames_const = "\
  LP\000\
  RP\000\
  LS\000\
  RS\000\
  IF\000\
  EOL\000\
  AND\000\
  Exit\000\
  "

let yynames_block = "\
  Bool\000\
  Identifier\000\
  Var\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'atom) in
    Obj.repr(
# 28 "parser.mly"
                (G([_1]))
# 113 "parser.ml"
               : Interpretor.goal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'atom) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Interpretor.goal) in
    Obj.repr(
# 29 "parser.mly"
                     (let G(k) = _3 in G(_1::k))
# 121 "parser.ml"
               : Interpretor.goal))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'clause) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : Interpretor.program) in
    Obj.repr(
# 32 "parser.mly"
                                (let P(k)=_3 in P(_1::k))
# 129 "parser.ml"
               : Interpretor.program))
; (fun __caml_parser_env ->
    Obj.repr(
# 33 "parser.mly"
                 (P([]))
# 135 "parser.ml"
               : Interpretor.program))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'fact) in
    Obj.repr(
# 38 "parser.mly"
                    (F(_1))
# 142 "parser.ml"
               : 'clause))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'rule) in
    Obj.repr(
# 39 "parser.mly"
                 (R(_1))
# 149 "parser.ml"
               : 'clause))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'head) in
    Obj.repr(
# 43 "parser.mly"
             (H(_1))
# 156 "parser.ml"
               : 'fact))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'head) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'body) in
    Obj.repr(
# 47 "parser.mly"
                    (HB(_1,_3))
# 164 "parser.ml"
               : 'rule))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atom) in
    Obj.repr(
# 51 "parser.mly"
             (AF(_1))
# 171 "parser.ml"
               : 'head))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'atom) in
    Obj.repr(
# 55 "parser.mly"
             (AFlist([_1]))
# 178 "parser.ml"
               : 'body))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'atom) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'body) in
    Obj.repr(
# 56 "parser.mly"
                    (let AFlist(k) = _3 in AFlist(_1::k))
# 186 "parser.ml"
               : 'body))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'termlist) in
    Obj.repr(
# 60 "parser.mly"
                             (A(_1,_3))
# 194 "parser.ml"
               : 'atom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 64 "parser.mly"
            (V(_1))
# 201 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 65 "parser.mly"
                 (Node(_1,[]))
# 208 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'termlist) in
    Obj.repr(
# 66 "parser.mly"
                             (Node(_1,_3))
# 216 "parser.ml"
               : 'term))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'term) in
    Obj.repr(
# 69 "parser.mly"
              ([_1])
# 223 "parser.ml"
               : 'termlist))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'term) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'termlist) in
    Obj.repr(
# 70 "parser.mly"
                       (_1::_3)
# 231 "parser.ml"
               : 'termlist))
(* Entry line *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
(* Entry target *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let line (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Interpretor.program)
let target (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 2 lexfun lexbuf : Interpretor.goal)
