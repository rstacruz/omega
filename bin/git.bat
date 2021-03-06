@rem Do not use "echo off" to not affect any child calls.
@setlocal

@rem Get the abolute path to the parent directory, which is assumed to be the
@rem Git installation root.
:: Find root dir

@if not DEFINED BaseDir (
    set _flagCreateBaseDir=1
) else (
    set _flagCreateBaseDir=0
    if not Exist %BaseDir%\system\git ( set _flagCreateBaseDir=1 )
)
@if %_flagCreateBaseDir% EQU 1 (
    for /f "delims=" %%i in ("%~dp0\..") do @set BaseDir=%%~fi
)

@if exist "%temp%\KeeAgent.sock" (
    SET SSH_AUTH_SOCK=%temp%\KeeAgent.sock
)
@set "gitdir=%BaseDir%\system\git\"
@if not EXIST %gitdir% (
    ERROR GIT NOT FOUND IN %BaseDir%
    EXIT /B 1
)
@set PATH=%gitdir%cmd;%gitdir%usr\bin;%PATH%

@REM see git documentation for more infromation
@REM https://git-scm.com/docs/git

@REM reverse the formatting of the editor's path, VIM
@REM change from \ backslash to / forwardslash
@REM as git will not accept WINDOWS-style PATHS
@set "editor=%BaseDir%\system\vim\vim.exe"
@set editor=%editor:\=/%

@git.exe -c include.path="%BaseDir%\config\omega.gitconfig" -c core.editor="%editor%" -c core.excludesFile="%BaseDir%\config\omega.gitignore" %*
