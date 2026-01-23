#!/usr/bin/env bash

# List all tty* serial devices with their vendor/product info
# and Wine COM port mapping (if available).

set -euo pipefail

have() { command -v "$1" >/dev/null 2>&1; }

list_serial_ttys() {
  ls /dev/tty* 2>/dev/null | sort -V || true
}

tty_props() {
  local tty="$1"
  # Try udevadm for rich properties; fallback to sysfs
  if have udevadm; then
    udevadm info -q property -n "$tty" 2>/dev/null || true
  else
    local sys="/sys/class/tty/$(basename "$tty")/device"
    if [ -e "$sys" ]; then
      {
        [ -f "$sys/uevent" ] && cat "$sys/uevent"
        local up="$sys"
        while [ "$up" != "/" ]; do
          [ -f "$up/idVendor" ] && echo "ID_VENDOR_ID=$(cat "$up/idVendor" 2>/dev/null)"
          [ -f "$up/idProduct" ] && echo "ID_MODEL_ID=$(cat "$up/idProduct" 2>/dev/null)"
          [ -f "$up/manufacturer" ] && echo "ID_VENDOR=$(cat "$up/manufacturer" 2>/dev/null)"
          [ -f "$up/product" ] && echo "ID_MODEL=$(cat "$up/product" 2>/dev/null)"
          [ -f "$up/serial" ] && echo "ID_SERIAL_SHORT=$(cat "$up/serial" 2>/dev/null)"
          up="$(dirname "$up")"
        done
      } 2>/dev/null || true
    fi
  fi
}

tty_to_wine_com() {
  # Map a TTY device to its Wine COM port(s)
  # Wine creates dosdevices/comX symlinks pointing to the real TTY devices
  local tty="$1"
  local real_tty
  real_tty="$(readlink -f "$tty" 2>/dev/null || echo "$tty")"
  
  # Check common Wine prefix locations
  local wine_dirs=(
    "$HOME/.wine/dosdevices"
  )
  
  if [ -n "${WINEPREFIX:-}" ]; then
    wine_dirs+=("$WINEPREFIX/dosdevices")
  fi
  
  local comports=()
  local d
  for d in "${wine_dirs[@]}"; do
    [ -d "$d" ] || continue
    local com
    for com in "$d"/com* "$d"/COM*; do
      [ -e "$com" ] || continue
      local target
      target="$(readlink -f "$com" 2>/dev/null || true)"
      if [ "$target" = "$real_tty" ]; then
        comports+=("$(basename "$com" | tr '[:lower:]' '[:upper:]')")
      fi
    done
  done
  
  if [ "${#comports[@]}" -gt 0 ]; then
    printf "%s" "${comports[*]}"
    return 0
  fi
  return 1
}

main() {
  mapfile -t ttys < <(list_serial_ttys)
  
  if [ "${#ttys[@]}" -eq 0 ]; then
    echo "No serial devices found." >&2
    exit 0
  fi
  
  for tty in "${ttys[@]}"; do
    local props vendor mod wine_com
    echo -ne "$tty\r"
    props="$(tty_props "$tty")"
    vendor="$(printf "%s" "$props" | awk -F= '/^ID_VENDOR=/{print $2}' | head -n1)"
    model="$(printf "%s" "$props" | awk -F= '/^ID_MODEL=/{print $2}' | head -n1)"
    
    # Skip devices without vendor or model information
    if [ -z "$vendor" ] || [ -z "$model" ]; then
      continue
    fi
    
    wine_com="$(tty_to_wine_com "$tty" || echo "")"
    
    # Format output
    if [ -n "$wine_com" ]; then
      printf "%s * %s * %s * %s\n" "$tty" "$vendor" "$model" "$wine_com"
    else
      printf "%s * %s * %s\n" "$tty" "$vendor" "$model"
    fi
  done

  # Print space over the last echoed TTY progress line.
  echo -ne "$(printf '%*s' "${#tty}" '')\r"
}

main "$@"
