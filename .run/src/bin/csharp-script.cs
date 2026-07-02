Console.WriteLine("");
Console.WriteLine("  Welcome to use `run.sh` / `run.ps1`");
Console.WriteLine("");
Console.WriteLine("  > \"Hello World\"");
Console.WriteLine("  > cwd  : \"{0}\"", Environment.CurrentDirectory);
var argStr = args.Length > 0 ? string.Join(", ", args.Select(a => $"\"{a}\"")) : "";
Console.WriteLine("  > args : {0}", argStr);
Console.WriteLine("");
