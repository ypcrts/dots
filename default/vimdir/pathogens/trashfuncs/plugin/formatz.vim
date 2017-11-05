command DieYouTrolls         call formatz#DieYouTrolls()
command DeleteTrailingSpaces call formatz#DeleteTrailingSpaces

command -range=% FormatJSON call formatz#FormatJSON(<line1>, <line2>)
command -range=% StripHtml  call formatz#StripHtml(<line1>, <line2>)
