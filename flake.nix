{
  description = "i have no idea how this works";

  inputs = {
    # Package sources.
    master.url = "github:nixos/nixpkgs/master";
    stable.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # spicetify-nix.url = "github:the-argus/spicetify-nix";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";

    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    # nix-gaming.url = "github:fufexan/nix-gaming";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
    };
    hyprland.url = "github:hyprwm/Hyprland";

    ags.url = "github:ozwaldorf/ags";

    darkmatter.url = "gitlab:VandalByte/darkmatter-grub-theme";

    matugen = {
      url = "github:/InioX/Matugen";
    };

    swayfx = {
      url = "github:/WillPower3309/swayfx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swayhide.url = "github:/rehanzo/swayhide";
  };
  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      dotdir = "$HOME/.dotfiles";
      secrets = builtins.fromJSON (builtins.readFile ./secrets/common.json);
      forSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nixos-apple-silicon.overlays.default ];
      };
    in
    {
      formatter = pkgs.nixfmt-rfc-style;
      overlays = import ./overlays { inherit inputs; };
      # host configurations
      nixosConfigurations = {
        frostbyte = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit
              inputs
              outputs
              dotdir
              secrets
              ;
          };
          modules = [
            # > Our main nixos configuration file <
            inputs.home-manager.nixosModule
            inputs.darkmatter.nixosModule
            inputs.nixos-apple-silicon.nixosModules.default
            inputs.lix-module.nixosModules.default
            ./hosts/frostbyte/configuration.nix
          ];
        };
        focusflake = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            # > Our main nixos configuration file <
            inputs.home-manager.nixosModule
            inputs.darkmatter.nixosModule
            ./hosts/focusflake/configuration.nix
          ];
        };
      };

      homeConfigurations = {
        quinn = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit
              inputs
              outputs
              dotdir
              secrets
              self
              ;
          };
          modules = [
            ./home/quinn/home.nix
          ];
        };
      };

      frostbyte = self.nixosConfigurations.frostbyte.config.system.build.toplevel;
    };
}
