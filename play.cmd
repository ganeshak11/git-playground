@echo off
setlocal

set "GITBASH="

:: Check standard install locations.
:: Separate if-blocks avoid the %ProgramFiles(x86)% parsing bug —
:: the ) in the path closes a FOR block prematurely.

if exist "%ProgramFiles%\Git\bin\bash.exe" (
    set "GITBASH=%ProgramFiles%\Git\bin\bash.exe"
    goto :found
)

if exist "%LOCALAPPDATA%\Programs\Git\bin\bash.exe" (
    set "GITBASH=%LOCALAPPDATA%\Programs\Git\bin\bash.exe"
    goto :found
)

:: Handle ProgramFiles(x86) via a temp variable to avoid the ) parse issue
set "PF86=%ProgramFiles(x86)%"
if defined PF86 (
    if exist "%PF86%\Git\bin\bash.exe" (
        set "GITBASH=%PF86%\Git\bin\bash.exe"
        goto :found
    )
)

:: Try PATH, but SKIP System32\bash.exe — that's the WSL launcher,
:: not Git Bash. It runs, then fails confusingly.
for /f "tokens=*" %%i in ('where bash.exe 2^>nul') do (
    echo %%i | findstr /i /v "System32" >nul
    if not errorlevel 1 (
        set "GITBASH=%%i"
        goto :found
    )
)

echo.
echo  ERROR: Git Bash not found.
echo.
echo  Install Git for Windows: https://git-scm.com/download/win
echo  Then re-run this command.
echo.
exit /b 1

:found
:: %~dp0 = directory of this .cmd file (with trailing backslash).
:: --login ensures Git's usr\bin is on PATH, so grep/head/cut work.
:: Without it, a non-login shell may find Windows' find.exe instead.
"%GITBASH%" --login "%~dp0play" %*
