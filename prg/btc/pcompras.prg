//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"
#include "TAutoGet.ch"

extern deleted

/*_____________________________________________________________________________*/

function CCompras()

   local oCol
   local oCont
   local cCaption, cTitle, cContTitle, cBitmap
   local cBrwState := GetIni( , "Browse", "AgOAbm-State", "" )
   local nBrwSplit := Val( GetIni( , "Browse", "AgOAbm-Split", "102" ) )
   local nBrwRecno := Val( GetIni( , "Browse", "AgOAbm-Recno", "1" ) )
   local nBrwOrder := Val( GetIni( , "Browse", "AgOAbm-Order", "3" ) )

   local cTipo     := "O" // para compras cTipo := O

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   cCaption    := i18n( "Gestión de Centros de compras" )
   cTitle      := i18n( "Compras" )
   cBitmap   := "BB_COMPRA"
   cContTitle := cTitle+": "

   AG->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Centros de compras" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias  := "AG"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNombre }
   oCol:cHeader  := i18n( "Nombre" )
   oCol:nWidth   := 120

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNotas }
   oCol:cHeader  := i18n( "Notas" )
   oCol:nWidth   := 150

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNEmpresa }
   oCol:cHeader  := i18n( "Empresa" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNContac }
   oCol:cHeader  := i18n( "Contacto" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNDirecc }
   oCol:cHeader  := i18n( "Dirección" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNLocali }
   oCol:cHeader  := i18n( "Localidad" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNCodPos }
   oCol:cHeader  := i18n( "C.Postal" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNTelefo1 }
   oCol:cHeader  := i18n( "Teléfono 1" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNTelefo2 }
   oCol:cHeader  := i18n( "Teléfono 2" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNFax }
   oCol:cHeader  := i18n( "Fax" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNEmail }
   oCol:cHeader  := i18n( "E-mail" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNUrl }
   oCol:cHeader  := i18n( "Sitio web" )
   oCol:nWidth   := 100

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| CcForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "AG", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| CcTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(AG->(ordKeyNo()),'@E 999,999')+" / "+tran(AG->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	 	
      IMAGE cBitmap

   DEFINE VMENUITEM OF oCont        ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( CcForm( oApp():oGrid, "add", cTipo, oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( CcForm( oApp():oGrid, "edt", cTipo, oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( CcForm( oApp():oGrid, "dup", cTipo, oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( CcBorrar( oApp():oGrid, oCont, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( CcBuscar( oApp():oGrid, oCont, , cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( CcImprimir( cTipo, oApp():oGrid ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "AgOAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION 1 SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Nombre")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( CcTabs( oApp():oGrid, oApp():oTab:nOption, cTipo, oCont ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont )

   if nBrwRecno <= AG->( ordKeyCount() )
      AG->( dbGoto( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      CcTabs( oApp():oGrid, oApp():oTab:nOption, @cTipo, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", "AgOAbm-State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", "AgOAbm-Order", oApp():oTab:nOption ),;
      SetIni( , "Browse", "AgOAbm-Recno", AG->( RecNo() ) ),;
      SetIni( , "Browse", "AgOAbm-Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function CCForm( oBrw, cModo, cTipo, oCont, cClave, cContTitle )

   local oDlg
   local oFld
   local aSay        := Array(12)
   local aGet        := Array(12)
   local aBtn        := Array(02)

   local cCaption    := ""
   local lIdOk       := .F.
   local nRecBrw     := AG->( RecNo() )
   local nRecAdd     := 0

   local cPenombre   := ""
   local mPenotas
   local lPepropiet  := .F.
   local lPecompras  := .T.
   local cPeNEmpres  := ""
   local cPeNContac  := ""
   local cPeNdirecc  := ""
   local cPeNcodpos  := ""
   local cPeNlocali  := ""
   local cPeNtelef1  := ""
   local cPeNtelef2  := ""
   local cPeNfax     := ""
   local cPeNemail   := ""
   local cPeNurl     := ""

   if cModo == "edt" .OR. cModo == "dup"
      if AgDbfVacia(cTipo)
         retu nil
      endif
   endif
   // evita la aparición de registro fantasma al hacer doble click en el browse
   if AG->( Eof() ) .AND. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   default cTipo := " "

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      cCaption := i18n("Añadir un centro de compras")
      AG->( dbAppend() )
      nRecAdd := AG->( RecNo() )
      replace AG->PePropiet with .F.
      replace AG->PeCompras with .T.
      if cClave != NIL
         cPenombre := cClave
      else
         cPenombre := Space(50)
      endif
      AG->( dbCommit() )
      // modificar
   case cModo == "edt"
      cCaption := i18n("Modificar un centro de compras")
      cPenombre  := AG->Penombre
      // duplicar
   case cModo == "dup"
      cCaption := i18n("Duplicar un centro de compras")
      cPenombre  := AG->Penombre
   end case

   mPenotas   := AG->Penotas
   lPepropiet := AG->Pepropiet
   lPecompras := AG->Pecompras
   cPeNEmpres := AG->PeNEmpresa
   cPeNContac := AG->PeNContac
   cPeNdirecc := AG->PeNdirecc
   cPeNcodpos := AG->PeNcodpos
   cPeNlocali := AG->PeNlocali
   cPeNtelef1 := AG->PeNtelefo1
   cPeNtelef2 := AG->PeNtelefo2
   cPeNfax    := AG->PeNfax
   cPeNemail  := AG->PeNemail
   cPeNurl    := AG->PeNurl

   DEFINE DIALOG oDlg RESOURCE "AGC_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   // Diálogo principal

   REDEFINE say aSay[1] ID 200 OF oDlg
   REDEFINE say aSay[2] ID 201 OF oDlg
   REDEFINE say aSay[3] ID 202 OF oDlg
   REDEFINE say aSay[4] ID 203 OF oDlg
   REDEFINE say aSay[5] ID 204 OF oDlg
   REDEFINE say aSay[6] ID 205 OF oDlg
   REDEFINE say aSay[7] ID 206 OF oDlg
   REDEFINE say aSay[8] ID 207 OF oDlg
   REDEFINE say aSay[9] ID 208 OF oDlg
   REDEFINE say aSay[10] ID 209 OF oDlg
   REDEFINE say aSay[11] ID 210 OF oDlg
   REDEFINE say aSay[12] ID 211 OF oDlg

   REDEFINE get aGet[01] ;
      var cPeNombre ;
      ID 100 ;
      OF oDlg ;
      valid CcClave( cPeNombre, aGet[01], cModo, cTipo )

   REDEFINE get aGet[02] var mPeNotas   ID 101 OF oDlg MEMO
   REDEFINE get aGet[03] var cPeNEmpres ID 102 OF oDlg UPDATE
   REDEFINE get aGet[04] var cPeNContac ID 103 OF oDlg UPDATE
   REDEFINE get aGet[05] var cPeNDirecc ID 104 OF oDlg UPDATE
   REDEFINE get aGet[06] var cPeNLocali ID 105 OF oDlg UPDATE
   REDEFINE get aGet[07] var cPeNCodPos ID 106 OF oDlg UPDATE
   REDEFINE get aGet[08] var cPeNTelef1 ID 107 OF oDlg UPDATE
   REDEFINE get aGet[09] var cPeNTelef2 ID 108 OF oDlg UPDATE
   REDEFINE get aGet[10] var cPeNFax    ID 109 OF oDlg UPDATE

   REDEFINE get aGet[11] var cPeNEmail  ID 110 OF oDlg UPDATE
   REDEFINE BUTTON aBtn[01];
      ID 310;
      OF oDlg;
      ACTION ( GoMail( cPeNEmail ) )
   aBtn[01]:cToolTip := i18n( "enviar e-mail" )

   REDEFINE get aGet[12] var cPeNUrl   ID 111 OF oDlg UPDATE
   REDEFINE BUTTON aBtn[02];
      ID 311;
      OF oDlg;
      ACTION ( GoWeb( cPeNUrl ) )
   aBtn[02]:cToolTip := i18n( "visitar web" )

   // Diálogo principal
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
         AG->( dbGoto( nRecAdd ) )
         replace AG->Penombre   with cPenombre
         replace AG->Penotas    with mPenotas
         replace AG->Pepropiet  with lPepropiet
         replace AG->PeCompras  with lPeCompras
         replace AG->PeNEmpresa with cPeNEmpres
         replace AG->PeNContac  with cPeNContac
         replace AG->PeNdirecc  with cPeNdirecc
         replace AG->PeNcodpos  with cPeNcodpos
         replace AG->PeNlocali  with cPeNlocali
         replace AG->PeNtelefo1 with cPeNtelef1
         replace AG->PeNtelefo2 with cPeNtelef2
         replace AG->PeNfax     with cPeNfax
         replace AG->PeNemail   with cPeNemail
         replace AG->PeNurl     with cPeNurl
         AG->( dbCommit() )
         nRecBrw := AG->( RecNo() )
         if cClave != NIL
            cClave := cPeNombre
         endif
         // cancelar
      else
         AG->( dbGoto( nRecAdd ) )
         AG->( dbDelete() )
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk == .T.
         AG->( dbGoto( nRecBrw ) )
         if AG->PeNombre != cPeNombre
            msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cVersion,;
               {|| CCRev( cPeNombre, AG->PeNombre ) } )
         endif
         replace AG->Penombre   with cPenombre
         replace AG->Penotas    with mPenotas
         replace AG->Pepropiet  with lPepropiet
         replace AG->PeCompras  with lPeCompras
         replace AG->PeNEmpresa with cPeNEmpres
         replace AG->PeNContac  with cPeNContac
         replace AG->PeNdirecc  with cPeNdirecc
         replace AG->PeNcodpos  with cPeNcodpos
         replace AG->PeNlocali  with cPeNlocali
         replace AG->PeNtelefo1 with cPeNtelef1
         replace AG->PeNtelefo2 with cPeNtelef2
         replace AG->PeNfax     with cPeNfax
         replace AG->PeNemail   with cPeNemail
         replace AG->PeNurl     with cPeNurl
         AG->( dbCommit() )
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         AG->( dbAppend() )
         replace AG->Penombre   with cPenombre
         replace AG->Penotas    with mPenotas
         replace AG->Pepropiet  with lPepropiet
         replace AG->PeCompras  with lPeCompras
         replace AG->PeNEmpresa with cPeNEmpres
         replace AG->PeNContac  with cPeNContac
         replace AG->PeNdirecc  with cPeNdirecc
         replace AG->PeNcodpos  with cPeNcodpos
         replace AG->PeNlocali  with cPeNlocali
         replace AG->PeNtelefo1 with cPeNtelef1
         replace AG->PeNtelefo2 with cPeNtelef2
         replace AG->PeNfax     with cPeNfax
         replace AG->PeNemail   with cPeNemail
         replace AG->PeNurl     with cPeNurl
         AG->( dbCommit() )
         nRecBrw := AG->( RecNo() )
      endif
   end case

   if lIdOk == .T.
      oAGet():lAgCo := .T.
      oAGet():Load()
   endif
   AG->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "AG", cContTitle )
   endif
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   endif
   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function CcBorrar( oBrw, oCont, cTipo, cContTitle )

   local nRecord := AG->( RecNo() )
   local nNext   := 0
   local cMsg     := ""
   local lPepropiet := AG->PePropiet
   local lPecompras := AG->PeCompras

   if AgDbfVacia()
      retu nil
   endif

   cMsg := i18n("Si borra este Centro de Compras, se borrará en todos los ficheros en que aparezca. ¿Está seguro de querer eliminarlo?")

   if msgYesNo( cMsg +CRLF+CRLF+ Trim( AG->peNombre ) )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ),;
         oApp():cAppName, ;
         {|| CcDelRev( AG->peNombre ) } )
      AG->( dbSkip() )
      nNext := AG->( RecNo() )
      AG->( dbGoto( nRecord ) )
      AG->( dbDelete() )
      AG->( dbGoto( nNext ) )
      if AG->( Eof() ) .OR. nNext == nRecord
         AG->( dbGoBottom() )
      endif
      oAGet():lAgCo := .T.
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont( oCont, "AG", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function CCBuscar( oBrw, oCont, cChr, cTipo, cContTitle )

   local oDlg
   local oGet
   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local cCaption := ""
   local cNoFind  := ""
   local nRecNo   := AG->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if AgDbfVacia()
      return nil
   endif

   oApp():nEdit++

   cPrompt  := i18n( "Introduzca el Nombre del Centro de Compra" )
   cCaption := i18n( "Búsqueda de Centros de Compra" )
   cNoFind  := i18n( "No encuentro ese Centro de compra." )

   cField  := i18n( "Nombre:" )
   cGet    := Space( 50 )

   lFecha := ValType( cGet ) == "D" // para un futuro

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

   ACTIVATE DIALOG oDlg ;
      on init oDlg:Center( oApp():oWndMain )

   if lIdOk
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
         {|| CcWildSeek(cTipo, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         msgStop( cNoFind )
         AG->(dbGoto(nRecno))
      else
         CcEncontrados(aBrowse, oApp():oDlg, cTipo)
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "AG", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function CCWildSeek(cTipo, cGet, aBrowse)

   local nRecno   := AG->(RecNo())

   AG->(dbGoTop())
   do while ! AG->(Eof())
      if cGet $ Upper(AG->PeNombre)
         AAdd(aBrowse, {AG->PeNombre, AG->PeNotas, AG->(RecNo())})
      endif
      AG->(dbSkip())
   enddo

   AG->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function CCEncontrados(aBrowse, oParent, cTipo)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := AG->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Centro de compra"
   oBrowse:aCols[2]:cHeader := "Notas"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   AG->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||AG->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      CcForm(oBrowse,"edt",cTipo,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(AG->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      CcForm(oBrowse,"edt",cTipo,oDlg)),) }
   oBrowse:bChange    := {|| AG->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (AG->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function CCClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)
   local cAlias  := "AG"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 3
   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   cMsgSi := i18n( "Centro de Compra ya registrado." )
   cMsgNo := i18n( "Centro de Compra no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")

   if Empty( cClave )
      if cModo == "aux"
         retu .T.
      else
         msgStop( i18n( "Es obligatorio rellenar este campo." ) )
         retu .F.
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
            lReturn := CcForm( , "add", cTipo, , @cClave )
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

function CCRev( cVar, cOld )

   local nOrder := 0
   local nRecNo := 0

   // libros: centros de compra
   nOrder := LI->( ordNumber() )
   nRecNo := LI->( RecNo()     )
   LI->( dbSetOrder( 0 ) )
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      if RTrim( Upper( LI->LiProveed ) ) == RTrim( Upper( cOld ) )
         replace LI->LiProveed with cVar
         LI->( dbCommit() )
      endif
      LI->( dbSkip() )
   end while
   LI->( dbSetOrder( nOrder ) )
   LI->( dbGoto( nRecNo )     )

   // discos: centros de compra
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( RecNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      if RTrim( Upper( MU->MuProveed ) ) == RTrim( Upper( cOld ) )
         replace MU->MuProveed with cVar
         MU->( dbCommit() )
      endif
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoto( nRecNo )     )

   // vídeos: centros de compra
   nOrder := VI->( ordNumber() )
   nRecNo := VI->( RecNo()     )
   VI->( dbSetOrder( 0 ) )
   VI->( dbGoTop() )
   while ! VI->( Eof() )
      if RTrim( Upper( VI->ViProveed ) ) == RTrim( Upper( cOld ) )
         replace VI->ViProveed with cVar
         VI->( dbCommit() )
      endif
      VI->( dbSkip() )
   end while
   VI->( dbSetOrder( nOrder ) )
   VI->( dbGoto( nRecNo )     )

   // software: centros de compra
   nOrder := SO->( ordNumber() )
   nRecNo := SO->( RecNo()     )
   SO->( dbSetOrder( 0 ) )
   SO->( dbGoTop() )
   while ! SO->( Eof() )
      if RTrim( Upper( SO->SoProveed ) ) == RTrim( Upper( cOld ) )
         replace SO->SoProveed with cVar
         SO->( dbCommit() )
      endif
      SO->( dbSkip() )
   end while
   SO->( dbSetOrder( nOrder ) )
   SO->( dbGoto( nRecNo )     )

return nil

/*_____________________________________________________________________________*/

function CCDelRev( cOld )

   local nOrder := 0
   local nRecNo := 0

   // libros: centros de compra
   nOrder := LI->( ordNumber() )
   nRecNo := LI->( RecNo()     )
   LI->( dbSetOrder( 0 ) )
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      if RTrim( Upper( LI->LiProveed ) ) == RTrim( Upper( cOld ) )
         replace LI->LiProveed with Space( 40 )
         LI->( dbCommit() )
      endif
      LI->( dbSkip() )
   end while
   LI->( dbSetOrder( nOrder ) )
   LI->( dbGoto( nRecNo )     )

   // discos: centros de compra
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( RecNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      if RTrim( Upper( MU->MuProveed ) ) == RTrim( Upper( cOld ) )
         replace MU->MuProveed with Space( 40 )
         MU->( dbCommit() )
      endif
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoto( nRecNo )     )

   // vídeos: centros de compra
   nOrder := VI->( ordNumber() )
   nRecNo := VI->( RecNo()     )
   VI->( dbSetOrder( 0 ) )
   VI->( dbGoTop() )
   while ! VI->( Eof() )
      if RTrim( Upper( VI->ViProveed ) ) == RTrim( Upper( cOld ) )
         replace VI->ViProveed with Space( 30 )
         VI->( dbCommit() )
      endif
      VI->( dbSkip() )
   end while
   VI->( dbSetOrder( nOrder ) )
   VI->( dbGoto( nRecNo )     )

   // software: centros de compra
   nOrder := SO->( ordNumber() )
   nRecNo := SO->( RecNo()     )
   SO->( dbSetOrder( 0 ) )
   SO->( dbGoTop() )
   while ! SO->( Eof() )
      if RTrim( Upper( SO->SoProveed ) ) == RTrim( Upper( cOld ) )
         replace SO->SoProveed with Space( 40 )
         SO->( dbCommit() )
      endif
      SO->( dbSkip() )
   end while
   SO->( dbSetOrder( nOrder ) )
   SO->( dbGoto( nRecNo )     )

return nil

/*_____________________________________________________________________________*/

function CCTabAux( cGet, oGet, cTipo )

   local oDlg
   local oBrw
   local oCol
   local aBtn       := Array( 06 )

   local lIdOk      := .F.
   local aPoint     := AdjustWnd( oGet, 268*2, 157*2 )
   local cCaption   := ""
   local nOrder     := AG->( ordNumber() )
   local cPrefix    := ""

   local cBrwState  := ""

   default cTipo := " "
   cTipo := Upper( cTipo )

   cCaption := i18n( "Selección de Centros de Compra" )
   AG->( ordSetFocus( "compras" ) )
   cPrefix := "AgAuxCm-"

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   AG->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "AG"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| AG->peNombre }
   oCol:cHeader  := i18n( "Nombre" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown   := {|nKey| AgTeclas( nKey, oBrw, , cTipo, oDlg ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg ;
      ACTION ( CcForm( oBrw, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( CcForm( oBrw, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( CcBorrar( oBrw, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( CcBuscar( oBrw, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := AG->PeNombre
      oGet:Refresh()
   endif

   AG->( dbSetOrder( nOrder ) )
   SetIni( , "Browse", cPrefix + "State", oBrw:SaveState()    )

return nil

/*_____________________________________________________________________________*/

function CCTabs( oBrw, nOpc, cTipo, oCont, cContTitle )

   AG->( ordSetFocus( "compras" ) )
   AG->( dbGoTop() )
   oBrw:refresh()
   RefreshCont( oCont, "AG", cContTitle )

return nil

/*_____________________________________________________________________________*/

function CCTeclas( nKey, oBrw, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      CcForm( oBrw, "add", cTipo, oCont, , cContTitle )
      exit
   case VK_RETURN
      CcForm( oBrw, "edt", cTipo, oCont, , cContTitle )
      exit
   case VK_DELETE
      CcBorrar( oBrw, oCont, cTipo, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      endif
      if nKey >= 65 .AND. nKey <= 90
         CcBuscar( oBrw, oCont, Chr( nKey ), cTipo, cContTitle )
      endif
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function CCImprimir( cTipo, oBrw )

   //  título                   campo         wd  shw  picture          tot
   //  =======================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Nombre"         ), "PENOMBRE",  0, .T.,            "NO", .F. },;
      { i18n("Notas"          ), "PENOTAS",  0, .T.,            "NO", .F. },;
      { i18n("Personal"       ), "PEPERSONAL",  2, .T.,        "ARRAY1", .F. },;
      { i18n("Negocios"       ), "PENEGOCIOS",  2, .T.,        "ARRAY2", .F. },;
      { i18n("Ocio"           ), "PEOCIO",  2, .T.,        "ARRAY3", .F. },;
      { i18n("Propietario"    ), "PEPROPIET",  2, .T.,        "ARRAY4", .F. },;
      { i18n("Centro Compras" ), "PECOMPRAS",  2, .T.,        "ARRAY5", .F. },;
      { i18n("P. Dirección"   ), "PEPDIRECC",  0, .T.,            "NO", .F. },;
      { i18n("P. Localidad"   ), "PEPLOCALI",  0, .T.,            "NO", .F. },;
      { i18n("P. C.Postal"    ), "PEPCODPOS",  0, .T.,            "NO", .F. },;
      { i18n("P. Teléfono 1"  ), "PEPTELEFO1",  0, .T.,            "NO", .F. },;
      { i18n("P. Teléfono 2"  ), "PEPTELEFO2",  0, .T.,            "NO", .F. },;
      { i18n("P. Fax"         ), "PEPFAX",  0, .T.,            "NO", .F. },;
      { i18n("P. Cumpleaños"  ), "PEPFCHNAC",  0, .T.,            "NO", .F. },;
      { i18n("P. Aniversario" ), "PEPFCHANIV",  0, .T.,            "NO", .F. },;
      { i18n("P. E-mail"      ), "PEPEMAIL",  0, .T.,            "NO", .F. },;
      { i18n("P. Sitio web"   ), "PEPURL",  0, .T.,            "NO", .F. },;
      { i18n("N. Empresa"     ), "PENEMPRESA",  0, .T.,            "NO", .F. },;
      { i18n("N. Contacto"    ), "PENCONTAC",  0, .T.,            "NO", .F. },;
      { i18n("N. Dirección"   ), "PENDIRECC",  0, .T.,            "NO", .F. },;
      { i18n("N. Localidad"   ), "PENLOCALI",  0, .T.,            "NO", .F. },;
      { i18n("N. C.Postal"    ), "PENCODPOS",  0, .T.,            "NO", .F. },;
      { i18n("N. Teléfono 1"  ), "PENTELEFO1",  0, .T.,            "NO", .F. },;
      { i18n("N. Teléfono 2"  ), "PENTELEFO2",  0, .T.,            "NO", .F. },;
      { i18n("N. Fax"         ), "PENFAX",  0, .T.,            "NO", .F. },;
      { i18n("N. E-mail"      ), "PENEMAIL",  0, .T.,            "NO", .F. },;
      { i18n("N. Sitio web"   ), "PENURL",  0, .T.,            "NO", .F. },;
      { i18n("O. Categoría"   ), "PEOCATEGOR",  0, .T.,            "NO", .F. },;
      { i18n("O. Dirección"   ), "PEODIRECC",  0, .T.,            "NO", .F. },;
      { i18n("O. Localidad"   ), "PEOLOCALI",  0, .T.,            "NO", .F. },;
      { i18n("O. C.Postal"    ), "PEOCODPOS",  0, .T.,            "NO", .F. },;
      { i18n("O. Teléfono 1"  ), "PEOTELEFO1",  0, .T.,            "NO", .F. },;
      { i18n("O. Teléfono 2"  ), "PEOTELEFO2",  0, .T.,            "NO", .F. },;
      { i18n("O. Fax"         ), "PEOFAX",  0, .T.,            "NO", .F. },;
      { i18n("O. E-mail"      ), "PEOEMAIL",  0, .T.,            "NO", .F. },;
      { i18n("O. Sitio web"   ), "PEOURL",  0, .T.,            "NO", .F. } }
   local nRecno   := AG->(RecNo())
   local nOrder   := AG->(ordSetFocus())
   local aCampos  := { "PENOMBRE", "PENOTAS", "PENEMPRESA", "PENCONTAC", "PENDIRECC",;
      "PENLOCALI", "PENCODPOS", "PENTELEFO1", "PENTELEFO2", "PENFAX",;
      "PEPEMAIL", "PEPURL" }
   local aTitulos := { "Nombre", "Notas", "Empresa", "Contacto", "Dirección",;
      "Localidad", "C.Postal", "Teléfono 1", "Teléfono 2", "Fax",;
      "E-mail", "Sitio web" }
   local aWidth   := { 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO" }
   local aTotal   := { .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F. }
   local oInforme, oRad
   local nAt
   local cAlias   := "AGO"
   local cTotal   := "Total centros de compra: "
   local aGet     := Array(1)
   local aSay     := Array(2)
   local aBtn     := Array(2)

   if AgDbfVacia(cTipo)
      return nil
   endif

   oApp():nEdit++

   select AG  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   // 1º pestaña: tipo de informe

   //REDEFINE SAY aSay[01] ID 200 OF oInforme:oFld:aDialogs[1]

   REDEFINE RADIO oInforme:oRadio ;
      var oInforme:nRadio ;
      ID 100      ;
      OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()

   if oInforme:Activate()
      nRecno := AG->( RecNo() )
      nOrder := AG->( ordNumber() )
      AG->( dbGoTop() )

      oInforme:Report()
      ACTIVATE REPORT oInforme:oReport ;
         on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
         oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
         oInforme:oReport:EndLine() )
      oInforme:End()
      AG->( ordSetFocus( nOrder ) )
      AG->( dbGoto( nRecno ) )
      oBrw:refresh()
      oBrw:setFocus()
   endif
   oApp():nEdit--

return nil

/*_____________________________________________________________________________*/
function CcList( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AG->( dbSetOrder(3) )
   AG->( dbGoTop() )
   while ! AG->(Eof())
      if at(Upper(cdata), Upper(AG->Penombre)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aNewList, { AG->PeNombre } )
      endif 
      AG->(DbSkip())
   enddo
return anewlist
