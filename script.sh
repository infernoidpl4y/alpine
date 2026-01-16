# Instalar
sudo xbps-install rxvt-unicode

# Configuración avanzada (~/.Xresources)
cat > ~/.Xresources << 'EOF'
! URxvt - Altamente personalizable
URxvt*font: xft:FiraCode Nerd Font:size=11, xft:DejaVu Sans Mono:size=11
URxvt*boldFont: xft:FiraCode Nerd Font:bold:size=11
URxvt*italicFont: xft:FiraCode Nerd Font:italic:size=11
URxvt*letterSpace: -1

! Colores (Catppuccin Mocha)
URxvt*background: #1e1e2e
URxvt*foreground: #cdd6f4
URxvt*color0:  #45475a
URxvt*color1:  #f38ba8
URxvt*color2:  #a6e3a1
URxvt*color3:  #f9e2af
URxvt*color4:  #89b4fa
URxvt*color5:  #f5c2e7
URxvt*color6:  #94e2d5
URxvt*color7:  #bac2de
URxvt*color8:  #585b70
URxvt*color9:  #f38ba8
URxvt*color10: #a6e3a1
URxvt*color11: #f9e2af
URxvt*color12: #89b4fa
URxvt*color13: #f5c2e7
URxvt*color14: #94e2d5
URxvt*color15: #a6adc8

! Transparencia (sin GPU!)
URxvt*depth: 32
URxvt*background: [95]#1e1e2e

! Comportamiento
URxvt*saveLines: 10000
URxvt*scrollBar: false
URxvt*scrollTtyOutput: false
URxvt*scrollWithBuffer: true
URxvt*scrollTtyKeypress: true
URxvt*termName: xterm-256color
URxvt*keysym.C-Up: \033[1;5A
URxvt*keysym.C-Down: \033[1;5B
URxvt*perl-ext-common: default,matcher

! Click en URLs
URxvt*url-launcher: firefox
URxvt*matcher.button: 1
EOF

# Cargar configuración
xrdb -merge ~/.Xresources

# Iniciar
urxvt
