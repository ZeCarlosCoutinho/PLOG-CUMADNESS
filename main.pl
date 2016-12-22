:- use_module(library(clpfd)).

/*
Restrictions:
    * Red -> 1 Yellow.
	* Each way of yellow -> Yellow-Green-Blue-Red.
	
Cube faces:
	   [3]
	[5][1][2][6]
	   [4]
*/



cube[Face1, Face2, Face3, Face4, Face5, Face6].

emptyTile[Cabeca|Cauda]:-
	Cabeca is Empty,
	emptyTitle[Cauda].
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
	
	%flatten?
	%labeling?
	
	

%Face by face, builds the cube
%Face = Actual face, Rest = Rest of the faces, CubeSize = Cube measure, NumberTiles = (Cube measure) ^2, Iterator = Face number
buildCube([], _, _, 7).
buildCube([], _, _, _):-
	write("Error building cube");
buildCube([Face | Rest], CubeSize, NumberTiles, Iterator):-
	buildFace(Face, Iterator, CubeSize, 1),
	Iteratorplus is Iterator + 1,
	buildCube(Rest, CubeSize, NumberTiles, Iteratorplus).
	
%Face is filled from top to bottom, left to right
% Face = [Tile | Rest], FaceNum = 1..6, CubeSize = Cube measure, Iterator = Tile Number
buildFace([], _, _, _).
buildFace([Tile | Rest], FaceNum, CubeSize, Iterator):-
	X is (Iterator mod CubeSize) + 1,
	Y is Iterator / CubeSize,
	element(Iterator, [Tile | Rest], [FaceNum, [X, Y], Cor]),
	domain(Cor, 1, 4), %There are only 4 color possible
	
	%Go to next iteration
	Iteratorplus is Iterator + 1,
	buildFace(Rest, FaceNum, Iteratorplus).

	

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
	element(1, List, [_, [_, _], Color1]),
	element(2, List, [_, [_, _], Color2]),
	element(3, List, [_, [_, _], Color3]),
	element(4, List, [_, [_, _], Color4]),
	
	%DUVIDA Ele vai perceber que dos valores das Color1,2,3 e 4, so um deles é que pode ter a Restricted Color?
	%Restrict that next color appears 1 time in List, and the other is free
	ColorList = [Color1, Color2, Color3, Color4],
	RestrictedColor is (Color mod 4) + 2, %Color + 1, and if is 4, then RestrictedColor is 1
	OtherColor1 is (Color mod 4) + 3,
	OtherColor2 is (Color mod 4),
	OtherColor3 is (Color mod 4) + 1,
	global_cardinality(ColorList, [RestrictedColor-1, OtherColor1-_, OtherColor2-_, OtherColor3-_]),
	
	%Recursive Step
	constrainFace(Rest, Cube, CubeSize).
	
	
	
%colorConstrict([_Face, [X1, Y1], Color1], [_Face, [X2, Y2], Color2], _CubeSize):-



%---------------------------- FACE ADJACENCE DEFINITION -------------------------
	
%For now only works with 3 x 3
%TODO change the 1st number in element to a variable

%Face 1
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
	element(9, Face5, LeftNext).
	
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
obtainNextTo([1, [X, 1], _Color, List, Cube, CubeSize):-
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
	element(5, Cube, Face5),
	RightElemNum = (CubeSize * (Y - 1)) + 1,
	element(RightElemNum, Face5, RightNext),
	element(1, Cube, Face1),
	UpElemNum is Y
	%TODO resto
	

%Notes: Check global_cardinality
%		Color + 1 mod 4 to obtain the next colors
/*generateSolution(Size):-
	createCube(Size).*/

