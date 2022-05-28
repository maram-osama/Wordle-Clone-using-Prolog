main:-
			write('Welcome to Pro-Wordle!'),nl,
			write('----------------------'),nl, 
			build_kb,
			write('Done building the words database...'),nl,
			play.
		
	build_kb:-
			write('Please enter a word and its category on separate lines:'),nl,
			read(W),
			kb_check(W),
			( W=done ;
			(read(C), assert(word(W,C)),
			build_kb)
			).
	
	kb_check(W):-
			nonvar(W),
			!.
	kb_check(_):-
			write('Please enter a non-variable.'),nl,
			build_kb.
	
			
	play:-
			categories(L),
			write('The available categories are: '),
			write(L), nl,
			write('Choose a category:'), nl,
			read(X),
			choosing_c(X,C),
			write('Choose a length:'),nl,
			read(Y),
			choosing_l(Y,C,Length),
			NT is Length + 1,
			write('Game started. You have '), write(NT), write(' guesses.'),
			nl,
			pick_word(W,Length,C),
			trials(NT,W,NT).
				
	word_check(A,NT,W,RT):-
			word(A,_),
			!,
			trialsH(NT,W,A,RT),
			!.
			
	word_check(A,NT,W,RT):-
			\+word(A,_),
			write('Please enter a valid word'), nl,
			write('Remaining Guesses are '), write(RT), nl,
			trials(NT,W,RT),
			!.
			
	trials(NT,W,RT):-
			RT>0,
			X is NT-1,
			write('Enter a word composed of '),
			write(X),
			write(' letters:'),nl,
			read(A),
			word_check(A,NT,W,RT).
			
	trialsH(_,W,W,RT):-
			!,
			RT>0,
			write('You Won!').
			
	
	trialsH(_,_,_,1):-
			!,
			write('You lost!').
			
	trialsH(NT,W,A,RT):-
			RT>1,
			string_length(W,X),
			string_length(A,X),
			string_chars(A,L1), string_chars(W,L2),
			correct_letters(L1,L2,L3),
			remove_duplicates(L3,CL),
			write('Correct letters are: '), write(CL), nl,
			correct_positions(L1,L2,CP),
			write('Correct letters in correct positions are: '), write(CP),nl,
			RT1 is RT-1,
			write('Remaining Guesses are '), write(RT1), nl,
			trials(NT,W,RT1).
			
	trialsH(NT,W,A,RT):-
			RT>1,
			string_length(W,X),
			\+string_length(A,X),
			write('Word is not composed of '),
			write(X),
			write(' letters. Try again.'), nl,
			write('Remaining Guesses are '), write(RT), nl,
			trials(NT,W,RT).
			
	choosing_c(X,X):-
			is_category(X),
			!.
			
	choosing_c(_,C):-
			write('This category does not exist'), nl,
			write('Choose a category:'), nl,
			read(N),
			choosing_c(N,C).
	
	choosing_l(Y,C,Y):-
			word(W,C),
			string_length(W,Y),
			!.
			
	choosing_l(_,C,L):-
			write('There are no words of this length'), nl,
			write('Choose a length:'), nl,
			read(N),
			choosing_l(N,C,L).
	
			
	is_category(C):-
			word(_,C).
			
	categories(L):-
			setof(C, is_category(C),L).
			
	available_length(L):-
			word(W,_),
			string_length(W,L).
			
	pick_word(W,L,C):-
			word(W,C),
			string_length(W,L).
			
	correct_letters(_,[],[]).
	
	correct_letters(L1,[H|T],[H|L3]):-
			member(H,L1),
			correct_letters(L1,T,L3).
			
	correct_letters(L1,[H|T],CL):-
			\+member(H,L1),
			correct_letters(L1,T,CL).
	
	remove_duplicates([],[]).		
	remove_duplicates([H|T], R):-
			member(H,T),
			!,
			remove_duplicates(T,R).
			
	remove_duplicates([H|T], [H|R]):-
			\+member(H,T),
			remove_duplicates(T,R).
		
	correct_positions(L1,L2,PL):-
			correct_positionsH(L1,L2,PL).
	
	correct_positionsH([],_,[]).
	
	correct_positionsH([H|T1],[H|T2],[H|T3]):-
			correct_positionsH(T1,T2,T3).
	
	correct_positionsH([H1|T1],[H2|T2],L):-
			H1\=H2,
			correct_positionsH(T1,T2,L).
			


