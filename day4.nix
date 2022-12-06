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

	# there still has to be a better way... and name lol
	deepMapPipe = list: flip pipe
		(imap0 (i: func: (foldl 
			(x: f: f x)
			func (genList (const map) i))) list);
	
	pairs = deepMapPipe (fileContents ./inputs/day4) [
		(splitString "\n")
		(splitString ",")
		(splitString "-")
		(toInt)
	];
in {
	part1 = count redundant pairs;
	part2 = count overlapping pairs;
}