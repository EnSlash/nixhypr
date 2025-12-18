# /home/iershov/git/nixconf/overlays.nix
{ unstable }: self: super: {
  # Here we can override or add packages.
  # Example: take vscode from unstable
  vscode = unstable.vscode;
  "code-cursor" = unstable.code-cursor;
  "gemini-cli" = unstable.gemini-cli;
  "zoom-us" = unstable.zoom-us;
  winbox4 = unstable.winbox4;

  # Your Python package
  dvPythonEnvTest = unstable.python313.withPackages (ps: with ps; [
    #ciscoconfparse2
    ntc-templates
    netmiko
    colorama
    aiofiles
    tabulate
  ]);
}
