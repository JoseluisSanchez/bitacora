**
* PROYECTO ..: Cuaderno de Bitácora
* COPYRIGHT .: (c) alanit software
* URL .......: www.alanit.com
**

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"
#include "AutoGet.ch"

extern deleted

/*_____________________________________________________________________________*/

function Canciones()

   local oCol
   local oCont
	local cTitle     := "Canciones"
	local cContTitle := cTitle+": "

   local cBrwState := GetIni( , "Browse", "CnAbm-State", "" )
   local nBrwSplit := val( GetIni( , "Browse", "CnAbm-Split", "102" ) )
   local nBrwRecno := val( GetIni( , "Browse", "CnAbm-Recno", "1" ) )
   local nBrwOrder := val( GetIni( , "Browse", "CnAbm-Order", "1" ) )

   if ModalSobreFsdi()
      retu NIL
   endif

   if ! Db_OpenAll()
      retu NIL
   endif

   CN->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Canciones y Piezas Musicales" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "CN"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || CN->caTitulo }
   oCol:cHeader  := i18n( "Título" )
   oCol:nWidth   := 200

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || CN->caMateria }
   oCol:cHeader  := i18n( "Género" )
   oCol:nWidth   := 141

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || CN->caAutor }
   oCol:cHeader  := i18n( "Compositor" )
   oCol:nWidth   := 159

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || CN->caInterp }
   oCol:cHeader  := i18n( "Intérprete" )
   oCol:nWidth   := 159

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || CN->caDuracc }
   oCol:cHeader  := i18n( "Duración" )
   oCol:nWidth   := 53

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || CN->caIdioma }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 80

   aEval( oApp():oGrid:aCols, { |oCol| oCol:bLDClickData := { || CnForm( oApp():oGrid, "edt", oCont, , cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := { || RefreshCont( oCont, "CN", cContTitle ) }
   oApp():oGrid:bKeyDown   := { |nKey| CnTeclas( nKey, oApp():oGrid, oCont, oApp():oTab:nOption, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 160 OF oApp():oDlg ;
		COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(CN->(OrdKeyNo()),'@E 999,999')+" / "+tran(CN->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_MCANCIONES"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nueva")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( CnForm( oApp():oGrid, "add", oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( CnForm( oApp():oGrid, "edt", oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( CnForm( oApp():oGrid, "dup", oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( CnBorrar( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( CnBuscar( oApp():oGrid, oCont, oApp():oTab:nOption, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( CnImprimir( oApp():oGrid ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "CnAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
     OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
     ITEMS " "+i18n("Título")+" ", " "+i18n("Intérprete")+" ", " "+i18n("Compositor")+" ", " "+i18n("Género")+" ",;
           " "+i18n("Duración")+" " ;
     COLOR CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
     ACTION ( CnTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont )

   if nBrwRecno <= CN->( ordKeyCount() )
      CN->( dbGoTo( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      ON INIT ( ResizeWndMain(),;
					 CnTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ),;
                oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0  ,;
              SetIni( , "Browse", "CnAbm-State", oApp():oGrid:SaveState() ),;
              SetIni( , "Browse", "CnAbm-Order", oApp():oTab:nOption ),;
              SetIni( , "Browse", "CnAbm-Recno", CN->( recNo() ) ),;
              SetIni( , "Browse", "CnAbm-Split", lTrim( str( oApp():oSplit:nleft / 2 ) ) ),;
              oCont:End(), dbCloseAll(),;
              oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .t. )

return NIL

/*_____________________________________________________________________________*/

function CnForm( oBrw, cModo, oCont, cClave, cContTitle )

   local oDlg
   local oFld
   local aGet       := array(05) //array( 06 )
   local aBtn       := array(03)
   local aBmp       := array(01)
   local oBrwCd
   local oCol

   local cCaption   := ""
   local lIdOk      := .F.
   local nRecBrw    := CN->( recNo() )
   local nRecAdd    := 0
   local nCdOrder   := CD->( ordNumber() )

   local cBrwState  := GetIni( , "Browse", "CnExtDi-State", "" )

   local cCaTitulo  := ""
   local cCaMateria := ""
   local cCaInterp  := ""
   local cCaAutor   := ""
   local cCaDuracc  := ""
   local cCaIdioma  := ""

   if cModo == "edt" .or. cModo == "dup"
      if CnDbfVacia()
         retu NIL
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if CN->( eof() ) .and. cModo != "add"
      return NIL
   endif

   oApp():nEdit++

   cModo := lower( cModo )

   do case

      // nuevo
      case cModo == "add"
         cCaption := i18n( "Añadir una Canción" )
         CN->( dbAppend() )
         if cClave != NIL
            cCaTitulo := cClave
         else
            cCaTitulo := space(30)
         endif
         CN->( dbCommit() )
         nRecAdd := CN->( recNo() )

      // modificar
      case cModo == "edt"
         cCaption := i18n( "Modificar una Canción" )
         cCaTitulo  := CN->CaTitulo

      // duplicar
      case cModo == "dup"
         cCaption := i18n( "Duplicar una Canción" )
         cCaTitulo  := CN->CaTitulo

   end case

   cCaMateria := CN->CaMateria
   cCaAutor   := CN->CaAutor
   cCaInterp  := CN->CaInterp
   cCaDuracc  := CN->CaDuracc
   cCaIdioma  := CN->CaIdioma

   if cModo == "dup"
      cCaTitulo := space( 60 )
   endif

   DEFINE DIALOG oDlg RESOURCE "CN_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE GET aGet[01] ;
      VAR cCaTitulo ;
      ID 100 ;
      OF oDlg ;
      VALID CnClave( cCaTitulo, aGet[01], cModo )

   REDEFINE AUTOGET aGet[02] ;
      VAR cCaAutor ;
      DATASOURCE {}						;
		FILTER AuListC( uDataSource, cData, Self );         
		HEIGHTLIST 100 ;
      ID 101 ;
      OF oDlg ;
      VALID ( AuClave( @cCaAutor, aGet[02], "aux", "C" ) )

   REDEFINE BUTTON aBtn[01];
      ID 107;
      OF oDlg;
      ACTION ( AuTabAux( @cCaAutor, aGet[02], "C" ),;
               aGet[02]:setFocus(),;
               SysRefresh() )

      aBtn[01]:cToolTip := i18n( "selecc. compositor" )

   REDEFINE AUTOGET aGet[03] ;
      DATASOURCE {}						;
      FILTER MaListM( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 102 ;
      OF oDlg ;
      VALID ( MaClave( @cCaMateria, aGet[03], "aux", "M" ) )

   REDEFINE BUTTON aBtn[02];
      ID 108;
      OF oDlg;
      ACTION ( MaTabAux( @cCaMateria, aGet[03], "M" ),;
               aGet[03]:setFocus(),;
               SysRefresh() )

      aBtn[02]:cToolTip := i18n( "selecc. género" )

   REDEFINE GET aGet[04] ;
      VAR cCaDuracc ;
      ID 103 ;
      OF oDlg

   REDEFINE AUTOGET aGet[05] ;
      VAR cCaIdioma ;
      DATASOURCE {}						;
      FILTER IdList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 104 ;
      OF oDlg ;
      VALID ( IdClave( @cCaIdioma, aGet[05], "aux" ) )

   REDEFINE BUTTON aBtn[03];
      ID 109;
      OF oDlg;
      ACTION ( IdTabAux( @cCaIdioma, aGet[05] ),;
               aGet[05]:setFocus(),;
               SysRefresh() )

      aBtn[03]:cToolTip := i18n( "selecc. idioma" )

   oBrwCd := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrwCd )

   oBrwCd:cAlias := "CD"

   oCol := oBrwCd:AddCol()
   oCol:bStrData := { || CD->cdMuCodigo }
   oCol:cHeader  := i18n( "Código" )
   oCol:nWidth   := 70

   oCol := oBrwCd:AddCol()
   oCol:bStrData := { || CD->cdMuTitulo }
   oCol:cHeader  := i18n( "Título" )
   oCol:nWidth   := 132

   oCol := oBrwCd:AddCol()
   oCol:bStrData := { || CD->cdMuInterp }
   oCol:cHeader  := i18n( "Intérprete" )
   oCol:nWidth   := 96

   aEval( oBrwCd:aCols, { |oCol| oCol:bLDClickData := { || lIdOk := .t., oDlg:End() } } )

   oBrwCd:lHScroll := .f.
   oBrwCd:SetRDD()
   oBrwCd:CreateFromResource( 105 )
   oDlg:oClient := oBrwCd
   oBrwCd:RestoreState( cBrwState )

   CD->( ordSetFocus( "CdCaTitulo" ) )
   CD->( ordScope( 0, upper( allTrim( cCaTitulo ) ) ) )
   CD->( ordScope( 1, upper( allTrim( cCaTitulo ) ) ) )
   CD->( dbGoTop() )

   // TLine():Redefine( oDlg, 500 )

   // REDEFINE BITMAP aBmp[01] ID 106 OF oDlg RESOURCE "CLIP_OFF" TRANSPARENT
   // aEval( aGet, { |oGet| oGet:bChange := { || ( aBmp[01]:reload( "CLIP_ON" ), aBmp[01]:refresh() ) } } )

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
      ON INIT oDlg:Center( oApp():oWndMain )

   do case
      // nuevo
      case cModo == "add"
         // aceptar
         if lIdOk == .T.
            // alta de la canción
            CN->( dbGoTo( nRecAdd ) )
            replace CN->CaTitulo  with cCaTitulo
            replace CN->CaInterp  with cCaInterp
            replace CN->CaAutor   with cCaAutor
            replace CN->CaMateria with cCaMateria
            replace CN->CaDuracc  with cCaDuracc
            replace CN->CaIdioma  with cCaIdioma
            CN->( dbCommit() )
            nRecBrw := CN->( recNo() )
            if cClave != NIL
               cClave := cCaTitulo
            endif
         // cancelar
         else
            CN->( dbGoTo( nRecAdd ) )
            CN->( dbDelete() )
         endif
      // modificar
      case cModo == "edt"
         // aceptar
         if lIdOk == .T.
            // relaciones con los discos
            CN->( dbGoTo( nRecBrw ) )
            if CN->CaTitulo != cCaTitulo
               CD->( dbSetOrder( 0 ) )
               CD->( dbGoTop() )
               msgRun( i18n( "Revisando el fichero de canciones de discos. Espere un momento..." ), oApp():cAppName,;
                  { || CD->( dbEval( { || _FIELD->CD->CdCaTitulo := rTrim( cCaTitulo ) },;
                  { || rTrim( CD->CdCaTitulo ) == rTrim( CN->CaTitulo ) },,,, .f. ) ) } )
               CD->( dbCommit() )
               CD->( ordSetFocus( "CdCaTitulo" ) )
            endif
            if CN->CaAutor != cCaAutor
               CD->( dbSetOrder( 0 ) )
               CD->( dbGoTop() )
               msgRun( i18n( "Revisando el fichero de canciones de discos. Espere un momento..." ), oApp():cAppName,;
                  { || CD->( dbEval( { || _FIELD->CD->CdCaAutor := rTrim( cCaAutor ) },;
                  { || rTrim( CD->CdCaTitulo ) == rTrim( CN->CaTitulo ) },,,, .f. ) ) } )
               CD->( dbCommit() )
               CD->( ordSetFocus( "CdCaTitulo" ) )
            endif
            // modificación de la canción
            replace CN->CaTitulo  with cCaTitulo
            replace CN->CaInterp  with cCaInterp
            replace CN->CaAutor   with cCaAutor
            replace CN->CaMateria with cCaMateria
            replace CN->CaDuracc  with cCaDuracc
            replace CN->CaIdioma  with cCaIdioma
            CN->( dbCommit() )
            nRecBrw := CN->( recNo() )
         endif
      // duplicar
      case cModo == "dup"
         // aceptar
         if lIdOk == .T.
            // duplicado de la canción
            CN->( dbAppend() )
            replace CN->CaTitulo  with cCaTitulo
            replace CN->CaInterp  with cCaInterp
            replace CN->CaAutor   with cCaAutor
            replace CN->CaMateria with cCaMateria
            replace CN->CaDuracc  with cCaDuracc
            replace CN->CaIdioma  with cCaIdioma
            CN->( dbCommit() )
            nRecBrw := CN->( recNo() )
         endif
   end case

   CD->( ordScope( 0, NIL ) )
   CD->( ordScope( 1, NIL ) )
   CD->( dbGoTop() )
   CD->( ordSetFocus( nCdOrder ) )

   SetIni( , "Browse", "CnExtDi-State", oBrwCd:SaveState()  )

   CN->( dbGoTo( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "CN", cContTitle )
   endif
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   endif

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function CnBorrar( oBrw, oCont, cContTitle )

   local nRecord := CN->( recNo() )
   local nNext   := 0
   local nCdOrd  := CD->( ordNumber() )

   if CnDbfVacia()
      return NIL
   endif

   if msgYesNo( i18n( "Si borra esta Canción, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarla?" ) +CRLF+CRLF ;
   + "'" + trim( CN->caTitulo ) + "', " + trim( CN->caAutor ) )
      CN->( dbSkip() )
      nNext := CN->( recNo() )
      CN->( dbGoto( nRecord ) )
      SELECT CD
      CD->( dbSetOrder( 0 ) )
      CD->( dbGoTop() )
      DELETE FOR rTrim( CD->CdCaTitulo ) == rTrim( CN->CaTitulo )
      CD->( dbCommit() )
      CD->( ordSetFocus( nCdOrd ) )
      CN->( dbDelete() )
      CN->( dbGoto( nNext ) )
      if CN->( eof() ) .or. nNext == nRecord
         CN->( dbGoBottom() )
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "CN", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return NIL

/*_____________________________________________________________________________*/

function CnBuscar( oBrw, oCont, nTabOpc, cChr, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local nRecNo   := CN->( recNo() )
   local lIdOk    := .f.
   local lFecha   := .f.
   local aBrowse  := {}

   if CnDbfVacia()
      return NIL
   endif

   oApp():nEdit++

   switch nTabOpc
      case 1
         cPrompt := i18n( "Introduzca el Título de la Canción" )
         cField  := i18n( "Título:" )
         cGet    := space( 60 )
         exit
      case 2
         cPrompt := i18n( "Introduzca el Intérprete de la Canción" )
         cField  := i18n( "Intérprete:" )
         cGet    := space( 40 )
         exit
      case 3
         cPrompt := i18n( "Introduzca el Compositor de la Canción" )
         cField  := i18n( "Compositor:" )
         cGet    := space( 40 )
         exit
      case 4
         cPrompt := i18n( "Introduzca el Género de la Canción" )
         cField  := i18n( "Género:" )
         cGet    := space( 30 )
         exit
      case 5
         cPrompt := i18n( "Introduzca la Duración de la Canción" )
         cField  := i18n( "Duración:" )
         cGet    := space( 10 )
         exit
      otherwise
         cPrompt := i18n( "Introduzca el Título de la Canción" )
         cField  := i18n( "Título:" )
         cGet    := space( 60 )
         exit
   end switch

   lFecha := valType( cGet ) == "D"

   DEFINE DIALOG oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Canciones" )
   oDlg:SetFont(oApp():oFont)

   REDEFINE SAY PROMPT cPrompt ID 20 OF oDlg
   REDEFINE SAY PROMPT cField  ID 21 OF oDlg

   if cChr != NIL
      if ! lFecha
         cGet := cChr + subStr( cGet, 1, len( cGet ) - 1 )
      else
         cGet := cTOd( cChr + " -  -    " )
      endif
   endif

   REDEFINE GET oGet VAR cGet ID 101 OF oDlg

   if cChr != NIL
      oGet:bGotFocus := { || ( oGet:setColor( CLR_BLACK, rgb( 255, 255, 127 ) ), oGet:setPos( 2 ) ) }
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
      ON INIT ( oDlg:Center( oApp():oWndMain ) )


   if lIdOk
      if ! lFecha
         cGet := rTrim( upper( cGet ) )
      else
         cGet := dTOs( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
            { || CnWildSeek(nTabOpc, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ninguna canción."))
      else
         CnEncontrados(aBrowse, oApp():oDlg)
      endif
   endif
   CnTabs( oBrw, nTabOpc, oCont, cContTitle)
   RefreshCont( oCont, "CN", cContTitle )
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return NIL
/*_____________________________________________________________________________*/

function CnWildSeek(nTabOpc, cGet, aBrowse)
   local nRecno   := CN->(Recno())

   do case
      case nTabOpc == 1
         CN->(DbGoTop())
         do while ! CN->(eof())
            if cGet $ upper(CN->CaTitulo)
               aadd(aBrowse, {CN->CaTitulo, CN->CaAutor, CN->CaMateria, CN->(Recno())})
            endif
            CN->(DbSkip())
         enddo
      case nTabOpc == 2
         CN->(DbGoTop())
         do while ! CN->(eof())
            if cGet $ upper(CN->CaInterp)
               aadd(aBrowse, {CN->CaTitulo, CN->CaAutor, CN->CaMateria, CN->(Recno())})
            endif
            CN->(DbSkip())
         enddo
      case nTabOpc == 3
         CN->(DbGoTop())
         do while ! CN->(eof())
            if cGet $ upper(CN->CaAutor)
               aadd(aBrowse, {CN->CaTitulo, CN->CaAutor, CN->CaMateria, CN->(Recno())})
            endif
            CN->(DbSkip())
         enddo
      case nTabOpc == 4
         CN->(DbGoTop())
         do while ! CN->(eof())
            if cGet $ upper(CN->CaMateria)
               aadd(aBrowse, {CN->CaTitulo, CN->CaAutor, CN->CaMateria, CN->(Recno())})
            endif
            CN->(DbSkip())
         enddo
      case nTabOpc == 5
         CN->(DbGoTop())
         do while ! CN->(eof())
            if cGet $ upper(CN->CaDuracc)
               aadd(aBrowse, {CN->CaTitulo, CN->CaAutor, CN->CaMateria, CN->(Recno())})
            endif
            CN->(DbSkip())
         enddo
   end case
   CN->(DbGoTo(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[1]) < upper(aAut2[1]) } )
return nil
/*_____________________________________________________________________________*/
function CnEncontrados(aBrowse, oParent)
   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := CN->(Recno())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .f.)
   oBrowse:aCols[1]:cHeader := "Título"
   oBrowse:aCols[2]:cHeader := "Compositor"
   oBrowse:aCols[3]:cHeader := "Género"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:nWidth  := 140
   oBrowse:aCols[4]:lHide   := .t.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   CN->(OrdSetFocus("titulo"))
   CN->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1])))
   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||CN->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                           CnForm(oBrowse,"edt",,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(CN->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                     CnForm(oBrowse,"edt",,oDlg)),) }
   oBrowse:bChange    := { || CN->((DbGoTo(aBrowse[oBrowse:nArrayAt, 4]))) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (CN->(DbGoTo(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function CnTabs( oBrw, nOpc, oCont, cContTitle )

   switch nOpc
      case 1
         CN->( ordSetFocus( "titulo" ) )
         exit
      case 2
         CN->( ordSetFocus( "interprete" ) )
         exit
      case 3
         CN->( ordSetFocus( "compositor" ) )
         exit
      case 4
         CN->( ordSetFocus( "materia" ) )
         exit
      case 5
         CN->( ordSetFocus( "duracion" ) )
         exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "CN", cContTitle )

return NIL

/*_____________________________________________________________________________*/

function CnTeclas( nKey, oBrw, oCont, nTabOpc, oDlg, cContTitle )

   switch nKey
      case VK_INSERT
         CnForm( oBrw, "add", oCont, , cContTitle )
         exit
      case VK_RETURN
         CnForm( oBrw, "edt", oCont, , cContTitle )
         exit
      case VK_DELETE
         CnBorrar( oBrw, oCont, cContTitle )
         exit
      case VK_ESCAPE
         oDlg:End()
         exit
      otherwise
         if nKey >= 97 .and. nKey <= 122
            nKey := nKey - 32
         endif
         if nKey >= 65 .and. nKey <= 90
            CnBuscar( oBrw, oCont, nTabOpc, chr( nKey ), cContTitle )
         endif
         exit
   end switch

return NIL

/*_____________________________________________________________________________*/

function CnTabAux( cGet, oGet, cGetComp, oGetComp, cGetDurac, oGetDurac, cGetIdiom, oGetIdiom )

   local oDlg
   local oBrw
   local oCol
   local aBtn       := array( 06 )

   local lIdOk      := .F.
   local aPoint     := AdjustWnd( oGet, 268*2, 157*2 )
   local cCaption   := i18n("Selección de Canciones")
   local nOrder     := CN->( ordNumber() )

   local cBrwState  := GetIni( , "Browse", "CnAux-State", "" )

   CN->( ordSetFocus( "titulo" ) )
   CN->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

      Ut_BrwRowConfig( oBrw )

      oBrw:cAlias := "CN"

      oCol := oBrw:AddCol()
      oCol:bStrData := { || CN->caTitulo }
      oCol:cHeader  := i18n( "Título" )
      oCol:nWidth   := 250

      aEval( oBrw:aCols, { |oCol| oCol:bLDClickData := { || lIdOk := .T., oDlg:End() } } )

      oBrw:lHScroll := .f.
      oBrw:SetRDD()
      oBrw:CreateFromResource( 110 )
      oBrw:bKeyDown := { |nKey| CnTeclas( nKey, oBrw, , 0, oDlg ) }
      oBrw:nRowHeight := 20

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg PROMPT i18n( "&Nueva" );
      ACTION ( CnForm( oBrw, "add" ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( CnForm( oBrw, "edt" ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( CnBorrar( oBrw ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( CnBuscar( oBrw, , 0, ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      ON PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet      := CN->CaTitulo
      oGet:Refresh()
      cGetComp  := CN->CaAutor
      oGetComp:Refresh()
      cGetDurac := CN->CaDuracc
      oGetDurac:Refresh()
      cGetIdiom := CN->CaIdioma
      oGetIdiom:Refresh()
   endif

   CN->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", "CnAux-State", oBrw:SaveState()    )

return NIL

/*_____________________________________________________________________________*/

function CnClave( cClave, oGet, cModo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "CN"
   local cMsgSi  := i18n( "Título de canción ya registrado." )
   local cMsgNo  := i18n( "Título de canción no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
   local cPkOrd  := "titulo"

   local lReturn := .f.
   local nRecno  := ( cAlias )->( recNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   if empty( cClave )
      if cModo == "aux"
         return .t.
      else
         msgStop( i18n( "Es obligatorio rellenar este campo." ) )
         return .f.
      endif
   endif

   ( cAlias )->( ordSetFocus( cPkOrd ) )
   ( cAlias )->( dbGoTop() )

   IF Val(cClave) != 0
      cClave := strZero( Val(cClave), 10 )
   ENDIF

   if ( cAlias )->( dbSeek( upper( cClave ) ) )
      do case
         case cModo == "add" .or. cModo == "dup"
            if msgYesNo( cMsgSi +CRLF+"¿ Desea introducirla de nuevo ?" )
               lReturn := .t.
            else
               lReturn := .f.
            endif
         case cModo == "edt"
            if ( cAlias )->( recNo() ) == nRecno
               lReturn := .t.
            else
               lReturn := .f.
               MsgStop( cMsgSi )
            endif
         case cModo == "aux"
            IF ! oApp():thefull
               Registrame()
            ENDIF
            lReturn := .t.
      end case
   else
      do case
         case cModo == "add" .or. cModo == "edt" .or. cModo == "dup"
            lReturn := .t.
         case cModo == "aux"
            if msgYesNo( cMsgNo )
               lReturn := CnForm( , "add", , @cClave )
               oGet:Refresh()
            else
               lReturn := .f.
            endif
      end case
   endif

   if ! lReturn
      oGet:setFocus()
   else
      oGet:cText := cClave
   endif

   ( cAlias )->( dbSetOrder( nOrder ) )
   ( cAlias )->( dbGoTo( nRecno ) )

return lReturn

/*_____________________________________________________________________________*/

function CnImprimir( oBrw )
                 //  título              campo         wd  shw  picture          tot
                 //  ==================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Título"    ), "CATITULO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Género"    ), "CAMATERIA" ,  0, .t.,            "NO", .f. },;
                   { i18n("Intérprete"), "CAINTERP"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Compositor"), "CAAUTOR"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Duración"  ), "CADURACC"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Idioma"    ), "CAIDIOMA"  ,  0, .t.,            "NO", .f. } }

   local nRecno   := CN->(Recno())
   local nOrder   := CN->(OrdSetFocus())
   local aCampos  := { "CATITULO", "CAMATERIA", "CAINTERP", "CAAUTOR", "CADURACC", "CAIDIOMA" }
   local aTitulos := { "Título", "Género", "Intérprete", "Compositor", "Duración", "Idioma" }
   local aWidth   := { 20, 20, 20, 10, 10, 10 }
   local aShow    := { .t., .t., .t., .t., .t., .t. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO" }

   local aTotal   := { .f., .f., .f., .f., .f., .f. }
   local oInforme
   local nAt
   local cAlias   := "CN"
   local cTotal   := "Total canciones: "
   local aGet     := array(11)
   local aSay     := array(2)
   local aBtn     := array(2)

   local aMa      := {}
   local cMa      := ""
   local nMaOrd   := MA->( ordNumber() )
   local nMaRec   := MA->( recNo() )

   local aIn      := {}
   local cIn      := ""
   local nInOrd   := AU->( ordNumber() )
   local nInRec   := AU->( recNo() )

   local aCo      := {}
   local cCo      := ""
   local nCoOrd   := AU->( ordNumber() )
   local nCoRec   := AU->( recNo() )

   if CnDbfVacia()
      return NIL
   endif

   oApp():nEdit++

   SELECT CN  // imprescindible

   FillCmb( "MA", "mmateria"    , aMa, "MaMateria", nMaOrd, nMaRec, @cMa )
   FillCmb( "AU", "compositores", aCo, "AuNombre" , nCoOrd, nCoRec, @cCo )
   FillCmb( "AU", "interpretes" , aIn, "AuNombre" , nInOrd, nInRec, @cIn )

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio ;
      VAR oInforme:nRadio ;
      ID 100, 101, 107, 103, 105 ;
      OF oInforme:oFld:aDialogs[1]

   REDEFINE COMBOBOX aGet[01] VAR cMa ITEMS aMa ID 102 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 2
   REDEFINE COMBOBOX aGet[02] VAR cIn ITEMS aCo ID 108 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 3
   REDEFINE COMBOBOX aGet[03] VAR cCo ITEMS aCo ID 104 OF oInforme:oFld:aDialogs[1] WHEN oinforme:nRadio == 4

   oInforme:Folders()
   if oInforme:Activate()
      nRecno := CN->( recNo() )
      nOrder := CN->( ordNumber() )
      do case
         case oInforme:nRadio == 1
            // todas las canciones, con el orden determinado
            CN->( dbGoTop() )
         case oInforme:nRadio == 2
            // canciones de un género
            CN->( ordSetFocus( "materia" ) )
            CN->( ordScope( 0, upper( rTrim( cMa ) ) ) )
            CN->( ordScope( 1, upper( rTrim( cMa ) ) ) )
            CN->( dbGoTop() )
         case oInforme:nRadio == 3
            // canciones de un intérprete
            CN->( ordSetFocus( "interprete" ) )
            CN->( ordScope( 0, upper( rTrim( cIn ) ) ) )
            CN->( ordScope( 1, upper( rTrim( cIn ) ) ) )
            CN->( dbGoTop() )
         case oInforme:nRadio == 4
            // canciones de un compositor
            CN->( ordSetFocus( "compositor" ) )
            CN->( ordScope( 0, upper( rTrim( cCo ) ) ) )
            CN->( ordScope( 1, upper( rTrim( cCo ) ) ) )
            CN->( dbGoTop() )
         case oInforme:nRadio == 5
            // ficha completa de la canción seleccionada
            CnImprimirFicha(oInforme)
      end case
      if oInforme:nRadio < 5
         Select CN
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
                     oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
                     oInforme:oReport:EndLine() )
      endif
      oInforme:End(.t.)
      CN->(DbSetOrder(nOrder))
      CN->(DbGoTo(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .t. )
   oApp():nEdit --
return NIL

/*_____________________________________________________________________________*/

function CnDbfVacia()

   local lReturn := .f.

   if CN->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ninguna canción registrada." ) )
      lReturn := .t.
   endif

return lReturn

/*_____________________________________________________________________________*/

function CnImprimirFicha( oInforme )

   local nRec    := CN->( recNo() )
   local oReport

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(CN->CaTitulo)
   oInforme:cTitulo2 := Rtrim("Ficha de la canción")

   if oInforme:nDevice == 1
      REPORT oInforme:oReport ;
         TITLE  " ",oInforme:cTitulo1,oInforme:cTitulo2,iif(oInforme:cTitulo3!=NIL,oInforme:cTitulo3," ") CENTERED;
         FONT   oInforme:oFont3, oInforme:oFont2, oInforme:oFont1 ;
         HEADER ' ', oApp():cAppName+oApp():cVersion, oApp():cUser   ;
         FOOTER ' ', "Fecha: "+dtoc(date())+ "   Página.: "+str(oInforme:oReport:nPage,3) ;
         CAPTION oApp():cAppName+oApp():cVersion PREVIEW
   elseif oInforme:nDevice == 2
      REPORT oInforme:oReport ;
         TITLE  " ",oInforme:cTitulo1,oInforme:cTitulo2,iif(oInforme:cTitulo3!=NIL,oInforme:cTitulo3," ") CENTERED;
         FONT   oInforme:oFont3, oInforme:oFont2, oInforme:oFont1 ;
         HEADER ' ', oApp():cAppName+oApp():cVersion, oApp():cUser   ;
         FOOTER ' ', "Fecha: "+dtoc(date())+ "   Página.: "+str(oInforme:oReport:nPage,3) ;
         CAPTION oApp():cAppName+oApp():cVersion
   endif
      COLUMN TITLE " " DATA " " SIZE 12
      COLUMN TITLE " " DATA " " SIZE 28
      COLUMN TITLE " " DATA " " SIZE  8
      COLUMN TITLE " " DATA " " SIZE 12
      COLUMN TITLE " " DATA " " SIZE 28
   END REPORT

   oInforme:oReport:Cargo := oInforme:cPdfFile

   if oInforme:oReport:lCreated
      oInforme:oReport:nTitleUpLine     := RPT_NOLINE
      oInforme:oReport:nTitleDnLine     := RPT_NOLINE
      oInforme:oReport:oTitle:aFont[2]  := {|| 3 }
      oInforme:oReport:oTitle:aFont[3]  := {|| 2 }
      oInforme:oReport:nTopMargin       := 0.1
      oInforme:oReport:nDnMargin        := 0.1
      oInforme:oReport:nLeftMargin      := 0.1
      oInforme:oReport:nRightMargin     := 0.1
      oInforme:oReport:oDevice:lPrvModal:= .t.
   endif

   ACTIVATE REPORT oInforme:oReport FOR CN->( recNo() ) == nRec ;
      ON INIT CnImprimirFicha2( oInforme:oReport, nRec )

   CN->( dbGoTo( nRec ) )
   // CD->( ordScope( 0, NIL ) )
   // CD->( ordScope( 1, NIL ) )

return NIL

/*_____________________________________________________________________________*/

function CnImprimirFicha2( oReport, nRec )

   local i        := 0
   local aDiscos  := {}

   CN->( dbGoTo( nRec ) )

   oReport:StartLine()
   oReport:Say( 1, i18n("Título:"), 2 )
   oReport:Say( 2, CN->CaTitulo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Compositor:"), 2 )
   oReport:Say( 2, CN->CaAutor        , 1 )
   oReport:Say( 4, i18n("Género:")    , 2 )
   oReport:Say( 5, CN->CaMateria      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Duración:"), 2 )
   oReport:Say( 2, CN->CaDuracc     , 1 )
   oReport:Say( 4, i18n("Idioma:")  , 2 )
   oReport:Say( 5, CN->CaIdioma     , 1 )
   oReport:EndLine()

   // discos en que aparece
   CD->( ordSetFocus( "CdCaTitulo" ) )
   if CD->( dbSeek( upper( CN->CaTitulo ) ) )
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 1, i18n("Discos en que aparece"), 2 )
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 2, i18n("Código")    , 2 )
      oReport:Say( 3, i18n("Título")    , 2 )
      oReport:Say( 5, i18n("Intérprete"), 2 )
      oReport:EndLine()
      CD->( ordScope( 0, upper( CN->CaTitulo ) ) )
      CD->( ordScope( 1, upper( CN->CaTitulo ) ) )
      CD->( dbGoTop() )
      while ! CD->( eof() )
         aAdd( aDiscos, CD->CdMuCodigo )
         CD->( dbSkip() )
      end while
      MU->( dbGoTop() )
      while ! MU->( eof() )
         if aScan( aDiscos, { |nMuCod| nMuCod == MU->MuCodigo } ) != 0
            oReport:StartLine()
            oReport:Say( 2, MU->MuCodigo, 1 )
            oReport:Say( 3, MU->MuTitulo, 1 )
            oReport:Say( 5, MU->MuAutor , 1 )
            oReport:EndLine()
         endif
         MU->( dbSkip() )
      end while
      CD->( ordScope( 0, NIL ) )
      CD->( ordScope( 1, NIL ) )
   endif
return NIL
