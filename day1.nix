with builtins;
with (import <nixpkgs> {}).lib;
let
	sum = foldl (a: b: a + b) 0;
	do = flip pipe; # not supposed to do this
	elves = pipe (readFile ./inputs/day1) [
		(removeSuffix "\n")
		(splitString "\n\n")
		(map (do [
			(splitString "\n")
			(map toInt)
			sum
		]))
		(sort (a: b: a > b))
	];
	part1 = head elves;
	part2 = sum (take 3 elves);
in {inherit part1 part2;}