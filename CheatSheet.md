# My Neovim Cheat Sheet

## Text Editing & Replace
Replace text: Select + `p`
Format code: `<space>f`
Format selection: Select + `<space>F`

## File Management
File explorer: `<space>ee`
Find files: `<space>sf`
Search text: `<space>sg`
Open nvim config: `<space>sn`

## File Navigation
Switch between files: `Ctrl-^`
Find buffers: `<space><space>`
Search in current file: `<space>/`
Go back in history: Ctrl-O
Go forward in history: Ctrl-I
View jump history: :jumps
Jump to exact last spot: ``` `` ```
Last edit location: ``` `. ```
Jump to matching bracket: `%`

## Text Editing Magic
Replace inside quotes with clipboard: `vi"` then `p`
Re-indent selection: Select with `V` → `=`
Reformat text: Select with `V` → `gq`
Replace current word: `ciw`
Replace word with clipboard: `vep`
Replace word + whitespace: `
Replace inside parentheses: ci(
Replace around parentheses: ca(
Replace inside brackets: ci[
Replace inside braces: ci{: `caw`
Undo: `u`
Redo: `Ctrl-r`
Go to older text state: `g-`
Go to newer text state: `g+`
Delete inside parentheses: `di(`
Delete backwards until ": `dT"`
Delete until ": `dF"`

## Text Selection
Select inside quotes: `vi"`
Select inside single quotes: `vi'`
Select inside parentheses: `vi(`
Select inside square brackets: `vi[`
Select inside curly braces: `vi{`
Select inside angle brackets: `vi<`
Select inside HTML/XML tags: `vit`
Select around (includes surroundings): `va"`, `va(`, `va[`, etc.

## Surrounding Text (mini.surround)
Add surrounding: `sa` (example: `saiw"` = surround word with quotes)
Delete surrounding: `sd` (example: `sd"` = remove quotes)
Replace surrounding: `sr` (example: `sr"'` = change quotes to single quotes)
Find surrounding: `sf` / `sF`
Highlight surrounding: `sh`

## CopilotChat (AI Assistance)
Toggle chat: `<space>cc`
Quick chat: `<space>cq`
Explain code: `<space>ce` (normal/visual)
Review code: `<space>cr` (normal/visual)
Fix code: `<space>cf` (normal/visual)
Optimize code: `<space>co` (normal/visual)
Generate docs: `<space>cd` (normal/visual)
Generate tests: `<space>ct` (normal/visual)
Fix diagnostic: `<space>cD`
Commit message: `<space>cm`
Commit staged: `<space>cM`
Inline chat: `<space>ci` (visual mode)
Help actions: `<space>ch`
Prompt actions: `<space>cp` (normal/visual)

## Copilot Suggestions
Accept suggestion: `Tab`
Next suggestion: `Ctrl-n`
Previous suggestion: `Ctrl-p`
Dismiss suggestion: `Ctrl-d`
Open panel: `Alt-Enter`

## Difi (Inline Diff Review)
Toggle diff vs HEAD: `<space>df`
Diff vs main: `:Difi main`
Diff vs previous commit: `:Difi HEAD~1`
Accept addition: leave green `+` line
Reject addition: `dd` on green line
Confirm deletion: leave red `-` line
Restore deletion: delete the `-` marker
Finalize edits: `:Difi` again
Health check: `:DifiHealth`

## Memory Tips
- **Visual + action** (select first, then format/replace)
- **`s` = Surround operations** (sa/sd/sr for add/delete/replace)
- **`c` = Change** (ciw = change inner word)

## Quick Reference Links
- [Format selection guide](https://www.reddit.com/r/neovim/comments/11biinx/format_selection_instead_of_entire_file/)
- [Change word with paste](https://unix.stackexchange.com/questions/88714/how-can-i-do-a-change-word-in-vim-using-the-current-paste-buffer)
- [Mini.surround docs](https://github.com/echasnovski/mini.surround)
