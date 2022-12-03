const puzzle = "2022/day1"

import strutils, sequtils, algorithm
import results

func solution*(input: string): Result[(int, int), string] =
  let 
    calorie_counts = ?input
      .strip
      .split("\n\n")
      .mapIt(it
        .splitLines()
        .map(parseInt)
        .foldl(a + b))
      .sorted
      .catch.orErr("invalid calorie count in puzzle input")
    part1 = calorie_counts[^1]
    part2 = calorie_counts[^3..^1].foldl(a + b)
  # in
  ok((part1, part2))

when isMainModule:
  proc main: Result[void, string] =
    echo puzzle
    let input = ?readFile("inputs/"&puzzle).catch.orErr("could not load input")
    echo "result: ", ?solution(input)
    ok()

  let result = main()
  if result.isErr:
    echo "error: ", result.error
    quit(1)