{
  description = "Milosuv Macbook";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
      };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      # https://search.nixos.org/packages
      environment.systemPackages =
        [ 
	 # CLI goodies
	  pkgs.vim pkgs.neofetch pkgs.htop pkgs.git pkgs.jq pkgs.mc pkgs.ranger

	  #DevOps
	  pkgs.docker pkgs.colima pkgs.k9s pkgs.kubectl pkgs.kubectx pkgs.awscli

	  # Python development
	  pkgs.poetry pkgs.uv pkgs.cargo
        ];
      environment.variables = {
	EDITOR = "vim";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnsupportedSystem = true;
      nixpkgs.config.allowBroken = true;

      # Security
      security.pam.enableSudoTouchIdAuth = true;
      
      # User-inteface 
      system.defaults.trackpad.Clicking = true;
      system.defaults.trackpad.TrackpadThreeFingerDrag = true;
      system.defaults.trackpad.TrackpadRightClick = true;
      system.defaults.WindowManager.EnableTiledWindowMargins = false;
      system.defaults.controlcenter.FocusModes = false;
      system.defaults.dock.appswitcher-all-displays = true;
      system.defaults.dock.scroll-to-open = true;
      system.defaults.dock.tilesize = 48;
      system.defaults.dock.wvous-tl-corner = 1;
      system.defaults.dock.wvous-br-corner = 1;
      system.defaults.finder.ShowStatusBar = null;
      system.defaults.finder.ShowPathbar = true;
      system.defaults.finder.FXRemoveOldTrashItems = true;
      system.defaults.finder.AppleShowAllExtensions = true;
      system.defaults.finder.NewWindowTarget = "Documents";
      system.defaults.finder.QuitMenuItem = true;

      # CLI programs
      programs.tmux.enable = true;
      programs.tmux.enableSensible = true;
      programs.tmux.enableMouse = true;
      programs.tmux.enableFzf = true;
      programs.tmux.enableVim = true;

      programs.tmux.extraConfig = ''
         bind 0 set status
         bind S choose-session

   	 bind-key -r "<" swap-window -t -1
	 bind-key -r ">" swap-window -t +1
      '';

      # ZSH
      programs.zsh.enable = true;
      programs.zsh.enableBashCompletion = true;
      programs.zsh.enableFzfCompletion = true;
      programs.zsh.ohMyZsh = {
	enable = true;
        theme = "cloud";
	plugins = ["git" "poetry" "kubectl"];
      };

      # Homebrew
      homebrew = {
	enable = true;
	casks = [
	  # Desktop basics
	  "1password" "1password-cli" "firefox" "easy-move+resize" "spotify" "synology-drive" "messenger"
	  
	  # Development tools
	  "jetbrains-toolbox" "visual-studio-code" "sublime-text"

	  # Productivity 
	  "obsidian"

	  # Privacy
	  "tailscale"

	  # Networking
	  "winbox"
	];
      }; 
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Milos--MacBook-Pro
    darwinConfigurations."Milos--MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ 
	configuration 
	./modules/programs/zsh/oh-my-zsh.nix
      ];
    };
  };
}
