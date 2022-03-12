@echo off

:: Define font color
color 2

set json_content="{\"ControllerId\":0, \"Raid\": \"RAID1\", \"Span\": 1, \"PhysicalDrives\":[\"HA-RAID.0.Disk.0\", \"HA-RAID.0.Disk.1\"], \"UsePercentage\":100, \"LogicalDriveCount\":1, \"StripSizePerDDF\":\"256K\", \"LdReadPolicy\":\"AlwaysReadAhead\", \"LdWritePolicy\":\"WriteBack\", \"LdIOPolicy\":\"DirectIO\", \"AccessPolicy\":\"ReadWrite\", \"DiskCachePolicy\":\"Unchanged\", \"InitState\":\"QuickInit\"}"

::User Name Password
set bmc_user=%1
set bmc_pass=%2

:: author info
:menu
cls
echo --------------------------------------------------------------------
echo Author: yanghao
echo Email: Gboyanghao@163.com
echo Version: 0.0.1
echo Describe: This is the batch RAID configuration script
echo Environment: 针对3108RAID卡进行操作，其他版本RAID卡兼容问题尚未可知
echo --------------------------------------------------------------------
echo.
echo 1、批量配置RAID
echo.
echo 2、修改JBOD功能是否开启
echo.
echo 3、返回主菜单
echo.


:: chdir
set chdir=%~dp0

:: ROOTDIR
for %%d in (%~dp0..) do set rootdir=%%~fd

set ip_file=%rootdir%\ip.txt
:: DIR If there is a
if not exist %ip_file% (
	echo '%ip_file% file does not exist!'
	goto end
)

set log_dir=%rootdir%\log
if NOT exist %log_dir% (
	md %log_dir%
)

:: INPUT
set /p msg=INPUT NUM(1/2):
if %msg% == 1 (
	goto configure_RAID
) else if %msg% == 2 (
	goto start_jbod
) else if %msg% == 3 (
	call %rootdir%\Run.bat
) else (
	echo 请确认你的输入是否正确，按任意键结束..........
	pause
	goto menu
)

:configure_RAID
	cls
	set /p msg=Whether to start execution(yes/no):
	if %msg% == yes (
		echo.
		echo RAID任务开始下发，请耐心等待.......
		echo.
		for /f %%i in (%ip_file%) do ( 
		echo %%i >> %log_dir%\raid_log.txt
		curl -X POST -H 'Content-Type':'application/json' -d %json_content% -u %bmc_user%:%bmc_pass%  https://%%i/redfish/v1/Systems/1/Storages/HA-RAID/Actions/Oem/Storage.CreateVolume -k >> %log_dir%\raid_log.txt
		echo. >>%log_dir%\raid_log.txt
		)
	) else if %msg% == no (
		echo 返回菜单...............
		goto menu
	) else (
		echo 请确认你的输入是否正确，按任意键返回..........
		pause
		goto menu
	)
	goto menu

:: 是否开启jbod
:start_jbod
	cls
	set /p msg=JBOD(enable\disable):
	if %msg% == enable (
		set jbod_json_content="{\"ControllerId\":0,\"BIOSBootMode\":\"PauseOnError\",\"JBODMode\":\"Enable\"}"
	) else if %msg% == disable (
		set jbod_json_content="{\"ControllerId\":0,\"BIOSBootMode\":\"PauseOnError\",\"JBODMode\":\"Disable\"}"
	) else (
		echo 请确认你的输入是否正确，按任意键返回..........
		goto menu
	)
	echo.
	echo JBOD任务开始下发，请耐心等待.......
	echo.
	for /f %%i in (%ip_file%) do ( 
	echo %%i >>%log_dir%\jbod_log.txt
	curl -X PATCH -H 'Content-Type':'application/json' -d %jbod_json_content% -u %bmc_user%:%bmc_pass% https://%%i/redfish/v1/Systems/1/Storages/HA-RAID/Actions/Oem/HARAIDController.Save -k >> %log_dir%\jbod_log.txt
	echo. >>%log_dir%\jbod_log.txt
	)
	goto menu

::end
:end 
	pause
