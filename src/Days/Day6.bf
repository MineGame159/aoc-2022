using System;
using System.Collections;

namespace AoC;

class Day6 : Day {
	public this() : base(6) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		output.Append(GetFirstMarker(input[0], 4));
	}
	
	protected override void CalculateSecond(List<StringView> input, String output) {
		output.Append(GetFirstMarker(input[0], 14));
	}

	private int GetFirstMarker(StringView input, int length) {
		HashSet<char8> set = scope .();
		
		for (int i < input.Length) {
			for (int j < length) {
				set.Add(input[i + j]);
			}

			if (set.Count == length) return i + length;

			set.Clear();
		}

		return -1;
	}
}