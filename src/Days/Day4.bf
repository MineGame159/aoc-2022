using System;
using System.Collections;

namespace AoC;

class Day4 : Day {
	public this() : base(4) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		int sum = 0;

		for (let line in input) {
			let (first, second) = GetPairRanges(line);

			if (first.Contains(second) || second.Contains(first)) sum++;
		}

		output.Append(sum);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		int sum = 0;

		for (let line in input) {
			let (first, second) = GetPairRanges(line);

			if (first.Contains(second.Start) || first.Contains(second.End) || second.Contains(first.Start) || second.Contains(first.End)) sum++;
		}

		output.Append(sum);
	}

	private (ClosedRange, ClosedRange) GetPairRanges(StringView input) {
		StringSplitEnumerator split = input.Split(',');

		// First
		StringSplitEnumerator firstSplit = split.GetNext().Value.Split('-');
		ClosedRange first = .(int.Parse(firstSplit.GetNext()), int.Parse(firstSplit.GetNext()));

		// Second
		StringSplitEnumerator secondSplit = split.GetNext().Value.Split('-');
		ClosedRange second = .(int.Parse(secondSplit.GetNext()), int.Parse(secondSplit.GetNext()));

		return (first, second);
	}
}