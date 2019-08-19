//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"
#include "AutoGet.ch"

extern deleted

/*_____________________________________________________________________________*/

function Colecciones( cTipo )

   local oBar
   local oCol
   local oCont
   local cBitmap    := "BB_TABLAS"
   local cCaption    := ""
   local cTitle      := ""
   local cContTitle  := ""
   local cSplSize    := ""
   local cPrefix     := ""
   local cHdrMateria := ""
   local cHdrTomos   := ""
   local cHdrEditor  := ""
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
      CL->( ordSetFocus( "colibros" ) )
      ED->( ordSetFocus( "edlibros" ) )
      cCaption    := i18n( "Gestión de Colecciones de Libros" )
      cTitle      := i18n( "Colecciones" )
      cBitmap   := "BB_LCOLECC"
      cSplSize    := "102"
      cPrefix     := "ClLiClAbm-"
      cHdrMateria := i18n("Materia")
      cHdrTomos   := i18n("Nº Tomos")
      cHdrEditor  := i18n("Editorial")
      cHdrEjempl  := i18n( "Nº Ejemplares" )
      cTbBmpEjemp := "16_libros"
      cTbTxtEjemp := "Ver libros"
      exit
   case "D"
      CL->( ordSetFocus( "codiscos" ) )
      ED->( ordSetFocus( "eddiscos" ) )
      cCaption   := i18n( "Gestión de Colecciones de Discos" )
      cTitle     := i18n( "Colecciones" )
      cBitmap   := "BB_LCOLECC"
      cSplSize   := "102"
      cPrefix    := "ClMuClAbm-"
      cHdrMateria := i18n("Género")
      cHdrTomos  := i18n("Nº Discos")
      cHdrEditor := i18n("Productora")
      cHdrEjempl  := i18n( "Nº Ejemplares" )
      cTbBmpEjemp := "16_discos"
      cTbTxtEjemp := "Ver discos"
      exit
   case "V"
      CL->( ordSetFocus( "covideos" ) )
      ED->( ordSetFocus( "edvideos" ) )
      cCaption   := i18n( "Gestión de Colecciones de Vídeos" )
      cTitle     := i18n( "Colecciones" )
      cBitmap   := "BB_LCOLECC"
      cSplSize   := "102"
      cPrefix    := "ClViClAbm-"
      cHdrMateria := i18n("Materia")
      cHdrTomos  := i18n("Nº Cintas")
      cHdrEditor := i18n("Productora")
      cHdrEjempl  := i18n( "Nº Ejemplares" )
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      exit
   end switch
   cContTitle := cTitle+": "

   CL->( dbGoTop() )
   ED->( dbGoTop() )

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )
   nBrwSplit := Val( GetIni( , "Browse", cPrefix + "Split", cSplSize ) )
   nBrwRecno := Val( GetIni( , "Browse", cPrefix + "Recno", "1" ) )
   nBrwOrder := Val( GetIni( , "Browse", cPrefix + "Order", "1" ) )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Colecciones" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "CL"
   
   ADD oCol TO oApp():oGrid DATA CL->ClNombre ;
      HEADER "Colección"   WIDTH 180

   ADD oCol TO oApp():oGrid DATA CL->ClMateria ;
      HEADER cHdrMateria   WIDTH 130

   ADD oCol TO oApp():oGrid DATA CL->ClTomos ;
      HEADER cHdrTomos PICTURE "@E 999,999" ;
      TOTAL 0 WIDTH 60

   ADD oCol TO oApp():oGrid DATA CL->ClEditor ;
      HEADER cHdrEditor    WIDTH 140

   ADD oCol TO oApp():oGrid DATA CL->ClPrecio ;
      HEADER "Precio" PICTURE "@E 999,999.99" ;
      TOTAL 0 WIDTH 80

   ADD oCol TO oApp():oGrid DATA CL->ClNotas ;
      HEADER "Notas"    WIDTH 200

   ADD oCol TO oApp():oGrid DATA CL->ClNumEjem ;
      HEADER cHdrEjempl PICTURE "@E 999,999" ;
      TOTAL 0 WIDTH 80

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| ClForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ), oApp():oGrid:Maketotals() } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "CL", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| ClTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21
   oApp():oGrid:lFooter    := .t.
	oApp():oGrid:bClrFooter := {|| { CLR_HRED, GetSysColor(15) } }
 	oApp():oGrid:MakeTotals()


   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(CL->(ordKeyNo()),'@E 999,999')+" / "+tran(CL->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE cBitmap

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nueva")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( ClForm( oApp():oGrid, "add", cTipo, oCont, ,cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( ClForm( oApp():oGrid, "edt", cTipo, oCont, ,cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( ClForm( oApp():oGrid, "dup", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( ClBorrar( oApp():oGrid, oCont, cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( ClBuscar( oApp():oGrid, oCont, , cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( ClImprimir( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont   ;
      CAPTION cTbTxtEjemp      ;
      IMAGE cTbBmpEjemp        ;
      ACTION ( ClEjemplares( oApp():oGrid, cTipo ) ) ;
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
      ITEMS " "+i18n("Colección")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( ClTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont )

   if nBrwRecno <= CL->( ordKeyCount() )
      CL->( dbGoto( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      ClTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() );
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", cPrefix + "State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", cPrefix + "Order", oApp():oTab:nOption ),;
      SetIni( , "Browse", cPrefix + "Recno", CL->( RecNo() ) ),;
      SetIni( , "Browse", cPrefix + "Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function ClForm( oGrid, cModo, cTipo, oCont, cClave, cContTitle )

   local oDlg
   local aGet        := Array(06)
   local aBtn        := Array(02)
   local aSay        := Array(02)

   local lIdOk       := .F.
   local nRecBrw     := CL->( RecNo() )
   local nRecAdd     := 0
   local cCaption    := ""
   local cSayItems   := ""
   local cSayEditor  := ""
   local cTipoMsg    := ""

   local cClNombre   := ""
   local cClNotas    := ""
   local cClEditor   := ""
   local cClMateria  := ""
   local nClTomos    := 0
   local nClPrecio   := 0

   if cModo == "edt" .OR. cModo == "dup"
      if ClDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if CL->( Eof() ) .AND. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      switch cTipo
      case "L"
         cCaption := i18n( "Añadir una Colección de Libros" )
         exit
      case "D"
         cCaption := i18n( "Añadir una Colección de Libros" )
         exit
      case "V"
         cCaption := i18n( "Añadir una Colección de Vídeos" )
         exit
      end switch
      CL->( dbAppend() )
      replace CL->ClTipo with cTipo
      if cClave != NIL
         cclnombre := cClave
      else
         cclnombre := Space( 40 )
      endif
      CL->( dbCommit() )
      nRecAdd := CL->( RecNo() )
      // modificar
   case cModo == "edt"
      switch cTipo
      case "L"
         cCaption := i18n( "Modificar una Colección de Libros" )
         exit
      case "D"
         cCaption := i18n( "Modificar una Colección de Discos" )
         exit
      case "V"
         cCaption := i18n( "Modificar una Colección de Vídeos" )
         exit
      end switch
      cclnombre  := CL->ClNombre
      // duplicar
   case cModo == "dup"
      switch cTipo
      case "L"
         cCaption := i18n( "Duplicar una Colección de Libros" )
         exit
      case "D"
         cCaption := i18n( "Duplicar una Colección de Discos" )
         exit
      case "V"
         cCaption := i18n( "Duplicar una Colección de Vídeos" )
         exit
      end switch
      cclnombre  := CL->ClNombre
   endcase

   switch cTipo
   case "L"
      cSayItems  := i18n( "Nº Tomos" )
      cSayEditor := i18n( "Editorial" )
      exit
   case "D"
   case "M"
      cSayItems  := i18n( "Nº Discos" )
      cSayEditor := i18n( "Productora" )
      exit
   case "V"
      cSayItems  := i18n( "Nº Vídeos" )
      cSayEditor := i18n( "Productora" )
   end switch

   cclnotas   := CL->ClNotas
   ccleditor  := CL->ClEditor
   cclmateria := CL->ClMateria
   ncltomos   := CL->ClTomos
   nclprecio  := CL->ClPrecio

   DEFINE DIALOG oDlg RESOURCE "CL_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE say aSay[01] ID 202 OF oDlg prompt i18n( cSayEditor )
   REDEFINE say aSay[02] ID 203 OF oDlg prompt i18n( cSayItems  )

   REDEFINE get aGet[01] ;
      var cClNombre ;
      ID 100 ;
      OF oDlg ;
      VALID ( ClClave( cClNombre, aGet[01], cModo, cTipo ) )

   do case
      case cTipo=='L'   
         REDEFINE AUTOGET aGet[02] ;
            VAR cClMateria ; 
            DATASOURCE {}						;
            FILTER MaListL( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 101 ;
            OF oDlg ;
            VALID ( MaClave( @cClMateria, aGet[02], "aux", "L" ) ) 
      case cTipo=='M' .or. cTipo=='D'   
         REDEFINE AUTOGET aGet[02] ;
            VAR cClMateria ; 
            DATASOURCE {}						;
            FILTER MaListM( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 101 ;
            OF oDlg ;
            VALID ( MaClave( @cClMateria, aGet[02], "aux", "M" ) ) 
      case cTipo=='V'   
         REDEFINE AUTOGET aGet[02] ;
            VAR cClMateria ; 
            DATASOURCE {}						;
            FILTER MaListV( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 101 ;
            OF oDlg ;
            VALID ( MaClave( @cClMateria, aGet[02], "aux", "V" ) )
   endcase

   REDEFINE BUTTON aBtn[01];
      ID 107;
      OF oDlg;
      ACTION ( MaTabAux( @cClMateria, aGet[02], if( cTipo == "D", "M", cTipo ) ),;
      aGet[02]:setFocus(),;
      SysRefresh() )

   aBtn[01]:cToolTip := i18n( "selecc. materia" )

   do case
      case cTipo=='L'   
         REDEFINE AUTOGET aGet[03] ;
            VAR cClEditor ; 
            DATASOURCE {}						;
            FILTER EdListL( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 102 ;
            OF oDlg ;
            VALID ( EdClave( @cClEditor, aGet[03], "aux", "L" ) )
       case cTipo=='M' .or. cTipo=='D'   
         REDEFINE AUTOGET aGet[03] ;
            VAR cClEditor ; 
            DATASOURCE {}						;
            FILTER EdListD( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 102 ;
            OF oDlg ;
            VALID ( EdClave( @cClEditor, aGet[03], "aux", "D" ) ) 
      case cTipo=='V'   
         REDEFINE AUTOGET aGet[03] ;
            VAR cClEditor ; 
            DATASOURCE {}						;
            FILTER EdListV( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 102 ;
            OF oDlg ;
            VALID ( EdClave( @cClEditor, aGet[03], "aux", cTipo ) )
   endcase

   REDEFINE BUTTON aBtn[02];
      ID 108;
      OF oDlg;
      ACTION ( EdTabAux( @cClEditor, aGet[03], cTipo ),;
      aGet[03]:setFocus(),;
      SysRefresh() )

   aBtn[02]:cToolTip := i18n( "selecc. editorial" )

   REDEFINE get aGet[04] var nClTomos  ID 103 OF oDlg picture "@E 999,999"
   REDEFINE get aGet[05] var nClPrecio ID 104 OF oDlg picture "@E 9,999,999,999.99"

   REDEFINE get aGet[06] var cClNotas  ID 105 OF oDlg MEMO

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
         CL->( dbGoto( nRecAdd ) )
         replace CL->ClNombre  with cclnombre
         replace CL->ClNotas   with cclnotas
         replace CL->ClEditor  with ccleditor
         replace CL->ClMateria with cclmateria
         replace CL->ClTomos   with ncltomos
         replace CL->ClPrecio  with nclprecio
         CL->( dbCommit() )
         nRecBrw := CL->( RecNo() )
         if cClave != NIL
            cClave := cClNombre
         endif
         // cancelar
      else
         CL->( dbGoto( nRecAdd ) )
         CL->( dbDelete() )
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk
         CL->( dbGoto( nRecBrw ) )
         if CL->ClNombre != cClNombre
            msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
               {|| ClR( cClNombre, CL->ClNombre, cTipo ) } )
         endif
         replace CL->ClNombre  with cclnombre
         replace CL->ClNotas   with cclnotas
         replace CL->ClEditor  with ccleditor
         replace CL->ClMateria with cclmateria
         replace CL->ClTomos   with ncltomos
         replace CL->ClPrecio  with nclprecio
         CL->( dbCommit() )
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         CL->( dbAppend() )
         replace CL->ClTipo with cTipo
         replace CL->ClNombre  with cclnombre
         replace CL->ClNotas   with cclnotas
         replace CL->ClEditor  with ccleditor
         replace CL->ClMateria with cclmateria
         replace CL->ClTomos   with ncltomos
         replace CL->ClPrecio  with nclprecio
         CL->( dbCommit() )
         nRecBrw := CL->( RecNo() )
      endif
   endcase
   if lIdOk
      switch cTipo
      case "L"
         oAGet():lClLi := .T.
         exit
      case "D"
         oAGet():lClMu := .T.
         exit
      case "V"
         oAGet():lClVi := .T.
         exit
      end switch
      oAGet():Load()
   endif
   CL->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "CL", cContTitle )
   endif
   if oGrid != NIL
      oGrid:Maketotals()
      oGrid:refresh()
      oGrid:setFocus()
   endif

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function ClBorrar( oGrid, oCont, cTipo, cContTitle )

   local nRecord := CL->( RecNo() )
   local nNext
   local cMsg    := ""

   if ClDbfVacia()
      return nil
   endif

   switch cTipo
   case "L"
      cMsg := i18n( "Si borra esta Colección, se borrará en todos los libros en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "D"
   case "M"
      cMsg := i18n( "Si borra esta Colección, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "V"
      cMsg := i18n( "Si borra esta Colección, se borrará en todos los vídeos en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   end switch

   if msgYesNo( cMsg +CRLF+CRLF+ Trim( CL->clNombre ) )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
         {|| ClDelR( CL->clNombre, cTipo ) } )
      CL->( dbSkip() )
      nNext := CL->( RecNo() )
      CL->( dbGoto( nRecord ) )
      CL->( dbDelete() )
      CL->( dbGoto( nNext ) )
      if CL->( Eof() ) .OR. nNext == nRecord
         CL->( dbGoBottom() )
      endif
      switch cTipo
      case "L"
         oAGet():lClLi := .T.
         exit
      case "D"
      case "M"
         oAGet():lClMu := .T.
         exit
      case "V"
         oAGet():lClVi := .T.
         exit
      end switch
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont( oCont, "CL", cContTitle )
   endif
   oGrid:Maketotals()
   oGrid:refresh()
   oGrid:setFocus()

return nil

/*_____________________________________________________________________________*/

function ClBuscar( oGrid, oCont, cChr, cTipo, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local cCaption := ""
   local cNoFind  := ""
   local nRecNo   := CL->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if ClDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cPrompt  := i18n( "Introduzca el Nombre de la Colección de Libros" )
      cCaption := i18n( "Búsqueda de Colecciones de Libros" )
      cNoFind  := i18n( "No encuentro esa Colección de Libros." )
      exit
   case "D"
   case "M"
      cPrompt  := i18n( "Introduzca el Nombre de la Colección de Discos" )
      cCaption := i18n( "Búsqueda de Colecciones de Discos" )
      cNoFind  := i18n( "No encuentro esa Colección de Discos." )
      exit
   case "V"
      cPrompt  := i18n( "Introduzca el Nombre de la Colección de Vídeos" )
      cCaption := i18n( "Búsqueda de Colecciones de Vídeos" )
      cNoFind  := i18n( "No encuentro esa Colección de Vídeos." )
      exit
   end switch

   cField  := i18n( "Nombre:" )
   cGet    := Space( 40 )

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
         {|| ClWildSeek(cTipo, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         msgStop( cNoFind )
         CL->(dbGoto(nRecno))
      else
         ClEncontrados(aBrowse, oApp():oDlg, cTipo)
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "CL", cContTitle )
   endif
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function ClWildSeek(cTipo, cGet, aBrowse)

   local nRecno   := ED->(RecNo())

   CL->(dbGoTop())
   do while ! CL->(Eof())
      if cGet $ Upper(CL->ClNombre)
         AAdd(aBrowse, {CL->ClNombre, CL->ClMateria, CL->ClEditor, CL->(RecNo())})
      endif
      CL->(dbSkip())
   enddo

   CL->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function CLEncontrados(aBrowse, oParent, cTipo)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := CL->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   switch cTipo
   case "L"
      oBrowse:aCols[1]:cHeader := i18n( "Colección de libros" )
      oBrowse:aCols[2]:cHeader := i18n( "Materia" )
      oBrowse:aCols[3]:cHeader := i18n( "Editorial" )
      exit
   case "M"
      oBrowse:aCols[1]:cHeader := i18n( "Colección de discos" )
      oBrowse:aCols[2]:cHeader := i18n( "Género musical" )
      oBrowse:aCols[3]:cHeader := i18n( "Productora" )
      exit
   case "V"
      oBrowse:aCols[1]:cHeader := i18n( "Colección de videos" )
      oBrowse:aCols[2]:cHeader := i18n( "Género cinematográfico" )
      oBrowse:aCols[3]:cHeader := i18n( "Productora" )
      exit
   end switch
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:nWidth  := 160
   oBrowse:aCols[4]:lHide    := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   CL->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||CL->(dbGoto(aBrowse[oBrowse:nArrayAt, 4])),;
      ClForm(oBrowse,"edt",cTipo,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(CL->(dbGoto(aBrowse[oBrowse:nArrayAt, 4])),;
      ClForm(oBrowse,"edt",cTipo,oDlg)),) }
   oBrowse:bChange    := {|| CL->(dbGoto(aBrowse[oBrowse:nArrayAt, 4])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (CL->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function ClTabAux( cGet, oGet, cTipo, cGetTomos, oGetTomos, oVItem )

   local oDlg
   local oGrid
   local oCol
   local aBtn       := Array( 06 )

   local lIdOk      := .F.
   local aPoint     := AdjustWnd( oGet, 268*2, 157*2 )
   local cCaption   := ""
   local nOrder     := CL->( ordNumber() )
   local cPrefix    := ""

   local cBrwState := ""

   cTipo := Upper( cTipo )

   switch cTipo
   case "L"
      CL->( ordSetFocus( "colibros" ) )
      cCaption := i18n( "Selección de Colecciones de Libros" )
      cPrefix  := "ClLiClAux-"
      exit
   case "D"
      CL->( ordSetFocus( "codiscos" ) )
      cCaption := i18n( "Selección de Colecciones de Discos" )
      cPrefix  := "ClMuClAux-"
      exit
   case "V"
      CL->( ordSetFocus( "covideos" ) )
      cCaption := i18n( "Selección de Colecciones de Vídeos" )
      cPrefix  := "ClViClAux-"
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   CL->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oGrid := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oGrid )

   oGrid:cAlias := "CL"

   oCol := oGrid:AddCol()
   oCol:bStrData := {|| CL->clNombre }
   oCol:cHeader  := i18n( "Colección" )
   oCol:nWidth   := 250

   AEval( oGrid:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oGrid:lHScroll := .F.
   oGrid:SetRDD()
   oGrid:CreateFromResource( 110 )

   oDlg:oClient := oGrid

   oGrid:RestoreState( cBrwState )
   oGrid:bKeyDown := {|nKey| ClTeclas( nKey, oGrid, , cTipo, oDlg ) }
   oGrid:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg prompt i18n( "&Nueva" );
      ACTION ( ClForm( oGrid, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( ClForm( oGrid, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( ClBorrar( oGrid, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( ClBuscar( oGrid, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oGrid:setFocus() )

   if lIdOK
      cGet := CL->ClNombre
      if oGet != NIL
         oGet:Refresh()
         cGetTomos := CL->ClTomos
         oGetTomos:Refresh()
      endif

   endif

   CL->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", cPrefix + "State", oGrid:SaveState()    )

return nil

/*_____________________________________________________________________________*/

function ClR( cVar, cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // colecciones de libros
   case "L"

      // libros: colección
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiColecc ) ) == RTrim( Upper( cOld ) )
            replace LI->LiColecc with cVar
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )
      exit

      // colecciones de discos
   case "D"
   case "M"

      // discos: colección
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuColecc ) ) == RTrim( Upper( cOld ) )
            replace MU->MuColecc with cVar
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )
      exit

      // colecciones de vídeos
   case "V"

      // vídeos: colección
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViColecc ) ) == RTrim( Upper( cOld ) )
            replace VI->ViColecc with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function ClDelR( cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // colecciones de libros
   case "L"

      // libros: colección
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiColecc ) ) == RTrim( Upper( cOld ) )
            replace LI->LiColecc with Space( 40 )
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )
      exit

      // colecciones de discos
   case "D"
   case "M"

      // discos: colección
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuColecc ) ) == RTrim( Upper( cOld ) )
            replace MU->MuColecc with Space( 40 )
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )
      exit

      // colecciones de vídeos
   case "V"

      // vídeos: colección
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViColecc ) ) == RTrim( Upper( cOld ) )
            replace VI->ViColecc with Space( 40 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function ClClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "CL"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   switch cTipo
   case "L"
      cMsgSi := i18n( "Colección de Libros ya registrada."   )
      cMsgNo := i18n( "Colección de Libros no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 1
      exit
   case "D"
      cMsgSi := i18n( "Colección de Discos ya registrada."   )
      cMsgNo := i18n( "Colección de Discos no registrada." )+CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 2
      exit
   case "V"
      cMsgSi := i18n( "Colección de Vídeos ya registrada."   )
      cMsgNo := i18n( "Colección de Vídeos no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 3
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
            lReturn := ClForm( , "add", cTipo, , @cClave )
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

function ClTeclas( nKey, oGrid, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      ClForm( oGrid, "add", cTipo, oCont, , cContTitle )
      exit
   case VK_RETURN
      ClForm( oGrid, "edt", cTipo, oCont, , cContTitle )
      exit
   case VK_DELETE
      ClBorrar( oGrid, oCont, cTipo, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      endif
      if nKey >= 65 .AND. nKey <= 90
         ClBuscar( oGrid, oCont, Chr( nKey ), cTipo, cContTitle )
      endif
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function ClEjemplares( oBrw, cTipo )

   local oDlg
   local oBrwEj
   local oBrwEjCol
   local oBtn

   local cCaption   := ""
   local cAlias     := ""
   local cColecc    := CL->ClNombre
   local bLDClick   := {|| NIL }
   local cPrefix    := ""
   local cOrdName   := ""

   local cBrwState  := ""

   if AuDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cCaption  := i18n( "Libros de" ) + " " + cColecc
      cAlias    := "LI"
      cPrefix   := "CLExtEjLi-"
      bLDClick  := {|| LiForm( oBrwEj, "edt" ) }
      cOrdName  := "COLECCION"
      exit
   case "D"
      cCaption  := i18n( "Discos de" ) + " " + cColecc
      cAlias    := "MU"
      cPrefix   := "MaExtEjMu-"
      bLDClick  := {|| MuForm( oBrwEj, "edt" ) }
      cOrdName  := "COLECCION"
      exit
   case "V"
      cCaption  := i18n( "Vídeos de" ) + " " + cColecc
      cAlias    := "VI"
      cPrefix   := "MaExtEjVi-"
      bLDClick  := {|| ViForm( oBrwEj, "edt" ) }
      cOrdName  := "COLECCION"
      exit
   case "S"
      cCaption  := i18n( "Software de" ) + " " + cColecc
      cAlias    := "SO"
      cPrefix   := "MaExtEjSo-"
      bLDClick  := {|| SoForm( oBrwEj, "edt" ) }
      exit
   case "I"
      cCaption  := i18n( "Direcciones de Internet de" ) + " " + cColecc
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
   ( cAlias )->( ordScope( 0, Upper( cColecc ) ) )
   ( cAlias )->( ordScope( 1, Upper( cColecc ) ) )
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

function ClTabs( oGrid, nOpc, cTipo, oCont, cContTitle )

   switch cTipo
   case "L"
      switch nOpc
      case 1
         CL->( ordSetFocus( "colibros" ) )
         exit
      end switch
      exit
   case "D"
      switch nOpc
      case 1
         CL->( ordSetFocus( "codiscos" ) )
         exit
      end switch
      exit
   case "V"
      switch nOpc
      case 1
         CL->( ordSetFocus( "covideos" ) )
         exit
      end switch
      exit
   end switch

   oGrid:refresh()
   RefreshCont( oCont, "CL", cContTitle )

return nil

/*_____________________________________________________________________________*/

function ClImprimir( oGrid, cTipo )

   local nRecno   := CL->(RecNo())
   local nOrder   := CL->(ordSetFocus())
   local aCampos  := { "CLNOMBRE", "CLMATERIA", "CLEDITOR", "CLTOMOS", "CLPRECIO", "CLNOTAS", "CLNUMEJEM" }
   local aTitulos := { "Colección", "Materia", "Editor", "Nº Tomos", "Precio", "Notas", "" }
   local aWidth   := { 20, 20, 20, 10, 20, 20, 20  }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO", "NO", "NO", "@E 99,999", "@E 999,999.99", "NO", "@E 999,999"  }
   local aTotal   := { .F., .F., .F., .F., .F., .F.,.T. }
   local oInforme
   local nAt
   local cAlias

   if ClDbfVacia()
      retu nil
   endif

   oApp():nEdit++

   switch cTipo
   case "L"
      cAlias      := "CLLI"
      aTitulos[2] := i18n("Materia")
      aTitulos[3] := i18n("Editorial")
      aTitulos[4] := i18n("Nº Tomos")
      aTitulos[7] := "Nº Libros"
      exit
   case "D"
      cAlias      := "CLDI"
      aTitulos[2] := i18n("Género")
      aTitulos[3] := i18n("Productora")
      aTitulos[4] := i18n("Nº Discos")
      aTitulos[7] := "Nº Discos"
      exit
   case "V"
      cAlias      := "CLVI"
      aTitulos[2] := i18n("Materia")
      aTitulos[3] := i18n("Productora")
      aTitulos[4] := i18n("Nº Videos")
      aTitulos[7] := "Nº Videos"
      exit
   end switch

   select CL  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select CL
      if oInforme:nRadio == 1
         CL->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
            oInforme:oReport:Say( 1, "Total colecciones " + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
            oInforme:oReport:EndLine() )

         oInforme:End(.T.)
      endif
      CL->(dbSetOrder(nOrder))
      CL->(dbGoto(nRecno))
   endif
   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil
/*_____________________________________________________________________________*/

function ClDbfVacia()

   local lReturn := .F.

   if CL->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ninguna colección registrada." ) )
      lReturn := .T.
   endif

return lReturn

function ClListL( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   CL->( dbSetOrder(1) )
   CL->( dbGoTop() )
   aNewList := ClListAll(cData)
return aNewList

function ClListD( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   CL->( dbSetOrder(2) )
   CL->( dbGoTop() )
   aNewList := ClListAll(cData)
return aNewList

function ClListV( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   CL->( dbSetOrder(3) )
   CL->( dbGoTop() )
   aNewList := ClListAll(cData)
return aNewList

Function ClListaLL(cData)
   local aList := {}
   while ! CL->(Eof())
      if at(Upper(cdata), Upper(CL->Clnombre)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aList, { CL->ClNombre } )
      endif 
      CL->(DbSkip())
   enddo
return alist
