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

function Idiomas()

   local oBar
   local oCol
   local oCont

   local cBrwState  := GetIni( , "Browse", "IdAbm-State", "" )
   local nBrwSplit  := Val( GetIni( , "Browse", "IdAbm-Split", "102" ) )
   local nBrwRecno  := Val( GetIni( , "Browse", "IdAbm-Recno", "1" ) )
   local nBrwOrder  := Val( GetIni( , "Browse", "IdAbm-Order", "1" ) )

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   ID->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Idiomas" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "ID"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| ID->Idioma }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 479

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| IdForm( oApp():oGrid, "edt", oCont ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "ID" ) }
   oApp():oGrid:bKeyDown   := {|nKey| IdTeclas( nKey, oApp():oGrid, oCont, oApp():oDlg ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 18 OF oApp():oDlg

   DEFINE TITLE OF oCont;
      CAPTION tran(ID->(ordKeyNo()),'@E 999,999')+" / "+tran(ID->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_TABLAS"

   @ 24, 05 VMENU oBar SIZE nBrwSplit-10, 150 OF oApp():oDlg  ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oBar;
      CAPTION i18n("Idiomas");
      HEIGHT 25 ;
		COLOR GetSysColor(9), oApp():nClrBar 	

   DEFINE VMENUITEM OF obar         ;
      HEIGHT 10 SEPARADOR

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( IdForm( oApp():oGrid, "add", oCont, ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( IdForm( oApp():oGrid, "edt", oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( IdForm( oApp():oGrid, "dup", oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( IdBorrar( oApp():oGrid, oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( IdBuscar( oApp():oGrid, oCont, ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( IdImprimir( oApp():oGrid ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "IdAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Idioma")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( IdTabs( oApp():oGrid, nBrwOrder, oCont ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= ID->( ordKeyCount() )
      ID->( dbGoto( nBrwRecno ) )
   end if

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      IdTabs( oApp():oGrid, nBrwOrder, oCont ),;
      oApp():oGrid:SetFocus() );
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", "IdAbm-State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", "IdAbm-Order", ID->( ordNumber() ) ),;
      SetIni( , "Browse", "IdAbm-Recno", ID->( RecNo() ) ),;
      SetIni( , "Browse", "IdAbm-Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oBar:End(), oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function IdForm( oBrw, cModo, oCont, cClave )

   local oDlg
   local aGet         := Array( 02 )
   local cCaption
   local lIdOk        := .F.
   local nRecBrw      := ID->( RecNo() )
   local nRecAdd      := 0
   local cOldIdioma   := ID->Idioma
   local cIdIdioma    := ""

   if cModo == "edt" .OR. cModo == "dup"
      if IdDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if ID->( Eof() ) .AND. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      cCaption  := i18n( "Añadir un Idioma" )
      nRecAdd   := ID->( RecNo() )
      if cClave != NIL
         cIdIdioma := cClave
      else
         cIdIdioma := Space(15)
      end if
      // modificar
   case cModo == "edt"
      cCaption := i18n( "Modificar un Idioma" )
      cIdIdioma := ID->Idioma
      // duplicar
   case cModo == "dup"
      cCaption := i18n( "Duplicar un Idioma" )
      cIdIdioma := ID->Idioma
   end case

   DEFINE DIALOG oDlg RESOURCE "ID_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE get aGet[02] ;
      var cIdIdioma ;
      ID 100 ;
      OF oDlg ;
      UPDATE ;
      valid IdClave( cIdIdioma, aGet[02], cModo )

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
         ID->( dbAppend() )
         replace ID->Idioma with cIdIdioma
         ID->( dbCommit() )
         nRecBrw := ID->( RecNo() )
         if cClave != NIL
            cClave := cIdIdioma
         endif
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk
         ID->( dbGoto( nRecBrw ) )
         if ID->Idioma != cIdIdioma
            msgRun( i18n( "Revisando el fichero de idiomas. Espere un momento..." ), oApp():cAppName, ;
               {|| IdR( cIdIdioma, ID->Idioma ) } )
         endif
         replace ID->Idioma with cIdIdioma
         ID->( dbCommit() )
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         ID->( dbAppend() )
         replace ID->Idioma with cIdIdioma
         ID->( dbCommit() )
         nRecBrw := ID->( RecNo() )
      endif
   end case
   if lIdOk == .T.
      oAGet():lId := .T.
      oAGet():Load()
   endif

   ID->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "ID" )
   end if
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   end if

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function IdBorrar( oBrw, oCont )

   local nRecord := ID->( RecNo() )
   local nNext

   local cItem    := ""
   local cTipoMsg := ""

   if IdDbfVacia()
      return nil
   end if

   if msgYesNo( i18n("Si borra este Idioma, se borrará en todos los ficheros en que aparezca. ¿Está seguro de querer eliminarlo?") ;
         +CRLF+CRLF+ Trim( ID->Idioma ) )
      msgRun( i18n( "Revisando el fichero de Idiomas. Espere un momento..." ), oApp():cAppName, ;
         {|| IdDelR( ID->Idioma ) } )
      ID->( dbSkip() )
      nNext := ID->( RecNo() )
      ID->( dbGoto( nRecord ) )
      ID->( dbDelete() )
      ID->( dbGoto( nNext ) )
      if ID->( Eof() ) .OR. nNext == nRecord
         ID->( dbGoBottom() )
      end if
      oAGet():lId := .T.
      oAGet():Load()
   end if

   if oCont != NIL
      RefreshCont( oCont, "ID" )
   end if
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function IdBuscar( oBrw, oCont, cChr )

   local oDlg
   local oGet

   local cPrompt  := i18n( "Introduzca el Idioma" )
   local cField   := i18n( "Idioma:" )
   local cGet     := Space( 15 )
   local nRecNo   := ID->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if IdDbfVacia()
      return nil
   end if

   oApp():nEdit++

   lFecha  := ValType( cGet ) == "D"

   DEFINE DIALOG oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Idiomas" )
   oDlg:SetFont(oApp():oFont)

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
         {|| IdWildSeek(RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         msgStop( i18n("No encuentro ese idioma.") )
         ID->(dbGoto(nRecno))
      else
         IdEncontrados(aBrowse, oApp():oDlg)
      endif
   end if

   if oCont != NIL
      RefreshCont( oCont, "ID" )
   end if
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function IdWildSeek( cGet, aBrowse )

   local nRecno   := ID->(RecNo())

   ID->(dbGoTop())
   do while ! ID->(Eof())
      if cGet $ Upper(ID->Idioma)
         AAdd(aBrowse, {ID->Idioma, ID->(RecNo())})
      endif
      ID->(dbSkip())
   enddo

   ID->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function IdEncontrados( aBrowse, oParent )

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ID->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Idioma"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   ID->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ID->(dbGoto(aBrowse[oBrowse:nArrayAt, 2])),;
      IdForm(oBrowse,"edt",oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ID->(dbGoto(aBrowse[oBrowse:nArrayAt, 2])),;
      IdForm(oBrowse,"edt",oDlg)),) }
   oBrowse:bChange    := {|| ID->(dbGoto(aBrowse[oBrowse:nArrayAt, 2])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (ID->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function IdTabAux( cGet, oGet, oVitem )

   local oDlg
   local oBrw
   local oCol
   local aBtn       := Array( 06 )
   local lIdOk      := .F.
   local aPoint := iif(oGet!=NIL,AdjustWnd( oGet, 271*2, 150*2 ),{1.3*oVItem:nTop(),oApp():oGrid:nLeft})
   local nOrder     := ID->( ordNumber() )

   local cBrwState  := ""

   ID->( ordSetFocus( "idioma" ) )
   ID->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "IdAux-State", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE i18n( "Selección de Idiomas" )
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "ID"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| ID->Idioma }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown := {|nKey| IdTeclas( nKey, oBrw, , oDlg ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg prompt i18n( "&Nuevo" );
      ACTION ( IdForm( oBrw, "add" ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( IdForm( oBrw, "edt" ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( IdBorrar( oBrw, ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( IdBuscar( oBrw, , ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := ID->Idioma
      if oGet != NIL
         oGet:Refresh()
      endif
   end if

   ID->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", "IdAux-State", oBrw:SaveState() )

return nil

/*_____________________________________________________________________________*/

function IdR( cVar, cOld )

   local nOrder := 0
   local nRecNo := 0

   // libros
   nOrder := LI->( ordNumber() )
   nRecNo := LI->( RecNo()     )
   LI->( dbSetOrder( 0 ) )
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      if RTrim( Upper( LI->LiIdioma ) ) == RTrim( Upper( cOld ) )
         replace LI->LiIdioma with cVar
         LI->( dbCommit() )
      end if
      LI->( dbSkip() )
   end while
   LI->( dbSetOrder( nOrder ) )
   LI->( dbGoto( nRecNo )     )

   // discos
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( RecNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      if RTrim( Upper( MU->MuIdioma ) ) == RTrim( Upper( cOld ) )
         replace MU->MuIdioma with cVar
         MU->( dbCommit() )
      end if
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoto( nRecNo )     )

   // canciones
   nOrder := CN->( ordNumber() )
   nRecNo := CN->( RecNo()     )
   CN->( dbSetOrder( 0 ) )
   CN->( dbGoTop() )
   while ! CN->( Eof() )
      if RTrim( Upper( CN->CaIdioma ) ) == RTrim( Upper( cOld ) )
         replace CN->CaIdioma with cVar
         CN->( dbCommit() )
      end if
      CN->( dbSkip() )
   end while
   CN->( dbSetOrder( nOrder ) )
   CN->( dbGoto( nRecNo )     )

   // canciones de discos
   nOrder := CD->( ordNumber() )
   nRecNo := CD->( RecNo()     )
   CD->( dbSetOrder( 0 ) )
   CD->( dbGoTop() )
   while ! CD->( Eof() )
      if RTrim( Upper( CD->CdCaIdioma ) ) == RTrim( Upper( cOld ) )
         replace CD->CdCaIdioma with cVar
         CD->( dbCommit() )
      end if
      CD->( dbSkip() )
   end while
   CD->( dbSetOrder( nOrder ) )
   CD->( dbGoto( nRecNo )     )

   // vídeos
   nOrder := VI->( ordNumber() )
   nRecNo := VI->( RecNo()     )
   VI->( dbSetOrder( 0 ) )
   VI->( dbGoTop() )
   while ! VI->( Eof() )
      if RTrim( Upper( VI->ViIdioma ) ) == RTrim( Upper( cOld ) )
         replace VI->ViIdioma with cVar
         VI->( dbCommit() )
      end if
      VI->( dbSkip() )
   end while
   VI->( dbSetOrder( nOrder ) )
   VI->( dbGoto( nRecNo )     )

   // software
   nOrder := SO->( ordNumber() )
   nRecNo := SO->( RecNo()     )
   SO->( dbSetOrder( 0 ) )
   SO->( dbGoTop() )
   while ! SO->( Eof() )
      if RTrim( Upper( SO->SoIdioma ) ) == RTrim( Upper( cOld ) )
         replace SO->SoIdioma with cVar
         SO->( dbCommit() )
      end if
      SO->( dbSkip() )
   end while
   SO->( dbSetOrder( nOrder ) )
   SO->( dbGoto( nRecNo )     )

   // internet
   nOrder := IN->( ordNumber() )
   nRecNo := IN->( RecNo()     )
   IN->( dbSetOrder( 0 ) )
   IN->( dbGoTop() )
   while ! IN->( Eof() )
      if RTrim( Upper( IN->InIdiomaC ) ) == RTrim( Upper( cOld ) )
         replace IN->InIdiomaC with cVar
         IN->( dbCommit() )
      end if
      IN->( dbSkip() )
   end while
   IN->( dbSetOrder( nOrder ) )
   IN->( dbGoto( nRecNo )     )

return nil

/*_____________________________________________________________________________*/

function IdDelR( cOld )

   local nOrder := 0
   local nRecNo := 0

   // libros
   nOrder := LI->( ordNumber() )
   nRecNo := LI->( RecNo()     )
   LI->( dbSetOrder( 0 ) )
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      if RTrim( Upper( LI->LiIdioma ) ) == RTrim( Upper( cOld ) )
         replace LI->LiIdioma with Space( 15 )
         LI->( dbCommit() )
      end if
      LI->( dbSkip() )
   end while
   LI->( dbSetOrder( nOrder ) )
   LI->( dbGoto( nRecNo )     )

   // discos
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( RecNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      if RTrim( Upper( MU->MuIdioma ) ) == RTrim( Upper( cOld ) )
         replace MU->MuIdioma with Space( 15 )
         MU->( dbCommit() )
      end if
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoto( nRecNo )     )

   // canciones
   nOrder := CN->( ordNumber() )
   nRecNo := CN->( RecNo()     )
   CN->( dbSetOrder( 0 ) )
   CN->( dbGoTop() )
   while ! CN->( Eof() )
      if RTrim( Upper( CN->CaIdioma ) ) == RTrim( Upper( cOld ) )
         replace CN->CaIdioma with Space( 15 )
         CN->( dbCommit() )
      end if
      CN->( dbSkip() )
   end while
   CN->( dbSetOrder( nOrder ) )
   CN->( dbGoto( nRecNo )     )

   // canciones de discos
   nOrder := CD->( ordNumber() )
   nRecNo := CD->( RecNo()     )
   CD->( dbSetOrder( 0 ) )
   CD->( dbGoTop() )
   while ! CD->( Eof() )
      if RTrim( Upper( CD->CdCaIdioma ) ) == RTrim( Upper( cOld ) )
         replace CD->CdCaIdioma with Space( 15 )
         CD->( dbCommit() )
      end if
      CD->( dbSkip() )
   end while
   CD->( dbSetOrder( nOrder ) )
   CD->( dbGoto( nRecNo )     )

   // vídeos
   nOrder := VI->( ordNumber() )
   nRecNo := VI->( RecNo()     )
   VI->( dbSetOrder( 0 ) )
   VI->( dbGoTop() )
   while ! VI->( Eof() )
      if RTrim( Upper( VI->ViIdioma ) ) == RTrim( Upper( cOld ) )
         replace VI->ViIdioma with Space( 15 )
         VI->( dbCommit() )
      end if
      VI->( dbSkip() )
   end while
   VI->( dbSetOrder( nOrder ) )
   VI->( dbGoto( nRecNo )     )

   // software
   nOrder := SO->( ordNumber() )
   nRecNo := SO->( RecNo()     )
   SO->( dbSetOrder( 0 ) )
   SO->( dbGoTop() )
   while ! SO->( Eof() )
      if RTrim( Upper( SO->SoIdioma ) ) == RTrim( Upper( cOld ) )
         replace SO->SoIdioma with Space( 15 )
         SO->( dbCommit() )
      end if
      SO->( dbSkip() )
   end while
   SO->( dbSetOrder( nOrder ) )
   SO->( dbGoto( nRecNo )     )

   // internet
   nOrder := IN->( ordNumber() )
   nRecNo := IN->( RecNo()     )
   IN->( dbSetOrder( 0 ) )
   IN->( dbGoTop() )
   while ! IN->( Eof() )
      if RTrim( Upper( IN->InIdiomaC ) ) == RTrim( Upper( cOld ) )
         replace IN->InIdiomaC with Space( 15 )
         IN->( dbCommit() )
      end if
      IN->( dbSkip() )
   end while
   IN->( dbSetOrder( nOrder ) )
   IN->( dbGoto( nRecNo )     )

return nil

/*_____________________________________________________________________________*/

function IdClave( cClave, oGet, cModo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "ID"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   cMsgSi := i18n( "Idioma ya registrado."   )
   cMsgNo := i18n( "Idioma no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
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
            lReturn := IdForm( , "add", , @cClave )
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

function IdTeclas( nKey, oBrw, oCont, oDlg )

   switch nKey
   case VK_INSERT
      IdForm( oBrw, "add", oCont )
      exit
   case VK_RETURN
      IdForm( oBrw, "edt", oCont )
      exit
   case VK_DELETE
      IdBorrar( oBrw, oCont )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      end if
      if nKey >= 65 .AND. nKey <= 90
         IdBuscar( oBrw, oCont, Chr( nKey ) )
      end if
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function IdTabs( oBrw, nOpc, oCont )

   switch nOpc
   case 1
      ID->( ordSetFocus( "idioma" ) )
      exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "ID" )

return nil

/*_____________________________________________________________________________*/

function IdImprimir( oBrw )

   local nRecno   := ID->(RecNo())
   local nOrder   := ID->(ordSetFocus())
   local aCampos  := { "Idioma" }
   local aTitulos := { "Idioma" }
   local aWidth   := { 40 }
   local aShow    := { .T. }
   local aPicture := { "NO" }
   local aTotal   := { .F. }
   local oInforme
   local nAt

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ID" )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select ID
      if oInforme:nRadio == 1
         ID->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport
         oInforme:End(.T.)
      endif
      ID->(dbSetOrder(nOrder))
      ID->(dbGoto(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .T. )
   oApp():nEdit --

return nil

/*_____________________________________________________________________________*/

function IdDbfVacia()

   local lReturn := .F.

   if ID->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún idioma registrado." ) )
      lReturn := .T.
   end if

return lReturn
//_____________________________________________________________________________//

function IdList( aList, cData, oSelf )
   local aNewList := {}
   ID->( dbSetOrder(1) )
   ID->( dbGoTop() )
   while ! ID->(Eof())
      if at(Upper(cdata), Upper(ID->Idioma)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aNewList, { ID->Idioma } )
      endif 
      ID->(DbSkip())
   enddo
return aNewlist
