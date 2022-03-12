@echo off

:: Define font color
color 2

::User Name Password
set bmc_user=%1
set bmc_pass=%2

:: chdir
set chdir=%~dp0

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd

:: author info
:menu
cls
echo --------------------------------------------------------------------
echo Author: yanghao
echo Email: Gboyanghao@163.com
echo Version: 0.0.1
echo Describe: update bmc script
echo Environment: win
echo --------------------------------------------------------------------
echo.

:: sum tool
set sum_dir=%chdir%\sum
if not exist %sum_dir% ( 
	echo %sum_dir% Directory does not exist;
	pause
	exit 
)

echo 1、获取单台BMC信息
echo.
echo 2、升级BMC固件
echo.
echo 3、返回主菜单
echo.

rem Define the directory
set host_info=%rootdir%\log\ServerVersion
if not exist %host_info% (
	md %host_info%
)
set bmc_file=%rootdir%\SMCI_BMC.rom

set /p info=请输入数字:

if %info% == 1 ( 

	goto get_bmc_info
	
) else if %info% == 2 ( 

	goto upgrade_bmc
	
) else if %info% == 3 (

	call %rootdir%\Run.bat
	
) else (

	exit
)

:get_bmc_info
cls
set /p ip_add=【输入IP地址】:
if NOT defined ip_add (
	cls
	echo ............................................
	echo .........【ERROR: ip地址不能为空】..........
	echo ............................................
	pause
	goto meun
)
echo.
set /p user_name=【输入BMC账号】:
if NOT defined user_name ( 
	cls
	echo .............................................
	echo .........【ERROR: 用户名不能为空】...........
	echo .............................................
	pause
	goto meun
)
echo.
set /p password=【输入BCM密码】:
if NOT defined password (
	cls
	echo ...........................................
	echo .........【ERROR: 密码不能为空】...........
	echo ...........................................
	pause
	goto meun
)

cls
echo '..........执行中..............'
cd /d %sum_dir% && sum.exe -i %ip_add% -u %user_name% -p %password% -c GetBmcInfo --file %bmc_file%
pause
goto meun


:upgrade_bmc
cls
set /p update_file=【INPUT Update File】：
if NOT defined update_file (
	cls
	echo ...........................................
	echo ....【ERROR: 升级文件路径不能为空】........
	echo ...........................................
	pause
	goto meun
)

cls
echo -------------------确认信息--------------------
echo.
echo username: %bmc_user%
echo password: %bmc_pass%
echo update_file: %update_file%
echo.
echo -----------------------------------------------

set /p input_info=【yes/no】:
if %input_info% == yes (
	if exist %update_file% (
		cls
		echo '开始下发..........'
		cd /d %sum_dir% && sum.exe -l %ip_file% -u %bmc_user% -p %bmc_pass% -c UpdateBmc --file %update_file%
		pause
		goto meun
	) else (
		echo '升级文件不存在，程序返回'
		pause
		goto meun
	)
) else (
	goto meun
)
pause