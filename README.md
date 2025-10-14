Build and place the executable, for example in an Obsidian valut subfolder, and use autohotkey or glazewm to run it from anywhere on your windows desktop. Clipster will append any utf8 text content of your clipboard (timestamped) to a file named `yyyy_mm_dd.md` in the current folder (makes a new one if it does not exist). Currently does not support images.

`clipster.odin` calls procs from my shared/lexicon lib (available on my github). I have included a batteries included copy of the script with all of the procs (`clipster_standalone.odin`) - use that one.

My glazewm launch command looks like:
```
  - commands: ['shell-exec --hide-window cmd /c cd /d C:\Path\to\clipster\folder && clipster.exe']
    bindings: ['alt+v']
```

The autohotkey command should be similar, I haven't tried.

<img width="885" height="878" alt="clipster obsidian clipboard dump" src="https://github.com/user-attachments/assets/a798c3ee-a427-4f4d-8518-bbe3ff406a6d" />
