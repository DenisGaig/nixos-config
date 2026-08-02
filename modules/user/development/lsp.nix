{pkgs, ...}: {
  home.packages = with pkgs; [
    astro-language-server
    bash-language-server
    lua-language-server
    markdown-oxide
    vscode-langservers-extracted
    yaml-language-server
  ];
}
