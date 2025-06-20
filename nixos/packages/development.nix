{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Programming languages and tools
    git
    go
    rustc
    nodejs
    yarn
    python3
    cargo
    gcc
    mpv
    
    # Neovim formatter dependencies
    stylua          # Lua formatter
    nodePackages.prettier  # JavaScript/TypeScript formatter
    black           # Python formatter

    # Neovim language server dependencies
    pyright         # Python language server
    gopls           # Go language server
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server
    nodePackages.vscode-langservers-extracted
    
    # Editors
    emacs
  ];
}
