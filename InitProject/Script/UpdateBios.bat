@echo off

:: Define font color
color 2

:: chdir
set chdir=%~dp0

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd

:: SMCIPMITool
set IPMI_tool=%chdir%\SMCIPMITool
if not exist %IPMI_tool% ( 
	echo %IPMI_tool% Directory does not exist;
	pause
	exit 
)

:: ip file
set ip_file=%rootdir%\ip.txt
if not exist %ip_file% ( 
	echo %ip_file% file does not exist;
	pause
	exit 
)

:: sum tool
set sum_dir=%chdir%\sum
if not exist %sum_dir% ( 
	echo %sum_dir% Directory does not exist;
	pause
	exit 
)


set bios_file=%rootdir%\bios.xml

:: user pass
set bmc_user=%1
set bmc_pass=%2

:meun
cls
echo --------------------------------------------------------------------
echo Author: yanghao
echo Email: Gboyanghao@163.com
echo Version: 0.0.1
echo Describe: update BIOS script
echo Environment: windown
echo --------------------------------------------------------------------
echo.
echo 1、获取bios版本信息
echo.
echo 2、获取单台配置信息
echo.
echo 3、更改bios配置
echo.
echo 4、升级bios固件
echo.
echo 5、返回主菜单
echo.

set /p info=请输入数字:
if %info% == 1 ( 
	goto get_version 
) else if %info% == 2 ( 
	goto get_config 
) else if %info% == 3 ( 
	goto change_bios_config 
) else if %info% == 4 (
	goto upgrade_bios
) else if %info% == 5 ( 
	call %rootdir%\Run.bat
) else (
	exit
)


:get_version
cls
:: DIR If there is a
if not exist %ip_file% (
	echo '%ip_file% file does not exist!'
	pause
	goto meun
)

rem Define the directory
set host_info=%rootdir%\log\ServerVersion
md %host_info%

::%IPMI_tool% %ip_add% %user_name% %password% ipmi oem summary
for /f %%i in (%ip_file%) do (
	cd /d %IPMI_tool% && SMCIPMITool.exe %%i %bmc_user% %bmc_pass% ipmi oem summary >> %host_info%\%%i.txt
)
echo.
pause
goto meun

:get_config
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
echo.
set getConfig_Path=%rootdir%\bios.xml
set /p getConfig_Path=【default: %getConfig_Path%】:

cls
echo ------------------确认信息---------------------
echo.
echo username: %user_name%
echo password: %password%
echo configfile: %getConfig_Path%
echo.
echo ------------------------------------------------
set /p input_info=【yes/no】:
if %input_info% == yes (
	echo '..........执行中..............'
	cd /d %sum_dir% && sum.exe -i %ip_add% -u %user_name% -p %password% -c GetCurrentBiosCfg --file %getConfig_Path% --overwrite
	pause
	goto meun
) else (
	goto meun
)


:change_bios_config
cls
set /p config_file=【输入配置文件路径】：
if NOT defined config_file (
	cls
	echo ...........................................
	echo ....【ERROR: 配置文件路径不能为空】........
	echo ...........................................
	pause
	goto meun
)

cls
echo ------------------确认信息---------------------
echo.
echo username: %bmc_user%
echo password: %bmc_pass%
echo configfile: %config_file%
echo.
echo ------------------------------------------------
set /p input_info=【yes/no】:
if %input_info% == yes (
	if exist %config_file% (
		echo '..........执行中..............'
		cd /d %sum_dir% && sum.exe -l %ip_file% -u %bmc_user% -p %bmc_pass% -c ChangeBiosCfg --file %config_file% --reboot --individually
	else (
		echo %config_file%没有找到此文件
		goto meun
	)
) else (
	pause
	goto meun
)


:upgrade_bios
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
		cd /d %sum_dir% && sum.exe -l %ip_file% -u %bmc_user% -p %bmc_pass% -c UpdateBios --file %update_file% --force_update --reboot
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