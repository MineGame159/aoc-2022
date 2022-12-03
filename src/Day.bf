using System;
using System.IO;
using System.Collections;
using System.Diagnostics;

namespace AoC;

abstract class Day {
	public readonly int number;

	public this(int number) {
		this.number = number;
	}

	public void Run() {
		// Get input
		String rawInput = File.ReadAllText(scope $"input/{number}.txt", .. scope .());
		List<StringView> input = scope .();

		for (let line in LineEnumerator(rawInput.Split('\n'))) {
			input.Add(line);
		}

		// Calculate results
		Console.WriteLine("-- Day {} -- ", number);
		Console.WriteLine();
		Console.WriteLine("Results:");

		TimeSpan first = .Zero;
		TimeSpan second = .Zero;

		// Calculate first
		String output = scope .();
		Stopwatch sw = scope .();

		sw.Start();
		CalculateFirst(input, output);
		sw.Stop();

		if (!output.IsEmpty) {
			Console.WriteLine("    First:  {}", output);
			first = sw.Elapsed;
		}

		// Calculate second
		output.Clear();

		sw.Restart();
		CalculateSecond(input, output);
		sw.Stop();

		if (!output.IsEmpty) {
			Console.WriteLine("    Second: {}", output);
			second = sw.Elapsed;
		}

		// Print time
		Console.WriteLine();
		Console.WriteLine("Time:");

		if (first != .Zero) Console.WriteLine("    First:  {} ms", first.TotalMilliseconds);
		if (second != .Zero) Console.WriteLine("    Second: {} ms", second.TotalMilliseconds);
	}

	protected abstract void CalculateFirst(List<StringView> input, String output);
	
	protected abstract void CalculateSecond(List<StringView> input, String output);
}

struct LineEnumerator : IEnumerator<StringView> {
	private StringSplitEnumerator enumerator;

	public this(StringSplitEnumerator enumerator) {
		this.enumerator = enumerator;
	}

	public bool HasMore => enumerator.HasMore;

	public Result<StringView> GetNext() mut {
		switch (enumerator.GetNext()) {
		case .Ok(let val): return val.EndsWith('\r') ? val[...^2] : val;
		case .Err:         return .Err;
		}
	}
}