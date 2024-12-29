# Miloš's Nix-darwin configuration

[<img src="https://daiderd.com/nix-darwin/images/nix-darwin.png" width="200px" alt="logo" />](https://github.com/LnL7/nix-darwin)

# Installation

I followed official [documentation](https://github.com/LnL7/nix-darwin?tab=readme-ov-file#getting-started).

Basically I used following steps:

```
mkdir -p ~/.config/nix-darwin
cd ~/.config/nix-darwin
nix flake init -t nix-darwin
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
nix run nix-darwin -- switch --flake ~/.config/nix-darwin
```

# My considerations

1. I wanted to use Nix packages for everything, but they didnt link to /Applications, so Spotlight didnt work properly
2. Homebrew is nice, so why not to use it? So I did.
   - My setup consists of two sections one for command line / system tools - pkgs.
   - Another one is just for GUI applications - brew.  
3. I want to have as much MacOS configruation in Nix as possible, but there are few things that are impossible:
    -  F1-12 are primary instead to multimedia keys


# Day to day operation

```
vim ~/.config/nix-darwin/flake.nix
darwin-rebuild switch --flake ~/.config/nix-darwin
```

After I feel the changes are right, I commit and push it!



# Sources
- https://evantravers.com/articles/2024/02/06/switching-to-nix-darwin-and-flakes/
