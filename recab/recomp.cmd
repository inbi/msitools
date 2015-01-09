@echo off
md %temp%\recomp$$
cabarc X %1 %temp%\recomp$$\ *.* -o
del %1 /q
cabarc -m LZX:21 N %1 "%temp%\recomp$$\*.*"
rd %temp%\recomp$$ /s /q
:quit

