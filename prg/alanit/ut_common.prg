//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "Fivewin.ch"
#include "Report.ch"
#include "DbStruct.ch"
#include "xBrowse.ch"
#include "SayRef.ch"

/*
 * función .: SetIni()
 * prec ....: cSection != NIL && cEntry != NIL && xVar != NIL
 * post ....: Escribe una entrada en un archivio INI.
*/

function SetIni( cIni, cSection, cEntry, xVar )

   local oIni

   default cIni := oApp():cIniFile

   INI oIni FILE cIni
   set SECTION cSection ;
      ENTRY cEntry      ;
      to xVar           ;
      OF oIni
   ENDINI

return nil


/*
 * función .: GetIni()
 * prec ....: cSection != NIL && cEntry != NIL && xDefault != NIL
 * post ....: Lee una entrada de un archivio INI.
*/

function GetIni( cIni, cSection, cEntry, xDefault )

   local oIni
   local xVar := xDefault

   default cIni := oApp():cIniFile

   INI oIni FILE cIni
   get xVar            ;
      SECTION cSection ;
      ENTRY cEntry     ;
      default xDefault ;
      OF oIni
   ENDINI

return xVar


/*
 * función .: GoWeb()
 * prec ....: cUrl != NIL
 * post ....: Abre el navegador y visita la URL indicada.
*/

function GoWeb( cUrl )

   cUrl := AllTrim( cUrl )

   if ! IsWinNt()
      WinExec("start urlto:"+cURL,0)
   else
      WinExec("rundll32.exe url.dll,FileProtocolHandler " + cURL)
   end if

return nil


/*
 * función .: GoMail()
 * prec ....: cMail != NIL
 * post ....: Abre el cliente de correo y carga un nuevo email con destinatario.
*/

function GoMail( cMail )

   cMail := AllTrim( cMail )

   if ! IsWinNt()
      WinExec( "start mailto: " + cMail, 0 )
   else
      WinExec( "rundll32.exe url.dll,FileProtocolHandler mailto:" + cMail )
   end if

return nil


/*
 * función .: ValEmpty()
 * prec ....: cDato != NIL && oGet != NIL
 * post ....: Comprueba que un GET no esté vacío.
*/

function ValEmpty( cDato, oGet )

   if Empty( cDato )
      MsgStop( i18n( "Es obligatorio rellenar este campo." ) )
      oGet:setFocus()
      return .F.
   end if

return .T.


/*
 * función .: DlgCenter()
 * prec ....: oDlg != NIL && oWnd != NIL
 * post ....: Centra un diálogo respecto a una ventana.
*/

function DlgCenter( oDlg, oWnd )

   oDlg:Center( oWnd )

return nil


/*
 * función .: SwapUpArray()
 * prec ....: aArray != NIL
 * post ....: Intercambia un elemento del array con su superior.
*/

function SwapUpArray( aArray, nPos )

   local uTmp

   default nPos := Len( aArray )

   if nPos <= Len( aArray ) .AND. nPos > 1
      uTmp              := aArray[nPos]
      aArray[nPos]      := aArray[nPos - 1 ]
      aArray[nPos - 1 ] := uTmp
   end if

return nil


/*
 * función .: SwapDwArray()
 * prec ....: aArray != NIL
 * post ....: Intercambia un elemento del array con su inferior.
*/

function SwapDwArray( aArray, nPos )

   local uTmp

   default nPos := Len( aArray )

   if nPos < Len( aArray ) .AND. nPos > 0
      uTmp              := aArray[nPos]
      aArray[nPos]      := aArray[nPos + 1 ]
      aArray[nPos + 1 ] := uTmp
   end if

return nil


/*
 * función .: FindRec()
 * prec ....: cAlias != NIL && cData != NIL && cOrder != NIL
 * post ....: Determina si existe un registro en el fichero indicado.
*/

function FindRec( cAlias, cData, cOrder )

   local nOrder := ( cAlias )->( ordNumber() )
   local nRecno := ( cAlias )->( RecNo()     )
   local lFind  := .F.

   ( cAlias )->( ordSetFocus( cOrder ) )

   if ( cAlias )->( dbSeek( Upper( cData ) ) )
      lFind := .T.
   end if

   ( cAlias )->( dbSetOrder( nOrder ) )
   ( cAlias )->( dbGoto( nRecno )     )

return lFind

/*
 * función .: aGetFont()
 * prec ....: oWnd != NIL
 * post ....: Devuelve un array con los nombres de las fuentes instaladas.
*/

function aGetFont( oWnd )

   local aFont    := {}
   local hDC      := GetDC( oWnd:hWnd )
   local nCounter := 0

   if hDC != 0
      while ( Empty( aFont := GetFontNames( hDC ) ) ) .AND. ( ++nCounter ) < 5
      end while
      if Empty( aFont )
         msgAlert( i18n("Error al obtener las fuentes.") + CRLF + ;
            i18n("Sólo podrá usar las fuentes predefinidas.") )
      else
         ASort( aFont,,, {|x, y| Upper( x ) < Upper( y ) } )
      end if
   else
      msgAlert( i18n("Error al procesar el manejador de la ventana.") + CRLF + ;
         i18n("Sólo podrá usar las fuentes predefinidas.") )
   end if

   ReleaseDC( oWnd:hWnd, hDC )

return aFont


/*
 * función .: FillCmb()
 * prec ....: cAlias != NIL && cTag != NIL && aCmb != NIL && cField != NIL && cVar != NIL
 * post ....: Rellena un array con los registros de un fichero ajeno.
*/

function FillCmb( cAlias, cTag, aCmb, cField, nOrd, nRec, cVar )

   default nOrd := ( cAlias )->( ordNumber() ),;
      nRec := ( cAlias )->( RecNo() )

   ( cAlias )->( ordSetFocus( cTag ) )
   ( cAlias )->( dbGoTop() )

   while ! ( cAlias )->( Eof() )
      AAdd( aCmb, ( cAlias )->&cField )
      ( cAlias )->( dbSkip() )
   end while

   ( cAlias )->( dbSetOrder( nOrd ) )
   ( cAlias )->( dbGoto( nRec ) )

   cVar := iif( Len( aCmb ) > 0, aCmb[1], "" )

return nil


/*
 * función .: GetFieldWidth()
 * prec ....: cAlias != NIL && cField != NIL
 * post ....: Obtiene el tamaño de un campo de fichero.
*/

function GetFieldWidth( cAlias, cField )

   local aDbf := ( cAlias )->( dbStruct() )
   local i    := 1
   local lEnc := .F.
   local nLen := Len( aDbf )
   local nPos := 0

   cField := Upper(cField)

   // encuentro la posición del campo a partir del nombre
   while ( i <= nLen ) .AND. ( ! lEnc )
      if aDbf[i,1] == cField
         lEnc := .T.
      else
         i++
      end if
   end while
   nPos := i

   // devuelvo el ancho del campo

return ( cAlias )->( dbFieldInfo( DBS_LEN, nPos ) )


/*
 * función .: GetDir()
 * prec ....: oGet != NIL
 * post ....: Rellena el GET indicado con la ruta al directorio seleccionado.
*/

function GetDir( oGet )

   local cFile

   cFile := cGetDir32()

   if ! Empty( cFile )
      oGet:cText := cFile + "\"
   end if

return nil


/*
 * función .: IsPrestado()
 * prec ....: $E x : {'LI','MU','VI','SO'} : cAlias == x
 * post ....: Determina si un registro prestable está prestado o no.
*/

function IsPrestado( cAlias )

   local cPrest := ""
   local cFecha := ""

   do case
   case cAlias == "LI"
      cPrest := "LiPrestad"
      cFecha := "LiFechaPr"
   case cAlias == "MU"
      cPrest := "MuPrestad"
      cFecha := "MuFchPres"
   case cAlias == "VI"
      cPrest := "ViPrestad"
      cFecha := "ViFchPres"
   case cAlias == "SO"
      cPrest := "SoPrestad"
      cFecha := "SoFecha"
   end case

   if !Empty( ( cAlias )->&cPrest ) .OR. ( cAlias )->&cFecha != CToD( "" )
      return .T. // prestado
   else
      return .F. // no prestado
   end if

return nil


/*
 * función .: RefreshCont()
 * prec ....: oCont != NIL && cAlias != NIL
 * post ....: Actualiza el contador recibido con el nº de registros del fichero.
*/

function RefreshCont( oCont, cAlias, cString )

   default cString := cAlias
   if oCont != NIL 
      oCont:cTitle := cString+tran( (cAlias)->(ordKeyNo()),'@E 999,999')+" / "+tran((cAlias)->(ordKeyCount()),'@E 999,999')
      oCont:refresh()
   endif

return nil


/*
 * función .: aScanN()
 * prec ....: aArray != NIL && xExpr != NIL
 * post ....: Cuenta el nº de elementos del array iguales a xExpr.
*/

function aScanN( aArray, xExpr )

   local nFound := 0
   local i      := 0
   local nLen   := Len( aArray )

   for i := 1 to nLen
      if aArray[i] == xExpr
         nFound++
      end if
   next

return nFound


/*
 * función .: GetNewCod()
 * prec ....: lFromBtn != NIL && cAlias != NIL && cField != NIL && cGet != NIL
 * post ....: Obtiene el siguiente código autonumérico para un fichero dado.
*/

function GetNewCod( lFromBtn, cAlias, cField, cGet )

   local nOrd      := ( cAlias )->( ordNumber() )
   local nRec      := ( cAlias )->( RecNo() )
   local nCod      := 0
   local cMsgAlert := ""

   ( cAlias )->( ordSetFocus( "codigo" ) )
   ( cAlias )->( dbGoBottom() )

   if Val( ( cAlias )->&cField ) != 0
      // su último registro es numérico (y distinto de cero)
      nCod := Val( ( cAlias )->&cField ) + 1
      cGet := StrZero( nCod, 10 )
   else
      if ( cAlias )->&cField == "0000000000" .OR. Empty( ( cAlias )->&cField )
         // su último registro vale 0 o está en blanco porque estás añadiendo
         // el 1er registro de la tabla [estás viendo el dbAppend()]
         cGet := "0000000001"
      else
         // su último registro contiene letras
         cMsgAlert := i18n("Es imposible incrementar automáticamente el " + ;
            "código porque no está siguiendo un patrón " + ;
            "numérico.")
         if !lFromBtn
            cMsgAlert += i18n(" Si no desea que el programa lo intente " + ;
               "generar, desactive la opción desde el panel " + ;
               "de configuración.")
         end if
         msgAlert( cMsgAlert )
      end if
   end if

   ( cAlias )->( ordSetFocus( nOrd ) )
   ( cAlias )->( dbGoto( nRec ) )

return nil

/*_____________________________________________________________________________*/

function GetFreeSystemResources() ; return 0

function nPtrWord() ; return 0


/*
 * función .: CheckGets()
 * prec ....: aGet != NIL && oFld != NIL
 * post ....: Evalúa los bValid de todos los TGet de un TFolder.
*/

function CheckGets( aGet, oFld )

   local i       := 0
   local nGets   := Len( aGet )
   local oCtrl
   local oDlg
   local lReturn := .T.
   local nFldOpt := 0

   // La DATA Cargo de los GETs contiene el nº de diálogo
   // del folder que lo contiene, y es asignada desde el
   // método ::setNumFolder() añadido a TFolder.

   for i := 1 to nGets
      oCtrl := aGet[i]
      if oCtrl:ClassName() == "TGET"
         if oCtrl:bValid != NIL
            if !Eval( oCtrl:bValid )
               if oCtrl:oWnd:oWnd == oFld
                  oDlg := oCtrl:oWnd
                  oFld:setOption( oCtrl:Cargo )
               end if
               oCtrl:setFocus()
               lReturn := .F.
               exit
            end if
         end if
      end if
   next

return lReturn


/*
 * función .: StartDebug()
 * prec ....: True
 * post ....: Habilita el debugger de xHarbour.
*/

function StartDebug()

   // requiere enlazar debug.lib y un flag

   //   AltD( 1 )   // Enables the debugger. Press F5 to go
   //   AltD()      // Invokes the debugger
   //   Alert( "debugger invoked" )

return nil


/*
 * función .: ModalSobreFsdi()
 * prec ....: True
 * post ....: Determina si hay un diálogo modal abierto sobre un TFsdi.
*/

function ModalSobreFsdi()

   local lReturn

   lReturn := .F.

   if oApp():oDlg != NIL
      if oApp():nEdit > 0
         msgStop( i18n("No puede cambiar de mantenimiento hasta que no " + ;
            "cierre las ventanas abiertas sobre el que está " + ;
            "manejando.") )
         lReturn := .T.
      else
         oApp():oDlg:End()
         SysRefresh()
      end if
   end if

return lReturn


/*
 * función .: DesglosarArrayInf()
 * prec ....: cAlias != NIL && aInf != NIL && aTitulos != NIL && aCampos != NIL && aWidth != NIL && aShow != NIL && aPicture != NIL && aTotal != NIL
 * post ....: Desglosa el array aInf en varios arrays.
*/

function DesglosarArrayInf( cAlias, aInf, aTitulos, aCampos, aWidth, aShow, aPicture, aTotal )

   local nLen
   local i

   nLen := Len( aInf )

   for i := 1 to nLen
      if aInf[i,3] == 0
         aInf[i,3] := GetFieldWidth( cAlias, aInf[i,2] ) // relleno los anchos automáticamente
      end if
      AAdd( aTitulos, aInf[i,1] )
      AAdd( aCampos, aInf[i,2] )
      AAdd( aWidth, aInf[i,3] )
      AAdd( aShow, aInf[i,4] )
      AAdd( aPicture, aInf[i,5] )
      AAdd( aTotal, aInf[i,6] )
   next

return nil


/*
 * función .: Registrarme()
 * prec ....: True
 * post ....: Muestra la prohibición de usar una funcionalidad de pago.
*/

function Registrame(lDirect) // CLASS TApplication

   local oDlg, oBmp01, oBmp02, oTmr, oSay, oTel, oURL1, oURL2, cCfg
   local lNext := .T.
   local nPaso := 11 // (-1)*GetDefaultFontHeight()-1

   IF Seconds() - oApp():nSeconds < 120 .AND. lDirect == NIL
      // ? Seconds() - oApp():nSeconds
      RETU NIL
   ELSE
      oApp():nSeconds := Seconds()
   ENDIF

   define dialog oDlg title 'edición gratuita del programa' ; // OF oParent ;
   from  0, 0 to 35*nPaso, 390 PIXEL  ;
      color CLR_BLACK, CLR_WHITE
   oDlg:SetFont(oApp():oFont)

   @ 04,36 BITMAP oBmp01 RESOURCE 'acercade' ;
      SIZE 110, 30 OF oDlg PIXEL NOBORDER // TRANSPAREN

   //@ 10,80 BITMAP oBmp02 RESOURCE 'acercade1' ;
   //   SIZE 94, 26 OF oDlg PIXEL NOBORDER // TRANSPAREN

   @ 40,10 say oSay prompt "version "+oApp():cVersion+" "+oApp():cBuild +" "+oApp():cEdicion ;
      SIZE 174,15 CENTERED PIXEL OF oDlg ;
      color CLR_GRAY, CLR_WHITE

   @ 40+nPaso-2,10 say oTel prompt ' © José Luis Sánchez Navarro 2018 ' ;
      SIZE 174,9 PIXEL CENTERED OF oDlg ;
      color CLR_GRAY, CLR_WHITE

   @ 40+2*nPaso,10 say oSay prompt 'Está utilizando la edición gratuita del programa. Esta edición es completamente funcional por tiempo ilimitado, pero existe una edición registrada que incorpora las siguientes funcionalidades:';
      SIZE 174,76 PIXEL OF oDlg ;
      CENTERED color CLR_BLACK, CLR_WHITE
   
   @ 40 + 5.5 * nPaso, 10 SAY oSay PROMPT "* No aparece este recordatorio de registrar el programa" ;
      SIZE 174, 10 PIXEL CENTERED OF oDlg COLOR RGB( 204, 0, 0 ), CLR_WHITE // FONT oMs10Under
   @ 40 + 6.5 * nPaso, 10 SAY oSay PROMPT "* Nombre del usuario en todos los listados" ;
      SIZE 174, 10 PIXEL CENTERED OF oDlg  COLOR RGB( 204, 0, 0 ), CLR_WHITE // FONT oMs10Under
   @ 40 + 7.5 * nPaso, 10 SAY oSay PROMPT "* Soporte técnico preferente" ;
      SIZE 174, 18 PIXEL CENTERED OF oDlg COLOR  RGB( 204, 0, 0 ), CLR_WHITE // FONT oMs10Under

   @ 40+9*nPaso,10 say oSay prompt 'Si desea comprar la edición registrada del programa por sólo 20 € pulse sobre el siguiente enlace:';
      SIZE 174,46 PIXEL CENTERED OF oDlg ;
      color CLR_BLACK, CLR_WHITE

   @ 40+11*nPaso,10 SAYREF oURL2 prompt "http://www.alanit.com/comprar" ;
      SIZE 174,14 PIXEL CENTERED OF oDlg     ;
      HREF "http://www.alanit.com/comprar"   ;
      color RGB(3,95,156), CLR_WHITE

   oUrl2:cTooltip  := 'registrar el programa por sólo 20 €'
   oUrl2:oFont  := oDlg:oFont

   activate dialog oDlg ;
      ON INIT DlgCenter( oDlg, oApp():oWndMain ) ;
      ON PAINT ( SysWait( 9 ), oDlg:End() )
   // oMs10Under:End()

return nil


/*
 * función .: GetWinCoors() - (c) OzScript
 * prec ....: oWnd != NIL && cIniFile != NIL
 * post ....: Obtiene del INI y establece las coordenadas de la ventana principal.
*/

#define ST_NORMAL        0
#define ST_ICONIZED      1
#define ST_ZOOMED        2

function GetWinCoors(oWnd,cIniFile)

   local oIni
   local nRow, nCol, nWidth, nHeight, nState

   // nRow    := oWnd:nTop
   // nCol    := oWnd:nLeft
   // nWidth  := oWnd:nRight-oWnd:nLeft
   // nHeight := oWnd:nBottom-oWnd:nTop

   nRow    := 0
   nCol    := 0
   nWidth  := 1024
   nHeight := 768

   if IsIconic( oWnd:hWnd )
      nState := ST_ICONIZED
   elseif IsZoomed(oWnd:hWnd)
      nState := ST_ZOOMED
   else
      nState := ST_NORMAL
   end if

   INI oIni FILE cIniFile

   get nRow SECTION "config" ;
      ENTRY "nTop" default nRow OF oIni

   get nCol SECTION "config" ;
      ENTRY "nLeft" default nCol OF oIni

   get nWidth SECTION "config" ;
      ENTRY "nRight" default nWidth OF oIni

   get nHeight SECTION "config" ;
      ENTRY "nBottom" default nHeight OF oIni

   get nState SECTION "config" ;
      ENTRY "Mode" default nState OF oIni

   ENDINI
   if nRow < -10 .OR. nCol < -10
      nRow := 1
      nCol := 1
      nWidth  := 1024
      nHeight := 768
   endif
   if nRow == 0 .AND. nCol == 0
      WndCenter(oWnd:hWnd)
   else
      oWnd:Move(nRow, nCol, nWidth, nHeight)
   end if

   if nState == ST_ICONIZED
      oWnd:Minimize()
   elseif nState == ST_ZOOMED
      oWnd:Maximize()
   end if
   UpdateWindow( oWnd:hWnd )
   oWnd:CoorsUpdate()
   SysRefresh()

return nil


/*
 * función .: GetWinCoors() - (c) OzScript
 * prec ....: oWnd != NIL && cIniFile != NIL
 * post ....: Guarda en el INI las coordenadas de la ventana principal.
*/

function SetWinCoors(oWnd, cIniFile)

   local oIni
   local nRow, nCol, nWidth, nHeight, nState

   oWnd:CoorsUpdate()

   nRow    := oWnd:nTop
   nCol    := oWnd:nLeft
   nWidth  := oWnd:nRight-oWnd:nLeft
   nHeight := oWnd:nBottom-oWnd:nTop

   if IsIconic( oWnd:hWnd )
      nState := ST_ICONIZED
   elseif IsZoomed(oWnd:hWnd)
      nState := ST_ZOOMED
   else
      nState := ST_NORMAL
   end if

   INI oIni FILE cIniFile

   set SECTION "config" ;
      ENTRY "nTop" to nRow OF oIni

   set SECTION "config" ;
      ENTRY "nLeft" to nCol OF oIni

   set SECTION "config" ;
      ENTRY "nRight" to nWidth OF oIni

   set SECTION "config" ;
      ENTRY "nBottom" to nHeight OF oIni

   set SECTION "config" ;
      ENTRY "Mode" to nState OF oIni

   if oApp():lRibbon
      set SECTION "config" ;
         ENTRY "Ribbon" to oApp():oRebar:nOption OF oIni
   endif

   ENDINI

return .T.


/*
 * función .: GetWinCoors() - (c) OzScript
 * prec ....: cFile != NIL
 * post ....: Extrae el nombre de un archivo a partir de nombre+extensión.
*/

function TakeOffExt(cFile)

   local nAt := At(".", cFile)

   if nAt > 0
      cFile := Left(cFile, nAt-1)
   end if

return cFile

/*_____________________________________________________________________________*/

function bTitulo( aTitulos, nFor )

return {|| aTitulos[nFor] }

/*_____________________________________________________________________________*/

function bCampo( aCampos, nFor )

return FieldWBlock( aCampos[nFor], Select() )

/*_____________________________________________________________________________*/

function bPicture( aPicture, nFor )

return aPicture[nFor]

/*_____________________________________________________________________________*/

function bArray( aArray, aCampos, nFor )

   local nIndex

   nIndex := Eval( bCampo( aCampos, nFor ) )

return aArray[Val(nIndex)]
/*_____________________________________________________________________________*/

function AdjustWnd( oBtn, nWidth, nHeight )

   local nMaxWidth, nMaxHeight
   local aPoint

   aPoint := { oBtn:nTop + oBtn:nHeight(), oBtn:nLeft }
   clientToScreen( oBtn:oWnd:hWnd, @aPoint )

   nMaxWidth  := GetSysMetrics(0)
   nMaxHeight := GetSysMetrics(1)

   if  aPoint[2] + nWidth > nMaxWidth
      aPoint[2] := nMaxWidth -  nWidth
   endif

   if  aPoint[1] + nHeight > nMaxHeight
      aPoint[1] := nMaxHeight - nHeight
   endif

return aPoint
