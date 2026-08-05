########################################
# WSL2 <-> Windows interop
########################################

# Sound
export PULSE_SERVER=unix:/mnt/wslg/PulseServer

alias exp="explorer.exe ."
alias vlc="/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe"

########################################
# Sedimentum VPN (community OpenVPN 2.6 on Windows, driven from WSL)
########################################
# Profile lives at %USERPROFILE%\OpenVPN\config\sedimentum.ovpn and uses askpass,
# so connecting never prompts. Do not run OpenVPN Connect at the same time —
# both clients share the same certificate and the server drops the duplicate.
export OVPN_GUI='/mnt/c/Program Files/OpenVPN/bin/openvpn-gui.exe'
export OVPN_PROFILE='sedimentum'

vpn() {
  /mnt/c/Windows/System32/tasklist.exe 2>/dev/null | tr -d '\0' | grep -qi openvpn-gui.exe \
    || ( "$OVPN_GUI" >/dev/null 2>&1 & sleep 3 )
  case "$1" in
    up)     "$OVPN_GUI" --command connect    "$OVPN_PROFILE" ;;
    down)   "$OVPN_GUI" --command disconnect "$OVPN_PROFILE" ;;
    status) if /mnt/c/Windows/System32/tasklist.exe 2>/dev/null | tr -d '\0' \
              | grep -qi '^openvpn\.exe'; then echo 'vpn: connected'
            else echo 'vpn: disconnected'; fi ;;
    *)      print -u2 'usage: vpn up|down|status' ; return 2 ;;
  esac
}

########################################
# Firefox
########################################
# Opens URLs as tabs in the already-running Firefox window. Local paths are
# translated to file:// URLs, since Firefox is a Windows process and cannot
# read /home/... directly.
export FIREFOX='/mnt/c/Users/ArthurHabicht/AppData/Local/Microsoft/WindowsApps/firefox.exe'

ff() {
  if [ $# -eq 0 ]; then print -u2 'usage: ff <url|file> [url ...]'; return 2; fi
  local a w args=()
  for a in "$@"; do
    if [ -e "$a" ]; then
      w=$(wslpath -w -- "$a") || return 1
      w=${w//\\//}
      # UNC (\\wsl.localhost\...) already carries its leading //, drive paths do not
      case "$w" in
        //*) args+=("file:$w") ;;
        *)   args+=("file:///$w") ;;
      esac
    else
      args+=("$a")
    fi
  done
  "$FIREFOX" -new-tab "${args[@]}" >/dev/null 2>&1
}

# Page shortcuts live in ~/.zsh/web.zsh (web-* aliases, sourced after this).
