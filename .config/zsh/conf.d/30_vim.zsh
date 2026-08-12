# Set Vi mode
bindkey -v
bindkey "^?" backward-delete-char
export KEYTIMEOUT=1

# Vi Mode Logic
function _update_vi_mode() {
    case ${KEYMAP} in
        vicmd)      echo -ne "\e[2 q" ;; # NORMAL (Block)
        main|viins) echo -ne "\e[6 q" ;; # INSERT (Beam)
    esac
    zle .reset-prompt
}

# Called on keymap switch
function zle-keymap-select() { _update_vi_mode }

# Called on newline init (reset to insert mode)
function zle-line-init() { _update_vi_mode }
zle -N zle-line-init
zle -N zle-keymap-select

# Visual mode
function _custom_visual_mode() { zle .visual-mode; _update_vi_mode }
zle -N _custom_visual_mode
bindkey -M vicmd 'v' _custom_visual_mode

# Visual line mode
function _custom_visual_line_mode() { zle .visual-line-mode; _update_vi_mode }
zle -N _custom_visual_line_mode
bindkey -M vicmd 'V' _custom_visual_line_mode

# Exit visual mode with ESC
function _custom_exit_visual() {
    [[ $REGION_ACTIVE -ne 0 ]] && zle .visual-mode
    _update_vi_mode
}
zle -N _custom_exit_visual
bindkey -M vicmd '^[' _custom_exit_visual

# Set initial cursor to beam (insert mode)
echo -ne "\e[6 q"

