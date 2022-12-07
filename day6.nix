#!/usr/bin/env -S nix-instantiate --eval --strict --show-trace
with (import <nixpkgs> {}).lib;
let
	input = fileContents ./test_inputs/day6;
	
	windows = n: list:
			genList (i: sublist i n list) (length list - n);
	
	firstUniqueSpan = n:
		flip pipe [
			stringToCharacters
			(windows n)
			(imap0 (i: xs: {inherit i xs;}))
			(findFirst
			 	({i, xs}: length (unique xs) == n)
			 	(abort "no unique"))
			({i, xs}: i + n)
		];
in {
	part1 = firstUniqueSpan 4 input;
	part2 = firstUniqueSpan 14 input;
}