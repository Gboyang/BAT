@echo off

:: Define font color
color 2

echo -------------------------------------------
echo '备选方案，在贵阳初始化参数中BIOS中许多参数都是默认的。'
echo '只要启动模式需要更改，本脚本只是针对BIOS启动模式更改'
echo -------------------------------------------

set para="{\"Bootmodeselect\": \"LEGACY\"}"

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd

set ip_file=%rootdir%\ip.txt
if not exist %ip_file% (
	cls
	echo 'file does not exist;'
	pause
	exit
)

:: user_pass
set /p user_name=【输入BMC账号】:
if NOT defined user_name ( 
	cls
	echo .............................................
	echo .........【ERROR: 用户名不能为空】...........
	echo .............................................
	pause
)
echo.
set /p user_pass=【输入BMC密码】:
if NOT defined user_pass (
	cls
	echo ...........................................
	echo .........【ERROR: 密码不能为空】...........
	echo ...........................................
	pause
)

for /f %%i in (%ip_file%) do (
	echo %%i
	curl -X PATCH -H 'Content-Type':'application/json' -d %para% -u %user_name%:%user_pass% https://%%i/redfish/v1/Systems/1/Bios  -k
	echo.
)
pause
