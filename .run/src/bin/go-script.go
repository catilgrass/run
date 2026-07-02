package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	cwd, _ := os.Getwd()
	quoted := make([]string, len(os.Args[1:]))
	for i, a := range os.Args[1:] {
		quoted[i] = fmt.Sprintf("\"%s\"", a)
	}
	args := strings.Join(quoted, ", ")

	fmt.Println()
	fmt.Println("  Welcome to use `run.sh` / `run.ps1`")
	fmt.Println()
	fmt.Println("  > \"Hello World\"")
	fmt.Printf("  > cwd  : \"%s\"\n", cwd)
	fmt.Printf("  > args : %s\n", args)
	fmt.Println()
}
