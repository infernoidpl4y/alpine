cat > ~/.config/kitty/kitty-nodbus.conf << 'EOF'
# Desactivar integraciones problemáticas
enable_audio_bell no
macos_option_as_alt no
linux_display_server x11
wayland_titlebar_color background

# Apariencia básica
font_size 12
font_family monospace
background_opacity 0.95

# Desactivar features que necesitan DBus
update_check_interval 0
EOF

kitty --config ~/.config/kitty/kitty-nodbus.conf
