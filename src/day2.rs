use std::str::FromStr;

use anyhow::{Result, Context};
use game::{Move, Round};

mod game {
    use std::str::FromStr;
    
    use thiserror::Error;

    #[derive(Copy, Clone)]
    pub enum Move {
        Rock,
        Paper,
        Scissors,
    }

    impl Move {
        pub const fn wins_against(self) -> Self {
            use self::Move::*;
            match self {
                Rock => Scissors,
                Paper => Rock,
                Scissors => Paper,
            }
        }
        pub const fn loses_against(self) -> Self {
            use self::Move::*;
            match self {
                Rock => Paper,
                Paper => Scissors,
                Scissors => Rock,
            }
        }
    }

    pub struct Round {
        pub foe: Move,
        pub you: Move,
    }

    enum Outcome {
        Loss,
        Draw,
        Win,
    }

    impl Round {
        fn outcome(&self) -> Outcome {
            use Move::*;
            match (self.foe, self.you) {
                (Rock, Scissors) | (Paper, Rock) | (Scissors, Paper) => Outcome::Loss,
                (Rock, Rock) | (Paper, Paper) | (Scissors, Scissors) => Outcome::Draw,
                (Rock, Paper) | (Paper, Scissors) | (Scissors, Rock) => Outcome::Win,
            }
        }

        pub fn score(&self) -> u32 {
            let outcome_score = match self.outcome() {
                Outcome::Loss => 0,
                Outcome::Draw => 3,
                Outcome::Win => 6,
            };

            let move_score = match self.you {
                Move::Rock => 1,
                Move::Paper => 2,
                Move::Scissors => 3,
            };

            outcome_score + move_score
        }
    }

    #[derive(Error, Debug)]
    pub enum ParseRoundError {
        #[error("cannot parse round from empty string")]
        Empty,
        #[error("invalid character found in string")]
        InvalidCharacter,
        #[error("string ends unexpectedly")]
        Ends,
        #[error("string continues too long")]
        Continues, // validation
    }

    impl FromStr for Round {
        type Err = ParseRoundError;
        fn from_str(s: &str) -> Result<Self, Self::Err> {
            let mut s = s.chars();

            let foe = match s.next().ok_or(ParseRoundError::Empty)? {
                'A' => Ok(Move::Rock),
                'B' => Ok(Move::Paper),
                'C' => Ok(Move::Scissors),
                _ => Err(ParseRoundError::InvalidCharacter),
            }?;

            if s.next().ok_or(ParseRoundError::Ends)? != ' ' {
                return Err(ParseRoundError::InvalidCharacter);
            }

            let you = match s.next().ok_or(ParseRoundError::Ends)? {
                'X' => Ok(Move::Rock),
                'Y' => Ok(Move::Paper),
                'Z' => Ok(Move::Scissors),
                _ => Err(ParseRoundError::InvalidCharacter),
            }?;

            if s.next().is_some() {
                return Err(ParseRoundError::Continues);
            }

            Ok(Round { foe, you })
        }
    }
}

pub fn solution(input: &str) -> Result<(u32, u32)> {
    let rounds: Vec<Round> = input
        .lines()
        .map(Round::from_str)
        .collect::<Result<_, _>>().context("could not parse rounds")?;

    let part1 = rounds.iter().map(|round| round.score()).sum();

    let part2 = rounds
        .iter()
        .map(|Round { foe, you }| {
            let you = match you {
                Move::Rock => foe.wins_against(),
                Move::Paper => *foe,
                Move::Scissors => foe.loses_against(),
            };
            Round { foe: *foe, you }
        })
        .map(|round| round.score())
        .sum();

    Ok((part1, part2))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn trivial_example() {
        let input = "A Y
B X
C Z";
        assert_eq!((15, 12), solution(input).unwrap());
    }
}
