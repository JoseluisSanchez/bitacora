//*
// PROYEC to  ...: Cuaderno de Bitácora
// COPYRIGHT ..: (c) alanit software
// URL ........: www.alanit.com
//*

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"

extern deleted

/*_____________________________________________________________________________*/

function Soportes()

   local oBar
   local oCol
   local oCont
   local cTitle    := "Soportes"
   local cContTitle := cTitle+": "

   local cBrwState  := GetIni( , "Browse", "SmAbm-State", "" )
   local nBrwSplit  := Val( GetIni( , "Browse", "SmAbm-Split", "102" ) )
   local nBrwRecno  := Val( GetIni( , "Browse", "SmAbm-Recno", "1" ) )
   local nBrwOrder  := Val( GetIni( , "Browse", "SmAbm-Order", "1" ) )

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   SM->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Soportes musicales" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "SM"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| SM->SmSoporte }
   oCol:cHeader  := i18n( "Soporte" )
   oCol:nWidth   := 479

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| SmForm( oApp():oGrid, "edt", oCont, cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "SM", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| SmTeclas( nKey, oApp():oGrid, oCont, oApp():oDlg, , cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(SM->(ordKeyNo()),'@E 999,999')+" / "+tran(SM->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_SOPORTES"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( SmForm( oApp():oGrid, "add", oCont, cContTitle) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( SmForm( oApp():oGrid, "edt", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( SmForm( oApp():oGrid, "dup", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( SmBorrar( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( SmBuscar( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( SmImprimir( oApp():oGrid ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "SmAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Soporte")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( SmTabs( oApp():oGrid, nBrwOrder, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= SM->( ordKeyCount() )
      SM->( dbGoto( nBrwRecno ) )
   end if

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      SmTabs( oApp():oGrid, nBrwOrder, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() );
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", "SmAbm-State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", "SmAbm-Order", SM->( ordNumber() ) ),;
      SetIni( , "Browse", "SmAbm-Recno", SM->( RecNo() ) ),;
      SetIni( , "Browse", "SmAbm-Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function SmForm( oBrw, cModo, oCont, cClave, cContTitle )

   local oDlg
   local aGet         := Array( 02 )
   local cCaption
   local lIdOk        := .F.
   local nRecBrw      := SM->( RecNo() )
   local nRecAdd      := 0
   local cOldSoporte  := SM->SmSoporte
   local cSmSoporte   := ""

   if cModo == "edt" .OR. cModo == "dup"
      if SmDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if SM->( Eof() ) .AND. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      cCaption  := i18n( "Añadir un Soporte" )
      nRecAdd   := SM->( RecNo() )
      if cClave != NIL
         cSmSoporte := cClave
      else
         cSmSoporte := Space(20)
      end if
      // modificar
   case cModo == "edt"
      cCaption := i18n( "Modificar un Soporte" )
      cSmSoporte := SM->SmSoporte
      // duplicar
   case cModo == "dup"
      cCaption := i18n( "Duplicar un Soporte" )
      cSmSoporte := SM->SmSoporte
   end case

   DEFINE DIALOG oDlg RESOURCE "SM_FORM" TITLE cCaption
   oDlg:oFont:= oApp():oFont

   REDEFINE get aGet[02] ;
      var cSmSoporte ;
      ID 100 ;
      OF oDlg ;
      UPDATE ;
      valid SmClave( cSmSoporte, aGet[02], cModo )

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
         SM->( dbAppend() )
         replace SM->SmSoporte with cSmSoporte
         SM->( dbCommit() )
         nRecBrw := SM->( RecNo() )
         if cClave != NIL
            cClave := cSmSoporte
         endif
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk
         SM->( dbGoto( nRecBrw ) )
         if SM->SmSoporte != cSmSoporte
            msgRun( i18n( "Revisando el fichero de soportes. Espere un momento..." ), oApp():cAppName, ;
               {|| SmR( cSmSoporte, SM->SmSoporte ) } )
         endif
         replace SM->SmSoporte with cSmSoporte
         SM->( dbCommit() )
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         SM->( dbAppend() )
         replace SM->SmSoporte with cSmSoporte
         SM->( dbCommit() )
         nRecBrw := SM->( RecNo() )
      endif
   end case
   if lIdOk == .T.
      oAGet():lSm := .T.
      oAGet():Load()
   endif

   SM->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "SM", cContTitle )
   end if
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   end if

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function SmBorrar( oBrw, oCont, cContTitle )

   local nRecord := SM->( RecNo() )
   local nNext

   local cItem    := ""
   local cTipoMsg := ""

   if IdDbfVacia()
      return nil
   end if

   if msgYesNo( i18n("Si borra este soporte, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarlo?") ;
         +CRLF+CRLF+ Trim( SM->SmSoporte ) )
      msgRun( i18n( "Revisando el fichero de soportes. Espere un momento..." ), oApp():cAppName, ;
         {|| SmDelR( SM->SmSoporte ) } )
      SM->( dbSkip() )
      nNext := SM->( RecNo() )
      SM->( dbGoto( nRecord ) )
      SM->( dbDelete() )
      SM->( dbGoto( nNext ) )
      if SM->( Eof() ) .OR. nNext == nRecord
         SM->( dbGoBottom() )
      end if
      oAGet():lSm := .T.
      oAGet():Load()
   end if

   if oCont != NIL
      RefreshCont( oCont, "SM", cContTitle )
   end if
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function SmBuscar( oBrw, oCont, cChr, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := i18n( "Introduzca el Soporte" )
   local cField   := i18n( "Soporte:" )
   local cGet     := Space( 20 )
   local nRecNo   := SM->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if IdDbfVacia()
      return nil
   end if

   oApp():nEdit++

   lFecha  := ValType( cGet ) == "D"

   DEFINE DIALOG oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Idiomas" )
   oDlg:oFont:= oApp():oFont

   REDEFINE say prompt cPrompt ID 20 OF oDlg
   REDEFINE say prompt cField  ID 21 OF oDlg

   if cChr != NIL
      if ! lFecha
         cGet := cChr + SubStr( cGet, 1, Len( cGet ) - 1 )
      else
         cGet := CToD( cChr + " -  -    " )
      end if
   end if

   REDEFINE get oGet var cGet ID 101 OF oDlg

   if cChr != NIL
      oGet:bGotFocus := {|| ( oGet:SetColor( CLR_BLACK, rgb( 255, 255, 127 ) ), oGet:SetPos( 2 ) ) }
   end if

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
      end if
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
         {|| SmWildSeek(RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         msgStop( i18n("No encuentro ese soporte.") )
         SM->(dbGoto(nRecno))
      else
         SmEncontrados(aBrowse, oApp():oDlg)
      endif
   end if

   if oCont != NIL
      RefreshCont( oCont, "SM", cContTitle )
   end if
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function SmWildSeek( cGet, aBrowse )

   local nRecno   := SM->(RecNo())

   SM->(dbGoTop())
   do while ! SM->(Eof())
      if cGet $ Upper(SM->SmSoporte)
         AAdd(aBrowse, {SM->SmSoporte, SM->(RecNo())})
      endif
      SM->(dbSkip())
   enddo

   SM->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function SmEncontrados( aBrowse, oParent )

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := SM->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:oFont:= oApp():oFont

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Soporte"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   SM->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||SM->(dbGoto(aBrowse[oBrowse:nArrayAt, 2])),;
      SmForm(oBrowse,"edt",oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(SM->(dbGoto(aBrowse[oBrowse:nArrayAt, 2])),;
      SmForm(oBrowse,"edt",oDlg)),) }
   oBrowse:bChange    := {|| SM->(dbGoto(aBrowse[oBrowse:nArrayAt, 2])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (SM->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function SmTabAux( cGet, oGet )

   local oDlg
   local oBrw
   local oCol
   local aBtn       := Array( 06 )

   local lIdOk      := .F.
   local aPoint     := AdjustWnd( oGet, 268*2, 157*2 )
   local nOrder     := SM->( ordNumber() )

   local cBrwState  := ""

   SM->( ordSetFocus( "soporte" ) )
   SM->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "SmAux-State", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE i18n( "Selección de Soportes" )
   oDlg:oFont:= oApp():oFont

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "SM"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| SM->SmSoporte }
   oCol:cHeader  := i18n( "Soporte" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown := {|nKey| SmTeclas( nKey, oBrw, , oDlg ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg prompt i18n( "&Nuevo" );
      ACTION ( SmForm( oBrw, "add" ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( SmForm( oBrw, "edt" ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( SmBorrar( oBrw, ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( SmBuscar( oBrw, , ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := SM->SmSoporte
      oGet:Refresh()
   end if

   SM->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", "SmAux-State", oBrw:SaveState() )

return nil

/*_____________________________________________________________________________*/

function SmR( cVar, cOld )

   local nOrder := 0
   local nRecNo := 0

   msginfo("SmR() pendiente")
   // discos
 /*
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( recNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( eof() )
      if rTrim( upper( MU->MuIdioma ) ) == rTrim( upper( cOld ) )
         replace MU->MuIdioma with cVar
         MU->( dbCommit() )
      end if
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoTo( nRecNo )     )
 */

return nil

/*_____________________________________________________________________________*/

function SmDelR( cOld )

   local nOrder := 0
   local nRecNo := 0

   msginfo("SmDelR() pendiente")
   // discos
 /*
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( recNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( eof() )
      if rTrim( upper( MU->MuIdioma ) ) == rTrim( upper( cOld ) )
         replace MU->MuIdioma with space( 15 )
         MU->( dbCommit() )
      end if
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoTo( nRecNo )     )
 */

return nil

/*_____________________________________________________________________________*/

function SmClave( cClave, oGet, cModo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "SM"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   cMsgSi := i18n( "Soporte ya registrado."   )
   cMsgNo := i18n( "Soporte no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
   nPkOrd := 1

   if Empty( cClave )
      if cModo == "aux"
         return .T.
      else
         msgStop( i18n( "Es obligatorio rellenar este campo." ) )
         return .F.
      end if
   end if

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
         end if
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
            lReturn := SmForm( , "add", , @cClave )
            oGet:Refresh()
         else
            lReturn := .F.
         end if
      end case
   end if

   ( cAlias )->( dbSetOrder( nOrder ) )
   ( cAlias )->( dbGoto( nRecno ) )

return lReturn

/*_____________________________________________________________________________*/

function SmTeclas( nKey, oBrw, oCont, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      SmForm( oBrw, "add", oCont, , cContTitle )
      exit
   case VK_RETURN
      IdForm( oBrw, "edt", oCont, , cContTitle )
      exit
   case VK_DELETE
      IdBorrar( oBrw, oCont, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      end if
      if nKey >= 65 .AND. nKey <= 90
         SmBuscar( oBrw, oCont, Chr( nKey ), cContTitle )
      end if
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function SmTabs( oBrw, nOpc, oCont, cContTitle )

   switch nOpc
   case 1
      SM->( ordSetFocus( "soporte" ) )
      exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "SM", cContTitle )

return nil

/*_____________________________________________________________________________*/

function SmImprimir( oBrw )

   local nRecno   := SM->(RecNo())
   local nOrder   := SM->(ordSetFocus())
   local aCampos  := { "SmSoporte" }
   local aTitulos := { "Soporte" }
   local aWidth   := { 40 }
   local aShow    := { .T. }
   local aPicture := { "NO" }
   local aTotal   := { .F. }
   local oInforme
   local nAt

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "SM" )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select SM
      if oInforme:nRadio == 1
         SM->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport
         oInforme:End(.T.)
      endif
      SM->(dbSetOrder(nOrder))
      SM->(dbGoto(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .T. )
   oApp():nEdit --

return nil

/*_____________________________________________________________________________*/

function SmDbfVacia()

   local lReturn := .F.

   if SM->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún soporte registrado." ) )
      lReturn := .T.
   end if

return lReturn

function SmList( aList, cData, oSelf )
   local aNewList := {}
   SM->( dbSetOrder(1) )
   SM->( dbGoTop() )
   while ! SM->(Eof())
      if at(Upper(cdata), Upper(SM->SmSoporte)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aNewList, { SM->SmSoporte } )
      endif 
      SM->(DbSkip())
   enddo
return aNewlist
