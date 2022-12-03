using System;
using System.Collections;

namespace AoC;

class Day1 : Day {
	public this() : base(1) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		List<int> elves = scope .();
		GetSortedElves(input, elves);

		output.Append(elves[0]);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		List<int> elves = scope .();
		GetSortedElves(input, elves);

		output.Append(elves[0] + elves[1] + elves[2]);
	}

	private void GetSortedElves(List<StringView> input, List<int> output) {
		output.Add(0);
		
		for (let line in input) {
			if (line.IsEmpty) output.Add(0);
			else output.Back += int.Parse(line);
		}

		output.Sort(scope (lhs, rhs) => lhs <=> rhs);
	}
}