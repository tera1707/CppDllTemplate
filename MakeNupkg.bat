@echo off
chcp 932
setlocal

call "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"

cd %~dp0

REM === 1. nuget.exe を同じ階層にダウンロード ===
set NUGET_URL=https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
set NUGET_EXE=%~dp0nuget.exe
set DLLPJPATH=%~dp0DllTest\DllTest.vcxproj

if not exist "%NUGET_EXE%" (
    echo Downloading nuget.exe...
    powershell -Command "Invoke-WebRequest -Uri %NUGET_URL% -OutFile '%NUGET_EXE%'"
) else (
    echo nuget.exe already exists.
)


REM === ビルド実施後、必要成果物ファイルをnupkg フォルダにコピー ===
xcopy /Y /S /I  "%~dp0DllTest\DllTest.h" "%~dp0nupkg\include\"

MSBuild %DLLPJPATH% /t:clean;rebuild /p:Configuration=Release;Platform="x64"
xcopy /Y /S /I "%~dp0DllTest\x64\Release\*.dll" "%~dp0nupkg\lib\native\x64\Release\"
xcopy /Y /S /I "%~dp0DllTest\x64\Release\*.lib" "%~dp0nupkg\lib\native\x64\Release\"

MSBuild %DLLPJPATH% /t:clean;rebuild /p:Configuration=Release;Platform="Win32"
xcopy /Y /S /I "%~dp0DllTest\Release\*.dll" "%~dp0nupkg\lib\native\x86\Release\"
xcopy /Y /S /I "%~dp0DllTest\Release\*.lib" "%~dp0nupkg\lib\native\x86\Release\"

MSBuild %DLLPJPATH% /t:clean;rebuild /p:Configuration=Debug;Platform="x64"
xcopy /Y /S /I "%~dp0DllTest\x64\Debug\*.dll" "%~dp0nupkg\lib\native\x64\Debug\"
xcopy /Y /S /I "%~dp0DllTest\x64\Debug\*.lib" "%~dp0nupkg\lib\native\x64\Debug\"

MSBuild %DLLPJPATH% /t:clean;rebuild /p:Configuration=Debug;Platform="Win32"
xcopy /Y /S /I "%~dp0DllTest\Debug\*.dll" "%~dp0nupkg\lib\native\x86\Debug\"
xcopy /Y /S /I "%~dp0DllTest\Debug\*.lib" "%~dp0nupkg\lib\native\x86\Debug\"

REM === nupkg フォルダ内の DllTest.nuspec を使って nupkg を作成 ===
set NUSPEC=%~dp0nupkg\DllTest.nuspec

if exist "%NUSPEC%" (
    echo Packing NuGet package...
    "%NUGET_EXE%" pack "%NUSPEC%" -OutputDirectory "%~dp0nupkg"
    echo Done.
) else (
    echo ERROR: DllTest.nuspec not found in nupkg folder.
)

endlocal

echo nuget.exeの出すNU5128:は、nativeのみのライブラリなら無視してOK。

pause
