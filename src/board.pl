/* Define start letter code of the board */
start_letter(65).
start_number(49).
max_board_size(9).

/* Get size of the board */
%board_size(+Board, -N)
board_size(Board, N) :-
    nth0(0, Board, Row),
    length(Board, N),
    length(Row, N).

/* Predicate to set the element at position [X, Y] on the board */
%board_set_element(+Board, +Position, +Element, -NewBoard)
board_set_element(Board, [X, Y], Element, NewBoard) :-
    nth0(Y, Board, Row),
    replace_element(Row, X, Element, NewRow),
    replace_element(Board, Y, NewRow, NewBoard).

/* Predicate to get the element at position [X, Y] on the board */
%board_get_element(+Board, +Position, -Element)
board_get_element(Board, [X, Y], Element) :-
    nth0(Y, Board, Row),
    nth0(X, Row, Element).

/* Predicate to get the adjacent pieces of a position */
%board_get_adjacent(+Board, +Position, -ListOfAdjacent)
board_get_adjacent(Board, [X, Y], ListOfAdjacent) :-
    board_size(Board, N),
    get_adjacent_positions(N, [X, Y], ListOfAdjacentPositions),
    board_get_elements(Board, ListOfAdjacentPositions, ListOfAdjacent).

/* Predicate to get elements from positions on the board */
%board_get_elements(+Board, +ListOfPositions, -ListOfElements)
board_get_elements(_, [], []).
board_get_elements(Board, [[X1, Y1] | Rest], [[Element, [X1, Y1]] | RestElements]) :-
    board_get_element(Board, [X1, Y1], Element),
    board_get_elements(Board, Rest, RestElements).


/* Predicate to initialize a board of size N */
%initialize_board(+N, -Board)
initialize_board(N, Board) :-
    max_board_size(MaxN),
    N =< MaxN, N > 0,
    create_list_of_rows(N, N, Board).

/* Predicate to create a list of N rows, each containing N spaces */
%create_list_of_rows(+N, +M, -Board)
create_list_of_rows(0, _, []).
create_list_of_rows(N, M, [Row | Rest]) :-
    N > 0,
    create_row(M, Row),
    N1 is N - 1,
    create_list_of_rows(N1, M, Rest).

/* Predicate to create a list of N spaces */
%create_row(+N, -Row)
create_row(0, []).
create_row(N, [' ' | Rest]) :-
    N > 0,
    N1 is N - 1,
    create_row(N1, Rest).

/* Predicate to display the board in a friendly way */
%display_board(+Board)
% display_board(+Board)
display_board(Board) :-
    nl,
    board_size(Board, N),
    write('  '),
    start_letter(StartLetterCode),
    display_letters(1,N, StartLetterCode),
    display_rows(Board, N),
    nl.

/* Predicate to display the rows of the board */
%display_rows(+Board, +N)
display_rows(Board, N) :-
    start_number(StartNumberCode),
    display_rows_helper(StartNumberCode, Board, N).

%display_rows_helper(+NumberCode, +ListOfRows, +N)
display_rows_helper(_, [], N) :-
    display_horizontal_line(N).

display_rows_helper(NumberCode, [Row | Rest], N) :-
    display_horizontal_line(N),
    put_code(NumberCode),
    display_row(Row, N),
    NewNumberCode is NumberCode + 1,
    display_rows_helper(NewNumberCode, Rest, N).

/* Predicate to display a single row */
%display_row(+Row, +N)
display_row([], _) :-
    write(' |'), nl.

display_row([Cell | Rest], N) :-
    write(' | '),
    write(Cell),
    display_row(Rest, N).

/* Predicate to display a horizontal line */
%display_horizontal_line(+N)
display_horizontal_line(N) :-
    write('  '),
    display_h_line(N),
    write('*'), nl.

/* Predicate to display a horizontal line */
%display_h_line(+N)
display_h_line(0).
display_h_line(N) :-
    N > 0,
    write('*---'),
    N1 is N - 1,
    display_h_line(N1).

/* Display header of the board with letters */
%display_letters(+N0, +N, +StartLetterCode)
display_letters(N, N, LetterCode) :-
    write('  '),
    put_code(LetterCode),
    nl.

display_letters(N0, N, LetterCode) :-
    N0 < N,
    write('  '),
    put_code(LetterCode),
    write(' '),
    N1 is N0 + 1,
    NewLetterCode is LetterCode + 1,
    display_letters(N1, N, NewLetterCode).

/* test to print the board with size N */
%test_board(+N)
test_board(N) :-
    initialize_board(N, Board),
    write('Board: '), write(Board), nl,
    display_board(Board).
