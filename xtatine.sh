#!/data/data/com.termux/files/usr/bin/bash

# ==============================================
#              XTATINE PREMIUM
#                   VERSION 3.0
# ==============================================

# COLORS
CYAN=$'\033[38;2;0;255;255m'
GREEN=$'\033[38;2;0;255;100m'
BLUE=$'\033[38;2;70;150;255m'
PURPLE=$'\033[38;2;190;90;255m'
RED=$'\033[38;2;255;75;75m'
YELLOW=$'\033[38;2;255;220;50m'
WHITE=$'\033[1;97m'
GRAY=$'\033[90m'
RESET=$'\033[0m'
BOLD=$'\033[1m'

APP="XTATINE"
VERSION="3.0"
CHARS='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%&'

# TERMINAL SETUP
export TERM="${TERM:-xterm-256color}"

cleanup() {
    printf '\033[?25h'
    printf '\033[0m'
    clear
}

trap cleanup EXIT
trap 'cleanup; exit 130' INT TERM

pause() {
    echo
    read -r -p "  Press ENTER to continue..."
}

header() {
    clear

    printf "${CYAN}${BOLD}"
    cat <<'LOGO'
  ██╗  ██╗████████╗ █████╗ ████████╗██╗███╗   ██╗███████╗
  ╚██╗██╔╝╚══██╔══╝██╔══██╗╚══██╔══╝██║████╗  ██║██╔════╝
   ╚███╔╝    ██║   ███████║   ██║   ██║██╔██╗ ██║█████╗
   ██╔██╗    ██║   ██╔══██║   ██║   ██║██║╚██╗██║██╔══╝
  ██╔╝ ██╗   ██║   ██║  ██║   ██║   ██║██║ ╚████║███████╗
  ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝
LOGO
    printf "${RESET}"

    echo
    printf "${CYAN}  ╔══════════════════════════════════════════════╗${RESET}\n"
    printf "${CYAN}  ║          ★  X T A T I N E  ★                 ║${RESET}\n"
    printf "${CYAN}  ╚══════════════════════════════════════════════╝${RESET}\n"

    echo
    printf "  ${GREEN}● ONLINE${RESET}  ${GRAY}|${RESET}"
    printf "  ${WHITE}VERSION:${CYAN} $VERSION ${RESET}"
    printf " ${GRAY}|${RESET} ${BLUE}TERMUX SYSTEM${RESET}\n"

    echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

rain() {
    local color="$1"
    local speed="$2"
    local rainbow="$3"

    local cols rows i y ch frame key
    local -a drops
    local -a colors

    colors=("$GREEN" "$CYAN" "$BLUE" "$PURPLE" "$RED" "$YELLOW")

    cols=$(tput cols 2>/dev/null || echo 40)
    rows=$(tput lines 2>/dev/null || echo 20)

    ((cols > 100)) && cols=100
    ((rows > 45)) && rows=45
    ((cols < 10)) && cols=40
    ((rows < 5)) && rows=20

    for ((i=0; i<cols; i++)); do
        drops[i]=$((RANDOM % rows + 1))
    done

    clear
    printf '\033[?25l'

    echo -e "${WHITE}  MATRIX RAIN${GRAY} | Press Q to exit${RESET}"

    for ((frame=0; frame<100000; frame++)); do

        for ((i=0; i<cols; i++)); do
            y=${drops[i]}
            ch=${CHARS:$((RANDOM % ${#CHARS})):1}

            if [[ "$rainbow" == "yes" ]]; then
                color="${colors[$((i % ${#colors[@]}))]}"
            fi

            printf '\033[%d;%dH%s%s%s' \
                "$y" "$((i+1))" "$WHITE" "$ch" "$RESET"

            if ((y > 1)); then
                printf '\033[%d;%dH%s%s%s' \
                    "$((y-1))" "$((i+1))" "$color" "$ch" "$RESET"
            fi

            drops[i]=$((y+1))

            if ((drops[i] > rows)); then
                drops[i]=1
            fi
        done

        sleep "$speed"

        if read -r -s -n 1 -t 0.02 key; then
            if [[ "$key" == "q" || "$key" == "Q" ]]; then
                break
            fi
        fi
    done

    printf '\033[?25h'
    clear
}

digital_clock() {
    clear

    while true; do
        printf '\033[H'
        printf '\033[J'

        echo -e "${CYAN}"
        echo "  ╔══════════════════════════════════════╗"
        echo "  ║          XTATINE DIGITAL CLOCK       ║"
        echo "  ╚══════════════════════════════════════╝"
        echo -e "${RESET}"

        printf "\n  ${WHITE}TIME${RESET}\n"
        printf "  ${CYAN}${BOLD}      %s${RESET}\n" "$(date '+%I:%M:%S %p')"

        printf "\n  ${WHITE}DATE${RESET}\n"
        printf "  ${GREEN}      %s${RESET}\n" "$(date '+%A, %d %B %Y')"

        echo
        echo -e "${GRAY}  Press Q to return to menu${RESET}"

        if read -r -s -n 1 -t 1 key; then
            [[ "$key" == "q" || "$key" == "Q" ]] && break
        fi
    done
}

system_info() {
    header

    echo -e "${CYAN}  [ SYSTEM INFORMATION ]${RESET}"
    echo

    echo -e "${GREEN}  Device Model:${WHITE} $(getprop ro.product.model 2>/dev/null)"
    echo -e "${GREEN}  Manufacturer:${WHITE} $(getprop ro.product.manufacturer 2>/dev/null)"
    echo -e "${GREEN}  Android Version:${WHITE} $(getprop ro.build.version.release 2>/dev/null)"
    echo -e "${GREEN}  Architecture:${WHITE} $(uname -m)"
    echo -e "${GREEN}  Kernel:${WHITE} $(uname -r)"
    echo -e "${GREEN}  Shell:${WHITE} $SHELL"
    echo -e "${GREEN}  Current Date:${WHITE} $(date)"

    echo
    echo -e "${CYAN}  [ STORAGE INFORMATION ]${RESET}"
    df -h "$HOME" 2>/dev/null

    pause
}

custom_banner() {
    header

    echo -e "${CYAN}  [ CUSTOM TEXT BANNER ]${RESET}"
    echo

    read -r -p "  Enter your text: " msg

    echo
    printf "${CYAN}  ╔══════════════════════════════════════════╗\n"
    printf "  ║ %-40.40s ║\n" "$msg"
    printf "  ╚══════════════════════════════════════════╝${RESET}\n"

    pause
}

network_info() {
    header

    echo -e "${CYAN}  [ NETWORK INFORMATION ]${RESET}"
    echo

    echo -e "${GREEN}  Hostname:${WHITE} $(hostname 2>/dev/null)"
    echo -e "${GREEN}  IP Address:${WHITE} $(hostname -I 2>/dev/null || echo 'Not available')"

    echo
    echo -e "${GRAY}  Network information depends on your device.${RESET}"

    pause
}

battery_info() {
    header

    echo -e "${CYAN}  [ BATTERY INFORMATION ]${RESET}"
    echo

    if command -v termux-battery-status >/dev/null 2>&1; then
        termux-battery-status
    else
        echo -e "${YELLOW}  Termux:API is not installed.${RESET}"
        echo
        echo "  Optional setup:"
        echo "  pkg install termux-api"
        echo "  Install the Termux:API Android app too."
    fi

    pause
}

about() {
    header

    echo -e "${CYAN}  [ ABOUT XTATINE ]${RESET}"
    echo
    echo -e "${WHITE}  NAME       : ${CYAN}XTATINE"
    echo -e "${WHITE}  VERSION    : ${GREEN}$VERSION"
    echo -e "${WHITE}  PLATFORM   : ${BLUE}TERMUX / ANDROID"
    echo -e "${WHITE}  DESIGN     : ${PURPLE}PREMIUM MATRIX"
    echo -e "${WHITE}  DEVELOPER  : ${CYAN}KAWSAR"
    echo
    echo -e "${GRAY}  Made for terminal lovers.${RESET}"
    echo -e "${CYAN}  Thank you for using XTATINE!${RESET}"

    pause
}

main_menu() {
    while true; do

        header

        echo -e "${CYAN}  ╭──────── MATRIX ANIMATION ─────────╮${RESET}"
        echo -e "  ${GREEN}[01]${WHITE}  Matrix Rain"
        echo -e "  ${GREEN}[02]${WHITE}  Fast Matrix Rain"
        echo -e "  ${BLUE}[03]${WHITE}  Blue Matrix"
        echo -e "  ${CYAN}[04]${WHITE}  Cyan Matrix"
        echo -e "  ${PURPLE}[05]${WHITE}  Purple Matrix"
        echo -e "  ${YELLOW}[06]${WHITE}  Rainbow Matrix"
        echo -e "${CYAN}  ╰──────────────────────────────────╯${RESET}"

        echo
        echo -e "${CYAN}  ╭────────── SYSTEM TOOLS ──────────╮${RESET}"
        echo -e "  ${GREEN}[07]${WHITE}  Digital Clock"
        echo -e "  ${GREEN}[08]${WHITE}  System Information"
        echo -e "  ${GREEN}[09]${WHITE}  Custom Text Banner"
        echo -e "  ${GREEN}[10]${WHITE}  Network Information"
        echo -e "  ${GREEN}[11]${WHITE}  Battery Information"
        echo -e "  ${GREEN}[12]${WHITE}  About XTATINE"
        echo -e "${CYAN}  ╰──────────────────────────────────╯${RESET}"

        echo
        echo -e "  ${RED}[00]${WHITE}  Exit"

        echo -e "${GRAY}  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"

        echo -ne "  ${CYAN}${BOLD}Select Option ➤ ${RESET}"
        read -r choice

        case "$choice" in
            1|01) rain "$GREEN" 0.07 no ;;
            2|02) rain "$GREEN" 0.015 no ;;
            3|03) rain "$BLUE" 0.06 no ;;
            4|04) rain "$CYAN" 0.06 no ;;
            5|05) rain "$PURPLE" 0.06 no ;;
            6|06) rain "$GREEN" 0.04 yes ;;
            7|07) digital_clock ;;
            8|08) system_info ;;
            9|09) custom_banner ;;
            10) network_info ;;
            11) battery_info ;;
            12) about ;;

            0|00)
                clear
                echo -e "${CYAN}  ★ THANK YOU FOR USING XTATINE ★${RESET}"
                sleep 1
                break
                ;;

            *)
                echo -e "${RED}  Invalid Option! Please try again.${RESET}"
                sleep 1
                ;;
        esac
    done
}

main_menu
