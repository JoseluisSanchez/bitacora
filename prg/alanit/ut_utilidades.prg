//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"

/*_____________________________________________________________________________*/

function UtConfigApp( lFromInit, nOption )
   local oDlg
   local oFld
   local aSay := Array(9)
   local aGet := Array(13)
   local aBtn := Array(9)
	local oRadio
	default nOption := 1

   if ModalSobreFsdi()
      return nil
   end if

   DEFINE DIALOG oDlg ;
      OF oApp():oWndMain ;
      RESOURCE "UT_CONFIGAPP" ;
      TITLE i18n( "Configuración del programa" )
   oDlg:SetFont(oApp():oFont)

   REDEFINE FOLDER oFld ;
      ID 100 ;
      OF oDlg ;
      ITEMS i18n("&Directorios"), i18n("&Valores por defecto"), i18n("&Azeta") ; //, i18n("&Icono");
      DIALOGS "UT_CONFIGAPP_A", "UT_CONFIGAPP_B", "UT_CONFIGAPP_C"; // , "UT_CONFIGAPP_D" ;
		OPTION nOption

   // 1º folder: directorios

   REDEFINE say aSay[1] ID 200 OF oFld:aDialogs[1]
   REDEFINE say aSay[2] ID 201 OF oFld:aDialogs[1]
   REDEFINE say aSay[3] ID 202 OF oFld:aDialogs[1]
   REDEFINE say aSay[4] ID 203 OF oFld:aDialogs[1]
   REDEFINE say aSay[5] ID 204 OF oFld:aDialogs[1]
   REDEFINE say aSay[6] ID 205 OF oFld:aDialogs[1]

   REDEFINE get aGet[1] ;
      var oApp():cDbfPath ;
      ID 100 ;
      OF oFld:aDialogs[1] ;
      picture "@!" ;
      valid if( lIsDir( Lower( oApp():cDbfPath ) ), .T.,;
      ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
      aGet[1]:setFocus(), .F. ) )

   REDEFINE BUTTON aBtn[01];
      ID 103;
      OF oFld:aDialogs[1];
      ACTION ( GetDir( aGet[1] ) )

   aBtn[01]:cToolTip := i18n( "selecc. directorio" )

   REDEFINE get aGet[2] ;
      var oApp():cBtcPath ;
      ID 101 ;
      OF oFld:aDialogs[1] ;
      picture "@!" ;
      valid if( lIsDir( Lower( oApp():cBtcPath ) ), .T.,;
      ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
      aGet[2]:setFocus(), .F. ) )

   REDEFINE BUTTON aBtn[02];
      ID 104;
      OF oFld:aDialogs[1];
      ACTION ( GetDir( aGet[2] ) )

   aBtn[02]:cToolTip := i18n( "selecc. directorio" )

   REDEFINE get aGet[3] ;
      var oApp():cZipPath ;
      ID 102 ;
      OF oFld:aDialogs[1] ;
      picture "@!" ;
      valid if( lIsDir( Lower( oApp():cZipPath ) ), .T.,;
      ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
      aGet[3]:setFocus(), .F. ) )

   REDEFINE BUTTON aBtn[03];
      ID 105;
      OF oFld:aDialogs[1];
      ACTION ( GetDir( aGet[3] ) )

   aBtn[03]:cToolTip := i18n( "selecc. directorio" )

   REDEFINE get aGet[4] ;
      var oApp():cXmlPath ;
      ID 106 ;
      OF oFld:aDialogs[1] ;
      picture "@!" ;
      valid if( lIsDir( Lower( oApp():cXmlPath ) ), .T.,;
      ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
      aGet[4]:setFocus(), .F. ) )

   REDEFINE BUTTON aBtn[04];
      ID 107;
      OF oFld:aDialogs[1];
      ACTION ( GetDir( aGet[4] ) )

   aBtn[04]:cToolTip := i18n( "selecc. directorio" )

   REDEFINE get aGet[5] ;
      var oApp():cPdfPath ;
      ID 108 ;
      OF oFld:aDialogs[1] ;
      picture "@!" ;
      valid if( lIsDir( Lower( oApp():cPdfPath ) ), .T.,;
      ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
      aGet[5]:setFocus(), .F. ) )

   REDEFINE BUTTON aBtn[05];
      ID 109;
      OF oFld:aDialogs[1];
      ACTION ( GetDir( aGet[5] ) )

   aBtn[05]:cToolTip := i18n( "selecc. directorio" )

   REDEFINE get aGet[6] ;
      var oApp():cXlsPath ;
      ID 110 ;
      OF oFld:aDialogs[1] ;
      picture "@!" ;
      valid if( lIsDir( Lower( oApp():cXlsPath ) ), .T.,;
      ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
      aGet[6]:setFocus(), .F. ) )

   REDEFINE BUTTON aBtn[06];
      ID 111;
      OF oFld:aDialogs[1];
      ACTION ( GetDir( aGet[6] ) )

   aBtn[06]:cToolTip := i18n( "selecc. directorio" )
   // 2º folder: valores por defecto

   REDEFINE CHECKBOX aGet[7] var oApp():lCodOblig ID 101 OF oFld:aDialogs[2] ;
      on CHANGE iif(!oApp():lCodOblig, (oApp():lCodAut:=.F.,aGet[8]:refresh()),)

   REDEFINE CHECKBOX aGet[8] var oApp():lCodAut ID 100 OF oFld:aDialogs[2] when oApp():lCodOblig

   REDEFINE CHECKBOX aGet[9] var oApp():lCodZero ID 102 OF oFld:aDialogs[2]

   REDEFINE CHECKBOX aGet[10] var oApp():lCodReord ID 103 OF oFld:aDialogs[2]

   // 3er folder: azeta

   REDEFINE say aSay[7] ID 200 OF oFld:aDialogs[3]

   REDEFINE get aGet[11] ;
      var oApp():cAztPath ;
      ID 100 ;
      OF oFld:aDialogs[3] ;
      picture "@!" ;
      valid if( lIsDir( Lower( oApp():cAztPath ) ), .T.,;
      ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
      aGet[11]:setFocus(), .F. ) )
      
   REDEFINE BUTTON aBtn[07];
      ID 101;
      OF oFld:aDialogs[3];
      ACTION ( GetDir( aGet[11] ) )
      
   REDEFINE say aSay[8] ID 201 OF oFld:aDialogs[3]
    
      REDEFINE get aGet[12] ;
          var oApp():cAztZipPath ;
          ID 102 ;
          OF oFld:aDialogs[3] ;
          picture "@!" ;
          valid if( lIsDir( Lower( oApp():cAztZipPath ) ), .T.,;
          ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
          aGet[12]:setFocus(), .F. ) )
   
   REDEFINE BUTTON aBtn[08];
         ID 103;
         OF oFld:aDialogs[3];
         ACTION ( GetDir( aGet[12] ) )
   
REDEFINE say aSay[9] ID 202 OF oFld:aDialogs[3]
 
   REDEFINE get aGet[13] ;
       var oApp():cAztPdfPath ;
       ID 104 ;
       OF oFld:aDialogs[3] ;
       picture "@!" ;
       valid if( lIsDir( Lower( oApp():cAztPdfPath ) ), .T.,;
       ( msgStop( i18n("La ruta indicada no existe. Por favor, introduzca una correcta.") ),;
       aGet[13]:setFocus(), .F. ) )

REDEFINE BUTTON aBtn[09];
      ID 105;
      OF oFld:aDialogs[3];
      ACTION ( GetDir( aGet[13] ) )



   // 4o folder: icono
	// REDEFINE RADIO oRadio VAR oApp():nIcon ID 101, 102 OF oFld:aDialogs[4]
	// REDEFINE ICON ID 201 NAME "BTC" OF oFld:aDialogs[4]
	// REDEFINE ICON ID 202 NAME "AZT" OF oFld:aDialogs[4]

   // diálogo principal

   REDEFINE BUTTON   ;
      ID    IDOK     ;
      OF    oDlg     ;
      ACTION   ( if( Eval( aGet[1]:bValid ) .AND.;
      Eval( aGet[2]:bValid ) .AND.;
      Eval( aGet[3]:bValid ) .AND.;
      Eval( aGet[4]:bValid ) .AND.;
      Eval( aGet[5]:bValid ) .AND.;
      Eval( aGet[6]:bValid ), oDlg:end( IDOK ), ) )

   REDEFINE BUTTON   ;
      ID    IDCANCEL ;
      OF    oDlg     ;
      CANCEL         ;
      ACTION   ( oDlg:end( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init oDlg:Center( oApp():oWndMain )

   if oDlg:nResult == IDOK
      oApp():cDbfPath := AllTrim( oApp():cDbfPath )
      oApp():cBtcPath := AllTrim( oApp():cBtcPath )
      oApp():cZipPath := AllTrim( oApp():cZipPath )
      SetIni( , "Config", "Dbf", oApp():cDbfPath )
      SetIni( , "Config", "Btc", oApp():cBtcPath )
      SetIni( , "Config", "Zip", oApp():cZipPath )
      SetIni( , "Config", "Xml", oApp():cXmlPath )
      SetIni( , "Config", "Pdf", oApp():cPdfPath )
      SetIni( , "Config", "Xls", oApp():cXlsPath )
      SetIni( , "Config", "Azt", oApp():cAztPath )
      SetIni( , "Config", "AztZip", oApp():cAztZipPath )
      SetIni( , "Config", "AztPdf", oApp():cAztPdfPath )
      SetIni( , "Config", "CodOblig", oApp():lCodOblig )
      SetIni( , "Config", "CodAut", oApp():lCodAut )
      SetIni( , "Config", "CodZero", oApp():lCodZero )
      SetIni( , "Config", "CodReord", oApp():lCodReord )
		SetIni( , "Config", "nIcon", oApp():nIcon )
   else
      if lFromInit
         msgStop( i18n("El programa no podrá continuar mientras no corrija las rutas a los archivos del programa.") )
         oApp():ExitFromSource()
      end if
   end if

return nil

/*_____________________________________________________________________________*/
/*
function UtPtsToEuro()

   local oDlg
   local oMeter
   local aSay
   local oBmp
   local nVar   := 0

   aSay := array(2)

   if ModalSobreFsdi()
      return NIL
   end if

   if ! msgYesNo( i18n( "A continuación se convertirán los precios de compra de libros, discos, vídeos, software y colecciones de pesetas a euros, dividiendo los actuales valores por 166,386. ¿Desea continuar?" ) )
      return NIL
   end if

   DEFINE DIALOG oDlg OF oApp():oWndMain RESOURCE "UT_INDEXAR";
         TITLE oApp():cAppName

   REDEFINE BITMAP oBmp ID 111 OF oDlg RESOURCE "BB_INDEX" TRANSPARENT

   REDEFINE SAY aSay[01] ID  99 OF oDlg PROMPT i18n( "Convirtiendo precios a euros..." )
   REDEFINE SAY aSay[02] ID 100 OF oDlg PROMPT ""

   oMeter := TProgress():Redefine( 101, oDlg )

   oDlg:bStart := { || SysRefresh(), UtPts2Euro( oMeter, nVar ), oDlg:End() }

   ACTIVATE DIALOG oDlg CENTERED

return NIL
*/

function UtPtsToEuro()

   local oDlg
   local oTexto
   local cTexto
   local oMeter
   local aSay
   local oBmp
   local nVar

   if ModalSobreFsdi()
      return nil
   end if

   aSay := Array(2)
   nVar := 0

   cTexto := i18n("Al convertir todos sus importes de pesetas a Euros " + ;
      "se dividirán dichos importes entre 166,386. Esto se " + ;
      "refiere a los campos de precios de compra de todas sus " + ;
      "colecciones: libros, discos, vídeos, software..." + ;
      +CRLF+CRLF+ ;
      "Tenga en cuenta que esta operación es irreversible y " + ;
      "por tanto debe ser consciente de que todos los importes " + ;
      "utilizados en el programa actualmente están expresados " + ;
      "en Pesetas.")

   DEFINE DIALOG oDlg;
      OF oApp():oWndMain;
      NAME 'ut_euros';
      TITLE i18n("Convertir importes a Euros")
   oDlg:SetFont(oApp():oFont)

   REDEFINE get oTexto;
      var cTexto;
      OF oDlg ID 100;
      color CLR_BLUE, CLR_WHITE;
      MEMO;
      READONLY

   REDEFINE BUTTON;
      ID IDOK OF oDlg;
      ACTION ( oDlg:End( IDOK ) )

   REDEFINE BUTTON;
      ID IDCANCEL OF oDlg;
      CANCEL;
      ACTION ( oDlg:End( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter( oDlg, oApp():oWndMain )

   if oDlg:nResult == IDOK

      DEFINE DIALOG oDlg;
         OF oApp():oWndMain;
         RESOURCE 'ut_indexar';
         TITLE oApp():cAppName
      oDlg:SetFont(oApp():oFont)

      REDEFINE BITMAP oBmp;
         ID 111 OF oDlg;
         RESOURCE 'bb_index';
         TRANSPARENT

      REDEFINE say aSay[01];
         ID 99 OF oDlg;
         prompt i18n("Convirtiendo importes a euros...")

      REDEFINE say aSay[02];
         ID 100 OF oDlg;
         prompt ""

      oMeter := TProgress():Redefine( 101, oDlg )

      oDlg:bStart := {|| SysRefresh(), UtPtsToEuro2( oMeter, nVar ), oDlg:End() }

      ACTIVATE DIALOG oDlg CENTERED

   end if

return nil

/*_____________________________________________________________________________*/

function UtPtsToEuro2( oMeter, nVar )

   local aFile  := { "Libros", "Musica", "Videos", "Software", "CoLibros" }
   local aAlias := { "LI", "MU", "VI", "SO", "CL"       }
   local aField := { "LiPrecio", "MuPrecio", "ViPrecio", "SoPrecio", "ClPrecio" }
   local cFile  := ""
   local cAlias := ""
   local cField := ""
   local i      := 0

   CursorWait()

   for i := 1 to Len( aFile )

      cFile  := aFile[i]
      cAlias := aAlias[i]
      cField := aField[i]

      if ! Db_OpenNoIndex( cFile, cAlias )
         return nil
      end if
      oMeter:setRange( 0, ( cAlias )->( LastRec() ) )
      oMeter:SetPos( 0 )
      while ! ( cAlias )->( Eof() )
         if ( cAlias )->&cField > 0
            replace ( cAlias )->&cField with ( cAlias )->&cField / 166.386
            ( cAlias )->( dbCommit() )
         end if
         ( cAlias )->( dbSkip() )
         oMeter:SetPos( nVar++ )
         SysRefresh()
      end while
      dbCloseAll()

   next

   CursorArrow()

   msgInfo( i18n( "La conversión de importes a Euros se realizó correctamente." ) )

   Ut_Indexar(.F.)

return nil

/*_____________________________________________________________________________*/

function UtReordenarCodigos()

   local oDlg
   local oTexto
   local cTexto
   local oMeter
   local aSay
   local oBmp
   local nCod

   if ModalSobreFsdi()
      return nil
   end if

   aSay := Array(2)
   nCod := 0

   cTexto := i18n("Al reordenar los códigos de sus ejemplares conseguirá, " + ;
      "de forma automática, que todos los ejemplares de cada " + ;
      "colección tengan códigos únicos: 0000000001, " + ;
      "0000000002, 0000000003..." + ;
      +CRLF+CRLF+ ;
      "Esta herramienta es útil para los usuarios que nunca " + ;
      "se han preocupado de asignar códigos únicos a sus " + ;
      "ejemplares cuando no era obligatorio hacerlo en " + ;
      "Cuaderno de Bitácora." +CRLF+ ;
      "Tenga en cuenta que este proceso es irreversible.")

   DEFINE DIALOG oDlg;
      OF oApp():oWndMain;
      NAME 'ut_codigos';
      TITLE i18n("Reordenar códigos de ejemplares")
   oDlg:SetFont(oApp():oFont)

   REDEFINE get oTexto;
      var cTexto;
      OF oDlg ID 100;
      color CLR_RED, CLR_WHITE;
      MEMO;
      READONLY

   REDEFINE BUTTON;
      ID IDOK OF oDlg;
      ACTION ( oDlg:End( iif(MsgYesNo("Esta operación es irreversible."+CRLF+"¿Está seguro de realizar la reordenación de códigos?"), IDOK, IDCANCEL )))

   REDEFINE BUTTON;
      ID IDCANCEL OF oDlg;
      CANCEL;
      ACTION ( oDlg:End( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter( oDlg, oApp():oWndMain )

   if oDlg:nResult == IDOK

      DEFINE DIALOG oDlg;
         OF oApp():oWndMain;
         RESOURCE 'ut_indexar_'+oApp():cLanguage;
         TITLE oApp():cAppName
      oDlg:SetFont(oApp():oFont)

      REDEFINE BITMAP oBmp;
         ID 111 OF oDlg;
         RESOURCE 'BB_U_REORDER' ; //'bb_index';
      TRANSPARENT

      REDEFINE say aSay[01];
         ID 99 OF oDlg;
         prompt i18n("Reordenando códigos...")

      REDEFINE say aSay[02];
         ID 10 OF oDlg;
         prompt ""

      oMeter := TProgress():Redefine( 101, oDlg )

      oDlg:bStart := {|| SysRefresh(), UtReordenarCodigos2( aSay[02], oMeter, nCod ), oDlg:End() }

      ACTIVATE DIALOG oDlg CENTERED

   end if

return nil

/*_____________________________________________________________________________*/

function UtReordenarCodigos2( oSay, oMeter, nCod )

   local nMeter := 0

   if ! Db_OpenAll()
      return nil
   end if

   CursorWait()

   oMeter:setRange( 0, 4 )

   oSay:setText( i18n("Libros") )
   nCod   := 0
   LI->( ordSetFocus( 0 ) )
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      replace LI->LiCodigo with StrZero( ++nCod, 10 )
      LI->( dbSkip() )
   end while
   oMeter:SetPos( 1 )

   oSay:setText( i18n("Discos") )
   nCod   := 0
   MU->( ordSetFocus( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      nCod += 1
      CD->(dbGoTop())
      while CD->(dbSeek(MU->MuCodigo))
         replace CD->CdMuCodigo with StrZero( nCod, 10 )
      end while
      replace MU->MuCodigo with StrZero( nCod, 10 )
      MU->( dbSkip() )
   end while
   oMeter:SetPos( 2 )

   oSay:setText( i18n("Software") )
   nCod   := 0
   SO->( ordSetFocus( 0 ) )
   SO->( dbGoTop() )
   while ! SO->( Eof() )
      replace SO->SoCodigo with StrZero( ++nCod, 10 )
      SO->( dbSkip() )
   end while
   oMeter:SetPos( 3 )

   oSay:setText( i18n("Direcciones de Internet") )
   nCod   := 0
   VI->( ordSetFocus( 0 ) )
   VI->( dbGoTop() )
   while ! VI->( Eof() )
      replace VI->ViNumero with StrZero( ++nCod, 10 )
      VI->( dbSkip() )
   end while
   oMeter:SetPos( 4 )

   dbCloseAll()

   CursorArrow()

   msgInfo( i18n( "Códigos reordenados con éxito." ) )

   Ut_Actualizar(.F.)
   Ut_Indexar(.F.)

return nil

/*_____________________________________________________________________________*/

function UtImportarVersion()

   local oDlg
   local oTexto
   local oGet
   local oBtn
   local cTexto
   local cDir
   local oBmp
   local aSay
   local oMeter

   if ModalSobreFsdi()
      return nil
   end if

   aSay := Array(2)

   cTexto := i18n("Para incorporar los datos de su Cuaderno de " + ;
      "Bitácora antiguo seleccione el directorio donde " + ;
      "se encuentran dichos datos. Para versiones " + ;
      "anteriores a la 6.00 este directorio es el " + ;
      "mismo en el que está instalado el programa." + ;
      +CRLF+CRLF+ ;
      "Los datos que tenga introducidos en la versión " + ;
      "actual serán reemplazados por los que va a " + ;
      "incorporar.")

   DEFINE DIALOG oDlg;
      OF oApp():oWndMain;
      NAME 'ut_importar_version';
      TITLE i18n("Importar datos de versión antigua")
   oDlg:SetFont(oApp():oFont)

   REDEFINE get oTexto;
      var cTexto;
      OF oDlg ID 100;
      color CLR_BLUE, CLR_WHITE;
      MEMO;
      READONLY

   REDEFINE get oGet;
      var cDir;
      OF oDlg ID 101;
      UPDATE

   REDEFINE BUTTON oBtn;
      ID 102 OF oDlg;
      ACTION GetDir( oGet )

   oBtn:cTooltip := i18n("seleccionar directorio")

   REDEFINE BUTTON;
      ID IDOK OF oDlg;
      ACTION ( iif( ValEmpty( cDir, oGet ), oDlg:End( IDOK ), ) )

   REDEFINE BUTTON;
      ID IDCANCEL OF oDlg;
      CANCEL;
      ACTION ( oDlg:End( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter( oDlg, oApp():oWndMain )

   if oDlg:nResult == IDOK

      DEFINE DIALOG oDlg;
         OF oApp():oDlg;
         RESOURCE 'ut_indexar';
         TITLE oApp():cAppName
      oDlg:SetFont(oApp():oFont)

      REDEFINE BITMAP oBmp;
         ID 111 OF oDlg;
         RESOURCE 'app';
         TRANSPARENT

      REDEFINE say aSay[01];
         ID 99 OF oDlg;
         prompt i18n("Importando ficheros...")

      REDEFINE say aSay[02];
         ID 100 OF oDlg;
         prompt ""

      oMeter := TProgress():Redefine( 101, oDlg )

      oDlg:bStart := {|| SysRefresh(), UtImportarVersion2( oMeter, cDir, aSay[02] ), oDlg:End() }

      ACTIVATE DIALOG oDlg ;
         on init oDlg:Center( oApp():oWndMain )

   end if

return nil

/*_____________________________________________________________________________*/

function UtImportarVersion2( oMeter, cDir, oSay )

   local i      := 0
   local nFiles := 0
   local aFiles := {}
   local cFile  := ""
   local cFrom  := ""

   // comprobación previa de que la ruta sea correcta
   aFiles := Directory( cDir + "\*.dbf" )
   nFiles := Len( aFiles )
   if nFiles == 0
      msgStop( i18n("El directorio indicado no contiene datos del programa.") )
      return nil
   end if

   oMeter:setRange( 0, 4 )

   aFiles := Directory( oApp():cDbfPath + "*.*" )
   nFiles := Len( aFiles )
   oSay:setText( i18n("borrando ficheros actuales") )
   for i := 1 to nFiles
      delete File ( oApp():cDbfPath + aFiles[i,1] )
   next
   oMeter:SetPos( 1 )

   aFiles := Directory( cDir + "\*.dbf" )
   nFiles := Len( aFiles )
   for i := 1 to nFiles
      cFile := aFiles[i,1]
      oSay:setText( cFile )
      cFrom := cDir + "\" + cFile
      cFile := oApp():cDbfPath + cFile
      copy File ( cFrom ) TO ( cFile )
   next
   oMeter:SetPos( 2 )

   aFiles := Directory( cDir + "\*.dbt" )
   nFiles := Len( aFiles )
   for i := 1 to nFiles
      cFile := aFiles[i,1]
      oSay:setText( cFile )
      cFrom := cDir + "\" + cFile
      cFile := oApp():cDbfPath + cFile
      copy File ( cFrom ) TO ( cFile )
   next
   oMeter:SetPos( 3 )

   // hará falta en las siguientes a la 6.0 por si se importan desde la 6.0, que usa cdx
   aFiles := Directory( cDir + "\*.fpt" )
   nFiles := Len( aFiles )
   for i := 1 to nFiles
      cFile := aFiles[i,1]
      oSay:setText( cFile )
      cFrom := cDir + "\" + cFile
      cFile := oApp():cDbfPath + cFile
      copy File ( cFrom ) TO ( cFile )
   next
   oMeter:SetPos( 4 )

   msgInfo( i18n("La importación se realizó correctamente.") )

   Ut_Actualizar(.F.)
   Ut_Indexar(.F.)

return nil
