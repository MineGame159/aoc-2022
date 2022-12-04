using System;

namespace AoC;

class Program {
	private static readonly Day[] DAYS = new .(
		new Day1(),
		new Day2(),
		new Day3(),
		new Day4()
	) ~ DeleteContainerAndItems!(_);

	public static void Main() {
		DAYS[DAYS.Count - 1].Run();

		Console.Read();
	}
}