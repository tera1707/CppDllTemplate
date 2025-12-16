@echo off
chcp 932
setlocal

REM === 1. nuget.exe を同じ階層にダウンロード ===
set NUGET_URL=https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
set NUGET_EXE=%~dp0nuget.exe

if not exist "%NUGET_EXE%" (
    echo Downloading nuget.exe...
    powershell -Command "Invoke-WebRequest -Uri %NUGET_URL% -OutFile '%NUGET_EXE%'"
) else (
    echo nuget.exe already exists.
)

REM === 2. nupkg フォルダ内の DllTest.nuspec を使って nupkg を作成 ===
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
