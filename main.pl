:- use_module(library(clpfd)).
:- use_module(library(lists)).

/*
Restrictions:
    * Red -> 1 Yellow.
	* Each way of yellow -> Yellow-Green-Blue-Red.
	
Cube faces:
	   [3]
	[5][1][2][6]
	   [4]
*/



%cube[Face1, Face2, Face3, Face4, Face5, Face6].

emptyTile([Cabeca|Cauda]):-
	Cabeca is Empty,
	emptyTitle(Cauda).
/*
createCube(Size):-
	length(Face1,6),
	length(Face2,6),
	length(Face3,6),
	length(Face4,6),
	length(Face5,6),
	length(Face6,6),
	emptyTile(Face1),
	emptyTile(Face2),
	emptyTile(Face3),
	emptyTile(Face4),
	emptyTile(Face5),
	emptyTile(Face6).*/
	
	/*FaceA = [TileA1, TileA2, TileA3, TileA4, TileA5, TileA6, TileA7, TileA8, TileA9],
	FaceB = [TileB1, TileB2, TileB3, TileB4, TileB5, TileB6, TileB7, TileB8, TileB9],
	FaceC = [TileC1, TileC2, TileC3, TileC4, TileC5, TileC6, TileC7, TileC8, TileC9],
	FaceD = [TileD1, TileD2, TileD3, TileD4, TileD5, TileD6, TileD7, TileD8, TileD9],
	FaceE = [TileE1, TileE2, TileE3, TileE4, TileE5, TileE6, TileE7, TileE8, TileE9],
	FaceF = [TileF1, TileF2, TileF3, TileF4, TileF5, TileF6, TileF7, TileF8, TileF9],*/	
	
	
createCube(Cube, CubeSize):-
	%Creates cube
	Cube = [Face1, Face2, Face3, Face4, Face5, Face6],
	NumberTiles is CubeSize * CubeSize,
	length(Face1, NumberTiles),
	length(Face2, NumberTiles),
	length(Face3, NumberTiles),
	length(Face4, NumberTiles),
	length(Face5, NumberTiles),
	length(Face6, NumberTiles),
	buildCube(Cube, CubeSize, NumberTiles, 1),
	constrain(Cube, Cube, CubeSize),
	
	flatten(Cube, Result),
	labeling([], Result),
	write(Cube).
	
element2(Position, Face, [FaceNum, [X, Y], Color]):-
	element(Position, Face, Tile),
	%length(Tile, 3),
	element(1, Tile, FaceNum),
	
	element(2, Tile, Coordinates),
	element(1, Coordinates, X),
	element(2, Coordinates, Y),
	
	element(3, Tile, Color).
	

%Face by face, builds the cube
%Face = Actual face, Rest = Rest of the faces, CubeSize = Cube measure, NumberTiles = (Cube measure) ^2, Iterator = Face number
buildCube(Cube, _, _, 7).
buildCube([Face | Rest], CubeSize, NumberTiles, Iterator):-
	Iteratorplus is Iterator + 1,
	buildFace(Face, Iterator, 0, CubeSize, NumberTiles),
	buildCube(Rest, CubeSize, NumberTiles, Iteratorplus).
	
%Face is filled from top to bottom, left to right
% Face = [Tile | Rest], FaceNum = 1..6, CubeSize = Cube measure, NumberTiles = (Cube measure) ^2, Iterator = Tile Number
buildFace(_, _, NumberTiles, _, NumberTiles).
buildFace([Tile | Rest], FaceNum, CubeSize, NumberTiles, Iterator):-
	X is (Iterator mod CubeSize) + 1,
	Y is floor(Iterator / CubeSize) + 1,
	append([FaceNum], [X, Y], TileTemp),
	append(TileTemp, [Color], Tile),
	domain([Color], 1, 4),
	Iteratorplus is Iterator + 1,
	buildFace(Rest, FaceNum, CubeSize, NumberTiles, Iteratorplus).

%-------------------------------  CONSTRAINS  --------------------------------
%Apply constrains to the cube
constrain([], _, _).
constrain([Face | Rest], Cube, CubeSize):-
	constrainFace([Face | Rest], Cube, CubeSize),
	constrain(Rest, Cube, CubeSize).
	
%Apply constrains to a face
constrainFace([], _, _).
constrainFace([[FaceNum, [X, Y], Color] | Rest], Cube, CubeSize):-
	obtainNextTo([FaceNum, [X, Y], Color], List, Cube, CubeSize),
	%Pick each adjacent tile color from the list
	/*element(1, List, [_, [_, _], Color1]),
	element(2, List, [_, [_, _], Color2]),
	element(3, List, [_, [_, _], Color3]),
	element(4, List, [_, [_, _], Color4]),*/
	
	%DUVIDA Ele vai perceber que dos valores das Color1,2,3 e 4, so um deles é que pode ter a Restricted Color?
	%Restrict that next color appears 1 time in List, and the other is free
	%ColorList = [Color1, Color2, Color3, Color4],
	RestrictedColor is (Color mod 4) + 2, %Color + 1, and if is 4, then RestrictedColor is 1
	OtherColor1 is (Color mod 4) + 3,
	OtherColor2 is (Color mod 4),
	OtherColor3 is (Color mod 4) + 1,
	global_cardinality(List, [RestrictedColor-1, OtherColor1-_, OtherColor2-_, OtherColor3-_]),
	
	%Recursive Step
	constrainFace(Rest, Cube, CubeSize).

%End of face
constrain2(_, 7, [_, _], _):-
	write('Finished Constraint'), nl.
constrain2(Cube, FaceNum, [CubeSize, CubeSize], CubeSize):-
	write('Constrain Face '), write(FaceNum), write(' ['), write(CubeSize), write(','),
	write(CubeSize), write('] '), nl,
	%Obtain actual tile
	TilesPerFace is CubeSize * CubeSize,
	ActualTileIndex is ((FaceNum - 1) * TilesPerFace) + ((CubeSize - 1) * CubeSize) + CubeSize,
	element(ActualTileIndex, Cube, ActualTileColor),
	
	%Obtain adjacent tiles
	obtainNextTo([FaceNum, [CubeSize, CubeSize], ActualTileColor], List, Cube, CubeSize),
	
	%Restrict that next color appears 1 time in List, and the other is free
	count(1, List, #=, AdjacentRed),
	count(2, List, #=, AdjacentYellow),
	count(3, List, #=, AdjacentGreen),
	count(4, List, #=, AdjacentBlue),
	ActualTileColor #= 1 #=> AdjacentRed #= 1,
	ActualTileColor #= 2 #=> AdjacentYellow #= 1,
	ActualTileColor #= 3 #=> AdjacentGreen #= 1,
	ActualTileColor #= 4 #=> AdjacentBlue #= 1,
	
	%Next Tile
	Faceplus is FaceNum + 1,
	constrain2(Cube, Faceplus, [1, 1], CubeSize).
%End of line
constrain2(Cube, FaceNum, [CubeSize, Y], CubeSize):-
	write('Constrain Face '), write(FaceNum), write(' ['), write(CubeSize), write(','),
	write(Y), write('] '), nl,
	%Obtain actual tile
	TilesPerFace is CubeSize * CubeSize,
	ActualTileIndex is ((FaceNum - 1) * TilesPerFace) + ((Y - 1) * CubeSize) + CubeSize,
	element(ActualTileIndex, Cube, ActualTileColor),
	
	%Obtain adjacent tiles
	obtainNextTo([FaceNum, [CubeSize, Y], ActualTileColor], List, Cube, CubeSize),
	
	%Restrict that next color appears 1 time in List, and the other is free
	count(1, List, #=, AdjacentRed),
	count(2, List, #=, AdjacentYellow),
	count(3, List, #=, AdjacentGreen),
	count(4, List, #=, AdjacentBlue),
	ActualTileColor #= 1 #=> AdjacentRed #= 1,
	ActualTileColor #= 2 #=> AdjacentYellow #= 1,
	ActualTileColor #= 3 #=> AdjacentGreen #= 1,
	ActualTileColor #= 4 #=> AdjacentBlue #= 1,
	
	%Next Tile
	Yplus is Y + 1,
	constrain2(Cube, FaceNum, [1, Yplus], CubeSize).
%General case
constrain2(Cube, FaceNum, [X, Y], CubeSize):-
	write('Constrain Face '), write(FaceNum), write(' ['), write(X), write(','),
	write(Y), write('] '), nl,
	%Obtain actual tile
	TilesPerFace is CubeSize * CubeSize,
	ActualTileIndex is ((FaceNum - 1) * TilesPerFace) + ((Y - 1) * CubeSize) + X,
	element(ActualTileIndex, Cube, ActualTileColor),
	
	%Obtain adjacent tiles
	obtainNextTo([FaceNum, [X, Y], ActualTileColor], List, Cube, CubeSize),
	
	%Restrict that next color appears 1 time in List, and the other is free
	/*
	RestrictedColor #= (ActualTileColor mod 4) + 2, %Color + 1, and if is 4, then RestrictedColor is 1
	OtherColor1 #= (ActualTileColor mod 4) + 3,
	OtherColor2 #= (ActualTileColor mod 4),
	OtherColor3 #= (ActualTileColor mod 4) + 1,
	global_cardinality(List, [RestrictedColor-1, OtherColor1-_, OtherColor2-_, OtherColor3-_]),
	*/
	
	count(1, List, #=, AdjacentRed),
	count(2, List, #=, AdjacentYellow),
	count(3, List, #=, AdjacentGreen),
	count(4, List, #=, AdjacentBlue),
	ActualTileColor #= 1 #=> AdjacentRed #= 1,
	ActualTileColor #= 2 #=> AdjacentYellow #= 1,
	ActualTileColor #= 3 #=> AdjacentGreen #= 1,
	ActualTileColor #= 4 #=> AdjacentBlue #= 1,
	
	%Next Tile
	Xplus is X + 1,
	constrain2(Cube, FaceNum, [Xplus, Y], CubeSize).
	
%colorConstrict([_Face, [X1, Y1], Color1], [_Face, [X2, Y2], Color2], _CubeSize):-



%---------------------------- FACE ADJACENCE DEFINITION -------------------------
	
%For now only works with 3 x 3
%TODO change the 1st number in element to a variable

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
	
%Notes: Check global_cardinality
%		Color + 1 mod 4 to obtain the next colors
/*generateSolution(Size):-
	createCube(Size).*/

%test(FaceNum, X, Y, List, CubeSize):-
test(Cube, CubeSize):-
	%NumberTiles is CubeSize * CubeSize,
	buildCube3(Cube, 1, 1, 1, CubeSize),
	write('=========='),nl,
	write('Finished Building Cube'), nl,
	write('=========='),nl,
	domain(Cube, 1, 4),
	%element(48, Cube, TestUpTile),
	%TestUpTile #= 1,
	%obtainNextTo3([FaceNum, [X, Y], _], List, Cube, CubeSize),
	constrain2(Cube, 1, [1, 1], CubeSize),
	write('=========='),nl,
	write('Finished Constrain Cube'), nl,
	write('=========='),nl,
	%global_cardinality(List, [1-2, 2-1, 3-1, 4-_]),
	labeling([], Cube),
	write('=========='),nl,
	write('Finished Labeling Cube'), nl,
	write('=========='),nl,
	writeCube(Cube, CubeSize).
	
	
buildCube2(Cube, _, _, 7).
buildCube2([Face | Rest], CubeSize, TotalTiles, Iterator):-
	Iteratorplus is Iterator + 1,
	buildFace2(Face, Iterator, 0, CubeSize, TotalTiles),
	buildCube2(Rest, CubeSize, TotalTiles, Iteratorplus).
	
buildFace2(_, _, TotalTiles, _, TotalTiles):- nl.
buildFace2([Tile | Rest], 6, 3, CubeSize, TotalTiles):- %Just for testing. Color #= 1 not being applied in the end
	X is (3 mod CubeSize) + 1,
	Y is floor(3 / CubeSize) + 1,
	append([6], [X, Y], TileTemp),
	append(TileTemp, [Color], Tile),
	domain([Color], 1, 4),
	Color #= 1,
	Iteratorplus is 3 + 1,
	buildFace2(Rest, FaceNum, Iteratorplus, CubeSize, TotalTiles).
buildFace2([Tile | Rest], FaceNum, Iterator, CubeSize, TotalTiles):-
	X is (Iterator mod CubeSize) + 1,
	Y is floor(Iterator / CubeSize) + 1,
	append([FaceNum], [X, Y], TileTemp),
	append(TileTemp, [Color], Tile),
	domain([Color], 1, 4),
	Iteratorplus is Iterator + 1,
	buildFace2(Rest, FaceNum, Iteratorplus, CubeSize, TotalTiles).
	
%buildCube3 - Builds a flat cube
buildCube3(Cube, 6, 3, 1, CubeSize):- %Next face
	append([Color],TileTemp, Cube),
	%Color #= 1,
	buildCube3(TileTemp, 6, 1, 2, CubeSize).
buildCube3(Cube, 6, CubeSize, CubeSize, CubeSize):-
	append([Color], [], Cube).
buildCube3(Cube, FaceNum, CubeSize, CubeSize, CubeSize):- %Next face
	append([Color],TileTemp, Cube),
	Faceplus is FaceNum + 1,
	buildCube3(TileTemp, Faceplus, 1, 1, CubeSize).
buildCube3(Cube, FaceNum, CubeSize, Y, CubeSize):- %Next Line
	append([Color],TileTemp, Cube),
	Yplus is Y + 1,
	buildCube3(TileTemp, FaceNum, 1, Yplus, CubeSize).
buildCube3(Cube, FaceNum, X, Y, CubeSize):- %Next tile in line
	append([Color],TileTemp, Cube),
	Xplus is X + 1,
	buildCube3(TileTemp, FaceNum, Xplus, Y, CubeSize).



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
	
	
%Up Left Corner
obtainNextTo2([3, [1,1], _Color], List, Cube, CubeSize):-
	nth1(6, Cube, Face6),
	UpElemNum = CubeSize,
	nth1(5, Cube, Face5),
	LeftElemNum = 1,
	nth1(3, Cube, Face3),
	RightElemNum = 2,
	DownElemNum is CubeSize + 1,
	nth1(UpElemNum, Face6, UpTile),
	nth1(RightElemNum, Face3, RightTile),
	nth1(DownElemNum, Face3, DownTile),
	nth1(LeftElemNum, Face5, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%Up Left Corner
obtainNextTo3([3, [1,1], _Color], List, Cube, CubeSize):-
	TilesPerFace is CubeSize * CubeSize,
	Face6 is TilesPerFace * 5, %1 before First Element of Face 6
	UpElemNum is Face6 + CubeSize,
	Face5 is TilesPerFace * 4,
	LeftElemNum is Face5 + 4,
	Face3 is TilesPerFace  * 2,
	RightElemNum is Face3 + 2,
	DownElemNum is Face3 + (CubeSize + 1),
	/*
	A is UpElemNum - 3,
	B is UpElemNum - 2,
	C is UpElemNum - 1,
	nth1(A, Cube, Oi),
	nth1(B, Cube, Oi2),
	nth1(C, Cube, Oi3),
	nth1(UpElemNum, Cube, Oi4),
	write(Oi),
	write(Oi2),
	write(Oi3),
	write(Oi4),
	*/
	element(UpElemNum, Cube, UpNext),
	element(RightElemNum, Cube, RightNext),
	element(DownElemNum, Cube, DownNext),
	element(LeftElemNum, Cube, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
flatten2([], []) :- !.
flatten2([L|Ls], FlatL) :-
    !,
    flatten2(L, NewL),
    flatten2(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten2(L, [L]).