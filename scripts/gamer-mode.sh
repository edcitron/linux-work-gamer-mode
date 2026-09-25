#!/bin/bash

source ../config.sh

# Mata as instancias do outro modo
pkill -TERM "$NAVEGADOR_PROCESS"
pkill -TERM "$EDITOR_PROCESS"

# Garantia que os programas fecharam para as configurações de tela
sleep 1

# Configura o monitor principal
xrandr --output "$MONITOR_PRINCIPAL" \
       --primary \
       --mode "$RESOLUCAO_PRINCIPAL" \
       --rate "$HZ_PRINCIPAL" \
       --output "$MONITOR_SECUNDARIO" \
       --off

# Abre a Steam
$STEAM_CMD &
