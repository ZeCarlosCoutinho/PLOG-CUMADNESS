/*
faces
	3
5	1	2	6
	4
*/	
:- include('logicoperators.pl').	
abs(A, Result):-
	A < 0,
	Result is -1 * A .
abs(A, Result):-
	A >= 0,
	Result = A .
	
pegIsNextTo([_Face, [X1, Y1]], [_Face, [X2, Y2]], _CubeSize):-
	DiffX is X1 - X2,
	DiffY is Y1 - Y2,
	abs(DiffX, Xf),
	abs(DiffY, Yf),
	xor(Xf, Yf).
pegIsNextTo([1, [Face1x, Face1y]], [2, [Face2x, Face2y]], CubeSize):-
	Face1x = CubeSize,
	Face2x = 1,
	Face1y = Face2y .
pegIsNextTo([2, [Face2x, Face2y]], [1, [Face1x, Face1y]], CubeSize):-
	pegIsNextTo([1, [Face1x, Face1y]], [2, [Face2x, Face2y]], CubeSize).
pegIsNextTo([1, [Face1x, Face1y]], [3, [Face2x, Face2y]], CubeSize):-
	Face1y = 1,
	Face2y = CubeSize,
	Face1x = Face2x .
pegIsNextTo([3, [Face2x, Face2y]], [1, [Face1x, Face1y]], CubeSize):-
	pegIsNextTo([1, [Face1x, Face1y]], [3, [Face2x, Face2y]], CubeSize).
pegIsNextTo([1, [Face1x, Face1y]], [4, [Face2x, Face2y]], CubeSize):-
	Face1y = CubeSize,
	Face2y = 1,
	Face1x = Face2x .
pegIsNextTo([4, [Face2x, Face2y]], [1, [Face1x, Face1y]], CubeSize):-
	pegIsNextTo([1, [Face1x, Face1y]], [4, [Face2x, Face2y]], CubeSize).
pegIsNextTo([1, [Face1x, Face1y]], [5, [Face2x, Face2y]], CubeSize):-
	Face1x = 1,
	Face2x = CubeSize,
	Face1y = Face2y .
pegIsNextTo([5, [Face2x, Face2y]], [1, [Face1x, Face1y]], CubeSize):-
	pegIsNextTo([1, [Face1x, Face1y]], [5, [Face2x, Face2y]], CubeSize).
pegIsNextTo([2, [Face2x, Face2y]], [3, [Face3x, Face3y]], CubeSize):-
	Face2y = 1,
	Face3x = CubeSize,
	Face2x is CubeSize + 1 - Face3y .
pegIsNextTo([3, [Face3x, Face3y]], [2, [Face2x, Face2y]], CubeSize):-
	pegIsNextTo([2, [Face2x, Face2y]], [3, [Face3x, Face3y]], CubeSize).
pegIsNextTo([2, [Face2x, Face2y]], [4, [Face4x, Face4y]], CubeSize):-
	Face2y = CubeSize,
	Face4x = CubeSize,
	Face2x = Face4y .
pegIsNextTo([4, [Face4x, Face4y]], [2, [Face2x, Face2y]], CubeSize):-
	pegIsNextTo([2, [Face2x, Face2y]], [4, [Face4x, Face4y]], CubeSize).
pegIsNextTo([2, [Face2x, Face2y]], [6, [Face6x, Face6y]], CubeSize):-
	Face2x = CubeSize,
	Face6x = 1,
	Face1y = Face2y .
pegIsNextTo([6, [Face6x, Face6y]], [2, [Face2x, Face2y]], CubeSize):-
	pegIsNextTo([2, [Face2x, Face2y]], [6, [Face6x, Face6y]], CubeSize).
pegIsNextTo([3, [Face3x, Face3y]], [5, [Face5x, Face5y]], CubeSize):-
	Face3x = 1,
	Face5y = 1,
	Face3y = Face5x .
pegIsNextTo([5, [Face5x, Face5y]], [3, [Face3x, Face3y]], CubeSize):-
	pegIsNextTo([3, [Face3x, Face3y]], [5, [Face5x, Face5y]], CubeSize).
pegIsNextTo([3, [Face3x, Face3y]], [6, [Face6x, Face6y]], CubeSize):-
	Face3y = 1,
	Face6y = 1,
	Face3x is CubeSize +1 - Face6x .
pegIsNextTo([6, [Face6x, Face6y]], [3, [Face3x, Face3y]], CubeSize):-
	pegIsNextTo([3, [Face3x, Face3y]], [5, [Face6x, Face6y]], CubeSize).
pegIsNextTo([4, [Face4x, Face4y]], [5, [Face5x, Face5y]], CubeSize):-
	Face4x = 1,
	Face5y = CubeSize,
	Face4y is CubeSize +1 - Face5x .
pegIsNextTo([5, [Face5x, Face5y]], [4, [Face4x, Face4y]], CubeSize):-
	pegIsNextTo([4, [Face4x, Face4y]], [5, [Face5x, Face5y]], CubeSize).
pegIsNextTo([4, [Face4x, Face4y]], [6, [Face6x, Face6y]], CubeSize):-
	Face4y = CubeSize,
	Face6y = CubeSize,
	Face4x is CubeSize +1 - Face6x .
pegIsNextTo([6, [Face6x, Face6y]], [4, [Face4x, Face4y]], CubeSize):-
	pegIsNextTo([4, [Face4x, Face4y]], [6, [Face6x, Face6y]], CubeSize).
pegIsNextTo([5, [Face5x, Face5y]], [6, [Face6x, Face6y]], CubeSize):-
	Face5x = 1,
	Face6x = CubeSize,
	Face6y = Face5y.
pegIsNextTo([6, [Face6x, Face6y]], [5, [Face5x, Face5y]], CubeSize):-
	pegIsNextTo([5, [Face5x, Face5y]], [6, [Face6x, Face6y]], CubeSize).
	
	
testPegIsNextTo:- %Must say yes
	pegIsNextTo([1, [1,1]], [1, [2,1]], 3),
	pegIsNextTo([1, [1,1]], [1, [1,2]], 3),
	pegIsNextTo([1, [2,2]], [1, [3,2]], 3),
	pegIsNextTo([1, [2,1]], [1, [3,1]], 3),
	pegIsNextTo([1, [3,1]], [2, [1,1]], 3),
	pegIsNextTo([1, [2,1]], [3, [2,3]], 3),
	pegIsNextTo([1, [2,3]], [4, [2,1]], 3),
	pegIsNextTo([1, [1,1]], [5, [3,1]], 3),
	pegIsNextTo([2, [1,1]], [1, [3,1]], 3),
	pegIsNextTo([2, [3,1]], [6, [1,1]], 3),
	pegIsNextTo([2, [1,3]], [4, [3,1]], 3),
	pegIsNextTo([2, [1,1]], [3, [3,3]], 3).
	
	