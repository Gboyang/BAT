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
echo 1����ȡbios�汾��Ϣ
echo.
echo 2����ȡ��̨������Ϣ
echo.
echo 3������bios����
echo.
echo 4������bios�̼�
echo.
echo 5���������˵�
echo.

set /p info=����������:
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
set /p ip_add=������IP��ַ��:
if NOT defined ip_add (
	cls
	echo ............................................
	echo .........��ERROR: ip��ַ����Ϊ�ա�..........
	echo ............................................
	pause
	goto meun
)
echo.
set /p user_name=������BMC�˺š�:
if NOT defined user_name ( 
	cls
	echo .............................................
	echo .........��ERROR: �û�������Ϊ�ա�...........
	echo .............................................
	pause
	goto meun
)
echo.
set /p password=������BCM���롿:
if NOT defined password (
	cls
	echo ...........................................
	echo .........��ERROR: ���벻��Ϊ�ա�...........
	echo ...........................................
	pause
	goto meun
)
echo.
set getConfig_Path=%rootdir%\bios.xml
set /p getConfig_Path=��default: %getConfig_Path%��:

cls
echo ------------------ȷ����Ϣ---------------------
echo.
echo username: %user_name%
echo password: %password%
echo configfile: %getConfig_Path%
echo.
echo ------------------------------------------------
set /p input_info=��yes/no��:
if %input_info% == yes (
	echo '..........ִ����..............'
	cd /d %sum_dir% && sum.exe -i %ip_add% -u %user_name% -p %password% -c GetCurrentBiosCfg --file %getConfig_Path% --overwrite
	pause
	goto meun
) else (
	goto meun
)


:change_bios_config
cls
set /p config_file=�����������ļ�·������
if NOT defined config_file (
	cls
	echo ...........................................
	echo ....��ERROR: �����ļ�·������Ϊ�ա�........
	echo ...........................................
	pause
	goto meun
)

cls
echo ------------------ȷ����Ϣ---------------------
echo.
echo username: %bmc_user%
echo password: %bmc_pass%
echo configfile: %config_file%
echo.
echo ------------------------------------------------
set /p input_info=��yes/no��:
if %input_info% == yes (
	if exist %config_file% (
		echo '..........ִ����..............'
		cd /d %sum_dir% && sum.exe -l %ip_file% -u %bmc_user% -p %bmc_pass% -c ChangeBiosCfg --file %config_file% --reboot --individually
	else (
		echo %config_file%û���ҵ����ļ�
		goto meun
	)
) else (
	pause
	goto meun
)


:upgrade_bios
cls
set /p update_file=��INPUT Update File����
if NOT defined update_file (
	cls
	echo ...........................................
	echo ....��ERROR: �����ļ�·������Ϊ�ա�........
	echo ...........................................
	pause
	goto meun
)

cls
echo -------------------ȷ����Ϣ--------------------
echo.
echo username: %bmc_user%
echo password: %bmc_pass%
echo update_file: %update_file%
echo.
echo -----------------------------------------------
set /p input_info=��yes/no��:
if %input_info% == yes (
	if exist %update_file% (
		cls
		echo '��ʼ�·�..........'
		cd /d %sum_dir% && sum.exe -l %ip_file% -u %bmc_user% -p %bmc_pass% -c UpdateBios --file %update_file% --force_update --reboot
		pause
		goto meun
	) else (
		echo '�����ļ������ڣ����򷵻�'
		pause
		goto meun
	)
) else (
	goto meun
)
pause