using System;
using System.Collections;

namespace AoC;

class Day8 : Day {
	public this() : base(8) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		int sum = 0;

		Grid grid = scope .(input);

		// Loop all trees
		for (let pos in grid) {
			// Check if the tree is on an edge
			if (grid.IsOnEdge(pos)) {
				sum++;
				continue;
			}

			// Check visibility from all sides
			visibility: for (let side in Enum.GetValues<Side>()) {
				if (grid.IsVisibleFromSide(pos, side)) {
					sum++;
					break visibility;
				}
			}
		}

		output.Append(sum);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		// Get the score for every tree
		Grid grid = scope .(input);
		List<int> scores = scope .(grid.width * grid.height);

		for (let pos in grid) {
			int score = 1;

			for (let side in Enum.GetValues<Side>()) {
				score *= grid.GetNumberOfVisibleTreesFromSide(pos, side);
			}

			if (score != 0) scores.Add(score);
		}

		// Find the largest score
		scores.Sort();
		output.Append(scores.Back);
	}

	struct Pos : this(int x, int y) {
		public static Pos operator+(Pos lhs, Pos rhs) => .(lhs.x + rhs.x, lhs.y + rhs.y);
	}

	enum Side {
		case Left, Right, Up, Down;

		public Pos Offset { get {
			switch (this) {
			case .Left:		return .(-1, 0);
			case .Right:	return .(1, 0);
			case .Up:		return .(0, 1);
			case .Down:		return .(0, -1);
			}
		} }
	}

	class Grid : IEnumerable<Pos> {
		public int width, height;
		public int[,] trees ~ delete _;

		public this(List<StringView> input) {
			this.width = input[0].Length;
			this.height = input.Count;
			this.trees = new .[width, height];

			for (let line in input) {
				int y = @line.Index;

				for (var tree in line) {
					int x = @tree.Index;

					trees[x, y] = int.Parse(.(&tree, 1));
				}
			}
		}

		public int Get(Pos pos) => trees[pos.x, pos.y];

		public bool IsOnEdge(Pos pos) => pos.x == 0 || pos.y == 0 || pos.x == width - 1 || pos.y == height - 1;
		public bool IsOutside(Pos pos) => pos.x < 0 || pos.y < 0 || pos.x >= width || pos.y >= height;

		public bool IsVisibleFromSide(Pos pos, Side side) {
			var pos;

			int targetHeight = Get(pos);

			while (true) {
				if (IsOnEdge(pos)) break;

				pos += side.Offset;
				if (Get(pos) >= targetHeight) return false;
			}

			return true;
		}

		public int GetNumberOfVisibleTreesFromSide(Pos pos, Side side) {
			var pos;

			if (IsOutside(pos + side.Offset)) return 0;

			int count = 1;
			int targetHeight = Get(pos);

			while (true) {
				pos += side.Offset;
				if (IsOutside(pos) || IsOnEdge(pos) || Get(pos) >= targetHeight) break;

				count++;
			}

			return count;
		}

		public GridEnumerator GetEnumerator() => .(this);
	}

	struct GridEnumerator : IEnumerator<Pos> {
		private Grid grid;
		private int x, y;

		public this(Grid grid) {
			this.grid = grid;
			this.x = -1;
			this.y = 0;
		}

		public Result<Pos> GetNext() mut {
			x++;

			if (x >= grid.width) {
				x = 0;
				y++;

				if (y >= grid.height) {
					return .Err;
				}
			}

			return Pos(x, y);
		}
	}
}