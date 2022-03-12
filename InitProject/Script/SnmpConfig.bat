@echo off

rem Define font color
color 2

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

set bmc_user=%1
set bmc_pass=%2

:meun
cls
echo --------------------------------------------------------------------
echo Author: yanghao
echo Email: Gboyanghao@163.com
echo Version: 0.0.1
echo Describe: SNMP Config script
echo Environment: windown
echo --------------------------------------------------------------------

echo 1、开启SNMP功能
echo.
echo 2、配置snmp v2
echo.
echo 3、配置SNMP trap
echo.
echo 4、配置LLDP
echo.
echo 5、返回主菜单
echo.

set /p info=请输入数字:
if %info% == 1 ( 
goto start_snmp
) else if %info% == 2 ( 
goto conf_v2 
) else if %info% == 3 (
goto conf_trap
) else if %info% == 4 (
goto conf_lldp
) else if %info% == 5 (
	call %rootdir%\Run.bat
) else (
	exit
)

:conf_lldp
cls
echo '开始下发任务..............'
for /f %%i in (%ip_file%) do (
	echo %%i >>%log_dir%\lldp.log
	curl -X PATCH -H 'Content-Type':'application/json' -d "{\"LldpEnabled\": true}" -u %bmc_user%:%bmc_pass% https://%%i/redfish/v1/Managers/1/LldpService -k >>%log_dir%\lldp.log
	echo. >>%log_dir%\lldp.log
)
pause
goto meun

:start_snmp
cls
echo '开始下发任务..............'
for /f %%i in (%ip_file%) do (
	echo %%i >>%log_dir%\start_snmp.log
	curl -X PATCH -H 'Content-Type':'application/json' -d "{\"SnmpV1Enabled\": true}" -u %bmc_user%:%bmc_pass% https://%%i/redfish/v1/Managers/1/SnmpService -k >>%log_dir%\start_snmp.log
	echo. >>%log_dir%\start_snmp.log
)
pause
goto meun

:conf_trap
set /p tr_addr=【输入配置trap地址】:
if NOT defined tr_addr (
	cls
	echo ...........................................
	echo .........【ERROR: trad地址不能为空】...........
	echo ...........................................
	pause
	goto meun
)
echo.

cls
echo '开始下发...........................'
set json_content={\"SnmpTrapNotification\": {\"TrapServer\":[{\"Enabled\":false,\"AlarmSeverity\":null,\"TrapServerAddress\":\"0.0.0.0\",\"TrapServerPort\":162},{\"Enabled\":true,\"AlarmSeverity\":\"Information\",\"TrapServerAddress\":\"%tr_addr%\",\"TrapServerPort\":162}]}}

for /f %%i in (%ip_file%) do (
	echo %%i >>%log_dir%\trap.log
	 curl -X PATCH -H 'Content-Type':'application/json' -d "%json_content%" -u %bmc_user%:%bmc_pass% https://%%i/redfish/v1/Managers/1/SnmpService -k >> %log_dir%\trap.log
	 echo. >> %log_dir%\trap.log
)

pause
goto meun

:conf_v2
cls
set t_r_name=yundiaoCOC2016
set t_w_name=yundiaoCOC2016
echo.
cls
echo '任务下发.................'
for /f %%i in (%ip_file%) do (
	echo %%i >>%log_dir%\snmp_v2.log
	curl -X PATCH -H 'Content-Type':'application/json' -d "{\"SnmpV2CEnabled\": true,\"ReadOnlyCommunity\": \"%t_r_name%\",\"ReadWriteCommunity\": \"%t_w_name%\"}" -u %bmc_user%:%bmc_pass% https://%%i/redfish/v1/Managers/1/SnmpService -k >> %log_dir%\snmp_v2.log
	echo. >>%log_dir%\snmp_v2.log
)
pause
goto meun

::end
:end 
	pause