using System;
using System.Collections;

namespace AoC;

class Day5 : Day {
	public this() : base(5) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		Ship ship = scope .();

		ship.ParseCrates(input);
		ship.SimulateMoves(input, false);

		ship.GetTopCrates(output);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		Ship ship = scope .();

		ship.ParseCrates(input);
		ship.SimulateMoves(input, true);

		ship.GetTopCrates(output);
	}

	private class Ship {
		private List<char8>[9] stacks;

		public this() {
			for (int i < 9) stacks[i] = new .();
		}

		public ~this() {
			for (int i < 9) delete stacks[i];
		}

		public void ParseCrates(List<StringView> input) {
			// Get number line
			int numberLineI = -1;

			for (let line in input) {
				if (line.StartsWith(" 1")) {
					numberLineI = @line.Index;
					break;
				}
			}

			// Parse stacks from bottom to top
			for (int i = numberLineI - 1; i >= 0; i--) {
				StringView line = input[i];

				for (int j < stacks.Count) {
					char8 crate = line[1 + j * 4];
					if (crate != ' ') stacks[j].Add(crate);
				}
			}
		}

		public void SimulateMoves(List<StringView> input, bool preserveCrateOrder) {
			List<char8> temp = scope .();

			// Loop through input
			for (let line in input) {
				if (!line.StartsWith("move ")) continue;

				// Parse move
				StringSplitEnumerator partsRaw = line.Split(' ', .RemoveEmptyEntries);
				partsRaw.GetNext();

				int count = int.Parse(partsRaw.GetNext()); partsRaw.GetNext();
				int fromI = int.Parse(partsRaw.GetNext()); partsRaw.GetNext();
				int toI = int.Parse(partsRaw.GetNext());

				// Simulate move
				List<char8> from = stacks[fromI - 1];
				List<char8> to = stacks[toI - 1];

				if (preserveCrateOrder) {
					for (int i < count) {
						temp.Add(from.PopBack());
					}

					for (int i < count) {
						to.Add(temp.PopBack());
					}
				}
				else {
					for (int i < count) {
						to.Add(from.PopBack());
					}
				}
			}
		}

		public void GetTopCrates(String output) {
			for (let stack_ in stacks) {
				output.Append(stack_.Back);
			}
		}
	}
}