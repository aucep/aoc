use anyhow::{Context, Result};
use itertools::Itertools;

pub fn solution(input: &str) -> Result<(u32, u32)> {
    let depths: Vec<u32> = input
        .lines()
        .map(|depth| depth.parse::<u32>().context("invalid depth measurement"))
        .collect::<Result<_>>()?;

    let part1 = depths
        .iter()
        .tuple_windows()
        .filter(|(a, b)| a < b)
        .count()
        .try_into()?;

    let part2 = depths
        .iter()
        .tuple_windows()
        .map(|(a, b, c)| a + b + c)
        .tuple_windows()
        .filter(|(a, b)| a < b)
        .count()
        .try_into()?;

    Ok((part1, part2))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn trivial_example() {
        let input = "199
200
208
210
200
207
240
269
260
263";
        assert_eq!((7, 5), solution(input).unwrap());
    }
}
