#!/bin/ash
# Script para crear initramfs con todos los módulos necesarios
# Copia y pega TODO en el terminal

echo "=== PASO 1: Creando initramfs manual ==="

# Crear directorio temporal
WORKDIR=/tmp/mkinitramfs
rm -rf $WORKDIR
mkdir -p $WORKDIR
cd $WORKDIR

echo "=== PASO 2: Creando estructura de directorios ==="
mkdir -p bin sbin lib/modules dev proc sys boot
mkdir -p usr/bin usr/sbin

echo "=== PASO 3: Copiando binarios esenciales ==="
# Copiar busybox
cp /bin/busybox bin/
ln -s busybox bin/sh
ln -s busybox bin/mount
ln -s busybox bin/umount
ln -s busybox bin/modprobe
ln -s busybox bin/switch_root
ln -s busybox bin/sleep
ln -s busybox bin/echo
ln -s busybox bin/ls
ln -s busybox bin/cat
ln -s busybox bin/grep
ln -s busybox bin/cut
ln -s busybox bin/blkid

echo "=== PASO 4: Copiando módulos del kernel ==="
KERNEL_VER=$(ls /lib/modules/ | head -1)
echo "Kernel: $KERNEL_VER"

# Copiar TODOS los módulos
cp -a /lib/modules/$KERNEL_VER lib/modules/

echo "=== PASO 5: Creando script init ==="
cat > init << 'EOF'
#!/bin/sh
export PATH=/bin:/sbin

# Montar sistemas de archivos virtuales
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

echo "Alpine Linux initramfs"
echo "Cargando módulos de almacenamiento..."

# Cargar módulos de almacenamiento
for mod in ahci ata_piix ata_generic sd_mod scsi_mod libata usb_storage nvme nvme_core ext4 vfat; do
    modprobe $mod 2>/dev/null && echo "  Cargado: $mod"
done

# Esperar a que los dispositivos aparezcan
echo "Esperando dispositivos..."
sleep 5

# Intentar montar root
echo "Buscando partición root..."

# Opción 1: Por dispositivo directo
if [ -b /dev/sdb3 ]; then
    echo "Montando /dev/sdb3"
    mount /dev/sdb3 /sysroot && ROOT_OK=1
elif [ -b /dev/sda3 ]; then
    echo "Montando /dev/sda3"
    mount /dev/sda3 /sysroot && ROOT_OK=1
fi

# Opción 2: Por UUID (el tuyo)
if [ -z "$ROOT_OK" ]; then
    echo "Buscando por UUID cc82b2ff-f43f-4a97-98f5-863135afae41"
    ROOT_DEV=$(blkid | grep "cc82b2ff-f43f-4a97-98f5-863135afae41" | cut -d: -f1)
    if [ -n "$ROOT_DEV" ]; then
        echo "Montando $ROOT_DEV"
        mount $ROOT_DEV /sysroot && ROOT_OK=1
    fi
fi

# Opción 3: Buscar cualquier ext4
if [ -z "$ROOT_OK" ]; then
    echo "Buscando cualquier partición ext4..."
    for dev in /dev/sd* /dev/nvme*; do
        if [ -b "$dev" ]; then
            if blkid -s TYPE -o value "$dev" | grep -q ext4; then
                echo "Probando $dev"
                mount "$dev" /sysroot 2>/dev/null && ROOT_OK=1 && break
            fi
        fi
    done
fi

if [ -n "$ROOT_OK" ]; then
    echo "Root montado correctamente"
    exec switch_root /sysroot /sbin/init
else
    echo "ERROR: No se pudo montar root"
    echo "Dispositivos disponibles:"
    ls /dev/sd* /dev/nvme* 2>/dev/null || echo "No hay dispositivos"
    echo "Particiones:"
    cat /proc/partitions 2>/dev/null || echo "No hay particiones"
    exec /bin/sh
fi
EOF

chmod +x init

echo "=== PASO 6: Empaquetando initramfs ==="
find . | cpio -H newc -o | gzip -9 > /boot/initramfs-manual

echo "=== PASO 7: Configurando grub para usar initramfs manual ==="
# Copiar como initramfs principal
cp /boot/initramfs-manual /boot/initramfs-lts

echo "=== PASO 8: Actualizando grub ==="
# Actualizar grub para usar dispositivo directo
cat > /etc/default/grub << 'EOF'
GRUB_DEFAULT=0
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="Alpine"
GRUB_CMDLINE_LINUX_DEFAULT="quiet root=/dev/sdb3"
GRUB_CMDLINE_LINUX=""
GRUB_PRELOAD_MODULES="part_gpt part_msdos"
GRUB_TERMINAL_INPUT="console"
GRUB_TERMINAL_OUTPUT="console"
EOF

# Regenerar config de grub
grub-mkconfig -o /boot/grub/grub.cfg

echo "=== COMPLETADO ==="
echo "Initramfs creado en: /boot/initramfs-manual"
echo "Tamaño: $(du -h /boot/initramfs-manual | cut -f1)"
echo "Módulos incluidos:"
find lib/modules -name "*.ko" | wc -l
