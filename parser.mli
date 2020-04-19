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

val line :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Interpretor.program
val target :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Interpretor.goal
