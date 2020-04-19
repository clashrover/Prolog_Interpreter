/*Declaring tokens*/
%{
	open Interpretor;;
%}
%token  <bool> Bool
%token  LP
%token  RP
%token  LS
%token  RS
%token  IF
%token  EOL
%token  AND		
%token Exit					  
%token <string>  Identifier
%token <string>  Var


%start line
%type  <Interpretor.program> line 
%start target
%type  <Interpretor.goal> target

%%
/* http://www.dai.ed.ac.uk/groups/ssp/bookpages/quickprolog/node5.html */
/* These rules were created using the link above and specifications given */

target:
	| atom EOL					{G([$1])}
	| atom AND target			{let G(k) = $3 in G($1::k)}

line:
    | clause EOL line          	{let P(k)=$3 in P($1::k)}
    | Exit 						{P([])}				
;


clause:        
    | fact      				{F($1)}
    | rule	 					{R($1)}
;

fact:
	| head						{H($1)}
;

rule:
	| head IF body 				{HB($1,$3)}
;

head:
	| atom						{AF($1)}
;

body:
	| atom						{AFlist([$1])}
	| atom AND body				{let AFlist(k) = $3 in AFlist($1::k)}
;

atom:
	| Identifier LP termlist RP	{A($1,$3)}		 /* for k arity atom k>=0 */
;

term:
	| Var						{V($1)}
	| Identifier				{Node($1,[])}
	| Identifier LS termlist RS	{Node($1,$3)}
;
termlist:
	| term 						{[$1]}
	| term AND termlist			{$1::$3}

;