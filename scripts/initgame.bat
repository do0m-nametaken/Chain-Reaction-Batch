cls
echo Please wait...
for /l %%a in (1 1 !game.board.width!) do for /l %%b in (1 1 !game.board.height!) do (
	echo %esc%[2;1H%esc%[K	Precalculating critical mass of cells... [%%a,%%b]
	set /a game.board[%%a][%%b].CRITICALMASS=0,game.board[%%a][%%b].orb_count=0
	if %%a neq 1 set /a game.board[%%a][%%b].CRITICALMASS+=1
	if %%a neq !game.board.width! set /a game.board[%%a][%%b].CRITICALMASS+=1
	if %%b neq 1 set /a game.board[%%a][%%b].CRITICALMASS+=1
	if %%b neq !game.board.height! set /a game.board[%%a][%%b].CRITICALMASS+=1
)
echo %esc%[3;1H%esc%[K	Loading the game board...
cls
%macros.hidetextcaret%
%macros.get_board_displaystring%
%macros.centerplayercursors%
%macros.displayall_cellcontents%
for /l %%_ in (1 1 !game.playercount!) do set /a game.player[%%_].orb_count=0,game.player[%%_].isout=0
for /l %%_ in (1 1 !game.board.width!) do for /l %%` in (1 1 !game.board.height!) do if defined game.board[%%_][%%`].orb_count if !game.board[%%_][%%`].orb_count! neq 0 (
	set /a game.player[!game.board[%%_][%%`].orb_owner!].orb_count+=game.board[%%_][%%`].orb_count
	set macros.checkorbs.orbs2check=!macros.checkorbs.orbs2check! %%_-%%`
)
set macros.gameloop.turns=0
set game.loser_count=0
set /a game.maxlosers=game.playercount-1
%macros.gameloop%
:: The gameloop macro will end the cmd.exe game instance when the game ends