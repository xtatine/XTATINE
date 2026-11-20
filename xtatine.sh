#!/data/data/com.termux/files/usr/bin/bash
# ==========================================================
# XTATINE TERMINAL SUITE
# VERSION 4.0 | DEVELOPER: KAWSAR
# ==========================================================

APP="XTATINE"
VERSION="4.0"
DEVELOPER="KAWSAR"
CHARS='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&*+=<>?/\|;:!^~()[]{}'

ESC=$'\033'
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

if ! [[ "${LC_ALL:-${LANG:-}}" == *[Uu][Tt][Ff]-8* ]]; then
    for _l in C.UTF-8 en_US.UTF-8 en_US.utf8; do
        if locale -a 2>/dev/null | grep -qix "$_l"; then export LC_ALL="$_l"; break; fi
    done
fi

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

DEV_LOGO=(
'██╗  ██╗ █████╗ ██╗    ██╗███████╗ █████╗ ██████╗ '
'██║ ██╔╝██╔══██╗██║    ██║██╔════╝██╔══██╗██╔══██╗'
'█████╔╝ ███████║██║ █╗ ██║███████╗███████║██████╔╝'
'██╔═██╗ ██╔══██║██║███╗██║╚════██║██╔══██║██╔══██╗'
'██║  ██╗██║  ██║╚███╔███╔╝███████║██║  ██║██║  ██║'
'╚═╝  ╚═╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝'
)

SCR_W=80
SCR_H=24
RESIZED=1

# Safe WINCH handler: only sets a flag (no stty/tput inside signal handler)
on_winch() {
    RESIZED=1
}
trap on_winch WINCH

refresh_size() {
    local r c line
    r=""
    c=""
    if [[ -r /dev/tty ]]; then
        line=$(stty size </dev/tty 2>/dev/null) || line=""
        if [[ "$line" =~ ^([0-9]+)[[:space:]]+([0-9]+)$ ]]; then
            r=${BASH_REMATCH[1]}
            c=${BASH_REMATCH[2]}
        fi
    fi
    [[ "$c" =~ ^[0-9]+$ ]] && (( c > 0 )) || c=${COLUMNS:-80}
    [[ "$r" =~ ^[0-9]+$ ]] && (( r > 0 )) || r=${LINES:-24}
    if (( r != SCR_H || c != SCR_W )); then
        SCR_W=$c
        SCR_H=$r
        RESIZED=1
    fi
}
refresh_size

cleanup() {
    printf '\033[?25h\033[0m'
}
trap cleanup EXIT
trap 'cleanup; clear; exit 130' INT TERM

term_width() {
    refresh_size
    local w=$SCR_W
    (( w < 24 )) && w=24
    (( w > 100 )) && w=100
    echo "$w"
}

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

center() {
    local t="$1" c="$2" w pad
    w=$(term_width)
    if (( ${#t} > w )); then
        t="${t:0:w}"
    fi
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

BOXW=60
set_boxw() {
    local w
    w=$(term_width)
    BOXW=$(( w - 4 ))
    (( BOXW < 20 )) && BOXW=20
    (( BOXW > 72 )) && BOXW=72
}

box_top() {
    local c="$1" t=" $2 " fill
    set_boxw
    if (( ${#t} > BOXW - 4 )); then
        t=" ${2:0:BOXW-6} "
    fi
    fill=$(( BOXW - 3 - ${#t} ))
    (( fill < 0 )) && fill=0
    printf '  %s╭─%s%s%s%s' "$c" "$BOLD" "$t" "$RESET" "$c"
    rep '─' "$fill"
    printf '╮%s\n' "$RESET"
}

box_bottom() {
    set_boxw
    printf '  %s╰' "$1"
    rep '─' "$(( BOXW - 2 ))"
    printf '╯%s\n' "$RESET"
}

box_row() {
    local n="$1" c="$2" label="$3" bc="$4" inner maxl pad
    set_boxw
    inner=$(( BOXW - 2 ))
    maxl=$(( inner - 8 ))
    (( maxl < 1 )) && maxl=1
    label="${label:0:maxl}"
    pad=$(( inner - 7 - ${#label} ))
    (( pad < 0 )) && pad=0
    printf '  %s│%s %s[%02d]%s  %s%s%s%*s%s│%s\n' \
        "$bc" "$RESET" "$c" "$n" "$RESET" "$BOLD$c" "$label" "$RESET" "$pad" '' "$bc" "$RESET"
}

kv_row() {
    local lab="$1" c="$2" val="$3" bc="$4" inner maxv pad
    set_boxw
    inner=$(( BOXW - 2 ))
    maxv=$(( inner - 18 ))
    (( maxv < 1 )) && maxv=1
    val="${val:0:maxv}"
    pad=$(( maxv - ${#val} ))
    (( pad < 0 )) && pad=0
    printf '  %s│%s %s%-14s%s %s›%s %s%s%*s%s│%s\n' \
        "$bc" "$RESET" "$BOLD$c" "$lab" "$RESET" "$DARK" "$RESET" "$WHITE" "$val" "$pad" '' "$bc" "$RESET"
}

text_row() {
    local t="$1" c="$2" bc="$3" inner pad
    set_boxw
    inner=$(( BOXW - 2 ))
    t="${t:0:inner-2}"
    pad=$(( inner - 1 - ${#t} ))
    (( pad < 0 )) && pad=0
    printf '  %s│%s %s%s%s%*s%s│%s\n' "$bc" "$RESET" "$c" "$t" "$RESET" "$pad" '' "$bc" "$RESET"
}

pause_back() {
    echo
    printf "  ${CYAN}[ ENTER ]${WHITE} Back / Main Menu   ${YELLOW}[ B ]${WHITE} Back   ${RED}[ 0 ]${WHITE} Exit${RESET}\n"
    read -r -p "  ➤ " ans || return
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

print_big_xtatine() {
    local w pad l
    w=$(term_width)
    if (( w >= 56 )); then
        pad=$(( (w - 56) / 2 ))
        for l in "${LOGO[@]}"; do
            printf '%*s%s%s%s%s\n' "$pad" '' "$CYAN" "$BOLD" "$l" "$RESET"
        done
    else
        center "X T A T I N E" "$CYAN$BOLD"
    fi
}

print_dev_name() {
    local w pad l
    w=$(term_width)
    if (( w >= 50 )); then
        pad=$(( (w - 50) / 2 ))
        for l in "${DEV_LOGO[@]}"; do
            printf '%*s%s%s%s%s\n' "$pad" '' "$PINK" "$BOLD" "$l" "$RESET"
        done
    else
        center "K A W S A R" "$PINK$BOLD"
    fi
}

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
    if (( ${#t} > w )); then
        t="${t:0:w}"
    fi
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

header() {
    if [[ "$1" == "keep" ]]; then printf '\033[H'; else clear; fi
    echo
    print_big_xtatine
    echo
    line
    center_rainbow "◢◤  H A C K E R   T E R M I N A L   S U I T E  ◥◣"
    line
    status_lines
    line
    echo
}

dash_header() {
    clear
    header
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
    local -a steps=("Loading kernel modules" "Mounting matrix engine" "Calibrating orbital scanner" "Opening secure shell")
    clear
    printf '\033[?25l'
    echo
    print_big_xtatine
    echo
    printf "  ${GREEN}root${WHITE}@${CYAN}xtatine${WHITE}:${BLUE}~${WHITE}# ${RESET}"
    type_text "./xtatine --init" 0.03
    echo
    echo
    for s in "${steps[@]}"; do
        printf "  ${DARK}[${YELLOW} .. ${DARK}]${RESET} ${GRAY}%s${RESET}" "$s"
        sleep 0.10
        printf "\r  ${DARK}[${GREEN} OK ${DARK}]${RESET} ${WHITE}%s${RESET}\033[K\n" "$s"
    done
    echo
    for ((n=0; n<=30; n++)); do
        printf '\r  %s[%s' "$CYAN" "$GREEN"
        for ((i=0; i<n; i++)); do printf '█'; done
        printf '%s' "$DARK"
        for ((i=n; i<30; i++)); do printf '░'; done
        printf '%s]%s %3d%%' "$CYAN" "$WHITE" $(( n * 100 / 30 ))
        sleep 0.02
    done
    echo
    echo
    center_rainbow "[ A C C E S S   G R A N T E D ]"
    sleep 0.4
    printf '\033[?25h'
}

# ---------- MATRIX RAIN (FULL SCREEN + ZOOM/RESIZE SAFE + ALWAYS VISIBLE BACK BAR) ----------
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
        L2[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*75/100)) $((g*75/100)) $((b*75/100)))
        D1[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*52/100)) $((g*52/100)) $((b*52/100)))
        D2[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*34/100)) $((g*34/100)) $((b*34/100)))
        D3[p]=$(printf '\033[22;38;2;%d;%d;%dm' $((r*20/100)) $((g*20/100)) $((b*20/100)))
    done

    local cols rows min_r ncol i y x row ch buf key frame=0 len back_msg
    local -a Y=() LEN=() SP=() CM=()
    printf '\033[?25l'
    RESIZED=1

    while true; do
        refresh_size
        if (( RESIZED == 1 )); then
            RESIZED=0
            cols=$SCR_W
            rows=$SCR_H
            (( cols < 10 )) && cols=10
            (( rows < 6 )) && rows=6
            min_r=2
            ncol=$cols
            CM=()
            Y=()
            LEN=()
            SP=()
            for ((i=0; i<ncol; i++)); do
                Y[i]=$(( min_r - (RANDOM % (rows - min_r + 1)) ))
                LEN[i]=$(( 5 + RANDOM % (rows - min_r + 1) ))
                SP[i]=$(( 1 + RANDOM % 2 ))
            done
            printf '\033[0m\033[2J\033[H'
        fi

        buf=""
        for ((i=0; i<ncol; i++)); do
            (( frame % SP[i] )) && continue
            y=$(( Y[i] + 1 ))
            Y[i]=$y
            x=$(( i + 1 ))
            len=${LEN[i]}
            p=$(( i % np ))

            if (( y >= min_r && y <= rows )); then
                ch=${CHARS:$((RANDOM % nch)):1}
                CM[i*rows+y]=$ch
                buf+="${ESC}[${y};${x}H${HEAD}${ch}"
            fi
            row=$(( y - 1 ))
            (( row >= min_r && row <= rows )) && buf+="${ESC}[${row};${x}H${L1[p]}${CM[i*rows+row]}"
            row=$(( y - 2 ))
            (( row >= min_r && row <= rows )) && buf+="${ESC}[${row};${x}H${L2[p]}${CM[i*rows+row]}"
            row=$(( y - len + 3 ))
            (( row >= min_r && row <= rows )) && buf+="${ESC}[${row};${x}H${D1[p]}${CM[i*rows+row]}"
            row=$(( y - len + 2 ))
            (( row >= min_r && row <= rows )) && buf+="${ESC}[${row};${x}H${D2[p]}${CM[i*rows+row]}"
            row=$(( y - len + 1 ))
            (( row >= min_r && row <= rows )) && buf+="${ESC}[${row};${x}H${D3[p]}${CM[i*rows+row]}"
            row=$(( y - len ))
            (( row >= min_r && row <= rows )) && buf+="${ESC}[${row};${x}H "

            if (( y - len > rows )); then
                Y[i]=$(( min_r - (RANDOM % ((rows - min_r) / 2 + 1)) ))
                LEN[i]=$(( 5 + RANDOM % (rows - min_r + 1) ))
                SP[i]=$(( 1 + RANDOM % 2 ))
            fi
        done

        back_msg=" [ Q / B ] BACK TO MAIN MENU "
        if (( cols < ${#back_msg} )); then
            back_msg=" Q/B=BACK "
        fi
        buf+="${ESC}[1;1H${ESC}[2K${ESC}[1;30;46m${back_msg}${RESET}"
        printf '%s' "$buf"
        frame=$(( frame + 1 ))

        if read -rsn1 -t "$speed" key; then
            case "$key" in
                q|Q|b|B) printf '\033[0m\033[?25h'; clear; return ;;
            esac
        fi
    done
}

# ---------- FAST 3-COLOR ROTATING EARTH GLOBE ----------
IFS= read -r -d '' AWK_GLOBE <<'AWKEOF'
function nrm(d){ while(d>180)d-=360; while(d<-180)d+=360; return d }
function wrap(d){ d=nrm(d); return d<0?-d:d }
function in_box(lat,lon,a,b,c,d){ return (lat>=a && lat<=b && lon>=c && lon<=d) }
function in_ell(lat,lon,clat,clon,ry,rx,   dy,dx){
  dy=(lat-clat)/ry; dx=wrap(lon-clon)/rx
  return (dy*dy+dx*dx<=1.0)
}
function land(lat,lon){
  if(lat<-72) return 1
  if(in_ell(lat,lon,72,-42,10,16) || in_box(lat,lon,62,78,-52,-25)) return 1
  if(in_ell(lat,lon,64,-152,8,15)) return 1
  if(in_ell(lat,lon,58,-102,14,32) || in_box(lat,lon,48,65,-125,-72)) return 1
  if(in_ell(lat,lon,41,-98,13,26) || in_box(lat,lon,28,48,-118,-74)) return 1
  if(in_ell(lat,lon,22,-99,8,10) || in_box(lat,lon,14,26,-105,-86)) return 1
  if(in_ell(lat,lon,-12,-56,22,17) || in_ell(lat,lon,-28,-62,14,10) || in_ell(lat,lon,-44,-68,11,5)) return 1
  if(in_ell(lat,lon,54,-2,5,4)) return 1
  if(in_ell(lat,lon,63,16,9,11)) return 1
  if(in_ell(lat,lon,48,14,11,24) || in_box(lat,lon,38,56,-9,35)) return 1
  if(in_ell(lat,lon,24,14,11,28) || in_box(lat,lon,16,33,-16,35)) return 1
  if(in_ell(lat,lon,4,22,15,19) || in_ell(lat,lon,-18,24,15,13)) return 1
  if(in_ell(lat,lon,-19,47,7,3)) return 1
  if(in_ell(lat,lon,24,46,10,11) || in_box(lat,lon,15,36,35,56)) return 1
  if(in_ell(lat,lon,58,85,15,58) || in_box(lat,lon,48,70,36,165)) return 1
  if(in_ell(lat,lon,36,96,17,28) || in_box(lat,lon,26,46,60,125)) return 1
  if(in_ell(lat,lon,20,78,12,9) || in_ell(lat,lon,12,78,7,5)) return 1
  if(in_ell(lat,lon,15,103,11,7) || in_ell(lat,lon,2,102,5,4)) return 1
  if(in_ell(lat,lon,36,138,7,4)) return 1
  if(in_ell(lat,lon,-2,114,5,15) || in_ell(lat,lon,-6,144,6,8)) return 1
  if(in_ell(lat,lon,-25,134,13,20) || in_box(lat,lon,-34,-14,115,150)) return 1
  if(in_ell(lat,lon,-41,173,6,3)) return 1
  return 0
}
BEGIN{
  PI=3.14159265358979; ESC=sprintf("%c",27)
  ramp=".:-/+osyh#WM@"; nr=length(ramp)
  oramp="..::--++"
  Rc=Rr*2
  for(r=-Rr;r<=Rr;r++){
    out=ESC "[" (top+r+Rr) ";" off "H"; last=""
    ny=r/Rr
    for(c=-Rc;c<=Rc;c++){
      nx=c/Rc; d=nx*nx+ny*ny
      if(d>1.0){ out=out " "; continue }
      nz=sqrt(1.0-d)
      lat=atan2(-ny, sqrt(1.0-ny*ny))*180.0/PI
      lon=nrm(atan2(nx,nz)*180.0/PI - rot)
      qa=int((lat+90)/3); qo=int((lon+180)/3)
      h=(qa*47+qo*31+(qa+qo)*7)%43
      if(land(lat,lon)){
        ix=int((nz^0.45)*(nr-0.001)); ch=substr(ramp,ix+1,1)
        lit=0.45+0.55*nz
        if(nz>0.72){
          R=int(hr*lit); G=int(hg*lit); B=int(hb*lit)
        } else {
          R=int(lr*lit); G=int(lg*lit); B=int(lb*lit)
        }
      } else if(h%4!=0){
        ix=int(nz*7.99); ch=substr(oramp,ix+1,1)
        lit=0.35+0.65*nz
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
globe_header() {
    local title="$1" r="$2" g="$3" b="$4" tc sp
    tc=$(printf '\033[1;38;2;%d;%d;%dm' "$r" "$g" "$b")
    sp=$(spaced "$title")
    printf '\033[0m\033[2J\033[H'
    if (( SCR_H >= 48 )); then
        echo
        print_art2
        echo
        print_big_xtatine
        echo
        center "◢◤  $sp  ◥◣" "$tc"
        center "░▒▓ ORBITAL SCAN SYSTEM ACTIVE ▓▒░" "$GRAY"
        GH=22
    elif (( SCR_H >= 24 )); then
        echo
        print_big_xtatine
        center "◢◤  $sp  ◥◣" "$tc"
        GH=11
    else
        printf '\033[2;1H'
        center "X T A T I N E  •  $sp" "$tc"
        GH=3
    fi
}

globe() {
    if ! command -v awk >/dev/null 2>&1; then
        header
        printf "  ${YELLOW}awk not found. Run: pkg install gawk${RESET}\n"
        pause_back
        return
    fi
    local c1="$1" c2="$2" c3="$3" title="$4"
    local lr lg lb wr wg wb hr hg hb
    local rot=0 Rr top off fr avail key
    read -r lr lg lb <<<"$c1"
    read -r wr wg wb <<<"$c2"
    read -r hr hg hb <<<"$c3"
    printf '\033[?25l'
    RESIZED=1

    while true; do
        refresh_size
        if (( RESIZED == 1 )); then
            RESIZED=0
            globe_header "$title" "$lr" "$lg" "$lb"
        fi
        avail=$(( SCR_H - GH - 3 ))
        Rr=$(( (avail - 1) / 2 ))
        (( Rr > 32 )) && Rr=32
        (( Rr * 4 + 1 > SCR_W )) && Rr=$(( (SCR_W - 1) / 4 ))
        (( Rr < 2 )) && Rr=2
        off=$(( (SCR_W - (4 * Rr + 1)) / 2 + 1 ))
        (( off < 1 )) && off=1
        top=$(( GH + 2 ))
        fr=$(awk -v Rr="$Rr" -v top="$top" -v off="$off" -v rot="$rot" \
                 -v lr="$lr" -v lg="$lg" -v lb="$lb" \
                 -v wr="$wr" -v wg="$wg" -v wb="$wb" \
                 -v hr="$hr" -v hg="$hg" -v hb="$hb" "$AWK_GLOBE" 2>/dev/null)
        printf '%s' "$fr"
        printf '\033[1;1H\033[30;46m [ Q / B ] BACK \033[0m'
        if (( SCR_H >= 2 )); then
            printf '\033[%d;1H\033[2K%s TARGET: EARTH  %sROT: %03d°  %s[ Q / B ] BACK TO MENU%s' \
                $(( SCR_H - 1 )) "$GREEN" "$CYAN" "$rot" "$YELLOW" "$RESET"
        fi
        printf '\033[%d;1H\033[2K%s Press Q or B to go back%s' "$SCR_H" "$WHITE" "$RESET"
        rot=$(( (rot + 8) % 360 ))
        if read -rsn1 -t 0.01 key; then
            case "$key" in
                q|Q|b|B) printf '\033[0m\033[?25h'; clear; return ;;
            esac
        fi
    done
}

# ---------- BIG DIGITS (SINGLE GREEN FOR DIGITS + DISTINCT COLOR FOR ':') ----------
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
    local t="$1" r i c w pad out plain
    local -a parts
    local COLON_COLOR="$YELLOW$BOLD"
    local DIGIT_COLOR="$GREEN$BOLD"
    w=$(term_width)
    for r in 0 1 2 3 4; do
        plain=""
        out=""
        for ((i=0; i<${#t}; i++)); do
            c="${t:i:1}"
            IFS='|' read -ra parts <<<"${F[$c]}"
            plain+="${parts[r]} "
            if [[ "$c" == ":" ]]; then
                out+="${COLON_COLOR}${parts[r]}${RESET} "
            else
                out+="${DIGIT_COLOR}${parts[r]}${RESET} "
            fi
        done
        pad=$(( (w - ${#plain}) / 2 ))
        (( pad < 0 )) && pad=0
        printf '%*s%s\n' "$pad" '' "$out"
    done
}

# ---------- UTILITY 1: LIVE WORLD TIME ----------
ZI="${PREFIX:-/data/data/com.termux/files/usr}/share/zoneinfo"
CITIES=("Dhaka|Asia/Dhaka|6" "Dubai|Asia/Dubai|4" "London|Europe/London|0" "New York|America/New_York|-5" "Tokyo|Asia/Tokyo|9")

city_time() {
    if [[ -e "$ZI/$1" ]]; then
        TZ="$1" date '+%I:%M:%S %p|%H'
    else
        date -u -d "@$(( $(date +%s) + $2 * 3600 ))" '+%I:%M:%S %p|%H'
    fi
}

world_clock() {
    local key entry nm tz off res t hh icon i
    local -a CC=("$GREEN" "$CYAN" "$YELLOW" "$PINK" "$PURPLE")
    printf '\033[?25l'
    clear
    while true; do
        header keep
        center "◆ LIVE WORLD TIME ◆" "$CYAN$BOLD"
        echo
        big_time "$(date '+%I:%M:%S')"
        center "$(date '+%p  •  %A, %d %B %Y')" "$YELLOW"
        echo
        box_top "$CYAN" "◆ GLOBAL CLOCK"
        i=0
        for entry in "${CITIES[@]}"; do
            IFS='|' read -r nm tz off <<<"$entry"
            res=$(city_time "$tz" "$off")
            t=${res%%|*}
            hh=${res##*|}
            if (( 10#$hh >= 6 && 10#$hh < 18 )); then icon="☼"; else icon="☾"; fi
            kv_row "$nm" "${CC[i]}" "$t  $icon" "$CYAN"
            i=$(( i + 1 ))
        done
        box_bottom "$CYAN"
        echo
        printf "  ${YELLOW}[ Q / B ]${WHITE} Back to Main Menu${RESET}\033[K\n"
        printf '\033[J'
        if read -r -s -n 1 -t 1 key; then
            [[ "$key" == "q" || "$key" == "Q" || "$key" == "b" || "$key" == "B" ]] && break
        fi
    done
    printf '\033[?25h'
}

# ---------- UTILITY 2: DEVICE INFO ----------
system_info() {
    header
    local sz us av pc
    box_top "$PURPLE" "◆ DEVICE INFO"
    kv_row "MODEL"     "$GREEN"  "$(getprop ro.product.model 2>/dev/null || echo Unknown)" "$PURPLE"
    kv_row "BRAND"     "$CYAN"   "$(getprop ro.product.manufacturer 2>/dev/null || echo Unknown)" "$PURPLE"
    kv_row "ANDROID"   "$YELLOW" "$(getprop ro.build.version.release 2>/dev/null || echo Unknown)" "$PURPLE"
    kv_row "ARCH"      "$PINK"   "$(uname -m 2>/dev/null)" "$PURPLE"
    kv_row "KERNEL"    "$ORANGE" "$(uname -r 2>/dev/null)" "$PURPLE"
    box_bottom "$PURPLE"
    echo
    read -r sz us av pc < <(df -h "$HOME" 2>/dev/null | awk 'NR==2{print $2,$3,$4,$5}')
    box_top "$TEAL" "◆ STORAGE"
    kv_row "TOTAL"     "$SKY"   "${sz:-N/A}" "$TEAL"
    kv_row "USED"      "$PINK"  "${us:-N/A} (${pc:-N/A})" "$TEAL"
    kv_row "FREE"      "$GREEN" "${av:-N/A}" "$TEAL"
    box_bottom "$TEAL"
    pause_back
}

# ---------- UTILITY 3: NET STATUS ----------
network_info() {
    header
    local ip lat
    ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    [[ -z "$ip" ]] && ip="Not available"
    lat=""
    if command -v ping >/dev/null 2>&1; then
        lat=$(ping -c 1 -W 2 1.1.1.1 2>/dev/null | sed -n 's/.*time=\([0-9.]*\).*/\1/p' | head -n1)
    fi
    box_top "$BLUE" "◆ NET STATUS"
    kv_row "LOCAL IP"  "$CYAN" "$ip" "$BLUE"
    if [[ -n "$lat" ]]; then
        kv_row "STATUS"  "$GREEN" "● ONLINE" "$BLUE"
        kv_row "PING"    "$PINK"  "${lat} ms" "$BLUE"
    else
        kv_row "STATUS"  "$RED"   "✕ OFFLINE" "$BLUE"
    fi
    box_bottom "$BLUE"
    pause_back
}

# ---------- UTILITY 4: POWER STATUS ----------
battery_info() {
    header
    local bj pct st tp
    if command -v termux-battery-status >/dev/null 2>&1; then
        bj=$(termux-battery-status 2>/dev/null)
        pct=$(sed -n 's/.*"percentage"[^0-9]*\([0-9]*\).*/\1/p' <<<"$bj" | head -n1)
        st=$(sed -n 's/.*"status"[^"]*"\([^"]*\)".*/\1/p' <<<"$bj" | head -n1)
        tp=$(sed -n 's/.*"temperature"[^0-9]*\([0-9.]*\).*/\1/p' <<<"$bj" | head -n1)
    fi
    box_top "$YELLOW" "◆ POWER STATUS"
    if [[ "$pct" =~ ^[0-9]+$ ]]; then
        kv_row "BATTERY" "${pct}%" "$GREEN" "$YELLOW"
        kv_row "STATE"   "$CYAN"   "${st:-N/A}" "$YELLOW"
        kv_row "TEMP"    "$ORANGE" "${tp:-N/A} °C" "$YELLOW"
    else
        text_row "Install Termux:API & pkg install termux-api" "$YELLOW" "$YELLOW"
    fi
    box_bottom "$YELLOW"
    pause_back
}

# ---------- UTILITY 5: DEVELOPER (KAWSAR) ----------
developer() {
    header
    print_dev_name
    echo
    center "◢◤  D E V E L O P E R   Z O N E  ◥◣" "$PINK$BOLD"
    echo
    box_top "$PINK" "◆ DEVELOPER PROFILE"
    kv_row "DEVELOPER" "$CYAN"   "$DEVELOPER" "$PINK"
    kv_row "PROJECT"   "$GREEN"  "XTATINE Suite" "$PINK"
    kv_row "VERSION"   "$YELLOW" "$VERSION" "$PINK"
    kv_row "PLATFORM"  "$SKY"    "Termux / Android" "$PINK"
    kv_row "GITHUB"    "$TEAL"   "github.com/xtatine/XTATINE" "$PINK"
    box_bottom "$PINK"
    echo
    center "✦ CRAFTED BY KAWSAR ✦" "$GREEN$BOLD"
    pause_back
}

# ---------- MENUS ----------
prompt() {
    printf "  ${GREEN}╭─[${WHITE}root${RED}@${CYAN}xtatine${GREEN}]─[${YELLOW}~/%s${GREEN}]${RESET}\n  ${GREEN}╰─${PINK}❯${CYAN}❯${GREEN}❯${RESET} " "$1"
}

section_divider() {
    echo
    grad "$(term_width)" "═"
    center "$1" "$WHITE$BOLD"
    grad "$(term_width)" "═"
    echo
}

main_menu() {
    local choice
    while true; do
        dash_header

        box_top "$GREEN" "◆ MATRIX RAIN (5 COLORS)"
        box_row 1 "$GREEN"  "Green Matrix Rain"   "$GREEN"
        box_row 2 "$RED"    "Red Matrix Rain"     "$GREEN"
        box_row 3 "$BLUE"   "Blue Matrix Rain"    "$GREEN"
        box_row 4 "$PURPLE" "Purple Matrix Rain"  "$GREEN"
        box_row 5 "$YELLOW" "Yellow Matrix Rain"  "$GREEN"
        box_bottom "$GREEN"
        echo

        box_top "$CYAN" "◆ ROTATING GLOBE (3 TRI-COLOR)"
        box_row 6 "$TEAL"   "Cyber Earth       ▸ Green + Blue + Cyan"    "$CYAN"
        box_row 7 "$LAV"    "Nebula Globe      ▸ Purple + Blue + Pink"   "$CYAN"
        box_row 8 "$ORANGE" "Solar Core        ▸ Gold + Red + Yellow"    "$CYAN"
        box_bottom "$CYAN"

        section_divider "◆◆◆  U T I L I T Y   &   D E V   M O D U L E S  ◆◆◆"

        box_top "$PURPLE" "◆ QUICK MODULES"
        box_row 9  "$CYAN"   "World Time (Live Clock)" "$PURPLE"
        box_row 10 "$LIME"   "Device Info"             "$PURPLE"
        box_row 11 "$BLUE"   "Net Status"              "$PURPLE"
        box_row 12 "$YELLOW" "Power Status"            "$PURPLE"
        box_row 13 "$PINK"   "Developer · KAWSAR"      "$PURPLE"
        box_bottom "$PURPLE"
        echo
        printf "  ${RED}${BOLD}[00]${RESET} ${WHITE}Exit${RESET}\n"
        line
        prompt "xtatine"
        read -r choice || exit_app
        case "$choice" in
            1|01) rain 0.04 "0 255 90" ;;
            2|02) rain 0.04 "255 50 60" ;;
            3|03) rain 0.04 "70 160 255" ;;
            4|04) rain 0.04 "190 90 255" ;;
            5|05) rain 0.04 "255 215 50" ;;
            6|06) globe "40 255 120"  "30 120 255"  "120 255 240" "CYBER EARTH" ;;
            7|07) globe "190 90 255"  "55 125 255"  "255 100 200" "NEBULA GLOBE" ;;
            8|08) globe "255 170 40"  "225 45 65"   "255 235 80"  "SOLAR CORE" ;;
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
