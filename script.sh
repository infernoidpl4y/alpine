#!/bin/bash
echo "=== CONFIGURANDO INTEL ALDER LAKE AUDIO ==="

# 1. Detener audio existente
pulseaudio --kill 2>/dev/null
sudo alsa force-reload 2>/dev/null

# 2. Descargar firmware manualmente si es necesario
echo "Instalando firmware SOF..."
sudo xbps-install -y sof-firmware

# 3. Cargar módulos específicos para Alder Lake
echo "Cargando módulos del kernel..."
sudo modprobe -r snd_hda_intel snd_sof_pci snd_sof_intel_hda_common 2>/dev/null
sleep 2

# Módulos específicos para Alder Lake-N
sudo modprobe snd_sof_pci_intel_tgl
sudo modprobe snd_sof_intel_hda_common
sudo modprobe snd_sof
sudo modprobe snd_hda_intel

# 4. Verificar carga de módulos
echo "Módulos cargados:"
lsmod | grep -E "snd|sof"

# 5. Crear symlinks de firmware
echo "Configurando firmware..."
sudo mkdir -p /lib/firmware/intel/sof 2>/dev/null
sudo mkdir -p /lib/firmware/intel/sof-tplg 2>/dev/null

# 6. Verificar dispositivos
echo "Dispositivos ALSA:"
sleep 2
sudo aplay -l

# 7. Iniciar PulseAudio
echo "Iniciando PulseAudio..."
export XDG_RUNTIME_DIR=/run/user/$(id -u)
pulseaudio --start --exit-idle-time=-1 --daemonize=no &

# 8. Verificar
sleep 3
echo "Estado PulseAudio:"
pactl info 2>/dev/null || echo "PulseAudio no iniciado"

# 9. Configurar volumen
pactl set-sink-volume @DEFAULT_SINK@ 70% 2>/dev/null
