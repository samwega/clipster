/*
Build and place the executable, for example in an Obsidian valut subfolder, and use autohotkey or glazewm to run it from anywhere on your windows desktop. Clipster will append any utf8 text content of your clipboard (timestamped) to a file named `yyyy_mm_dd.md` in the current folder (makes a new one if it does not exist). Currently does not support images.

This calls procs from my shared/lexicon lib (available on my github). I have included a copy of the program with all of the procs included (`clipster_standalone.odin`) - use that one.

My glazewm launch command looks like:
  - commands: ['shell-exec --hide-window cmd /c cd /d C:\Path\to\clipster\folder && clipster.exe']
    bindings: ['alt+v']
*/
package clipster

import "core:fmt"
import "core:os"
import lex "shared:lexicon"

append_to_daily_file :: proc(text: string) -> bool {
	year, month, day := lex.get_local_datetime(.DATE)
	filename := fmt.tprintf("%d_%02d_%02d.md", year, month, day)

	// Open file in append mode (creates if doesn't exist)
	file, err := os.open(filename, os.O_WRONLY | os.O_APPEND | os.O_CREATE, 0o644)
	if err != os.ERROR_NONE {
		return false
	}
	// defer os.close(file) // not really needed, runtime is milliseconds

	hour, minute, second := lex.get_local_datetime(.TIME)
	content := fmt.tprintf("\n\n`%02d:%02d:%02d`\n%s", hour, minute, second, text)

	bytes_written, write_err := os.write_string(file, content)
	return write_err == os.ERROR_NONE && bytes_written > 0
}


main :: proc() {
	text := lex.get_clipboard_text()

	if len(text) > 0 {
		append_to_daily_file(text)
	}
}
