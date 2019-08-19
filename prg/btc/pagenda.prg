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

function Agenda(cTipo)

   // cTipo C-contactos P-propietarios
   local oCol
   local oCont
   local cCaption, cTitle, cContTitle, cBitmap
   local cBrwState := GetIni( , "Browse", "Ag"+cTipo+"Abm-State", "" )
   local nBrwSplit := Val( GetIni( , "Browse", "Ag"+cTipo+"Abm-Split", "102" ) )
   local nBrwRecno := Val( GetIni( , "Browse", "Ag"+cTipo+"Abm-Recno", "1" ) )
   local nBrwOrder := Val( GetIni( , "Browse", "Ag"+cTipo+"Abm-Order", iif(cTipo=="C","1","2" )) )

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   switch cTipo
   case "C"
      cCaption    := i18n( "Gestión de Contactos" )
      cTitle      := i18n( "Contactos" )
      cBitmap   := "BB_AGENDA"
      exit
   case "P"
      cCaption    := i18n( "Gestión de Propietarios" )
      cTitle      := i18n( "Propietarios" )
      cBitmap   := "BB_PROPIET"
      exit
   end switch
   cContTitle := cTitle+": "

   AG->( dbGoTop() )
   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Agenda de Contactos" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias  := "AG"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->peNombre }
   oCol:cHeader  := i18n( "Nombre" )
   oCol:nWidth   := 120

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| MemoLine(AG->peNotas,240,1) }
   oCol:cHeader  := i18n( "Notas" )
   oCol:nWidth   := 150

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePDirecc }
   oCol:cHeader  := i18n( "Dirección" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePLocali }
   oCol:cHeader  := i18n( "Localidad" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePCodPos }
   oCol:cHeader  := i18n( "C.Postal" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePTelefo1 }
   oCol:cHeader  := i18n( "Teléfono 1" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePTelefo2 }
   oCol:cHeader  := i18n( "Teléfono 2" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePFax }
   oCol:cHeader  := i18n( "Fax" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| DToC(AG->pePFchNac) }
   oCol:cHeader  := i18n( "Cumpleaños" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| DToC(AG->pePFchAniv) }
   oCol:cHeader  := i18n( "Aniversario" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePEmail }
   oCol:cHeader  := i18n( "E-mail" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| AG->pePUrl }
   oCol:cHeader  := i18n( "Sitio web" )
   oCol:nWidth   := 100

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| AgForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "AG", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| AgTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(AG->(ordKeyNo()),'@E 999,999')+" / "+tran(AG->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE cBitmap

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( AgForm( oApp():oGrid, "add", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( AgForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( AgForm( oApp():oGrid, "dup", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( AgBorrar( oApp():oGrid, oCont, cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( AgBuscar( oApp():oGrid, oCont, , cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( AgImprimir( cTipo, oApp():oGrid ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "AgAbm-State" ), oApp():oGrid:setFocus() ) ;
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
   ACTION ( AgTabs( oApp():oGrid, oApp():oTab:nOption, cTipo, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont )

   if nBrwRecno <= AG->( ordKeyCount() )
      AG->( dbGoto( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      AgTabs( oApp():oGrid, oApp():oTab:nOption, cTipo, oCont, cContTitle ),;
      oApp():oGrid:SetFocus()) ;
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", "Ag"+cTipo+"Abm-State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", "Ag"+cTipo+"Abm-Order", nBrwOrder ),;
      SetIni( , "Browse", "Ag"+cTipo+"Abm-Recno", AG->( RecNo() ) ),;
      SetIni( , "Browse", "Ag"+cTipo+"Abm-Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function AgForm( oBrw, cModo, cTipo, oCont, cClave, cContTitle )

   local oDlg
   local aSay        := Array(12)
   local aGet        := Array(12)
   local aBtn        := Array(4)
   local cCaption    := ""
   local lIdOk       := .F.
   local nRecBrw     := AG->( RecNo() )
   local nRecAdd     := 0

   local cPenombre   := ""
   local mPenotas
   local lPepropiet  := iif(cTipo=="P",.T.,.F.)
   local lPecompras  := .F.
   local cPepdirecc  := ""
   local cPepcodpos  := ""
   local cPeplocali  := ""
   local cPeptelef1  := ""
   local cPeptelef2  := ""
   local cPepfax     := ""
   local cPepemail   := ""
   local cPepurl     := ""
   local dPepfchnac  := Date()
   local lPepnacins  := .F.
   local dPepfchani  := Date()
   local lPepanyins  := .F.
   local cPepcony    := ""

   if cModo == "edt" .OR. cModo == "dup"
      if AgDbfVacia(cTipo)
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if AG->( Eof() ) .AND. cModo != "add"
      return nil
   endif

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      if cTipo == "P"
         cCaption := i18n("Añadir un Propietario")
      elseif cTipo == "C"
         cCaption := i18n("Añadir un Contacto")
      endif
      AG->( dbAppend() )
      nRecAdd := AG->( RecNo() )
      if cTipo == "P"
         replace AG->PePropiet with .T.
         replace AG->PeCompras with .F.
      elseif cTipo == "C"
         replace AG->PePropiet with .F.
         replace AG->PeCompras with .F.
      endif
      if cClave != NIL
         cPenombre := cClave
      else
         cPenombre := Space(50)
      endif
      AG->( dbCommit() )
      // modificar
   case cModo == "edt"
      if cTipo == "P"
         cCaption := i18n("Modificar un Propietario")
      elseif cTipo == "C"
         cCaption := i18n("Modificar un Contacto")
      endif
      cPenombre  := AG->Penombre
      // duplicar
   case cModo == "dup"
      if cTipo == "P"
         cCaption := i18n("Duplicar un Propietario")
      elseif cTipo == "C"
         cCaption := i18n("Duplicarr un Contacto")
      endif
      cPenombre  := AG->Penombre
   end case
   mPenotas   := AG->Penotas
   lPepropiet := AG->Pepropiet
   lPecompras := AG->Pecompras
   cPepdirecc := AG->Pepdirecc
   cPepcodpos := AG->Pepcodpos
   cPeplocali := AG->Peplocali
   cPeptelef1 := AG->Peptelefo1
   cPeptelef2 := AG->Peptelefo2
   cPepfax    := AG->Pepfax
   cPepemail  := AG->Pepemail
   cPepurl    := AG->Pepurl
   dPepfchnac := AG->Pepfchnac
   lPepnacins := AG->Pepnacins
   dPepfchani := AG->Pepfchaniv
   lPepanyins := AG->Pepanyins
   cPepcony   := AG->Pepcony

   DEFINE DIALOG oDlg RESOURCE "AGP_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   // Diálogo principal
   REDEFINE say aSay[01] ID 200 OF oDlg
   REDEFINE say aSay[02] ID 201 OF oDlg
   REDEFINE say aSay[03] ID 202 OF oDlg
   REDEFINE say aSay[04] ID 203 OF oDlg
   REDEFINE say aSay[05] ID 204 OF oDlg
   REDEFINE say aSay[06] ID 205 OF oDlg
   REDEFINE say aSay[07] ID 206 OF oDlg
   REDEFINE say aSay[08] ID 207 OF oDlg
   REDEFINE say aSay[09] ID 208 OF oDlg
   REDEFINE say aSay[10] ID 209 OF oDlg
   REDEFINE say aSay[11] ID 210 OF oDlg
   REDEFINE say aSay[12] ID 211 OF oDlg

   REDEFINE get aGet[01] ;
      var cPeNombre ;
      ID 100 ;
      OF oDlg ;
      valid AgClave( cPeNombre, aGet[01], cModo, cTipo )

   REDEFINE get aGet[02] var mPeNotas ID 101 OF oDlg MEMO

   REDEFINE get aGet[03] var cPePDirecc ID 102 OF oDlg
   REDEFINE get aGet[04] var cPePLocali ID 103 OF oDlg
   REDEFINE get aGet[05] var cPePCodPos ID 104 OF oDlg
   REDEFINE get aGet[06] var cPePTelef1 ID 105 OF oDlg
   REDEFINE get aGet[07] var cPePTelef2 ID 106 OF oDlg
   REDEFINE get aGet[08] var cPePFax    ID 107 OF oDlg

   REDEFINE get aGet[09] ;
      var dPePFchNac ;
      ID 108     ;
      OF oDlg

   REDEFINE BUTTON aBtn[01];
      ID 3   ;
      OF oDlg  ;
      ACTION ( SelecFecha( dPePFchNac, aGet[09] ),;
      aGet[09]:setFocus(),;
      SysRefresh() )

   aBtn[01]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE get aGet[10] ;
      var dPePFchAni ;
      ID 109  ;
      OF oDlg

   REDEFINE BUTTON aBtn[02];
      ID 4   ;
      OF oDlg  ;
      ACTION ( SelecFecha( dPePFchAni, aGet[10] ),;
      aGet[10]:setFocus(),;
      SysRefresh() )

   aBtn[02]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE get aGet[11] ;
      var cPePEmail ;
      ID 110 OF oDlg

   REDEFINE BUTTON aBtn[03];
      ID 5 OF oDlg  ;
      ACTION ( GoMail( cPePEmail ) )

   aBtn[03]:cToolTip := i18n( "enviar e-mail" )

   REDEFINE get aGet[12] ;
      var cPePUrl ;
      ID 111 OF oDlg

   REDEFINE BUTTON aBtn[04];
      ID 6 OF oDlg  ;
      ACTION ( GoWeb( cPePUrl ) )

   aBtn[04]:cToolTip := i18n( "visitar web" )

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
         replace AG->PeCompras  with lPecompras
         replace AG->Pepdirecc  with cPepdirecc
         replace AG->Pepcodpos  with cPepcodpos
         replace AG->Peplocali  with cPeplocali
         replace AG->Peptelefo1 with cPeptelef1
         replace AG->Peptelefo2 with cPeptelef2
         replace AG->Pepfax     with cPepfax
         replace AG->Pepemail   with cPepemail
         replace AG->Pepurl     with cPepurl
         replace AG->Pepfchnac  with dPepfchnac
         replace AG->Pepnacins  with lPepnacins
         replace AG->Pepfchaniv with dPepfchani
         replace AG->Pepanyins  with lPepanyins
         replace AG->Pepcony    with cPepcony
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
               {|| AgRev( cTipo, cPeNombre, AG->PeNombre ) } )
         endif
         replace AG->Penombre   with cPenombre
         replace AG->Penotas    with mPenotas
         replace AG->Pepropiet  with lPepropiet
         replace AG->PeCompras  with lPecompras
         replace AG->Pepdirecc  with cPepdirecc
         replace AG->Pepcodpos  with cPepcodpos
         replace AG->Peplocali  with cPeplocali
         replace AG->Peptelefo1 with cPeptelef1
         replace AG->Peptelefo2 with cPeptelef2
         replace AG->Pepfax     with cPepfax
         replace AG->Pepemail   with cPepemail
         replace AG->Pepurl     with cPepurl
         replace AG->Pepfchnac  with dPepfchnac
         replace AG->Pepnacins  with lPepnacins
         replace AG->Pepfchaniv with dPepfchani
         replace AG->Pepanyins  with lPepanyins
         replace AG->Pepcony    with cPepcony
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
         replace AG->PeCompras  with lPecompras
         replace AG->Pepdirecc  with cPepdirecc
         replace AG->Pepcodpos  with cPepcodpos
         replace AG->Peplocali  with cPeplocali
         replace AG->Peptelefo1 with cPeptelef1
         replace AG->Peptelefo2 with cPeptelef2
         replace AG->Pepfax     with cPepfax
         replace AG->Pepemail   with cPepemail
         replace AG->Pepurl     with cPepurl
         replace AG->Pepfchnac  with dPepfchnac
         replace AG->Pepnacins  with lPepnacins
         replace AG->Pepfchaniv with dPepfchani
         replace AG->Pepanyins  with lPepanyins
         replace AG->Pepcony    with cPepcony
         AG->( dbCommit() )
         nRecBrw := AG->( RecNo() )
      endif
   end case

   if lIdOk == .T.
      if cTipo == "P"
         oAGet():lAgPr := .T.
      elseif cTipo == "C"
         oAGet():lAgTo := .T.
      endif
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

function AgBorrar( oBrw, oCont, cTipo, cContTitle )

   local nRecord := AG->( RecNo() )
   local nNext   := 0
   local cMsg     := ""
   local lPepropiet := AG->PePropiet
   local lPecompras := AG->PeCompras

   if AgDbfVacia(cTipo)
      retu nil
   endif

   if cTipo == "P"
      cMsg := i18n("Si borra este Propietario, se borrará en todos los ficheros en que aparezca. ¿Está seguro de querer eliminarlo?")
   elseif cTipo == "C"
      cMsg := i18n("Si borra este Contacto, se borrará en todos los ficheros en que aparezca. ¿Está seguro de querer eliminarlo?")
   endif

   if msgYesNo( cMsg +CRLF+CRLF+ Trim( AG->peNombre ) )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ),;
         oApp():cAppName, ;
         {|| AgDelRev( cTipo, AG->peNombre ) } )
      AG->( dbSkip() )
      nNext := AG->( RecNo() )
      AG->( dbGoto( nRecord ) )
      AG->( dbDelete() )
      AG->( dbGoto( nNext ) )
      if AG->( Eof() ) .OR. nNext == nRecord
         AG->( dbGoBottom() )
      endif
      if cTipo == "P"
         oAGet():lAgPr := .T.
      elseif cTipo == "C"
         oAGet():lAgTo := .T.
      endif
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont( oCont, "AG", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function AgBuscar( oBrw, oCont, cChr, cTipo, cContTitle )

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

   if AgDbfVacia(cTipo)
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "P"
      cPrompt  := i18n( "Introduzca el Nombre del Propietario" )
      cCaption := i18n( "Búsqueda de Propietarios" )
      cNoFind  := i18n( "No encuentro ese Propietario." )
      exit
   otherwise
      cPrompt  := i18n( "Introduzca el Nombre del Contacto" )
      cCaption := i18n( "Búsqueda de Contactos" )
      cNoFind  := i18n( "No encuentro ese Contacto." )
      exit
   end switch

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
         {|| AgWildSeek(cTipo, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         msgStop( cNoFind )
         AG->(dbGoto(nRecno))
      else
         AgEncontrados(aBrowse, oApp():oDlg, cTipo)
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
function AgWildSeek(cTipo, cGet, aBrowse)

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
function AgEncontrados(aBrowse, oParent, cTipo)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := AG->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Nombre"
   oBrowse:aCols[2]:cHeader := "Notas"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   AG->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||AG->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      AgForm(oBrowse,"edt",cTipo,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(AG->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      AgForm(oBrowse,"edt",cTipo,oDlg)),) }
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

function AgClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)
   local cAlias  := "AG"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0
   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   switch cTipo
   case "P"
      cMsgSi := i18n( "Propietario ya registrado." )
      cMsgNo := i18n( "Propietario no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 2
      exit
   case "C"
      cMsgSi := i18n( "Contacto ya registrado." )
      cMsgNo := i18n( "Contacto no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
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
            lReturn := AgForm( , "add", cTipo, , @cClave )
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

function AgRev( cTipo, cVar, cOld )

   local nOrder := 0
   local nRecNo := 0

   // libros: propietarios & centros de compra & prestatarios
   nOrder := LI->( ordNumber() )
   nRecNo := LI->( RecNo()     )
   LI->( dbSetOrder( 0 ) )
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      if RTrim( Upper( LI->LiPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace LI->LiPropiet with cVar
         LI->( dbCommit() )
      endif
      if RTrim( Upper( LI->LiPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace LI->LiPrestad with cVar
         LI->( dbCommit() )
      endif
      LI->( dbSkip() )
   end while
   LI->( dbSetOrder( nOrder ) )
   LI->( dbGoto( nRecNo )     )

   // discos: propietarios & centros de compra & prestatarios
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( RecNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      if RTrim( Upper( MU->MuPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace MU->MuPropiet with cVar
         MU->( dbCommit() )
      endif
      if RTrim( Upper( MU->MuPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace MU->MuPrestad with cVar
         MU->( dbCommit() )
      endif
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoto( nRecNo )     )

   // vídeos: propietarios & centros de compra & prestatarios
   nOrder := VI->( ordNumber() )
   nRecNo := VI->( RecNo()     )
   VI->( dbSetOrder( 0 ) )
   VI->( dbGoTop() )
   while ! VI->( Eof() )
      if RTrim( Upper( VI->ViPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace VI->ViPropiet with cVar
         VI->( dbCommit() )
      endif
      if RTrim( Upper( VI->ViPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace VI->ViPrestad with cVar
         VI->( dbCommit() )
      endif
      VI->( dbSkip() )
   end while
   VI->( dbSetOrder( nOrder ) )
   VI->( dbGoto( nRecNo )     )

   // software: propietarios & centros de compra & prestatarios
   nOrder := SO->( ordNumber() )
   nRecNo := SO->( RecNo()     )
   SO->( dbSetOrder( 0 ) )
   SO->( dbGoTop() )
   while ! SO->( Eof() )
      if RTrim( Upper( SO->SoPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace SO->SoPropiet with cVar
         SO->( dbCommit() )
      endif
      if RTrim( Upper( SO->SoPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace SO->SoPrestad with cVar
         SO->( dbCommit() )
      endif
      SO->( dbSkip() )
   end while
   SO->( dbSetOrder( nOrder ) )
   SO->( dbGoto( nRecNo )     )

   // notas: prestatarios
   nOrder := NO->( ordNumber() )
   nRecNo := NO->( RecNo()     )
   NO->( dbSetOrder( 0 ) )
   NO->( dbGoTop() )
   while ! NO->( Eof() )
      if RTrim( Upper( NO->NoAQuien ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace NO->NoAQuien with cVar
         NO->( dbCommit() )
      endif
      NO->( dbSkip() )
   end while
   NO->( dbSetOrder( nOrder ) )
   NO->( dbGoto( nRecNo )     )

return nil

/*_____________________________________________________________________________*/

function AgDelRev( cTipo, cOld )

   local nOrder := 0
   local nRecNo := 0

   // libros: propietarios & prestatarios
   nOrder := LI->( ordNumber() )
   nRecNo := LI->( RecNo()     )
   LI->( dbSetOrder( 0 ) )
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      if RTrim( Upper( LI->LiPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace LI->LiPropiet with Space( 40 )
         LI->( dbCommit() )
      endif
      if RTrim( Upper( LI->LiPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace LI->LiPrestad with Space( 30 )
         LI->( dbCommit() )
      endif
      LI->( dbSkip() )
   end while
   LI->( dbSetOrder( nOrder ) )
   LI->( dbGoto( nRecNo )     )

   // discos: propietarios & prestatarios
   nOrder := MU->( ordNumber() )
   nRecNo := MU->( RecNo()     )
   MU->( dbSetOrder( 0 ) )
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      if RTrim( Upper( MU->MuPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace MU->MuPropiet with Space( 40 )
         MU->( dbCommit() )
      endif
      if RTrim( Upper( MU->MuPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace MU->MuPrestad with Space( 30 )
         MU->( dbCommit() )
      endif
      MU->( dbSkip() )
   end while
   MU->( dbSetOrder( nOrder ) )
   MU->( dbGoto( nRecNo )     )

   // vídeos: propietarios & prestatarios
   nOrder := VI->( ordNumber() )
   nRecNo := VI->( RecNo()     )
   VI->( dbSetOrder( 0 ) )
   VI->( dbGoTop() )
   while ! VI->( Eof() )
      if RTrim( Upper( VI->ViPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace VI->ViPropiet with Space( 40 )
         VI->( dbCommit() )
      endif
      if RTrim( Upper( VI->ViPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace VI->ViPrestad with Space( 30 )
         VI->( dbCommit() )
      endif
      VI->( dbSkip() )
   end while
   VI->( dbSetOrder( nOrder ) )
   VI->( dbGoto( nRecNo )     )

   // software: propietarios & prestatarios
   nOrder := SO->( ordNumber() )
   nRecNo := SO->( RecNo()     )
   SO->( dbSetOrder( 0 ) )
   SO->( dbGoTop() )
   while ! SO->( Eof() )
      if RTrim( Upper( SO->SoPropiet ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "P"
         replace SO->SoPropiet with Space( 40 )
         SO->( dbCommit() )
      endif
      if RTrim( Upper( SO->SoPrestad ) ) == RTrim( Upper( cOld ) ) .AND. cTipo == "C"
         replace SO->SoPrestad with Space( 30 )
         SO->( dbCommit() )
      endif
      SO->( dbSkip() )
   end while
   SO->( dbSetOrder( nOrder ) )
   SO->( dbGoto( nRecNo )     )

return nil
/*_____________________________________________________________________________*/

function AgTabAux( cGet, oGet, cTipo, oVItem )

   local oDlg
   local oBrw
   local oCol
   local aBtn       := Array( 06 )
   local lIdOk      := .F.
   local aPoint := iif(oGet!=NIL,AdjustWnd( oGet, 271*2, 150*2 ),{1.3*oVItem:nTop(),oApp():oGrid:nLeft})
   local cCaption   := ""
   local nOrder     := AG->( ordNumber() )
   local cPrefix    := ""
   local cBrwState  := ""

   switch cTipo
   case "P"
      cCaption := i18n( "Selección de Propietarios" )
      AG->( ordSetFocus( "propietarios" ) )
      cPrefix := "AgAuxPr-"
      exit
   case "C"
      cCaption := i18n( "Selección de Contactos de la Agenda" )
      AG->( ordSetFocus( "contactos" ) )
      cPrefix := "AgAuxTo-"
      exit
   end switch

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
      ACTION ( AgForm( oBrw, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( AgForm( oBrw, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( AgBorrar( oBrw, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( AgBuscar( oBrw, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := AG->PeNombre
      if oGet != NIL
         oGet:Refresh()
      endif
   endif

   AG->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", cPrefix + "State", oBrw:SaveState()    )

return nil

/*_____________________________________________________________________________*/

function AgTabs( oBrw, nOpc, cTipo, oCont, cContTitle )

   if cTipo == "C"
      AG->( ordSetFocus( "contactos" ) )
   elseif cTipo == "P"
      AG->( ordSetFocus( "propietarios" ) )
   endif
   AG->( dbGoTop() )
   oBrw:refresh()
   RefreshCont( oCont, "AG", cContTitle )

return nil
/*_____________________________________________________________________________*/

function AgTeclas( nKey, oBrw, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      AgForm( oBrw, "add", cTipo, oCont, , cContTitle )
      exit
   case VK_RETURN
      AgForm( oBrw, "edt", cTipo, oCont, , cContTitle )
      exit
   case VK_DELETE
      AgBorrar( oBrw, oCont, cTipo, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      endif
      if nKey >= 65 .AND. nKey <= 90
         AgBuscar( oBrw, oCont, Chr( nKey ), cTipo, cContTitle )
      endif
      exit
   end switch

return nil
/*_____________________________________________________________________________*/

function AgImprimir( cTipo, oBrw )

   //  título                   campo         wd  shw  picture          tot
   //  =======================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Nombre"         ), "PENOMBRE",  0, .T.,            "NO", .F. },;
      { i18n("Notas"          ), "PENOTAS",  0, .T.,            "NO", .F. },;
      { i18n("P. Dirección"   ), "PEPDIRECC",  0, .T.,            "NO", .F. },;
      { i18n("P. Localidad"   ), "PEPLOCALI",  0, .T.,            "NO", .F. },;
      { i18n("P. C.Postal"    ), "PEPCODPOS",  0, .T.,            "NO", .F. },;
      { i18n("P. Teléfono 1"  ), "PEPTELEFO1",  0, .T.,            "NO", .F. },;
      { i18n("P. Teléfono 2"  ), "PEPTELEFO2",  0, .T.,            "NO", .F. },;
      { i18n("P. Fax"         ), "PEPFAX",  0, .T.,            "NO", .F. },;
      { i18n("P. Cumpleaños"  ), "PEPFCHNAC",  0, .T.,            "NO", .F. },;
      { i18n("P. Aniversario" ), "PEPFCHANIV",  0, .T.,            "NO", .F. },;
      { i18n("P. E-mail"      ), "PEPEMAIL",  0, .T.,            "NO", .F. },;
      { i18n("P. Sitio web"   ), "PEPURL",  0, .T.,            "NO", .F. } }
   local nRecno   := AG->(RecNo())
   local nOrder   := AG->(ordSetFocus())

   local aCampos  := { "PENOMBRE", "PENOTAS", "PEPDIRECC", "PEPLOCALI", "PEPCODPOS",;
      "PEPTELEFO1", "PEPTELEFO2", "PEPFAX", "PEPFCHNAC", "PEPFCHANIV",;
      "PEPEMAIL", "PEPURL" }
   local aTitulos := { "Nombre", "Notas", "Dirección", "Localidad", "C.Postal",;
      "Teléfono 1", "Teléfono 2", "Fax", "Cumpleaños", "Aniversario",;
      "E-mail", "Sitio web" }
   local aWidth   := { 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO" }
   local aTotal   := { .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F. }
   local oInforme, oRad
   local nAt
   local cAlias   := iif(cTipo=="P","AGP","AGC")
   local cTotal   := iif(cTipo=="P","Total propietarios: ","Total contactos: ")
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
      iif(cTipo=="P", AG->(ordSetFocus("propietarios")), AG->(ordSetFocus("contactos")))
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

function AgDbfVacia(cTipo)

   local lReturn := .F.

   if AG->( ordKeyVal() ) == NIL
      if cTipo == 'P'
         msgStop( i18n( "No hay ningún propietario registrado." ) )
      elseif cTipo == 'C'
         msgStop( i18n( "No hay ningún contacto registrado." ) )
      elseif cTipo == 'O'
         msgStop( i18n( "No hay ningún centro de compras registrado." ) )
      endif
      lReturn := .T.
   endif

return lReturn

function AgListP( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AG->( dbSetOrder(2) )
   AG->( dbGoTop() )
   aNewList := AgListAll(cData)
return aNewList

function AgListC( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AG->( dbSetOrder(1) )
   AG->( dbGoTop() )
   aNewList := AgListAll(cData)
return aNewList

Function AgListaLL(cData)
   local aList := {}
   while ! AG->(Eof())
      if at(Upper(cdata), Upper(AG->PeNombre)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aList, { AG->PeNombre } )
      endif 
      AG->(DbSkip())
   enddo
return alist
