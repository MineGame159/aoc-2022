using System;
using System.IO;
using System.Collections;

namespace AoC;

class Day7 : Day {
	public this() : base(7) {}

	protected override void CalculateFirst(List<StringView> input, String output) {
		int sum = 0;

		FileSystem fs = scope .();

		fs.Parse(input);
		fs.CalculateDirSizes();

		fs.LoopDirs(scope [&](dir) => {
			if (dir.Size <= 100000) sum += dir.Size;
		});

		output.Append(sum);
	}

	protected override void CalculateSecond(List<StringView> input, String output) {
		// Find all directories that if deleted would free enough space
		FileSystem fs = scope .();

		fs.Parse(input);
		fs.CalculateDirSizes();

		List<FsDir> dirs = scope .();
		fs.LoopDirs(scope (dir) => {
			if (fs.Available + dir.Size >= 30000000) dirs.Add(dir);
		});

		// Get the smallest directory
		dirs.Sort();

		output.Append(dirs[0].Size);
	}

	class FileSystem {
		private FsDir root = new .("/") ~ delete _;

		public int Available => 70000000 - root.Size;

		public void Parse(List<StringView> input) {
			for (let file in scope FileIterator(input)) {
				Add(file);
			}
		}

		public void LoopDirs(delegate void(FsDir dir) callback) {
			LoopDirs(root, callback);
		}

		public void CalculateDirSizes() {
			LoopDirs(scope (dir) => {
				for (let entry in dir.entries.Values) {
					dir.Size += entry.Size;
				}
			});
		}

		private void LoopDirs(FsDir dir, delegate void(FsDir dir) callback) {
			for (let entry in dir.entries.Values) {
				if (entry is FsDir) LoopDirs(entry as FsDir, callback);
			}

			callback(dir);
		}

		private void Add(File file) {
			FsDir dir = root;

			for (let part in file.path.Split('/', .RemoveEmptyEntries)) {
				if (@part.HasMore) {
					IFsEntry entry = dir.Get(part);

					if (entry != null) {
						dir = entry as FsDir;
					}
					else {
						FsDir newDir = new .(part);
						dir.Add(newDir);
						dir = newDir;
					}
				}
				else {
					dir.Add(new FsFile(part, file.size));
				}
			}
		}
	}

	interface IFsEntry {
		StringView Name { get; };
		int Size { get; }
	}

	class FsFile : IFsEntry {
		private String name ~ delete _;
		public int Size { get; private set; };

		public this(StringView name, int size) {
			this.name = new .(name);
			this.Size = size;
		}

		public StringView Name => name;

		public static int operator<=>(Self lhs, Self rhs) => lhs.Size <=> rhs.Size;
	}

	class FsDir : IFsEntry {
		private String name ~ delete _;
		public Dictionary<StringView, IFsEntry> entries = new .();

		public int Size { get; set; };

		public this(StringView name) {
			this.name = new .(name);
		}

		public ~this() {
			for (let entry in entries.Values) delete entry;
			delete entries;
		}

		public StringView Name => name;

		public IFsEntry Get(StringView name) => entries.GetValueOrDefault(name);

		public void Add(IFsEntry entry) => entries[entry.Name] = entry;

		public static int operator<=>(Self lhs, Self rhs) => lhs.Size <=> rhs.Size;
	}

	struct File : this(StringView path, int size) {}

	class FileIterator : IEnumerator<File> {
		private List<StringView> input;

		private int i;
		private String path = new .() ~ delete _;
		private String filePath = new .() ~ delete _;

		public this(List<StringView> input) {
			this.input = input;
		}

		public Result<File> GetNext() {
			while (true) {
				if (i >= input.Count) return .Err;
				StringView line = input[i++];

				if (line.StartsWith("$")) {
					if (line.StartsWith("$ cd ")) {
						StringView dir = line[5...];
	
						switch (dir) {
						case "/":	path.Set("/");
						case "..":	path.RemoveFromEnd(path.Length - path.LastIndexOf('/'));
						default:	path..Append(dir).Append('/');
						}
					}
				}
				else {
					if (!line.StartsWith("dir ")) {
						StringSplitEnumerator split = line.Split(' ');
	
						int size = int.Parse(split.GetNext());
						StringView name = split.GetNext();
	
						return File(filePath..Set(path)..Append(name), size);
					}
				}
			}
		}
	}
}