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
	%TODO restrictions -> copy nice try but with restrictions
	
	

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
	

generateSolution(Size):-
	createCube(Size).

