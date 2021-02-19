syntax match logDebug /.*DEBUG.*/
syntax match logDebug /FINE/
syntax match logInfo /INFO/
syntax match logInfo /NOTICE/
syntax match logWarn /WARN/
syntax match logWarn /WARNING/
syntax match logError /ERROR/
syntax match logError /SEVERE/

" ref: http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html
highlight logDebug ctermfg=247 guifg=#9e9e9e
highlight logInfo ctermfg=15 guifg=#ffffff
highlight logWarn ctermfg=228 guifg=#ffff87
highlight logError ctermfg=9 guifg=#ff0000

let b:current_syntax = "log"
