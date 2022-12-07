#!/bin/env -S nix-instantiate --eval --strict --show-trace
with (import <nixpkgs> {}).lib;
let
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

	# thanks to 
	splitAndMap = sep: f: s:
    map f (splitString sep s);

	# last function applied to second to last, etc.
	compose = xs: foldr id (last xs) (init xs);

	pairs = pipe ./inputs/day4 [
		fileContents
		(compose [
			(splitAndMap "\n")
			(splitAndMap ",")
			(splitAndMap "-")
			toInt
		])
	];
in {
	part1 = count redundant pairs;
	part2 = count overlapping pairs;
}