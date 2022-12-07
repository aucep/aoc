with (import <nixpkgs> {}).lib;
with {inherit (builtins) match;};
let
	sum = foldl add 0;
	
	input = pipe ./inputs/day5 [
		fileContents
		(splitString "\n\n")
		(map (splitString "\n"))
	];

	movements =
		let parse = step:
			let
				digit = "([[:digit:]]{1,})";
				getArg = pipe step [
					(match "move ${digit} from ${digit} to ${digit}")
					elemAt
				];
			in {
				num = toInt (getArg 0);
				fromKey = getArg 1;
				destKey = getArg 2;
			};
		in map parse (last input);

	initialState =
		let
			stackCount = ((stringLength (last (head input))) + 1) / 4;
			getStacks = i: pipe (head input) [
				(map (line: elemAt (stringToCharacters line) (i*4 + 1)))
				(filter (c: " " != c))
				(xs: {name = last xs; value = init xs;})
			];
		in pipe stackCount [
			(genList getStacks)
			listToAttrs
		];

	makeMutate = moveModifier: state: {num, fromKey, destKey}:
		let
			from = getAttr fromKey state;
			dest = getAttr destKey state;
			changes = listToAttrs [
				(nameValuePair fromKey (drop num from))
				(nameValuePair destKey
				 	((moveModifier (take num from)) ++ dest))
			];
		in state // changes;

	moveAllWith = moveModifier:
		pipe movements [
			(foldl (makeMutate moveModifier) initialState)
			(mapAttrsToList (n: v: head v))
			concatStrings
		];
	
in {
	part1 = moveAllWith reverseList;
	part2 = moveAllWith id;
}