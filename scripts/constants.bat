set CODEPAGE=65001
chcp %CODEPAGE% >nul
set ^"LF=^

^" Above empty line is required - do not remove
set ^"\n=^^^%LF%%LF%^%LF%%LF%^^"
set "esc="

set BOX.PLAYERCOLORS[1]=red
set BOX.PLAYERCOLORS[2]=blue
set BOX.PLAYERCOLORS[3]=green
set BOX.PLAYERCOLORS[4]=yellow
set BOX.PLAYERCOLORS[5]=magenta
set BOX.PLAYERCOLORS[6]=cyan

set BOX.COLORVALUES[red]=31
set BOX.COLORVALUES[blue]=34
set BOX.COLORVALUES[green]=32
set BOX.COLORVALUES[yellow]=33
set BOX.COLORVALUES[magenta]=35
set BOX.COLORVALUES[cyan]=96

set BOX.CHAR.ORB_DISPLAY[0]=  
set BOX.CHAR.ORB_DISPLAY[1]=. 
set BOX.CHAR.ORB_DISPLAY[2]=○ 
set BOX.CHAR.ORB_DISPLAY[3]=● 
set BOX.CHAR.ORB_DISPLAY[4]=┼ 
set BOX.CHAR.ORB_DISPLAY[5]=╬ 
set BOX.CHAR.ORB_DISPLAY[6]=╋ 
for /l %%a in (7 1 99) do set BOX.CHAR.ORB_DISPLAY[%%a]=%%a
set BOX.CHAR.ORB_DISPLAY[100]=1k

set BOX.CHAR.NS=│
set BOX.CHAR.WE=─
set BOX.CHAR.NW=┘
set BOX.CHAR.NE=└
set BOX.CHAR.SW=┐
set BOX.CHAR.SE=┌
set BOX.CHAR.NSW=┤
set BOX.CHAR.NSE=├
set BOX.CHAR.NWE=┴
set BOX.CHAR.SWE=┬
set BOX.CHAR.NSWE=┼
set BOX.CHAR.CURSOR.F=█
set BOX.CHAR.CURSOR.L=▌
set BOX.CHAR.CURSOR.R=▐
set BOX.CHAR.CURSOR.U=▀
set BOX.CHAR.CURSOR.D=▄
set BOX.CHAR.CURSOR=!BOX.CHAR.CURSOR.F!!BOX.CHAR.CURSOR.U!!BOX.CHAR.CURSOR.U!!BOX.CHAR.CURSOR.U!!BOX.CHAR.CURSOR.F!!esc![1B!esc![1D!BOX.CHAR.CURSOR.R!!esc![5D!BOX.CHAR.CURSOR.L!!esc![1B!esc![1D!BOX.CHAR.CURSOR.F!!BOX.CHAR.CURSOR.D!!BOX.CHAR.CURSOR.D!!BOX.CHAR.CURSOR.D!!BOX.CHAR.CURSOR.F!

:: Macros
:: Limitations:
:: 1. They need to be declared in a specific order in order for macros that call other macros to work.
:: 2. The variable character limit

:: TAKES NO ARGUMENTS
set macros.hidetextcaret=(echo !esc![?25l)
:: TAKES NO ARGUMENTS
set macros.showtextcaret=(echo !esc![?25h)

:: <displaystring_varname_for_synced_render>
set macros.get_board_displaystring=^
(%\n%
	set game.board.displaystring=!esc![1;1H!BOX.CHAR.SE!%\n%
	for /f %%_ in ('set /a game.board.width-1') do for /l %%. in (1 1 %%_) do set game.board.displaystring=^^!game.board.displaystring^^!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.SWE!%\n%
	set game.board.displaystring=^^!game.board.displaystring^^!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.SW!%\n%
	for /l %%_ in (1 1 ^^!game.board.height^^!) do (%\n%
		set game.board.displaystring=^^!game.board.displaystring^^!!\n!!BOX.CHAR.NS!%\n%
		for /l %%. in (1 1 ^^!game.board.width^^!) do set game.board.displaystring=^^!game.board.displaystring^^!!esc![3C!BOX.CHAR.NS!%\n%
		if %%_ equ ^^!game.board.height^^! (%\n%
			set game.board.displaystring=^^!game.board.displaystring^^!!\n!!BOX.CHAR.NE!%\n%
			for /f %%_ in ('set /a game.board.width-1') do for /l %%. in (1 1 %%_) do (%\n%
				set game.board.displaystring=^^!game.board.displaystring^^!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.NWE!%\n%
			)%\n%
			set game.board.displaystring=^^!game.board.displaystring^^!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.NW!%\n%
		) else (%\n%
			set game.board.displaystring=^^!game.board.displaystring^^!!\n!!BOX.CHAR.NSE!%\n%
			for /f %%_ in ('set /a game.board.width-1') do for /l %%. in (1 1 %%_) do (%\n%
				set game.board.displaystring=^^!game.board.displaystring^^!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.NSWE!%\n%
			)%\n%
			set game.board.displaystring=^^!game.board.displaystring^^!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.WE!!BOX.CHAR.NSW!%\n%
		)%\n%
	)%\n%
)

:: <displaystring_varname_for_synced_render>
set macros.displayall_cellcontents=^
for %%# in (1 2) do if %%#==2 (%\n%
	set macros.displayall_cellcontents.displaystring=%\n%
	for /l %%_ in (1 1 ^^!game.board.width^^!) do for /l %%. in (1 1 ^^!game.board.height^^!) do if defined game.board[%%_][%%.].orb_owner (%\n%
		set /a macros.displayall_cellcontents.curwidth=%%_*4-1,macros.displayall_cellcontents.curheight=%%.*2%\n%
		for %%{ in (BOX.PLAYERCOLORS[^^!game.board[%%_][%%.].orb_owner^^!]) do for %%} in (BOX.COLORVALUES[^^!%%{^^!]) do set macros.displayall_cellcontents.curcolor=^^!%%}^^!%\n%
		for %%@ in (BOX.CHAR.ORB_DISPLAY[^^!game.board[%%_][%%.].orb_count^^!]) do set macros.displayall_cellcontents.curorbcount=^^!%%@^^!%\n%
		set macros.displayall_cellcontents.displaystring=^^!macros.displayall_cellcontents.displaystring^^!!esc![^^!macros.displayall_cellcontents.curheight^^!;^^!macros.displayall_cellcontents.curwidth^^!H!esc![^^!macros.displayall_cellcontents.curcolor^^!m^^!macros.displayall_cellcontents.curorbcount^^!%\n%
	)%\n%
	if not defined macros.displayall_cellcontents.args (echo ^^!macros.displayall_cellcontents.displaystring^^!!esc![0m%\n%
	) else for %%_ in (^^!macros.displayall_cellcontents.args^^!) do set %%_=^^!%%_^^!^^!macros.displayall_cellcontents.displaystring^^!%\n%
) else set macros.displayall_cellcontents.args=

:: <displaystring_varname_for_synced_render>
set macros.centerplayercursors=^
for %%# in (1 2) do if %%#==2 (%\n%
	set macros.centercursor.argindex=0%\n%
	for %%_ in (^^!macros.centercursor.args^^!) do (%\n%
		set /a macros.centercursor.argindex+=1%\n%
		set macros.centercursor.args[^^!macros.centercursor.argindex^^!]=%%_%\n%
	)%\n%
	for /f %%{ in ('set /a game.board.width/2+1') do for /f %%} in ('set /a game.board.height/2+1') do for /l %%_ in (1 1 ^^!game.playercount^^!) do set /a game.player[%%_].last_cursorpos[x]=game.board.width/2+1,game.player[%%_].last_cursorpos[y]=game.board.height/2+1%\n%
) else set macros.centercursor.args=

:: TAKES NO ARGUMENTS
set macros.hidecursor=^
(for %%{ in (BOX.PLAYERCOLORS[^^!game.currentplayer^^!]) do for %%} in (BOX.COLORVALUES[^^!%%{^^!]) do echo !esc![^^!%%}^^!m^^!game.board.displaystring^^!!esc![0m%)

set macros.returncursor=^
(%\n%
	for %%{ in (BOX.PLAYERCOLORS[^^!game.currentplayer^^!]) do for %%} in (BOX.COLORVALUES[^^!%%{^^!]) do set macros.returncursor.temp=!esc![^^!%%}^^!m%\n%
	for /f %%{ in ('set /a game.cur_cursorpos[x]*4-3') do for /f %%} in ('set /a game.cur_cursorpos[y]*2-1') do echo ^^!macros.returncursor.temp^^!^^!game.board.displaystring^^!!esc![%%};%%{H^^!BOX.CHAR.CURSOR^^!!esc![0m%\n%
)

:: <*movedirs>
set macros.movecursor=^
for %%# in (1 2) do if %%#==2 (%\n%
	for %%` in (^^!macros.movecursor.args^^!) do for %%_ in (^^!game.currentplayer^^!) do (%\n%
		if [%%`]==[up] (if ^^!game.player[%%_].last_cursorpos[y]^^! equ 1 (set game.player[%%_].last_cursorpos[y]=^^!game.board.height^^!) else (set /a game.player[%%_].last_cursorpos[y]-=1)%\n%
		) else if [%%`]==[down] (if ^^!game.player[%%_].last_cursorpos[y]^^! equ ^^!game.board.height^^! (set game.player[%%_].last_cursorpos[y]=1) else (set /a game.player[%%_].last_cursorpos[y]+=1)%\n%
		) else if [%%`]==[left] (if ^^!game.player[%%_].last_cursorpos[x]^^! equ 1 (set game.player[%%_].last_cursorpos[x]=^^!game.board.width^^!) else (set /a game.player[%%_].last_cursorpos[x]-=1)%\n%
		) else if [%%`]==[right] (if ^^!game.player[%%_].last_cursorpos[x]^^! equ ^^!game.board.width^^! (set game.player[%%_].last_cursorpos[x]=1) else (set /a game.player[%%_].last_cursorpos[x]+=1)%\n%
		)%\n%
	)%\n%
	set macros.movecursor.args=%\n%
) else set macros.movecursor.args=

:: TAKES NO ARGUMENTS
set macros.checkorbs.orbs2check=
set macros.checkorbs=^
(%\n%
	set macros.checkorbs.orbs2check_new=%\n%
	for %%_ in (^^!macros.checkorbs.orbs2check^^!) do for /f "tokens=1,2 delims=-" %%? in ("%%_") do if ^^!game.board[%%?][%%@].orb_count^^! geq ^^!game.board[%%?][%%@].CRITICALMASS^^! (%\n%
		set /a game.board[%%?][%%@].orb_count-=game.board[%%?][%%@].CRITICALMASS%\n%
		if ^^!game.board[%%?][%%@].orb_count^^! geq ^^!game.board[%%?][%%@].CRITICALMASS^^! set macros.checkorbs.orbs2check_new=^^!macros.checkorbs.orbs2check_new: %%?-%%@=^^! %%?-%%@%\n%
		if %%? neq 1 for /f %%. in ('set /a %%?-1') do (%\n%
			if defined game.board[%%.][%%@].orb_owner if ^^!game.board[%%.][%%@].orb_owner^^! neq ^^!game.board[%%?][%%@].orb_owner^^! set /a game.player[^^!game.board[%%.][%%@].orb_owner^^!].orb_count-=^^!game.board[%%.][%%@].orb_count^^!,game.player[^^!game.board[%%?][%%@].orb_owner^^!].orb_count+=^^!game.board[%%.][%%@].orb_count^^!%\n%
			set /a game.board[%%.][%%@].orb_count+=1,game.board[%%.][%%@].orb_owner=game.board[%%?][%%@].orb_owner%\n%
			if ^^!game.board[%%.][%%@].orb_count^^! geq ^^!game.board[%%.][%%@].CRITICALMASS^^! set macros.checkorbs.orbs2check_new=^^!macros.checkorbs.orbs2check_new: %%.-%%@=^^! %%.-%%@%\n%
		)%\n%
		if %%? neq ^^!game.board.width^^! for /f %%. in ('set /a %%?+1') do (%\n%
			if defined game.board[%%.][%%@].orb_owner if ^^!game.board[%%.][%%@].orb_owner^^! neq ^^!game.board[%%?][%%@].orb_owner^^! set /a game.player[^^!game.board[%%.][%%@].orb_owner^^!].orb_count-=^^!game.board[%%.][%%@].orb_count^^!,game.player[^^!game.board[%%?][%%@].orb_owner^^!].orb_count+=^^!game.board[%%.][%%@].orb_count^^!%\n%
			set /a game.board[%%.][%%@].orb_count+=1,game.board[%%.][%%@].orb_owner=game.board[%%?][%%@].orb_owner%\n%
			if ^^!game.board[%%.][%%@].orb_count^^! geq ^^!game.board[%%.][%%@].CRITICALMASS^^! set macros.checkorbs.orbs2check_new=^^!macros.checkorbs.orbs2check_new: %%.-%%@=^^! %%.-%%@%\n%
		)%\n%
		if %%@ neq 1 for /f %%. in ('set /a %%@-1') do (%\n%
			if defined game.board[%%?][%%.].orb_owner if ^^!game.board[%%?][%%.].orb_owner^^! neq ^^!game.board[%%?][%%@].orb_owner^^! set /a game.player[^^!game.board[%%?][%%.].orb_owner^^!].orb_count-=^^!game.board[%%?][%%.].orb_count^^!,game.player[^^!game.board[%%?][%%@].orb_owner^^!].orb_count+=^^!game.board[%%?][%%.].orb_count^^!%\n%
			set /a game.board[%%?][%%.].orb_count+=1,game.board[%%?][%%.].orb_owner=game.board[%%?][%%@].orb_owner%\n%
			if ^^!game.board[%%?][%%.].orb_count^^! geq ^^!game.board[%%?][%%.].CRITICALMASS^^! set macros.checkorbs.orbs2check_new=^^!macros.checkorbs.orbs2check_new: %%?-%%.=^^! %%?-%%.%\n%
		)%\n%
		if %%@ neq ^^!game.board.height^^! for /f %%. in ('set /a %%@+1') do (%\n%
			if defined game.board[%%?][%%.].orb_owner if ^^!game.board[%%?][%%.].orb_owner^^! neq ^^!game.board[%%?][%%@].orb_owner^^! set /a game.player[^^!game.board[%%?][%%.].orb_owner^^!].orb_count-=^^!game.board[%%?][%%.].orb_count^^!,game.player[^^!game.board[%%?][%%@].orb_owner^^!].orb_count+=^^!game.board[%%?][%%.].orb_count^^!%\n%
			set /a game.board[%%?][%%.].orb_count+=1,game.board[%%?][%%.].orb_owner=game.board[%%?][%%@].orb_owner%\n%
			if ^^!game.board[%%?][%%.].orb_count^^! geq ^^!game.board[%%?][%%.].CRITICALMASS^^! set macros.checkorbs.orbs2check_new=^^!macros.checkorbs.orbs2check_new: %%?-%%.=^^! %%?-%%.%\n%
		)%\n%
		!macros.displayall_cellcontents!%\n%
	)%\n%
	set macros.checkorbs.orbs2check=^^!macros.checkorbs.orbs2check_new^^!%\n%
)

:: TAKES NO ARGUMENTS
set macros.gameloop.movedirs[1]=up
set macros.gameloop.movedirs[2]=left
set macros.gameloop.movedirs[3]=down
set macros.gameloop.movedirs[4]=right
set macros.gameloop.movedirs[5]=up up
set macros.gameloop.movedirs[6]=left left
set macros.gameloop.movedirs[7]=down down
set macros.gameloop.movedirs[8]=right right
:: For loops are faster than goto loops
set macros.gameloop=^
for /l %%# in (1 0 2) do (%\n%
	!macros.checkorbs!%\n%
	if ^^!macros.gameloop.turns^^! gtr ^^!game.playercount^^! for /l %%_ in (1 1 ^^!game.playercount^^!) do if ^^!game.player[%%_].isout^^! neq 1 if ^^!game.player[%%_].orb_count^^! lss 1 set /a game.player[%%_].isout=1,game.loser_count+=1%\n%
	if defined game.previousplayer if ^^!game.loser_count^^! equ ^^!game.maxlosers^^! exit ^^!game.previousplayer^^!%\n%
	if not defined macros.checkorbs.orbs2check for %%# in (^^!game.currentplayer^^!) do if ^^!game.player[%%#].isout^^! neq 1 (%\n%
		set /a game.cur_cursorpos[x]=game.player[^^!game.currentplayer^^!].last_cursorpos[x],game.cur_cursorpos[y]=game.player[^^!game.currentplayer^^!].last_cursorpos[y]%\n%
		!macros.returncursor!%\n%
		set game.previousplayer=%\n%
		choice /c ESDF3ACGT ^>nul%\n%
		if ^^!errorlevel^^! gtr 8 (%\n%
			set macros.gameloop.valid=0%\n%
			if defined game.board[^^!game.cur_cursorpos[x]^^!][^^!game.cur_cursorpos[y]^^!].orb_owner (for %%. in (game.board[^^!game.cur_cursorpos[x]^^!][^^!game.cur_cursorpos[y]^^!].orb_owner) do if ^^!%%.^^! equ ^^!game.currentplayer^^! set macros.gameloop.valid=1) else set macros.gameloop.valid=1%\n%
			if defined game.board[^^!game.cur_cursorpos[x]^^!][^^!game.cur_cursorpos[y]^^!].orb_count for %%. in (game.board[^^!game.cur_cursorpos[x]^^!][^^!game.cur_cursorpos[y]^^!].orb_count) do if ^^!%%.^^! equ 0 set macros.gameloop.valid=1%\n%
			if ^^!macros.gameloop.valid^^! equ 1 (%\n%
				set /a macros.gameloop.turns+=1%\n%
				set /a game.board[^^!game.cur_cursorpos[x]^^!][^^!game.cur_cursorpos[y]^^!].orb_owner=game.currentplayer,game.board[^^!game.cur_cursorpos[x]^^!][^^!game.cur_cursorpos[y]^^!].orb_count+=1,game.player[^^!game.currentplayer^^!].orb_count+=1,game.previousplayer=game.currentplayer%\n%
				set /a macros.gameloop.tempwidth=game.cur_cursorpos[x]*4-1,macros.gameloop.tempheight=game.cur_cursorpos[y]*2%\n%
				for %%_ in (BOX.PLAYERCOLORS[^^!game.currentplayer^^!]) do for %%. in (BOX.COLORVALUES[^^!%%_^^!]) do set macros.gameloop.tempcolor=^^!%%.^^!%\n%
				for %%_ in (game.board[^^!game.cur_cursorpos[x]^^!][^^!game.cur_cursorpos[y]^^!].orb_count) do for %%. in (BOX.CHAR.ORB_DISPLAY[^^!%%_^^!]) do echo !esc![^^!macros.gameloop.tempheight^^!;^^!macros.gameloop.tempwidth^^!H!esc![^^!macros.gameloop.tempcolor^^!m^^!%%.^^!%\n%
				!macros.hidecursor!%\n%
				if ^^!game.currentplayer^^! equ ^^!game.playercount^^! (set game.currentplayer=1) else set /a game.currentplayer+=1%\n%
			)%\n%
			set macros.gameloop.valid=%\n%
		) else for %%_ in (macros.gameloop.movedirs[^^!errorlevel^^!]) do !macros.movecursor! ^^!%%_^^!%\n%
		set macros.checkorbs.orbs2check=^^!game.cur_cursorpos[x]^^!-^^!game.cur_cursorpos[y]^^!%\n%
	) else if ^^!game.currentplayer^^! equ ^^!game.playercount^^! (set game.currentplayer=1) else set /a game.currentplayer+=1%\n%
)%\n%
