using System;
using System.Collections;

namespace AoC;

class Day10 : Day {
	public this() : base(10) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		int sum = 0;

		Execute(input, scope [&](cycle, register) => {
			if ((cycle - 20) % 40 == 0) sum += cycle * register;
		});

		output.Append(sum);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		output.Append('\n');

		int position = 0;

		Execute(input, scope [&](cycle, register) => {
			output.Append((register >= position - 1 && register <= position + 1) ? '#' : '.');

			position++;

			if (position >= 40) {
				position = 0;
				output.Append('\n');
			}
		});
	}

	private void Execute(List<StringView> input, delegate void(int cycle, int register) onCycle) {
		int cycle = 1;
		int register = 1;

		mixin Cycle() {
			onCycle(cycle, register);
			cycle++;
		}

		// Loop all instructions
		for (let line in input) {
			// Parse instruction
			StringSplitEnumerator split = line.Split(' ');

			StringView instruction = split.GetNext();
			int data = 0;

			if (split.HasMore) data = int.Parse(split.GetNext());

			// Execute instruction
			if (instruction == "noop") {
				// Execute noop
				Cycle!();
			}
			else {
				// Execute addx
				Cycle!();

				Cycle!();
				register += data;
			}
		}
	}
}