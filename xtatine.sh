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
    printf '  %s╰' "$1"
    rep '─' "$(( BOXW - 2 ))"
    printf '╯%s\n' "$RESET"
}

box_row() {  # number color label bordercolor
    local n="$1" c="$2" label="$3" bc="$4" inner pad
    inner=$(( BOXW - 2 ))
    pad=$(( inner - 7 - ${#label} ))
    (( pad < 0 )) && pad=0
    printf '  %s│%s %s[%02d]%s  %s%s%s%*s%s│%s\n' \
        "$bc" "$RESET" "$c" "$n" "$RESET" "$BOLD$c" "$label" "$RESET" "$pad" '' "$bc" "$RESET"
}

kv_row() {  # label color value bordercolor
    local lab="$1" c="$2" val="$3" bc="$4" inner maxv pad
    inner=$(( BOXW - 2 ))
    maxv=$(( inner - 18 ))
    (( maxv < 1 )) && maxv=1
    val="${val:0:maxv}"
    pad=$(( maxv - ${#val} ))
    printf '  %s│%s %s%-14s%s %s›%s %s%s%*s%s│%s\n' \
        "$bc" "$RESET" "$BOLD$c" "$lab" "$RESET" "$DARK" "$RESET" "$WHITE" "$val" "$pad" '' "$bc" "$RESET"
}

text_row() {  # plain text color bordercolor
    local t="$1" c="$2" bc="$3" inner pad
    inner=$(( BOXW - 2 ))
    t="${t:0:inner-2}"
    pad=$(( inner - 1 - ${#t} ))
    (( pad < 0 )) && pad=0
    printf '  %s│%s %s%s%s%*s%s│%s\n' "$bc" "$RESET" "$c" "$t" "$RESET" "$pad" '' "$bc" "$RESET"
}

pause_back() {
    echo
    printf "  ${CYAN}[ ENTER ]${WHITE} Main Menu   ${YELLOW}[ B ]${WHITE} Back   ${RED}[ 0 ]${WHITE} Exit${RESET}\n"
    read -r -p "  ➤ " ans
    case "$ans" in
        0) exit_app ;;
        *) return ;;
    esac
}

exit_app() {
    clear
    echo
    grad "$(term_width)" "═"
    echo
    center "✦ SESSION TERMINATED • SEE YOU SOON ✦" "$CYAN$BOLD"
    center "Developed with passion by ${DEVELOPER}" "$GREEN"
    echo
    grad "$(term_width)" "═"
    echo
    exit 0
}

MODEL=$(getprop ro.product.model 2>/dev/null)
[[ -z "$MODEL" ]] && MODEL="Android"

# ---------- ART DATA ----------
mapfile -t DEMON <<'DEMONEOF'
00000000000001100000000000000000000000000000000110000000000000
00000000000011110000000011110000001111000000001111000000000000
00000000000001100001100001100000000110000110000110000000000000
00000001100011110001100001100000000110000110001111000110000000
00000011110111111011110111111000011111101111011111101111000000
00000001100011110011110011110000001111001111001111000110000000
00110011110011110011110011110000001111001111001111001111001100
00110111111111111111111111111000011111111111111111111111101100
01111011110011110011111111111111111111111111001111001111011110
01111111111111111111111111111111111111111111111111111111111110
01111111111111111111111111111111111111111111111111111111111110
11111111111111111111111111111111111111111111111111111111111111
00011111111111111111111111111111111111111111111111111111111000
00111111111111111111111111111111111111111111111111111111111100
00111111111111111111111111111111111111111111111111111111111100
00111111111111111111111111111111111111111111111111111111111100
00111111110000011111111111111111111111111111111000001111111100
00011111110000000001111111111111111111111110000000001111111000
00000111111100000000000011110000001111000000000000111111100000
00000000111111110000000011110000001111000000001111111100000000
00000001111111111111111111111111111111111111111111111110000000
00000111111111111111111111111111111111111111111111111111100000
00000111101111011110111101111011011110111101111011110111100000
00000000011111111111111111000000000011111111111111111000000000
00000000000000000011111111110000001111111111000000000000000000
00000000000000000011111111110000001111111111000000000000000000
00000000000000000011111111110000001111111111000000000000000000
00000000000000000011111111110000001111111111000000000000000000
00000000000000000011111111110000001111111111000000000000000000
00000000000000000011100010110000001101000111000000000000000000
00000000000000000011100010110000001101000111000000000000000000
DEMONEOF

mapfile -t NAME_ART <<'NAMEEOF'
██╗  ██╗ █████╗ ██╗    ██╗███████╗ █████╗ ██████╗ 
██║ ██╔╝██╔══██╗██║    ██║██╔════╝██╔══██╗██╔══██╗
█████╔╝ ███████║██║ █╗ ██║███████╗███████║██████╔╝
██╔═██╗ ██╔══██║██║███╗██║╚════██║██╔══██║██╔══██╗
██║  ██╗██║  ██║╚███╔███╔╝███████║██║  ██║██║  ██║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
NAMEEOF

mapfile -t WAVE_ART <<'WAVEEOF'
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
WAVEEOF

# pre-render the red demon (made of ¶ on a dotted background)
DEMON_C=()
build_demon() {
    local y x row line r cell prev
    for ((y=0; y<${#DEMON[@]}; y++)); do
        row=${DEMON[y]}
        line=""
        prev=""
        r=$(( 100 + (y < 16 ? y : 31 - y) * 8 ))
        for ((x=0; x<${#row}; x++)); do
            if [[ "${row:x:1}" == "1" ]]; then
                if [[ "$prev" != "on" ]]; then line+="${ESC}[38;2;${r};$(( y % 2 ? 0 : 12 ));0m"; prev="on"; fi
                line+="¶"
            elif (( x % 2 == 0 )); then
                if [[ "$prev" != "dot" ]]; then line+="${ESC}[38;2;75;10;10m"; prev="dot"; fi
                line+="·"
            else
                line+=" "
            fi
        done
        DEMON_C[y]="${line}${RESET}"
    done
}
build_demon

print_demon() {
    local w pad i
    w=$(term_width)
    pad=$(( (w - 62) / 2 ))
    (( pad < 0 )) && pad=0
    for ((i=0; i<${#DEMON_C[@]}; i++)); do
        printf '%*s%s\n' "$pad" '' "${DEMON_C[i]}"
    done
}

# big gradient "KAWSAR": print_name "r g b" "r g b"
print_name() {
    local w pad i r g b r1 g1 b1 r2 g2 b2 n=${#NAME_ART[@]}
    w=$(term_width)
    read -r r1 g1 b1 <<<"$1"
    read -r r2 g2 b2 <<<"$2"
    if (( w < 52 )); then
        center "K A W S A R" "$BOLD$(printf '\033[38;2;%d;%d;%dm' "$r1" "$g1" "$b1")"
        return
    fi
    pad=$(( (w - 50) / 2 ))
    for ((i=0; i<n; i++)); do
        r=$(( r1 + (r2 - r1) * i / (n - 1) ))
        g=$(( g1 + (g2 - g1) * i / (n - 1) ))
        b=$(( b1 + (b2 - b1) * i / (n - 1) ))
        printf '%*s\033[1;38;2;%d;%d;%dm%s%s\n' "$pad" '' "$r" "$g" "$b" "${NAME_ART[i]}" "$RESET"
    done
}

# blue/green wave emblem
print_art2() {
    local w pad i line n=${#WAVE_ART[@]} lr lg lb rr rg rb
    w=$(term_width)
    pad=$(( (w - 53) / 2 ))
    (( pad < 0 )) && pad=0
    for ((i=0; i<n; i++)); do
        line="${WAVE_ART[i]}"
        lr=$(( 120 - i * 4 )); lg=$(( 110 + i * 8 )); lb=255
        rr=60; rg=$(( 255 - i * 6 )); rb=$(( 120 - i * 4 ))
        printf '%*s\033[1;38;2;%d;%d;%dm%s\033[1;38;2;%d;%d;%dm%s%s\n' \
            "$pad" '' "$lr" "$lg" "$lb" "${line:0:20}" "$rr" "$rg" "$rb" "${line:20}" "$RESET"
    done
}

center_rainbow() {
    local t="$1" w pad
    w=$(term_width)
    pad=$(( (w - ${#t}) / 2 ))
    (( pad < 0 )) && pad=0
    printf '%*s' "$pad" ''
    rainbow_text "$t"
    echo
}

spaced() {
    local t="$1" o="" i
    for ((i=0; i<${#t}; i++)); do o+="${t:i:1} "; done
    printf '%s' "${o% }"
}

status_lines() {
    printf "  ${GREEN}● SYSTEM ONLINE${RESET} ${DARK}│${RESET} ${YELLOW}VERSION ${ORANGE}${VERSION}${RESET} ${DARK}│${RESET} ${SKY}TERMUX / ANDROID${RESET}\n"
    printf "  ${PINK}OPERATOR${RESET} ${DARK}›${RESET} ${PURPLE}${BOLD}${DEVELOPER}${RESET} ${DARK}│${RESET} ${TEAL}%s${RESET} ${DARK}│${RESET} ${GRAY}%s${RESET}\033[K\n" "$MODEL" "$(date '+%d %b %Y  %I:%M %p')"
}

# standard header (used by tool screens)
header() {
    if [[ "$1" == "keep" ]]; then printf '\033[H'; else clear; fi
    local w pad l
    w=$(term_width)
    echo
    if (( w >= 56 )); then
        pad=$(( (w - 56) / 2 ))
        for l in "${LOGO[@]}"; do
            printf '%*s%s%s%s%s\n' "$pad" '' "$CYAN" "$BOLD" "$l" "$RESET"
        done
    else
        center "X T A T I N E" "$CYAN$BOLD"
    fi
    echo
    line
    center_rainbow "◢◤  H A C K E R   T E R M I N A L   S U I T E  ◥◣"
    line
    status_lines
    line
    echo
}

# main dashboard header: demon emblem, then the name, then XTATINE banner
dash_header() {
    clear
    local w
    w=$(term_width)
    if (( SCR_H >= 76 && w >= 64 )); then
        echo
        print_demon
        echo
        print_name "255 50 50" "255 200 60"
        echo
        line
        center "✦  X T A T I N E  ✦" "$CYAN$BOLD"
        center_rainbow "◢◤  H A C K E R   T E R M I N A L   S U I T E  ◥◣"
        line
        status_lines
        line
        echo
    else
        header
    fi
}

type_text() {
    local t="$1" d="${2:-0.02}" i
    for ((i=0; i<${#t}; i++)); do
        printf '%s' "${t:i:1}"
        sleep "$d"
    done
}

boot() {
    local s i n
    local -a steps=("Loading kernel modules" "Mounting matrix engine" "Calibrating orbital scanner" "Decrypting UI themes" "Opening secure shell")
    clear
    printf '\033[?25l'
    echo
    if (( SCR_H >= 60 && $(term_width) >= 64 )); then
        print_demon
        echo
    fi
    print_name "255 50 50" "255 200 60"
    echo
    printf "  ${GREEN}root${WHITE}@${CYAN}xtatine${WHITE}:${BLUE}~${WHITE}# ${RESET}"
    type_text "./xtatine --init" 0.04
    echo
    echo
    for s in "${steps[@]}"; do
        printf "  ${DARK}[${YELLOW} .. ${DARK}]${RESET} ${GRAY}%s${RESET}" "$s"
        sleep 0.18
        printf "\r  ${DARK}[${GREEN} OK ${DARK}]${RESET} ${WHITE}%s${RESET}\033[K\n" "$s"
    done
    echo
    for ((n=0; n<=30; n++)); do
        printf '\r  %s[%s' "$CYAN" "$GREEN"
        for ((i=0; i<n; i++)); do printf '█'; done
        printf '%s' "$DARK"
        for ((i=n; i<30; i++)); do printf '░'; done
        printf '%s]%s %3d%%' "$CYAN" "$WHITE" $(( n * 100 / 30 ))
        sleep 0.03
    done
    echo
    echo
    center_rainbow "[ A C C E S S   G R A N T E D ]"
    sleep 0.8
    printf '\033[?25h'
}

# ---------- MATRIX RAIN (full screen, spaced columns, long trails) ----------
# usage: rain <speed> "r g b" ["r g b" ...]
rain() {
    local speed="$1"; shift
    local -a pal=("$@")
    local np=${#pal[@]} nch=${#CHARS}
    local p r g b
    local -a L1=() L2=() D1=() D2=() D3=()
    local HEAD=$'\033[1;97m'

    for ((p=0; p<np; p++)); do
        read -r r g b <<<"${pal[p]}"
        L1[p]=$(printf '\033[1;38;2;%d;%d;%dm' "$r" "$g" "$b")
        L2[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*72/100)) $((g*72/100)) $((b*72/100)))
        D1[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*48/100)) $((g*48/100)) $((b*48/100)))
        D2[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*30/100)) $((g*30/100)) $((b*30/100)))
        D3[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*16/100)) $((g*16/100)) $((b*16/100)))
    done

    local cols rows hs ncol i y x row ch buf key frame=0 len
    local -a Y=() LEN=() SP=() CM=()
    printf '\033[?25l'
    while true; do
        get_size
        cols=$SCR_W
        hs=$SCR_H
        rows=$hs
        (( rows < 10 )) && rows=10
        ncol=$(( (cols + 1) / 2 ))
        CM=()
        for ((i=0; i<ncol; i++)); do
            Y[i]=$(( -(RANDOM % rows) ))
            LEN[i]=$(( 6 + RANDOM % (rows - 4) ))
            SP[i]=$(( 1 + RANDOM % 3 ))
        done
        printf '\033[0m\033[2J'

        while (( cols == SCR_W && hs == SCR_H )); do
            buf=""
            for ((i=0; i<ncol; i++)); do
                (( frame % SP[i] )) && continue
                y=$(( Y[i] + 1 ))
                Y[i]=$y
                x=$(( 2*i + 1 ))
                len=${LEN[i]}
                p=$(( i % np ))

                if (( y >= 1 && y <= rows )); then
                    ch=${CHARS:$((RANDOM % nch)):1}
                    CM[i*rows+y]=$ch
                    buf+="${ESC}[${y};${x}H${HEAD}${ch}"
                fi
                row=$(( y - 1 ))
                (( row >= 1 && row <= rows )) && buf+="${ESC}[${row};${x}H${L1[p]}${CM[i*rows+row]}"
                row=$(( y - 2 ))
                (( row >= 1 && row <= rows )) && buf+="${ESC}[${row};${x}H${L2[p]}${CM[i*rows+row]}"
                row=$(( y - len + 3 ))
                (( row >= 1 && row <= rows )) && buf+="${ESC}[${row};${x}H${D1[p]}${CM[i*rows+row]}"
                row=$(( y - len + 2 ))
                (( row >= 1 && row <= rows )) && buf+="${ESC}[${row};${x}H${D2[p]}${CM[i*rows+row]}"
                row=$(( y - len + 1 ))
                (( row >= 1 && row <= rows )) && buf+="${ESC}[${row};${x}H${D3[p]}${CM[i*rows+row]}"
                row=$(( y - len ))
                (( row >= 1 && row <= rows )) && buf+="${ESC}[${row};${x}H "

                if (( y - len > rows )); then
                    Y[i]=$(( -(RANDOM % (rows / 2 + 1)) ))
                    LEN[i]=$(( 6 + RANDOM % (rows - 4) ))
                    SP[i]=$(( 1 + RANDOM % 3 ))
                fi
            done
            if (( frame < 50 )); then
                buf+="${ESC}[1;1H${ESC}[30;46m XTATINE • Q / B = BACK ${RESET}"
            elif (( frame == 50 )); then
                buf+="${ESC}[1;1H${ESC}[0m                         "
            fi
            printf '%s' "$buf"
            frame=$(( frame + 1 ))
            if read -rsn1 -t "$speed" key; then
                case "$key" in
                    q|Q|b|B) printf '\033[0m\033[?25h'; clear; return ;;
                esac
            fi
        done
    done
}

# ---------- ORBITAL GLOBE (rotating Earth, ASCII shading) ----------
IFS= read -r -d '' AWK_GLOBE <<'AWKEOF'
function nrm(d){ while(d>180)d-=360; while(d<-180)d+=360; return d }
function wrap(d){ d=nrm(d); return d<0?-d:d }
function land(lat,lon,   i,dy,dx){
  if(lat<-70) return 1
  for(i=1;i<=N;i++){
    dy=(lat-CL[i])/RY[i]; dx=wrap(lon-CO[i])/RX[i]
    if(dy*dy+dx*dx<1) return 1
  }
  return 0
}
BEGIN{
  PI=3.14159265358979; ESC=sprintf("%c",27)
  N=split("45 -100 22 36;63 -105 12 30;62 -150 8 14;72 -40 9 14;18 -92 7 10;-12 -58 26 17;5 -68 10 12;-40 -68 14 6;50 12 12 24;63 15 9 10;28 15 11 28;3 20 18 24;-20 25 15 18;-18 47 7 4;52 90 20 55;35 100 18 28;22 78 12 11;15 105 12 8;24 45 10 12;36 138 7 4;-25 134 13 20;-3 112 5 15;-41 173 6 4;52 -2 5 4",BL,";")
  for(i=1;i<=N;i++){ split(BL[i],t," "); CL[i]=t[1]; CO[i]=t[2]; RY[i]=t[3]; RX[i]=t[4] }
  ramp=".:-/+osyhdN@"; nr=length(ramp)
  oramp="..-:"
  Rc=Rr*2
  for(r=-Rr;r<=Rr;r++){
    out=ESC "[" (top+r+Rr) ";" off "H"; last=""
    ny=r/Rr
    for(c=-Rc;c<=Rc;c++){
      nx=c/Rc; d=nx*nx+ny*ny
      if(d>1){ out=out " "; continue }
      nz=sqrt(1-d)
      lat=atan2(-ny, sqrt(1-ny*ny))*180/PI
      lon=nrm(atan2(nx,nz)*180/PI - rot)
      qa=int((lat+90)/4); qo=int((lon+180)/4)
      h=(qa*53+qo*29+(qa*qo)%17)%47
      if(land(lat,lon)){
        ix=int((nz^0.5)*(nr-0.001)); ch=substr(ramp,ix+1,1)
        lit=0.4+0.6*nz
        R=int(lr*lit); G=int(lg*lit); B=int(lb*lit)
      } else if(h%2==0){
        ix=int(nz*3.99); ch=substr(oramp,ix+1,1)
        lit=0.45+0.55*nz
        R=int(wr*lit); G=int(wg*lit); B=int(wb*lit)
      } else { out=out " "; continue }
      key=R "," G "," B
      if(key!=last){ out=out ESC "[38;2;" R ";" G ";" B "m"; last=key }
      out=out ch
    }
    out=out ESC "[0m"
    printf "%s", out
  }
}
AWKEOF

GH=3
globe_header() {  # title r g b
    local title="$1" r="$2" g="$3" b="$4" tc sp
    tc=$(printf '\033[1;38;2;%d;%d;%dm' "$r" "$g" "$b")
    sp=$(spaced "$title")
    printf '\033[0m\033[2J\033[H'
    if (( SCR_H >= 46 )); then
        echo
        print_art2
        print_name "0 230 255" "90 255 130"
        echo
        center "◢◤  $sp  ◥◣" "$tc"
        center "░▒▓ ORBITAL SCAN IN PROGRESS ▓▒░" "$GRAY"
        GH=20
    else
        printf '\033[2;1H'
        center "◢◤  $sp  ◥◣" "$tc"
        GH=3
    fi
}

# usage: globe "r g b" (land)  "r g b"|auto (ocean)  "TITLE"
globe() {
    if ! command -v awk >/dev/null 2>&1; then
        header
        printf "  ${YELLOW}awk not found. Run: pkg install gawk${RESET}\n"
        pause_back
        return
    fi
    local land="$1" ocean="$2" title="$3" lr lg lb wr wg wb
    local rot=0 Rr top off key hs=0 ws=0 fr avail
    read -r lr lg lb <<<"$land"
    if [[ "$ocean" == "auto" ]]; then
        wr=$(( lr * 32 / 100 )); wg=$(( lg * 32 / 100 )); wb=$(( lb * 32 / 100 ))
    else
        read -r wr wg wb <<<"$ocean"
    fi
    printf '\033[?25l'
    while true; do
        get_size
        if (( hs != SCR_H || ws != SCR_W )); then
            hs=$SCR_H; ws=$SCR_W
            globe_header "$title" "$lr" "$lg" "$lb"
        fi
        avail=$(( SCR_H - GH - 2 ))
        Rr=$(( (avail - 1) / 2 ))
        (( Rr > 30 )) && Rr=30
        (( Rr * 4 + 1 > SCR_W )) && Rr=$(( (SCR_W - 1) / 4 ))
        (( Rr < 3 )) && Rr=3
        off=$(( (SCR_W - (4 * Rr + 1)) / 2 + 1 ))
        (( off < 1 )) && off=1
        top=$(( GH + 2 ))
        fr=$(awk -v Rr="$Rr" -v top="$top" -v off="$off" -v rot="$rot" \
                 -v lr="$lr" -v lg="$lg" -v lb="$lb" -v wr="$wr" -v wg="$wg" -v wb="$wb" "$AWK_GLOBE")
        printf '%s' "$fr"
        printf '\033[1;1H\033[30;46m Q / B = BACK \033[0m'
        printf '\033[%d;1H\033[2K%s TARGET: EARTH  %sROT: %03d°%s' "$SCR_H" "$GREEN" "$CYAN" "$rot" "$RESET"
        rot=$(( (rot + 3) % 360 ))
        if read -rsn1 -t 0.02 key; then
            case "$key" in
                q|Q|b|B) printf '\033[0m\033[?25h'; clear; return ;;
            esac
        fi
    done
}

# ---------- BIG DIGITS ----------
declare -A F
F[0]="███|█ █|█ █|█ █|███"
F[1]=" █ |██ | █ | █ |███"
F[2]="███|  █|███|█  |███"
F[3]="███|  █|███|  █|███"
F[4]="█ █|█ █|███|  █|  █"
F[5]="███|█  |███|  █|███"
F[6]="███|█  |███|█ █|███"
F[7]="███|  █|  █|  █|  █"
F[8]="███|█ █|███|█ █|███"
F[9]="███|█ █|███|  █|███"
F[':']=" |█| |█| "

big_time() {
    local t="$1" r i c line
    local -a parts
    local -a RC=("$CYAN" "$SKY" "$BLUE" "$PURPLE" "$PINK")
    for r in 0 1 2 3 4; do
        line=""
        for ((i=0; i<${#t}; i++)); do
            c="${t:i:1}"
            IFS='|' read -ra parts <<<"${F[$c]}"
            line+="${parts[r]} "
        done
        center "$line" "$BOLD${RC[r]}"
    done
}

# ---------- 1. WORLD CHRONO (live world clock) ----------
ZI="${PREFIX:-/data/data/com.termux/files/usr}/share/zoneinfo"
CITIES=("Dhaka|Asia/Dhaka|6" "Dubai|Asia/Dubai|4" "London|Europe/London|0" "New York|America/New_York|-5" "Los Angeles|America/Los_Angeles|-8" "Tokyo|Asia/Tokyo|9" "Sydney|Australia/Sydney|11")

city_time() {  # tz fallback-offset-hours  -> "HH:MM:SS AM|HH"
    if [[ -e "$ZI/$1" ]]; then
        TZ="$1" date '+%I:%M:%S %p|%H'
    else
        date -u -d "@$(( $(date +%s) + $2 * 3600 ))" '+%I:%M:%S %p|%H'
    fi
}

world_clock() {
    local key entry nm tz off res t hh icon i
    local -a CC=("$GREEN" "$CYAN" "$YELLOW" "$PINK" "$ORANGE" "$PURPLE" "$SKY")
    printf '\033[?25l'
    clear
    while true; do
        header keep
        center "◆ WORLD CHRONO TERMINAL ◆" "$PINK$BOLD"
        echo
        center "LOCAL TIME" "$GRAY"
        big_time "$(date '+%I:%M:%S')"
        center "$(date '+%p  •  %A, %d %B %Y')" "$YELLOW"
        echo
        box_top "$SKY" "◆ WORLD TIME GRID"
        i=0
        for entry in "${CITIES[@]}"; do
            IFS='|' read -r nm tz off <<<"$entry"
            res=$(city_time "$tz" "$off")
            t=${res%%|*}
            hh=${res##*|}
            if (( 10#$hh >= 6 && 10#$hh < 18 )); then icon="☼"; else icon="☾"; fi
            kv_row "$nm" "${CC[i]}" "$t  $icon" "$SKY"
            i=$(( i + 1 ))
        done
        kv_row "UTC" "$WHITE" "$(date -u '+%I:%M:%S %p')" "$SKY"
        kv_row "UNIX EPOCH" "$GRAY" "$(date +%s)" "$SKY"
        box_bottom "$SKY"
        echo
        printf "  ${YELLOW}Q / B${WHITE} Back to Main Menu${RESET} ${GRAY}• live • ☼ day  ☾ night${RESET}\033[K\n"
        printf '\033[J'
        if read -r -s -n 1 -t 1 key; then
            [[ "$key" == "q" || "$key" == "Q" || "$key" == "b" || "$key" == "B" ]] && break
        fi
    done
    printf '\033[?25h'
}

# ---------- 2. DEVICE RECON ----------
system_info() {
    header
    local sz us av pc up
    up=$(uptime -p 2>/dev/null | sed 's/^up //')
    [[ -z "$up" ]] && up="N/A"
    box_top "$PURPLE" "◆ DEVICE RECON"
    kv_row "DEVICE MODEL"  "$GREEN"  "$(getprop ro.product.model 2>/dev/null || echo Unknown)" "$PURPLE"
    kv_row "MANUFACTURER"  "$CYAN"   "$(getprop ro.product.manufacturer 2>/dev/null || echo Unknown)" "$PURPLE"
    kv_row "ANDROID"       "$YELLOW" "$(getprop ro.build.version.release 2>/dev/null || echo Unknown)" "$PURPLE"
    kv_row "ARCHITECTURE"  "$PINK"   "$(uname -m 2>/dev/null)" "$PURPLE"
    kv_row "KERNEL"        "$ORANGE" "$(uname -r 2>/dev/null)" "$PURPLE"
    kv_row "SHELL"         "$TEAL"   "${SHELL:-bash}" "$PURPLE"
    kv_row "UPTIME"        "$LIME"   "$up" "$PURPLE"
    box_bottom "$PURPLE"
    echo
    read -r sz us av pc < <(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $2,$3,$4,$5}')
    box_top "$TEAL" "◆ DATA VAULT"
    kv_row "TOTAL"     "$SKY"    "${sz:-N/A}" "$TEAL"
    kv_row "USED"      "$ORANGE" "${us:-N/A} (${pc:-N/A})" "$TEAL"
    kv_row "AVAILABLE" "$GREEN"  "${av:-N/A}" "$TEAL"
    box_bottom "$TEAL"
    pause_back
}

# ---------- 3. NET RADAR ----------
network_info() {
    header
    local ip wifi ssid lat q bar i c
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    [[ -z "$ip" ]] && ip="Not available"
    if command -v termux-wifi-connectioninfo >/dev/null 2>&1; then
        wifi=$(termux-wifi-connectioninfo 2>/dev/null)
        ssid=$(printf '%s' "$wifi" | sed -n 's/.*"ssid"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n1)
        [[ -z "$ssid" ]] && ssid="Unavailable"
    else
        ssid="Termux:API optional"
    fi
    lat=""
    if command -v ping >/dev/null 2>&1; then
        lat=$(ping -c 1 -W 2 1.1.1.1 2>/dev/null | sed -n 's/.*time=\([0-9.]*\).*/\1/p' | head -n1)
    fi
    box_top "$BLUE" "◆ NET RADAR"
    kv_row "HOSTNAME"   "$GREEN"  "$(hostname 2>/dev/null || echo Unknown)" "$BLUE"
    kv_row "LOCAL IP"   "$CYAN"   "$ip" "$BLUE"
    kv_row "WI-FI NAME" "$YELLOW" "$ssid" "$BLUE"
    if [[ -n "$lat" ]]; then
        kv_row "INTERNET" "$LIME" "● CONNECTED" "$BLUE"
        kv_row "LATENCY"  "$PINK" "${lat} ms" "$BLUE"
        q=$(( 10 - ${lat%.*} / 20 )); (( q < 1 )) && q=1; (( q > 10 )) && q=10
        c=$GREEN; (( q < 6 )) && c=$YELLOW; (( q < 3 )) && c=$RED
        bar="$c"
        for ((i=0; i<10; i++)); do
            if (( i < q )); then bar+="█"; else bar+="${DARK}░"; fi
        done
        printf '  %s│%s %sSIGNAL        %s %s%s%s\n' "$BLUE" "$RESET" "$BOLD$ORANGE" "$RESET" "$bar" "$RESET" ""
    else
        kv_row "INTERNET" "$RED" "✕ NOT CONFIRMED" "$BLUE"
    fi
    box_bottom "$BLUE"
    echo
    printf "  ${GRAY}Note: public IP and Wi-Fi details may be restricted by Android.${RESET}\n"
    pause_back
}

# ---------- 4. POWER CORE ----------
battery_info() {
    header
    local bj pct st hl pl tp filled bar c i
    if command -v termux-battery-status >/dev/null 2>&1; then
        bj=$(termux-battery-status 2>/dev/null)
        pct=$(sed -n 's/.*"percentage"[^0-9]*\([0-9]*\).*/\1/p' <<<"$bj" | head -n1)
        st=$(sed -n 's/.*"status"[^"]*"\([^"]*\)".*/\1/p' <<<"$bj" | head -n1)
        hl=$(sed -n 's/.*"health"[^"]*"\([^"]*\)".*/\1/p' <<<"$bj" | head -n1)
        pl=$(sed -n 's/.*"plugged"[^"]*"\([^"]*\)".*/\1/p' <<<"$bj" | head -n1)
        tp=$(sed -n 's/.*"temperature"[^0-9]*\([0-9.]*\).*/\1/p' <<<"$bj" | head -n1)
    fi
    box_top "$YELLOW" "◆ POWER CORE"
    if [[ "$pct" =~ ^[0-9]+$ ]]; then
        filled=$(( pct / 5 ))
        c=$GREEN
        (( pct < 50 )) && c=$YELLOW
        (( pct < 20 )) && c=$RED
        bar="$c"
        for ((i=0; i<20; i++)); do
            if (( i < filled )); then bar+="█"; else bar+="${DARK}░"; fi
        done
        kv_row "LEVEL"       "$c"      "${pct}%" "$YELLOW"
        printf '  %s│%s %s%s\n' "$YELLOW" "$RESET" "$bar" "$RESET"
        kv_row "STATUS"      "$CYAN"   "${st:-N/A}" "$YELLOW"
        kv_row "HEALTH"      "$GREEN"  "${hl:-N/A}" "$YELLOW"
        kv_row "PLUGGED"     "$PINK"   "${pl:-N/A}" "$YELLOW"
        kv_row "TEMPERATURE" "$ORANGE" "${tp:-N/A} °C" "$YELLOW"
    else
        text_row "Termux:API is not available." "$YELLOW" "$YELLOW"
        text_row "" "$WHITE" "$YELLOW"
        text_row "1. Install the Termux:API Android app." "$GREEN" "$YELLOW"
        text_row "2. In Termux run: pkg install termux-api" "$CYAN" "$YELLOW"
        text_row "3. Reopen XTATINE, choose Power Core." "$PINK" "$YELLOW"
    fi
    box_bottom "$YELLOW"
    pause_back
}

# ---------- 5. DEVELOPER ----------
developer() {
    header
    print_name "255 80 190" "80 200 255"
    echo
    center "◢◤  D E V E L O P E R  ◥◣" "$PINK$BOLD"
    echo
    box_top "$PINK" "◆ DEVELOPER PROFILE"
    kv_row "NAME"      "$CYAN"   "$DEVELOPER" "$PINK"
    kv_row "ROLE"      "$GREEN"  "Creator of XTATINE" "$PINK"
    kv_row "PROJECT"   "$YELLOW" "XTATINE Premium Suite" "$PINK"
    kv_row "VERSION"   "$ORANGE" "$VERSION" "$PINK"
    kv_row "PLATFORM"  "$SKY"    "Termux / Android" "$PINK"
    kv_row "LANGUAGE"  "$LIME"   "Bash + AWK" "$PINK"
    kv_row "THEME"     "$PURPLE" "Matrix • Cyan • RGB" "$PINK"
    kv_row "GITHUB"    "$TEAL"   "github.com/xtatine/XTATINE" "$PINK"
    box_bottom "$PINK"
    echo
    line
    center "BUILT TO MAKE YOUR TERMINAL UNIQUE" "$YELLOW"
    center "Thank you for using XTATINE!" "$GREEN"
    pause_back
}

# ---------- MENUS ----------
prompt() {
    printf "  ${GREEN}╭─[${WHITE}root${RED}@${CYAN}xtatine${GREEN}]─[${YELLOW}~/%s${GREEN}]${RESET}\n  ${GREEN}╰─${PINK}❯${CYAN}❯${GREEN}❯${RESET} " "$1"
}

section_divider() {  # text
    echo
    grad "$(term_width)" "═"
    center "$1" "$WHITE"
    grad "$(term_width)" "═"
    echo
}

main_menu() {
    local choice
    while true; do
        dash_header

        box_top "$PURPLE" "◆ MATRIX RAIN ENGINE"
        box_row 1 "$GREEN"  "Neural Rain       ▸ Green"  "$PURPLE"
        box_row 2 "$RED"    "Crimson Overlord  ▸ Red"    "$PURPLE"
        box_row 3 "$BLUE"   "Cobalt Protocol   ▸ Blue"   "$PURPLE"
        box_row 4 "$PURPLE" "Phantom Violet    ▸ Purple" "$PURPLE"
        box_row 5 "$YELLOW" "Golden Backdoor   ▸ Yellow" "$PURPLE"
        box_bottom "$PURPLE"
        echo
        box_top "$ORANGE" "◆ ORBITAL WORLD HACK"
        box_row 6 "$CYAN"   "World Hack      ▸ Green + Blue"    "$ORANGE"
        box_row 7 "$LAV"    "Planet Override ▸ Violet + Blue"   "$ORANGE"
        box_row 8 "$ORANGE" "Global Breach   ▸ Gold + Crimson"  "$ORANGE"
        box_bottom "$ORANGE"

        section_divider "◆◆◆  U T I L I T Y   M O D U L E S  ◆◆◆"

        box_top "$TEAL" "◆ CYBER TOOLS"
        box_row 9  "$SKY"  "World Chrono (live time)" "$TEAL"
        box_row 10 "$LIME" "Device Recon"             "$TEAL"
        box_row 11 "$TEAL" "Net Radar"                "$TEAL"
        box_row 12 "$ROSE" "Power Core"               "$TEAL"
        box_row 13 "$MINT" "Developer · KAWSAR"       "$TEAL"
        box_bottom "$TEAL"
        echo
        printf "  ${RED}${BOLD}[00]${RESET} ${WHITE}Terminate Session${RESET}\n"
        line
        prompt "modules"
        read -r choice || exit_app
        case "$choice" in
            1|01) rain 0.05 "0 255 70" ;;
            2|02) rain 0.05 "255 30 40" ;;
            3|03) rain 0.05 "60 140 255" ;;
            4|04) rain 0.05 "190 90 255" ;;
            5|05) rain 0.05 "255 215 40" ;;
            6|06) globe "40 255 120"  "30 110 255" "WORLD HACK" ;;
            7|07) globe "190 100 255" "50 100 255" "PLANET OVERRIDE" ;;
            8|08) globe "255 205 60"  "220 40 60"  "GLOBAL BREACH" ;;
            9|09) world_clock ;;
            10) system_info ;;
            11) network_info ;;
            12) battery_info ;;
            13) developer ;;
            0|00) exit_app ;;
            "") ;;
            *) printf "\n  ${RED}Invalid option. Choose 01–13 or 00.${RESET}\n"; sleep 1 ;;
        esac
    done
}

boot
main_menu
