with (import <nixpkgs> {}).lib;
let
	sum = foldl add 0;

	unpair = pair: {fst = head pair; snd = last pair;};
	
	inRange = range: n:
		with (unpair range);
		fst <= n && n <= snd;

	isSubrange = sup: all (inRange sup);

	redundant = pair:
		with (unpair pair);
		isSubrange fst snd || isSubrange snd fst;

	overlapping = pair:
		with (unpair pair);
		redundant pair
		|| any (inRange fst) snd
		|| any (inRange snd) fst;
	
	pairs = pipe ./inputs/day4 [
		(fileContents)
		(splitString "\n")
		(map (splitString ","))
		(map (map (splitString "-")))
		(map (map (map toInt)))
		# i don't know the correct pattern
	];
in {
	part1 = count redundant pairs;
	part2 = count overlapping pairs;
}