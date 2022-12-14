using System;

namespace AoC;

class Program {
	private static readonly Day[] DAYS = new .(
		new Day1(),
		new Day2(),
		new Day3(),
		new Day4(),
		new Day5(),
		new Day6(),
		new Day7(),
		new Day8(),
		new Day9(),
		new Day10()
	) ~ DeleteContainerAndItems!(_);

	public static void Main() {
		DAYS[DAYS.Count - 1].Run();

		Console.Read();
	}
}