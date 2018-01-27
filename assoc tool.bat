@echo off&color 2f&mode con lines=45 cols=145&title 文件关联工具

echo.
echo.-------------- 文件关联工具使用说明 --------------
echo.
echo 操作序号：
echo   1: 添加右键菜单
echo   2: 删除右键菜单
echo   3: 关联扩展名(与程序同目录的 ext.txt 文件中)
echo   4: 删除扩展名
echo   5: 退出
echo.

echo 拖入程序后，点击此窗口按 enter 键：
set /p exe_path=
for %%i in (%exe_path%) do (set file_name=%%~nxi)
for %%i in (%exe_path%) do (set file_path=%%~dpi)
set exe_path=%exe_path:"=%
set ext_path=%file_path%ext.txt
if not exist "%ext_path%" (echo.&echo 注意：&echo 扩展名列表文件 "%ext_path%" 不存在。&pause>nul&exit)


:begin
echo.
set u=&set /p u=输入操作序号：
if "%u%" == "1" goto reg_menu
if "%u%" == "2" goto un_reg_menu
if "%u%" == "3" goto text_file
if "%u%" == "4" goto un_text_file
if "%u%" == "5" exit
goto begin


:reg_menu
reg add "hkcr\*\shell\%file_name%" /ve /d "使用 %file_name% 打开" /f >nul 2>nul
reg add "hkcr\*\shell\%file_name%\command" /ve /d "%exe_path% """%%1%"""" /f >nul 2>nul
echo.&echo 注册右键菜单完成 &echo.&goto begin

:un_reg_menu
reg delete "hkcr\*\shell\%file_name%" /f >nul 2>nul
echo.&echo 卸载右键菜单完成 &echo.&goto begin

:text_file
reg add "hkcr\text_file" /ve /d "文本文档" /f >nul 2>nul
reg add "hkcr\text_file\defaulticon" /ve /d "%exe_path%" /f >nul 2>nul
reg add "hkcr\text_file\shell\open\command" /ve /d "%exe_path% """%%1%"""" /f >nul 2>nul

for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /ve') do (
      if not "%%c" == "text_file" (
        reg add "hkcr\.%%e" /v "text_backup" /d "%%c" /f >nul 2>nul
      )
    )
  )
  assoc .%%e=text_file
)
echo.&echo 注册扩展名完成 &echo.&goto begin


:un_text_file
reg delete "hkcr\text_file" /f >nul 2>nul
for /f "eol=; delims=" %%e in ('type "%ext_path%"') do (
  (
    for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /v "text_backup"') do (
      reg add "hkcr\.%%e" /ve /d "%%c" /f >nul 2>nul
      reg delete "hkcr\.%%e" /v "text_backup" /f >nul 2>nul
    )
  )
)
echo.&echo 卸载扩展名完成 &echo.&goto begin

