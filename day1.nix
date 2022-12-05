with (import <nixpkgs> {}).lib;
let
	sum = foldl add 0;
	elves = pipe (fileContents ./inputs/day1) [
		(splitString "\n\n")
		(map (flip pipe [
			(splitString "\n")
			(map toInt)
			sum
		]))
		(sort (flip lessThan))
	];
	part1 = head elves;
	part2 = sum (take 3 elves);
in {inherit part1 part2;}