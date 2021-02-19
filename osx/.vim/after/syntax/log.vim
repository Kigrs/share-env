syntax match logDebug /DEBUG/
syntax match logDebug /FINE/
syntax match logInfo /INFO/
syntax match logInfo /NOTICE/
syntax match logWarn /WARN/
syntax match logWarn /WARNING/
syntax match logError /ERROR/
syntax match logError /SEVERE/

highlight logDebug ctermfg=8 guifg=#808080
highlight logInfo ctermfg=15 guifg=#ffffff
highlight logWarn ctermfg=228 guifg=#ffff87
highlight logError ctermfg=9 guifg=#ff0000

let b:current_syntax = "log"
