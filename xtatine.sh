#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# XTATINE PREMIUM TERMINAL SUITE
# VERSION 4.0 | DEVELOPER: KAWSAR
# ==========================================================

APP="XTATINE"
VERSION="4.0"
DEVELOPER="KAWSAR"
CHARS='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ@#$%&'

# True-color palette
CYAN=$'\033[38;2;0;255;255m'
GREEN=$'\033[38;2;0;255;100m'
BLUE=$'\033[38;2;70;150;255m'
PURPLE=$'\033[38;2;190;90;255m'
PINK=$'\033[38;2;255;80;190m'
RED=$'\033[38;2;255;75;75m'
YELLOW=$'\033[38;2;255;220;50m'
WHITE=$'\033[1;97m'
GRAY=$'\033[38;2;130;145;155m'
DARK=$'\033[38;2;70;85;95m'
RESET=$'\033[0m'
BOLD=$'\033[1m'

export TERM="${TERM:-xterm-256color}"

cleanup() {
    printf '\033[?25h\033[0m'
}
trap cleanup EXIT
trap 'cleanup; clear; exit 130' INT TERM

term_width() {
    local w
    w=$(tput cols 2>/dev/null)
    [[ "$w" =~ ^[0-9]+$ ]] || w=40
    (( w < 24 )) && w=24
    (( w > 76 )) && w=76
    echo "$w"
}

line() {
    local w
    w=$(term_width)
    printf -v bar '%*s' "$w" ''
    printf '%s\n' "${bar// /─}"
}

center_text() {
    local text="$1" w pad
    w=$(term_width)
    pad=$(( (w - ${#text}) / 2 ))
    (( pad < 0 )) && pad=0
    printf '%*s%s\n' "$pad" '' "$text"
}

pause_back() {
    echo
    printf "  ${CYAN}[ ENTER ]${WHITE} Main Menu    ${YELLOW}[ B ]${WHITE} Back    ${RED}[ 0 ]${WHITE} Exit${RESET}\n"
    read -r -p "  Press ENTER or B to continue: " _
    case "$_" in
        0) exit_app ;;
        *) return ;;
    esac
}

exit_app() {
    clear
    echo
    center_text "${CYAN}${BOLD}✦ THANK YOU FOR USING XTATINE ✦${RESET}"
    center_text "${GREEN}Developed with passion by KAWSAR${RESET}"
    echo
    exit 0
}

header() {
    clear
    local w
    w=$(term_width)
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
    line
    center_text "${CYAN}✦  X T A T I N E  ✦${RESET}"
    line
    printf "  ${GREEN}● ONLINE${RESET}  ${DARK}│${RESET} ${WHITE}VERSION ${CYAN}${VERSION}${RESET}  ${DARK}│${RESET} ${BLUE}TERMUX / ANDROID${RESET}\n"
    printf "  ${GRAY}DESIGNED FOR TERMINAL LOVERS  •  BY ${WHITE}${DEVELOPER}${RESET}\n"
    line
    echo
}

section_title() {
    local title="$1"
    echo
    printf "  ${CYAN}╭"
    printf '%*s' 3 ''
    printf " %s " "$title"
    printf '%*s' 3 ''
    printf "╮${RESET}\n"
}

menu_item() {
    printf "  ${GREEN}[%02d]${RESET} ${WHITE}%s${RESET}\n" "$1" "$2"
}

rain() {
    local color="$1" speed="$2" rainbow="$3"
    local cols rows i y ch frame key
    local -a drops colors
    cols=$(term_width)
    rows=$(tput lines 2>/dev/null || echo 24)
    (( rows < 8 )) && rows=8
    (( rows > 50 )) && rows=50
    colors=("$GREEN" "$CYAN" "$BLUE" "$PURPLE" "$PINK" "$YELLOW")
    for ((i=0; i<cols; i++)); do drops[i]=$((RANDOM % rows + 1)); done

    clear
    printf '\033[?25l'
    printf "${CYAN}${BOLD}  XTATINE MATRIX RAIN${RESET}  ${GRAY}• Press Q or B to return${RESET}\n"
    for ((frame=0; frame<100000; frame++)); do
        for ((i=0; i<cols; i++)); do
            y=${drops[i]}
            ch=${CHARS:$((RANDOM % ${#CHARS})):1}
            [[ "$rainbow" == "yes" ]] && color="${colors[$((i % ${#colors[@]}))]}"
            printf '\033[%d;%dH%s%s%s' "$y" "$((i+1))" "$WHITE" "$ch" "$RESET"
            if (( y > 1 )); then
                printf '\033[%d;%dH%s%s%s' "$((y-1))" "$((i+1))" "$color" "$ch" "$RESET"
            fi
            drops[i]=$((y+1))
            (( drops[i] > rows )) && drops[i]=1
        done
        sleep "$speed"
        if read -r -s -n 1 -t 0.02 key; then
            [[ "$key" == "q" || "$key" == "Q" || "$key" == "b" || "$key" == "B" ]] && break
        fi
    done
    printf '\033[?25h'
    header
}

digital_clock() {
    local key
    while true; do
        header
        section_title "XTATINE DIGITAL CLOCK"
        echo
        center_text "${GRAY}LIVE DEVICE TIME${RESET}"
        center_text "${CYAN}${BOLD}$(date '+%I:%M:%S %p')${RESET}"
        echo
        center_text "${GREEN}$(date '+%A')${RESET}"
        center_text "${WHITE}$(date '+%d %B %Y')${RESET}"
        echo
        line
        printf "  ${YELLOW}Q / B${WHITE}  Back to Main Menu${RESET}  ${GRAY}• Refreshes every second${RESET}\n"
        if read -r -s -n 1 -t 1 key; then
            [[ "$key" == "q" || "$key" == "Q" || "$key" == "b" || "$key" == "B" ]] && break
        fi
    done
}

system_info() {
    header
    section_title "DEVICE OVERVIEW"
    printf "  ${GREEN}DEVICE MODEL   ${DARK}›${WHITE} %s\n" "$(getprop ro.product.model 2>/dev/null || echo Unknown)"
    printf "  ${GREEN}MANUFACTURER   ${DARK}›${WHITE} %s\n" "$(getprop ro.product.manufacturer 2>/dev/null || echo Unknown)"
    printf "  ${GREEN}ANDROID        ${DARK}›${WHITE} %s\n" "$(getprop ro.build.version.release 2>/dev/null || echo Unknown)"
    printf "  ${GREEN}ARCHITECTURE   ${DARK}›${WHITE} %s\n" "$(uname -m 2>/dev/null)"
    printf "  ${GREEN}KERNEL         ${DARK}›${WHITE} %s\n" "$(uname -r 2>/dev/null)"
    printf "  ${GREEN}SHELL          ${DARK}›${WHITE} %s\n" "${SHELL:-bash}"
    section_title "STORAGE"
    df -h "$HOME" 2>/dev/null | awk 'NR==1 || NR==2 {print "  " $0}'
    pause_back
}

custom_banner() {
    header
    section_title "CUSTOM TEXT BANNER"
    echo
    read -r -p "  Enter your text: " msg
    echo
    printf "  ${CYAN}╔"
    printf '%*s' 3 ''
    printf " XTATINE MESSAGE "
    printf '%*s' 3 ''
    printf "╗${RESET}\n"
    printf "  ${CYAN}║${WHITE} %-*.*s ${CYAN}║${RESET}\n" "$(( $(term_width) - 6 ))" "$(( $(term_width) - 6 ))" "$msg"
    printf "  ${CYAN}╚"
    printf '%*s' $(( $(term_width) - 4 )) ''
    printf "╝${RESET}\n"
    pause_back
}

network_info() {
    header
    section_title "NETWORK STATUS"
    echo
    printf "  ${GREEN}HOSTNAME       ${DARK}›${WHITE} %s\n" "$(hostname 2>/dev/null || echo Unknown)"
    local ip
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    [[ -z "$ip" ]] && ip="Not available"
    printf "  ${GREEN}LOCAL IP       ${DARK}›${WHITE} %s\n" "$ip"

    if command -v termux-wifi-connectioninfo >/dev/null 2>&1; then
        local wifi
        wifi=$(termux-wifi-connectioninfo 2>/dev/null)
        local ssid
        ssid=$(printf '%s' "$wifi" | sed -n 's/.*"ssid"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)
        [[ -z "$ssid" ]] && ssid="Unavailable"
        printf "  ${GREEN}WI-FI NAME     ${DARK}›${WHITE} %s\n" "$ssid"
    else
        printf "  ${YELLOW}WI-FI NAME     ${DARK}›${GRAY} Termux:API optional\n"
    fi

    echo
    if command -v ping >/dev/null 2>&1 && ping -c 1 -W 2 1.1.1.1 >/dev/null 2>&1; then
        printf "  ${GREEN}INTERNET       ${DARK}› ${GREEN}CONNECTED${RESET}\n"
    else
        printf "  ${RED}INTERNET       ${DARK}› ${RED}NOT CONFIRMED${RESET}\n"
    fi
    echo
    printf "  ${GRAY}Note: public IP and Wi-Fi details may be restricted by Android.${RESET}\n"
    pause_back
}

battery_info() {
    header
    section_title "BATTERY HEALTH & STATUS"
    echo
    if command -v termux-battery-status >/dev/null 2>&1; then
        termux-battery-status
    else
        printf "  ${YELLOW}Termux:API is not available.${RESET}\n\n"
        echo "  To enable battery details:"
        echo "  1. Install the Termux:API Android app."
        echo "  2. In Termux run: pkg install termux-api"
        echo "  3. Reopen XTATINE and select Battery Information."
    fi
    pause_back
}

about() {
    header
    section_title "ABOUT XTATINE"
    echo
    center_text "${CYAN}${BOLD}✦ XTATINE PREMIUM ✦${RESET}"
    center_text "${GRAY}A colorful terminal experience${RESET}"
    echo
    printf "  ${GREEN}NAME         ${DARK}› ${CYAN}XTATINE${RESET}\n"
    printf "  ${GREEN}VERSION      ${DARK}› ${WHITE}%s${RESET}\n" "$VERSION"
    printf "  ${GREEN}PLATFORM     ${DARK}› ${BLUE}TERMUX / ANDROID${RESET}\n"
    printf "  ${GREEN}VISUAL THEME ${DARK}› ${PURPLE}MATRIX • CYAN • RGB${RESET}\n"
    printf "  ${GREEN}DEVELOPER    ${DARK}› ${CYAN}${DEVELOPER}${RESET}\n"
    printf "  ${GREEN}GITHUB       ${DARK}› ${WHITE}github.com/xtatine/XTATINE${RESET}\n"
    echo
    line
    center_text "${YELLOW}BUILT TO MAKE YOUR TERMINAL UNIQUE${RESET}"
    center_text "${GREEN}Thank you for using XTATINE!${RESET}"
    pause_back
}

main_menu() {
    local choice
    while true; do
        header
        section_title "MATRIX ANIMATION"
        menu_item 1 "Matrix Rain"
        menu_item 2 "Fast Matrix Rain"
        menu_item 3 "Blue Matrix"
        menu_item 4 "Cyan Matrix"
        menu_item 5 "Purple Matrix"
        menu_item 6 "Rainbow Matrix"
        echo
        section_title "SYSTEM TOOLS"
        menu_item 7 "Digital Clock"
        menu_item 8 "System Information"
        menu_item 9 "Custom Text Banner"
        menu_item 10 "Network Information"
        menu_item 11 "Battery Information"
        menu_item 12 "About XTATINE"
        echo
        line
        printf "  ${RED}[00]${WHITE} Exit XTATINE${RESET}\n"
        line
        printf "  ${CYAN}${BOLD}Select Option ➤ ${RESET}"
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
            0|00) exit_app ;;
            *) printf "\n  ${RED}Invalid option. Choose 01–12 or 00.${RESET}\n"; sleep 1 ;;
        esac
    done
}

main_menu
