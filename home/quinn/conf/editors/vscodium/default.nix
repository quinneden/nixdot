{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      # pr1sm8.theme-panda
      jeff-hykin.better-nix-syntax
      kamadorueda.alejandra
      mkhl.direnv
    ];
    userSettings = {
      "alejandra.program" = "alejandra";
      "breadcrumbs.enabled" = true;
      "editor.fontFamily" = "'CaskaydiaCove NF'";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 15;
      "editor.formatOnPaste" = true;
      "editor.formatOnSave" = true;
      "editor.formatOnType" = false;
      "editor.minimap.enabled" = false;
      "editor.mouseWheelZoom" = false;
      "editor.renderControlCharacters" = false;
      "editor.scrollbar.horizontal" = "hidden";
      "editor.scrollbar.horizontalScrollbarSize" = 2;
      "editor.scrollbar.vertical" = "hidden";
      "editor.scrollbar.verticalScrollbarSize" = 2;
      "explorer.confirmDragAndDrop" = true;
      "explorer.openEditors.visible" = 1;
      "extensions.autoUpdate" = true;
      "files.autoSave" = "off";
      "update.mode" = "none";
      "window.titleBarStyle" = "custom";
      "workbench.colorTheme" = "Panda Syntax";
      "workbench.editor.limit.enabled" = true;
      "workbench.editor.limit.perEditorGroup" = true;
      "workbench.editor.limit.value" = 10;
      "workbench.layoutControl.enabled" = true;
      "workbench.layoutControl.type" = "menu";
      "workbench.startupEditor" = "none";
      "workbench.statusBar.visible" = true;
      "window.customTitleBarVisibility" = "auto";
      "editor.tabSize" = 2;
      "terminal.integrated.fontFamily" = "'CaskaydiaCove NF'";
      "terminal.integrated.fontSize" = "16";
      "terminal.integrated.fontWeight" = "300";
      "terminal.integrated.fontWeightBold" = "500";
      "terminal.integrated.defaultProfile.linux" = "zsh";
    };
    keybindings = [
      {
        key = "ctrl+/";
        command = "editor.action.commentLine";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+shift+/";
        command = "editor.action.blockComment";
        when = "editorTextFocus && !editorReadonly";
      }
      {
        key = "ctrl+s";
        command = "workbench.action.files.saveFiles";
      }
      {
        key = "meta+s";
        command = "workbench.action.files.saveFiles";
      }
      {
        key = "meta+shift+w";
        command = "workbench.action.terminal.toggleTerminal";
        when = "terminal.active";
      }
      {
        key = "ctrl+w";
        command = "";
      }
      {
        key = "ctrl+d";
        command = "editor.action.duplicateSelection";
      }
      {
        key = "meta+shift+e";
        command = "workbench.view.explorer";
        when = "viewContainer.workbench.view.explorer.enabled";
      }
      {
        key = "meta+shift+f";
        command = "workbench.action.findInFiles";
      }
    ];
  };
}
