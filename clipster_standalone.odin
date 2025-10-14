package clipster

import "core:fmt"
import "core:os"
import "core:time"
import win "core:sys/windows"
import tz "core:time/timezone"

get_clipboard_text :: proc() -> string {
    if win.OpenClipboard(nil) == false {
        return ""
    }

    handle := win.GetClipboardData(13)
    ptr := win.GlobalLock(win.HGLOBAL(handle))
    wstr: win.wstring = cast(win.wstring)ptr
    result, _ := win.wstring_to_utf8_alloc(wstr, -1)
    win.GlobalUnlock(win.HGLOBAL(handle))
    return result
}

TimeComponent :: enum {
    DATE,
    TIME,
}
/* Specify components to return. Call the proc like:

`get_current_local_datetime(.DATE)` or `get_current_local_datetime(.TIME)` */
get_local_datetime :: proc(component: TimeComponent) -> (int, int, int) {
    now := time.now()
    datetime, _ := time.time_to_datetime(now)
    region, _ := tz.region_load("local", context.allocator)
    if region != nil {
        datetime, _ = tz.datetime_to_tz(datetime, region)
    }
    
    switch component {
    case .DATE:
        return int(datetime.year), int(datetime.month), int(datetime.day)
    case .TIME:
        return int(datetime.hour), int(datetime.minute), int(datetime.second)
    }
    
    return 0, 0, 0
}

append_to_daily_file :: proc(text: string) -> bool {
	year, month, day := get_local_datetime(.DATE)
	filename := fmt.tprintf("%d_%02d_%02d.md", year, month, day)

	// Open file in append mode (creates if doesn't exist)
	file, err := os.open(filename, os.O_WRONLY | os.O_APPEND | os.O_CREATE, 0o644)
	if err != os.ERROR_NONE {
		return false
	}
	// defer os.close(file) // not really needed, runtime is milliseconds

	hour, minute, second := get_local_datetime(.TIME)
	content := fmt.tprintf("\n\n`%02d:%02d:%02d`\n%s", hour, minute, second, text)

	bytes_written, write_err := os.write_string(file, content)
	return write_err == os.ERROR_NONE && bytes_written > 0
}


main :: proc() {
	text := get_clipboard_text()

	if len(text) > 0 {
		append_to_daily_file(text)
	}
}
