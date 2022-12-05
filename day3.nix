with (import <nixpkgs> {}).lib;
let
	sum = foldl add 0;
	
	priority = 
		let alphabet = "abcdefghijklmnopqrstuvwxyz"
			+ "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		in c: pipe alphabet [
			(stringToCharacters)
			(imap1 (i: c: {name=c; value=i;}))
			(listToAttrs)
			(getAttr c)
		];
	
	common = xs: findFirst
		(c: all (hasInfix c) (tail xs))
		(throw "no common character")
		(stringToCharacters (head xs));
	
	sacks = pipe ./inputs/day3 [
		(fileContents)
		(splitString "\n")
	];
	
	part1 =
		let halves = s:
			let len = stringLength s;
			in [
				(substring 0 (len / 2) s)
				(substring (len / 2) len s)
			];
		in pipe sacks [
			(map halves)
			(map common)
			(map priority)
			sum
		];
	
	part2 = 
		let chunks = n: foldl
			(acc: elem:
				if (length (last acc)) < n
				then (init acc) ++ [((last acc) ++ [elem])]
				else acc ++ [[elem]])
			[[]];
		in pipe sacks [
			(chunks 3)
			(map common)
			(map priority)
			sum
		];
	
in {inherit part1 part2;}