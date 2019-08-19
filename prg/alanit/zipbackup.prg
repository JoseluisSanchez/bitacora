#include "FiveWin.ch"
#include "xBrowse.ch"

function ZipBackup(cPath, cZip)

   // local cPath    := oApp():cDbfPath
   local aDir     := Directory(cPath+"*.*" )
   local aFiles   := {}
   local aToZip   := {}
   local aFooter  := { 0, 0, "" }
   local cZipFile := cZip+DToS(Date())+".ZIP" + Space( 20 )
   local aGet[3]
   local i
   local oDlg, oLbx, oCol
   local oDlgPro, oSay01, oSay02, oProgress, oBmp

   if oApp():oDlg != nil
      if oApp():nEdit > 0
         msgStop( i18n("No puede hacer copias de seguridad hasta que no cierre las ventanas abiertas sobre el mantenimiento que está manejando.") )
         retu nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   for i := 1 to Len( aDir )
      AAdd( aFiles, {aDir[i,1],aDir[i,2],aDir[i,3]})
      AAdd( aToZip, cPath+aDir[i,1] )
      aFooter[1] := aFooter[1] + 1
      aFooter[2] := aFooter[2] + aDir[i,2]
   next
   aFiles   := ASort(aFiles,,,{|x,y| Upper(x[1]) < Upper(y[1])})

   DEFINE DIALOG oDlg OF oApp():oWndMain RESOURCE "ZipBackup_"+oApp():cLanguage  ;
      TITLE oApp():cAppName+oApp():cVersion + " - hacer copia de seguridad"
   oDlg:SetFont(oApp():oFont)

   REDEFINE say ID 100 OF oDlg

   REDEFINE get aGet[1] var cPath   ;
      ID 101 OF oDlg                ;
      color CLR_BLACK, CLR_WHITE    ;
      when .F.

   oLbx := TXBrowse():New( oDlg )
   oLbx:SetArray(aFiles)
   Ut_BrwRowConfig( oLbx )
   oLbx:nDataType     := 1 // array

   oLbx:aCols[1]:cHeader  := i18n("Fichero")
   oLbx:aCols[1]:nWidth   := 100

   oLbx:aCols[2]:cHeader  := i18n("Tamaño")
   oLbx:aCols[2]:nWidth   := 100
   oLbx:aCols[2]:nDataStrAlign := 1
   oLbx:aCols[2]:nHeadStrAlign := 1
   //oLbx:aCols[2]:bStrData := {|| TRAN(aFiles[ oLbx:nAt,2 ]/1000,"@E 999,999,999 ")+" KB" }

   oLbx:aCols[3]:cHeader  := i18n("Fecha modificación")
   oLbx:aCols[3]:nWidth   := 100
   oLbx:aCols[3]:nDataStrAlign := 1
   oLbx:aCols[3]:nHeadStrAlign := 1
   //oLbx:aCols[3]:bStrData := {|| DtoC(aFiles[ oLbx:nAt,3 ]) }

   oLbx:CreateFromResource( 102 )

   REDEFINE say ID 103 OF oDlg

   REDEFINE get aGet[2] var cZipFile   ;
      ID 104 OF oDlg UPDATE            ;
      picture '@!'

   REDEFINE BUTTON aGet[3]             ;
      ID 105 OF oDlg UPDATE            ;
      ACTION SetFileZip(aGet[2])
   aGet[3]:cTOOLTIP  := "seleccionar fichero de destino"

   REDEFINE BUTTON   ;
      ID    IDOK     ;
      OF    oDlg     ;
      ACTION   ( if( File( cZipFile ),;
      if( msgYesNo( i18n( "El fichero de destino especificado ya exite." ) + CRLF + CRLF + ;
      i18n( "¿Desea reemplazarlo?" ) ), oDlg:end( IDOK ), aGet[2]:setFocus() ),;
      oDlg:end( IDOK ) ) )

   REDEFINE BUTTON   ;
      ID    IDCANCEL ;
      OF    oDlg     ;
      CANCEL         ;
      ACTION   ( oDlg:end( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init oDlg:Center( oApp():oWndMain )

   if oDlg:nresult == IDOK
      DEFINE DIALOG oDlgPro RESOURCE 'UT_PROGRESS_'+oApp():cLanguage
      oDlgPro:SetFont(oApp():oFont)
      REDEFINE BITMAP oBmp ID 111 OF oDlgPro RESOURCE "APP" TRANSPARENT
      REDEFINE say oSay01 prompt "Realizando copia de seguridad..." ID 99  OF oDlgPro
      REDEFINE say oSay02 prompt Space(30) ID 100  OF oDlgPro
      oProgress := TProgress():Redefine( 101, oDlgPro )
      oDlgPro:bStart := {|| SysRefresh(), DoMakeZip( oProgress, cZipFile, aToZip, aFooter, oSay02 ), oDlgPro:End() }
      ACTIVATE DIALOG oDlgPro ;
         on init oDlgPro:Center( oApp():oWndMain )
   endif

return nil

function SetFileZip( oGet )

   local cFile

   /*solicita el nombre con la unidad destino incluido*/
   cFile := cGetFile( "ZipFile | *.zip", "Nombre de archivo de copia de seguridad en Disco Duro", 1, oApp():cZipPath, .T., .T. )
   cFile := RTrim( cFile )

   /*agrega la extencion ZIP de ser necesario*/
   if Empty( cFileExt( cFile ) )
      cFile += ".zip"
   endif
   oGet:cText := cFile

return nil

procedure DoMakeZip( oProgress, cZipFile, aToZip, aFooter, oSay )

   local lOkZip      := .F.
   local bOnZipFile  := {|cFile, nFile| ( oProgress:SetPos( nFile ),;
      oSay:SetText(SubStr(cFile,RAt("\",cFile)+1)),;
      SysRefresh() ) }
   local nPos     := 0

   /*establece limites de valores de control meter*/
   oProgress:SetRange( 0, aFooter[1] )
   oProgress:SetPos( 0 )
   /*realiza la compresion de los ficheros*/
   hb_SetDiskZip( {|| NIL } )
   lOkZip := hb_ZipFile( cZipFile,;
      aToZip,;
      9,;
      bOnZipFile,;
      NIL,;
      NIL,;
      NIL        )

   /*verifica proceso e informa al usuario*/
   if lOkZip
      MsgInfo("La creación del fichero de copia de seguridad se realizó correctamente.")
   else
      MsgStop("La creación del fichero de copia de seguridad falló.")
   endif

   hb_gcAll()

return

/*_____________________________________________________________________________*/

function ZipRestore(cPath, cZip)
   // local cPath    := Upper(oApp():cDbfPath)
   local aDir     := {}
   local aFiles   := Array(1,3)
   local aToUnZip := {}
   local aFooter  := { 0, 0, "" }
   local cZipFile := ""
   local aGet[4]
   local i
   local oDlg, oLbx, oCol
   local oDlgPro, oSay01, oSay02, oProgress, oBmp

   if oApp():oDlg != nil
      if oApp():nEdit > 0
         msgStop( i18n("No puede restaurar copias de seguridad hasta que no cierre las ventanas abiertas sobre el mantenimiento que está manejando.") )
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif
   if Left(cPath,1) == '.'
      cPath := cFilePath(GetModuleFileName(GetInstance()))+SubStr(cPath,2)
   endif
   for i := 1 to Len( aDir )
      AAdd( aFiles, {aDir[i,1],aDir[i,2],aDir[i,3]})
      AAdd( aToUnzip, cPath+aDir[i,1] )
      aFooter[1] := aFooter[1] + 1
      aFooter[2] := aFooter[2] + aDir[i,2]
   next
   aFiles   := ASort(aFiles,,,{|x,y| Upper(x[1]) < Upper(y[1])})

   DEFINE DIALOG oDlg OF oApp():oWndMain RESOURCE "ZipRestore_"+oApp():cLanguage;
      TITLE oApp():cAppName+oApp():cVersion + " - restaurar copia de seguridad"
   oDlg:SetFont(oApp():oFont)

   REDEFINE say ID 100 OF oDlg

   REDEFINE get aGet[1] var cZipFile;
      ID 101 OF oDlg UPDATE         ;
      picture '@!'
   REDEFINE BUTTON aGet[4]             ;
      ID 105 OF oDlg UPDATE            ;
      ACTION GetFileToUnzip(aGet[1], aFiles, aToUnZip, aFooter, oLbx, cZip)
   aGet[4]:cTOOLTIP  := "seleccionar fichero con la copia de seguridad"

   oLbx := TXBrowse():New( oDlg )
   oLbx:SetArray(aFiles)
   Ut_BrwRowConfig( oLbx )
   oLbx:nDataType     := 1 // array

   oLbx:aCols[1]:cHeader  := i18n("Fichero")
   oLbx:aCols[1]:nWidth   := 100

   oLbx:aCols[2]:cHeader  := i18n("Tamaño")
   oLbx:aCols[2]:nWidth   := 100
   oLbx:aCols[2]:nDataStrAlign := 1
   oLbx:aCols[2]:nHeadStrAlign := 1
   //oLbx:aCols[2]:bStrData := {|| TRAN(aFiles[ oLbx:nAt,2 ]/1000,"@E 999,999,999 ")+" KB" }

   oLbx:aCols[3]:cHeader  := i18n("Fecha modificación")
   oLbx:aCols[3]:nWidth   := 100
   oLbx:aCols[3]:nDataStrAlign := 1
   oLbx:aCols[3]:nHeadStrAlign := 1
   //oLbx:aCols[3]:bStrData := {|| DtoC(aFiles[ oLbx:nAt,3 ]) }

   oLbx:CreateFromResource( 102 )

   REDEFINE say ID 103 OF oDlg

   REDEFINE get aGet[2] var cPath   ;
      ID 104 OF oDlg                ;
      color CLR_BLACK, CLR_WHITE    ;
      when .F.

   REDEFINE BUTTON   ;
      ID    IDOK     ;
      OF    oDlg     ;
      ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON   ;
      ID    IDCANCEL ;
      OF    oDlg     ;
      CANCEL         ;
      ACTION   ( oDlg:end( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init oDlg:Center( oApp():oWndMain )

   if oDlg:nresult == IDOK

      DEFINE DIALOG oDlgPro RESOURCE 'UT_PROGRESS_'+oApp():cLanguage
      oDlgPro:SetFont(oApp():oFont)
      REDEFINE BITMAP oBmp ID 111 OF oDlgPro RESOURCE "APP" TRANSPARENT
      REDEFINE say oSay01 prompt "Restaurando copia de seguridad..." ID 99  OF oDlgPro
      REDEFINE say oSay02 prompt Space(30) ID 100  OF oDlgPro
      oProgress := TProgress():Redefine( 101, oDlgPro )
      oDlgPro:bStart := {|| SysRefresh(), DoMakeUnZip( oProgress, cZipFile, cPath, aFooter, oSay02 ), oDlgPro:End() }
      ACTIVATE DIALOG oDlgPro ;
         on init oDlgPro:Center( oApp():oWndMain )

   endif

return nil

procedure GetFileToUnZip( oGet,aFiles,aToUnZip,aFooter,oLbx,cZip )

   local cFile
   local aDir
   local i

   /*pide al usuario que seleccione el fichero de respaldo*/
   cFile := cGetFile( "ZipFile   | *.zip", "Nombre de archivo de copia de seguridad a restaurar", 1, cZip, .F., .T. )

   /*verifica si realmente se paso el fichero*/
   if ! Empty( cFile )

      /*muestra el nombre del fichero en el dialogo*/
      oGet:cText := cFile

      aDir := hb_GetFilesInZip( cFile, .T. )

      /*vereficia el valor retornado por la funcion, si es arreglo y si tiene elementos*/
      if ValType( aDir ) = "A" .AND. Len( aDir ) > 0
         aFiles   := {}
         aToUnzip := {}
         aFooter  := { 0, 0, ""}
         for i := 1 to Len( aDir )
            AAdd( aFiles, {aDir[i,1],aDir[i,2],aDir[i,6]})
            AAdd( aToUnZip, cFilePath(cFile)+aDir[i,1] )
            aFooter[1] := aFooter[1] + 1
            aFooter[2] := aFooter[2] + aDir[i,2]
         next

         aFiles   := ASort(aFiles,,,{|x,y| Upper(x[1]) < Upper(y[1])})

         /*pasa el arreglo al browse*/

         oLbx:bLine  := {|| { " "+cFileName(aFiles[ oLbx:nAt,1 ]),;
            TRAN(aFiles[ oLbx:nAt,2 ]/1000,"@E 999,999,999 ")+" KB",;
            " "+DToC(aFiles[ oLbx:nAt,3 ]) }}
         //oLbx:aFooters  := { TRAN(aFooter[1],"@E 999 ")+" ficheros",TRAN(aFooter[2]/1000,"@E 999,999,999 ")+" KB", }
         oLbx:SetArray( aFiles )
         oLbx:refresh( .T. )
         hb_gcAll()
      else
         MsgStop(i18n("El fichero no es un fichero ZIP válido o parece estar dañado."))
         return
      endif
   endif

return

procedure DoMakeUnZip( oProgress, cZipFile, cPath, aFooter, oSay )

   local lOkUnZip    := .F.
   local bOnZipFile  := {|cFile, nFile| ( oProgress:SetPos( nFile ),;
      oSay:SetText(SubStr(cFile,RAt("\",cFile)+1)),;
      SysRefresh() ) }
   local nPos     := 0
   local aFiles   := hb_GetFilesInZip( cZipFile )

   /*establece limites de valores de control meter*/
   oProgress:SetRange( 0, aFooter[1] )
   oProgress:SetPos( 0 )
   /*realiza la compresion de los ficheros*/
   hb_SetDiskZip( {|| NIL } )

   lOkUnZip := hb_UnZipFile( cZipFile,;
      bOnZipFile,;
      .F.,;
      NIL,;
      cPath,;
      aFiles  )

   /*verifica proceso e informa al usuario*/
   if lOkUnZip
      MsgInfo("La restauración del fichero de copia de seguridad se realizó correctamente.")
      WritePProString("Browse","ReOrder","1",oApp():cIniFile)
      WritePProString("Browse","ReRecno","0",oApp():cIniFile)
      WritePProString("Browse","PlOrder","1",oApp():cIniFile)
      WritePProString("Browse","PlRecno","0",oApp():cIniFile)
      WritePProString("Browse","VaOrder","1",oApp():cIniFile)
      WritePProString("Browse","VaRecno","0",oApp():cIniFile)
      WritePProString("Browse","AlOrder","1",oApp():cIniFile)
      WritePProString("Browse","AlRecno","0",oApp():cIniFile)
      WritePProString("Browse","PrOrder","1",oApp():cIniFile)
      WritePProString("Browse","PrRecno","0",oApp():cIniFile)
      WritePProString("Browse","GrOrder","1",oApp():cIniFile)
      WritePProString("Browse","GrRecno","0",oApp():cIniFile)
      WritePProString("Browse","AuOrder","1",oApp():cIniFile)
      WritePProString("Browse","AuRecno","0",oApp():cIniFile)
      WritePProString("Browse","PuOrder","1",oApp():cIniFile)
      WritePProString("Browse","PuRecno","0",oApp():cIniFile)
      Ut_Actualizar()
      Ut_Indexar()
   else
      MsgStop("La restauración del fichero de copia de seguridad ha fallado.")
   endif

   hb_gcAll()

return

/*_____________________________________________________________________________*/
