# template.nvim

A minimalist Neovim plugin to automatically insert file templates based on file extensions. Great for competitive programming, boilerplate setup, or project scaffolding.

## ✨ Features

- Detects filetype via extension
- Loads templates from a configurable directory
- Prompts to select if multiple templates match
- Replaces `cursor` marker with live cursor
- Zero dependencies, pure Lua

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "Rational-Idiot/template.nvim",
  lazy = false,
  config = function()
    --This is the default configuration, Change it to your templates directory
    require("template").setup({
      template_directory = vim.fn.stdpath("config") .. "/templates"
    })
    --Call :Template for the plugin
    --Uncomment the following to set the keymap
    -- vim.keymap.set("n", "<leader>ct", "<cmd>Template<CR>", { desc = "Insert file template" })
  end,
}
```

## 🗂️ Template Format

Place template files inside your configured directory, named like:

cp.cpp
ai.py
utility.sh

Have a line that says just "\_\_cursor\_\_" {it can also be commented} to mark the positio where you want to be placed after the template is inserted

Example:

```cpp
# include <iostream>

using namespace std;

int main() {
    __cursor__
return 0;
}
```

The line containing cursor will be trimmed to just its indentation, and the cursor will be moved there in insert mode.

## 🚀 Usage

    Open a new file with a any extension that you have a template for

    Press <leader>ct (or run :Template)

    Select a matching template (if multiple)

    Done!

## 📁 Example Template Directory
```plaintext
~/.config/nvim/lua/templates/
├── ai.py
├── cp.cpp
├── game.cpp
└── operation.fish
```
## 💡 Tips

    Supports multiple templates per extension — you'll get a picker.
    Use telescope and telescope-ui-select for a better experience

    Use it with snippets for even more power.

## 📜 License

    MIT
