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

function Editores( cTipo )

   local oCol
   local oCont

   local cCaption   := ""
   local cTitle     := ""
   local cContTitle := ""
   local cBitmap    := "BB_TABLAS"
   local cSplSize   := ""
   local cPrefix    := ""
   local cHdrEjempl  := ""
   local cTbBmpEjemp := ""
   local cTbTxtEjemp := ""

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

   switch cTipo
   case "L"
      ED->( ordSetFocus( "edlibros" ) )
      cCaption := i18n( "Gestión de Editoriales" )
      cTitle   := i18n( "Editoriales" )
      cBitmap  := "BB_LEDITOR"
      cSplSize := "102"
      cPrefix  := "EdLiEdAbm-"
      cHdrEjempl  := i18n( "Nº Libros" )
      cTbBmpEjemp := "16_libros"
      cTbTxtEjemp := "Ver libros"
      exit
   case "D"
      ED->( ordSetFocus( "eddiscos" ) )
      cCaption := i18n( "Gestión de Productoras de discos" )
      cTitle   := i18n( "Productoras" )
      cBitmap  := "BB_MEDITOR"
      cSplSize := "102"
      cPrefix  := "EdMuPrAbm-"
      cHdrEjempl  := i18n( "Nº Discos" )
      cTbBmpEjemp := "16_discos"
      cTbTxtEjemp := "Ver discos"
      exit
   case "V"
      ED->( ordSetFocus( "edvideos" ) )
      cCaption := i18n( "Gestión de Productoras de cine" )
      cTitle   := i18n( "Productoras" )
      cBitmap  := "BB_VEDITOR"
      cSplSize := "102"
      cPrefix  := "EdViPrAbm-"
      cHdrEjempl  := i18n( "Nº Videos" )
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      exit
   case "S"
      ED->( ordSetFocus( "edsoftware" ) )
      cCaption := i18n( "Gestión de Compañías de software" )
      cTitle   := i18n( "Compañías" )
      cBitmap  := "BB_SEDITOR"
      cSplSize := "102"
      cPrefix  := "EdSoCoAbm-"
      cHdrEjempl  := i18n( "Nº Programas" )
      cTbBmpEjemp := "16_software"
      cTbTxtEjemp := "Ver programas"
      exit
   end switch
   cContTitle := cTitle+": "
   ED->( dbGoTop() )

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )
   nBrwSplit := Val( GetIni( , "Browse", cPrefix + "Split", cSplSize ) )
   nBrwRecno := Val( GetIni( , "Browse", cPrefix + "Recno", "1" ) )
   nBrwOrder := Val( GetIni( , "Browse", cPrefix + "Order", "1" ) )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Autores" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "ED"

   ADD oCol TO oApp():oGrid DATA ED->EdNombre ;
      HEADER "Nombre"   WIDTH 180

   ADD oCol TO oApp():oGrid DATA ED->EdDirecc  ;
      HEADER "Dirección"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA ED->EdLocali  ;
      HEADER "Localidad"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA ED->EdPais ;
      HEADER "País"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA ED->EdTelefo ;
      HEADER "Teléfono"   WIDTH 80

   ADD oCol TO oApp():oGrid DATA ED->EdFax ;
      HEADER "Fax"   WIDTH 80

   ADD oCol TO oApp():oGrid DATA ED->EdEmail ;
      HEADER "E-mail"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA ED->EdURL ;
      HEADER "Sitio web"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA ED->EdNotas ;
      HEADER "Notas"   WIDTH 280

   ADD oCol TO oApp():oGrid DATA ED->EdNumEjem ;
      HEADER cHdrEjempl PICTURE "@E 999,999" ;
      TOTAL 0 WIDTH 80

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| EdForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "ED", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| EdTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21
   oApp():oGrid:lFooter    := .t.
	oApp():oGrid:bClrFooter := {|| { CLR_HRED, GetSysColor(15) } }
 	oApp():oGrid:MakeTotals()

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(ED->(ordKeyNo()),'@E 999,999')+" / "+tran(ED->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE cBitmap

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nueva")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( EdForm( oApp():oGrid, "add", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( EdForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( EdForm( oApp():oGrid, "dup", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( EdBorrar( oApp():oGrid, oCont, cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( EdBuscar( oApp():oGrid, oCont, , cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( EdImprimir( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Visitar sitio web")  ;
      IMAGE "16_internet"             ;
      ACTION ( if( !EdDbfVacia(), GoWeb( ED->edUrl ), oApp():oGrid:setFocus() ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Enviar e-mail")      ;
      IMAGE "16_email"          ;
      ACTION ( if( !EdDbfVacia(), GoMail( ED->edEmail ), oApp():oGrid:setFocus() ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont   ;
      CAPTION cTbTxtEjemp      ;
      IMAGE cTbBmpEjemp        ;
      ACTION ( EdEjemplares( oApp():oGrid, cTipo ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, cPrefix + "State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Nombre")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( EdTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont )

   //if nBrwRecno <= ED->( ordKeyCount() )
   ED->( dbGoto( nBrwRecno ) )
   //endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      EdTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() );
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", cPrefix + "State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", cPrefix + "Order", oApp():oTab:nOption ),;
      SetIni( , "Browse", cPrefix + "Recno", ED->( RecNo() ) ),;
      SetIni( , "Browse", cPrefix + "Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function EdForm( oBrw, cModo, cTipo, oCont, cClave, cContTitle )

   local oDlg
   local aGet        := Array(09)
   local aBtn        := Array(02)

   local lIdOk       := .F.
   local nRecBrw     := ED->( RecNo() )
   local nRecAdd     := 0
   local cCaption    := ""

   local cEdNombre   := ""
   local cEdNotas    := ""
   local cEdDirecc   := ""
   local cEdTelefon  := ""
   local cEdFax      := ""
   local cEdPais     := ""
   local cEdLocali   := ""
   local cEdEmail    := ""
   local cEdUrl      := ""

   if cModo == "edt" .OR. cModo == "dup"
      if EdDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if ED->( Eof() ) .AND. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      switch cTipo
      case "L"
         cCaption := i18n("Añadir una Editorial")
         exit
      case "D"
         cCaption := i18n("Añadir una Productora de Discos")
         exit
      case "V"
         cCaption := i18n("Añadir una Productora de Cine")
         exit
      case "S"
         cCaption := i18n("Añadir una Compañía de Software")
         exit
      end switch
      ED->( dbAppend() )
      replace ED->EdTipo with cTipo
      if cClave != NIL
         cednombre := cClave
      else
         cednombre := Space( 30 )
      endif
      ED->( dbCommit() )
      nRecAdd := ED->( RecNo() )
      // modificar
   case cModo == "edt"
      switch cTipo
      case "L"
         cCaption := i18n("Modificar una Editorial")
         exit
      case "D"
         cCaption := i18n("Modificar una Productora de Discos")
         exit
      case "V"
         cCaption := i18n("Modificar una Productora de Cine")
         exit
      case "S"
         cCaption := i18n("Modificar una Compañía de Software")
         exit
      end switch
      cednombre  := ed->ednombre
      // duplicar
   case cModo == "dup"
      switch cTipo
      case "L"
         cCaption := i18n("Duplicar una Editorial")
         exit
      case "D"
         cCaption := i18n("Duplicar una Productora de Discos")
         exit
      case "V"
         cCaption := i18n("Duplicar una Productora de Cine")
         exit
      case "S"
         cCaption := i18n("Duplicar una Compañía de Software")
         exit
      end switch
      cednombre  := ed->ednombre
   endcase

   cednotas   := ed->ednotas
   ceddirecc  := ed->eddirecc
   cedtelefon := ed->edtelefo
   cedfax     := ed->edfax
   cedlocali  := ed->edlocali
   cedPais    := ed->edpais
   cedemail   := ed->edemail
   cedurl     := ed->edurl

   DEFINE DIALOG oDlg RESOURCE "ED_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE get aGet[01] ;
      var cEdNombre ;
      ID 100 ;
      OF oDlg ;
      VALID ( EdClave( cEdNombre, aGet[01], cModo, cTipo ) )

   REDEFINE get aGet[02] var cEdDirecc  ID 101 OF oDlg
   REDEFINE get aGet[03] var cEdLocali  ID 102 OF oDlg
   REDEFINE get aGet[04] var cEdPais    ID 103 OF oDlg
   REDEFINE get aGet[05] var cEdTelefon ID 104 OF oDlg
   REDEFINE get aGet[06] var cEdFax     ID 105 OF oDlg

   REDEFINE get aGet[07] ;
      var cEdEmail ;
      ID 106 ;
      OF oDlg

   REDEFINE BUTTON aBtn[01];
      ID 110;
      OF oDlg;
      ACTION ( GoMail( cEdEmail ) )

   aBtn[01]:cToolTip := i18n( "enviar e-mail" )

   REDEFINE get aGet[08] ;
      var cEdUrl ;
      ID 107 ;
      OF oDlg

   REDEFINE BUTTON aBtn[02];
      ID 111;
      OF oDlg;
      ACTION ( GoWeb( cEdUrl ) )

   aBtn[02]:cToolTip := i18n( "visitar web" )

   REDEFINE get aGet[09] var cedNotas ID 108 OF oDlg MEMO

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
         ED->( dbGoto( nRecAdd ) )
         replace ED->ednombre    with  cednombre
         replace ED->ednotas     with  cednotas
         replace ED->eddirecc    with  ceddirecc
         replace ED->edtelefo    with  cedtelefon
         replace ED->edfax       with  cedfax
         replace ED->edlocali    with  cedlocali
         replace ED->edpais      with  cedpais
         replace ED->edemail     with  cedemail
         replace ED->edurl       with  cedurl
         ED->( dbCommit() )
         nRecBrw := ED->( RecNo() )
         if cClave != NIL
            cClave := cEdNombre
         endif
         // cancelar
      else
         ED->( dbGoto( nRecAdd ) )
         ED->( dbDelete() )
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk
         ED->( dbGoto( nRecBrw ) )
         if ED->ednombre != cednombre
            msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
               {|| EdR( cEdNombre, ED->EdNombre, cTipo ) } )
         endif
         replace ED->ednombre    with  cednombre
         replace ED->ednotas     with  cednotas
         replace ED->eddirecc    with  ceddirecc
         replace ED->edtelefo    with  cedtelefon
         replace ED->edfax       with  cedfax
         replace ED->edlocali    with  cedlocali
         replace ED->edpais      with  cedpais
         replace ED->edemail     with  cedemail
         replace ED->edurl       with  cedurl
         ED->( dbCommit() )
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         ED->( dbAppend() )
         replace ED->EdTipo      with  cTipo
         replace ED->ednombre    with  cednombre
         replace ED->ednotas     with  cednotas
         replace ED->eddirecc    with  ceddirecc
         replace ED->edtelefo    with  cedtelefon
         replace ED->edfax       with  cedfax
         replace ED->edlocali    with  cedlocali
         replace ED->edpais      with  cedpais
         replace ED->edemail     with  cedemail
         replace ED->edurl       with  cedurl
         ED->( dbCommit() )
         nRecBrw := ED->( RecNo() )
      endif
   endcase

   if lIdOk
      switch cTipo
      case "L"
         oAGet():lEdLi := .T.
         exit
      case "D"
         oAGet():lEdMu := .T.
         exit
      case "V"
         oAGet():lEdVi := .T.
         exit
      case "S"
         oAGet():lEdSo := .T.
         exit
      end switch
      oAGet():Load()
   endif

   ED->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "ED", cContTitle )
   endif
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   endif

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function EdBorrar( oBrw, oCont, cTipo, cContTitle )

   local nRecord := ED->( RecNo() )
   local nNext
   local cMsg    := ""

   if EdDbfVacia()
      return nil
   endif

   switch cTipo
   case "L"
      cMsg  := i18n( "Si borra esta Editorial, se borrará en todos los libros en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "D"
      cMsg  := i18n( "Si borra esta Productora de Discos, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "V"
      cMsg  := i18n( "Si borra esta Productora de Cine, se borrará en todos los vídeos en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "S"
      cMsg  := i18n( "Si borra esta Compañía de Software, se borrará en todos los programas en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   end switch

   if msgYesNo( cMsg +CRLF+CRLF+ Trim( ED->edNombre ) )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
         {|| EdDelR( ED->edNombre, cTipo ) } )
      ED->( dbSkip() )
      nNext := ED->( RecNo() )
      ED->( dbGoto( nRecord ) )
      ED->( dbDelete() )
      ED->( dbGoto( nNext ) )
      if ED->( Eof() ) .OR. nNext == nRecord
         ED->( dbGoBottom() )
      endif
      switch cTipo
      case "L"
         oAGet():lEdLi := .T.
         exit
      case "D"
         oAGet():lEdMu := .T.
         exit
      case "V"
         oAGet():lEdVi := .T.
         exit
      case "S"
         oAGet():lEdSo := .T.
         exit
      end switch
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont( oCont, "ED", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function EdBuscar( oBrw, oCont, cChr, cTipo, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local cCaption := ""
   local cNoFind  := ""
   local nRecNo   := ED->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if EdDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cPrompt  := i18n( "Introduzca el Nombre de la Editorial" )
      cCaption := i18n( "Búsqueda de Editoriales" )
      cNoFind  := i18n( "No encuentro esa Editorial" )
      exit
   case "D"
      cPrompt  := i18n( "Introduzca el Nombre de la Productora de Discos" )
      cCaption := i18n( "Búsqueda de Productoras de Discos" )
      cNoFind  := i18n( "No encuentro esa Productora de Discos" )
      exit
   case "V"
      cPrompt  := i18n( "Introduzca el Nombre de la Productora de Cine" )
      cCaption := i18n( "Búsqueda de Productoras de Cine" )
      cNoFind  := i18n( "No encuentro esa Productora de Cine" )
      exit
   case "S"
      cPrompt  := i18n( "Introduzca el Nombre de la Compañía de software" )
      cCaption := i18n( "Búsqueda de Compañías de software" )
      cNoFind  := i18n( "No encuentro esa Compañía de software" )
      exit
   end switch

   cField  := i18n( "Nombre:" )
   cGet    := Space( 30 )

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
      on INIT ( oDlg:Center( oApp():oWndMain ) )

   if lIdOk
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
         {|| EdWildSeek(cTipo, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         msgStop( cNoFind )
         ED->(dbGoto(nRecno))
      else
         EdEncontrados(aBrowse, oApp():oDlg, cTipo)
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "ED", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function EdWildSeek(cTipo, cGet, aBrowse)

   local nRecno   := ED->(RecNo())

   ED->(dbGoTop())
   do while ! ED->(Eof())
      if cGet $ Upper(ED->EdNombre)
         AAdd(aBrowse, {ED->EdNombre, ED->EdPais, ED->EdURL, ED->(RecNo())})
      endif
      ED->(dbSkip())
   enddo

   ED->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function EdEncontrados(aBrowse, oParent, cTipo)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ED->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   switch cTipo
   case "L"
      oBrowse:aCols[1]:cHeader := i18n( "Editorial" )
      exit
   case "D"
      oBrowse:aCols[1]:cHeader := i18n( "Productora musical" )
      exit
   case "V"
      oBrowse:aCols[1]:cHeader := i18n( "Productora cinematográfica" )
      exit
   case "S"
      oBrowse:aCols[1]:cHeader := i18n( "Compañía de software" )
   end switch

   oBrowse:aCols[2]:cHeader := i18n( "Pais" )
   oBrowse:aCols[3]:cHeader := i18n( "Sitio web" )
   oBrowse:aCols[1]:nWidth  := 160
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:nWidth  := 260
   oBrowse:aCols[4]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   ED->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ED->(dbGoto(aBrowse[oBrowse:nArrayAt, 4])),;
      EdForm(oBrowse,"edt",cTipo,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ED->(dbGoto(aBrowse[oBrowse:nArrayAt, 4])),;
      EdForm(oBrowse,"edt",cTipo,oDlg)),) }
   oBrowse:bChange    := {|| ED->(dbGoto(aBrowse[oBrowse:nArrayAt, 4])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (ED->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function EdTabAux( cGet, oGet, cTipo, oVItem )
   local oDlg
   local oBrw
   local oCol
   local aBtn       := Array( 06 )
   local lIdOk      := .F.
   local aPoint := iif(oGet!=NIL,AdjustWnd( oGet, 271*2, 150*2 ),{1.3*oVItem:nTop(),oApp():oGrid:nLeft})
   local cCaption   := ""
   local nOrder     := ED->( ordNumber() )
   local cPrefix    := ""

   local cBrwState  := ""

   cTipo := Upper( cTipo )

   switch cTipo
   case "L"
      ED->( ordSetFocus( "edlibros" ) )
      cCaption := i18n( "Selección de Editoriales" )
      cPrefix  := "EdLiEdAux-"
      exit
   case "D"
      ED->( ordSetFocus( "eddiscos" ) )
      cCaption := i18n( "Selección de Productoras de discos" )
      cPrefix  := "EdMuPrAux-"
      exit
   case "V"
      ED->( ordSetFocus( "edvideos" ) )
      cCaption := i18n( "Selección de Productoras de cine" )
      cPrefix  := "EdViPrAux-"
      exit
   case "S"
      ED->( ordSetFocus( "edsoftware" ) )
      cCaption := i18n( "Selección de Compañías de software" )
      cPrefix  := "EdSoCoAux-"
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   ED->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "ED"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| ED->edNombre }
   oCol:cHeader  := i18n( "Nombre" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown := {|nKey| EdTeclas( nKey, oBrw, , cTipo, oDlg ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg ;
      ACTION ( EdForm( oBrw, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( EdForm( oBrw, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( EdBorrar( oBrw, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( EdBuscar( oBrw, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := ED->EdNombre
      if oGet != NIL
         oGet:Refresh()
      endif
   endif

   ED->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", cPrefix + "State", oBrw:SaveState()    )

return nil

/*_____________________________________________________________________________*/

function EdR( cVar, cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // Editoriales
   case "L"

      // libros: editorial
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiEditor ) ) == RTrim( Upper( cOld ) )
            replace LI->LiEditor with cVar
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )

      // colecciones: editorial
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "colibros" ) )     // ¡ojo! sólo Editoriales
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->ClEditor ) ) == RTrim( Upper( cOld ) )
            replace CL->ClEditor with cVar
            CL->( dbCommit() )
         endif
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // Productoras de discos
   case "D"

      // discos: editor (compañía)
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuEditor ) ) == RTrim( Upper( cOld ) )
            replace MU->MuEditor with cVar
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // vídeos: bso editor
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViBsoEdi ) ) == RTrim( Upper( cOld ) )
            replace VI->ViBsoEdi with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // colecciones: editor
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "codiscos" ) )         // ¡ojo! sólo Productoras de discos
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->ClEditor ) ) == RTrim( Upper( cOld ) )
            replace CL->ClEditor with cVar
            CL->( dbCommit() )
         endif
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // Productoras de cine
   case "V"

      // vídeos: editor (distribuidor)
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViProduct ) ) == RTrim( Upper( cOld ) )
            replace VI->ViProduct with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // colecciones: editor
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "covideos" ) )         // ¡ojo! sólo Productoras de cine
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->ClEditor ) ) == RTrim( Upper( cOld ) )
            replace CL->ClEditor with cVar
            CL->( dbCommit() )
         endif
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // Compañías de software
   case "S"

      // software: compañía
      nOrder := SO->( ordNumber() )
      nRecNo := SO->( RecNo()     )
      SO->( dbSetOrder( 0 ) )
      SO->( dbGoTop() )
      while ! SO->( Eof() )
         if RTrim( Upper( SO->SoEditor ) ) == RTrim( Upper( cOld ) )
            replace SO->SoEditor with cVar
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

function EdDelR( cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // Editoriales
   case "L"

      // libros: editorial
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiEditor ) ) == RTrim( Upper( cOld ) )
            replace LI->LiEditor with Space( 38 )
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )

      // colecciones: editorial
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "colibros" ) )         // ¡ojo! sólo Editoriales
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->ClEditor ) ) == RTrim( Upper( cOld ) )
            replace CL->ClEditor with Space( 30 )
            CL->( dbCommit() )
         endif
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // Productoras de discos
   case "D"

      // discos: editor (compañía)
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuEditor ) ) == RTrim( Upper( cOld ) )
            replace MU->MuEditor with Space( 40 )
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // vídeos: bso editor
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViBsoEdi ) ) == RTrim( Upper( cOld ) )
            replace VI->ViBsoEdi with Space( 30 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // colecciones: editor
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "codiscos" ) )         // ¡ojo! sólo Productoras de discos
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->ClEditor ) ) == RTrim( Upper( cOld ) )
            replace CL->ClEditor with Space( 30 )
            CL->( dbCommit() )
         endif
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // Productoras de cine
   case "V"

      // vídeos: editor (distribuidor)
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViProduct ) ) == RTrim( Upper( cOld ) )
            replace VI->ViProduct with Space( 30 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // colecciones: editor
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "covideos" ) )         // ¡ojo! sólo Productoras de cine
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->ClEditor ) ) == RTrim( Upper( cOld ) )
            replace CL->ClEditor with Space( 30 )
            CL->( dbCommit() )
         endif
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // Compañías de software
   case "S"

      // software: compañía
      nOrder := SO->( ordNumber() )
      nRecNo := SO->( RecNo()     )
      SO->( dbSetOrder( 0 ) )
      SO->( dbGoTop() )
      while ! SO->( Eof() )
         if RTrim( Upper( SO->SoEditor ) ) == RTrim( Upper( cOld ) )
            replace SO->SoEditor with Space( 40 )
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

function EdClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "ED"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   switch cTipo
   case "L"
      cMsgSi := i18n( "Editorial ya registrada." )
      cMsgNo := i18n( "Editorial no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 1
      exit
   case "D"
      cMsgSi := i18n( "Productora de discos ya registrada." )
      cMsgNo := i18n( "Productora de discos no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 2
      exit
   case "V"
      cMsgSi := i18n( "Productora de cine ya registrada." )
      cMsgNo := i18n( "Productora de cine no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 3
      exit
   case "S"
      cMsgSi := i18n( "Compañía de software ya registrada." )
      cMsgNo := i18n( "Compañía de software no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 4
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
            lReturn := EdForm( , "add", cTipo, , @cClave )
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

function EdTeclas( nKey, oBrw, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      EdForm( oBrw, "add", cTipo, oCont, , cContTitle )
      exit
   case VK_RETURN
      EdForm( oBrw, "edt", cTipo, oCont, , cContTitle )
      exit
   case VK_DELETE
      EdBorrar( oBrw, oCont, cTipo, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      endif
      if nKey >= 65 .AND. nKey <= 90
         EdBuscar( oBrw, oCont, Chr( nKey ), cTipo, cContTitle )
      endif
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function EdEjemplares( oBrw, cTipo )

   local oDlg
   local oBrwEj
   local oBrwEjCol
   local oBtn

   local cCaption   := ""
   local cAlias     := ""
   local cEditor    := ED->EdNombre
   local bLDClick   := {|| NIL }
   local cPrefix    := ""
   local cOrdName   := ""

   local cBrwState  := ""

   if AuDbfVacia()
      return nil
   end if

   oApp():nEdit++

   switch cTipo
   case "L"
      cCaption  := i18n( "Libros de" ) + " " + cEditor
      cAlias    := "LI"
      cPrefix   := "EdExtEjLi-"
      bLDClick  := {|| LiForm( oBrwEj, "edt" ) }
      cOrdName  := "EDITOR"
      exit
   case "D"
      cCaption  := i18n( "Discos de" ) + " " + cEditor
      cAlias    := "MU"
      cPrefix   := "MaExtEjMu-"
      bLDClick  := {|| MuForm( oBrwEj, "edt" ) }
      cOrdName  := "EDITOR"
      exit
   case "V"
      cCaption  := i18n( "Vídeos de" ) + " " + cEditor
      cAlias    := "VI"
      cPrefix   := "MaExtEjVi-"
      bLDClick  := {|| ViForm( oBrwEj, "edt" ) }
      cOrdName  := "EDITOR"
      exit
   case "S"
      cCaption  := i18n( "Software de" ) + " " + cEditor
      cAlias    := "SO"
      cPrefix   := "MaExtEjSo-"
      bLDClick  := {|| SoForm( oBrwEj, "edt" ) }
      cOrdName  := "EDITOR"
      exit
   case "I"
      cCaption  := i18n( "Direcciones de Internet de" ) + " " + cEditor
      cAlias    := "IN"
      cPrefix   := "MaExtEjIn-"
      bLDClick  := {|| InForm( oBrwEj, "edt" ) }
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
   case "D"
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

      // internet
   case "I"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| IN->InCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| IN->InNombre }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 100
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| IN->InDirecc }
      oBrwEjCol:cHeader  := i18n( "Dirección" )
      oBrwEjCol:nWidth   := 100
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| IN->InServic }
      oBrwEjCol:cHeader  := i18n( "Servicio" )
      oBrwEjCol:nWidth   := 90
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

   ( cAlias )->( ordSetFocus( cOrdName ) )
   ( cAlias )->( ordScope( 0, Upper( cEditor ) ) )
   ( cAlias )->( ordScope( 1, Upper( cEditor ) ) )
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

function EdTabs( oBrw, nOpc, cTipo, oCont, cContTitle )

   switch cTipo
   case "L"
      ED->( ordSetFocus( "edlibros" ) )
      exit
   case "D"
      ED->( ordSetFocus( "eddiscos" ) )
      exit
   case "V"
      ED->( ordSetFocus( "edvideos" ) )
      exit
   case "S"
      ED->( ordSetFocus( "edsoftware" ) )
      exit
   end switch
   oBrw:refresh()
   RefreshCont( oCont, "ED", cContTitle )

return nil

/*_____________________________________________________________________________*/

function EdImprimir( oBrw, cTipo )

   local nRecno   := ED->(RecNo())
   local nOrder   := ED->(ordSetFocus())
   local aCampos  := { "EDNOMBRE", "EDDIRECC", "EDLOCALI", "EDPAIS", "EDTELEFO", "EDFAX", "EDEMAIL", "EDURL", "EDNUMEJEM" }
   local aTitulos := { "Nombre", "Dirección", "Localidad", "Pais", "Teléfono", "Fax", "E-mail", "Sitio web", "" }
   local aWidth   := { 20, 20, 20, 10, 20, 20, 20, 20, 20 }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO"  }
   local aTotal   := { .F., .F., .F., .F., .F., .F., .F., .F., .T. }
   local oInforme
   local nAt
   local cAlias
   local cTotal

   if EdDbfVacia()
      retu nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cAlias   := "EDLI"
      cTotal   := "Total editores:"
      aTitulos[9] := "Nº Libros"
      exit
   case "D"
      cAlias   := "EDDI"
      cTotal   := "Total productoras:"
      aTitulos[9] := "Nº Discos"
      exit
   case "V"
      cAlias   := "EDVI"
      cTotal   := "Total productoras:"
      aTitulos[9] := "Nº Videos"
      exit
   case "S"
      cAlias   := "EDSO"
      cTotal   := "Total compañías de software:"
      aTitulos[9] := "Nº Software"
      exit
   end switch

   select CL  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select ED
      if oInforme:nRadio == 1
         ED->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
            oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
            oInforme:oReport:EndLine() )

         oInforme:End(.T.)
      endif
      ED->(dbSetOrder(nOrder))
      ED->(dbGoto(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .T. )
   oApp():nEdit --

return nil

/*_____________________________________________________________________________*/

function EdDbfVacia()

   local lReturn := .F.

   if ED->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún registro." ) )
      lReturn := .T.
   endif

return lReturn

function EdListL( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   ED->( dbSetOrder(1) )
   ED->( dbGoTop() )
   aNewList := EdListAll(cData)
return aNewList

function EdListD( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   ED->( dbSetOrder(2) )
   ED->( dbGoTop() )
   aNewList := EdListAll(cData)
return aNewList

function EdListV( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   ED->( dbSetOrder(3) )
   ED->( dbGoTop() )
   aNewList := EdListAll(cData)
return aNewList

function EdListS( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   ED->( dbSetOrder(4) )
   ED->( dbGoTop() )
   aNewList := EdListAll(cData)
return aNewList

Function EdListaLL(cData)
   local aList := {}
   while ! ED->(Eof())
      if at(Upper(cdata), Upper(ED->Ednombre)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aList, { ED->EdNombre } )
      endif 
      ED->(DbSkip())
   enddo
return alist
