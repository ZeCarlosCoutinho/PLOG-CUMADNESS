:- use_module(library(clpfd)).
:- use_module(library(lists)).

%-------------------------------  CUBE BUILDING  --------------------------------
%Builds a flat cube
%End of Cube
buildCube(Cube, 6, CubeSize, CubeSize, CubeSize):-
	append([Color], [], Cube).
%When the end of Face is reached
buildCube(Cube, FaceNum, CubeSize, CubeSize, CubeSize):-
	append([Color],TileTemp, Cube),
	Faceplus is FaceNum + 1,
	buildCube(TileTemp, Faceplus, 1, 1, CubeSize).
%When the end of Line is reached
buildCube(Cube, FaceNum, CubeSize, Y, CubeSize):-
	append([Color],TileTemp, Cube),
	Yplus is Y + 1,
	buildCube3(TileTemp, FaceNum, 1, Yplus, CubeSize).
%General case
buildCube(Cube, FaceNum, X, Y, CubeSize):-
	append([Color],TileTemp, Cube),
	Xplus is X + 1,
	buildCube(TileTemp, FaceNum, Xplus, Y, CubeSize).
	
%-------------------------------  CONSTRAINS  --------------------------------
	
%The method of going through the cube is the same as when it's created (above)
	
%End of cube
constrain(_, 7, [_, _], _):-
	write('Finished Constraint'), nl.

%Apply constraints when reached the end of the actual Face
constrain(Cube, FaceNum, [CubeSize, CubeSize], CubeSize):-
	%Write on screen
	write('Constrain Face '), write(FaceNum), write(' ['), write(CubeSize), write(','),
	write(CubeSize), write('] '), nl,
	
	%Obtain actual tile
	TilesPerFace is CubeSize * CubeSize,
	ActualTileIndex is ((FaceNum - 1) * TilesPerFace) + ((CubeSize - 1) * CubeSize) + CubeSize,
	element(ActualTileIndex, Cube, ActualTileColor),
	
	%Obtain adjacent tiles
	obtainNextTo([FaceNum, [CubeSize, CubeSize], ActualTileColor], List, Cube, CubeSize),
	
	%Restricts the count of the next color to be equals to 1 on the adjacent tiles
	count(1, List, #=, AdjacentRed),
	count(2, List, #=, AdjacentYellow),
	count(3, List, #=, AdjacentGreen),
	count(4, List, #=, AdjacentBlue),
	ActualTileColor #= 1 #=> AdjacentYellow #= 1,
	ActualTileColor #= 2 #=> AdjacentGreen #= 1,
	ActualTileColor #= 3 #=> AdjacentBlue #= 1,
	ActualTileColor #= 4 #=> AdjacentRed #= 1,
	
	%Next Tile
	Faceplus is FaceNum + 1,
	constrain(Cube, Faceplus, [1, 1], CubeSize).

%End of line
constrain(Cube, FaceNum, [CubeSize, Y], CubeSize):-
	write('Constrain Face '), write(FaceNum), write(' ['), write(CubeSize), write(','),
	write(Y), write('] '), nl,
	%Obtain actual tile
	TilesPerFace is CubeSize * CubeSize,
	ActualTileIndex is ((FaceNum - 1) * TilesPerFace) + ((Y - 1) * CubeSize) + CubeSize,
	element(ActualTileIndex, Cube, ActualTileColor),
	
	%Obtain adjacent tiles
	obtainNextTo([FaceNum, [CubeSize, Y], ActualTileColor], List, Cube, CubeSize),
	
	%Restricts the count of the next color to be equals to 1 on the adjacent tiles
	count(1, List, #=, AdjacentRed),
	count(2, List, #=, AdjacentYellow),
	count(3, List, #=, AdjacentGreen),
	count(4, List, #=, AdjacentBlue),
	ActualTileColor #= 1 #=> AdjacentYellow #= 1,
	ActualTileColor #= 2 #=> AdjacentGreen #= 1,
	ActualTileColor #= 3 #=> AdjacentBlue #= 1,
	ActualTileColor #= 4 #=> AdjacentRed #= 1,
	
	%Next Tile
	Yplus is Y + 1,
	constrain(Cube, FaceNum, [1, Yplus], CubeSize).
	
%General case
constrain(Cube, FaceNum, [X, Y], CubeSize):-
	write('Constrain Face '), write(FaceNum), write(' ['), write(X), write(','),
	write(Y), write('] '), nl,
	%Obtain actual tile
	TilesPerFace is CubeSize * CubeSize,
	ActualTileIndex is ((FaceNum - 1) * TilesPerFace) + ((Y - 1) * CubeSize) + X,
	element(ActualTileIndex, Cube, ActualTileColor),
	
	%Obtain adjacent tiles
	obtainNextTo([FaceNum, [X, Y], ActualTileColor], List, Cube, CubeSize),
	
	%Restricts the count of the next color to be equals to 1 on the adjacent tiles
	count(1, List, #=, AdjacentRed),
	count(2, List, #=, AdjacentYellow),
	count(3, List, #=, AdjacentGreen),
	count(4, List, #=, AdjacentBlue),
	ActualTileColor #= 1 #=> AdjacentYellow #= 1,
	ActualTileColor #= 2 #=> AdjacentGreen #= 1,
	ActualTileColor #= 3 #=> AdjacentBlue #= 1,
	ActualTileColor #= 4 #=> AdjacentRed #= 1,
	
	%Next Tile
	Xplus is X + 1,
	constrain(Cube, FaceNum, [Xplus, Y], CubeSize).



%---------------------------- FACE ADJACENCE DEFINITION -------------------------


%------------------------------------------------------
%-------------------------- Face 1 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([1, [1, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face5 is TilesPerFace * 4,
	Face1 = 0,
	UpElemNum is Face3 + (CubeSize * (CubeSize - 1))+1,
	LeftElemNum is Face5 + CubeSize,
	RightElemNum is Face1 + 2,
	DownElemNum is Face1 + CubeSize + 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([1, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face2 = TilesPerFace,
	Face1 = 0,
	UpElemNum is Face3 + (CubeSize * CubeSize),
	RightElemNum is Face2 + 1,
	DownElemNum is Face1 + (CubeSize * 2),
	LeftElemNum is Face1 + (CubeSize - 1),
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([1, [1, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face4 is TilesPerFace * 3,
	Face1 = 0,
	UpElemNum is Face1 + (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is Face1 + (CubeSize * (CubeSize - 1)) + 2,
	DownElemNum is Face4 + 1,
	LeftElemNum is Face5 + (CubeSize * CubeSize),
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([1, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face1 = 0,
	Face2 = TilesPerFace,
	Face4 is TilesPerFace * 3,
	UpElemNum is Face1 + (CubeSize * (CubeSize - 1)),
	RightElemNum is Face2 + (CubeSize * (CubeSize - 1)) + 1,
	DownElemNum is Face4 + CubeSize,
	LeftElemNum is Face1 + (CubeSize * CubeSize) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([1, [X, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face1 = 0,
	Face3 = TilesPerFace * 2,
	UpElemNum is Face3 + (CubeSize * (CubeSize - 1)) + X,
	RightElemNum is Face1 + X + 1,
	DownElemNum is Face1 + X + CubeSize,
	LeftElemNum is Face1 + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([1, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face1 = 0,
	Face2 = TilesPerFace,
	UpElemNum is Face1 + CubeSize * (Y - 1),
	RightElemNum is Face2 + (CubeSize * (Y - 1)) + 1,
	DownElemNum is Face1 + CubeSize * (Y + 1),
	LeftElemNum is Face1 + (CubeSize * Y) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([1, [X, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face1 = 0,
	Face4 is TilesPerFace * 3,
	UpElemNum is Face1 + (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is Face1 + (CubeSize * (CubeSize - 1)) + X + 1,
	DownElemNum is Face4 + X,
	LeftElemNum is Face1 + (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([1, [1, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face1 = 0,
	Face5 is TilesPerFace * 4,
	UpElemNum is Face1 + (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is Face1 + (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is Face1 + (CubeSize * (Y + 1)) - (CubeSize - 1),
	LeftElemNum is Face5 + CubeSize * Y,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 2 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([2, [1, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face3 is TilesPerFace * 2,
	Face1 = 0,
	UpElemNum is Face3 + (CubeSize * CubeSize),
	RightElemNum is Face2 + 2,
	DownElemNum is Face2 + CubeSize + 1,
	LeftElemNum is Face1 + CubeSize,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([2, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face6 is TilesPerFace * 5,
	Face3 is TilesPerFace * 2,
	UpElemNum is Face3 + CubeSize,
	RightElemNum is Face6 + 1,
	DownElemNum is Face2 + CubeSize * 2,
	LeftElemNum is Face2 + CubeSize - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([2, [1, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face1 = 0,
	Face4 is TilesPerFace * 3,
	UpElemNum is Face2 + (CubeSize * (CubeSize - 1)) - (CubeSize - 1),
	RightElemNum is Face2 + (CubeSize * (CubeSize - 1)) + 2,
	DownElemNum is Face4 + CubeSize,
	LeftElemNum is Face1 + CubeSize * CubeSize,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([2, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face4 is TilesPerFace * 3,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face2 + CubeSize * (CubeSize - 1),
	RightElemNum is Face6 + (CubeSize * (CubeSize - 1)) + 1,
	DownElemNum is Face4 + CubeSize * CubeSize,
	LeftElemNum is Face2 + (CubeSize * CubeSize) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([2, [X, 1], _Color], List, Cube,CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face3 is TilesPerFace * 2,
	UpElemNum is Face3 + (CubeSize * CubeSize) - (CubeSize * (X-1)),
	RightElemNum is Face2 + X + 1,
	DownElemNum is Face2 + CubeSize + X,
	LeftElemNum is Face2 + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([2, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face2 + CubeSize *(Y - 1),
	RightElemNum is Face6 + (CubeSize * (Y - 1)) + 1,
	DownElemNum is Face2 + CubeSize * (Y + 1),
	LeftElemNum is Face2 + (CubeSize * Y) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([2, [X, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face4 is TilesPerFace * 3,
	YDownElem = X,
	UpElemNum is Face2 + (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is Face2 + (CubeSize * (CubeSize - 1)) + X + 1,
	DownElemNum is Face4 + (CubeSize * X),
	LeftElemNum is Face2 + (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([2, [1, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face2 = TilesPerFace,
	Face1 = 0,
	UpElemNum is Face2 + (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is Face2 + (CubeSize * (Y - 1)) + 2,
	DownElemNum is Face2 + (CubeSize * (Y + 1)) - (CubeSize - 1),
	LeftElemNum is Face1 + CubeSize * Y,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 3 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([3, [1,1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face5 is TilesPerFace * 4,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face6 * CubeSize,
	RightElemNum is Face3 + 2,
	DownElemNum is Face3 + CubeSize + 1,
	LeftElemNum is Face5 + 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([3, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face2 = TilesPerFace,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face6 + 1,
	RightElemNum is Face2 + CubeSize,
	DownElemNum is Face3 + CubeSize * 2,
	LeftElemNum is Face3 + CubeSize - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([3, [1, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face1 = 0,
	Face5 is TilesPerFace * 4,
	UpElemNum is Face3 + (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is Face3 + (CubeSize * (CubeSize - 1)) + 2,
	DownElemNum is Face1 + 1,
	LeftElemNum is Face5 + CubeSize,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([3, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face1 = 0,
	Face2 = TilesPerFace,
	UpElemNum is Face3 + CubeSize * (CubeSize - 1),
	RightElemNum is Face2 + 1,
	DownElemNum is Face1 + CubeSize,
	LeftElemNum is Face3 + (CubeSize * CubeSize) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([3, [X, 1], _Color], List, Cube,CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face6 + CubeSize - (X - 1),
	RightElemNum is Face3 + X + 1,
	DownElemNum is Face3 + CubeSize + X,
	LeftElemNum is Face3 + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([3, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face2 = TilesPerFace,
	UpElemNum is Face3 + CubeSize *(Y - 1),
	RightElemNum is Face2 + CubeSize - (Y - 1),
	DownElemNum is Face3 + CubeSize * (Y + 1),
	LeftElemNum is Face3 + (CubeSize * Y) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([3, [X, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face1 = 0,
	UpElemNum is Face3 + (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is Face3 + (CubeSize * (CubeSize - 1)) + X + 1,
	DownElemNum is Face1 + X,
	LeftElemNum is Face3 + (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([3, [1, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face3 is TilesPerFace * 2,
	Face5 is TilesPerFace * 4,
	UpElemNum is Face3 + (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is Face3 + (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is Face3 + (CubeSize * (Y + 1)) - (CubeSize - 1),
	LeftElemNum is Face5 + Y,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 4 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([4, [1,1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face1 = 0,
	Face5 is TilesPerFace * 4,
	UpElemNum is Face1 + (CubeSize * (CubeSize -1)) + 1,
	RightElemNum is Face4 + 2,
	DownElemNum is Face4 + CubeSize + 1,
	LeftElemNum is Face5 + CubeSize * CubeSize,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([4, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face1 = 0,
	Face2 = TilesPerFace,
	UpElemNum is Face1 + CubeSize * CubeSize,
	RightElemNum is Face2 + (CubeSize *(CubeSize - 1)) + 1,
	DownElemNum is Face4 + CubeSize * 2,
	LeftElemNum is Face4 + CubeSize - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([4, [1, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face5 is TilesPerFace * 4,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face4 + (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is Face4 + (CubeSize * (CubeSize - 1)) + 2,
	DownElemNum is Face6 + CubeSize * CubeSize,
	LeftElemNum is Face5 + (CubeSize * (CubeSize - 1)) + 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([4, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face2 = TilesPerFace,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face4 + CubeSize * (CubeSize - 1),
	RightElemNum is Face2 + CubeSize * CubeSize,
	DownElemNum is Face6 + (CubeSize * (CubeSize - 1)) + 1,
	LeftElemNum is Face4 + (CubeSize * CubeSize) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([4, [X, 1], _Color], List, Cube,CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face1 = 0,
	UpElemNum is Face1 + (CubeSize * (CubeSize - 1)) + X,
	RightElemNum is Face4 + X + 1,
	DownElemNum is Face4 + CubeSize + X,
	LeftElemNum is Face4 + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([4, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face2 = TilesPerFace,
	UpElemNum is Face4 + CubeSize * (Y - 1),
	RightElemNum is Face2 + (CubeSize * (CubeSize -1))+ Y,
	DownElemNum is Face4 + CubeSize * (Y + 1),
	LeftElemNum is Face4 + (CubeSize * Y) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([4, [X, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face4 + (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is Face4 + (CubeSize * (CubeSize - 1)) + X + 1,
	DownElemNum is Face6 + (CubeSize * CubeSize) - (X - 1),
	LeftElemNum is Face4 + (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([4, [1, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face4 is TilesPerFace * 3,
	Face5 is TilesPerFace * 4,
	UpElemNum is Face4 + (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is Face4 + (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is Face4 + (CubeSize * (Y + 1)) - (CubeSize - 1),
	LeftElemNum is Face5 + (CubeSize * CubeSize) - (Y -1),
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 5 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([5, [1,1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face3 is TilesPerFace * 2,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face3 + 1,
	LeftElemNum is Face6 + CubeSize,
	RightElemNum is Face5 + 2,
	DownElemNum is Face5 + CubeSize + 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([5, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face1 = 0,
	Face3 is TilesPerFace * 2,
	UpElemNum is Face3 + (CubeSize * (CubeSize - 1)) + 1,
	RightElemNum is Face1 + 1,
	DownElemNum is Face5 + CubeSize * 2,
	LeftElemNum is Face5 + CubeSize - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([5, [1, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face4 is TilesPerFace * 3,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face5 + (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is Face5 + (CubeSize * (CubeSize - 1)) + 2,
	DownElemNum is Face4 + (CubeSize * (CubeSize - 1)) + 1,
	LeftElemNum is Face6 + CubeSize * CubeSize,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([5, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face1 = 0,
	Face4 is TilesPerFace * 3,
	UpElemNum is Face5 + CubeSize * (CubeSize - 1),
	RightElemNum is Face1 + (CubeSize * (CubeSize - 1)) + 1,
	DownElemNum is Face4 + 1,
	LeftElemNum is Face5 + (CubeSize * CubeSize) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([5, [X, 1], _Color], List, Cube,CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face3 is TilesPerFace * 2,
	UpElemNum is Face3 + (CubeSize * (X - 1)) + 1,
	RightElemNum is Face5 + X + 1,
	DownElemNum is Face5 + CubeSize + X,
	LeftElemNum is Face5 + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([5, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face1 = 0,
	UpElemNum is Face5 + CubeSize*(Y - 1),
	RightElemNum is Face1 + (CubeSize * (Y - 1)) + 1,
	DownElemNum is Face5 + CubeSize * (Y + 1),
	LeftElemNum is Face5 + (CubeSize * Y) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([5, [X, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face4 is TilesPerFace * 3,
	UpElemNum is Face5 + (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is Face5 + (CubeSize * (CubeSize - 1)) + X + 1,
	DownElemNum is Face4 + (CubeSize * (CubeSize - X)) + 1,
	LeftElemNum is Face5 + (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([5, [1, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face5 is TilesPerFace * 4,
	Face6 is TilesPerFace * 5,
	UpElemNum is Face5 + (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is Face5 + (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is Face5 + (CubeSize * (Y + 1)) - (CubeSize - 1),
	LeftElemNum is Face6 + CubeSize * Y,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 6 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([6, [1,1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face2 = TilesPerFace,
	Face3 is TilesPerFace * 2,
	UpElemNum is Face3 + CubeSize,
	LeftElemNum is Face2 + CubeSize,
	RightElemNum is Face6 + 2,
	DownElemNum is Face6 + CubeSize + 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([6, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face1 = 0,
	Face3 is TilesPerFace * 2,
	UpElemNum is Face3 + 1,
	RightElemNum is Face1 +  1,
	DownElemNum is Face6 + CubeSize * 2,
	LeftElemNum is Face6 + CubeSize - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([6, [1, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face2 = TilesPerFace,
	Face4 is TilesPerFace * 3,
	UpElemNum is Face6 + (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is Face6 + (CubeSize * (CubeSize - 1)) + 2,
	DownElemNum is Face4 + CubeSize * CubeSize,
	LeftElemNum is Face2 + CubeSize * CubeSize,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([6, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face4 is TilesPerFace * 3,
	Face5 is TilesPerFace * 4,
	UpElemNum is Face6 + CubeSize * (CubeSize - 1),
	RightElemNum is Face5 + (CubeSize * (CubeSize - 1)) + 1,
	DownElemNum is Face4 + (CubeSize * (CubeSize - 1)) + 1,
	LeftElemNum is Face6 + (CubeSize * CubeSize) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([6, [X, 1], _Color], List, Cube,CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face3 is TilesPerFace * 2,
	UpElemNum is Face3 + CubeSize - (X - 1),
	RightElemNum is Face6 + X + 1,
	DownElemNum is Face6 + CubeSize + X,
	LeftElemNum is Face6 + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([6, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face5 is TilesPerFace * 4,
	UpElemNum is Face6 + CubeSize*(Y - 1),
	RightElemNum is Face5 + (CubeSize * (Y - 1)) + 1,
	DownElemNum is Face6 + CubeSize * (Y + 1),
	LeftElemNum is Face6 + (CubeSize * Y) - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([6, [X, CubeSize], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face4 is TilesPerFace * 3,
	UpElemNum is Face6 + (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is Face6 +(CubeSize * (CubeSize - 1)) + X + 1,
	DownElemNum is Face4 + (CubeSize * CubeSize) - (X - 1),
	LeftElemNum is Face6 + (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([6, [1, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5,
	Face2 = TilesPerFace,
	UpElemNum is Face6 + (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is Face6 + (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is Face6 + (CubeSize * (Y + 1)) - (CubeSize - 1),
	LeftElemNum is Face2 + CubeSize * Y,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].

%------------------------------------------------------
%-------------------General Case ----------------------
%------------------------------------------------------
obtainNextTo([FaceNum, [X, Y], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face is TilesPerFace * (FaceNum - 1),
	UpElemNum is Face + (CubeSize * (Y - 2)) + X,
	RightElemNum is Face + (CubeSize * (Y - 1)) + X + 1,
	DownElemNum is Face + (CubeSize * Y) + X,
	LeftElemNum is Face + (CubeSize * (Y - 1)) + X - 1,
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].


%-------------------------------  CUBE DISPLAY  --------------------------------

writeCube(Cube, CubeSize):-
	writeCube(Cube, 1, [1,1], CubeSize).

writeCube(_, 7, [_, _], _).
writeCube(Cube, Face, [CubeSize, CubeSize], CubeSize):-
	TotalTiles is CubeSize * CubeSize,
	Index is TotalTiles * (Face - 1) + (CubeSize * (CubeSize - 1) + CubeSize),
	nth1(Index, Cube, Color),
	write(Color), write(' '),
	nl, nl,
	Faceplus is Face + 1,
	writeCube(Cube, Faceplus, [1, 1], CubeSize).
writeCube(Cube, Face, [CubeSize, Y], CubeSize):-
	TotalTiles is CubeSize * CubeSize,
	Index is TotalTiles * (Face - 1) + (CubeSize * (Y - 1) + CubeSize),
	nth1(Index, Cube, Color),
	write(Color),
	write(' '),
	nl,
	Yplus is Y + 1,
	writeCube(Cube, Face, [1, Yplus], CubeSize).
writeCube(Cube, Face, [X, Y], CubeSize):-
	TotalTiles is CubeSize * CubeSize,
	Index is TotalTiles * (Face - 1) + (CubeSize * (Y - 1) + X),
	nth1(Index, Cube, Color),
	write(Color),
	write(' '),
	Xplus is X + 1,
	writeCube(Cube, Face, [Xplus, Y], CubeSize).


	
%-------------------------------  CU MADNESS --------------------------------

cuMadness(Cube, CubeSize):-
	buildCube(Cube, 1, 1, 1, CubeSize),
	write('=========='),nl,
	write('Finished Building Cube'), nl,
	write('=========='),nl,
	
	domain(Cube, 1, 4),

	constrain(Cube, 1, [1, 1], CubeSize),
	write('=========='),nl,
	write('Finished Constrain Cube'), nl,
	write('=========='),nl,
	
	labeling([], Cube),
	write('=========='),nl,
	write('Finished Labeling Cube'), nl,
	write('=========='),nl,
	
	writeCube(Cube, CubeSize).