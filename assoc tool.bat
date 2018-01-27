@echo off&color f2&mode con lines=45 cols=145&title 文件关联工具 -- by xw

call :doc

echo  拖入程序后，点击此窗口按 enter 键：
set /p exe_path=
for %%i in (%exe_path%) do (set exe_name=%%~nxi)
for %%i in (%exe_path%) do (set temp=%%~dpi)
set exe_name=%exe_name:.exe=%
set exe_path=%exe_path:"=%
set ext_path=%temp%ext.txt
set ext_tag=text_file

call :doc &if not exist "%ext_path%" (echo  注意：扩展名列表文件 "%ext_path%" 不存在。&pause>nul&exit)


:begin
echo.&set u=&set /p u= 输入操作序号：
if "%u%" == "1" goto reg_menu
if "%u%" == "2" goto reg_ext
if "%u%" == "3" goto reg_ico
if "%u%" == "4" goto un_reg_ext
if "%u%" == "5" goto un_reg_menu
if "%u%" == "6" exit
call :doc &goto begin


:reg_menu
reg add "hkcr\*\shell\%exe_name%" /ve /d "使用 %exe_name% 打开" /f >nul 2>nul
reg add "hkcr\*\shell\%exe_name%\command" /ve /d "%exe_path% """%%1%"""" /f >nul 2>nul
call :doc &echo.&echo  * 添加右键菜单完成 &echo.&goto begin

:un_reg_menu
reg delete "hkcr\*\shell\%exe_name%" /f >nul 2>nul
call :doc &echo.&echo  * 取消添加右键菜单完成 &echo.&goto begin

:reg_ico
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    if exist "%cd%\icons\%%e.ico" (
      reg add "hkcr\%ext_tag%.%%e\defaulticon" /ve /d "%cd%\icons\%%e.ico" /f >nul 2>nul
    )
  )
)
taskkill /f /im explorer.exe >nul 2>nul&start explorer.exe
call :doc &echo.&echo  * 关联图标完成 &echo.&goto begin

:reg_ext
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    reg add "hkcr\%ext_tag%.%%e" /ve /d "%%e" /f >nul 2>nul
    reg add "hkcr\%ext_tag%.%%e\defaulticon" /ve /d "%exe_path%" /f >nul 2>nul
    reg add "hkcr\%ext_tag%.%%e\shell\open\command" /ve /d """"%exe_path%""" """%%1%"""" /f >nul 2>nul
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /ve') do (
      if not "%%c" == "%ext_tag%" (
        reg add "hkcr\.%%e" /v "ext_backup" /d "%%c" /f >nul 2>nul
      )
    )
  )
  assoc .%%e=%ext_tag%.%%e
)
call :doc &echo.&echo  * 关联扩展名完成 &echo.&goto begin


:un_reg_ext
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    reg delete "hkcr\%ext_tag%.%%e" /f >nul 2>nul
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /v "ext_backup"') do (
      reg add "hkcr\%ext_tag%.%%e" /ve /d "%%c" /f >nul 2>nul
      reg delete "hkcr\%ext_tag%.%%e" /v "ext_backup" /f >nul 2>nul
    )
  )
)
taskkill /f /im explorer.exe >nul 2>nul&start explorer.exe
call :doc &echo.&echo  * 取消关联扩展名完成 &echo.&goto begin


:doc
cls&echo.
echo. -------------- 文件关联工具使用说明 --------------
echo.
echo  操作序号：
echo   1 添加右键菜单
echo   2 关联扩展名(与程序同目录的 ext.txt 文件中)
echo   3 关联图标
echo   4 取消关联扩展名
echo   5 取消添加右键菜单
echo   6 退出
echo.
goto :eof
