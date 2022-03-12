@echo off

@echo off

:: Define font color
color 2

set dir=%~dp0

set smc_dir=%dir%\SMCIPMITool

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd
set ip_file=%rootdir%\ip.txt

set BMC_USER=%%1
set BMC_PASS=%%2

:: author info
:menu
cls
echo --------------------------------------------------------------------
echo Author: yanghao
echo Email: Gboyanghao@163.com
echo Version: 0.0.1
echo Describe: power
echo Environment: windown
echo --------------------------------------------------------------------
echo.
echo 1、上电
echo.
echo 2、下电
echo.
echo 3、重启
echo.
echo 4、返回主菜单
echo.

:: INPUT
set /p msg=INPUT NUM(1/2):
if %msg% == 1 ( 

goto start_host 

) else if %msg% == 2 ( 

goto stop_host

) else if %msg% == 3 (

goto restart_host

) else if %msg% == 4 ( 

call %rootdir%\Run.bat

) else (

	echo 请确认你的输入是否正确，按任意键结束..........

	pause
	
	goto menu
)


:restart_host
cls
for /f %%i in (%ip_file%) do (
	echo %%i
	cd %smc_dir% && SMCIPMITool.exe %%i %BMC_USER% %BMC_PASS% ipmi power reset
	echo.
)
pause
goto menu

:start_host
cls
for /f %%i in (%ip_file%) do (
	echo %%i
	cd %smc_dir% && SMCIPMITool.exe %%i %BMC_USER% %BMC_PASS% ipmi power up
	echo.
)
pause
goto menu

:stop_host
cls
for /f %%i in (%ip_file%) do (
	echo %%i
	cd %smc_dir% && SMCIPMITool.exe %%i %BMC_USER% %BMC_PASS% ipmi power down
	echo.
)
pause
goto menu