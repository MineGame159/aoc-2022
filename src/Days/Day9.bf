using System;
using System.Collections;

namespace AoC;

class Day9 : Day {
	public this() : base(9) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		Rope<2> rope = scope .();
		rope.Simulate(input);

		output.Append(rope.TailPositions);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		Rope<10> rope = scope .();
		rope.Simulate(input);

		output.Append(rope.TailPositions);
	}

	struct Pos : this(int x, int y), IHashable {
		public int GetHashCode() => x ^ y;

		public static Pos operator+(Pos lhs, Pos rhs) => .(lhs.x + rhs.x, lhs.y + rhs.y);
	}

	class Rope<T> where T : const int {
		private const Pos[?] DIAGONALS = .(.(1, 1), .(-1, 1), .(1, -1), .(-1, -1));

		private Pos[T] knots;
		private HashSet<Pos> tailPositions = new .() ~ delete _;

		public this() {
			tailPositions.Add(Tail);
		}

		private ref Pos Head => ref knots[0];
		private ref Pos Tail => ref knots[T - 1];

		public int TailPositions => tailPositions.Count;

		public void Simulate(List<StringView> input) {
			// Loop all moves
			for (let line in input) {
				// Parse move
				StringSplitEnumerator split = line.Split(' ');

				char8 direction = split.GetNext().Value[0];
				int steps = .Parse(split.GetNext());

				// Simulate steps
				for (int i < steps) {
					// Move head
					switch (direction) {
					case 'R': Head.x++;
					case 'L': Head.x--;
					case 'U': Head.y++;
					case 'D': Head.y--;
					}

					// Move all knots after head
					for (int j < T) {
						if (j == 0) continue;

						MoveIfNeeded(knots[j - 1], ref knots[j]);
					}

					// Add tail position
					tailPositions.Add(Tail);
				}
			}
		}

		private bool IsTouching(Pos head, Pos pos) {
			ClosedRange headRangeX = .(head.x - 1, head.x + 1);
			ClosedRange headRangeY = .(head.y - 1, head.y + 1);

			return headRangeX.Contains(pos.x) && headRangeY.Contains(pos.y);
		}

		private void MoveIfNeeded(Pos head, ref Pos pos) {
			// Check if head and tail are touching
			if (IsTouching(head, pos)) return;

			// Move vertically
			if (head.x == pos.x) {
				if (pos.y > head.y) pos.y--;
				else pos.y++;

				return;
			}

			// Move horizontally
			if (head.y == pos.y) {
				if (pos.x > head.x) pos.x--;
				else pos.x++;

				return;
			}

			// Move diagonally
			for (let diagonal in DIAGONALS) {
				Pos testTail = pos + diagonal;

				if (IsTouching(head, testTail)) {
					pos = testTail;
					return;
				}
			}
		}
	}
}