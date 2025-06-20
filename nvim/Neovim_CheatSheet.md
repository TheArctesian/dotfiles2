Neovim with Lazy.nvim Cheatsheet
General Neovim Basics

    Leader Key: <Space> (used as the prefix for many custom mappings)
    Save File: <leader>w (saves the current file with :w)
    Quit Neovim: <leader>q (quits with :q)
    Clear Search Highlights: <leader>h (clears search highlighting with :nohlsearch)
    Scroll with Cursor Centered: <C-d> (scroll down, cursor centered), <C-u> (scroll up, cursor centered)

Lazy.nvim Plugin Management

    Open Lazy UI: :Lazy (opens the Lazy.nvim interface to manage plugins)
    Sync Plugins: :Lazy sync (installs/updates all plugins defined in init.lua)
    Update Plugins: :Lazy update (updates plugins to their latest versions)
    Check for Updates: :Lazy check (checks for plugin updates without installing)
    Profile Performance: :Lazy profile (profiles plugin load times to optimize startup, as per lazy.nvim GitHub features)
    Clean Unused Plugins: :Lazy clean (removes plugins not defined in init.lua)

File Navigation with Telescope

    Find Files: <leader>ff (opens Telescope to search for files)
    Live Grep (Search Text): <leader>fg (searches text across files with live grep)
    List Buffers: <leader>fb (shows open buffers in Telescope)
    Help Tags: <leader>fh (searches Neovim help tags)

File Tree with Nvim-Tree

    Toggle File Explorer: <leader>e (opens/closes Nvim-Tree file explorer)

LSP (Language Server Protocol) Commands

    Check LSP Status: :LspInfo (displays information about active language servers like ts_ls, pyright, etc.)
    Format Buffer (LSP): Automatically formats on save (via BufWritePre autocmd with vim.lsp.buf.format())
    Manual Format (LSP): :lua vim.lsp.buf.format() (manually formats the current buffer using LSP)
    Go to Definition: gd (default LSP mapping, jumps to definition if supported by the language server)
    Hover Documentation: K (default LSP mapping, shows hover info for the symbol under cursor)
    Diagnostics: :lua vim.diagnostic.open_float() (shows diagnostics for the current line in a floating window)

Formatting with Formatter.nvim

    Format on Save: Automatically formats on save (via BufWritePost autocmd with FormatWrite)
    Manual Format: :FormatWrite (manually formats the current buffer using formatter.nvim settings for languages like Python, TypeScript, etc.)

Git Integration with Gitsigns.nvim

    View Git Status: :Gitsigns (shows git status or diff in the sign column, configured via gitsigns.nvim)
    Blame Line: :Gitsigns blame_line (shows who last modified the current line)
    Next Hunk: ]c (jumps to the next git change/hunk, default mapping from gitsigns.nvim)
    Previous Hunk: [c (jumps to the previous git change/hunk)

Buffer and Tab Management with Bufferline

    Cycle Buffers: :BufferLineCycleNext (moves to next buffer tab)
    Cycle Buffers Back: :BufferLineCyclePrev (moves to previous buffer tab)
    Close Buffer: :BufferLineCloseRight or :BufferLineCloseLeft (closes buffers to the right or left of current)

Treesitter (Syntax Highlighting)

    Update Parsers: :TSUpdate (updates Treesitter parsers for languages defined in ensure_installed, requires a C compiler like gcc)
    Check Treesitter Status: :TSModuleInfo (shows status of Treesitter modules)

Transparency and Theme

    Theme: Atom One Dark (onedark.nvim) with transparency enabled (background set to none for full transparency)
    Verify Transparency: Ensure your terminal (e.g., alacritty) and compositor (e.g., picom) support transparency. Adjust settings if the background isn't transparent.

Troubleshooting

    Check Lazy.nvim Errors: :Lazy log (views the log for plugin installation or loading errors)
    Debug LSP Issues: :LspLog (views LSP logs for debugging language server issues)
    Suppress Warnings (Temporary): If deprecation warnings like "Feature will be removed in lspconfig 0.2.1" persist, monitor nvim-lspconfig GitHub for updates. Optionally, add vim.lsp.log.set_level(vim.log.levels.OFF) at the end of init.lua to hide warnings (not recommended long-term).
    C Compiler Error: If you see "No C compiler found" when running :TSUpdate, ensure gcc is installed in your NixOS environment (should be added via environment.systemPackages as previously provided).

Requirements (from lazy.nvim GitHub)

Ensure your system meets these requirements for lazy.nvim to work optimally:

    Neovim Version: >= 0.8.0 (check with nvim --version)
    Git Version: >= 2.19.0 (check with git --version, needed for partial clones)
    Nerd Font: Optional for icons (already in your NixOS config as nerdfonts.jetbrains-mono)


