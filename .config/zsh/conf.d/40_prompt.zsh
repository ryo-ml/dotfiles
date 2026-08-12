setopt prompt_subst

function _vi_status_text() {
    if [[ $REGION_ACTIVE -ne 0 ]]; then
        echo "%F{yellow}[VISUAL]%f"
    else
        case ${KEYMAP} in
            vicmd)      echo "%F{red}[NORMAL]%f" ;;
            main|viins) echo "%F{green}[INSERT]%f" ;;
            vireplace)  echo "%F{blue}[REPLACE]%f" ;;
            *)          echo "%F{green}[INSERT]%f" ;;
        esac
    fi
}

function _conda_env_text() {
    [[ -n $CONDA_DEFAULT_ENV ]] && echo "(%F{white}${CONDA_DEFAULT_ENV}%f) "
}

PROMPT='$(_vi_status_text) $(_conda_env_text)%n@%m %F{cyan}%~%f %# '
