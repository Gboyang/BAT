@echo off


set bmc_user=%1
set bmc_pass=%2

:: chdir
set chdir=%~dp0

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd

set smc_dir=%chdir%\SMCIPMITool
if not exist %smc_dir% (
	cls
	echo '%smc_dir% not exist;'
	pause
	exit
)
set ipmi_tool=%chdir%\ipmitool
if not exist %ipmi_tool% (
	cls
	echo '%ipmi_tool% not exist;'
	pause
	exit
)

set ip_file=%rootdir%\ip.txt
if not exist %ip_file% (
	cls
	echo 'file does not exist;'
	pause
	exit
)
:menu
cls
echo --------------------------------------------------------------------
echo Author: yanghao
echo Email: Gboyanghao@163.com
echo Version: 0.0.1
echo Describe: The entrance to the script
echo Environment: windown
echo --------------------------------------------------------------------
echo.
echo 1、查看用户列表
echo.
echo 2、添加用户
echo.
echo 3、修改ADMIN密码
echo.
echo 4、删除用户
echo.
echo 5、返回主菜单
echo.
set /p info=INPUT NUM:

if %info% == 1 (

	goto list_user
	
) else if %info% == 2 (

	goto add_user
	
) else if %info% == 3 (
	
	goto change_pw
	
) else if %info% == 4 (
	
	goto del_user
	
) else if %info% == 5 ( 

	call %rootdir%\Run.bat
	
) else (

	pause
	
	exit
	
)

:: 关闭复杂度
cd /d %ipmi_tool% && ipmitool.exe -H %%i -I lanplus -U %bmc_user% -P %bmc_pass% raw 0x30 0x68 0x22 0x01 0x00

:list_user
cls
set /p host_ip=ip addr:
if NOT defined host_ip (
	cls
	echo ...........................................
	echo .........【ERROR: ip address not null】.........
	echo ...........................................
	pause
)
cd /d %smc_dir% && SMCIPMITool.exe %host_ip% %bmc_user% %bmc_pass% user list
echo.
pause
goto menu
	
:add_user
cls
set /p new_user=username:
if NOT defined new_user (
	cls
	echo ...........................................
	echo .........【ERROR: 用户名不能为空】.........
	echo ...........................................
	pause
)
echo.
set /p new_password=password:
if NOT defined new_password (
	cls
	echo ...........................................
	echo .........【ERROR: 密码不能为空】...........
	echo ...........................................
	pause
)
echo.
set /p new_user_id=uid:
if NOT defined new_user_id (
	cls
	echo ...........................................
	echo .........【ERROR: UID不能为空】...........
	echo ...........................................
	pause
)

for /f "delims=" %%i in (%ip_file%) do (
 	cd /d %smc_dir% && SMCIPMITool.exe %%i %bmc_user% %bmc_pass% user add %new_user_id% %new_user% "%new_password%" 2
)
pause
goto menu


:change_pw
cls
echo '----------修改密码--------------'
echo.
set /p user_id=用户ID：
if NOT defined user_id (
	cls
	echo ...........................................
	echo .........【ERROR: UID不能为空】...........
	echo ...........................................
	pause
)
echo.
set /p new_password=新密码：
if NOT defined new_password (
	cls
	echo ...........................................
	echo .........【ERROR: 密码不能为空】...........
	echo ...........................................
	pause
)
echo.
set /p new_pw2=再次确认密码：
if NOT defined new_pw2 (
	cls
	echo ...........................................
	echo .........【ERROR: 密码不能为空】...........
	echo ...........................................
	pause
)
if %new_password% == %new_pw2% (
	for /f "delims=" %%i in (%ip_file%) do (
		cd /d %smc_dir% && SMCIPMITool.exe %%i %bmc_user% %bmc_pass% user setpwd %user_id% %new_pw2%
		cd /d %smc_dir% && SMCIPMITool.exe %%i %bmc_user% %new_pw2% ipmi reset
	)
	pause
	call %rootdir%\Run.bat
) else (
	echo '两次密码输入不一致！'
	pause
	goto menu
)
pause
goto menu

:del_user
cls
echo '-------删除用户---------'
echo.
set /p userid=user id:
echo.
for /f "delims=" %%i in (%ip_file%) do (
	cd /d %smc_dir% && SMCIPMITool.exe %%i %bmc_user% %bmc_pass% user delete %userid%
)
pause
goto menu