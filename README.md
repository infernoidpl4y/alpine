# Archivo: ~/.config/sxhkd/sxhkdrc
#
# Configuración para Void Linux con Urxvt, rofi, Thunar, ranger, polybar y picom
#

# ====================== #
#  Variables comunes     #
# ====================== #
TERMINAL="urxvt"
LAUNCHER="rofi -show drun"
FILE_MANAGER="thunar"
TERMINAL_FILE_MANAGER="ranger"
BROWSER="firefox"  # Cambia según tu navegador

# ====================== #
#  Atajos de teclado     #
# ====================== #

# ----------------------
# Lanzadores y aplicaciones
# ----------------------

# Lanzador de aplicaciones (rofi)
super + space
    $LAUNCHER

# Terminal
super + Return
    $TERMINAL

# Terminal con ranger
super + shift + r
    $TERMINAL -e $TERMINAL_FILE_MANAGER

# Navegador web
super + w
    $BROWSER

# Gestor de archivos GUI
super + e
    $FILE_MANAGER

# ----------------------
# Ventanas y escritorios
# ----------------------

# Cerrar ventana
super + q
    bspc node -c

# Modo monocle (ventana a pantalla completa)
super + m
    bspc desktop -l next

# Alternar ventana flotante
super + shift + space
    bspc node -t floating

# Alternar tiled/pseudo-tiled
super + t
    bspc node -t tiled

# Cambiar foco de ventana
super + {h,j,k,l}
    bspc node -f {west,south,north,east}

# Mover ventana
super + shift + {h,j,k,l}
    bspc node -v {west,south,north,east}

# ----------------------
# Cambio de escritorio
# ----------------------

# Cambiar a escritorio 1-9
super + {1-9}
    bspc desktop -f {1-9}

# Enviar ventana a escritorio 1-9
super + shift + {1-9}
    bspc node -d {1-9}

# ----------------------
# Redimensionar ventanas
# ----------------------

# Entrar en modo resize
super + r
    bspc node -t resize

# En modo resize:
#   h,j,k,l para redimensionar
#   Escape para salir del modo

# Alternativa: redimensionar con atajos directos
super + ctrl + {h,j,k,l}
    bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

super + ctrl + shift + {h,j,k,l}
    bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

# ----------------------
# Configuración del sistema
# ----------------------

# Recargar sxhkd
super + Escape
    pkill -USR1 -x sxhkd

# Recargar bspwm
super + alt + r
    bspc wm -r

# ----------------------
# Polybar control
# ----------------------

# Alternar polybar (toggle)
super + b
    ~/.config/polybar/launch.sh  # Ajusta esta ruta según tu configuración

# Recargar polybar
super + shift + b
    pkill polybar && ~/.config/polybar/launch.sh

# ----------------------
# Picom control
# ----------------------

# Alternar compositor (picom)
super + shift + p
    if pgrep -x picom >/dev/null; then pkill picom; else picom --config ~/.config/picrom/picom.conf -b; fi

# Recargar picom
super + alt + p
    pkill picom && picom --config ~/.config/picom/picom.conf -b

# ----------------------
# Capturas de pantalla
# ----------------------

# Capturar pantalla completa
Print
    scrot ~/Imágenes/Capturas/%Y-%m-%d-%H-%M-%S.png

# Capturar área seleccionada
shift + Print
    scrot -s ~/Imágenes/Capturas/%Y-%m-%d-%H-%M-%S.png

# Capturar ventana activa
ctrl + Print
    scrot -u ~/Imágenes/Capturas/%Y-%m-%d-%H-%M-%S.png

# ----------------------
# Control multimedia
# ----------------------

# Volumen (ajusta según tu configuración de audio)
XF86AudioRaiseVolume
    pamixer -i 5

XF86AudioLowerVolume
    pamixer -d 5

XF86AudioMute
    pamixer -t

# Brillo (si tienes soporte)
XF86MonBrightnessUp
    xbacklight -inc 10

XF86MonBrightnessDown
    xbacklight -dec 10

# Reproducción multimedia
XF86AudioPlay
    playerctl play-pause

XF86AudioNext
    playerctl next

XF86AudioPrev
    playerctl previous

# ----------------------
# Bloqueo de pantalla
# ----------------------

# Bloquear pantalla (instala slock o i3lock)
super + x
    slock  # o i3lock

# ----------------------
# Reinicio/apagado
# ----------------------

# Menú de apagado (con rofi)
super + shift + x
    rofi -show power-menu -modi power-menu:rofi-power-menu

# ====================== #
#  Notas importantes     #
# ====================== #

# 1. Asegúrate de que bspwm esté instalado:
#    sudo xbps-install bspwm sxhkd

# 2. Para que los atajos funcionen al inicio:
#    - Agrega en ~/.xinitrc:
#      sxhkd &
#      exec bspwm

# 3. Ajusta las rutas según tu configuración:
#    - Polybar: ~/.config/polybar/launch.sh
#    - Picom: ~/.config/picom/picom.conf

# 4. Para capturas de pantalla necesitas scrot:
#    sudo xbps-install scrot

# 5. Para control de volumen necesitas pamixer:
#    sudo xbps-install pamixer

# 6. Para el menú de apagado con rofi:
#    sudo xbps-install rofi-power-menu
