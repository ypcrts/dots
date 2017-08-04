"                      __                         _
"    ___  __  ______  / /_  _________ _____ ___  (_)________
"   / _ \/ / / / __ \/ __ \/ ___/ __ `/ __ `__ \/ / ___/ __ \
"  /  __/ /_/ / /_/ / / / / /  / /_/ / / / / / / / /  / /_/ /
"  \___/\__,_/ .___/_/ /_/_/   \__,_/_/ /_/ /_/_/_/   \____/
"           /_/ 
"   by ypcrts -  https://github.com/ypcrts/euphramiro
"
let s:black=[ '#242424', '0']
let s:blackb=[ '#474747', '8']

let s:red=[ '#8A2F58', '1']
let s:redb=[ '#CF4F88', '9']

let s:green=[ '#287373', '2']
let s:greenb=[ '#53A6A6', '10']

let s:yellow=[ '#914E89', '3']
let s:yellowb=[ '#BF85CC', '11']

let s:blue=[ '#395573', '4']
let s:blueb=[ '#4779B3', '12']

let s:magenta=[ '#5E468C', '5']
let s:magentab=[ '#7F62B3', '13']

let s:cyan=[ '#2B7694', '6']
let s:cyanb=[ '#47959E', '14']

let s:white=[ '#899CA1', '7']
let s:whiteb=[ '#C0C0C0', '15']

let s:p = { 'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {} }

let s:filename = [s:whiteb,s:blackb]

let s:p.normal.left     = [ [ s:black, s:cyan ] , s:filename ]
let s:p.inactive.left   = [ [ s:blue, s:black ] ]
let s:p.insert.left     = [ [ s:whiteb, s:magenta ], s:filename ]
let s:p.replace.left    = [ [ s:whiteb, s:red ] , s:filename ]
let s:p.visual.left     = [ [ s:black, s:blueb ] , s:filename ]

let s:p.normal.right    = [ [ s:blackb, s:black ] , [ s:blackb, s:black] ]
let s:p.inactive.right  = [ [ s:blackb, s:black ]  ]

let s:p.normal.middle   = [ [ s:cyan, s:black ] ]
let s:p.inactive.middle = [ [ s:blue, s:black ] ]

let s:p.tabline.left    = [ [ s:white, s:black ] ]
let s:p.tabline.tabsel  = [ [ s:whiteb, s:cyan ] ]
let s:p.tabline.middle  = [ [ s:black, s:black ] ]
let s:p.tabline.right   = [ [ s:cyanb, s:black ] ]

let s:p.normal.error    = [ [ s:redb, s:black ] ]
let s:p.normal.warning  = [ [ s:redb, s:black ] ]

let g:lightline#colorscheme#euphramiro#palette = lightline#colorscheme#flatten(s:p)
