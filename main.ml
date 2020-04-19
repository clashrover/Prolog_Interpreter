open Interpretor;;

let main () = begin
  try
      let filename = Sys.argv.(1) in
      let file_handle = open_in filename in
      let lexbuf = Lexing.from_channel file_handle in
        let program = Parser.line Lexer.token lexbuf in
        print_prog program;
        flush stdout;
      let lexbuf = Lexing.from_channel stdin in
      while true do
        print_string "| ?- ";
        flush stdout;
        let goals = Parser.target Lexer.token lexbuf in
       	(* let g1 = replace_rules goals program in *)
       	(* print_goals g1; *)
        (* print_string "printing atoms:\n"; *)
        (* print_goals goals; *)
        resolve goals program [] true
        (* print_final_ans f_ans;  *)
      done
  with 
  Lexer.Eof -> exit 0

end;;

main();;