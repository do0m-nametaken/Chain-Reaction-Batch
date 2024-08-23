@echo off
@setlocal EnableDelayedExpansion
if "%~1"==":startgame" call :startgame %2 %3 %4 %5
set /p board.width=board width:
set /p board.height=board height:
set /p playercount=player count:
set /p currentplayer=starting player:
echo CONTROLS:
echo ESDF to move selection up,left,down,right
echo 3AGC to move selection up,left,down,right twice the distance
echo T to place orb
pause >nul
cmd /c "%~0" :startgame %board.width% %board.height% %playercount% %currentplayer%
title GAMEOVER
cls
echo Game Over
echo Player %~1 wins
pause >nul
set
goto:eof

:startgame <game.board.width> <game.board.height> <game.playercount> <game.currentplayer>
set game.board.width=%1
set game.board.height=%2
set game.playercount=%3
set game.currentplayer=%4
call scripts\constants
call scripts\initgame.bat