#!/bin/bash

# Mata as instancias do outro modo
flatpak kill com.valvesoftware.Steam

# Garantia que os programas fecharam para asa configurações de tela
sleep 1

# Configura os monitores
xrandr --output DP-4 --primary --mode 1920x1080 --rate 144 \
       --output DP-0 --mode 1920x1080 --rate 180 \
       --rotate left --left-of DP-4

# Abre os programas
code &
brave-browser &
