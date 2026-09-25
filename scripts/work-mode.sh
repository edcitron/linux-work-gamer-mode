#!/bin/bash

source ../config.sh

# Mata as instancias do outro modo
flatpak kill com.valvesoftware.Steam

# Garantia que os programas fecharam para as configurações de tela
sleep 1

# Configura os monitores
xrandr --output "$MONITOR_PRINCIPAL" \
       --primary \
       --mode "$RESOLUCAO_PRINCIPAL" \
       --rate "$HZ_PRINCIPAL" \
       --output "$MONITOR_SECUNDARIO" \
       --mode "$RESOLUCAO_SECUNDARIO" \
       --rate "$HZ_SECUNDARIO" \
       --rotate left \
       --left-of "$MONITOR_PRINCIPAL"

# Abre os programas
$EDITOR_CMD &
$NAVEGADOR_CMD &
