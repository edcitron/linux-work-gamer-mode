#!/bin/bash

# Mata as instancias do outro modo
pkill -TERM brave
pkill -TERM code

# Garantia que os programas fecharam para asa configurações de tela
sleep 1

# Configura o monitor principal
xrandr --output DP-4 --primary --mode 1920x1080 --rate 144 \
       --output DP-0 --off

# Abre a Steam
flatpak run com.valvesoftware.Steam &
