using System;
using System.Collections;

namespace AoC;

class Day2 : Day {
	public this() : base(2) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		int score = 0;

		for (let line in input) {
			Sign opponent = .FromChar(line[0]);
			Sign me = .FromChar(line[2]);

			Outcome outcome = .FromSigns(opponent, me);

			score += me.Score + outcome.Score;
		}

		output.Append(score);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		int score = 0;

		for (let line in input) {
			Sign opponent = .FromChar(line[0]);
			Outcome outcome = .FromChar(line[2]);

			Sign me = .Predict(opponent, outcome);

			score += me.Score + outcome.Score;
		}

		output.Append(score);
	}

	enum Sign {
		case Rock, Paper, Scissors;

		public static Sign FromChar(char8 c) {
			switch (c) {
			case 'B', 'Y':	return .Paper;
			case 'C', 'Z':	return .Scissors;
			default:	return .Rock;
			}
		}

		public static Sign Predict(Sign opponent, Outcome outcome) {
			switch (outcome) {
			case .Draw:	return opponent;
			case .Loss:	{
				switch (opponent) {
				case .Rock:		return .Scissors;
				case .Paper:	return .Rock;
				case .Scissors:	return .Paper;
				}
			}
			case .Win:	{
				switch (opponent) {
				case .Rock:		return .Paper;
				case .Paper:	return .Scissors;
				case .Scissors:	return .Rock;
				}
			}
			}
		}

		public int Score => Underlying + 1;
	}

	enum Outcome {
		case Loss, Draw, Win;

		public static Outcome FromSigns(Sign opponent, Sign me) {
			if (opponent == me) return .Draw;
			if ((me == .Rock && opponent == .Scissors) || (me == .Scissors && opponent == .Paper) || (me == .Paper && opponent == .Rock)) return .Win;
			return .Loss;
		}

		public static Outcome FromChar(char8 c) {
			switch (c) {
			case 'Y':	return .Draw;
			case 'Z':	return .Win;
			default:	return .Loss;
			}
		}

		public int Score => Underlying * 3;
	}
}