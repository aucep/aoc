import unittest
import results
import ../src/day1

test "trivial example":
    let input = """1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"""
    check solution(input).get == (24000, 45000)