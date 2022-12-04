use anyhow::{bail, Context, Result};

pub fn solution(input: &str) -> Result<(u32, u32)> {
    let mut calorie_counts: Vec<u32> = input
        .split("\n\n")
        .filter(|group| !group.is_empty())
        .map(|group| {
            group
                .lines()
                .map(|line| line.parse::<u32>().context("encountered invalid calorie count"))
                .sum()
        })
        .collect::<Result<_>>()?;

    calorie_counts.sort();

    let [.., part1] = calorie_counts[..] else {
        bail!("There should be at least 1 elf");
    };

    let part2 = {
        let [.., a, b, c] = calorie_counts[..] else {
            bail!("There should be at least 3 elves");
        };
        a + b + c
    };

    Ok((part1, part2))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn trivial_example() {
        let input = "1000
2000
3000

4000

5000
6000

7000
8000
9000

10000";
        assert_eq!((24000, 45000), solution(input).unwrap());
    }
}
