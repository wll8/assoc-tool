@echo off&color 2f&mode con lines=45 cols=145&title %exe_name% 便携版工具
set exe_path=notepad2.exe
set exe_name=%exe_path%
set ext_list=ext.txt


if not exist %exe_path% (echo 目标程序不存在，请把本工具复制到 %exe_path% 所在的目录运行！ &pause>nul&exit)
if not exist %ext_list% (echo 目标程序不存在，请把本工具复制到 %ext_list% 所在的目录运行！ &pause>nul&exit)


echo.
echo.%exe_name% 便携版工具包使用说明
echo.
echo 操作序号：
echo   1: 添加右键菜单;
echo   2: 删除右键菜单;
echo   3: 关联扩展名(扩展名保存在同目录的 %ext_list% 文件中);
echo   4: 删除扩展名;
echo   5: 退出;
echo.

:begin
set u=&set /p u=输入操作序号并按 enter 键：
if "%u%" == "1" goto reg_menu
if "%u%" == "2" goto un_reg_menu
if "%u%" == "3" goto text_file
if "%u%" == "4" goto un_text_file
if "%u%" == "5" exit
goto begin



:reg_menu
reg add "hkcr\*\shell\%exe_name%" /ve /d "使用 %exe_name% 打开" /f
reg add "hkcr\*\shell\%exe_name%\command" /ve /d "%cd%\%exe_path% """%%1%"""" /f
echo.&echo 已成功注册右键菜单 &echo.&goto begin



:un_reg_menu
reg delete "hkcr\*\shell\%exe_name%" /f
echo.&echo 已成功卸载右键菜单 &echo.&goto begin

:text_file
reg add "hkcr\text_file" /ve /d "文本文档" /f
reg add "hkcr\text_file\defaulticon" /ve /d "%cd%\%exe_path%" /f
reg add "hkcr\text_file\shell\open\command" /ve /d "%cd%\%exe_path% """%%1%"""" /f
for /f "eol=;" %%e in (%ext_list%) do (
    (for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /ve') do (
      if not "%%c" == "text_file" (
        reg add "hkcr\.%%e" /v "text_backup" /d "%%c" /f
      )
    ))
    assoc .%%e=text_file
  )
echo.&echo 已成功注册扩展名 &echo.&goto begin



:un_text_file
reg delete "hkcr\text_file" /f
for /f "eol=;" %%e in (%ext_list%) do (
    (for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "hkcr\.%%e" /v "text_backup"') do (
      reg add "hkcr\.%%e" /ve /d "%%c" /f
      reg delete "hkcr\.%%e" /v "text_backup" /f
    ))
  )
echo.&echo 已成功卸载扩展名 &echo.&goto begin

