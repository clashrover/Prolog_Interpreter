{
  open Parser
  exception Eof
  exception InvalidToken
}


rule token = parse
    | [' ' '\t']          { token lexbuf }                                                                          (* again call lexbuf *)
    | ['\n' ]             { token lexbuf }
    | ['a'-'z'] ['a'-'z' 'A'-'Z' '0'-'9']* as x    { Identifier(x) }
    | ['A'-'Z'] ['a'-'z' 'A'-'Z' '0'-'9']* as y    { Var(y) } 
    | '('                 { LP }                                
    | ')'                 { RP } 
    | '['                 { LS }                                
    | ']'                 { RS }                
    | ','                 { AND}      
    | '.'                 { EOL }
    | 'T'                 { Bool(true) }
    | 'F'                 { Bool(false) }
    | ":-"                { IF }
    | eof                 { Exit }
    | _                   { raise InvalidToken }
