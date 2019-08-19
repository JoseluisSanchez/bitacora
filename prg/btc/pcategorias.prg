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

function Categorias( cTipo )

   local oBar
   local oCol
   local oCont

   local cCaption   := ""
   local cTitle     := ""
   local cSplSize   := ""
   local cPrefix    := ""

   local cBrwState  := ""
   local nBrwSplit  := 0
   local nBrwRecno  := 0
   local nBrwOrder  := 0

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   CA->( dbGoTop() )

   // preparado para añadir más tipos
   switch cTipo
   case "O"
      CA->( ordSetFocus( 1 ) )
      cCaption := i18n( "Gestión de Categorías de Ocio" )
      cTitle   := i18n( "Categorías" )
      cSplSize := "102"
      cPrefix  := "CaOcAbm-"
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )
   nBrwSplit := Val( GetIni( , "Browse", cPrefix + "Split", cSplSize ) )
   nBrwRecno := Val( GetIni( , "Browse", cPrefix + "Recno", "1" ) )
   nBrwOrder := Val( GetIni( , "Browse", cPrefix + "Order", "1" ) )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := cCaption
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "CA"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| CA->Categoria }
   oCol:cHeader  := i18n( "Categoría" )
   oCol:nWidth   := 479

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| CaForm( oApp():oGrid, "edt", cTipo, oCont ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "CA" ) }
   oApp():oGrid:bKeyDown   := {|nKey| CaTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 18 OF oApp():oDlg

   DEFINE TITLE OF oCont;
      CAPTION tran(CA->(ordKeyNo()),'@E 999,999')+" / "+tran(CA->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_TABLAS"

   @ 24, 05 VMENU oBar SIZE nBrwSplit-10, 150 OF oApp():oDlg  ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oBar;
      CAPTION i18n("Categorias de ocio");
		COLOR GetSysColor(9), oApp():nClrBar ; 	

   DEFINE VMENUITEM OF obar         ;
      HEIGHT 10 SEPARADOR

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Nueva")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( CaForm( oApp():oGrid, "add", cTipo, oCont, ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( CaForm( oApp():oGrid, "edt", cTipo, oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( CaForm( oApp():oGrid, "dup", cTipo, oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( CaBorrar( oApp():oGrid, oCont, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( CaBuscar( oApp():oGrid, oCont, , cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( CaImprimir( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Enviar a Excel"     ;
      IMAGE "16_EXCEL"             ;
      ACTION (CursorWait(), oApp():oGrid:ToExcel(), CursorArrow());
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Configurar rejilla") ;
      IMAGE "16_grid"              ;
      ACTION ( Ut_BrwColConfig( oApp():oGrid, cPrefix + "State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Categoría")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( CaTabs( oApp():oGrid, nBrwOrder, cTipo, oCont ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= CA->( ordKeyCount() )
      CA->( dbGoto( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      CaTabs( oApp():oGrid, nBrwOrder, cTipo, oCont ),;
      oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", cPrefix + "State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", cPrefix + "Order", CA->( ordNumber() ) ),;
      SetIni( , "Browse", cPrefix + "Recno", CA->( RecNo() ) ),;
      SetIni( , "Browse", cPrefix + "Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oBar:End(), oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function CaForm( oBrw, cModo, cTipo, oCont, cClave )

   local oDlg
   local oGet

   local lIdOk        := .F.
   local nRecBrw      := CA->( RecNo() )
   local nRecAdd      := 0
   local cOldCateg    := CA->Categoria
   local cCaption     := ""
   local cSayTipo     := ""
   local cTipoMsg     := ""

   local cCaCategoria := ""
   local cCaTipo      := ""

   if cModo == "edt" .OR. cModo == "dup"
      if CaDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if CA->( Eof() ) .AND. cModo != "add"
      return nil
   endif

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      cCaption := i18n( "Añadir " )
      switch cTipo
      case "O"
         cCaption := i18n("Añadir una Categoría de Ocio")
         exit
      end switch
      nRecAdd := CA->( RecNo() )
      if cClave != NIL
         cCaCategoria := cClave
      else
         cCaCategoria := Space(30)
      endif
      // modificar
   case cModo == "edt"
      switch cTipo
      case "O"
         cCaption := i18n("Modificar una Categoría de Ocio")
         exit
      end switch
      cCaCategoria := CA->Categoria
      // duplicar
   case cModo == "dup"
      switch cTipo
      case "O"
         cCaption := i18n("Duplicar una Categoría de Ocio")
         exit
      end switch
      cCaCategoria := CA->Categoria
   end case

   DEFINE DIALOG oDlg RESOURCE "CA_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE get oGet ;
      var cCaCategoria ;
      ID 100 ;
      OF oDlg ;
      UPDATE ;
      valid CaClave( cCaCategoria, oGet, cModo, cTipo )

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
         CA->( dbAppend() )
         replace CA->Categoria with cCaCategoria
         replace CA->Tipo      with cTipo
         CA->( dbCommit() )
         nRecBrw := CA->( RecNo() )
         if cClave != NIL
            cClave := cCaCategoria
         endif
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk
         if CA->Categoria != cCaCategoria
            msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
               {|| CaR( cCaCategoria, CA->Categoria, cTipo ) } )
         endif
         replace CA->Categoria with cCaCategoria
         CA->( dbCommit() )
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         CA->( dbAppend() )
         replace CA->Categoria with cCaCategoria
         replace CA->Tipo      with cTipo
         CA->( dbCommit() )
         nRecBrw := CA->( RecNo() )
      endif
   end case

   if lIdOk
      oAGet():lCa := .T.
      oAGet():Load()
   endif

   CA->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "CA" )
   endif
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   endif

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function CaBorrar( oBrw, oCont, cTipo )

   local nRecord := CA->( RecNo() )
   local nNext

   local cItem    := ""
   local cTipoMsg := ""

   if CaDbfVacia()
      return nil
   endif

   if msgYesNo( i18n( "Si borra esta Categoría, se borrará en todos los ficheros en que aparezca. ¿Está seguro de querer eliminarla?" ) +CRLF+CRLF ;
         + Trim( CA->Categoria ) )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
         {|| CaDelR( CA->Categoria, cTipo ) } )
      CA->( dbSkip() )
      nNext := CA->( RecNo() )
      CA->( dbGoto( nRecord ) )
      CA->( dbDelete() )
      CA->( dbGoto( nNext ) )
      if CA->( Eof() ) .OR. nNext == nRecord
         CA->( dbGoBottom() )
      endif
      oAGet():lCa := .T.
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont( oCont, "CA" )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function CaBuscar( oBrw, oCont, cChr, cTipo )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local cCaption := ""
   local cNoFind  := ""
   local nRecNo   := CA->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.

   if CaDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "O"
      cPrompt  := i18n( "Introduzca el Nombre de la Categoría de Ocio" )
      cCaption := i18n( "Búsqueda de Categorías de Ocio" )
      cNoFind  := i18n( "No encuentro esa Categoría de Ocio." )
      exit
   end switch

   cField  := i18n( "Nombre:" )
   cGet    := Space( 30 )

   lFecha  := ValType( cGet ) == "D"

   DEFINE DIALOG oDlg RESOURCE "DLG_BUSCAR" TITLE cCaption
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

   ACTIVATE DIALOG oDlg CENTERED ;
      on INIT ( oDlg:Center( oApp():oWndMain ) )

   if lIdOk
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      endif
      if ! CA->( dbSeek( cGet, .T. ) )
         msgAlert( cNoFind )
         CA->( dbGoto( nRecno ) )
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "CA" )
   endif
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil

/*_____________________________________________________________________________*/

function CaTabAux( cGet, oGet, cTipo )

   local oDlg
   local oBrw
   local oCol
   local aBtn       := Array( 06 )

   local lIdOk      := .F.
   local aPoint     := AdjustWnd( oGet, 268*2, 157*2 )
   local cCaption   := ""
   local nOrder     := CA->( ordNumber() )
   local cPrefix    := ""

   local cBrwState  := ""

   cTipo := Upper( cTipo )

   switch cTipo
   case "O"
      CA->( ordSetFocus( 1 ) )
      cCaption := i18n( "Selección de Categorías de Ocio" )
      cPrefix  := "CaOcAux-"
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   CA->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "CA"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| CA->Categoria }
   oCol:cHeader  := i18n( "Categoría" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown := {|nKey| CaTeclas( nKey, oBrw, , cTipo, oDlg ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg prompt i18n( "&Nueva" );
      ACTION ( CaForm( oBrw, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( CaForm( oBrw, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( CaBorrar( oBrw, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( CaBuscar( oBrw, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := CA->Categoria
      oGet:Refresh()
   endif

   CA->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", cPrefix + "State", oBrw:SaveState()    )

return nil

/*_____________________________________________________________________________*/

function CaR( cVar, cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // categorías de ocio
   case "O"

      // agenda: categoría de ocio
      nOrder := AG->( ordNumber() )
      nRecNo := AG->( RecNo()     )
      AG->( dbSetOrder( 0 ) )
      AG->( dbGoTop() )
      while ! AG->( Eof() )
         if RTrim( Upper( AG->PeOCategor ) ) == RTrim( Upper( cOld ) )
            replace AG->PeOCategor with cVar
            AG->( dbCommit() )
         endif
         AG->( dbSkip() )
      end while
      AG->( dbSetOrder( nOrder ) )
      AG->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function CaDelR( cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // categorías de ocio
   case "O"

      // agenda: categoría de ocio
      nOrder := AG->( ordNumber() )
      nRecNo := AG->( RecNo()     )
      AG->( dbSetOrder( 0 ) )
      AG->( dbGoTop() )
      while ! AG->( Eof() )
         if RTrim( Upper( AG->PeOCategor ) ) == RTrim( Upper( cOld ) )
            replace AG->PeOCategor with Space( 38 )
            AG->( dbCommit() )
         endif
         AG->( dbSkip() )
      end while
      AG->( dbSetOrder( nOrder ) )
      AG->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function CaClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "CA"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   switch cTipo
   case "O"
      cMsgSi := i18n( "Categoría de Ocio ya registrada." )
      cMsgNo := i18n( "Categoría de Ocio no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 1
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
      end case
   else
      do case
      case cModo == "add" .OR. cModo == "edt" .OR. cModo == "dup"
         lReturn := .T.
      case cModo == "aux"
         if msgYesNo( cMsgNo )
            lReturn := CaForm( , "add", cTipo, , @cClave )
            oGet:Refresh()
         else
            lReturn := .F.
         endif
      end case
   endif

   ( cAlias )->( dbSetOrder( nOrder ) )
   ( cAlias )->( dbGoto( nRecno ) )

return lReturn

/*_____________________________________________________________________________*/

function CaTeclas( nKey, oBrw, oCont, cTipo, oDlg )

   switch nKey
   case VK_INSERT
      CaForm( oBrw, "add", cTipo, oCont )
      exit
   case VK_RETURN
      CaForm( oBrw, "edt", cTipo, oCont )
      exit
   case VK_DELETE
      CaBorrar( oBrw, oCont, cTipo )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      endif
      if nKey >= 65 .AND. nKey <= 90
         CaBuscar( oBrw, oCont, Chr( nKey ), cTipo )
      endif
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function CaTabs( oBrw, nOpc, cTipo, oCont )

   switch cTipo
   case "O"
      switch nOpc
      case 1
         CA->( ordSetFocus( "todos" ) ) // cambiar cuando añada más
         exit
      end switch
      exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "CA" )

return nil

/*_____________________________________________________________________________*/

function CaImprimir( oBrw, cTipo )

   local nRecno   := CA->(RecNo())
   local nOrder   := CA->(ordSetFocus())
   local aCampos  := { "CATEGORIA" }
   local aTitulos := { "Categoría" }
   local aWidth   := { 40 }
   local aShow    := { .T. }
   local aPicture := { "NO" }
   local aTotal   := { .F. }
   local oInforme
   local nAt

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "CA" )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select CA
      if oInforme:nRadio == 1
         CA->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport
         oInforme:End(.T.)
      endif
      CA->(dbSetOrder(nOrder))
      CA->(dbGoto(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .T. )
   oApp():nEdit --

return nil

/*_____________________________________________________________________________*/

function CaDbfVacia()

   local lReturn := .F.

   if CA->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ninguna categoría registrada." ) )
      lReturn := .T.
   endif

return lReturn
