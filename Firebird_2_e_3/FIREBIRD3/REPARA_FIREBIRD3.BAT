@echo off
set PATH=%PATH%;"C:\Program Files\Firebird\Firebird_3_0"

GFIX -user sysdba -password masterkey -h 0 %1
GFIX -user sysdba -password masterkey -v -full %1
pause
echo Recuperando banco de dados...
GFIX -user sysdba -password masterkey -mend -ig %1

pause
echo Backup do banco para backup.bkp

gbak -v -t -NOD -user sysdba -password masterkey %1 backup.bkp

echo Restaurando o Banco
pause

gbak -rep -c -v -user sysdba -password masterkey -FIX_FSS_METADATA utf8 -FIX_FSS_DATA utf8 -P 8192 backup.bkp %1
GFIX -user sysdba -password masterkey -h 20000 %1

pause
echo Terminado
√‹