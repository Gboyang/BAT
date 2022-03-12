@echo off

color 2

::path variable
set dir=%~dp0

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd

set ip_file=%rootdir%\ip.txt
set ipmi_tool=%dir%\SMCIPMITool

cls
echo '---------批量开启/关闭定位灯-----------'
echo.
echo.
set bmc_name=%1
set bmc_pass=%2
echo.
set /p info=(input on/off):
if %info% == on (
	goto start_uid
) else if %info% == off (
	goto stop_uid
) else (
	goto end
)

:start_uid
for /f %%i in (%ip_file%) do (
	cd /d %ipmi_tool% && SMCIPMITool.exe %%i %bmc_name% %bmc_pass% ipmi oem uid on
)
goto end


:stop_uid
for /f %%i in (%ip_file%) do (
	cd /d %ipmi_tool% && SMCIPMITool.exe %%i %bmc_name% %bmc_pass% ipmi oem uid off
)
goto end


:end
	pause
	call %rootdir%\Run.bat