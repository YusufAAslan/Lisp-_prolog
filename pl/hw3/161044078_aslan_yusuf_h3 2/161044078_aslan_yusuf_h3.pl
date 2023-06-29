% PART 1

	% when each course will be given.
	when(101,8).
	when(107,10).
	when(211,12).
	when(341,14).
	when(102,16).


	% room information for each course.
	where(101,z23).
	where(107,z10).
	where(211,z06).
	where(341,z07).
	where(102,z07).

	% who is the instructor of every course
	teach(a,101).
	teach(a,107).
	teach(b,211).
	teach(c,341).
	teach(d,102).

	% what  is the capacity of every course
	capacity(101,100).
	capacity(107,100).
	capacity(211,100).
	capacity(341,100).
	capacity(102,100).






		
	% solution of part 1 - conflict
	course_conflict(COURSE_A,COURSE_B):-
		where(COURSE_A,A), where(COURSE_B,B),not(A \= B).

	time_conflict(COURSE_A,COURSE_B):- 
		when(COURSE_A,A),when(COURSE_B,B),not(A \= B).
	
	conflict(COURSE_A,COURSE_B):-
		not(not(not((not(course_conflict(COURSE_A,COURSE_B)), not(time_conflict(COURSE_A,COURSE_B)))))).

% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>




% Knowledge base
	
	flight(istanbul,izmir).
	flight(istanbul,ankara).
	flight(istanbul,rize).



	flight(izmir,ankara).
	flight(izmir,istanbul).
	flight(izmir,antalya).


	flight(antalya,erzincan).
	flight(antalya,diyarbakir).
	flight(antalya,izmir).


	flight(ankara,rize).
	flight(ankara,van).
	flight(ankara,diyarbakir).
	flight(ankara,izmir).
	flight(ankara,istanbul).

	flight(van,gaziantep).
	flight(van,ankara).

	flight(gaziantep,van).

	flight(rize,istanbul).
	flight(rize,ankara).

	flight(diyarbakir,antalya).
	flight(diyarbakir,ankara).

	flight(erzincan,canakkale).
	flight(erzincan,antalya).

	flight(canakkale,erzincan).




% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% cost facts

	

	cost(istanbul,izmir,2).
	cost(istanbul,ankara,1).
	cost(istanbul,rize,4).



	cost(izmir,ankara,6).
	cost(izmir,istanbul,2).
	cost(izmir,antalya,2).


	cost(antalya,erzincan,3).
	cost(antalya,diyarbakir,4).
	cost(antalya,izmir,2).


	cost(ankara,rize,5).
	cost(ankara,van,4).
	cost(ankara,diyarbakir,8).
	cost(ankara,izmir,6).
	cost(ankara,istanbul,1).

	cost(van,gaziantep,3).
	cost(van,ankara,4).

	cost(gaziantep,van,3).

	cost(rize,istanbul,4).
	cost(rize,ankara,5).

	cost(diyarbakir,antalya,4).
	cost(diyarbakir,ankara,8).

	cost(erzincan,canakkale,6).
	cost(erzincan,antalya,3).

	cost(canakkale,erzincan,6).

% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% PART 2
	% rules

	% shows direct flights
	route(X,Y,C) :- flight(X,Y,C).

% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

% PART 2 

	related(X,Y,L) :- cost(X,Y,L).
	related(X,Y,L) :- cost(Y,X,L).

	path(A,B,Path,Len) :-
	       travel(A,B,[A],Q,Len), 
	       reverse(Q,Path).

	travel(A,B,P,[B|P],L) :- 
	       related(A,B,L).
	travel(A,B,Visited,Path,L) :-
	       related(A,C,D),           
	       C \== B,
	       \+member(C,Visited),
	       travel(C,B,[C|Visited],Path,L1),
	       L is D+L1.  

	sroute(A,B,Length) :-
	   setof([P,L],path(A,B,P,L),Set),
	   Set = [_|_], % fail if empty
	   minimal(Set,[Path,Length]).

	minimal([F|R],M) :- min(R,F,M).

	% minimal path
	min([],M,M).
	min([[P,L]|R],[_,M],Min) :- L < M, !, min(R,[P,L],Min). 
	min([_|R],M,Min) :- min(R,M,Min).
% >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

