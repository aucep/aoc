use anyhow::{bail, Context, Result};
use std::{env, fs};

mod day1;
mod day2;

fn main() -> Result<()> {
    let mut args = env::args().skip(1).peekable();

    args.peek().context("no days were specified")?;

    for day in args {
        let day: u8 = day.parse().with_context(|| {
            format!("invalid input '{day}': each day should be formatted as an integer 1..=31")
        })?;

        let solution = match day {
            1 => day1::solution,
            2 => day2::solution,
            0 | 32.. => bail!("{day} outside of range 1..=31"),
            _ => bail!("day{day} not implemented"),
        };

        let path = format!("./inputs/day{day}");
        let input =
            fs::read_to_string(path).with_context(|| format!("input for day{day} not found"))?;

        println!("day{day} => {:?}", solution(&input)?);
    }

    Ok(())
}
