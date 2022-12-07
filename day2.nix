with (import <nixpkgs> {}).lib;
let
	sum = foldl add 0;
	# find = m: s: foldl (flip getAttr) m (splitString " " s);
	find = flip (
		(flip pipe) [
			(splitString " ")
			(pipe getAttr [flip foldl flip])
		]);
	scoreMap = {
		A={X=4; Y=8; Z=3;};
		B={X=1; Y=5; Z=9;};
		C={X=7; Y=2; Z=6;};
	};
	outcomeMap = {
		A={X="A Z"; Y="A X"; Z="A Y";};
		B={X="B X"; Y="B Y"; Z="B Z";};
		C={X="C Y"; Y="C Z"; Z="C X";};
	};
	rounds = pipe ./inputs/day2 [
		(fileContents)
		(splitString "\n")
	];
	part1 = pipe rounds [
		(map (find scoreMap))
		sum
	];
	part2 = pipe rounds [
		(map (find outcomeMap))
		(map (find scoreMap))
		sum
	];
in {inherit part1 part2;}