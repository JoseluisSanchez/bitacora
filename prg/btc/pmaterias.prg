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

function Materias(cTipo)

   local oBar
   local oCol
   local oCont
   local cBitmap     := ""
   local cCaption    := ""
   local cTitle      := ""
   local cContTitle  := ""
   local cSplSize    := ""
   local cPrefix     := ""
   local cHdrMateria := ""
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
      MA->( ordSetFocus( "lmateria" ) )
      LI->( ordSetFocus( "materia" ) )
      cCaption    := i18n( "Gestión de materias de Libros" )
      cTitle      := i18n( "Materias" )
      cBitmap   := "BB_MATERIAS"
      cSplSize    := "102"
      cPrefix     := "MaLiAbm-"
      cHdrMateria := i18n("Materia")
      cHdrEjempl  := i18n("Nº Libros")
      cTbBmpEjemp := "16_libros"
      cTbTxtEjemp := "Ver libros"
      exit
   case "M"
      // música
      MA->( ordSetFocus( "mmateria" ) )
      MU->( ordSetFocus( "materia" ) )
      cCaption    := i18n( "Gestión de generos musicales" )
      cTitle      := i18n( "Géneros" )
      cBitmap   := "BB_MATERIAS"
      cSplSize    := "102"
      cPrefix     := "MaMuAbm-"
      cHdrMateria := i18n("Género")
      cHdrEjempl  := i18n("Nº Discos")
      cTbBmpEjemp := "16_discos"
      cTbTxtEjemp := "Ver discos"
      exit
   case "V"
      // videos
      MA->( ordSetFocus( "vmateria" ) )
      VI->( ordSetFocus( "materia" ) )
      cCaption    := i18n( "Gestión de materias de videos" )
      cTitle      := i18n( "Materias" )
      cBitmap   := "BB_MATERIAS"
      cSplSize    := "102"
      cPrefix     := "MaViAbm-"
      cHdrMateria := i18n("Materia")
      cHdrEjempl  := i18n("Nº Videos")
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      exit
   case "S"
      // software
      MA->( ordSetFocus( "smateria" ) )
      SO->( ordSetFocus( "materia" ) )
      cCaption    := i18n( "Gestión de materias de software" )
      cTitle      := i18n( "Materias" )
      cBitmap   := "BB_MATERIAS"
      cSplSize    := "102"
      cPrefix     := "MaSoAbm-"
      cHdrMateria := i18n("Materia")
      cHdrEjempl  := i18n("Nº Programas")
      cTbBmpEjemp := "16_software"
      cTbTxtEjemp := "Ver software"
      exit
   case "I"
      // internet
      MA->( ordSetFocus( "imateria" ) )
      IN->( ordSetFocus( "materia" ) )
      cCaption    := i18n( "Gestión de materias de internet" )
      cTitle      := i18n( "Materias" )
      cBitmap   := "BB_MATERIAS"
      cSplSize    := "102"
      cPrefix     := "MaInAbm-"
      cHdrMateria := i18n("Materia")
      cHdrEjempl  := i18n("Nº Direcciones")
      cTbBmpEjemp := "16_url"
      cTbTxtEjemp := "Ver direcciones"
      exit
   end switch

   cContTitle := cTitle + ": "
   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )
   nBrwSplit := Val( GetIni( , "Browse", cPrefix + "Split", cSplSize ) )
   nBrwRecno := Val( GetIni( , "Browse", cPrefix + "Recno", "1" ) )
   nBrwOrder := Val( GetIni( , "Browse", cPrefix + "Order", "1" ) )

   MA->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de colecciones por Materias" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "MA"

   ADD oCol TO oApp():oGrid DATA MA->MaMateria ;
      HEADER cHdrEjempl  WIDTH 200

   ADD oCol TO oApp():oGrid DATA MA->MaNumLibr ;
      HEADER cHdrEjempl PICTURE "@E 999,999" ;
      TOTAL 0 WIDTH 80

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| MaForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ), oApp():oGrid:Maketotals() } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "MA", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| MaTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21
   oApp():oGrid:lFooter    := .t.
	oApp():oGrid:bClrFooter := {|| { CLR_HRED, GetSysColor(15) } }
 	oApp():oGrid:MakeTotals()


   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(MA->(ordKeyNo()),'@E 999,999')+" / "+tran(MA->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25 ;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE cBitmap

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nueva")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( MaForm( oApp():oGrid, "add", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( MaForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( MaForm( oApp():oGrid, "dup", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( MaBorrar( oApp():oGrid, oCont, cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( MaBuscar( oApp():oGrid, oCont, , cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( MaImprimir( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont   ;
      CAPTION cTbTxtEjemp      ;
      IMAGE cTbBmpEjemp        ;
      ACTION ( MaEjemplares( oApp():oGrid, cTipo ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, cPrefix+"State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+cHdrMateria+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( MaTabs( oApp():oGrid, oApp():oTab:nOption, cTipo, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= MA->( ordKeyCount() )
      MA->( dbGoto( nBrwRecno ) )
   end if

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      MaTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", cPrefix+"State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", cPrefix+"Order", oApp():oTab:nOption ),;
      SetIni( , "Browse", cPrefix+"Recno", MA->( RecNo() ) ),;
      SetIni( , "Browse", cPrefix+"Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function MaForm( oBrw, cModo, cTipo, oCont, cClave, cContTitle )

   local oDlg
   local aGet        := Array( 04 )

   local lIdOk       := .F.
   local nRecBrw     := MA->( RecNo() )
   local nRecAdd     := 0
   local cOldMateria := MA->MaMateria
   local cCaption    := ""
   local cSayTipo    := ""
   local cSayNum     := ""

   local cMaMateria  := ""
   local cMaTipo     := ""
   local nMaNumLibr  := 0

   if cModo == "edt" .OR. cModo == "dup"
      if MaDbfVacia()
         retu nil
      end if
   end if

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if MA->( Eof() ) .AND. cModo != "add"
      retu nil
   end if

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      cCaption := i18n( "Añadir " )
      switch cTipo
      case "L"
         cCaption := i18n( "Añadir una Materia de Libros" )
         exit
      case "M"
         cCaption := i18n( "Añadir un Género Musical" )
         exit
      case "S"
         cCaption := i18n( "Añadir una Materia de Software" )
         exit
      case "I"
         cCaption := i18n( "Añadir una Materia de Internet" )
         exit
      case "V"
         cCaption := i18n( "Añadir una Materia de Vídeo" )
         exit
      end switch
      MA->( dbAppend() )
      if cClave != NIL
         cMaMateria := cClave
      else
         cMaMateria := Space( 30 )
      end if
      MA->( dbCommit() )
      nRecAdd := MA->( RecNo() )
      // modificar
   case cModo == "edt"
      switch cTipo
      case "L"
         cCaption := i18n( "Modificar una Materia de Libros" )
         exit
      case "M"
         cCaption := i18n( "Modificar un Género Musical" )
         exit
      case "S"
         cCaption := i18n( "Modificar una Materia de Software" )
         exit
      case "I"
         cCaption := i18n( "Modificar una Materia de Internet" )
         exit
      case "V"
         cCaption := i18n( "Modificar una Materia de Vídeo" )
         exit
      end switch
      cMaMateria := MA->maMateria
      // duplicar
   case cModo == "dup"
      cCaption := i18n( "Duplicar " )
      switch cTipo
      case "L"
         cCaption := i18n( "Duplicar una Materia de Libros" )
         exit
      case "M"
         cCaption := i18n( "Duplicar un Género Musical" )
         exit
      case "S"
         cCaption := i18n( "Duplicar una Materia de Software" )
         exit
      case "I"
         cCaption := i18n( "Duplicar una Materia de Internet" )
         exit
      case "V"
         cCaption := i18n( "Duplicar una Materia de Vídeo" )
         exit
      end switch
      cMaMateria := MA->maMateria
   end case

   switch cTipo
   case "L"
      cSayTipo := i18n( "Materia" )
      cSayNum  := i18n( "Nº de Libros" )
      exit
   case "M"
      cSayTipo := i18n( "Género" )
      cSayNum  := i18n( "Nº de Discos" )
      exit
   case "S"
      cSayTipo := i18n( "Materia" )
      cSayNum  := i18n( "Nº de Programas" )
      exit
   case "I"
      cSayTipo := i18n( "Materia" )
      cSayNum  := i18n( "Nº de Direcciones" )
      exit
   case "V"
      cSayTipo := i18n( "Materia" )
      cSayNum  := i18n( "Nº de Vídeos" )
      exit
   end switch

   cMaTipo    := MA->maTipo
   nMaNumLibr := MA->maNumLibr

   if cModo == "dup"
      nMaNumLibr := 0
   end if

   DEFINE DIALOG oDlg RESOURCE "MA_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE say aGet[01] var cSayTipo ID 200 OF oDlg

   REDEFINE get aGet[02] ;
      var cMaMateria ;
      ID 100 ;
      OF oDlg ;
      UPDATE ;
      VALID ( MaClave( cMaMateria, aGet[02], cModo, cTipo ) )

   REDEFINE say aGet[03] var cSayNum    ID 201 OF oDlg
   REDEFINE say aGet[04] var nMaNumLibr ID 101 OF oDlg

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
         MA->( dbGoto( nRecAdd ) )
         replace MA->MaMateria with cMaMateria
         replace MA->MaTipo    with cTipo
         MA->( dbCommit() )
         nRecBrw := nRecAdd
         if cClave != NIL
            cClave := cMaMateria
         endif
      else
         MA->( dbGoto( nRecAdd ) )
         MA->( dbDelete() )
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk
         MA->( dbGoto( nRecBrw ) )
         replace MA->MaMateria with cMaMateria
         replace MA->MaTipo    with cMaTipo
         MA->( dbCommit() )
         if MA->MaNumLibr > 0
            msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
               {|| MaR( cMaMateria, cOldMateria, cTipo ) } )
         endif
      end if
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         MA->( dbAppend() )
         replace MA->MaMateria with cMaMateria
         replace MA->MaTipo    with cTipo
         MA->( dbCommit() )
         nRecBrw := MA->( RecNo() )
      end if
   end case

   if lIdOk == .T.
      switch cTipo
      case "L"
         oAGet():lMaLi := .T.
         exit
      case "M"
         oAGet():lMaMu := .T.
         exit
      case "S"
         oAGet():lMaSo := .T.
         exit
      case "I"
         oAGet():lMaIn := .T.
         exit
      case "V"
         oAGet():lMaVi := .T.
         exit
      end switch
      oAGet():Load()
   endif
   MA->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "MA", cContTitle )
   end if
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   end if

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function MaBorrar( oBrw, oCont, cTipo, cContTitle )

   local nRecord := MA->( RecNo() )
   local nNext   := 0
   local cMsg    := ""

   if MaDbfVacia()
      return nil
   end if

   switch cTipo
   case "L"
      cMsg  := i18n( "Si borra esta Materia, se borrará en todos los libros en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "M"
      cMsg  := i18n( "Si borra este Género, se borrará en todos los discos y canciones en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   case "V"
      cMsg  := i18n( "Si borra esta Materia, se borrará en todos los vídeos en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "S"
      cMsg  := i18n( "Si borra esta Materia, se borrará en todos los programas en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   case "I"
      cMsg  := i18n( "Si borra esta Materia, se borrará en todas las direcciones en que aparezca. ¿Está seguro de querer eliminarla?" )
      exit
   end switch

   if msgYesNo( cMsg +CRLF+CRLF+ Trim( MA->MaMateria ) )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName, ;
         {|| MaDelR( MA->MaMateria, cTipo ) } )
      MA->( dbSkip() )
      nNext := MA->( RecNo() )
      MA->( dbGoto( nRecord ) )
      MA->( dbDelete() )
      MA->( dbGoto( nNext ) )
      if MA->( Eof() ) .OR. nNext == nRecord
         MA->( dbGoBottom() )
      end if
      switch cTipo
      case "L"
         oAGet():lMaLi := .T.
         exit
      case "M"
         oAGet():lMaMu := .T.
         exit
      case "S"
         oAGet():lMaSo := .T.
         exit
      case "I"
         oAGet():lMaIn := .T.
         exit
      case "V"
         oAGet():lMaVi := .T.
         exit
      end switch
      oAGet():Load()
   end if

   if oCont != NIL
      RefreshCont( oCont, "MA", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function MaBuscar( oBrw, oCont, cChr, cTipo, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local cNoFind  := ""
   local cCaption := ""
   local nRecNo   := MA->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if MaDbfVacia()
      return nil
   end if

   oApp():nEdit++

   switch cTipo
   case "L"
      cPrompt  := i18n( "Introduzca el Materia de Libros" )
      cCaption := i18n( "Búsqueda de Materias de Libros" )
      cNoFind  := i18n( "No encuentro esa Materia de Libros" )
      exit
   case "M"
      cPrompt  := i18n( "Introduzca el Nombre del Género Musical" )
      cCaption := i18n( "Búsqueda de Géneros Musicales" )
      cNoFind  := i18n( "No encuentro ese Género Musical" )
      exit
   case "V"
      cPrompt  := i18n( "Introduzca el Nombre de la Materia de Vídeos" )
      cCaption := i18n( "Búsqueda de Materias de Vídeos" )
      cNoFind  := i18n( "No encuentro esa Materia de Vídeos" )
      exit
   case "S"
      cPrompt  := i18n( "Introduzca el Nombre de la Materia de Software" )
      cCaption := i18n( "Búsqueda de Materias de Software" )
      cNoFind  := i18n( "No encuentro esa Materia de Software" )
      exit
   case "I"
      cPrompt  := i18n( "Introduzca el Nombre de la Materia de Internet" )
      cCaption := i18n( "Búsqueda de Materias de Internet" )
      cNoFind  := i18n( "No encuentro esa Materia de Internet" )
      exit
   end switch

   cGet   := Space( 30 )

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

   ACTIVATE DIALOG oDlg ;
      on INIT ( oDlg:Center( oApp():oWndMain ) )

   if lIdOk
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      end if
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
         {|| MaWildSeek(cTipo, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ninguna materia."))
      else
         MaEncontrados(aBrowse, oApp():oDlg, cTipo)
      endif
   endif
   // LiTabs( oBrw, nTabOpc, oCont)
   if oCont != NIL
      RefreshCont( oCont, "MA", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function MaWildSeek(cTipo, cGet, aBrowse)

   local nRecno   := MA->(RecNo())

   MA->(dbGoTop())
   do while ! MA->(Eof())
      if cGet $ Upper(MA->MaMateria)
         AAdd(aBrowse, {MA->MaMateria, MA->MaNumLibr, MA->(RecNo())})
      endif
      MA->(dbSkip())
   enddo

   MA->(dbGoto(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function MaEncontrados(aBrowse, oParent, cTipo)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := MA->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Materia"
   oBrowse:aCols[2]:cHeader := "Ejemplares"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   MA->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||MA->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      MaForm(oBrowse,"edt",cTipo,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(MA->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      MaForm(oBrowse,"edt",cTipo,oDlg)),) }
   oBrowse:bChange    := {|| MA->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (MA->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function MaClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "MA"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   switch cTipo
   case "L"
      cMsgSi := i18n( "Materia de Libros ya registrada." )
      cMsgNo := i18n( "Materia de Libros no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 2
      exit
   case "M"
      cMsgSi := i18n( "Género Musical ya registrada." )
      cMsgNo := i18n( "Género Musical no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 3
      exit
   case "V"
      cMsgSi := i18n( "Materia de Vídeos ya registrada." )
      cMsgNo := i18n( "Materia de Vídeos no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 4
      exit
   case "S"
      cMsgSi := i18n( "Materia de Software ya registrada." )
      cMsgNo := i18n( "Materia de Software no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 5
      exit
   case "I"
      cMsgSi := i18n( "Materia de Internet ya registrada." )
      cMsgNo := i18n( "Materia de Internet no registrada." ) +CRLF+CRLF+ i18n("¿Desea darla de alta ahora?")
      nPkOrd := 6
      exit
   end switch

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
            lReturn := MaForm( , "add", cTipo, , @cClave )
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

function MaTabAux( cGet, oGet, cTipo, oVItem )

   local oDlg
   local oBrw
   local oCol
   local aBtn      := Array( 06 )

   local lIdOk     := .F.
   // local aPoint    := AdjustWnd( oGet, 268*2, 157*2 )
   local aPoint := iif(oGet!=NIL,AdjustWnd( oGet, 271*2, 150*2 ),{1.3*oVItem:nTop(),oApp():oGrid:nLeft})
   local cCaption  := ""
   local nOrder    := MA->( ordNumber() )
   local cPrefix   := ""

   local cBrwState := ""

   cTipo := Upper( cTipo )

   switch cTipo
   case "L"
      MA->( ordSetFocus( "lmateria" ) )
      cCaption := i18n( "Selección de Materias de Libros" )
      cPrefix  := "MaAuxLi-"
      exit
   case "M"
      MA->( ordSetFocus( "mmateria" ) )
      cCaption := i18n( "Selección de Géneros Musicales" )
      cPrefix  := "MaAuxMu-"
      exit
   case "V"
      MA->( ordSetFocus( "vmateria" ) )
      cCaption := i18n( "Selección de Materias de Vídeos" )
      cPrefix  := "MaAuxVi-"
      exit
   case "S"
      MA->( ordSetFocus( "smateria" ) )
      cCaption := i18n( "Selección de Materias de Software" )
      cPrefix  := "MaAuxSo-"
      exit
   case "I"
      MA->( ordSetFocus( "imateria" ) )
      cCaption := i18n( "Selección de Materias de Internet" )
      cPrefix  := "MaAuxIn-"
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   MA->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "MA"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| MA->maMateria }
   oCol:cHeader  := i18n( "Materia" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown := {|nKey| MaTeclas( nKey, oBrw, , cTipo, oDlg ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg prompt i18n( "&Nueva" );
      ACTION ( MaForm( oBrw, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( MaForm( oBrw, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( MaBorrar( oBrw, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( MaBuscar( oBrw, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := MA->MaMateria
      if oGet != NIL
         oGet:Refresh()
      endif
   end if

   MA->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", cPrefix + "State", oBrw:SaveState()    )

return nil

/*_____________________________________________________________________________*/

function MaTabs( oBrw, nOpc, cTipo, oCont, cContTitle )

   switch cTipo
   case "L"
      MA->( ordSetFocus( "lmateria" ) )
      exit
   case "M"
      MA->( ordSetFocus( "mmateria" ) )
      exit
   case "V"
      MA->( ordSetFocus( "vmateria" ) )
      exit
   case "S"
      MA->( ordSetFocus( "smateria" ) )
      exit
   case "I"
      MA->( ordSetFocus( "imateria" ) )
      exit
   end switch

   MA->( dbGoTop() )
   oBrw:refresh()
   RefreshCont( oCont, "MA", cContTitle )

return nil

/*_____________________________________________________________________________*/

function MaTeclas( nKey, oBrw, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      MaForm( oBrw, "add", cTipo, oCont, , cContTitle )
      exit
   case VK_RETURN
      MaForm( oBrw, "edt", cTipo, oCont, , cContTitle )
      exit
   case VK_DELETE
      MaBorrar( oBrw, oCont, cTipo, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      end if
      if nKey >= 65 .AND. nKey <= 90
         MaBuscar( oBrw, oCont, Chr( nKey ), cTipo, cContTitle )
      end if
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function MaR( cVar, cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // libros
   case "L"

      // libros: materia
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiMateria ) ) == RTrim( Upper( cOld ) )
            replace LI->LiMateria with cVar
            LI->( dbCommit() )
         end if
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )

      // autores: materia
      nOrder := AU->( ordNumber() )
      nRecNo := AU->( RecNo()     )
      AU->( ordSetFocus( "all_libros" ) )         // ¡ojo! sólo escritores
      AU->( dbGoTop() )
      while ! AU->( Eof() )
         if RTrim( Upper( AU->AuMateria ) ) == RTrim( Upper( cOld ) )
            replace AU->AuMateria with cVar
            AU->( dbCommit() )
         end if
         AU->( dbSkip() )
      end while
      AU->( dbSetOrder( nOrder ) )
      AU->( dbGoto( nRecNo )     )

      // colecciones: materia
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "colibros" ) )         // ¡ojo! sólo colecciones de libros
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->clMateria ) ) == RTrim( Upper( cOld ) )
            replace CL->clMateria with cVar
            CL->( dbCommit() )
         end if
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // discos
   case "M"

      // discos: género
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuMateria ) ) == RTrim( Upper( cOld ) )
            replace MU->MuMateria with cVar
            MU->( dbCommit() )
         end if
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // canciones: género
      nOrder := CN->( ordNumber() )
      nRecNo := CN->( RecNo()     )
      CN->( dbSetOrder( 0 ) )
      CN->( dbGoTop() )
      while ! CN->( Eof() )
         if RTrim( Upper( CN->CaMateria ) ) == RTrim( Upper( cOld ) )
            replace CN->CaMateria with cVar
            CN->( dbCommit() )
         end if
         CN->( dbSkip() )
      end while
      CN->( dbSetOrder( nOrder ) )
      CN->( dbGoto( nRecNo )     )

      // autores: materia
      nOrder := AU->( ordNumber() )
      nRecNo := AU->( RecNo()     )
      AU->( ordSetFocus( "all_discos" ) )         // ¡ojo! sólo autores musicales
      AU->( dbGoTop() )
      while ! AU->( Eof() )
         if RTrim( Upper( AU->AuMateria ) ) == RTrim( Upper( cOld ) )
            replace AU->AuMateria with cVar
            AU->( dbCommit() )
         end if
         AU->( dbSkip() )
      end while
      AU->( dbSetOrder( nOrder ) )
      AU->( dbGoto( nRecNo )     )

      // colecciones: materia
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "codiscos" ) )         // ¡ojo! sólo colecciones de discos
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->clMateria ) ) == RTrim( Upper( cOld ) )
            replace CL->clMateria with cVar
            CL->( dbCommit() )
         end if
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // vídeos
   case "V"

      // vídeos: materia
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViMateria ) ) == RTrim( Upper( cOld ) )
            replace VI->ViMateria with cVar
            VI->( dbCommit() )
         end if
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // autores: materia
      nOrder := AU->( ordNumber() )
      nRecNo := AU->( RecNo()     )
      AU->( ordSetFocus( "all_videos" ) )         // ¡ojo! sólo autores de vídeos
      AU->( dbGoTop() )
      while ! AU->( Eof() )
         if RTrim( Upper( AU->AuMateria ) ) == RTrim( Upper( cOld ) )
            replace AU->AuMateria with cVar
            AU->( dbCommit() )
         end if
         AU->( dbSkip() )
      end while
      AU->( dbSetOrder( nOrder ) )
      AU->( dbGoto( nRecNo )     )

      // colecciones: materia
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "covideos" ) )         // ¡ojo! sólo colecciones de vídeos
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->clMateria ) ) == RTrim( Upper( cOld ) )
            replace CL->clMateria with cVar
            CL->( dbCommit() )
         end if
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // software
   case "S"

      // software: materia
      nOrder := SO->( ordNumber() )
      nRecNo := SO->( RecNo()     )
      SO->( dbSetOrder( 0 ) )
      SO->( dbGoTop() )
      while ! SO->( Eof() )
         if RTrim( Upper( SO->SoMateria ) ) == RTrim( Upper( cOld ) )
            replace SO->SoMateria with cVar
            SO->( dbCommit() )
         end if
         SO->( dbSkip() )
      end while
      SO->( dbSetOrder( nOrder ) )
      SO->( dbGoto( nRecNo )     )
      exit

      // internet
   case "I"

      // internet: materia
      nOrder := IN->( ordNumber() )
      nRecNo := IN->( RecNo()     )
      IN->( dbSetOrder( 0 ) )
      IN->( dbGoTop() )
      while ! IN->( Eof() )
         if RTrim( Upper( IN->InMateria ) ) == RTrim( Upper( cOld ) )
            replace IN->InMateria with cVar
            IN->( dbCommit() )
         end if
         IN->( dbSkip() )
      end while
      IN->( dbSetOrder( nOrder ) )
      IN->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function MaDelR( cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // libros
   case "L"

      // libros: materia
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiMateria ) ) == RTrim( Upper( cOld ) )
            replace LI->LiMateria with Space( 30 )
            LI->( dbCommit() )
         end if
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )

      // autores: materia
      nOrder := AU->( ordNumber() )
      nRecNo := AU->( RecNo()     )
      AU->( ordSetFocus( "all_libros" ) )         // ¡ojo! sólo escritores
      AU->( dbGoTop() )
      while ! AU->( Eof() )
         if RTrim( Upper( AU->AuMateria ) ) == RTrim( Upper( cOld ) )
            replace AU->AuMateria with Space( 30 )
            AU->( dbCommit() )
         end if
         AU->( dbSkip() )
      end while
      AU->( dbSetOrder( nOrder ) )
      AU->( dbGoto( nRecNo )     )

      // colecciones: materia
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "colibros" ) )         // ¡ojo! sólo colecciones de libros
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->clMateria ) ) == RTrim( Upper( cOld ) )
            replace CL->clMateria with Space( 30 )
            CL->( dbCommit() )
         end if
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // discos
   case "M"

      // discos: género
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuMateria ) ) == RTrim( Upper( cOld ) )
            replace MU->MuMateria with Space( 30 )
            MU->( dbCommit() )
         end if
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // canciones: género
      nOrder := CN->( ordNumber() )
      nRecNo := CN->( RecNo()     )
      CN->( dbSetOrder( 0 ) )
      CN->( dbGoTop() )
      while ! CN->( Eof() )
         if RTrim( Upper( CN->CaMateria ) ) == RTrim( Upper( cOld ) )
            replace CN->CaMateria with Space( 40 )
            CN->( dbCommit() )
         end if
         CN->( dbSkip() )
      end while
      CN->( dbSetOrder( nOrder ) )
      CN->( dbGoto( nRecNo )     )

      // autores: materia
      nOrder := AU->( ordNumber() )
      nRecNo := AU->( RecNo()     )
      AU->( ordSetFocus( "all_discos" ) )         // ¡ojo! sólo autores musicales
      AU->( dbGoTop() )
      while ! AU->( Eof() )
         if RTrim( Upper( AU->AuMateria ) ) == RTrim( Upper( cOld ) )
            replace AU->AuMateria with Space( 30 )
            AU->( dbCommit() )
         end if
         AU->( dbSkip() )
      end while
      AU->( dbSetOrder( nOrder ) )
      AU->( dbGoto( nRecNo )     )

      // colecciones: materia
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "codiscos" ) )         // ¡ojo! sólo colecciones de discos
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->clMateria ) ) == RTrim( Upper( cOld ) )
            replace CL->clMateria with Space( 30 )
            CL->( dbCommit() )
         end if
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // vídeos
   case "V"

      // vídeos: materia
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViMateria ) ) == RTrim( Upper( cOld ) )
            replace VI->ViMateria with Space( 30 )
            VI->( dbCommit() )
         end if
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // autores: materia
      nOrder := AU->( ordNumber() )
      nRecNo := AU->( RecNo()     )
      AU->( ordSetFocus( "all_videos" ) )         // ¡ojo! sólo autores de vídeos
      AU->( dbGoTop() )
      while ! AU->( Eof() )
         if RTrim( Upper( AU->AuMateria ) ) == RTrim( Upper( cOld ) )
            replace AU->AuMateria with Space( 30 )
            AU->( dbCommit() )
         end if
         AU->( dbSkip() )
      end while
      AU->( dbSetOrder( nOrder ) )
      AU->( dbGoto( nRecNo )     )

      // colecciones: materia
      nOrder := CL->( ordNumber() )
      nRecNo := CL->( RecNo()     )
      CL->( ordSetFocus( "covideos" ) )         // ¡ojo! sólo colecciones de vídeos
      CL->( dbGoTop() )
      while ! CL->( Eof() )
         if RTrim( Upper( CL->clMateria ) ) == RTrim( Upper( cOld ) )
            replace CL->clMateria with Space( 30 )
            CL->( dbCommit() )
         end if
         CL->( dbSkip() )
      end while
      CL->( dbSetOrder( nOrder ) )
      CL->( dbGoto( nRecNo )     )
      exit

      // software
   case "S"

      // software: materia
      nOrder := SO->( ordNumber() )
      nRecNo := SO->( RecNo()     )
      SO->( dbSetOrder( 0 ) )
      SO->( dbGoTop() )
      while ! SO->( Eof() )
         if RTrim( Upper( SO->SoMateria ) ) == RTrim( Upper( cOld ) )
            replace SO->SoMateria with Space( 30 )
            SO->( dbCommit() )
         end if
         SO->( dbSkip() )
      end while
      SO->( dbSetOrder( nOrder ) )
      SO->( dbGoto( nRecNo )     )
      exit

      // internet
   case "I"

      // internet: materia
      nOrder := IN->( ordNumber() )
      nRecNo := IN->( RecNo()     )
      IN->( dbSetOrder( 0 ) )
      IN->( dbGoTop() )
      while ! IN->( Eof() )
         if RTrim( Upper( IN->InMateria ) ) == RTrim( Upper( cOld ) )
            replace IN->InMateria with Space( 30 )
            IN->( dbCommit() )
         end if
         IN->( dbSkip() )
      end while
      IN->( dbSetOrder( nOrder ) )
      IN->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function MaEjemplares( oBrw, cTipo )

   local oBrwEj
   local oBrwEjCol
   local oBtn
   local oDlg
   local cCaption   := ""
   local cAlias     := ""
   local cMateria   := MA->MaMateria
   local bLDClick   := {|| NIL }
   local cPrefix    := ""

   local cBrwState  := ""

   if MaDbfVacia()
      return nil
   end if

   oApp():nEdit++

   switch cTipo
   case "L"
      cCaption  := i18n( "Libros de" ) + " " + cMateria
      cAlias    := "LI"
      cPrefix   := "MaExtEjLi-"
      bLDClick  := {|| LiForm( oBrwEj, "edt" ) }
      exit
   case "M"
      cCaption  := i18n( "Discos de" ) + " " + cMateria
      cAlias    := "MU"
      cPrefix   := "MaExtEjMu-"
      bLDClick  := {|| MuForm( oBrwEj, "edt" ) }
      exit
   case "V"
      cCaption  := i18n( "Vídeos de" ) + " " + cMateria
      cAlias    := "VI"
      cPrefix   := "MaExtEjVi-"
      bLDClick  := {|| ViForm( oBrwEj, "edt" ) }
      exit
   case "S"
      cCaption  := i18n( "Software de" ) + " " + cMateria
      cAlias    := "SO"
      cPrefix   := "MaExtEjSo-"
      bLDClick  := {|| SoForm( oBrwEj, "edt" ) }
      exit
   case "I"
      cCaption  := i18n( "Direcciones de Internet de" ) + " " + cMateria
      cAlias    := "IN"
      cPrefix   := "MaExtEjIn-"
      bLDClick  := {|| InForm( oBrwEj, "edt" ) }
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   DEFINE DIALOG oDlg RESOURCE "MA_EJEMPLARES" TITLE cCaption
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

   ( cAlias )->( ordSetFocus( "materia" ) )
   ( cAlias )->( ordScope( 0, Upper( cMateria ) ) )
   ( cAlias )->( ordScope( 1, Upper( cMateria ) ) )
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

function MaImprimir( oBrw, cTipo )

   //  título                 campo        wd  shw  picture          tot
   //  =====================  ===========  ==  ===  ===============  ===
   local aInf := { { i18n("Materia"      ), "MAMATERIA",  0, .T.,            "NO", .F. },;
      { i18n("Nº Ejemplares"), "MANUMLIBR", 14, .T.,     "@E 99,999", .T. } }

   local nRecno   := MA->(RecNo())
   local nOrder   := MA->(ordSetFocus())
   local aCampos  := { "MAMATERIA", "MANUMLIBR" }
   local aTitulos := { "Materia", "Nº Ejemplares" }
   local aWidth   := { 60, 20 }
   local aShow    := { .T., .T. }
   local aPicture := { "NO", "@E 99,999" }
   local aTotal   := { .F., .T. }
   local oInforme
   local nAt
   local cAlias
   local cTotal

   if MaDbfVacia()
      retu nil
   end if

   oApp():nEdit++

   switch cTipo
   case "L"
      cAlias   := "MALI"
      cTotal   := "Total materias de libros:"
      exit
   case "M"
      cAlias   := "MADI"
      cTotal   := "Total géneros musicales:"
      exit
   case "V"
      cAlias   := "MAVI"
      cTotal   := "Total materias de videos:"
      exit
   case "S"
      cAlias   := "MASO"
      cTotal   := "Total materias de software:"
      exit
   case "I"
      cAlias   := "MAIN"
      cTotal   := "Total materias de internet:"
      exit
   end switch

   select MA  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select MA
      if oInforme:nRadio == 1
         MA->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
            oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
      endif
      MA->(dbSetOrder(nOrder))
      MA->(dbGoto(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .T. )
   oApp():nEdit --

return nil

/*_____________________________________________________________________________*/

function MaDbfVacia()

   local lReturn := .F.

   if MA->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ninguna materia registrada." ) )
      lReturn := .T.
   end if

return lReturn
//_____________________________________________________________________________//
function MaListL( aList, cData, oSelf )
   local aNewList := {}
   MA->( dbSetOrder(2) )
   MA->( dbGoTop() )
   aNewList := MaListAll(cData)
return aNewList

function MaListM( aList, cData, oSelf )
   local aNewList := {}
   MA->( dbSetOrder(3) )
   MA->( dbGoTop() )
   aNewList := MaListAll(cData)
return aNewList

function MaListV( aList, cData, oSelf )
   local aNewList := {}
   MA->( dbSetOrder(4) )
   MA->( dbGoTop() )
   aNewList := MaListAll(cData)
return aNewList

function MaListS( aList, cData, oSelf )
   local aNewList := {}
   MA->( dbSetOrder(5) )
   MA->( dbGoTop() )
   aNewList := MaListAll(cData)
return aNewList

function MaListI( aList, cData, oSelf )
   local aNewList := {}
   MA->( dbSetOrder(6) )
   MA->( dbGoTop() )
   aNewList := MaListAll(cData)
return aNewList

Function MaListaLL(cData)
   local aList := {}
   while ! MA->(Eof())
      if at(Upper(cdata), Upper(MA->MaMateria)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aList, { MA->MaMateria } )
      endif 
      MA->(DbSkip())
   enddo
return alist
