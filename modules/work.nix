{ config, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (config.gizmo) work;

  # Custom codeownership plugin
  codeowners = pkgs.vimUtils.buildVimPlugin {
    name = "vim-codeowners";
    src = builtins.fetchGit {
      url = "git@github.com:discord/vim-codeowners.git";
      rev = "ff6d2ad447d17f5c7eaf64fb99a77d1afaa02eda";
    };
  };
in
{
  config = mkIf work {
    home = {
      packages = [
        # Tool for managing k8s contexts and namespaces
        pkgs.kubectx
        pkgs.docker-compose
      ];
      sessionVariables = {
        # Used by Clyde to install the updated nix version
        USE_NEW_NIX = "1";
      };
    };

    programs.zsh.initExtra = ''
      if [ -e $HOME/.anthropic_api_key ]
      then
          export ANTHROPIC_API_KEY="$(cat $HOME/.anthropic_api_key)"
      fi
    '';


    # Disable oh-my-zsh git prompt statuses because they're slow on the monorepo
    programs.git.extraConfig = {
      oh-my-zsh = {
        hide-status = 1;
        hide-dirty = 1;
      };
    };

    programs.nixvim = {
      # Enable some LSPs for I only care about at work
      plugins = {
        avante.enable = true;
        lsp.servers = {
          bashls.enable = true;
          terraformls.enable = true;
          dockerls.enable = true;
          docker_compose_language_service.enable = true;
          elixirls.enable = true;
        };
      };

      extraPlugins = [ codeowners ];

      keymaps = [
        {
          key = "<leader>co";
          action = ":CodeownersWhoOwns<CR>";
          mode = "n";
        }
        {
          key = "<leader>ct";
          action = ":CodeownersGotoTeamDefinition<CR>";
          mode = "n";
        }
        {
          key = "<leader>co";
          action = ":CodeownersGotoTeamHelpChannel<CR>";
          mode = "n";
        }
        {
          key = "<leader>C";
          action = ":FloatermNew --width=0.9 --height=0.9 clyde tui<CR>";
          mode = "n";
        }
      ];
    };
  };
}
