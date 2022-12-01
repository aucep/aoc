use anyhow::{bail, Context, Result};

enum Command {
    Forward(u32),
    Up(u32),
    Down(u32),
}

pub fn solution(input: &str) -> Result<(u32, u32)> {
    let commands: Vec<Command> = input
        .lines()
        .map(|command| {
            let [direction, distance] = command.split(' ').collect::<Vec<_>>()[..] else {
                bail!("invalid command format");
            };

            let distance: u32 = distance.parse().context("invalid distance in command")?;

            let command = match direction {
                "forward" => Command::Forward(distance),
                "up" => Command::Up(distance),
                "down" => Command::Down(distance),
                _ => bail!("invalid direction in command"),
            };

            Ok(command)
        })
        .collect::<Result<_>>()?;

    let part1 = {
        let (x, y) = commands
            .iter()
            .fold((0, 0), |(x, y), command| match command {
                Command::Forward(distance) => (x + distance, y),
                Command::Up(distance) => (x, y - distance),
                Command::Down(distance) => (x, y + distance),
            });
        x * y
    };

    let part2 = {
        let (x, y, _) = commands
            .iter()
            .fold((0, 0, 0), |(x, y, aim), command| match command {
                Command::Forward(distance) => (x + distance, y + aim * distance, aim),
                Command::Up(distance) => (x, y, aim - distance),
                Command::Down(distance) => (x, y, aim + distance),
            });
        x * y
    };

    Ok((part1, part2))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn trivial_example() {
        let input = "forward 5
down 5
forward 8
up 3
down 8
forward 2";
        assert_eq!((150, 900), solution(input).unwrap());
    }
}
