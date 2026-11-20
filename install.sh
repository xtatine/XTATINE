#!/data/data/com.termux/files/usr/bin/bash

# XTATINE PREMIUM INSTALLER

CYAN=$'\033[1;96m'
GREEN=$'\033[1;92m'
RED=$'\033[1;91m'
WHITE=$'\033[1;97m'
RESET=$'\033[0m'

REPO="xtatine/XTATINE"
URL="https://raw.githubusercontent.com/$REPO/main/xtatine.sh"

clear

echo -e "${CYAN}"
echo "  ╔══════════════════════════════════════╗"
echo "  ║         XTATINE INSTALLER             ║"
echo "  ║             VERSION 3.0               ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${RESET}"

if [ -z "$PREFIX" ]; then
    echo -e "${RED}Please run this inside Termux.${RESET}"
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "Installing curl..."
    pkg install curl -y || exit 1
fi

mkdir -p "$PREFIX/bin" || exit 1

echo -e "${CYAN}[1/3] Downloading XTATINE...${RESET}"

TMP="$PREFIX/bin/xtatine.tmp"

if ! curl -fL --progress-bar "$URL" -o "$TMP"; then
    rm -f "$TMP"
    echo -e "${RED}Download failed. Check your repository.${RESET}"
    exit 1
fi

if ! grep -q 'XTATINE PREMIUM' "$TMP"; then
    rm -f "$TMP"
    echo -e "${RED}Invalid XTATINE file.${RESET}"
    exit 1
fi

echo -e "${CYAN}[2/3] Installing files...${RESET}"

mv "$TMP" "$PREFIX/bin/xtatine" || exit 1
chmod +x "$PREFIX/bin/xtatine"

echo -e "${CYAN}[3/3] Completing setup...${RESET}"

echo
echo -e "${GREEN}  ╔══════════════════════════════════════╗"
echo "  ║       INSTALLATION SUCCESSFUL!       ║"
echo "  ╚══════════════════════════════════════╝"
echo -e "${RESET}"

echo -e "${WHITE}  To start XTATINE, type:${RESET}"
echo -e "${CYAN}  xtatine${RESET}"
echo
