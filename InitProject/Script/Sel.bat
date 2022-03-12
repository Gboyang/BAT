@echo off

set chroot=%~dp0

set SMC_IPMI=%chroot%\SMCIPMITool

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd

set ip_file=%rootdir%\ip.txt

set bmc_user=%%1
set bmc_pass=%%2

for /f %%i in (%ip_file%) do (
	echo %%i
	echo.
	cd %SMC_IPMI% && SMCIPMITool.exe %%i %bmc_user% %bmc_pass% sel csv sel_%%i

)

pause

call %rootdir%\Run.bat