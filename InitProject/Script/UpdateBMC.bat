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

echo 1����ȡ��̨BMC��Ϣ
echo.
echo 2������BMC�̼�
echo.
echo 3���������˵�
echo.

rem Define the directory
set host_info=%rootdir%\log\ServerVersion
if not exist %host_info% (
	md %host_info%
)
set bmc_file=%rootdir%\SMCI_BMC.rom

set /p info=����������:

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

cls
echo '..........ִ����..............'
cd /d %sum_dir% && sum.exe -i %ip_add% -u %user_name% -p %password% -c GetBmcInfo --file %bmc_file%
pause
goto meun


:upgrade_bmc
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
		cd /d %sum_dir% && sum.exe -l %ip_file% -u %bmc_user% -p %bmc_pass% -c UpdateBmc --file %update_file%
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