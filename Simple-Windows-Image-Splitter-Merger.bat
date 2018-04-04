@ECHO off
setlocal EnableDelayedExpansion
TITLE Simple Windows Image Splitter/Merger (WIM/ESD ^<-^> SWM) - By Joel Didier (Studisys)
GOTO ADMIN_RIGHTS_ROUTINE
::==================================================================
:: HERE STARTS THIS PART - ADMIN_RIGHTS_ROUTINE
::==================================================================
:ADMIN_RIGHTS_ROUTINE
IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
	>NUL 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
		) ELSE (
	>NUL 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
		)
IF '%ERRORLEVEL%' NEQ '0' (
GOTO GET_ADMIN_RIGHTS
) ELSE ( GOTO GET_ADMIN_RIGHTS_SUCCESS )
::==================================================================
:: HERE ENDS THIS PART - ADMIN_RIGHTS_ROUTINE
::==================================================================
::==================================================================
:: HERE STARTS THIS PART - GET_ADMIN_RIGHTS
::==================================================================
:GET_ADMIN_RIGHTS
CLS
COLOR 17
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                   Administrator Rights Required
ECHO.                           ================================================================
ECHO.
ECHO.
ECHO.  You did not execute the script as Administrator.
ECHO.  Administrator rights are required.
ECHO.  You will now be prompted for Administrator rights.
ECHO.  If you do not grant Administrator rights, this script will not run.
ECHO.
PAUSE
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\GET_ADMIN_RIGHTS.vbs"
SET params = %*:"=""
ECHO UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params%", "", "runas", 1 >> "%temp%\GET_ADMIN_RIGHTS.vbs"
"%temp%\GET_ADMIN_RIGHTS.vbs"
DEL "%temp%\GET_ADMIN_RIGHTS.vbs"
EXIT /B
::==================================================================
:: HERE ENDS THIS PART - GET_ADMIN_RIGHTS
::==================================================================
::==================================================================
:: HERE STARTS THIS PART - GET_ADMIN_RIGHTS_SUCCESS
::==================================================================
:GET_ADMIN_RIGHTS_SUCCESS
pushd "%CD%"
CD /D "%~dp0"
GOTO Home
::==================================================================
:: HERE ENDS THIS PART - GET_ADMIN_RIGHTS_SUCCESS
::==================================================================
::==================================================================
:: HERE STARTS THIS PART - Home
::==================================================================
:Home
CLS
COLOR 17
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                   	     Welcome
ECHO.                           ================================================================
ECHO.
ECHO.
ECHO.  Welcome to the Simple Windows Image Splitter/Merger (WIM/ESD ^<-^> SWM) (version 0.5.0-beta)
ECHO.
ECHO.  This tool allows to quickly split WIM/ESD Images into multiple SWM Images,
ECHO.  but also merging SWM images into single WIM/ESD Images.
ECHO.
ECHO.  Please read the full documentation on :
ECHO.  https://github.com/Studisys/Simple-Windows-Image-Splitter-Merger/
ECHO.
ECHO.
PAUSE
GOTO PROCESSING_ROUTINE
::==================================================================
:: HERE ENDS THIS PART - Home
::==================================================================


::==================================================================
:: HERE STARTS THIS PART - PROCESSING_ROUTINE
::==================================================================
:PROCESSING_ROUTINE
:: [1] Ask for conversion type
CALL :CONVERSION_TYPE_SET

:: [2] Set the source image path
CALL :SRCPATH_SET

IF "%CONVTYPE%" == "SWM2WIM" (
CALL :GET_SWM_FILES
)
IF "%CONVTYPE%" == "SWM2ESD" (
CALL :GET_SWM_FILES
)



:: [3] Set the destination image path
CALL :DSTPATH_SET



:: Now checking Conversion Type and proceed accordingly
:: [4] If conversion to SWM, set size per SWM
IF "%CONVTYPE%" == "WIM2SWM" CALL :FILE_SIZE_SET
IF "%CONVTYPE%" == "ESD2SWM" CALL :FILE_SIZE_SET
:: [4] If conversion from SWM, set compression type
IF "%CONVTYPE%" == "SWM2WIM" CALL :COMPRESSIONTYPE_SET
IF "%CONVTYPE%" == "SWM2ESD" CALL :COMPRESSIONTYPE_SET


:: [5] Select indexes to export
GOTO INDEX_SELECTION
GOTO EXIT
::==================================================================
:: HERE ENDS THIS PART - ProcessingRoutine
::==================================================================


::==================================================================
:: HERE STARTS THIS PART - FILE_SIZE_SET
::==================================================================
:FILE_SIZE_SET
CLS
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                         Program Parameters
ECHO.                                               Filesize per SWM Image
ECHO.                           ================================================================
ECHO.
ECHO.  Please choose the maximum size per SWM Image in MB, without quotes nor unit.
ECHO.  Please note that the maximum size per SWM Image is 4700MB.
ECHO.
ECHO.  Example : The input "700" (without quotes) will make SWM Images with a maximum size of 700MB each.
ECHO.
SET /P SWMSize=	 Size (in MB) : 
GOTO :eof

::==================================================================
:: HERE ENDS THIS PART - FILE_SIZE_SET
::==================================================================


::==================================================================
:: HERE STARTS THIS PART - CONPRESSION_TYPE_SET
::==================================================================
:COMPRESSIONTYPE_SET
CLS
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                         Program Parameters
ECHO.                                                  Compression Type
ECHO.                           ================================================================
ECHO.
ECHO. Please enter the compression type.
ECHO.
ECHO. Available Compression Types :
ECHO.
ECHO. [1] None :  No Compression (Fastest) [Destination Image bigger than Source Image]
ECHO.
ECHO. [2] Fast :  Low Compression (Fast) [Destination Image 'may' be bigger than Source Image]
ECHO.
ECHO. [3] Maximum :  Very High Compression (Slow) [Destination Image WAY smaller than Source Image]
ECHO.
ECHO. [4] Recovery :  Insane Compression (Slowest) [Destination Image WAY smaller than Source Image]
ECHO.
ECHO.
ECHO.                           ================================================================
ECHO.                                        Press 'Q' to exit, 'S' to start over
ECHO.                           ================================================================
ECHO.
CHOICE /c 1234qs /n /m "Your choice :  "
IF %ERRORLEVEL%==1 (
SET COMPRESSIONTYPE=None
)
IF %ERRORLEVEL%==2 (
SET COMPRESSIONTYPE=Fast
)
IF %ERRORLEVEL%==3 (
SET COMPRESSIONTYPE=Maximum
)
IF %ERRORLEVEL%==4 (
SET COMPRESSIONTYPE=Recovery
)
IF %ERRORLEVEL%==5 EXIT
IF %ERRORLEVEL%==6 GOTO ADMIN_RIGHTS_ROUTINE
GOTO :eof
::==================================================================
:: HERE ENDS THIS PART - CONPRESSION_TYPE_SET
::==================================================================

::==================================================================
:: HERE STARTS THIS PART - CONVERSION_TYPE_SET
::==================================================================
:CONVERSION_TYPE_SET
CLS
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                         Program Parameters
ECHO.                                                  Conversion Type
ECHO.                           ================================================================
ECHO.
ECHO.
ECHO.  What type of conversion do you want ?
ECHO.
ECHO.  [1] WIM --^> SWM
ECHO.  [2] ESD --^> SWM
ECHO. ------------------
ECHO.  [3] SWM --^> WIM
ECHO.  [4] SWM --^> ESD
ECHO.
ECHO.
ECHO.                           ================================================================
ECHO.                                        Press 'Q' to exit, 'S' to start over
ECHO.                           ================================================================
ECHO.
CHOICE /c 1234qs /n /m "  Your choice :  "
IF %ERRORLEVEL%==1 (
SET SRCtype=WIM
SET DSTtype=SWM
SET CONVTYPE=WIM2SWM
SET SRCPATH=install.wim
SET DSTPATH=install.swm
SET COMPRESSIONTYPE=Recovery
GOTO :eof
)
IF %ERRORLEVEL%==2 (
SET SRCtype=ESD
SET DSTtype=SWM
SET CONVTYPE=ESD2SWM
SET SRCPATH=install.esd
SET DSTPATH=install.swm
SET COMPRESSIONTYPE=Recovery
GOTO :eof
)
IF %ERRORLEVEL%==3 (
SET SRCtype=SWM
SET DSTtype=WIM
SET CONVTYPE=SWM2WIM
SET SRCPATH=install.swm
SET DSTPATH=install.wim
SET COMPRESSIONTYPE=Recovery
GOTO :eof
)
IF %ERRORLEVEL%==4 (
SET SRCtype=SWM
SET DSTtype=ESD
SET CONVTYPE=SWM2ESD
SET SRCPATH=install.swm
SET DSTPATH=install.esd
SET COMPRESSIONTYPE=Recovery
GOTO :eof
)
IF %ERRORLEVEL%==5 EXIT
IF %ERRORLEVEL%==6 GOTO ADMIN_RIGHTS_ROUTINE
GOTO :eof
::==================================================================
:: HERE ENDS THIS PART - CONVERSION_TYPE_SET
::==================================================================





::==================================================================
:: HERE STARTS THIS PART - SRCPATH_SET
::==================================================================
:SRCPATH_SET
CLS
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                            %SRCtype% --^> %DSTtype%
ECHO.                                                Path to Source Image
ECHO.                           ================================================================
ECHO.
ECHO.
ECHO. Please enter the path to the source image.
ECHO. (Do not include quotes "")
ECHO.
SET /P c=	 Path : 
SET SRCPATH=%c%
GOTO :eof
::==================================================================
:: HERE ENDS THIS PART - SRCPATH_SET
::==================================================================

::==================================================================
:: HERE STARTS THIS PART - DSTPATH_SET
::==================================================================
:DSTPATH_SET
CLS
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                            %SRCtype% --^> %DSTtype%
ECHO.                                             Path to Destination Image
ECHO.                           ================================================================
ECHO.
ECHO.
ECHO. Please enter the path to the destination image.
ECHO. (Do not include quotes "")
ECHO.
SET /P c=	 Path : 
SET DSTPATH=%c%
GOTO :eof
::==================================================================
:: HERE ENDS THIS PART - DSTPATH_SET
::==================================================================


::==================================================================
:: HERE STARTS THIS PART - INDEX_SELECTION
::==================================================================
:INDEX_SELECTION
CLS
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                            %SRCtype% --^> %DSTtype%
ECHO.                                                  Index Selection
ECHO.                           ================================================================
ECHO.
setlocal EnableDelayedExpansion
SET /A count=0
FOR /F "tokens=2 delims=: " %%i IN ('DISM /Get-WimInfo /WimFile:"%SRCPATH%" ^| findstr "Index"') DO SET images=%%i
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
FOR /L %%i in (1, 1, %images%) DO CALL :INDEXCOUNTER %%i
ECHO.         The %SRCtype% Image contains the following %images% indexes :
ECHO. 
FOR /L %%i in (1, 1, %images%) DO (
ECHO.  [%%i] !name%%i!
)
ECHO.
ECHO.                           ================================================================
ECHO.
ECHO.         What do you want to do ?
ECHO.
ECHO.  [1] Export a single Index
ECHO.  [2] Export all Indexes
ECHO.                           ================================================================
ECHO.                                        Press 'Q' to exit, 'S' to start over
ECHO.                           ================================================================
ECHO.
CHOICE /c 12qs /n /m "Your choice :  "
IF %ERRORLEVEL%==1 (
SET CONVERSION_TYPE=SINGLE_INDEX
ECHO.
SET /P INDEXCHOICE= Please enter the Index you want to export : 
GOTO PROCESSING_CONVERT
)
IF %ERRORLEVEL%==2 (
SET CONVERSION_TYPE=ALL_INDEXES
GOTO PROCESSING_CONVERT
)
IF %ERRORLEVEL%==3 EXIT
IF %ERRORLEVEL%==4 GOTO ADMIN_RIGHTS_ROUTINE
GOTO EXIT
::==================================================================
:: HERE ENDS THIS PART - INDEX_SELECTION
::==================================================================


:INDEXCOUNTER
SET /A count+=1
FOR /f "tokens=1* delims=: " %%i IN ('DISM /Get-WimInfo /wimfile:"%SRCPATH%" /index:%1 ^| find /i "Name"') DO SET name%count%=%%j
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
GOTO :eof


:DEL_DSTPATH
IF EXIST %DSTPATH% (
	DEL /F %DSTPATH%
)
GOTO :eof





:GET_SWM_FILES
CLS
TITLE
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.			                            %SRCtype% --^> %DSTtype%
ECHO.                                                    SWM Pattern
ECHO.                           ================================================================
ECHO.
ECHO.
ECHO. Please enter the SWM Pattern.
ECHO. Example : if the source SWM file was : "C:\Path\To\install.swm" , type :
ECHO. "C:\Path\To\install*.swm" (without quotes)
ECHO.
ECHO. (Do not include quotes "")
ECHO.
SET /P c=	 Path (Pattern) : 
SET SWMFILE=%c%
GOTO :eof




:PROCESSING_CONVERT
IF "%CONVERSION_TYPE%" == "SINGLE_INDEX" (
	IF "%CONVTYPE%" == "WIM2SWM" GOTO CONV2SWM_SINGLE_INDEX
	IF "%CONVTYPE%" == "ESD2SWM" GOTO CONV2SWM_SINGLE_INDEX
	IF "%CONVTYPE%" == "SWM2WIM" GOTO CONVFRMSWM_SINGLE_INDEX
	IF "%CONVTYPE%" == "SWM2ESD" GOTO CONVFRMSWM_SINGLE_INDEX
)

IF "%CONVERSION_TYPE%" == "ALL_INDEXES" (
	IF "%CONVTYPE%" == "WIM2SWM" GOTO CONV2SWM_ALL_INDEXES
	IF "%CONVTYPE%" == "ESD2SWM" GOTO CONV2SWM_ALL_INDEXES
	IF "%CONVTYPE%" == "SWM2WIM" GOTO CONVFRMSWM_ALL_INDEXES
	IF "%CONVTYPE%" == "SWM2ESD" GOTO CONVFRMSWM_ALL_INDEXES
)
GOTO :EOF



::==================================================================
:: HERE STARTS THIS PART - CONV2SWM_ALL_INDEXES
::==================================================================
:CONV2SWM_ALL_INDEXES
CLS
CALL :DEL_DSTPATH
TITLE Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype% - Exporting Index 1 / %images% . . . 
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.                                                   %SRCtype% --^> %DSTtype%
ECHO.                                            Splitting Image - All Indexes
ECHO.                                            Exporting Index 1 of %images% . . .
ECHO.                           ================================================================
ECHO.
ECHO.     This will export all indexes to the destination %DSTtype% Images.
ECHO.
ECHO.     PLEASE NOTE : 
ECHO.     This operation may take a few minutes to complete depending on your PC Hardware.
ECHO.     This operation will use a lot of CPU and Memory ressources.
ECHO.     Your system may be hotter or may seem unresponsive while processing your request.
ECHO.     Please do not interfer with the process before it has ended.
ECHO.
ECHO.              Operation : %SRCtype% to %DSTtype%
ECHO.                 Output : %DSTtype% Image / All Indexes (%images%)
ECHO.            Source Path : %SRCPATH%
ECHO.       Destination Path : %DSTPATH%
ECHO.       Compression Type : %COMPRESSIONTYPE%
ECHO.     Size per SWM Image : %SWMSize% MB
ECHO. 
ECHO.                           ================================================================
ECHO.
ECHO.                                              EXPORTING INDEX 1 OF %images%
ECHO.
ECHO.                                                 PLEASE WAIT . . .
DISM /Split-Image /ImageFile:"%SRCPATH%" /SWMFile:"%DSTPATH%" /SourceIndex:1 /FileSize:%SWMSize% /Compress:%COMPRESSIONTYPE% /CheckIntegrity> NUL 2>&1
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
FOR /L %%i IN (2, 1, %images%) DO (
CLS
TITLE Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype% - Exporting Index %%i / %images% . . . 
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.                                                   %SRCtype% --^> %DSTtype%
ECHO.                                            Splitting Image - All Indexes
ECHO.                                            Exporting Index %%i of %images% . . .
ECHO.                           ================================================================
ECHO.
ECHO.     This will export all indexes to the destination %DSTtype% Image.
ECHO.
ECHO.     PLEASE NOTE : 
ECHO.     This operation may take a few minutes to complete depending on your PC Hardware.
ECHO.     This operation will use a lot of CPU and Memory ressources.
ECHO.     Your system may be hotter or may seem unresponsive while processing your request.
ECHO.     Please do not interfer with the process before it has ended.
ECHO.
ECHO.
ECHO.                  Operation : %SRCtype% to %DSTtype%
ECHO.                     Output : %DSTtype% Image / All Indexes
ECHO.                Source Path : %SRCPATH%
ECHO.           Destination Path : %DSTPATH%
ECHO.           Compression Type : %COMPRESSIONTYPE%
ECHO.     Max Size per SWM Image : %SWMSize% MB
ECHO.
ECHO.                           ================================================================
ECHO.
ECHO.                                              EXPORTING INDEX %%i OF %images%
ECHO.
ECHO.                                                 PLEASE WAIT . . .
DISM /Split-Image /ImageFile:"%SRCPATH%" /SWMFile:"%DSTPATH%" /SourceIndex:%%i /FileSize:%SWMSize% /Compress:%COMPRESSIONTYPE% /CheckIntegrity> NUL 2>&1
)
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
GOTO SUCCESS
::==================================================================
:: HERE ENDS THIS PART - CONV2SWM_ALL_INDEXES
::==================================================================



::==================================================================
:: HERE STARTS THIS PART - CONV2SWM_SINGLE_INDEX
::==================================================================
:CONV2SWM_SINGLE_INDEX
CLS
CALL :DEL_DSTPATH
TITLE Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype% - Exporting Index %INDEXCHOICE% . . . 
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.                                                   %SRCtype% --^> %DSTtype%
ECHO.                                            Merging Image - Single Index
ECHO.                                             Exporting Index %INDEXCHOICE% . . .
ECHO.                           ================================================================
ECHO.
ECHO.     This will export all indexes to the destination %DSTtype% Images.
ECHO.
ECHO.     PLEASE NOTE : 
ECHO.     This operation may take a few minutes to complete depending on your PC Hardware.
ECHO.     This operation will use a lot of CPU and Memory ressources.
ECHO.     Your system may be hotter or may seem unresponsive while processing your request.
ECHO.     Please do not interfer with the process before it has ended.
ECHO.
ECHO.              Operation : %SRCtype% -^> %DSTtype%
ECHO.                 Output : %DSTtype% Image (Single Index - Index %INDEXCHOICE%)
ECHO.            Source Path : %SRCPATH%
ECHO.       Destination Path : %DSTPATH%
ECHO.       Compression Type : %COMPRESSIONTYPE%
ECHO.     Size per SWM Image : %SWMSize% MB
ECHO. 
ECHO.                           ================================================================
ECHO.
ECHO.                                                  EXPORTING INDEX %INDEXCHOICE%
ECHO.
ECHO.                                                  PLEASE WAIT . . .
DISM /Split-Image /ImageFile:"%SRCPATH%" /SWMFile:%DSTPATH% /SourceIndex:%INDEXCHOICE% /FileSize:%SWMSize% /Compress:%COMPRESSIONTYPE% /CheckIntegrity> NUL 2>&1
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
GOTO SUCCESS
::==================================================================
:: HERE ENDS THIS PART - CONV2SWM_SINGLE_INDEX
::==================================================================





::==================================================================
:: HERE STARTS THIS PART - CONVFRMSWM_SINGLE_INDEX
::==================================================================
:CONVFRMSWM_SINGLE_INDEX
CLS
CALL :DEL_DSTPATH
TITLE Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype% - Exporting Index %INDEXCHOICE% . . .  
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.                                                   %SRCtype% --^> %DSTtype%
ECHO.                                            Merging Image - Single Index
ECHO.                                              Exporting Index %INDEXCHOICE% . . .
ECHO.                           ================================================================
ECHO.
ECHO.     This will export all indexes to the destination %DSTtype% Image.
ECHO.
ECHO.     PLEASE NOTE : 
ECHO.     This operation may take a few minutes to complete depending on your PC Hardware.
ECHO.     This operation will use a lot of CPU and Memory ressources.
ECHO.     Your system may be hotter or may seem unresponsive while processing your request.
ECHO.     Please do not interfer with the process before it has ended.
ECHO.
ECHO.            Operation : %SRCtype% -^> %DSTtype%
ECHO.               Output : %DSTtype% Image (Single Index - Index %INDEXCHOICE%)
ECHO.          Source Path : %SRCPATH%
ECHO.              Pattern : %SWMFILE%
ECHO.     Destination Path : %DSTPATH%
ECHO.     Compression Type : %COMPRESSIONTYPE%
ECHO. 
ECHO.                           ================================================================
ECHO.
ECHO.                                                  EXPORTING INDEX %INDEXCHOICE%
ECHO.
ECHO.                                                  PLEASE WAIT . . .
DISM /Export-Image /sourceimagefile:"%SRCPATH%" /SourceIndex:%INDEXCHOICE% /swmfile:"%SWMFILE%" /destinationimagefile:"%DSTPATH%" /Compress:%COMPRESSIONTYPE% /CheckIntegrity >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
GOTO SUCCESS
::==================================================================
:: HERE ENDS THIS PART - CONVFRMSWM_SINGLE_INDEX
::==================================================================



::==================================================================
:: HERE STARTS THIS PART - CONVFRMSWM_ALL_INDEXES
::==================================================================
:CONVFRMSWM_ALL_INDEXES
CLS
CALL :DEL_DSTPATH
TITLE Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype% - Exporting Index 1 / %images% . . . 
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.                                                   %SRCtype% --^> %DSTtype%
ECHO.                                              Merging Image - All Indexes
ECHO.                                             Exporting Index 1 of %images% . . .
ECHO.                           ================================================================
ECHO.
ECHO.     This will export all indexes to the destination %DSTtype% Image.
ECHO.
ECHO.     PLEASE NOTE : 
ECHO.     This operation may take a few minutes to complete depending on your PC Hardware.
ECHO.     This operation will use a lot of CPU and Memory ressources.
ECHO.     Your system may be hotter or may seem unresponsive while processing your request.
ECHO.     Please do not interfer with the process before it has ended.
ECHO.
ECHO.            Operation : %SRCtype% -^> %DSTtype%
ECHO.               Output : %DSTtype% Image - All Indexes
ECHO.          Source Path : %SRCPATH%
ECHO.              Pattern : %SWMFILE%
ECHO.     Destination Path : %DSTPATH%
ECHO.     Compression Type : %COMPRESSIONTYPE%
ECHO. 
ECHO.                           ================================================================
ECHO.
ECHO.                                              EXPORTING INDEX 1 OF %images%
ECHO.
ECHO.                                                 PLEASE WAIT . . .
DISM /Export-Image /sourceimagefile:"%SRCPATH%" /SourceIndex:1 /swmfile:"%SWMFILE%" /destinationimagefile:"%DSTPATH%" /Compress:%COMPRESSIONTYPE% /CheckIntegrity >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
FOR /L %%i IN (2, 1, %images%) DO (
CLS
TITLE Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype% - Exporting Index %%i / %images% . . . 
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.                                                   %SRCtype% --^> %DSTtype%
ECHO.                                              Splitting Image - All Indexes
ECHO.                                             Exporting Index %%i of %images% . . .
ECHO.                           ================================================================
ECHO.
ECHO.     This will export all indexes to the destination %DSTtype% Image.
ECHO.
ECHO.     PLEASE NOTE : 
ECHO.     This operation may take a few minutes to complete depending on your PC Hardware.
ECHO.     This operation will use a lot of CPU and Memory ressources.
ECHO.     Your system may be hotter or may seem unresponsive while processing your request.
ECHO.     Please do not interfer with the process before it has ended.
ECHO.
ECHO.
ECHO.            Operation : %SRCtype% -^> %DSTtype%
ECHO.               Output : %DSTtype% Image - All Indexes
ECHO.          Source Path : %SRCPATH%
ECHO.              Pattern : %SWMFILE%
ECHO.     Destination Path : %DSTPATH%
ECHO.     Compression Type : %COMPRESSIONTYPE%
ECHO.
ECHO.                           ================================================================
ECHO.
ECHO.                                              EXPORTING INDEX %%i OF %images%
ECHO.
ECHO.                                                 PLEASE WAIT . . .
DISM /Export-Image /sourceimagefile:"%SRCPATH%" /swmfile:"%SWMFILE%" /SourceIndex:%%i /destinationimagefile:"%DSTPATH%" /Compress:%COMPRESSIONTYPE% /CheckIntegrity >NUL 2>&1
)
IF %ERRORLEVEL% NEQ 0 GOTO ERROR
GOTO SUCCESS
::==================================================================
:: HERE ENDS THIS PART - CONVFRMSWM_ALL_INDEXES
::==================================================================














:SUCCESS
CLS
TITLE Success - Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype%
COLOR 17
ECHO.
ECHO.                           ================================================================
ECHO.                                        Simple Windows Image Splitter/Merger
ECHO.                                                      Success
ECHO.                           ================================================================
ECHO.
ECHO. Successfully performed requested tasks.
ECHO.
ECHO.            Operation : %SRCtype% -^> %DSTtype%
ECHO.          Source Path : %SRCPATH%
ECHO.     Destination Path : %DSTPATH%
ECHO.     Compression Type : %COMPRESSIONTYPE%
ECHO.
ECHO.
ECHO. Thanks for using my script.
ECHO. GitHub Page : https://github.com/Studisys/Simple-Windows-Image-Splitter-Merger/
ECHO. Version : 0.5.0-beta
ECHO. Author : Joel Didier (Studisys)
ECHO. Twitter : https://twitter.com/Studisys
ECHO. Email : studisys@protonmail.com
ECHO. 
ECHO.                           ================================================================
ECHO.                                        Press 'Q' to exit, 'S' to start over
ECHO.                           ================================================================
ECHO.
CHOICE /c qs /n /m ""
IF %ERRORLEVEL%==1 EXIT
IF %ERRORLEVEL%==2 GOTO ADMIN_RIGHTS_ROUTINE
EXIT

:ERROR
TITLE Error - Simple Windows Image Splitter/Merger - %SRCtype%2%DSTtype%
COLOR 17
ECHO.
ECHO.                           ================================================================
ECHO.                                              Simple WIM2ESD Converter
ECHO.                                                       Error
ECHO.                           ================================================================
ECHO.
ECHO. Something wrong occured . . .
ECHO.
ECHO. Currently, there is no log, except the one generated from DISM.
ECHO. This script will generate a complete log in the future.
ECHO. Please send me the error given by DISM and the log located in :
ECHO. C:\WINDOWS\Logs\DISM\dism.log
ECHO.
ECHO.
ECHO. Thanks in advance.
ECHO.
ECHO. GitHub Page : https://github.com/Studisys/Simple-Windows-Image-Splitter-Merger/
ECHO.
ECHO. Author : Joel Didier (Studisys)
ECHO. Twitter : https://twitter.com/Studisys
ECHO. Email : studisys@protonmail.com
ECHO.
ECHO.                           ================================================================
ECHO.                                        Press 'Q' to exit, 'S' to start over
ECHO.                           ================================================================
ECHO.
CHOICE /c qs /n /m ""
IF %ERRORLEVEL%==1 EXIT
IF %ERRORLEVEL%==2 GOTO ADMIN_RIGHTS_ROUTINE
EXIT