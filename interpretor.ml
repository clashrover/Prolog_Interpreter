type variable = string;;
type symbol = string;;
type term = V of variable | Node of symbol*(term list);;
type atom = A of symbol*(term list);;
type body = AFlist of atom list;;
type head = AF of atom;;
type rule = HB of head*body;;
type fact = H of head;;
type clause = F of fact | R of rule;;
type program = P of clause list;;
type goal = G of atom list;;



(* let a:term = Node(I(2),[V("x");Node(I(3),[])]);; *)
open List;;
type pair = symbol*int;;
type signature = pair list;;
type substitution = (variable*term) list;;
type mgu_list = substitution list;;
(* type comp_subs = substitution list;; *)
exception SymbolNotFound;;
exception VariableNotFound;;
exception Not_Unifiable;;
exception Not_defined;;
exception Not_yet;;
exception Not_found;;

(* let s:signature = [("x",2);("y",2);("zz",0)];; *)

let rec print_term (t:term) = 
	match t with
	| V(x) -> print_string "var "; print_string x; print_string " "
	| Node(a,b) -> print_string a; print_string " "; print_termlist(b)

and print_termlist (tl:term list)=
	match tl with
	| [] -> print_string " "
	| x::xs -> print_term x; print_termlist xs;;

let rec print_atom(a:atom) = 
	let A(x,y) = a in
	print_string x; print_string " "; print_termlist y;;

let rec print_head (h:head) = 
	let AF(a) = h in print_atom a;;

let rec print_body (b:body) = 
	let AFlist(k) = b in 
	match k with
	| [] 	-> print_string " "
	| x::xs -> print_atom x; let p = AFlist(xs) in print_body p;;

let rec print_rule (r:rule) =
	let HB(x,y) = r in print_head x; print_string " :- "; print_body y;;

let rec print_fact (f:fact) =
	let H(h) = f in print_head h;;

let rec print_clause (c:clause) =
	match c with
	| F(f) -> print_fact f
	| R(r) -> print_rule r;;

let rec print_prog (p:program) = 
	let P(k) = p in
		match k with 
		| [] 	-> print_string "\n"
		| x::xs -> print_clause x; print_string "\n"; let x1 = P(xs) in print_prog x1 ;;  

let rec print_goals (g:goal) =
	let G(l) = g in
	match l with
	| [] 	-> print_string "goals printed\n"
	| x::xs -> print_atom x; print_string " +++ "; let l1 = G(xs) in print_goals l1;;

(* let sig:signature = [(s,2)] ;; *)
(* -------------------------------------------------------------------------------------------------- *)
(* ---------------------------------Well formed term checking---------------------------------------- *)

let rec check_arity (x:pair): bool =
  let (a,b) = x in
    if b<0 then false
    else true;;

let rec check_dup (p:pair) (s:signature) (occurance:int) : bool =
  if occurance > 1 then false
  else
    match s with
    | []    -> true
    | x::xs -> let (a,b) = x in
                let (c,d) = p in
                  if a=c then
                    check_dup p xs (occurance+1)
                  else
                  check_dup p xs occurance;;

let rec check_sig (s:signature) (temp:signature) : bool = 
  match temp with
  | []    -> true
  | x::xs -> (check_dup x s 0) && (check_arity x) && check_sig s xs;; 


let rec arity (sym:symbol) (s:signature):int =
	match s with
	| [] 	-> raise SymbolNotFound
	| x::xs -> let (a,b) = x in
				if a=sym then b else arity sym xs;; 




let rec wfterm (t:term) (s:signature) : bool = 
  match t with
  | V(v)        -> true
  | Node(x,xs)  ->  if (arity x s)= length xs then wflist xs s
  					else false

and wflist (s:term list) (sign:signature):bool = 
  match s with
  | []  -> true
  | x::xs -> if wfterm x sign then wflist xs sign else false;;


(* -------------------------------------------------------------------------------------------------- *)
(* --------------------------------------Height------------------------------------------------------ *)

let rec ht (t:term): int =
	match t with
	| V(x) 			-> 1
	| Node(x,xs) 	-> let y = htlist xs 0 in y+1

and htlist (l:term list) (ans:int):int =
	match l with
	| [] 	-> ans
	| x::xs -> let h = ht x in
				if h > ans then htlist xs h else htlist xs ans;;


(* -------------------------------------------------------------------------------------------------- *)
(* ----------------------------------------Size------------------------------------------------------ *)

let rec size (t:term) :int =
	match  t with
	| V(x) 		 -> 1		
	| Node(x,xs) -> 1 +  (sizelist xs 0)

and sizelist (l:term list) (ans:int):int =
	match l with
	| [] ->  ans
	| x::xs -> sizelist xs (ans+(size x));; 


(* -------------------------------------------------------------------------------------------------- *)
(* ------------------------------------------Forming Var set----------------------------------------- *)

let rec filter (x:variable) (lp:variable list) : variable list = 
	match lp with
	| [] 	-> []
	| y::ys -> if x = y then filter x ys else (y::filter x ys);;

let rec removeDup (lp:variable list) (lp_temp:variable list): variable list = 
	match lp_temp with
	| [] 	-> lp
	| x::xs -> let lnew = filter x lp in 
				removeDup (x::lnew) xs;; 

let rec vars (e:term) (l:variable list) : variable list = 
	match  e with
	| V(x) 			-> let lp = l@[x] in removeDup lp lp
	| Node(x,xs) 	-> let lp = l@(varslist xs) in removeDup lp lp

and varslist (e:term list) : variable list =
	match e with
	 | [] -> []
	 | x::xs -> (vars x []) @ varslist xs;; 


(* -------------------------------------------------------------------------------------------------- *)
(* ---------------------------Apply given substitution on given term--------------------------------- *)


let rec makeSubst (x:variable) (s:substitution) =
	match s with
	| [] 	-> V(x)
	| y::ys -> let (a,b) = y in 
				if a=x then b
				else makeSubst x ys;;

let rec subst (t:term) (s:substitution): term =
	match t with
	| V(x) 			-> makeSubst x s 
	| Node(x,xs) 	-> Node(x,substList xs s)

and substList (l:term list) (s:substitution): term list =
	match l with
	| [] 	-> []
	| x::xs -> (subst x s)::substList xs s;;

(* -------------------------------------------------------------------------------------------------- *)
(* ----------------------------------Composition of two substitutions-------------------------------- *)

let rec applyOnS1 (s1:substitution) (s2:substitution) : substitution =
	match s1 with
	| [] 	-> []
	| x::xs -> let (a,b) = x in
				let t = subst b s2 in
					(a,t) :: (applyOnS1 xs s2);; 

let rec findXinSubs (x:variable) (l:substitution) : bool = 
	match  l with
	| [] -> false
	| y::ys -> let (a,b) = y in 
				if a = x then true else findXinSubs x ys;;

let rec deletefrom (s2:substitution ) (l:substitution):substitution =
	match s2 with
	| [] -> []
	| x::xs -> let (a,b) = x in 
				if findXinSubs a l then deletefrom xs l else x:: deletefrom xs l ;;

let rec deleteident (l:substitution) =
	match l with
	| [] -> []
	| x::xs -> let (a,b) = x in
				match b with
				| V(y) -> if a = y then xs else x:: deleteident xs
				| _ -> x:: deleteident xs;;

let rec composition (s1:substitution) (s2:substitution) : substitution =
	let l = applyOnS1 s1 s2 in
		let lnew =	deletefrom s2 l in
			let lnn = l @ lnew in
			deleteident lnn;;


(* -------------------------------------------------------------------------------------------------- *)
(* ---------------------------Find mgu for two terms which is a substitution------------------------- *)




let rec findXinVars (s:variable list) (x:variable) : bool =
	match s with
	| [] 	-> false
	| y::ys -> if x=y then true else findXinVars ys x;;

let rec checkVarsf (x:variable) (l:term list): bool =
	match l with
	| [] 	-> false
	| y::ys -> let set = vars y [] in
				if findXinVars set x then true else checkVarsf x ys;; 

let rec mgu (t1:term) (t2:term): substitution = 
	match t1 with
	| V(x)			->	(match t2 with
						| V(y)			->	if x = y then [] else [(x,V(y))]
						| Node(y,ys) 	->	if checkVarsf x ys then raise Not_Unifiable else [(x,Node(y,ys))])
	| Node(x,xs) 	->	(match t2 with
						| V(y)			->	if checkVarsf y xs then raise Not_Unifiable else [(y,Node(x,xs))]
						| Node(y,ys) 	->	if x=y && length xs = length ys then mgulist xs ys else raise Not_Unifiable)

and mgulist (l1:term list) (l2:term list): substitution = 
	match l1 with
	| [] 	->	[]
	| x::xs ->	(match l2 with
				| [] 	-> []
				| y::ys -> let s = mgu x y in
							let l1_sub = substList xs s in
								let l2_sub = substList ys s in
									s @ mgulist l1_sub l2_sub) 

(* ------------------------------------------------------------------------------------- *)
(* ------------------------------------------------------------------------------------- *)
(* ------------------------------------------------------------------------------------- *)

let rec print_subs (s:substitution) =
	match s with
	| [] 	-> print_string "\n"
	| x::xs -> let (a,b) = x in print_string a; print_string " -> "; print_term b; print_string "    "; print_subs xs

let rec apply_subs_on_goal (s:substitution) (g:goal): goal = 
	let G(k) = g in
	match k with
	| [] 	-> G([])
	| x::xs -> 	let A(a,b) = x in
					let l = substList b s in
						let ans = A(a,l) in
							let g2 = G(xs) in
								let g3 = apply_subs_on_goal s g2 in
									let G(k1) = g3 in
										let final = G(ans::k1) in
											final;;


let rec print_mgulist (s:mgu_list) =
	match s with
	| [] -> ()(* print_string "mgu list printed\n" *)
	| x::xs -> print_subs x; print_mgulist xs;;

let rec equal_atom (x:atom) (a:atom) =
	let A(a1,b1) = x in
		let A(a2,b2) = a in
			if a1 = a2 then
				try
					if (mgulist b1 b2) = [] then true
					else false
				with Not_Unifiable -> false
		else
			false;;

let rec hasVars (a:atom):bool = 
	let A(a,b) = a in
		let v = varslist b in
			if v = [] then false
			else true;; 

let rec checkTrue (a:atom) (p:program):bool =
	let P(k) = p in
	match k with
	| [] 	-> false
	| x::xs -> 	let p_new = P(xs) in
				match x with
				| F(f) 	-> 	let F(H(AF(x1))) = x in
									equal_atom a x1 || checkTrue a p_new
				| R(r)	-> 	checkTrue a p_new;;

				



let rec equal_atom (x:atom) (a:atom) =
	let A(a1,b1) = x in
		let A(a2,b2) = a in
			if a1 = a2 then
				if (mgulist b1 b2) = [] then true
				else false
		else
			false;;

let rec filter_goal (a:atom) (g:goal): goal =
	match g with
	| G([]) -> G([])
	| G(x::xs) -> if equal_atom x a then G(xs) else G(x::xs);;


let rec fact_solve (a:atom) (f:fact) = 
	let H(h) = f in
		let AF(aa) = h in
			let A(a1,a2) = a in
				let A(b1,b2) = aa in
					(* print_atom a; print_string "  "; print_atom aa; print_newline(); *)
					if a1 = b1 then
						try
							mgulist a2 b2
						with Not_Unifiable -> []
					else
						[];;

(* let rec clause_solve (a:atom) (c:clause)=
	match c with
	| F(f)  ->	fact_solve a f
	| R(r)	-> 	raise Not_yet;; *)

let rec checkfact (a:atom) (p:program) =
	(* let alp = print_string "in cf\n" in *)
	let P(k) = p in
		match k with
		| [] 	-> true
		| x::xs -> let p1 = P(xs) in
					match x with
					| F(f) -> let H(a1) = f in
								let AF(a2) = a1 in
									let A(s1,tl1) = a in
										let A(s2,tl2) = a2 in
											if s1 = s2 then true else checkfact a p1
					| R(r) -> let HB(h,b) = r in
								let AF(a1) = h in
									let A(s1,tl1) = a1 in
										let A(s2,tl2) = a in
											if s1=s2 then false else checkfact a p1;;

(* let rec get_subgoal (a:atom) (p:program):goal =
	let P(k) = p in
	match k with
	| [] 	-> 	raise Not_found
	| x::xs -> 	let p1 = P(xs) in
				match x with
				| F(f) -> get_subgoal a p1
				| R(r) -> let HB(h,b) = r in
								let AF(a1) = h in
										let A(s1,tl1) = a1 in
										let A(s2,tl2) = a in
											if s1 = s2 then
												(* let alp =print_string "here\n" in *)
												let s = mgulist tl1 tl2 in
													(* print_subs s; *)
													(* let alp =print_string "here\n" in *)
													let AFlist(bod) = b in
														let g1 = G(bod) in
															let g2 = apply_subs_on_goal s g1 in
																g2;;
 *)

let rec solve_fact (a:atom) (p:program): mgu_list = 
	let P(k) = p in
	match k with
	| [] 	-> []
	| x::xs -> let p1 = P(xs) in 
				match x with
				| F(f) 	-> let ans = fact_solve a f in 
							if ans = [] then solve_fact a p1
							else ans :: (solve_fact a p1)
				| R(r)	-> solve_fact a p1


and solve_rule (g:goal) (p:program) (ans:mgu_list) (tvalue: bool) (a:atom) (p_comp:program) =
	let P(k) = p in
		match k with
		| [] 	-> ()
		| x::xs -> let p1 = P(xs) in
					match x with
					| F(f) -> solve_rule g p1 ans tvalue a p_comp
					| R(r) -> let HB(h,b) = r in
								let AF(a1) = h in
										let A(s1,tl1) = a1 in
										let A(s2,tl2) = a in
											if s1 = s2 then
												(* let alp =print_string "here\n" in *)
												let s = mgulist tl1 tl2 in
													(* print_subs s; *)
													(* let alp =print_string "here\n" in *)
													let AFlist(bod) = b in
														let g1 = G(bod) in
															let G(k2) = apply_subs_on_goal s g1 in
																(* print_goals (apply_subs_on_goal s g1); *)
																let G(k3) = g in
																	let g_new = G(k2@k3) in
																		(* print_goals g_new; *)
																		resolve g_new p_comp ans tvalue;
																		solve_rule g p1 ans tvalue a p_comp
											else
												solve_rule g p1 ans tvalue a p_comp




and recurse_mgulist (s:mgu_list) (g:goal) (p:program) (ans:mgu_list) (tvalue:bool)= 
	match s with
	| [] 	->	()	
	| x::xs ->	let g1 = apply_subs_on_goal x g in
				(* print_goals g1; *)
				let ans2 = x::ans in
				let tvalue2 = tvalue && true in
				resolve g1 p ans2 tvalue2;
				recurse_mgulist xs g p ans tvalue

and resolve (g:goal) (p:program) (ans:mgu_list) (tvalue: bool) = 
	(* let alp = print_goals g in *)
	let G(k) = g in
	match k with
	| [] 	-> 	if tvalue then let alp = print_mgulist ans in print_string "true\n"
				else ()
	| x::xs -> 	if checkfact x p then
					if hasVars x then
						let s = solve_fact x p in
							let g2 = G(xs) in
								recurse_mgulist s g2 p ans tvalue
					else
						if checkTrue x p then
							let g2 = G(xs) in
								resolve g2 p ans (tvalue && true)
						else
							let g2 = G([]) in
								resolve g2 p [] false
				else
					(* if hasVars x in *)
						let g2 = G(xs) in
							solve_rule g2 p ans tvalue x p
					(* else
						let sg = get_subgoal x p in
							if checkVarsInGoal sg then
								let g2 = G(xs) in
								solve_rule g2 p ans tvalue x p
							else
								if checkTrueList x p then
									let g2 = G(xs) in
										resolve g2 p ans (tvalue && true)
								else
									let g2 = G([]) in
									resolve g2 p [] false *)

;;

(* let rec get_subgoal (a:atom) (p:program):goal =
	let P(k) = p in
	match k with
	| [] 	-> 	G([])
	| x::xs ->	let p1 = P(xs) in
					match x with
					| F(f) 	->	get_subgoal a p1 
					| R(r) 	-> 	let HB(head,body) = r in
									let AF(a2) = head in
										let A(s1,tl1) =a in
											let A(s2,tl2) = a2 in
												if s1 = s2 then
													let s = mgulist tl2 tl1 in
														let AFlist(bod) = body in 
															let g4 = G(bod) in
																let g5 = replace_rules g4 p in
																	apply_subs_on_goal s g5
												else
													get_subgoal a p1 *)

(* and replace_rules (g:goal) (p:program):goal =
	let G(k) = g in
	match k with
	| [] 	-> 	G([])
	| x::xs -> 	let g1 = get_subgoal x p in
					if g1 = G([]) then
						let g2 = G(xs) in
							let G(k2) = replace_rules g2 p in
								let g3 = G(x::k2) in g3
					else
						let g2 = G(xs) in
							let G(k2) = replace_rules g2 p in
								let G(k3) = g1 in
									let g3 = G(k3@k2) in g3;; *)