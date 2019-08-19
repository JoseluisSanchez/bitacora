//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"

extern deleted

/*_____________________________________________________________________________*/

function Ubicaciones(cTipo)

   local oBar
   local oCol
   local oCont
   local cBitmap     := ""
   local cCaption    := ""
   local cTitle      := ""
   local cContTitle  := ""
   local cSplSize    := ""
   local cPrefix     := ""
   local cHdrEjempl  := ""
   local cTbBmpEjemp := ""
   local cTbTxtEjemp := ""

   local cBrwState   := ""
   local nBrwSplit   := 0
   local nBrwRecno   := 0
   local nBrwOrder   := 0

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   switch cTipo
   case "L"
      UB->( ordSetFocus( "lubicacion" ) )
      LI->( ordSetFocus( "ubicacion" ) )
      cCaption    := i18n( "Gestión de ubicaciones de Libros" )
      cTitle      := i18n( "Ubicaciones" )
      cBitmap   := "BB_UBICACIONES"
      cSplSize    := "102"
      cPrefix     := "UbLiAbm-"
      cHdrEjempl  := i18n("Nº Libros")
      cTbBmpEjemp := "16_libros"
      cTbTxtEjemp := "Ver libros"
      exit
   case "M"
      // música
      UB->( ordSetFocus( "mubicacion" ) )
      MU->( ordSetFocus( "ubicacion" ) )
      cCaption    := i18n( "Gestión de ubicaciones de Discos" )
      cTitle      := i18n( "Ubicaciones" )
      cBitmap   := "BB_UBICACIONES"
      cSplSize    := "102"
      cPrefix     := "UbMuAbm-"
      cHdrEjempl  := i18n("Nº Discos")
      cTbBmpEjemp := "16_discos"
      cTbTxtEjemp := "Ver discos"
      exit
   case "V"
      // videos
      UB->( ordSetFocus( "vubicacion" ) )
      VI->( ordSetFocus( "ubicacion" ) )
      cCaption    := i18n( "Gestión de ubicaciones de videos" )
      cTitle      := i18n( "Ubicaciones" )
      cBitmap   := "BB_UBICACIONES"
      cSplSize    := "102"
      cPrefix     := "UbViAbm-"
      cHdrEjempl  := i18n("Nº Videos")
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      exit
   case "S"
      // software
      MA->( ordSetFocus( "subicacion" ) )
      SO->( ordSetFocus( "ubicacion" ) )
      cCaption    := i18n( "Gestión de ubicaciones de software" )
      cTitle      := i18n( "Ubicaciones" )
      cBitmap   := "BB_UBICACIONES"
      cSplSize    := "102"
      cPrefix     := "UbSoAbm-"
      cHdrEjempl  := i18n("Nº Programas")
      cTbBmpEjemp := "16_software"
      cTbTxtEjemp := "Ver software"
      exit
   case "I"
      // internet
      MA->( ordSetFocus( "imateria" ) )
      VI->( ordSetFocus( "materia" ) )
      cCaption    := i18n( "Gestión de materias de internet" )
      cTitle      := i18n( "Materias" )
      cBitmap   := "BB_MATERIAS"
      cSplSize    := "102"
      cPrefix     := "MaViAbm-"
      cHdrEjempl  := i18n("Nº Videos")
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      exit
   end switch

   cContTitle := cTitle + ": "
   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )
   nBrwSplit := Val( GetIni( , "Browse", cPrefix + "Split", cSplSize ) )
   nBrwRecno := Val( GetIni( , "Browse", cPrefix + "Recno", "1" ) )
   nBrwOrder := Val( GetIni( , "Browse", cPrefix + "Order", "1" ) )

   UB->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de colecciones por Ubicaciones" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )
   oApp():oGrid:cAlias := "UB"

   ADD oCol TO oApp():oGrid DATA UB->UbUbicaci ;
      HEADER "Ubicación"  WIDTH 200

   ADD oCol TO oApp():oGrid DATA UB->UbItems   ;
      HEADER cHdrEjempl PICTURE "@E 999,999" ;
      TOTAL 0 WIDTH 80

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| UbForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ), oApp():oGrid:Maketotals() } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "UB", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| UbTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21
   oApp():oGrid:lFooter    := .t.
	oApp():oGrid:bClrFooter := {|| { CLR_HRED, GetSysColor(15) } }
 	oApp():oGrid:MakeTotals()

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(UB->(ordKeyNo()),'@E 999,999')+" / "+tran(UB->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE cBitmap

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nueva")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( UbForm( oApp():oGrid, "add", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( UbForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( UbForm( oApp():oGrid, "dup", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( UbBorrar( oApp():oGrid, oCont, cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( UbBuscar( oApp():oGrid, oCont, , cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( UbImprimir( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION cTbTxtEjemp      ;
      IMAGE cTbBmpEjemp        ;
      ACTION ( UbEjemplares( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar a Excel"     ;
      IMAGE "16_EXCEL"             ;
      ACTION (CursorWait(), oApp():oGrid:ToExcel(), CursorArrow());
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Configurar rejilla") ;
      IMAGE "16_grid"              ;
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "UbAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " Ubicación " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( UbTabs( oApp():oGrid, oApp():oTab:nOption, @cTipo, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= UB->( ordKeyCount() )
      UB->( dbGoto( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      UbTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", cPrefix+"State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", cPrefix+"Order", oApp():oTab:nOption ),;
      SetIni( , "Browse", cPrefix+"Recno", UB->( RecNo() ) ),;
      SetIni( , "Browse", cPrefix+"Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function UbForm( oBrw, cModo, cTipo, oCont, cClave, cContTitle )

   local oDlg
   local aGet        := Array( 03 )
   local lIdOk       := .F.
   local nRecBrw     := UB->( RecNo() )
   local nRecAdd     := 0
   local cOldUbicaci := UB->UbUbicaci
   local cCaption    := ""
   local cSayNum     := ""
   local cUbUbicaci  := ""
   local cUbTipo     := ""
   local nUbItems    := 0

   if cModo == "edt" .OR. cModo == "dup"
      if UbDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if UB->( Eof() ) .AND. cModo != "add"
      retu nil
   endif
   oApp():nEdit++
   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      cCaption := i18n( "Añadir " )
      switch cTipo
      case "L"
         cCaption := i18n( "Añadir una Ubicación de Libros" )
         exit
      case "M"
         cCaption := i18n( "Añadir una Ubicación de Discos" )
         exit
      case "S"
         cCaption := i18n( "Añadir una Ubicación de Software" )
         exit
      case "V"
         cCaption := i18n( "Añadir una Ubicación de Vídeos" )
         exit
      end switch
      UB->( dbAppend() )
      if cClave != NIL
         cUbUbicaci := cClave
      else
         cUbUbicaci := Space( 60 )
      endif
      UB->( dbCommit() )
      nRecAdd := UB->( RecNo() )
      // modificar
   case cModo == "edt"
      switch cTipo
      case "L"
         cCaption := i18n( "Modificar una Ubicación de Libros" )
         exit
      case "M"
         cCaption := i18n( "Modificar una Ubicación de Discos" )
         exit
      case "S"
         cCaption := i18n( "Modificar una Ubicación de Software" )
         exit
      case "V"
         cCaption := i18n( "Modificar una Ubicación de Vídeos" )
         exit
      end switch
      cUbUbicaci := UB->ubUbicaci
      // duplicar
   case cModo == "dup"
      switch cTipo
      case "L"
         cCaption := i18n( "Duplicar una Ubicación de Libros" )
         exit
      case "M"
         cCaption := i18n( "Duplicar una Ubicación de Discos" )
         exit
      case "S"
         cCaption := i18n( "Duplicar una Ubicación de Software" )
         exit
      case "V"
         cCaption := i18n( "Duplicar una Ubicación de Vídeos" )
         exit
      end switch
      cUbUbicaci := UB->ubUbicaci
   endcase

   switch cTipo
   case "L"
      cSayNum  := i18n( "Nº de Libros" )
      exit
   case "M"
      cSayNum  := i18n( "Nº de Discos" )
      exit
   case "S"
      cSayNum  := i18n( "Nº de Programas" )
      exit
   case "V"
      cSayNum  := i18n( "Nº de Vídeos" )
      exit
   end switch

   cUbTipo    := UB->ubTipo
   nUbItems   := UB->ubItems

   if cModo == "dup"
      nUbItems := 0
   endif

   DEFINE DIALOG oDlg RESOURCE "UB_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE get aGet[01] ;
      var cUbUbicaci ;
      ID 100 ;
      OF oDlg ;
      UPDATE ;
      VALID ( UbClave( cUbUbicaci, aGet[01], cModo, cTipo ) )

   REDEFINE say aGet[02] var cSayNum    ID 201 OF oDlg
   REDEFINE say aGet[03] var nUbItems   ID 101 OF oDlg

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:end() )

   REDEFINE BUTTON ;
      ID IDCANCEL ;
      OF oDlg ;
      CANCEL ;
      ACTION ( lIdOk := .F., oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      on init oDlg:Center( oApp():oWndMain )

   do case
      // nuevo
   case cModo == "add"
      // aceptar
      if lIdOk == .T.
         UB->( dbGoto( nRecAdd ) )
         replace UB->UbUbicaci with cUbUbicaci
         replace UB->UbTipo    with cTipo
         UB->( dbCommit() )
         nRecBrw := UB->( RecNo() )
         if cClave != NIL
            cClave := cUbUbicaci
         endif
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk
         UB->( dbGoto( nRecBrw ) )
         replace UB->UbUbicaci with cUbUbicaci
         replace UB->UbTipo    with cUbTipo
         UB->( dbCommit() )
         if UB->UbItems > 0
            msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
               {|| UbR( cUbUbicaci, cOldUbicaci, cTipo ) } )
         endif
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         UB->( dbAppend() )
         replace UB->UbUbicaci with cUbUbicaci
         replace UB->UbTipo    with cTipo
         UB->( dbCommit() )
         nRecBrw := UB->( RecNo() )
      endif
   endcase
   if lIdOk
      switch cTipo
      case "L"
         oAGet():lUbLi := .T.
         exit
      case "M"
         oAGet():lUbMu := .T.
         exit
      case "S"
         oAGet():lUbSo := .T.
         exit
      case "V"
         oAGet():lUbVi := .T.
         exit
      end switch
      oAGet():Load()
   endif

   UB->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "UB", cContTitle )
   endif
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   endif

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function UbBorrar( oBrw, oCont, cTipo, cContTitle )

   local nRecord := UB->( RecNo() )
   local nNext   := 0
   local cMsg    := ""

   if UbDbfVacia()
      return nil
   endif

   switch cTipo
   case "L"
      cMsg  := i18n( "Si borra esta Ubicación, se borrará en todos los libros en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "M"
      cMsg  := i18n( "Si borra esta Ubicación, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "V"
      cMsg  := i18n( "Si borra esta Ubicación, se borrará en todos los vídeos en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "S"
      cMsg  := i18n( "Si borra esta Ubicación, se borrará en todos los programas en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   end switch

   if msgYesNo( cMsg +CRLF+CRLF+ Trim( UB->UbUbicaci ) )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
         {|| UbDelR( UB->UbUbicaci, cTipo ) } )
      UB->( dbSkip() )
      nNext := UB->( RecNo() )
      UB->( dbGoto( nRecord ) )
      UB->( dbDelete() )
      UB->( dbGoto( nNext ) )
      if UB->( Eof() ) .OR. nNext == nRecord
         UB->( dbGoBottom() )
      endif
      switch cTipo
      case "L"
         oAGet():lUbLi := .T.
         exit
      case "M"
         oAGet():lUbMu := .T.
         exit
      case "S"
         oAGet():lUbSo := .T.
         exit
      case "V"
         oAGet():lUbVi := .T.
         exit
      end switch
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont( oCont, "UB", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function UbBuscar( oBrw, oCont, cChr, cTipo, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := i18n("Ubicación:")
   local cGet     := ""
   local nRecNo   := UB->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if UbDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cPrompt := i18n( "Introduzca el Nombre de la Ubicación de Libros" )
      exit
   case "M"
      cPrompt := i18n( "Introduzca el Nombre de la Ubicación de Discos" )
      exit
   case "V"
      cPrompt := i18n( "Introduzca el Nombre de la Ubicación de Vídeos" )
      exit
   case "S"
      cPrompt := i18n( "Introduzca el Nombre de la Ubicación de Software" )
      exit
   end switch

   cGet   := Space( 60 )

   lFecha := ValType( cGet ) == "D" // para un futuro

   DEFINE DIALOG oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Ubicaciones" )
   oDlg:SetFont(oApp():oFont)

   REDEFINE say prompt cPrompt ID 20 OF oDlg
   REDEFINE say prompt cField  ID 21 OF oDlg

   if cChr != NIL
      if ! lFecha
         cGet := cChr + SubStr( cGet, 1, Len( cGet ) - 1 )
      else
         cGet := CToD( cChr + " -  -    " )
      endif
   endif

   REDEFINE get oGet var cGet ID 101 OF oDlg

   if cChr != NIL
      oGet:bGotFocus := {|| ( oGet:SetColor( CLR_BLACK, rgb( 255, 255, 127 ) ), oGet:SetPos( 2 ) ) }
   endif

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:end() )

   REDEFINE BUTTON ;
      ID IDCANCEL ;
      OF oDlg ;
      CANCEL ;
      ACTION ( lIdOk := .F., oDlg:end() )

   SysRefresh()

   ACTIVATE DIALOG oDlg ;
      on INIT ( oDlg:Center( oApp():oWndMain ) )

   if lIdOk
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
         {|| UbWildSeek(cTipo, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ninguna ubicación."))
         UB->(dbGoto(nRecno))
      else
         UbEncontrados(aBrowse, oApp():oDlg, cTipo)
      endif
   endif
   RefreshCont( oCont, "UB", cContTitle )
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function UbWildSeek(cTipo, cGet, aBrowse)

   local nRecno   := UB->(RecNo())

   UB->(dbGoTop())
   do while ! UB->(Eof())
      if cGet $ Upper(UB->UbUbicaci)
         AAdd(aBrowse, {UB->UbUbicaci, UB->UbItems, UB->(RecNo())})
      endif
      UB->(dbSkip())
   enddo

   UB->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function UbEncontrados(aBrowse, oParent, cTipo)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := UB->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Ubicación"
   oBrowse:aCols[2]:cHeader := "Ejemplares"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   UB->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||UB->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      UbForm(oBrowse,"edt",cTipo,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(UB->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      UbForm(oBrowse,"edt",cTipo,oDlg)),) }
   oBrowse:bChange    := {|| UB->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (UB->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function UbClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "UB"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   switch cTipo
   case "L"
      cMsgSi := i18n( "Ubicación de Libros ya registrada." )
      cMsgNo := i18n( "Ubicación de Libros no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 2
      exit
   case "M"
      cMsgSi := i18n( "Ubicación de Discos ya registrada." )
      cMsgNo := i18n( "Ubicación de Discos no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 3
      exit
   case "V"
      cMsgSi := i18n( "Ubicación de Vídeos ya registrada." )
      cMsgNo := i18n( "Ubicación de Vídeos no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 4
      exit
   case "S"
      cMsgSi := i18n( "Ubicación de Software ya registrada." )
      cMsgNo := i18n( "Ubicación de Software no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 5
      exit
   end switch

   if Empty( cClave )
      if cModo == "aux"
         return .T.
      else
         msgStop( i18n( "Es obligatorio rellenar este campo." ) )
         return .F.
      endif
   endif

   ( cAlias )->( dbSetOrder( nPkOrd ) )
   ( cAlias )->( dbGoTop() )

   if ( cAlias )->( dbSeek( Upper( cClave ) ) )
      do case
      case cModo == "add" .OR. cModo == "dup"
         lReturn := .F.
         msgStop( cMsgSi )
      case cModo == "edt"
         if ( cAlias )->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop( cMsgSi )
         endif
      case cModo == "aux"
         IF ! oApp():thefull
            Registrame()
         ENDIF
         lReturn := .T.
      endcase
   else
      do case
      case cModo == "add" .OR. cModo == "edt" .OR. cModo == "dup"
         lReturn := .T.
      case cModo == "aux"
         if msgYesNo( cMsgNo )
            lReturn := UbForm( , "add", cTipo, , @cClave )
            oGet:Refresh()
         else
            lReturn := .F.
         endif
      endcase
   endif

   ( cAlias )->( dbSetOrder( nOrder ) )
   ( cAlias )->( dbGoto( nRecno ) )

return lReturn

/*_____________________________________________________________________________*/

function UbTabAux( cGet, oGet, cTipo, oVItem )

   local oDlg
   local oBrw
   local oCol
   local aBtn      := Array( 06 )

   local lIdOk     := .F.
   local aPoint := iif(oGet!=NIL,AdjustWnd( oGet, 271*2, 150*2 ),{1.3*oVItem:nTop(),oApp():oGrid:nLeft})
   local cCaption  := ""
   local nOrder    := UB->( ordNumber() )
   local cPrefix   := ""

   local cBrwState := ""

   cTipo := Upper( cTipo )

   switch cTipo
   case "L"
      UB->( ordSetFocus( "lubicacion" ) )
      cCaption := i18n( "Selección de Ubicaciones de Libros" )
      cPrefix  := "UbAuxLi-"
      exit
   case "M"
      UB->( ordSetFocus( "mubicacion" ) )
      cCaption := i18n( "Selección de Ubicaciones de Discos" )
      cPrefix  := "UbAuxMu-"
      exit
   case "V"
      UB->( ordSetFocus( "vubicacion" ) )
      cCaption := i18n( "Selección de Ubicaciones de Vídeos" )
      cPrefix  := "UbAuxVi-"
      exit
   case "S"
      UB->( ordSetFocus( "subicacion" ) )
      cCaption := i18n( "Selección de Ubicaciones de Software" )
      cPrefix  := "UbAuxSo-"
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   UB->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "UB"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| UB->ubUbicaci }
   oCol:cHeader  := i18n( "Ubicación" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown := {|nKey| UbTeclas( nKey, oBrw, , cTipo, oDlg ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg prompt i18n( "&Nueva" );
      ACTION ( UbForm( oBrw, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( UbForm( oBrw, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( UbBorrar( oBrw, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( UbBuscar( oBrw, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := UB->ubUbicaci
      if oGet != NIL
         oGet:Refresh()
      endif
   endif

   UB->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", cPrefix + "State", oBrw:SaveState()    )

return nil
/*_____________________________________________________________________________*/

function UbTabs( oBrw, nOpc, cTipo, oCont, cContTitle )

   switch cTipo
   case "L"
      UB->( ordSetFocus( "lubicacion" ) )
      exit
   case "M"
      UB->( ordSetFocus( "mubicacion" ) )
      exit
   case "V"
      UB->( ordSetFocus( "vubicacion" ) )
      exit
   case "S"
      UB->( ordSetFocus( "subicacion" ) )
      exit
   end switch

   UB->( dbGoTop() )
   oBrw:refresh()
   RefreshCont( oCont, "UB", cContTitle )

return nil
/*_____________________________________________________________________________*/

function UbTeclas( nKey, oBrw, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      UbForm( oBrw, "add", cTipo, oCont, , cContTitle )
      exit
   case VK_RETURN
      UbForm( oBrw, "edt", cTipo, oCont, , cContTitle )
      exit
   case VK_DELETE
      UbBorrar( oBrw, oCont, cTipo, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      endif
      if nKey >= 65 .AND. nKey <= 90
         UbBuscar( oBrw, oCont, Chr( nKey ), cTipo, cContTitle )
      endif
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function UbR( cVar, cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // libros
   case "L"

      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiUbicaci ) ) == RTrim( Upper( cOld ) )
            replace LI->LiUbicaci with cVar
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )
      exit

      // discos
   case "M"

      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuUbicaci ) ) == RTrim( Upper( cOld ) )
            replace MU->MuUbicaci with cVar
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )
      exit

      // vídeos
   case "V"

      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViUbicaci ) ) == RTrim( Upper( cOld ) )
            replace VI->ViUbicaci with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // software
   case "S"

      nOrder := SO->( ordNumber() )
      nRecNo := SO->( RecNo()     )
      SO->( dbSetOrder( 0 ) )
      SO->( dbGoTop() )
      while ! SO->( Eof() )
         if RTrim( Upper( SO->SoGuardado ) ) == RTrim( Upper( cOld ) )
            replace SO->SoGuardado with cVar
            SO->( dbCommit() )
         endif
         SO->( dbSkip() )
      end while
      SO->( dbSetOrder( nOrder ) )
      SO->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function UbDelR( cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // libros
   case "L"

      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiUbicaci ) ) == RTrim( Upper( cOld ) )
            replace LI->LiUbicaci with Space( 60 )
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )
      exit

      // discos
   case "M"

      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuUbicaci ) ) == RTrim( Upper( cOld ) )
            replace MU->MuUbicaci with Space( 60 )
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )
      exit

      // vídeos
   case "V"

      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViUbicaci ) ) == RTrim( Upper( cOld ) )
            replace VI->ViUbicaci with Space( 60 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // software
   case "S"

      nOrder := SO->( ordNumber() )
      nRecNo := SO->( RecNo()     )
      SO->( dbSetOrder( 0 ) )
      SO->( dbGoTop() )
      while ! SO->( Eof() )
         if RTrim( Upper( SO->SoGuardado ) ) == RTrim( Upper( cOld ) )
            replace SO->SoGuardado with Space( 60 )
            SO->( dbCommit() )
         endif
         SO->( dbSkip() )
      end while
      SO->( dbSetOrder( nOrder ) )
      SO->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function UbEjemplares( oBrw, cTipo )

   local oDlg
   local oBrwEj
   local oBrwEjCol
   local oBtn

   local cCaption   := ""
   local cAlias     := ""
   local cUbicaci   := UB->UbUbicaci
   local bLDClick   := {|| NIL }
   local cPrefix    := ""

   local cBrwState  := ""

   if UbDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cCaption  := i18n( "Libros de" ) +" "+ cUbicaci
      cAlias    := "LI"
      cPrefix   := "UbExtEjLi-"
      bLDClick  := {|| LiForm( oBrwEj, "edt" ) }
      exit
   case "M"
      cCaption  := i18n( "Discos de" ) +" "+ cUbicaci
      cAlias    := "MU"
      cPrefix   := "UbExtEjMu-"
      bLDClick  := {|| MuForm( oBrwEj, "edt" ) }
      exit
   case "V"
      cCaption  := i18n( "Vídeos de" ) +" "+ cUbicaci
      cAlias    := "VI"
      cPrefix   := "UbExtEjVi-"
      bLDClick  := {|| ViForm( oBrwEj, "edt" ) }
      exit
   case "S"
      cCaption  := i18n( "Software de" ) +" "+ cUbicaci
      cAlias    := "SO"
      cPrefix   := "UbExtEjSo-"
      bLDClick  := {|| SoForm( oBrwEj, "edt" ) }
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "MA_EJEMPLARES" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   // browse: estructura
   oBrwEj := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrwEj )

   oBrwEj:cAlias := cAlias

   // browse: columnas
   switch cTipo

      // libros
   case "L"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| LI->LiCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| LI->LiTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| LI->LiAutor }
      oBrwEjCol:cHeader  := i18n( "Autor" )
      oBrwEjCol:nWidth   := 115
      exit

      // música
   case "M"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuAutor }
      oBrwEjCol:cHeader  := i18n( "Intérprete" )
      oBrwEjCol:nWidth   := 115
      exit

      // vídeos
   case "V"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViNumero }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViDirector }
      oBrwEjCol:cHeader  := i18n( "Director" )
      oBrwEjCol:nWidth   := 120
      exit

      // software
   case "S"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| SO->SoCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| SO->SoTitulo }
      oBrwEjCol:cHeader  := i18n( "Nombre" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| SO->SoNumSer }
      oBrwEjCol:cHeader  := i18n( "Nº Serie" )
      oBrwEjCol:nWidth   := 110
      exit

   end switch

   // browse: configuración
   AEval( oBrwEj:aCols, {|oCol| oCol:bLDClickData := {|| Eval( bLDClick ) } } )
   oBrwEj:lHScroll := .F.
   oBrwEj:SetRDD()
   oBrwEj:CreateFromResource( 100 )
   oDlg:oClient    := oBrwEj
   oBrwEj:RestoreState( cBrwState )
   oBrwEj:nRowHeight := 20

   ( cAlias )->( ordSetFocus( "ubicacion" ) )
   ( cAlias )->( ordScope( 0, Upper( RTrim(cUbicaci) ) ) )
   ( cAlias )->( ordScope( 1, Upper( RTrim(cUbicaci) ) ) )
   ( cAlias )->( dbGoTop() )

   REDEFINE BUTTON oBtn ID IDOK OF oDlg ;
      ACTION ( oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on INIT ( oDlg:Center( oApp():oWndMain ),;
      oBrwEj:Refresh(), oBrwEj:SetFocus() )

   ( cAlias )->( ordScope( 0, NIL ) )
   ( cAlias )->( ordScope( 1, NIL ) )
   ( cAlias )->( dbGoTop() )

   SetIni( , "Browse", cPrefix + "State", oBrwEj:SaveState() )

   oBrw:setFocus()

   oApp():nEdit--

return nil

/*_____________________________________________________________________________*/

function UbImprimir( oBrw, cTipo )

   //  título                 campo        wd  shw  picture          tot
   //  =====================  ===========  ==  ===  ===============  ===
   local aInf := { { i18n("Ubicación"    ), "UBUBICACI",  0, .T.,            "NO", .F. },;
      { i18n("Nº Ejemplares"), "UBITEMS", 14, .T.,     "@E 99,999", .T. } }
   local nRecno   := UB->(RecNo())
   local nOrder   := UB->(ordSetFocus())
   local aCampos  := { "UBUBICACI", "UBITEMS" }
   local aTitulos := { "Ubicación", "Nº Ejemplares" }
   local aWidth   := { 60, 20 }
   local aShow    := { .T., .T. }
   local aPicture := { "NO", "@E 99,999" }
   local aTotal   := { .F., .T. }
   local oInforme
   local nAt
   local cAlias
   local cTotal

   if UbDbfVacia()
      retu nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cAlias   := "UBLI"
      cTotal   := "Total ubicaciones de libros:"
      exit
   case "M"
      cAlias   := "UBDI"
      cTotal   := "Total ubicaciones de discos:"
      exit
   case "V"
      cAlias   := "UBVI"
      cTotal   := "Total ubicaciones de videos:"
      exit
   case "S"
      cAlias   := "UBSO"
      cTotal   := "Total ubicaciones de software:"
      exit
   end switch

   select UB  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select UB
      if oInforme:nRadio == 1
         UB->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
            oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
      endif
      UB->(dbSetOrder(nOrder))
      UB->(dbGoto(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .T. )
   oApp():nEdit --

return nil

/*____________________________________________________________________________*/

function UbDbfVacia()

   local lReturn := .F.

   if UB->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ninguna ubicación registrada." ) )
      lReturn := .T.
   endif

return lReturn
/*____________________________________________________________________________*/

function UbListL( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   UB->( dbSetOrder(2) )
   UB->( dbGoTop() )
   aNewList := UbListAll(cData)
return aNewList

function UbListM( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   UB->( dbSetOrder(3) )
   UB->( dbGoTop() )
   aNewList := UbListAll(cData)
return aNewList

function UbListV( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   UB->( dbSetOrder(4) )
   UB->( dbGoTop() )
   aNewList := UbListAll(cData)
return aNewList

function UbListS( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   UB->( dbSetOrder(5) )
   UB->( dbGoTop() )
   aNewList := UbListAll(cData)
return aNewList

Function UbListAll(cData)
   local aList := {}
   while ! UB->(Eof())
      if at(Upper(cdata), Upper(UB->UbUbicaci)) != 0 
         AAdd( aList, { UB->UbUbicaci } )
      endif 
      UB->(DbSkip())
   enddo
return alist
