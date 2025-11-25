@echo off

SET mypath=%~dp0
SET mypath=%mypath:~0,-1%

cd %mypath%

sc query state= all | findstr /C:": FirebirdServerDefaultInstance"
if not %ERRORLEVEL% == 1 (
  Echo Servico do firebird encontrado... Instalando com Multi-Versoes

  if exist "C:\Program Files\Firebird\Firebird_3_0\firebird.exe" (
    Echo Firebird 3 ja instalado
    Echo -------------------------------------------------------------------------------------
    Echo Veja agora a calculadora de configuracao do Firebird, e preencha de acordo com as especificacoes do Servidor!
    Echo Duvidas sobre configuracao contatar Osmar.Junior ou Thiago.ittner
    Pause
    start https://cc.ib-aid.com/democalc.html
    goto :eof
  )

  Echo Parando servico antigo...

  net stop FirebirdServerDefaultInstance
  
  Firebird-3.0.10.33601_0_x64.exe /TASKS="UseClassicServerTask,UseServiceTask,AutoStartTask,CopyFbClientToSysTask" /SYSDBAPASSWORD="masterkey" /SILENT
  
  copy 3051\firebird.conf "C:\Program Files\Firebird\Firebird_3_0"
  copy tbudf.dll "C:\Program Files\Firebird\Firebird_3_0\UDF"
  cd "C:\Program Files\Firebird\Firebird_3_0"
  instsvc install -a -name firebird3
  instsvc start -name firebird3
  sc config FirebirdServerfirebird3 start=delayed-auto
  
  Echo Iniciando servico antigo...
  net start FirebirdServerDefaultInstance
) else (
  Echo Nenhum servico do firebird encontrado... Fazendo instalacao Padrao

  Firebird-3.0.10.33601_0_x64.exe /TASKS="UseClassicServerTask,UseServiceTask,AutoStartTask,CopyFbClientToSysTask" /SYSDBAPASSWORD="masterkey" /SILENT
  copy 3051\firebird.conf "C:\Program Files\Firebird\Firebird_3_0"
  copy tbudf.dll "C:\Program Files\Firebird\Firebird_3_0\UDF"
  cd "C:\Program Files\Firebird\Firebird_3_0"
  instsvc install -a -name firebird3
  instsvc start -name firebird3
  sc config FirebirdServerfirebird3 start=delayed-auto
) 
Echo -------------------------------------------------------------------------------------
Echo Veja agora a calculadora de configuracao do Firebird, e preencha de acordo com as especificacoes do Servidor!
Echo Duvidas sobre configuracao contatar Osmar.Junior ou Thiago.ittner
Pause
start https://cc.ib-aid.com/democalc.html