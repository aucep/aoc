import os, strutils, strformat, tables, sugar
import results
import day1

const solutions = {1: day1.solution}.toTable

proc main: Result[void, string] =
  if paramCount() == 0:
    return err("no days were specified")

  for dayStr in commandLineParams():
    let day = ?dayStr.parseInt.catch.orErr(&"{dayStr} is not a valid day")
    
    if day notin 1..31:
      return err(&"day{day} not in range 1..31")

    let solution = ?solutions[day].catch.orErr(&"day{day} not implemented")

    let input = ?readFile(&"inputs/2022/day{day}").catch.mapErr((err) => &"could not load input for day{day}: {err.msg}")

    let output = ?solution(input)

    echo &"day{day}: {output}"

  ok()
      
  
  
when isMainModule:
  # result error handling
  if (let r = main(); r.isErr):
    echo "error: ", r.error
    quit(1)
    
