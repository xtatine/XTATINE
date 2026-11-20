#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# XTATINE PREMIUM TERMINAL SUITE
# VERSION 7.0 | DEVELOPER: KAWSAR
# ==========================================================

APP="XTATINE"
VERSION="8.0"
DEVELOPER="KAWSAR"
CHARS='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*+=<>?/\|;:!^~()[]{}'

ESC=$'\033'
# True-color palette
CYAN=$'\033[38;2;0;255;255m'
GREEN=$'\033[38;2;0;255;100m'
LIME=$'\033[38;2;170;255;60m'
BLUE=$'\033[38;2;70;150;255m'
SKY=$'\033[38;2;100;200;255m'
TEAL=$'\033[38;2;40;230;190m'
PURPLE=$'\033[38;2;190;90;255m'
PINK=$'\033[38;2;255;80;190m'
ROSE=$'\033[38;2;255;110;150m'
RED=$'\033[38;2;255;75;75m'
LAV=$'\033[38;2;170;150;255m'
MINT=$'\033[38;2;120;255;190m'
ORANGE=$'\033[38;2;255;150;50m'
YELLOW=$'\033[38;2;255;220;50m'
WHITE=$'\033[1;97m'
GRAY=$'\033[38;2;130;145;155m'
DARK=$'\033[38;2;70;85;95m'
RESET=$'\033[0m'
BOLD=$'\033[1m'

export TERM="${TERM:-xterm-256color}"

# prefer a UTF-8 locale so string lengths count characters, not bytes
if ! [[ "${LC_ALL:-${LANG:-}}" == *[Uu][Tt][Ff]-8* ]]; then
    for _l in C.UTF-8 en_US.UTF-8 en_US.utf8; do
        if locale -a 2>/dev/null | grep -qix "$_l"; then export LC_ALL="$_l"; break; fi
    done
fi

# repeat a (multi-byte safe) character N times: rep "─" 10
rep() {
    local s
    printf -v s '%*s' "$2" ''
    printf '%s' "${s// /$1}"
}

LOGO=(
'██╗  ██╗████████╗ █████╗ ████████╗██╗███╗   ██╗███████╗'
'╚██╗██╔╝╚══██╔══╝██╔══██╗╚══██╔══╝██║████╗  ██║██╔════╝'
' ╚███╔╝    ██║   ███████║   ██║   ██║██╔██╗ ██║█████╗  '
' ██╔██╗    ██║   ██╔══██║   ██║   ██║██║╚██╗██║██╔══╝  '
'██╔╝ ██╗   ██║   ██║  ██║   ██║   ██║██║ ╚████║███████╗'
'╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝'
)

# ---------- screen size (real size of the whole display) ----------
SCR_W=80
SCR_H=24
get_size() {
    local sz r c
    sz=$(stty size </dev/tty 2>/dev/null)
    if [[ "$sz" =~ ^([0-9]+)[[:space:]]+([0-9]+)$ ]]; then
        r=${BASH_REMATCH[1]}
        c=${BASH_REMATCH[2]}
    else
        r=$(tput lines 2>/dev/null)
        c=$(tput cols 2>/dev/null)
    fi
    [[ "$c" =~ ^[0-9]+$ ]] && (( c > 0 )) || c=${COLUMNS:-80}
    [[ "$r" =~ ^[0-9]+$ ]] && (( r > 0 )) || r=${LINES:-24}
    SCR_W=$c
    SCR_H=$r
}
get_size
trap get_size WINCH

cleanup() {
    printf '\033[?25h\033[0m'
}
trap cleanup EXIT
trap 'cleanup; clear; exit 130' INT TERM

# width used for menus (capped so layout stays neat)
term_width() {
    local w=$SCR_W
    (( w < 30 )) && w=30
    (( w > 100 )) && w=100
    echo "$w"
}

# ---------- gradient line (cyan -> purple -> pink) ----------
grad() {
    local w=$1 ch=${2:-─} i t r g b out="" d
    d=$(( w > 1 ? w - 1 : 1 ))
    for ((i=0; i<w; i++)); do
        t=$(( i * 200 / d ))
        if (( t <= 100 )); then
            r=$(( 190 * t / 100 )); g=$(( 255 - 165 * t / 100 )); b=255
        else
            t=$(( t - 100 ))
            r=$(( 190 + 65 * t / 100 )); g=$(( 90 - 10 * t / 100 )); b=$(( 255 - 65 * t / 100 ))
        fi
        out+="${ESC}[38;2;${r};${g};${b}m${ch}"
    done
    printf '%s%s\n' "$out" "$RESET"
}

line() { grad "$(term_width)" "─"; }

# center "plain text" "color codes"
center() {
    local t="$1" c="$2" w pad
    w=$(term_width)
    pad=$(( (w - ${#t}) / 2 ))
    (( pad < 0 )) && pad=0
    printf '%*s%s%s%s\n' "$pad" '' "$c" "$t" "$RESET"
}

rainbow_text() {
    local t="$1" i out=""
    local -a P=("$PINK" "$PURPLE" "$BLUE" "$CYAN" "$GREEN" "$YELLOW" "$ORANGE")
    for ((i=0; i<${#t}; i++)); do
        out+="${P[i % 7]}${t:i:1}"
    done
    printf '%s%s' "$out" "$RESET"
}

# ---------- boxes ----------
BOXW=60
set_boxw() {
    BOXW=$(( $(term_width) - 4 ))
    (( BOXW > 72 )) && BOXW=72
}

box_top() {  # color title
    local c="$1" t=" $2 " fill
    set_boxw
    fill=$(( BOXW - 3 - ${#t} ))
    (( fill < 0 )) && fill=0
    printf '  %s╭─%s%s%s%s' "$c" "$BOLD" "$t" "$RESET" "$c"
    rep '─' "$fill"
    printf '╮%s\n' "$RESET"
}

box_bottom() {  # color
