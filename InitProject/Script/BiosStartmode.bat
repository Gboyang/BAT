@echo off

:: Define font color
color 2

echo -------------------------------------------
echo '��ѡ�������ڹ�����ʼ��������BIOS������������Ĭ�ϵġ�'
echo 'ֻҪ����ģʽ��Ҫ���ģ����ű�ֻ�����BIOS����ģʽ����'
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
set /p user_name=������BMC�˺š�:
if NOT defined user_name ( 
	cls
	echo .............................................
	echo .........��ERROR: �û�������Ϊ�ա�...........
	echo .............................................
	pause
)
echo.
set /p user_pass=������BMC���롿:
if NOT defined user_pass (
	cls
	echo ...........................................
	echo .........��ERROR: ���벻��Ϊ�ա�...........
	echo ...........................................
	pause
)

for /f %%i in (%ip_file%) do (
	echo %%i
	curl -X PATCH -H 'Content-Type':'application/json' -d %para% -u %user_name%:%user_pass% https://%%i/redfish/v1/Systems/1/Bios  -k
	echo.
)
pause
