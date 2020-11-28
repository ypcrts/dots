set formatoptions+=t
" https://www.reddit.com/r/vim/comments/4lvaok/supercharge_vim_formatting_for_plain_text/
set formatlistpat=^\\s*                    " Optional leading whitespace
set formatlistpat+=[                       " Start class
set formatlistpat+=\\[({]\\?               " |  Optionally match opening punctuation
set formatlistpat+=\\(                     " |  Start group
set formatlistpat+=[0-9]\\+                " |  |  A number
set formatlistpat+=\\\|[iIvVxXlLcCdDmM]\\+ " |  |  Roman numerals
set formatlistpat+=\\\|[a-zA-Z]            " |  |  A single letter
set formatlistpat+=\\)                     " |  End group
set formatlistpat+=[\\]:.)}                " |  Closing punctuation
set formatlistpat+=]                       " End class
set formatlistpat+=\\s\\+                  " One or more spaces
set formatlistpat+=\\\|^\\s*[-–+o*]\\s\\+  " Or ASCII style bullet points
