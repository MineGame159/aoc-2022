using System;
using System.Collections;

namespace AoC;

class Day3 : Day {
	public this() : base(3) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		int sum = 0;

		for (let line in input) {
			let (first, second) = Split(line);
			char8 duplicate = GetDuplicate<2>(.(first, second));

			sum += GetPriority(duplicate);
		}

		output.Append(sum);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		int sum = 0;

		for (int i = 0; i < input.Count; i += 3) {
			char8 duplicate = GetDuplicate<3>(.(input[i], input[i + 1], input[i + 2]));

			sum += GetPriority(duplicate);
		}

		output.Append(sum);
	}

	private (StringView, StringView) Split(StringView string) {
		StringView first = string[...(string.Length / 2 - 1)];
		StringView second = string[first.Length...];

		return (first, second);
	}

	private char8 GetDuplicate<T>(StringView[T] strings) where T : const int {
		for (int i < T) {
			StringView string = strings[i];

			for (char8 c in string) {
				bool ok = true;

				for (int j < T) {
					if (j != i && !strings[j].Contains(c)) {
						ok = false;
						break;
					}
				}

				if (ok) return c;
			}
		}

		return '\0';
	}

	private int GetPriority(char8 c) {
		if (c >= 'a' && c <= 'z') return c - 'a' + 1;
		if (c >= 'A' && c <= 'Z') return c - 'A' + 27;

		return 0;
	}
}