{ pkgs, ... }:

{

  fonts.fontconfig.enable = true;

  home.stateVersion = "26.05";
  home.sessionVariables = {
    SSH_AUTH_SOCK = "$HOME/.1password/agent.sock";
  };
  
  xdg.desktopEntries.fastmail = {
    name = "Fastmail";
    comment = "Fastmail Web Client";
    exec = "${pkgs.brave}/bin/brave --app=https://app.fastmail.com --ozone-platform-hint=auto";
    icon = "mail-client";
    terminal = false;
    categories = [ "Network" "Email" ];
  };
  
  home.packages = with pkgs; [
    ripgrep
    htop

    #fonts
    nerd-fonts.departure-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    nerd-fonts.terminess-ttf
    nerd-fonts.gohufont
    #nordwand-mono
    #nerd-fonts.paper-mono

    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome

    #browser
    google-chrome
    brave

    wlogout
    vlc
    #fastmail-desktop
    drawio

    #video & streaming
    obs-studio
    pkgs.kdePackages.kdenlive
    #davinci-resolve
    blender
    handbrake
    ffmpeg

    #audio
    audacity
    ardour
    easyeffects

    #graphics & design
    gimp
    inkscape
    krita
  ]; 
  


  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
    };
  };

  # 2. Configure GTK 3 & GTK 4 dark theme
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # 3. Configure Qt applications to match dark styling
  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  programs.git = {
    enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };

    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --graph --oneline --decorate --all";
    };
  };

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableFishIntegration = true;

    settings = {
      theme = "Black Metal (Bathory)";
      font-size = 12;
      background-opacity = 0.95;
      #font-family = "Terminess Nerd Font Mono";
      font-family = "FiraCode Nerd Font Mono";
      #font-family = "GohuFont 14 Nerd Font";
    };
  };


  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      plenary-nvim
      telescope-nvim
    ];

    initLua = ''
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.shiftwidth = 2
    '';
  };

  programs.firefox = {
    enable = true;
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host *
	IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.bash = {
    enable = true;
    initExtra = ''
      export SSH_AUTH_SOCK="$HOME/.1password/agent.sock";
    '';
  };

  programs.lazygit = {
    enable = true;

    settings = {
      gui = {
	nerdFontsVersion = "3";
	showBottomLine = true;
      };
      git = {
	paging = {
	  colorArg = "always";
	  pager = "delta --dark --paging=never";
	};
      };
    };
  };


}
