#!/data/data/com.termux/files/usr/bin/bash
# XTATINE V4.0 INSTALLER
CYAN=$'\033[1;96m'
GREEN=$'\033[1;92m'
RED=$'\033[1;91m'
WHITE=$'\033[1;97m'
RESET=$'\033[0m'
REPO="xtatine/XTATINE"
URL="https://raw.githubusercontent.com/${REPO}/main/xtatine.sh"

if [ -z "${PREFIX:-}" ]; then
  echo -e "${RED}Please run this installer inside Termux.${RESET}"
  exit 1
fi

clear

mapfile -t INST_ART <<'INSTEOF'
      \                                              
                                     .::!!!!!!!!:.   
   .!!!!!!:.                        .:!!!!!!!!!!!!!!!
   ~~~~!!!!!!.                  .:!!!!!!!!!!UWWW$$$  
       :$$NWX!!:            .:!!!!!!XUWW$$$$$$$$$P   
       $$$$$##WX!:       .<!!!!UW$$$$"  $$$$$$$$#    
       $$$$$  $$$UX   :!!UW$$$$$$$$$   4$$$$$*       
       ^$$$B  $$$$\     $$$$$$$$$$$$$   d$$R"        
         "*$bd$$$$       '*$$$$$$$$$$$o+#"           
              """"           """"""""                
INSTEOF

BIG_XTATINE=(
'██╗  ██╗████████╗ █████╗ ████████╗██╗███╗   ██╗███████╗'
'╚██╗██╔╝╚══██╔══╝██╔══██╗╚══██╔══╝██║████╗  ██║██╔════╝'
' ╚███╔╝    ██║   ███████║   ██║   ██║██╔██╗ ██║█████╗  '
' ██╔██╗    ██║   ██╔══██║   ██║   ██║██║╚██╗██║██╔══╝  '
'██╔╝ ██╗   ██║   ██║  ██║   ██║   ██║██║ ╚████║███████╗'
'╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝'
)

echo
for i in "${!INST_ART[@]}"; do
  line="${INST_ART[i]}"
  lr=$(( 120 - i * 4 )); lg=$(( 110 + i * 8 )); lb=255
  rr=60; rg=$(( 255 - i * 6 )); rb=$(( 120 - i * 4 ))
  printf '  \033[1;38;2;%d;%d;%dm%s\033[1;38;2;%d;%d;%dm%s%s\n' \
    "$lr" "$lg" "$lb" "${line:0:20}" "$rr" "$rg" "$rb" "${line:20}" "$RESET"
done
echo
for l in "${BIG_XTATINE[@]}"; do
  printf '  %s%s%s\n' "$CYAN" "$l" "$RESET"
done
echo

echo -e "${CYAN}╔══════════════════════════════════════╗"
echo "║          XTATINE INSTALLER           ║"
echo "║              VERSION 4.0             ║"
echo -e "╚══════════════════════════════════════╝${RESET}"

command -v curl >/dev/null 2>&1 || pkg install curl -y || exit 1
mkdir -p "$PREFIX/bin" || exit 1

TMP="$PREFIX/bin/xtatine.tmp"
echo -e "${CYAN}[1/3] Downloading XTATINE...${RESET}"
curl -fsSL --progress-bar "$URL" -o "$TMP" || { rm -f "$TMP"; echo -e "${RED}Download failed.${RESET}"; exit 1; }

sed -i 's/\r$//' "$TMP" 2>/dev/null || true

grep -q 'VERSION="4.0"' "$TMP" || { rm -f "$TMP"; echo -e "${RED}The downloaded file is not XTATINE V4.0.${RESET}"; exit 1; }

echo -e "${CYAN}[2/3] Installing...${RESET}"
mv "$TMP" "$PREFIX/bin/xtatine" || exit 1
chmod +x "$PREFIX/bin/xtatine" || exit 1

echo -e "${GREEN}[3/3] Installation complete!${RESET}"
echo -e "${WHITE}Start XTATINE by typing:${CYAN} xtatine${RESET}"
