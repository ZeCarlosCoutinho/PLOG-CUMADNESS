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
	
	
	
%colorConstrict([_Face, [X1, Y1], Color1], [_Face, [X2, Y2], Color2], _CubeSize):-



%---------------------------- FACE ADJACENCE DEFINITION -------------------------
	
%For now only works with 3 x 3
%TODO change the 1st number in element to a variable

%------------------------------------------------------
%-------------------------- Face 1 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([1, [1, 1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3), %Up Tile
	element(7, Face3, UpNext),
	element(1, Cube, Face1), %Right and Down tiles
	element(2, Face1, RightNext),
	element(4, Face1, DownNext),
	element(5, Cube, Face5), %Left Tile
	element(3, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([1, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3), %Up Tile
	element(9, Face3, UpNext),
	element(2, Cube, Face2),%Right Tile
	element(1, Face2, RightNext),
	element(1, Cube, Face1), %Down and Left Tiles
	element(6, Face1, DownNext),
	element(2, Face1, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([1, [1, CubeSize], _Color], List, Cube, CubeSize):-
	element(1, Cube, Face1), %Up and Right tiles
	element(4, Face1, UpNext),
	element(8, Face1, RightNext),
	element(4, Cube, Face4), %Down tile
	element(1, Face4, DownNext),
	element(5, Cube, Face5), %Left tile
	element(9, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([1, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	element(1, Cube, Face1),
	element(6, Face1, UpNext),
	element(8, Face1, LeftNext),
	element(2, Cube, Face2),
	element(7, Face2, RightNext),
	element(4, Cube, Face4),
	element(3, Face4, DownNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([1, [X, 1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3),
	UpElemNum is (CubeSize * (CubeSize - 1)) + X,
	element(UpElemNum, Face3, UpNext),
	element(1, Cube, Face1),
	RightElemNum is X +1,
	DownElemNum is X+CubeSize,
	LeftElemNum is X - 1,
	element(RightElemNum, Face1, RightNext),
	element(DownElemNum, Face1, DownNext),
	element(LeftElemNum, Face1, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([1, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	element(2, Cube, Face2),
	RightElemNum = (CubeSize * (Y - 1)) + 1,
	element(RightElemNum, Face2, RightNext),
	element(1, Cube, Face1),
	UpElemNum is CubeSize * (Y-1),
	DownElemNum is CubeSize * (Y + 1),
	LeftElemNum is (CubeSize * Y) - 1,
	element(UpElemNum, Face1, UpNext),
	element(DownElemNum, Face1, DownNext),
	element(LeftElemNum, Face1, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([1, [X, CubeSize], _Color], List, Cube, CubeSize):-
	element(4, Cube, Face4),
	DownElemNum = X,
	element(DownElemNum, Face4, DownNext),
	element(1, Cube, Face1),
	UpElemNum is (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is (CubeSize * (CubeSize - 1)) + X + 1,
	LeftElemNum is (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Face1, UpNext),
	element(RightElemNum, Face1, RightNext),
	element(LeftElemNum, Face1, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([1, [1, Y], _Color], List, Cube, CubeSize):-
	element(5, Cube, Face5),
	LeftElemNum is CubeSize * Y,
	element(LeftElemNum, Face5, LeftNext),
	element(1, Cube, Face1),
	UpElemNum is (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is (CubeSize * (Y + 1)) - (CubeSize - 1),
	element(UpElemNum, Face1, UpNext),
	element(RightElemNum, Face1, RightNext),
	element(DownElemNum, Face1, DownNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 2 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([2, [1, 1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3),
	UpElemNum is (CubeSize * CubeSize),
	element(2, Cube, Face2),
	RightElemNum = 2,
	DownElemNum is CubeSize + 1,
	element(1, Cube, Face1),
	LeftElemNum is CubeSize,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face2, RightNext),
	element(DownElemNum, Face2, DownNext),
	element(LeftElemNum, Face1, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([2, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3),
	UpElemNum is CubeSize,
	element(6, Cube, Face6),
	RightElemNum = 1,
	element(2, Cube, Face2),
	DownElemNum is CubeSize * 2,
	LeftElemNum is CubeSize - 1,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(DownElemNum, Face2, DownNext),
	element(LeftElemNum, Face2, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([2, [1, CubeSize], _Color], List, Cube, CubeSize):-
	element(2, Cube, Face2),
	UpElemNum is (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is (CubeSize * (CubeSize - 1)) + 2,
	element(4, Cube, Face4),
	DownElemNum = CubeSize,
	element(1, Cube, Face1),
	LeftElemNum is CubeSize * CubeSize,
	element(UpElemNum, Face2, UpNext),
	element(RightElemNum, Face2, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face1, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([2, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	element(2, Cube, Face2),
	UpElemNum is CubeSize * (CubeSize - 1),
	LeftElemNum is (CubeSize * CubeSize) - 1,
	element(6, Cube, Face6),
	RightElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(4, Cube, Face4),
	DownElemNum is CubeSize * CubeSize,
	element(UpElemNum, Face2, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face2, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([2, [X, 1], _Color], List, Cube,CubeSize):-
	element(3, Cube, Face3),
	YFace3 is CubeSize - X,
	element(UpElemNum, Face3, [_, [CubeSize, YFace3], UpNext]), %TODO sera que tem de se fazer outro element depois deste com element(UpElemNum, Face3, UpNext)?
	element(2, Cube, Face2),
	RightElemNum is X + 1,
	DownElemNum is CubeSize + X,
	LeftElemNum is X - 1,
	element(RightElemNum, Face2, RightNext),
	element(DownElemNum, Face2, DownNext),
	element(LeftElemNum, Face2, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([2, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	element(6, Cube, Face6),
	RightElemNum is (CubeSize * Y) + 1,
	element(2, Cube, Face2),
	UpElemNum is CubeSize*(Y - 1),
	DownElemNum is CubeSize * (Y + 1),
	LeftElemNum is (CubeSize * Y) - 1,
	element(UpElemNum, Face2, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(DownElemNum, Face2, DownNext),
	element(LeftElemNum, Face2, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([2, [X, CubeSize], _Color], List, Cube, CubeSize):-
	element(4, Cube, Face4),
	YDownElem = X,
	element(DownElemNum, Face4, [_, [CubeSize, X], DownNext]),
	element(2, Cube, Face2),
	UpElemNum is (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is (CubeSize * (CubeSize - 1)) + X + 1,
	LeftElemNum is (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Face2, UpNext),
	element(RightElemNum, Face2, RightNext),
	element(LeftElemNum, Face2, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([2, [1, Y], _Color], List, Cube, CubeSize):-
	element(1, Cube, Face1),
	LeftElemNum is CubeSize * Y,
	element(LeftElemNum, Face1, LeftNext),
	element(2, Cube, Face2),
	UpElemNum is (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is (CubeSize * (Y + 1)) - (CubeSize - 1),
	element(UpElemNum, Face2, UpNext),
	element(RightElemNum, Face2, RightNext),
	element(DownElemNum, Face2, DownNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 3 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([3, [1,1], _Color], List, Cube, CubeSize):-
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
%Up Right Corner
obtainNextTo([3, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	nth1(6, Cube, Face6),
	UpElemNum = 1,
	nth1(2, Cube, Face2),
	RightElemNum = CubeSize,
	nth1(3, Cube, Face3),
	DownElemNum is CubeSize * 2,
	LeftElemNum is CubeSize - 1,
	nth1(UpElemNum, Face6, UpTile),
	nth1(RightElemNum, Face2, RightTile),
	nth1(DownElemNum, Face3, DownTile),
	nth1(LeftElemNum, Face3, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([3, [1, CubeSize], _Color], List, Cube, CubeSize):-
	nth1(3, Cube, Face3),
	UpElemNum is (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is (CubeSize * (CubeSize - 1)) + 2,
	nth1(1, Cube, Face1),
	DownElemNum = 1,
	nth1(5, Cube, Face5),
	LeftElemNum = CubeSize,
	nth1(UpElemNum, Face3, UpTile),
	nth1(RightElemNum, Face3, RightTile),
	nth1(DownElemNum, Face1, DownTile),
	nth1(LeftElemNum, Face5, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([3, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	nth1(3, Cube, Face3),
	UpElemNum is CubeSize * (CubeSize - 1),
	LeftElemNum is (CubeSize * CubeSize) - 1,
	nth1(2, Cube, Face2),
	RightElemNum = 1,
	nth1(1, Cube, Face1),
	DownElemNum = CubeSize,
	nth1(UpElemNum, Face3, UpTile),
	nth1(RightElemNum, Face2, RightTile),
	nth1(DownElemNum, Face1, DownTile),
	nth1(LeftElemNum, Face3, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([3, [X, 1], _Color], List, Cube,CubeSize):-
	nth1(6, Cube, Face6),
	UpElemNum is CubeSize - (X - 1),
	nth1(3, Cube, Face3),
	RightElemNum is X + 1,
	DownElemNum is CubeSize + X,
	LeftElemNum is X - 1,
	nth1(UpElemNum, Face6, UpTile),
	nth1(RightElemNum, Face3, RightTile),
	nth1(DownElemNum, Face3, DownTile),
	nth1(LeftElemNum, Face3, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([3, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	nth1(2, Cube, Face2),
	RightElemNum is CubeSize - (Y - 1),
	nth1(3, Cube, Face3),
	UpElemNum is CubeSize*(Y - 1),
	DownElemNum is CubeSize * (Y + 1),
	LeftElemNum is (CubeSize * Y) - 1,
	nth1(UpElemNum, Face3, UpTile),
	nth1(RightElemNum, Face2, RightTile),
	nth1(DownElemNum, Face3, DownTile),
	nth1(LeftElemNum, Face3, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([3, [X, CubeSize], _Color], List, Cube, CubeSize):-
	nth1(1, Cube, Face1),
	DownElemNum = X,
	nth1(3, Cube, Face3),
	UpElemNum is (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is (CubeSize * (CubeSize - 1)) + X + 1,
	LeftElemNum is (CubeSize * (CubeSize - 1)) + X - 1,
	nth1(UpElemNum, Face3, UpTile),
	nth1(RightElemNum, Face3, RightTile),
	nth1(DownElemNum, Face1, DownTile),
	nth1(LeftElemNum, Face3, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([3, [1, Y], _Color], List, Cube, CubeSize):-
	nth1(5, Cube, Face5),
	LeftElemNum = Y,
	nth1(3, Cube, Face3),
	UpElemNum is (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is (CubeSize * (Y + 1)) - (CubeSize - 1),
	nth1(UpElemNum, Face3, UpTile),
	nth1(RightElemNum, Face3, RightTile),
	nth1(DownElemNum, Face3, DownTile),
	nth1(LeftElemNum, Face5, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 4 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([4, [1,1], _Color], List, Cube, CubeSize):-
	nth1(1, Cube, Face1),
	UpElemNum is (CubeSize * (CubeSize -1)) + 1,
	nth1(5, Cube, Face5),
	LeftElemNum is CubeSize * CubeSize,
	nth1(4, Cube, Face4),
	RightElemNum = 2,
	DownElemNum is CubeSize + 1,
	nth1(UpElemNum, Face1, UpTile),
	nth1(RightElemNum, Face4, RightTile),
	nth1(DownElemNum, Face4, DownTile),
	nth1(LeftElemNum, Face5, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([4, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	nth1(1, Cube, Face1),
	UpElemNum is CubeSize * CubeSize,
	nth1(2, Cube, Face2),
	RightElemNum is (CubeSize *(CubeSize - 1)) + 1,
	nth1(4, Cube, Face4),
	DownElemNum is CubeSize * 2,
	LeftElemNum is CubeSize - 1,
	nth1(UpElemNum, Face1, UpTile),
	nth1(RightElemNum, Face2, RightTile),
	nth1(DownElemNum, Face4, DownTile),
	nth1(LeftElemNum, Face4, LeftTile),
	element(4, UpTile, UpNext),
	element(4, RightTile, RightNext),
	element(4, DownTile, DownNext),
	element(4, LeftTile, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([4, [1, CubeSize], _Color], List, Cube, CubeSize):-
	element(4, Cube, Face4),
	UpElemNum is (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is (CubeSize * (CubeSize - 1)) + 2,
	element(6, Cube, Face6),
	DownElemNum is CubeSize * CubeSize,
	element(5, Cube, Face5),
	LeftElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(UpElemNum, Face4, UpNext),
	element(RightElemNum, Face4, RightNext),
	element(DownElemNum, Face6, DownNext),
	element(LeftElemNum, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([4, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	element(4, Cube, Face4),
	UpElemNum is CubeSize * (CubeSize - 1),
	LeftElemNum is (CubeSize * CubeSize) - 1,
	element(2, Cube, Face2),
	RightElemNum is CubeSize * CubeSize,
	element(6, Cube, Face6),
	DownElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(UpElemNum, Face4, UpNext),
	element(RightElemNum, Face2, RightNext),
	element(DownElemNum, Face6, DownNext),
	element(LeftElemNum, Face4, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([4, [X, 1], _Color], List, Cube,CubeSize):-
	element(1, Cube, Face1),
	UpElemNum is (CubeSize * (CubeSize - 1)) + X,
	element(4, Cube, Face4),
	RightElemNum is X + 1,
	DownElemNum is CubeSize + X,
	LeftElemNum is X - 1,
	element(UpElemNum, Face1, UpNext),
	element(RightElemNum, Face4, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face4, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([4, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	element(2, Cube, Face2),
	RightElemNum is (CubeSize * (CubeSize -1))+ Y,
	element(4, Cube, Face4),
	UpElemNum is CubeSize*(Y - 1),
	DownElemNum is CubeSize * (Y + 1),
	LeftElemNum is (CubeSize * Y) - 1,
	element(UpElemNum, Face4, UpNext),
	element(RightElemNum, Face2, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face4, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([4, [X, CubeSize], _Color], List, Cube, CubeSize):-
	element(6, Cube, Face6),
	DownElemNum is (CubeSize * CubeSize) - (X - 1),
	element(DownElemNum, Face6, DownNext),
	element(4, Cube, Face4),
	UpElemNum is (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is (CubeSize * (CubeSize - 1)) + X + 1,
	LeftElemNum is (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Face4, UpNext),
	element(RightElemNum, Face4, RightNext),
	element(LeftElemNum, Face4, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([4, [1, Y], _Color], List, Cube, CubeSize):-
	element(5, Cube, Face5),
	LeftElemNum is (CubeSize * CubeSize) - (Y -1),
	element(LeftElemNum, Face5, LeftNext),
	element(4, Cube, Face4),
	UpElemNum is (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is (CubeSize * (Y + 1)) - (CubeSize - 1),
	element(UpElemNum, Face4, UpNext),
	element(RightElemNum, Face4, RightNext),
	element(DownElemNum, Face4, DownNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 5 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([5, [1,1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3),
	UpElemNum = 1,
	element(6, Cube, Face6),
	LeftElemNum = CubeSize,
	element(5, Cube, Face5),
	RightElemNum = 2,
	DownElemNum is CubeSize + 1,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(DownElemNum, Face5, DownNext),
	element(LeftElemNum, Face6, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([5, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3),
	UpElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(1, Cube, Face1),
	RightElemNum = 1,
	element(5, Cube, Face5),
	DownElemNum is CubeSize * 2,
	LeftElemNum is CubeSize - 1,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face1, RightNext),
	element(DownElemNum, Face5, DownNext),
	element(LeftElemNum, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([5, [1, CubeSize], _Color], List, Cube, CubeSize):-
	element(5, Cube, Face5),
	UpElemNum is (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is (CubeSize * (CubeSize - 1)) + 2,
	element(4, Cube, Face4),
	DownElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(6, Cube, Face6),
	LeftElemNum is CubeSize * CubeSize,
	element(UpElemNum, Face5, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face6, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([5, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	element(5, Cube, Face5),
	UpElemNum is CubeSize * (CubeSize - 1),
	LeftElemNum is (CubeSize * CubeSize) - 1,
	element(1, Cube, Face1),
	RightElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(4, Cube, Face4),
	DownElemNum = 1,
	element(UpElemNum, Face5, UpNext),
	element(RightElemNum, Face1, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([5, [X, 1], _Color], List, Cube,CubeSize):-
	element(3, Cube, Face3),
	UpElemNum is (CubeSize * (X - 1)) + 1,
	element(5, Cube, Face5),
	RightElemNum is X + 1,
	DownElemNum is CubeSize + X,
	LeftElemNum is X - 1,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(DownElemNum, Face5, DownNext),
	element(LeftElemNum, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([5, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	element(1, Cube, Face1),
	RightElemNum is (CubeSize * (Y - 1)) + 1,
	element(5, Cube, Face5),
	UpElemNum is CubeSize*(Y - 1),
	DownElemNum is CubeSize * (Y + 1),
	LeftElemNum is (CubeSize * Y) - 1,
	element(UpElemNum, Face5, UpNext),
	element(RightElemNum, Face1, RightNext),
	element(DownElemNum, Face5, DownNext),
	element(LeftElemNum, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([5, [X, CubeSize], _Color], List, Cube, CubeSize):-
	element(4, Cube, Face4),
	DownElemNum is (CubeSize * (CubeSize - X)) + 1,
	element(DownElemNum, Face4, DownNext),
	element(5, Cube, Face5),
	UpElemNum is (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is (CubeSize * (CubeSize - 1)) + X + 1,
	LeftElemNum is (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Face5, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(LeftElemNum, Face5, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([5, [1, Y], _Color], List, Cube, CubeSize):-
	element(6, Cube, Face6),
	LeftElemNum is CubeSize * Y,
	element(LeftElemNum, Face6, LeftNext),
	element(5, Cube, Face5),
	UpElemNum is (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is (CubeSize * (Y + 1)) - (CubeSize - 1),
	element(UpElemNum, Face5, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(DownElemNum, Face5, DownNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%------------------------------------------------------
%-------------------------- Face 6 --------------------
%------------------------------------------------------
%Up Left Corner
obtainNextTo([6, [1,1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3),
	UpElemNum = CubeSize,
	element(2, Cube, Face2),
	LeftElemNum = CubeSize,
	element(6, Cube, Face6),
	RightElemNum = 2,
	DownElemNum is CubeSize + 1,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(DownElemNum, Face6, DownNext),
	element(LeftElemNum, Face2, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Right Corner
obtainNextTo([6, [CubeSize, 1], _Color], List, Cube, CubeSize):-
	element(3, Cube, Face3),
	UpElemNum = 1,
	element(5, Cube, Face5),
	RightElemNum = 1,
	element(6, Cube, Face6),
	DownElemNum is CubeSize * 2,
	LeftElemNum is CubeSize - 1,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(DownElemNum, Face6, DownNext),
	element(LeftElemNum, Face6, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Left Corner
obtainNextTo([6, [1, CubeSize], _Color], List, Cube, CubeSize):-
	element(6, Cube, Face6),
	UpElemNum is (CubeSize * (CubeSize - 2)) + 1,
	RightElemNum is (CubeSize * (CubeSize - 1)) + 2,
	element(4, Cube, Face4),
	DownElemNum is CubeSize * CubeSize,
	element(2, Cube, Face2),
	LeftElemNum is CubeSize * CubeSize,
	element(UpElemNum, Face6, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face2, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Right Corner
obtainNextTo([6, [CubeSize, CubeSize], _Color], List, Cube, CubeSize):-
	element(6, Cube, Face6),
	UpElemNum is CubeSize * (CubeSize - 1),
	LeftElemNum is (CubeSize * CubeSize) - 1,
	element(5, Cube, Face5),
	RightElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(4, Cube, Face4),
	DownElemNum is (CubeSize * (CubeSize - 1)) + 1,
	element(UpElemNum, Face6, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(DownElemNum, Face4, DownNext),
	element(LeftElemNum, Face6, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Up Border
obtainNextTo([6, [X, 1], _Color], List, Cube,CubeSize):-
	element(3, Cube, Face3),
	UpElemNum is CubeSize - (X - 1),
	element(6, Cube, Face6),
	RightElemNum is X + 1,
	DownElemNum is CubeSize + X,
	LeftElemNum is X - 1,
	element(UpElemNum, Face3, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(DownElemNum, Face6, DownNext),
	element(LeftElemNum, Face6, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Right Border
obtainNextTo([6, [CubeSize, Y], _Color], List, Cube, CubeSize):-
	element(5, Cube, Face5),
	RightElemNum is (CubeSize * (Y - 1)) + 1,
	element(6, Cube, Face6),
	UpElemNum is CubeSize*(Y - 1),
	DownElemNum is CubeSize * (Y + 1),
	LeftElemNum is (CubeSize * Y) - 1,
	element(UpElemNum, Face6, UpNext),
	element(RightElemNum, Face5, RightNext),
	element(DownElemNum, Face6, DownNext),
	element(LeftElemNum, Face6, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Down Border
obtainNextTo([6, [X, CubeSize], _Color], List, Cube, CubeSize):-
	element(4, Cube, Face4),
	DownElemNum is (CubeSize * CubeSize) - (X - 1),
	element(DownElemNum, Face4, DownNext),
	element(6, Cube, Face6),
	UpElemNum is (CubeSize * (CubeSize - 2)) + X,
	RightElemNum is (CubeSize * (CubeSize - 1)) + X + 1,
	LeftElemNum is (CubeSize * (CubeSize - 1)) + X - 1,
	element(UpElemNum, Face6, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(LeftElemNum, Face6, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
%Left Border
obtainNextTo([6, [1, Y], _Color], List, Cube, CubeSize):-
	element(2, Cube, Face2),
	LeftElemNum is CubeSize * Y,
	element(LeftElemNum, Face2, LeftNext),
	element(6, Cube, Face6),
	UpElemNum is (CubeSize * (Y - 1)) - (CubeSize - 1),
	RightElemNum is (CubeSize * Y) - (CubeSize - 2),
	DownElemNum is (CubeSize * (Y + 1)) - (CubeSize - 1),
	element(UpElemNum, Face6, UpNext),
	element(RightElemNum, Face6, RightNext),
	element(DownElemNum, Face6, DownNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].

%------------------------------------------------------
%-------------------General Case ----------------------
%------------------------------------------------------
obtainNextTo([FaceNum, [X, Y], _Color], List, Cube, CubeSize):-
	element(FaceNum, Cube, Face),
	UpElemNum is (CubeSize * (Y - 2)) + X,
	RightElemNum is (CubeSize * (Y - 1)) + X + 1,
	DownElemNum is (CubeSize * Y) + X,
	LeftElemNum is (CubeSize * (Y - 1)) + X - 1,
	element(UpElemNum, Face, UpNext),
	element(RightElemNum, Face, RightNext),
	element(DownElemNum, Face, DownNext),
	element(LeftElemNum, Face, LeftNext),
	
	List = [UpNext, RightNext, DownNext, LeftNext].
	
%Notes: Check global_cardinality
%		Color + 1 mod 4 to obtain the next colors
/*generateSolution(Size):-
	createCube(Size).*/

test(FaceNum, X, Y, List, CubeSize):-
	%NumberTiles is CubeSize * CubeSize,
	buildCube3(Cube, 1, 1, 1, CubeSize),
	obtainNextTo3([FaceNum, [X, Y], _], List, Cube, CubeSize),
	global_cardinality(List, [1-2, 2-1, 3-1, 4-_]),
	labeling([], List).
	
	
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
buildCube3(_, 7, _, _, _).
buildCube3(Cube, FaceNum, CubeSize, CubeSize, CubeSize):- %Next face
	append([FaceNum, CubeSize, CubeSize, Color],TileTemp, Cube),
	Color #> 0, Color #< 5,
	Faceplus is FaceNum + 1,
	buildCube3(TileTemp, Faceplus, 1, 1, CubeSize).
buildCube3(Cube, FaceNum, CubeSize, Y, CubeSize):- %Next Line
	append([FaceNum, CubeSize, Y, Color],TileTemp, Cube),
	Color #> 0, Color #< 5,
	Yplus is Y + 1,
	buildCube3(TileTemp, FaceNum, 1, Yplus, CubeSize).
buildCube3(Cube, FaceNum, X, Y, CubeSize):- %Next tile in line
	append([FaceNum, X, Y, Color],TileTemp, Cube),
	Color #> 0, Color #< 5,
	Xplus is X + 1,
	buildCube3(TileTemp, FaceNum, Xplus, Y, CubeSize).



writeCube([]):- nl.
writeCube([Face|Rest]):-
	writeFace(Face),
	writeCube(Rest).

writeFace([]):- nl.
writeFace([Tile | Rest]):-
	write(Tile),
	writeFace(Rest).
	
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
	Face6 is (4 * TilesPerFace * 5), %1 before First Element of Face 6
	UpElemNum is Face6 + (4 * CubeSize),
	Face5 is (4 * TilesPerFace * 4),
	LeftElemNum is Face5 + 4,
	Face3 is (4 * TilesPerFace  * 2),
	RightElemNum is Face3 + (4 * 2),
	DownElemNum is Face3 + (4 * (CubeSize + 1)),
	
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