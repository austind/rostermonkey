@echo off
setlocal

REM ********************************************************************************
REM * process_classes.bat
REM *
REM * Usage:
REM *
REM * This batch file is designed to be run as a scheduled task.
REM * It must be run in FSC-Destiny\fsc\automate directory.
REM *
REM * By default, no commandline arguments are necessary.
REM *
REM * Valid commandline sytax is:
REM *
REM *  process_classes [intputfile] [NOLOAD]
REM *
REM * inputfile - Name of an alternate input file to process. Must be first argument.
REM *             (Must not be one of the destiny_ archive files. They are renamed during this process).
REM * NOLOAD    - Perform all preprocessing but don't load into Destiny
REM *
REM * 08/30/2007 - Created by Don Lazov @ Follett Software dlazov@fsc.follett.com
REM * 11/15/2007 - Added new expansion variables
REM * 01/18/2008 - Added command line parameter to account for new development parameter for UpdateClasses.exe
REM *                      updateclasses <properties.file> <file2load>
REM * 02/27/2008 - Added the missing UPDATE variable.
REM * 10/02/2008 - Tested and updated for Destiny 8.5 rc8, changed file version
REM * 10/14/2008 - Added the /Y to the copy command to supress the warning and overwrite the file anyway.
REM * 10/26/2009 - AB (Development) - Modified the batch file to allow for environment 
REM *                      settings instead of passing in the variables.
REM * 07/14/2011 - BB (TS) - Adjusted / created batches for HOSTED / CONSORTIUM remote upload customers:
REM *               -Set OPTIONAL VARIABLES for the data files (CSV and XML) to use the classdata folder.
REM *               -Set OPTIONAL VARIABLES for the log file to use the automate folder.
REM * 09/02/2013 - BB (TS) - Added variables for easily setting the removeExistingSections to No
REM * 			     and the default dates if needed
REM * 
REM ********************************************************************************


REM ********************************************************************************
REM * CUSTOMER-SPECIFIC CONFIGURATION: SET DEFAULT GLOBAL VALUES
REM *
REM * Set the following expansion varablies as needed 
REM * (can be remote if this job is run as a user with rights to the remote server)
REM *
REM ********************************************************************************
REM REQUIRED VARIABLES
IF "%SOURCEDIR%"=="" SET SOURCEDIR=E:\Follett\FSC-Patron
IF "%SOURCEFILE%"=="" SET SOURCEFILE=classes.csv

REM OPTIONAL VARIABLES USING DEFAULT VAULES
IF "%SOURCEFULLFILE%"=="" SET SOURCEFULLFILE=%SOURCEDIR%\%SOURCEFILE%
IF "%LOGFILE%"=="" SET LOGFILE=.\automate\process_classes.log
IF "%FINAL%"=="" SET FINAL=.\classdata\destiny_classes_final.xml
IF "%TEMPCSVFILE%"=="" SET TEMPCSVFILE=.\classdata\destiny_classes_temp.csv
IF "%PROP%"=="" SET PROP=classimport.properties
IF "%SORTED%"=="" SET SORTED=.\classdata\destiny_classes_sorted.csv
IF "%UPDATE%"=="" SET UPDATE=update_classes.properties

REM OPTIONAL VARIABLES FOR UPLOADING THE XML FILE TO DESTINY
REM   To tell Destiny to keep existing sections ("no, don't remove them")
REM   remove the REM comment marker at the beginning of the following line.
REM IF "%REMOVEEXISTINGSECTIONS%"=="" SET REMOVEEXISTINGSECTIONS=no

REM   To provide default start and end dates for the incoming sections
REM   remove the REM comment marker at the beginning of the following two lines.
REM	****DATES MUST BE ENTERED IN mm/dd/yyyy FORMAT****
REM IF "%STARTDATE%"=="" SET STARTDATE=
REM IF "%ENDDATE%"=="" SET ENDDATE=


REM ********************************************************************************
REM * START THE LOG FILE
REM ********************************************************************************
cd ..
echo Class data process beginning %date% %time%   >%LOGFILE%


REM ********************************************************************************
REM * OBTAIN NEW CLASS DATA FILE
REM ********************************************************************************
if not exist %SOURCEFULLFILE% goto :nodata
echo Copying class data file from %SOURCEFULLFILE% to %TEMPCSVFILE%   >>%LOGFILE%
copy /Y %SOURCEFULLFILE% %TEMPCSVFILE%   >>%LOGFILE%
SET RAWFILE=%TEMPCSVFILE%


REM ********************************************************************************
REM * KEEP 7 ARCHIVED GENERATIONS OF SOURCE DATA
REM ********************************************************************************
echo Saving %RAWFILE% to %RAWFILE%.001   >>%LOGFILE%
if exist %RAWFILE%.007  del %RAWFILE%.007
if exist %RAWFILE%.006  copy /Y %RAWFILE%.006  %RAWFILE%.007
if exist %RAWFILE%.005  copy /Y %RAWFILE%.005  %RAWFILE%.006
if exist %RAWFILE%.004  copy /Y %RAWFILE%.004  %RAWFILE%.005
if exist %RAWFILE%.003  copy /Y %RAWFILE%.003  %RAWFILE%.004
if exist %RAWFILE%.002  copy /Y %RAWFILE%.002  %RAWFILE%.003
if exist %RAWFILE%.001  copy /Y %RAWFILE%.001  %RAWFILE%.002
if exist %RAWFILE%  copy /Y %RAWFILE% %RAWFILE%.001   >>%LOGFILE%


REM ********************************************************************************
REM * SORT AND CONVERT THEM
REM ********************************************************************************
if exist %SORTED%  del %SORTED%
if exist %FINAL%   del %FINAL%
echo Transforming and Sorting from %RAWFILE% to %SORTED%  >>%LOGFILE%
ClassImportConverter %RAWFILE% %SORTED% /s     >>%LOGFILE%
ClassImportConverter %SORTED% %FINAL% %PROP%     >>%LOGFILE%

if not exist %FINAL% echo ERROR: %FINAL% was not created    >>%LOGFILE%
if not exist %FINAL% GOTO :end
echo Class data transformed to %FINAL%   >>%LOGFILE%


REM ********************************************************************************
REM * LOAD THE XML DATA TO DESTINY
REM ********************************************************************************
call updateclasses.exe %UPDATE% %FINAL% CONTEXT %REMOVEEXISTINGSECTIONS% %STARTDATE% %ENDDATE% >>%LOGFILE%
echo Class XML upload submitted   >>%LOGFILE%


:AFTER_LOAD
REM ********************************************************************************
REM Keep 7 archived generations of final files
REM ********************************************************************************
echo Saving %FINAL% to %FINAL%.001   >>%LOGFILE%
if exist %FINAL%.007  del %FINAL%.007
if exist %FINAL%.006  copy /Y %FINAL%.006  %FINAL%.007
if exist %FINAL%.005  copy /Y %FINAL%.005  %FINAL%.006
if exist %FINAL%.004  copy /Y %FINAL%.004  %FINAL%.005
if exist %FINAL%.003  copy /Y %FINAL%.003  %FINAL%.004
if exist %FINAL%.002  copy /Y %FINAL%.002  %FINAL%.003
if exist %FINAL%.001  copy /Y %FINAL%.001  %FINAL%.002
if exist %FINAL%  copy /Y %FINAL% %FINAL%.001   >>%LOGFILE%


goto :end


:nodata
REM ********************************************************************************
REM * NO PATRON DATA FOUND
REM ********************************************************************************
echo ERROR - No Class data found in %SOURCEFULLFILE%   >>%LOGFILE%
goto :end


:end
echo Class data process ended %date% %time%   >>%LOGFILE%

endlocal
REM EoF
