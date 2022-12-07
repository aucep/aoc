#!/bin/env -S nix-instantiate --eval --strict --show-trace
with (import <nixpkgs> {}).lib;
with builtins;
let
	getNum = file:
		let m = match "day([[:digit:]]{1,}).nix" file;
		in if m == null
			then null
			else head m;
in pipe ./. [
		readDir
		(mapAttrs (name: type:
			if type == "regular"
			then getNum name
			else null))
		(filterAttrs (_: day: day != null))
		(mapAttrs' (name: day: nameValuePair
			("day " + (
				if stringLength day == 1
				then "0${day}"
				else day))
			(import (./. + "/${name}"))))
	]