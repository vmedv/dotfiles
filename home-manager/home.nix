{ pkgs, ...}: 
{
  home.username = "vmedv";
  home.homeDirectory = "/home/vmedv";
  home.stateVersion = "24.05";
  home.packages = with pkgs; [ 
    alacritty 
    neovim
    telegram-desktop 
    rofi 
    spotify
    steam
    openvpn
    htop
    xsecurelock
    light
  ]++
  ( with haskellPackages; [ 
    xmobar
  ]) ++ [
    obs-studio
    openjdk11
    pavucontrol
    ripgrep
    mpv
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
  };
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "ivan medvedev";
    userEmail = "vmedvedev1017@gmail.com";
  };
  programs.alacritty = {
    enable = true;
    settings = {
      window.decorations = "None";
      font.size = 6;
      env.TERM = "xterm-256color";
    };
  };
  programs.firefox = {
    enable = true;
  };
  programs.fzf.enable = true;
  programs.fish.enable = true;
  programs.zathura.enable = true;
  services.screen-locker = {
    enable = true;
    lockCmd = "xlock -mode blank";
  };
  services.flameshot.enable = true;
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Inconsolata";
        markup = "full";
        format = "<b>%s</b>\\n%b";
        icon_position = "left";
        sort = true;
        alignment = "center";
        geometry = "500x60-15+49";
        browser = "firefox -new-tab";
        transparency = 10;
        word_wrap = true;
        show_indicators = false;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;
        separator_color = "frame";
        frame_width = 2;
      };
      urgency_low = {
        frame_color = "#3B7C87";
        foreground = "#3B7C87";
        background = "#191311";
        timeout = 4;
      };
      urgency_normal = {
        frame_color = "#5B8234";
        foreground = "#5B8234";
        background = "#191311";
        timeout = 6;
      };
      urgency_critical = {
        frame_color = "#B7472A";
        foreground = "#B7472A";
        background = "#191311";
        timeout = 8;
      };
    };
  };
}
