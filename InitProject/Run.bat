@echo off

:: Define font color
color 2

:: chdir
set chdir=%~dp0
set bmc_user=ADMIN
echo.
set bmc_pass=ADMIN

cls
echo --------------------------------------------------------------------
echo Author: yanghao
echo Email: Gboyanghao@163.com
echo Version: 0.0.1
echo Describe: The entrance to the script
echo Environment: windown
echo --------------------------------------------------------------------

echo 1、升级BIOS		7、升级BMC
echo.
echo 2、配置RAID		8、收集SEL日志
echo.
echo 3、配置SNMP
echo.
echo 4、用户管理
echo.
echo 5、定位灯
echo.
echo 6、电源操作
echo.
set /p info=请输入数字:
if %info% == 1 (

	call %chdir%\Script\UpdateBios.bat %bmc_user% %bmc_pass%
	
) else if %info% == 2 ( 
	
	call %chdir%\Script\RaidConfig.bat %bmc_user% %bmc_pass%
	
) else if %info% == 3 ( 

	call %chdir%\Script\SnmpConfig.bat %bmc_user% %bmc_pass%
	
) else if %info% == 4 (

	call %chdir%\Script\UserConfig.bat %bmc_user% %bmc_pass%
	
) else if %info% == 5 (
	
	call %chdir%\Script\SetUid.bat %bmc_user% %bmc_pass%
	
) else if %info% == 6 (
	
	call %chdir%\Script\Power.bat %bmc_user% %bmc_pass%
	
) else if %info% == 7 (
	
	call %chdir%\Script\UpdateBMC.bat %bmc_user% %bmc_pass%
	
) else if %info% == 8 (
	
	call %chdir%\Script\Sel.bat %bmc_user% %bmc_pass%
	
) else (

	exit
	
)