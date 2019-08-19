**
* PROYECTO ..: Cuaderno de Bitácora
* COPYRIGHT .: (c) alanit software
* URL .......: www.alanit.com
**

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "splitter.ch"
#include "vMenu.ch"
#include "AutoGet.ch"

extern deleted
Static oLiImage

/*-----------------------------------------------------------------------------
 * función .: Libros()
 * prec ....: True
 * post ....: Muestra el TFsdi de Libros.
*/

function Libros()
   local oBar
   local oCol
   local oCont
	local oLiMenu
	local oVMItem
   local cBrwState := GetIni( , "Browse", "LiAbm-State", "" )
   local nBrwSplit := val( GetIni( , "Browse", "LiAbm-Split", "102" ) )
   local nBrwRecno := val( GetIni( , "Browse", "LiAbm-Recno", "1" ) )
   local nBrwOrder := val( GetIni( , "Browse", "LiAbm-Order", "1" ) )

   local n := 0

   if ModalSobreFsdi()
      retu NIL
   endif

   if ! Db_OpenAll()
      retu NIL
   endif
	SELECT LI
   LI->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Libros" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )
	oApp():oGrid:cAlias := "LI"

	ADD oCol TO oApp():oGrid DATA LI->LiCodigo ;
		HEADER "Código" WIDTH 70

	ADD oCol TO oApp():oGrid DATA LI->LiTitulo ;
		HEADER "Título" WIDTH 170

	ADD oCol TO oApp():oGrid DATA LI->LiTitOrig;
		HEADER "Título original" WIDTH 170

	ADD oCol TO oApp():oGrid DATA LI->LiAutor  ;
		HEADER "Autor" WIDTH 100

	ADD oCol TO oApp():oGrid DATA LI->LiMateria ;
		HEADER "Materia" WIDTH 100

	ADD oCol TO oApp():oGrid DATA LI->LiIdioma  ;
		HEADER "idioma" WIDTH 80

	ADD oCol TO oApp():oGrid DATA LI->LiPropiet ;
		HEADER "Propietario" WIDTH 140

	ADD oCol TO oApp():oGrid DATA LI->LiUbicaci ;
		HEADER "Ubicación" WIDTH 100

	ADD oCol TO oApp():oGrid DATA LI->LiEditor  ;
		HEADER "Editorial" WIDTH 140

	ADD oCol TO oApp():oGrid DATA LI->LiNumEdic ;
		HEADER "Nº Edic." WIDTH 70

	ADD oCol TO oApp():oGrid DATA LI->LiISBN ;
		HEADER "I.S.B.N." WIDTH 70

	ADD oCol TO oApp():oGrid DATA LI->LiAnoEdic ;
		HEADER "Año Edic." WIDTH 70

	ADD oCol TO oApp():oGrid DATA LI->LiCiudad  ;
		HEADER "Ciudad Edic." WIDTH 70

	ADD oCol TO oApp():oGrid DATA LI->LiEncuad ;
		HEADER "Encuadernación." WIDTH 70

	ADD oCol TO oApp():oGrid DATA LI->LiPaginas ;
		HEADER "Nº Pág.." WIDTH 50

	ADD oCol TO oApp():oGrid DATA LI->LiColecc ;
		HEADER "Colección" WIDTH 90

	ADD oCol TO oApp():oGrid DATA LI->LiNumTomos ;
		HEADER "Nº Tomos" WIDTH 55

	ADD oCol TO oApp():oGrid DATA LI->LiEsteTomo ;
		HEADER "Tomo Nº" WIDTH 55

	ADD oCol TO oApp():oGrid DATA LI->LiFchAdq ;
		HEADER "Fch. Compra" WIDTH 80

	ADD oCol TO oApp():oGrid DATA LI->LiProveed ;
		HEADER "Centro compra" WIDTH 80

	ADD oCol TO oApp():oGrid DATA LI->LiPrecio ;
		HEADER "Precio" PICTURE "@E 999,999.99" ;
		TOTAL 0 WIDTH 80
	
	ADD oCol TO oApp():oGrid HEADER "Imagen" WIDTH 80
		oCol:AddResource( "BR_IMG1" )
		oCol:AddResource( "BR_IMG2" )
		oCol:bBmpData := { || if( !empty( LI->liImagen ), 1, 2 ) }

	ADD oCol TO oApp():oGrid HEADER "Prestado" WIDTH 80
		oCol:AddResource( "16_PRES_ON" )
		oCol:AddResource( "16_PRES_OFF" )
		oCol:bBmpData := { || if( IsPrestado( "LI" ), 1, 2 ) }

	ADD oCol TO oApp():oGrid DATA LI->LiFechaPr ;
		HEADER "Fch. préstamo" WIDTH 80
	
	ADD oCol TO oApp():oGrid DATA LI->LiPrestad ;
		HEADER "Prestatario"   WIDTH 140

	ADD oCol TO oApp():oGrid DATA LI->LiObserv ;
		HEADER "Comentarios"   WIDTH 140

	ADD oCol TO oApp():oGrid DATA LI->LiResumen ;
		HEADER "Resumen"   WIDTH 140

	ADD oCol TO oApp():oGrid DATA LI->LiValoraci ;
		HEADER "Valoración"   WIDTH 100

	ADD oCol TO oApp():oGrid DATA LI->LiFchLec ;
		HEADER "Fch. Lectura"   WIDTH 140


   aEval( oApp():oGrid:aCols, { |oCol| oCol:bLDClickData := { || LiForm( oApp():oGrid, "edt", oCont ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := { || RefreshCont( oCont, "LI", "Libros: "), RefreshLiImage(), oApp():oGrid:Maketotals() }
   oApp():oGrid:bKeyDown   := { |nKey| LiTeclas( nKey, oApp():oGrid, oCont, oApp():oTab:nOption, oApp():oDlg ) }
   oApp():oGrid:nRowHeight := 21
	oApp():oGrid:lFooter := .t.
	oApp():oGrid:bClrFooter := {|| { CLR_HRED, GetSysColor(15) } }
 	oApp():oGrid:MakeTotals()
		// oApp():oWndMain:oClient := oGrid

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 175 OF oApp():oDlg ;
		COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX 

   DEFINE TITLE OF oCont;
      CAPTION "Libros: "+tran(LI->(OrdKeyNo()),'@E 999,999')+" / "+tran(LI->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_LIBROS" OPENCLOSE

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( LiForm( oApp():oGrid, "add", oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( LiForm( oApp():oGrid, "edt", oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( LiForm( oApp():oGrid, "dup", oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( LiBorrar( oApp():oGrid, oCont ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( LiBuscar( oApp():oGrid, oCont, oApp():oTab:nOption, ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( LiImprimir( oApp():oGrid ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Devolver")           ;
      IMAGE "16_devolver"          ;
      ACTION ( LiDevolver(), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Ver imagen")         ;
      IMAGE "16_imagen"             ;
      ACTION ( Liximagen( LI->LiImagen, LI->LiTitulo ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

	MENU oLiMenu POPUP 2007
		MENUITEM "Sin filtro" ;
			ACTION LiFilter( 0, oCont, oLiMenu, oVMItem );
			CHECKED
		SEPARATOR
		MENUITEM "Filtrar por autor" ;
			ACTION LiFilter( 1, oCont, oLiMenu, oVMItem )
		MENUITEM "Filtrar por materia";
			ACTION LiFilter( 2, oCont, oLiMenu, oVMitem )
		MENUITEM "Filtrar por idioma";
			ACTION LiFilter( 3, oCont, oLiMenu, oVMitem )
		MENUITEM "Filtrar por propietario";
			ACTION LiFilter( 4, oCont, oLiMenu, oVMitem )
		MENUITEM "Filtrar por ubicación";
			ACTION LiFilter( 5, oCont, oLiMenu, oVMitem )
		MENUITEM "Filtrar por editorial";
			ACTION LiFilter( 6, oCont, oLiMenu, oVMitem )
		MENUITEM "Filtrar por colección";
			ACTION LiFilter( 7, oCont, oLiMenu, oVMitem )
		SEPARATOR
		MENUITEM "Libros comprados el último mes";
			ACTION LiFilter( 10, oCont, oLiMenu, oVMitem )
		MENUITEM "Libros comprados el último año";
			ACTION LiFilter( 11, oCont, oLiMenu, oVMitem )
	ENDMENU

	DEFINE VMENUITEM oVMItem OF oCont ;
		CAPTION "Filtrar libros"    	 ;
		IMAGE "16_FILTRO"              ;
		MENU oLiMenu 						 ;
		LEFT 10

	DEFINE VMENUITEM OF oCont         ;
		INSET HEIGHT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar a Excel"     ;
      IMAGE "16_EXCEL"             ;
      ACTION (CursorWait(), oApp():oGrid:ToExcel(), CursorArrow()); // ACTION (CursorWait(), Ut_ExportXls(oApp():oGrid), CursorArrow());
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Configurar rejilla") ;
      IMAGE "16_grid"              ;
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "LiAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() ) ;
      LEFT 10

   @ 180, 05 VMENU oBar SIZE nBrwSplit-10, 3*nBrwSplit OF oApp():oDlg  ;
      COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX ATTACH TO oCont
	oBar:nClrBox := MIN(GetSysColor(13), GetSysColor(14))

   DEFINE TITLE OF oBar;
      CAPTION i18n("Portada");
      HEIGHT 25 ;
		COLOR GetSysColor(9), oApp():nClrBar  	

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
     OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Título")+" "    , " "+i18n("Tít. Original")+" "   , " "+i18n("Código")+" "     , " "+i18n("Autor")+" "    ,;
            " "+i18n("Materia")+" "   , " "+i18n("Propietario")+" ", " "+i18n("Ubicación")+" ",;
            " "+i18n("Editor")+" "    , " "+i18n("Año Edic.")+" "  , " "+i18n("Colección")+" ",;
            " "+i18n("Fch.Compra")+" ", " "+i18n("Fch.Préstamo")+" ";
      COLOR CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
      ACTION ( LiTabs( oApp():oGrid, oApp():oTab:nOption, oCont ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar, oLiImage )

   if nBrwRecno <= LI->( ordKeyCount() )
      LI->( dbGoTo( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      ON INIT ( ResizeWndMain(),;
					 LiBarImage(oBar, nBrwSplit),;
                LiTabs( oApp():oGrid, oApp():oTab:nOption, oCont ),;
                oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
              SetIni( , "Browse", "LiAbm-State", oApp():oGrid:SaveState() ),;
              SetIni( , "Browse", "LiAbm-Order", oApp():oTab:nOption ),;
              SetIni( , "Browse", "LiAbm-Recno", LI->( recNo() ) ),;
              SetIni( , "Browse", "LiAbm-Split", lTrim( str( oApp():oSplit:nleft / 2 ) ) ),;
              oBar:End(), oCont:End(), dbCloseAll(),;
              oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .t. )

return NIL
/*-----------------------------------------------------------------------------*/

function LiBarImage(oBar, nBrwSplit)
	oLiImage := TXImage():New( 35, 10, ( 2 * nBrwSplit ) -40, ( 2.6 * nBrwSplit ) -40,,oBar,.t.,.f. )
   IF File(lfn2sfn(rtrim(LI->LiImagen)))
      oLiImage:SetSource( lfn2sfn(rtrim(LI->LiImagen)))
	ELSE 
		oLiImage:Hide()
   ENDIF
   oLiImage:Refresh()

return nil
/*-----------------------------------------------------------------------------*/
function RefreshLiImage()
	oLiImage:Hide()
	if File(lfn2sfn(rtrim(LI->LiImagen)))
      oLiImage:SetSource( lfn2sfn(rtrim(LI->LiImagen)))
		oLiImage:Show()
	endif
	oLiImage:Refresh()
return nil
/*-----------------------------------------------------------------------------
 * función .: LiForm()
 * prec ....: oBrw != NIL && ( $E x : {'add','edt','dup'} : cModo == x )
 * post ....: Muestra el TFsdi de Libros.
*/

function LiForm( oBrw, cModo, oCont )
   local oDlg
   local oFld
   local aSay          := array(20)
   local aGet          := array(30)
   local aBtn          := array(17)
   local aBmp          := array(02)
   local oBtnBmp
   local oBtnImg

   local cCaption      := ""
   local lIdOk         := .f.
   local nRecBrw       := LI->( recNo() )
   local nRecAdd       := 0
   local lPrestado     := .f.
   local lPresEdit     := .t.

   local cLiCodigo     := ""
   local cLiTitulo     := ""
   local cLiTitOrig    := ""
   local cLiPropiet    := ""
   local cLiAutor      := ""
   local cLiIdioma     := ""
   local cLiEditor     := ""
   local nLiAnoEdic    := 0
   local nLiNumEdic    := 0
   local cLiIsbn       := ""
   local nLiPrecio     := 0
   local dLiFchaDq     := date()
   local cLiProveed    := ""
   local cLiMateria    := ""
   local cLiPrestad    := ""
   local dLiFechaPr    := date()
   local cLiUbicaci    := ""
   local cLiCiudad     := ""
   local nLiPaginas    := 0
   local cLiEncuad     := ""
   local nLiValoraci   := 0
   local dLiFchLec     := CtoD('')
   local mLiObserv
   local cLiColecc     := ""
   local nLiNumTomos   := 0
   local nLiEsteTomo   := 0
   local cLiImagen     := ""
	local cLiResumen	  := ""

   if cModo == "edt" .or. cModo == "dup"
      if LiDbfVacia()
         retu NIL
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if LI->( eof() ) .and. cModo != "add"
      retu NIL
   endif

   oApp():nEdit++

   cModo := lower( cModo )

   do case
      // nuevo
      case cModo == "add"
         cCaption := i18n( "Añadir un Libro" )
         LI->( dbAppend() )
         LI->( dbCommit() )
         nRecAdd := LI->( recNo() )
      // modificar
      case cModo == "edt"
         cCaption := i18n( "Modificar un Libro" )
      // duplicar
      case cModo == "dup"
         cCaption := i18n( "Duplicar un Libro" )
   endcase

   // ambos casos
   cLiCodigo   := LI->liCodigo
   cLiTitulo   := LI->liTitulo
   cLiTitOrig  := LI->liTitOrig
   cLiPropiet  := LI->liPropiet
   cLiAutor    := LI->liAutor
   cLiIdioma   := LI->liIdioma
   cLiEditor   := LI->liEditor
   nLiAnoEdic  := LI->liAnoEdic
   nLiNumEdic  := LI->liNumEdic
   cLiIsbn     := LI->liIsbn
   nLiPrecio   := LI->liPrecio
   dLiFchaDq   := LI->liFchaDq
   cLiProveed  := LI->liProveed
   cLiMateria  := LI->liMateria
   cLiPrestad  := LI->liPrestad
   dLiFechaPr  := LI->liFechaPr
   cLiUbicaci  := LI->liUbicaci
   cLiCiudad   := LI->liCiudad
   nLiPaginas  := LI->liPaginas
   cLiEncuad   := LI->liEncuad
   nLiValoraci := LI->liValoraci
   dLiFchLec   := LI->LiFchLec
   mLiObserv   := LI->liObserv
   cLiColecc   := LI->liColecc
   nLiNumTomos := LI->liNumTomos
   nLiEsteTomo := LI->liEsteTomo
   cLiImagen   := LI->liImagen
	cLiResumen  := LI->liResumen

   do case
      case cModo == "add" .and. oApp():lCodAut
         GetNewCod( .f., "LI", "LiCodigo", @cLiCodigo )
      case cModo == "dup"
         if oApp():lCodAut
            GetNewCod( .f., "LI", "LiCodigo", @cLiCodigo )
         else
            cLiCodigo := space( 10 )
         endif
   endcase

   lPresEdit := if( cModo == "edt", ( empty( cLiPrestad ) .or. dLiFechaPr == cTOd( "" ) ), .t. )

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "LI_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   // Diálogo principal

   REDEFINE GET aGet[01] ;
      VAR cLiTitulo ;
      ID 100 ;
      OF oDlg ;
      WHEN ( lPresEdit )

   REDEFINE GET aGet[02] ;
      VAR cLiCodigo ;
      ID 101 ;
      OF oDlg ;
      WHEN ( lPresEdit ) ;
      VALID ( LiClave( cLiCodigo, aGet[02], cModo ) )

   REDEFINE BUTTON aBtn[01];
      ID 111;
      OF oDlg;
      WHEN ( lPresEdit );
      ACTION ( GetNewCod( .t., "LI", "LiCodigo", @cLiCodigo ), aGet[02]:refresh(), aGet[02]:setFocus() )

      aBtn[01]:cToolTip := i18n( "generar código autonumérico" )

   REDEFINE GET aGet[03] ;
      VAR cLiTitOrig ;
      ID 102 ;
      OF oDlg

   REDEFINE AUTOGET aGet[04] ;
      VAR cLiAutor ; // ITEMS oAGet():aAuLi ;
		DATASOURCE {}						;
		FILTER AuListE( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 103 ;
      OF oDlg ;
      VALID ( AuClave( @cLiAutor, aGet[04], "aux", "E" ) ) 

   REDEFINE BUTTON aBtn[02];
      ID 112;
      OF oDlg;
      ACTION ( AuTabAux( @cLiAutor, aGet[04], "E" ),;
               aGet[04]:setFocus(),;
               SysRefresh() )

      aBtn[02]:cToolTip := i18n( "selecc. escritor" )

   REDEFINE AUTOGET aGet[05] ;
      VAR cLiMateria ; // ITEMS oAGet():aMALi ;
		DATASOURCE {}						;
		FILTER MaListL( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 104 ;
      OF oDlg ;
      VALID ( MaClave( @cLiMateria, aGet[05], "aux", "L" ) ) 

   REDEFINE BUTTON aBtn[03];
      ID 113;
      OF oDlg;
      ACTION ( MaTabAux( @cLiMateria, aGet[05], "L" ),;
               aGet[05]:setFocus(),;
               SysRefresh() )
      aBtn[03]:cToolTip := i18n( "selecc. materia" )

   REDEFINE AUTOGET aGet[06] ;
      VAR cLiIdioma ; // ITEMS oAGet():aId ;
		DATASOURCE {}						;
		FILTER IdList( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 105 ;
      OF oDlg ;
      VALID ( IdClave( @cLiIdioma, aGet[06], "aux" ) )

   REDEFINE BUTTON aBtn[04];
      ID 114;
      OF oDlg;
      ACTION ( IdTabAux( @cLiIdioma, aGet[06] ),;
               aGet[06]:setFocus(),;
               SysRefresh() )

      aBtn[04]:cToolTip := i18n( "selecc. idioma" )

   REDEFINE AUTOGET aGet[07] ;
      VAR cLiPropiet ; // ITEMS oAGet():aAGPr ;
		DATASOURCE {}						;
		FILTER AgListP( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 106 ;
      OF oDlg ;
      VALID ( AgClave( @cLiPropiet, aGet[07], "aux", "P" ) )

   REDEFINE BUTTON aBtn[05];
      ID 115;
      OF oDlg;
      ACTION ( AgTabAux( @cLiPropiet, aGet[07], "P" ),;
               aGet[07]:setFocus(),;
               SysRefresh() )
      aBtn[05]:cToolTip := i18n( "selecc. propietario" )

   REDEFINE AUTOGET aGet[08] ;
      VAR cLiUbicaci ; // ITEMS oAGet():aUbLi ;
		DATASOURCE {}						;
		FILTER UbListL( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 107 ;
      OF oDlg ;
      VALID ( UbClave( @cLiUbicaci, aGet[08], "aux", "L" ) )

   REDEFINE BUTTON aBtn[06];
      ID 116;
      OF oDlg;
      ACTION ( UbTabAux( @cLiUbicaci, aGet[08], "L" ),;
               aGet[08]:setFocus(),;
               SysRefresh() )

      aBtn[06]:cToolTip := i18n( "selecc. ubicación" )

   REDEFINE XIMAGE aGet[27] ID 117 OF oDlg FILE "" //SCROLL

   if File(lfn2sfn(rtrim(cLiImagen)))
      aGet[27]:SetSource(lfn2sfn(rtrim(cLiImagen)))
		aGet[27]:Refresh()
   endif

   REDEFINE FOLDER oFld ;
      ID 108 ;
      OF oDlg ;
      ITEMS i18n("&Edición"), i18n("Co&lección"), i18n("&Observaciones"),;
            i18n("&Imagen"), i18n("Co&mpra"), i18n("&Préstamo"), i18n("&Valoración") ;
      DIALOGS "LI_FORM_A", "LI_FORM_B", "LI_FORM_C", "LI_FORM_D", "LI_FORM_E", "LI_FORM_F", "LI_FORM_G"

   // Primer folder: datos de edición

   REDEFINE SAY aSay[01] ID 200 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[03] ID 202 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[04] ID 203 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[05] ID 204 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[06] ID 205 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[07] ID 206 OF oFld:aDialogs[1]

   REDEFINE AUTOGET aGet[09] ;
      VAR cLiEditor ; 
		DATASOURCE {}						;
		FILTER EdListL( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100 ;
      OF oFld:aDialogs[1] ;
      VALID ( EdClave( @cLiEditor, aGet[09], "aux", "L" ) )

   REDEFINE BUTTON aBtn[07];
      ID 107;
      OF oFld:aDialogs[1];
      ACTION ( EdTabAux( @cLiEditor, aGet[09], "L" ),;
               aGet[09]:setFocus(),;
               SysRefresh() )

      aBtn[07]:cToolTip := i18n( "selecc. editorial" )

   REDEFINE GET aGet[10] VAR cLiCiudad  ID 101 OF oFld:aDialogs[1]
   REDEFINE GET aGet[11] VAR cLiIsbn    ID 102 OF oFld:aDialogs[1]
   REDEFINE GET aGet[12] VAR nLiAnoEdic ID 103 OF oFld:aDialogs[1] PICTURE "9999"
   REDEFINE GET aGet[13] VAR nLiNumEdic ID 104 OF oFld:aDialogs[1] PICTURE "999"
   REDEFINE GET aGet[14] VAR nLiPaginas ID 105 OF oFld:aDialogs[1] PICTURE "@E 9,999"
   REDEFINE GET aGet[15] VAR cLiEncuad  ID 106 OF oFld:aDialogs[1]

   // Segundo folder: datos de colección

   REDEFINE SAY aSay[08] ID 200 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[09] ID 201 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[10] ID 202 OF oFld:aDialogs[2]

   REDEFINE AUTOGET aGet[16]  ;
      VAR cLiColecc           ; // ITEMS oAGet():aClLi     ;
		DATASOURCE {}						;
		FILTER ClListL( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[2]     ;
      VALID ( ClClave( @cLiColecc, aGet[16], "aux", "L" ) )

   REDEFINE BUTTON aBtn[08];
      ID 103;
      OF oFld:aDialogs[2];
      ACTION ( ClTabAux( @cLiColecc, aGet[16], "L", @nLiNumTomos, aGet[17] ),;
               aGet[16]:setFocus(),;
               SysRefresh() )

      aBtn[08]:cToolTip := i18n( "selecc. colección" )

   REDEFINE GET aGet[17] VAR nLiNumTomos ID 101 OF oFld:aDialogs[2] PICTURE "@E 999,999"
   REDEFINE GET aGet[18] VAR nLiEsteTomo ID 102 OF oFld:aDialogs[2] PICTURE "@E 999,999"

   // Tercer folder: observaciones

   REDEFINE SAY aSay[11] ID 200 OF oFld:aDialogs[3]
	REDEFINE SAY aSay[20] ID 201 OF oFld:aDialogs[3]

   REDEFINE GET aGet[19] VAR mLiObserv ID 100 OF oFld:aDialogs[3] MEMO
	
	REDEFINE GET aGet[30] var cLiResumen       ;
      ID 101 OF oFld:aDialogs[3] UPDATE      
   REDEFINE BUTTON aBtn[16]                  ;
      ID 102 OF oFld:aDialogs[3] UPDATE      ;
      ACTION aGet[30]:cText := cGetFile32('*.*','indique la ubicación del resumen',,,,.T.) 
   aBtn[16]:cTooltip := "seleccionar fichero"
   REDEFINE BUTTON aBtn[17]                  ;
      ID 103 OF oFld:aDialogs[3] UPDATE      ;
      ACTION GoFile( cLiResumen )            
   aBtn[17]:cTooltip := "ejecutar fichero"

   // Cuarto folder: imagen

   REDEFINE SAY aSay[12] ID 200 OF oFld:aDialogs[4]

   REDEFINE GET aGet[20] ;
      VAR cLiImagen ;
      ID 100 ;
      OF oFld:aDialogs[4] ;
      VALID ( aGet[21]:SetSource( , cLiImagen ), aGet[21]:refresh(), ;
              aGet[27]:SetSource( , cLiImagen ), aGet[27]:refresh(), .t. )

   REDEFINE BUTTON aBtn[09];
      ID 103;
      OF oFld:aDialogs[4];
      ACTION LiGetImagen( aGet[21], aGet[27], aGet[20], oBtnImg )

      aBtn[09]:cToolTip := i18n( "selecc. imagen" )

   REDEFINE XIMAGE aGet[21] FILE "" ID 101 OF oFld:aDialogs[4] //SCROLL

   aGet[21]:SetColor( CLR_RED, CLR_WHITE )

   if File(lfn2sfn(rtrim(cLiImagen)))
      aGet[21]:SetSource(lfn2sfn(rtrim(cLiImagen)))
   endif

   REDEFINE BUTTON oBtnImg ;
      ID 102 ;
      OF oFld:aDialogs[4] ;
      ACTION Liximagen( cLiImagen, cLiTitulo )

   // Quinto folder: datos de compra

   REDEFINE SAY aSay[13] ID 200 OF oFld:aDialogs[5]
   REDEFINE SAY aSay[14] ID 201 OF oFld:aDialogs[5]
   REDEFINE SAY aSay[15] ID 202 OF oFld:aDialogs[5]

   REDEFINE AUTOGET aGet[22] ;
      VAR cLiProveed ; // ITEMS oAGet():aAgCo ;
		DATASOURCE {}						;
		FILTER CcList( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100 ;
      OF oFld:aDialogs[5] ;
      VALID ( CcClave( @cLiProveed, aGet[22], "aux", "O" ) )

   REDEFINE BUTTON aBtn[10];
      ID 103;
      OF oFld:aDialogs[5];
      ACTION ( CcTabAux( @cLiProveed, aGet[22], "O" ),;
               aGet[22]:setFocus(),;
               SysRefresh() )
   aBtn[10]:cToolTip := i18n( "selecc. centro de compra" )

   REDEFINE GET aGet[23] ;
      VAR dLiFchaDq ;
      ID 101 ;
      OF oFld:aDialogs[5]

   REDEFINE BUTTON aBtn[11];
      ID 104;
      OF oFld:aDialogs[5];
      ACTION ( SelecFecha( dLiFchaDq, aGet[23] ),;
               aGet[23]:setFocus(),;
               SysRefresh() )
   aBtn[11]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[24] VAR nLiPrecio ID 102 OF oFld:aDialogs[5] PICTURE "@E 999,999.99 "
   // aGet[24]:bKeyDown = {|nKey| IIF( nKey == VK_SPACE, ShowCalculator( aGet[24] ), .T. ) }

   // Sexto folder: préstamo

   REDEFINE SAY aSay[16] ID 200 OF oFld:aDialogs[6]
   REDEFINE SAY aSay[17] ID 201 OF oFld:aDialogs[6]

   REDEFINE AUTOGET aGet[25] ;
      VAR cLiPrestad ; // ITEMS oAGet():aAgTo ;
		DATASOURCE {}						;
		FILTER AgListC( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100 ;
      OF oFld:aDialogs[6] ;
      VALID ( AgClave( @cLiPrestad, aGet[25], "aux", "C" ) )

   REDEFINE BUTTON aBtn[12];
      ID 103;
      OF oFld:aDialogs[6];
      ACTION ( AgTabAux( @cLiPrestad, aGet[25], "C" ),;
               aGet[25]:setFocus(),;
               SysRefresh() )

      aBtn[12]:cToolTip := i18n( "selecc. prestatario" )

   REDEFINE BUTTON ;
      ID 101 ;
      OF oFld:aDialogs[6] ;
      WHEN ( !empty( cLiPrestad ) .or. dLiFechaPr != cTOd( "" ) ) ;
      ACTION ( iif( msgYesNo( i18n("¿Desea anotar la devolución del libro?") ),;
                     ( cLiPrestad := space( 30 ),;
                       aGet[25]:refresh(),;
                       dLiFechaPr := cTOd( "" ),;
                       aGet[26]:refresh(),;
                       aBmp[02]:reload( "16_pres_off" ),;
                       aBmp[02]:refresh(),;
                       SysRefresh() ), ),;
               aGet[25]:setFocus() )

   REDEFINE GET aGet[26] ;
      VAR dLiFechaPr ;
      ID 102 ;
      OF oFld:aDialogs[6]

   REDEFINE BUTTON aBtn[13];
      ID 104;
      OF oFld:aDialogs[6];
      ACTION ( SelecFecha( dLiFechaPr, aGet[26] ),;
               aGet[26]:setFocus(),;
               SysRefresh() )

      aBtn[13]:cToolTip := i18n( "selecc. fecha" )

   // Septimo folder: valoración

   REDEFINE SAY aSay[18] ID 200 OF oFld:aDialogs[7]
   REDEFINE SAY aSay[19] ID 201 OF oFld:aDialogs[7]

   REDEFINE GET aGet[28] ;
      VAR nLiValoraci    ;
      ID 100 ;
      OF oFld:aDialogs[7];
      SPINNER

   REDEFINE GET aGet[29] ;
      VAR dLiFchLec      ;
      ID 102 ;
      OF oFld:aDialogs[7]

   REDEFINE BUTTON aBtn[14];
      ID 104;
      OF oFld:aDialogs[7];
      ACTION ( SelecFecha( dLiFchLec, aGet[29] ),;
               aGet[28]:setFocus(),;
               SysRefresh() )

      aBtn[14]:cToolTip := i18n( "selecc. fecha" )


   // Diálogo principal

   REDEFINE BITMAP aBmp[02] ID 110 OF oDlg RESOURCE "16_pres_off" TRANSPARENT

   //REDEFINE BUTTON ;
   //   ID 401  ;
   //   OF oDlg ;
   //   ACTION MsgInfo('Edición express') WHEN .f.

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlg ;
      ACTION ( if( CheckGets( aGet, oFld ), ( lIdOk := .T., oDlg:end() ), ) )

   REDEFINE BUTTON ;
      ID IDCANCEL ;
      OF oDlg ;
      CANCEL ;
      ACTION ( lIdOk := .F., oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      ON INIT ( oDlg:Center( oApp():oWndMain ), Iif( !empty( cLiPrestad ) .or. dLiFechaPr != cTOd( "" ),;
                 ( aBmp[02]:reload( "16_pres_on"  ), aBmp[02]:refresh() ),;
                 ( aBmp[02]:reload( "16_pres_off" ), aBmp[02]:refresh() ) ) )

   do case
      // nuevo
      case cModo == "add"
         // aceptar
         if lIdOk == .T.
            // alta del libro
            LI->( dbGoTo( nRecAdd ) )
            replace Li->Licodigo    with cLiCodigo
            replace LI->LiTitulo    with cLiTitulo
            replace LI->LiTitOrig   with cLiTitOrig
            replace LI->LiAutor     with cLiAutor
            replace LI->LiIdioma    with cLiIdioma
            replace LI->LiEditor    with cLiEditor
            replace LI->LiAnoEdic   with nLiAnoEdic
            replace LI->LiIsbn      with cLiIsbn
            replace LI->LiPrecio    with nLiPrecio
            replace LI->LiMateria   with cLiMateria
            replace LI->LiPrestad   with cLiPrestad
            replace LI->LiFechaPr   with dLiFechaPr
            replace LI->Liciudad    with cLiciudad
            replace LI->Liubicaci   with cLiubicaci
            replace LI->Lipaginas   with nLipaginas
            replace LI->Liencuad    with cLiencuad
            replace Li->Lipropiet   with cLipropiet
            replace Li->Linumedic   with nLinumedic
            replace Li->Lifchadq    with dLifchadq
            replace Li->Liproveed   with cLiproveed
            replace Li->Liobserv    with mLiobserv
            replace Li->Licolecc    with cLicolecc
            replace Li->Linumtomos  with nLinumtomos
            replace Li->Liestetomo  with nLiestetomo
            replace Li->LiImagen    with cLiImagen
            replace Li->LiValoraci  with nLiValoraci
            replace Li->LiFchLec    with dLiFchLec
				replace Li->liResumen   with cLiResumen
            LI->( dbCommit() )
            nRecBrw := LI->( recNo() )
            // incremento del nº de ejemplares en autores
				AU->(OrdSetFocus("ESCRITORES"))
				AU->(dbGoTop())
            if AU->( dbSeek( upper( cLiAutor ) ) )
               replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
               AU->( dbCommit() )
            endif
				// incremento del nº de ejemplares en editores
				ED->(OrdSetFocus("EDLIBROS"))
				ED->(dbGoTop())
            if ED->( dbSeek( upper( cLiEditor ) ) )
               replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
               ED->( dbCommit() )
            endif
				// incremento del nº de ejemplares en colecciones
				CL->(OrdSetFocus("COLIBROS"))
				CL->(dbGoTop())
            if CL->( dbSeek( upper( cLiColecc ) ) )
               replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
               CL->( dbCommit() )
            endif
            // incremento del nº de ejemplares en materias
				MA->(OrdSetFocus("MATERIA"))
				MA->(Dbgotop())
            if MA->( dbSeek( "L" + upper( cLiMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumLibr ) + 1
               MA->( dbCommit() )
            endif
            // incremento del nº de ejemplares en ubicaciones
				UB->(OrdSetFocus("UBICACION"))
				UB->(Dbgotop())
            if UB->( dbSeek( "L" + upper( cLiUbicaci ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif
            // anotación del préstamo (si es necesario)
            if IsPrestado( "LI" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 1
               replace NO->NoCodigo  with LI->LiCodigo
               replace NO->NoFecha   with LI->LiFechaPr
               replace NO->NoTitulo  with LI->LiTitulo
               replace NO->NoAQuien  with LI->LiPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  LiImprimirJustif()
               endif
            endif
         // cancelar
         else
            // aquí no ha pasado nada
            LI->( dbGoTo( nRecAdd ) )
            LI->( dbDelete() )
         endif
      // modificar
      case cModo == "edt"
         // aceptar
         if lIdOk == .T.
            // modificación del préstamo (si es necesario)
            do case
               // acaba de anotarse el préstamo
               case !IsPrestado( "LI" ) .and. ( !empty( cLiPrestad ) .or. dLiFechaPr != cTOd( "" ) )
                  NO->( dbAppend() )
                  replace NO->NoTipo    with 1
                  replace NO->NoCodigo  with cLiCodigo
                  replace NO->NoFecha   with dLiFechaPr
                  replace NO->NoTitulo  with cLiTitulo
                  replace NO->NoAQuien  with cLiPrestad
                  NO->( dbCommit() )
                  lPrestado := .t.
               // estaba y sigue estando prestado
               case IsPrestado( "LI" ) .and. ( !empty( cLiPrestad ) .or. dLiFechaPr != cTOd( "" ) )
                  if NO->( dbSeek( "1" + cLiCodigo ) )
                     replace NO->NoFecha   with dLiFechaPr
                     replace NO->NoAQuien  with cLiPrestad
                     NO->( dbCommit() )
                  endif
               // estaba pero ya no está prestado
               case IsPrestado( "LI" ) .and. ( empty( cLiPrestad ) .and. dLiFechaPr == cTOd( "" ) )
                  if NO->( dbSeek( "1" + LI->LiCodigo ) )
                     NO->( dbDelete() )
                  endif
                  NO->( dbCommit() )
            endcase
            // modificación del nº de ejemplares en materias
            if ( LI->LiMateria != cLiMateria )
					MA->(OrdSetFocus("MATERIA"))
					MA->(Dbgotop())
               do case
                  case ( MA->( dbSeek( "L" + upper( LI->LiMateria ) ) ) )
                     MA->( dbSeek( "L" + upper( cLiMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
                     MA->( dbSeek( "L" + upper( LI->LiMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
                     MA->( dbCommit() )
                  case ( empty( LI->LiMateria ) )
                     MA->( dbSeek( "L" + upper( cLiMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               endcase
            endif
            // modificación del nº de ejemplares en ubicaciones
            if ( LI->LiUbicaci != cLiUbicaci )
					UB->(OrdSetFocus("UBICACION"))
					UB->(dbGoTop())
               do case
                  case ( UB->( dbSeek( "L" + upper( LI->LiUbicaci ) ) ) )
                     UB->( dbSeek( "L" + upper( cLiUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) + 1
                     UB->( dbSeek( "L" + upper( LI->LiUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) - 1
                     UB->( dbCommit() )
                  case ( empty( LI->LiUbicaci ) )
                     UB->( dbSeek( "L" + upper( cLiUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) + 1
               endcase
            endif
				// modificación del nº de ejemplares en autores
				if ( LI->LiAutor != cLiAutor )
					AU->(OrdSetFocus("ESCRITORES"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( LI->LiAutor ) ) ) )
							AU->( dbSeek( upper( cLiAutor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( LI->LiAutor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( LI->LiAutor ) )
							AU->( dbSeek( upper( cLiAutor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en editores
				if ( LI->LiEditor != cLiEditor )
					ED->(OrdSetFocus("EDLIBROS"))
					ED->(dbGoTop())
					do case
						case ( ED->( dbSeek( upper( LI->LiEditor ) ) ) )
							ED->( dbSeek( upper( cLiEditor ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
							ED->( dbSeek( upper( LI->LiEditor ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) - 1
							ED->( dbCommit() )
						case ( empty( LI->LiEditor ) )
							ED->( dbSeek( upper( cLiEditor ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en colecciones
				if ( LI->LiColecc != cLiColecc )
					CL->(OrdSetFocus("COLIBROS"))
					CL->(dbGoTop())
					do case
						case ( CL->( dbSeek( upper( LI->liColecc ) ) ) )
							CL->( dbSeek( upper( cLiColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
							CL->( dbSeek( upper( LI->liColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) - 1
							CL->( dbCommit() )
						case ( empty( LI->LiColecc ) )
							CL->( dbSeek( upper( cLiColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
					endcase
				endif
            // modificación del libro
            LI->( dbGoTo( nRecBrw ) )
            replace Li->LiCodigo    with cLiCodigo
            replace LI->LiTitulo    with cLiTitulo
            replace LI->LiTitOrig   with cLiTitOrig
            replace LI->LiAutor     with cLiAutor
            replace LI->LiIdioma    with cLiIdioma
            replace LI->LiEditor    with cLiEditor
            replace LI->LiAnoEdic   with nLiAnoEdic
            replace LI->LiIsbn      with cLiIsbn
            replace LI->LiPrecio    with nLiPrecio
            replace LI->LiMateria   with cLiMateria
            replace LI->LiPrestad   with cLiPrestad
            replace LI->LiFechaPr   with dLiFechaPr
            replace LI->LiCiudad    with cLiciudad
            replace LI->LiUbicaci   with cLiubicaci
            replace LI->LiPaginas   with nLipaginas
            replace LI->LiEncuad    with cLiencuad
            replace Li->LiPropiet   with cLipropiet
            replace Li->LiNumEdic   with nLinumedic
            replace Li->LiFchaDq    with dLifchadq
            replace Li->LiProveed   with cLiproveed
            replace Li->LiObserv    with mLiObserv
            replace Li->LiColecc    with cLicolecc
            replace Li->LiNumTomos  with nLinumtomos
            replace Li->LiEsteTomo  with nLiestetomo
            replace Li->LiImagen    with cLiImagen
            replace Li->LiValoraci  with nLiValoraci
            replace Li->LiFchLec    with dLiFchLec
				replace Li->liResumen   with cLiResumen
            LI->( dbCommit() )
            // impresión del justificante de préstamo (si es necesario)
            if lPrestado
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  LiImprimirJustif()
               endif
            endif
         endif
      // duplicar
      case cModo == "dup"
         // aceptar
         if lIdOk == .T.
            // duplicado del libro
            LI->( dbAppend() )
            nRecBrw := LI->( recNo() )
            replace Li->LiCodigo    with cLiCodigo
            replace LI->LiTitulo    with cLiTitulo
            replace LI->LiTitOrig   with cLiTitOrig
            replace LI->LiAutor     with cLiAutor
            replace LI->LiIdioma    with cLiIdioma
            replace LI->LiEditor    with cLiEditor
            replace LI->LiAnoEdic   with nLiAnoEdic
            replace LI->LiIsbn      with cLiIsbn
            replace LI->LiPrecio    with nLiPrecio
            replace LI->LiMateria   with cLiMateria
            replace LI->LiPrestad   with cLiPrestad
            replace LI->LiFechaPr   with dLiFechaPr
            replace LI->LiCiudad    with cLiciudad
            replace LI->LiUbicaci   with cLiubicaci
            replace LI->LiPaginas   with nLipaginas
            replace LI->LiEncuad    with cLiencuad
            replace Li->LiPropiet   with cLipropiet
            replace Li->LiNumEdic   with nLinumedic
            replace Li->LiFchaDq    with dLifchadq
            replace Li->LiProveed   with cLiproveed
            replace Li->LiObserv    with mLiObserv
            replace Li->LiColecc    with cLicolecc
            replace Li->LiNumTomos  with nLinumtomos
            replace Li->LiEsteTomo  with nLiestetomo
            replace Li->LiImagen    with cLiImagen
            replace Li->LiValoraci  with nLiValoraci
            replace Li->LiFchLec    with dLiFchLec
				replace Li->liResumen   with cLiResumen
            LI->( dbCommit() )
				// incremento del nº de ejemplares en autores
				AU->(OrdSetFocus(1))
				AU->(dbGoTop())
            if AU->( dbSeek( upper( cLiAutor ) ) )
               replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
               AU->( dbCommit() )
            endif
				// incremento del nº de ejemplares en editores
				ED->(OrdSetFocus(1))
				ED->(dbGoTop())
            if ED->( dbSeek( upper( cLiEditor ) ) )
               replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
               ED->( dbCommit() )
            endif
				// incremento del nº de ejemplares en colecciones
				CL->(OrdSetFocus(1))
				CL->(dbGoTop())
            if CL->( dbSeek( upper( cLiColecc ) ) )
               replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
               CL->( dbCommit() )
            endif
            // incremento del nº de ejemplares en materias
				MA->(OrdSetFocus(1))
				MA->(Dbgotop())
            if MA->( dbSeek( "L" + upper( cLiMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumLibr ) + 1
               MA->( dbCommit() )
            endif
            // incremento del nº de ejemplares en ubicaciones
				UB->(OrdSetFocus(1))
				UB->(Dbgotop())
            if UB->( dbSeek( "L" + upper( cLiUbicaci ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif
            // anotación del préstamo (si es necesario)
            if IsPrestado( "LI" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 1
               replace NO->NoCodigo  with LI->LiCodigo
               replace NO->NoFecha   with LI->LiFechaPr
               replace NO->NoTitulo  with LI->LiTitulo
               replace NO->NoAQuien  with LI->LiPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  LiImprimirJustif()
               endif
            endif
         endif
   endcase

   // actualización del browse
   LI->( dbGoTo( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "LI", "Libros: " )
		RefreshLiImage()
	endif
	oBrw:maketotals()
   oBrw:refresh()
   oBrw:setFocus()
   oApp():nEdit--
return NIL


/*-----------------------------------------------------------------------------
 * función .: LiBorrar()
 * prec ....: oBrw != NIL
 * post ....: Borra un libro, previa confirmación.
*/

function LiBorrar( oBrw, oCont )

   local nRecord := LI->( recNo() )
   local nNext   := 0

   if LiDbfVacia()
      return NIL
   endif

   if IsPrestado( "LI" )
      msgStop( i18n( "No se pueden eliminar libros prestados." ) )
      return NIL
   endif

   if msgYesNo( i18n( "¿Está seguro de querer borrar este Libro?" +CRLF+CRLF ;
                + trim( LI->liTitulo ) ) )
      LI->( dbSkip() )
      nNext := LI->( recNo() )
      LI->( dbGoto( nRecord ) )
		MA->(OrdSetFocus(1))
		MA->(Dbgotop())
      if MA->( dbSeek( "L" + upper( LI->LiMateria ) ) )
         replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
      endif
		UB->(OrdSetFocus(1))
		UB->(Dbgotop())
      if UB->( dbSeek( "L" + upper( LI->LiUbicaci ) ) )
         replace UB->UbItems with ( UB->UbItems ) - 1
      endif
		AU->(OrdSetFocus(1))
		AU->(Dbgotop())
		if AU->( dbSeek( upper( LI->LiAutor ) ) )
         replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
      endif
		ED->(OrdSetFocus(1))
		ED->(Dbgotop())
		if ED->( dbSeek( upper( LI->LiEditor ) ) )
         replace ED->EdNumEjem with ( ED->EdNumEjem ) - 1
      endif
		CL->(OrdSetFocus(1))
		CL->(Dbgotop())
		if CL->( dbSeek( upper( LI->liColecc ) ) )
         replace CL->ClNumEjem with ( CL->ClNumEjem ) - 1
      endif
      LI->( dbDelete() )
      LI->( dbGoto( nNext ) )
      if LI->( eof() ) .or. nNext == nRecord
         LI->( dbGoBottom() )
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "LI", "Libros: " )
		RefreshLiImage()
   endif
	oBrw:maketotals()
   oBrw:refresh()
   oBrw:setFocus()

return NIL


/*-----------------------------------------------------------------------------
 * función .: LiBuscar()
 * prec ....: oBrw != NIL && oCont != NIL && 1 <= nTabOpc <= 11
 * post ....: Muestra el formulario de búsqueda de libros.
*/

function LiBuscar( oBrw, oCont, nTabOpc, cChr )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local nRecNo   := LI->( recNo() )
   local lIdOk    := .f.
   local lFecha   := .f.
   local aBrowse  := { }

   if LiDbfVacia()
      return NIL
   endif

   oApp():nEdit++

   switch nTabOpc
      case 1
         cPrompt := i18n( "Introduzca el Título del Libro" )
         cField  := i18n( "Título:" )
         cGet    := space( 60 )
         exit
      case 2
         cPrompt := i18n( "Introduzca el Título Original del Libro" )
         cField  := i18n( "Título Original:" )
         cGet    := space( 60 )
         exit
      case 3
         cPrompt := i18n( "Introduzca el Código del Libro" )
         cField  := i18n( "Código:" )
         cGet    := space( 10 )
         exit
      case 4
         cPrompt := i18n( "Introduzca el Autor del Libro" )
         cField  := i18n( "Autor:" )
         cGet    := space( 30 )
         exit
      case 5
         cPrompt := i18n( "Introduzca la Materia del Libro" )
         cField  := i18n( "Materia:" )
         cGet    := space( 30 )
         exit
      case 6
         cPrompt := i18n( "Introduzca el Propietario del Libro" )
         cField  := i18n( "Propietario:" )
         cGet    := space( 40 )
         exit
      case 7
         cPrompt := i18n( "Introduzca la Ubicación del Libro" )
         cField  := i18n( "Ubicación:" )
         cGet    := space( 60 )
         exit
      case 8
         cPrompt := i18n( "Introduzca el Editor del Libro" )
         cField  := i18n( "Editor:" )
         cGet    := space( 30 )
         exit
      case 9
         cPrompt := i18n( "Introduzca el Año de Edición del Libro" )
         cField  := i18n( "Año de Edición:" )
         cGet    := space( 04 )
         exit
      case 10
         cPrompt := i18n( "Introduzca la Colección del Libro" )
         cField  := i18n( "Colección:" )
         cGet    := space( 40 )
         exit
      case 11
         cPrompt := i18n( "Introduzca la Fecha de Compra del Libro" )
         cField  := i18n( "Fch. Compra:" )
         cGet    := cTOd( "" )
         exit
      case 12
         cPrompt := i18n( "Introduzca la Fecha de Préstamo del Libro" )
         cField  := i18n( "Fch. Préstamo:" )
         cGet    := cTOd( "" )
         exit
   end switch

   lFecha := valType( cGet ) == "D"

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Libros" )
   oDlg:SetFont(oApp():oFont)

      REDEFINE SAY PROMPT cPrompt ID 20 OF oDlg
      REDEFINE SAY PROMPT cField  ID 21 OF oDlg

      if cChr != NIL
         if ! lFecha
            cGet := cChr + subStr( cGet, 1, len( cGet ) - 1 )
         else
            cGet := cTOd( "  -  -    " )
         endif
      endif

      REDEFINE GET oGet VAR cGet ID 101 OF oDlg

      //if lFecha
      //   oGet:cText := cTOd(cChr + " -  -    ")
      //endif

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
      ON INIT oDlg:Center( oApp():oWndMain )

   if lIdOk
      if ! lFecha
         cGet := rTrim( upper( cGet ) )
      else
         cGet := dTOs( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
            { || LiWildSeek(nTabOpc, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ningún libro."))
         LI->(DbGoTo(nRecno))
      else
         LiEncontrados(aBrowse, oApp():oDlg)
      endif
   endif
   LiTabs( oBrw, nTabOpc, oCont)

   RefreshCont( oCont, "LI", "Libros: " )
	RefreshLiImage()
   oBrw:refresh()
   oBrw:setFocus()
   oApp():nEdit--
return NIL
/*_____________________________________________________________________________*/
function LiWildSeek(nTabOpc, cGet, aBrowse)
   local nRecno   := LI->(Recno())
   do case
      case nTabOpc == 1
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiTitulo)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
		case nTabOpc == 2
			LI->(DbGoTop())
			do while ! LI->(eof())
				if cGet $ upper(LI->liTitOrig)
					aadd(aBrowse, {LI->LiTitOrig, LI->LiAutor, LI->LiMateria, LI->(Recno())})
				endif
				LI->(DbSkip())
			enddo
      case nTabOpc == 3
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiCodigo)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 4
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiAutor)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 5
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiMateria)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 6
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiPropiet)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 7
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiUbicaci)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 8
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiEditor)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 9
         LI->(DbGoTop())
         do while ! LI->(eof())
            if val(cGet) == LI->LiAnoEdic
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 10
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet $ upper(LI->LiColecc)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 11
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet == dTOs(LI->LiFchAdq)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo
      case nTabOpc == 12
         LI->(DbGoTop())
         do while ! LI->(eof())
            if cGet == dTOs(LI->LiFechaPr)
               aadd(aBrowse, {LI->LiTitulo, LI->LiAutor, LI->LiMateria, LI->(Recno())})
            endif
            LI->(DbSkip())
         enddo

   endcase
   LI->(DbGoTo(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[1]) < upper(aAut2[1]) } )
return nil
/*_____________________________________________________________________________*/
function LiEncontrados(aBrowse, oParent)
   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := LI->(Recno())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .f.)
   oBrowse:aCols[1]:cHeader := "Título"
   oBrowse:aCols[2]:cHeader := "Autor"
   oBrowse:aCols[3]:cHeader := "Materia"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:nWidth  := 140
   oBrowse:aCols[4]:lHide    := .t.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   LI->(OrdSetFocus("titulo"))
   LI->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1])))
   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||LI->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                           LiForm(oBrowse,"edt",,oDlg) }} )
                                                           DbGoTo(aBrowse[oBrowse:nArrayAt,4])
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(LI->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                     LiForm(oBrowse,"edt",,oDlg)),) }
   oBrowse:bChange    := { || LI->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (LI->(DbGoTo(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/
/*
 * función .: LiTabs()
 * prec ....: oBrw != NIL && oCont != NIL && 1 <= nTabOpc <= 11
 * post ....: Ordena oBrw por el criterio indicado.
*/

function LiTabs( oBrw, nOpc, oCont )
   switch nOpc
      case 1
         LI->( ordSetFocus( "titulo" ) )
         exit
      case 2
         LI->( ordSetFocus( "tituloriginal" ) )
         exit
      case 3
         LI->( ordSetFocus( "codigo" ) )
         exit
      case 4
         LI->( ordSetFocus( "autor" ) )
         exit
      case 5
         LI->( ordSetFocus( "materia" ) )
         exit
      case 6
         LI->( ordSetFocus( "propietario" ) )
         exit
      case 7
         LI->( ordSetFocus( "ubicacion" ) )
         exit
      case 8
         LI->( ordSetFocus( "editor" ) )
         exit
      case 9
         LI->( ordSetFocus( "anoedic" ) )
         exit
      case 10
         LI->( ordSetFocus( "coleccion" ) )
         exit
      case 11
         LI->( ordSetFocus( "fchcompra" ) )
         exit
      case 12
         LI->( ordSetFocus( "fchprestamo" ) )
         exit
   end switch
   oBrw:refresh()
   RefreshCont( oCont, "LI", "Libros: " )
return NIL
/*_____________________________________________________________________________*/
/*
 * función .: LiTeclas()
 * prec ....: nKey != NIL && oBrw != NIL && oCont != NIL && nTabOpc != NIL && oDlg != NIL
 * post ....: Evalúa la tecla pulsada.
*/

function LiTeclas( nKey, oBrw, oCont, nTabOpc, oDlg )
   switch nKey
      case VK_INSERT
         LiForm( oBrw, "add", oCont )
         exit
      case VK_RETURN
         LiForm( oBrw, "edt", oCont )
         exit
      case VK_DELETE
         LiBorrar( oBrw, oCont )
         exit
      case VK_ESCAPE
         oDlg:End()
         exit
      otherwise
         if nKey >= 96 .and. nKey <= 105
            LiBuscar( oBrw, oCont, nTabOpc, str( nKey - 96, 1 ) )
         elseif hb_IsString( chr( nKey ) )
            LiBuscar( oBrw, oCont, nTabOpc, chr( nKey ) )
         endif
         exit
   end switch
return NIL

/*_____________________________________________________________________________*/
/*
 * función .: LiImprimirJustif()
 * prec ....: True
 * post ....: Imprime el justificante de préstamo del libro actual.
*/

function LiImprimirJustif( oFont1, oFont2, oFont3, cTitulo1, cTitulo2 )
   local nRec    := LI->( recNo() )
   local oInforme

   oInforme := TInforme():New( {}, {}, {}, {}, {}, {}, "LI" )

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(LI->LiTitulo)
   oInforme:cTitulo2 := Rtrim("Justificante de préstamo del libro")
   oInforme:nDevice := 1

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
      COLUMN TITLE " " DATA " " SIZE 20
      COLUMN TITLE " " DATA " " SIZE 60
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

   ACTIVATE REPORT oInforme:oReport FOR LI->( recNo() ) == nRec ;
      ON INIT LiImprimirJustif2( oInforme:oReport, nRec )

   LI->( dbGoTo( nRec ) )
return NIL


/*
 * función .: LiImprimirJustif2()
 * prec ....: oReport != NIL && 1 <= nRec <= LI->(lastRec())
 * post ....: Rellena la hoja del justificante de préstamo.
*/

function LiImprimirJustif2( oReport, nRec )

   LI->( dbGoTo( nRec ) )

   with object oReport
      :StartLine()
      :Say( 1, i18n("Código:"), 1 )
      :Say( 2, LI->LiCodigo   , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Título:"), 1 )
      :Say( 2, LI->LiTitulo   , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Autor:"), 1 )
      :Say( 2, LI->LiAutor   , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("I.S.B.N.:"), 1 )
      :Say( 2, LI->LiIsbn       , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Propietario:"), 1 )
      :Say( 2, LI->LiPropiet       , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Fecha de Compra:"), 1 )
      :Say( 2, LI->LiFchAdq            , 1 )
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Este libro ha sido objeto del siguiente préstamo:"), 2 )
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Prestatario:"), 1 )
      :Say( 2, LI->LiPrestad       , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Fecha de Préstamo:"), 1 )
      :Say( 2, LI->LiFechaPr             , 1 )
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Firma del Prestatario:"), 2 )
      :EndLine()
   end with

return NIL


/*
 * función .: LiDevolver()
 * prec ....: True
 * post ....: Anota la devolución de un libro, previa confirmación.
*/

function LiDevolver()

   if LiDbfVacia()
      return NIL
   endif

   if !IsPrestado( "LI" )
      msgStop( i18n( "El libro seleccionado no está prestado." ) )
      return NIL
   endif

   if msgYesNo( i18n( "¿Desea anotar la devolución de este libro?" ) +CRLF+CRLF+ ;
                i18n( trim( LI->LiTitulo ) ) )
      if NO->( dbSeek( "1" + LI->LiCodigo ) )
         replace LI->LiPrestad with ""
         replace LI->LiFechaPr with cTOd( "" )
         LI->( dbCommit() )
         NO->( dbDelete() )
         NO->( dbCommit() )
      else
         msgAlert( i18n("No se encontró el libro seleccionado en el " + ;
                        "fichero de préstamos. Por favor reindexe los " + ;
                        "ficheros.") )
      endif

   endif

return NIL


/*
 * función .: LiGetImagen()
 * prec ....: oImage != NIL && oGet != NIL && oBtn != NIL
 * post ....: Asocia un archivo de imagen a un libro.
*/

function LiGetImagen( oImage1, oImage2, oGet, oBtn )

   local cImageFile

   cImageFile := cGetfile32( i18n("Archivos de imagen") + ;
                             " (bmp,jpg,gif,png,dig,pcx,tga,rle) | " + ;
                             "*.bmp;*.jpg;*.gif;*.png;*.dig;*.pcx;*.tga;*.rle |",;
                             i18n("Indica la ubicación de la imagen"),,,, .t. )

   if ! empty(cImageFile) .and. File(lfn2sfn(rtrim(cImageFile)))
      oImage1:SetSource(lfn2sfn(rtrim(cImageFile)))
      oImage2:SetSource(lfn2sfn(rtrim(cImageFile)))
      oGet:cText := cImageFile
      oBtn:Refresh()
   endif

return NIL


/*
 * función .: Liximagen()
 * prec ....: cImagen != NIL && cTitulo != NIL
 * post ....: Muestra la imagen de un libro a tamaño real o ajustada.
*/

function Liximagen( cImagen, cTitulo )

   local oDlg
   local oImage

   if LiDbfVacia()
      return NIL
   endif

   if empty( rTrim( cImagen ) )
      msgAlert( i18n( "El libro no tiene asociada ninguna imagen." ) )
      return NIL
   endif

   if ! file( lfn2sfn( rTrim( cImagen ) ) )
      msgAlert( i18n( "No existe el fichero de imagen asociado al libro." ) + " " + ;
              i18n( "Por favor revise la ruta y el nombre del fichero." ) )
      return NIL
   endif

   oApp():nEdit++

   DEFINE DIALOG oDlg RESOURCE "DLG_IMGZOOM" TITLE cTitulo
   oDlg:SetFont(oApp():oFont)

   REDEFINE XIMAGE oImage ;
      FILE lfn2sfn( rTrim( cImagen ) ) ;
      ID 102 OF oDlg //SCROLL

   oImage:SetColor( CLR_RED, CLR_WHITE )

   REDEFINE BUTTON  ;
      ID       IDOK ;
      OF       oDlg ;
      ACTION   oDlg:End()

   ACTIVATE DIALOG oDlg CENTER ;
      ON INIT oDlg:Center( oApp():oWndMain )

   oApp():nEdit--

return NIL


/*
 * función .: LiClave()
 * prec ....: cClave != NIL && cTitulo != NIL && ( $E x : {'add','edt','dup'} : cModo == x )
 * post ....: Controla el comportamiento de un libro en función de cModo.
*/

function LiClave( cClave, oGet, cModo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro

   local cAlias  := "LI"
   local cMsgSi  := i18n( "Código de libro ya registrado." )
   local cMsgNo  := i18n( "Código de libro no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
   local cPkOrd  := "codigo"

   local lReturn := .f.
   local nRecno  := ( cAlias )->( recNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   if empty( cClave ) .and. .not. oApp():lCodOblig
      return .t.
   endif

   if empty( cClave )
      msgStop( i18n( "Es obligatorio rellenar este campo." ) )
      oGet:setFocus()
      return .f.
   endif

   ( cAlias )->( ordSetFocus( cPkOrd ) )
   ( cAlias )->( dbGoTop() )

   IF Val(cClave) != 0 .AND. oApp():lCodZero
      cClave := strZero( Val(cClave), 10 )
   ENDIF

   if ( cAlias )->( dbSeek( upper( cClave ) ) )

      do case

         case cModo == "add" .or. cModo == "dup"
            lReturn := .f.
            msgStop( cMsgSi )

         case cModo == "edt"
            if ( cAlias )->( recNo() ) == nRecno
               lReturn := .t.
            else
               lReturn := .f.
               MsgStop( cMsgSi )
            endif

      endcase

   else

      lReturn := .t.

   endif

   if ! lReturn
      oGet:setFocus()
   else
      oGet:cText := cClave
   endif

   ( cAlias )->( dbSetOrder( nOrder ) )
   ( cAlias )->( dbGoTo( nRecno ) )

return lReturn


/*
 * función .: LiImprimir()
 * prec ....: oBrw != NIL
 * post ....: Muestra el selector de informes.
*/

function LiImprimir( oBrw )
                 //  título                   campo         wd  shw  picture          tot
                 //  =======================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Código"         ), "LICODIGO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Título"         ), "LITITULO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Título original"), "LITITORIG" ,  0, .t.,            "NO", .f. },;
                   { i18n("Autor"          ), "LIAUTOR"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Materia"        ), "LIMATERIA" ,  0, .t.,            "NO", .f. },;
                   { i18n("Idioma"         ), "LIIDIOMA"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Propietario"    ), "LIPROPIET" ,  0, .t.,            "NO", .f. },;
                   { i18n("Ubicación"      ), "LIUBICACI" ,  0, .t.,            "NO", .f. },;
                   { i18n("Editorial"      ), "LIEDITOR"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Nº Edic."       ), "LINUMEDIC" ,  0, .t.,            "NO", .f. },;
                   { i18n("I.S.B.N."       ), "LIISBN"    ,  0, .t.,            "NO", .f. },;
                   { i18n("Año Edic."      ), "LIANOEDIC" ,  0, .t.,            "NO", .f. },;
                   { i18n("Ciudad"         ), "LICIUDAD"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Encuadernación" ), "LIENCUAD"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Nº Pág."        ), "LIPAGINAS" ,  0, .t.,     "@E 99,999", .f. },;
                   { i18n("Colección"      ), "LICOLECC"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Nº Tomos"       ), "LINUMTOMOS",  0, .t.,     "@E 99,999", .f. },;
                   { i18n("Tomo Nº"        ), "LIESTETOMO",  0, .t.,     "@E 99,999", .f. },;
                   { i18n("Fch.Compra"     ), "LIFCHADQ"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Centro Compra"  ), "LIPROVEED" ,  0, .t.,            "NO", .f. },;
                   { i18n("Precio"         ), "LIPRECIO"  ,  0, .t., "@E 999,999.99", .t. },;
                   { i18n("Fch.Préstamo"   ), "LIFECHAPR" ,  0, .t.,            "NO", .f. },;
                   { i18n("Prestatario"    ), "LIPRESTAD" ,  0, .t.,            "NO", .f. },;
                   { i18n("Valoración"     ), "LIVALORACI",  0, .t.,            "NO", .f. },;
                   { i18n("Fcl.Lectura"    ), "LIFCHLEC"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Comentarios"    ), "LIOBSERV"  , 40, .t.,            "NO", .f. } }
   local nRecno   := MU->(Recno())
   local nOrder   := MU->(OrdSetFocus())
   local aCampos  := { "LICODIGO", "LITITULO", "LITITORIG", "LIAUTOR", "LIMATERIA",;
                       "LIIDIOMA", "LIPROPIET", "LIUBICACI", "LIEDITOR", "LINUMEDIC",;
                       "LIISBN", "LIANOEDIC", "LICIUDAD", "LIENCUAD", "LIPAGINAS",;
                       "LICOLECC", "LINUMTOMOS", "LIESTETOMO","LIFCHADQ", "LIPROVEED",;
                       "LIPRECIO", "LIFECHAPR", "LIPRESTAD", "LIVALORACI", "LIFCHLEC", "LIOBSERV" }
   local aTitulos := { "Código", "Título", "Tít. Original", "Autor", "Materia",;
                       "Idioma", "Propietario", "Ubicación", "Editorial", "Nº Edic.",;
                       "I.S.B.N.", "Año Edic.", "Ciudad", "Encuadernación", "Nº Pág.",;
                       "Colección", "Nº Tomos", "Tomo Nº", "Fch.Compra", "Centro Compra",;
                       "Precio", "Fch.Préstamo", "Prestatario", "Valoración", "Fch.Lectura", "Comentarios" }
   local aWidth   := { 10, 20, 20, 10, 10, 10, 10, 10, 10, 10,;
                       10, 10, 10, 10, 10, 10, 10, 10, 10, 10,;
                       10, 10, 10, 10, 10, 10 }
   local aShow    := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t.,;
                       .t., .t., .t., .t., .t., .t., .t., .t., .t., .t.,;
                       .t., .t., .t., .t., .t., .t. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO",;
                       "NO", "NO", "NO", "NO", "@E 99,999", "NO", "@E 99,999","@E 99,999", "NO", "NO",;
                       "@E 999,999.99", "NO", "NO", "NO", "NO", "NO" }

   local aTotal   := { .f., .f., .f., .f., .f., .f., .f., .f., .f., .f.,;
                       .f., .f., .f., .f., .f., .f., .f., .t., .f., .f.,;
                       .t., .f., .f., .f., .f., .f. }
   local oInforme
   local nAt
   local cAlias   := "LI"
   local cTotal   := "Total libros: "
   local aGet     := array(11)
   local aSay     := array(2)
   local aBtn     := array(2)

   // aqui el original
   local aMa      := {}
   local cMa      := ""
   local nMaOrd   := MA->( ordNumber() )
   local nMaRec   := MA->( recNo() )

   local aPr      := {}
   local cPr      := ""
   local nPrOrd   := AG->( ordNumber() )
   local nPrRec   := AG->( recNo() )

   local aUb      := {}
   local cUb      := ""
   local nUbOrd   := UB->( ordNumber() )
   local nUbRec   := UB->( recNo() )

   local aAu      := {}
   local cAu      := ""
   local nAuOrd   := AU->( ordNumber() )
   local nAuRec   := AU->( recNo() )

   local aCl      := {}
   local cCl      := ""
   local nClOrd   := CL->( ordNumber() )
   local nClRec   := CL->( recNo() )

   local aEd      := {}
   local cEd      := ""
   local nEdOrd   := ED->( ordNumber() )
   local nEdRec   := ED->( recNo() )

   local nAno     := year( date() )
   local dFch1    := cTOd( "" )
   local dFch2    := date()
   local lImg     := .f.

   if LiDbfVacia()
      retu NIL
   endif

   oApp():nEdit++

   SELECT LI  // imprescindible

   FillCmb( "MA", "lmateria"    , aMa, "MaMateria", nMaOrd, nMaRec, @cMa )
   FillCmb( "AG", "propietarios", aPr, "PeNombre" , nPrOrd, nPrRec, @cPr )
   FillCmb( "UB", "lubicacion"  , aUb, "UbUbicaci", nUbOrd, nUbRec, @cUb )
   FillCmb( "AU", "escritores"  , aAu, "AuNombre" , nAuOrd, nAuRec, @cAu )
   FillCmb( "CL", "colibros"    , aCl, "ClNombre" , nClOrd, nClRec, @cCl )
   FillCmb( "ED", "edlibros"    , aEd, "EdNombre" , nEdOrd, nEdRec, @cEd )

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   REDEFINE SAY aSay[01] ID 200 OF oInforme:oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oInforme:oFld:aDialogs[1]

   REDEFINE RADIO oInforme:oRadio ;
      VAR oInforme:nRadio ;
      ID 100, 101, 103, 120, 105, 107, 109, 111, 113, 116, 117, 119 ;
      OF oInforme:oFld:aDialogs[1]

   if !IsPrestado( "LI" )
      oInforme:oRadio:aItems[12]:disable() // justificante de préstamo
   endif

   REDEFINE COMBOBOX aGet[01] VAR cMa ITEMS aMa ID 102 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 2
   REDEFINE COMBOBOX aGet[02] VAR cPr ITEMS aPr ID 104 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 3
   REDEFINE COMBOBOX aGet[03] VAR cUb ITEMS aUb ID 121 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 4
   REDEFINE COMBOBOX aGet[04] VAR cAu ITEMS aAu ID 106 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 5
   REDEFINE COMBOBOX aGet[05] VAR cCl ITEMS aCl ID 108 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 6
   REDEFINE COMBOBOX aGet[06] VAR cEd ITEMS aEd ID 110 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 7

   REDEFINE GET aGet[07] ;
      VAR nAno ;
      ID 112 ;
      OF oInforme:oFld:aDialogs[1] ;
      PICTURE "9999" ;
      WHEN oInforme:nRadio == 8

   REDEFINE GET aGet[08] ;
      VAR dFch1 ;
      ID 114 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 9

   REDEFINE BUTTON aBtn[01];
      ID 122;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch1, aGet[08] ),;
               aGet[08]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 9

      aBtn[01]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[09] ;
      VAR dFch2 ;
      ID 115 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 9

   REDEFINE BUTTON aBtn[02];
      ID 123;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch2, aGet[09] ),;
               aGet[09]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 9

      aBtn[02]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE CHECKBOX aGet[10] ;
      VAR lImg ;
      ID 118 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 11 .and. !empty( LI->LiImagen )

   oInforme:Folders()
   if oInforme:Activate()
      nRecno := LI->( recNo() )
      nOrder := LI->( ordNumber() )
      do case
         case oInforme:nRadio == 1
            // toos los libros, con el orden determinado
            LI->( dbGoTop() )
         case oInforme:nRadio == 2
            // libros de una materia
            LI->( ordSetFocus( "materia" ) )
            LI->( ordScope( 0, upper( rTrim( cMa ) ) ) )
            LI->( ordScope( 1, upper( rTrim( cMa ) ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 3
            // libros de un propietario
            LI->( ordSetFocus( "propietario" ) )
            LI->( ordScope( 0, upper( rTrim( cPr ) ) ) )
            LI->( ordScope( 1, upper( rTrim( cPr ) ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 4
            // libros de una ubicación
            LI->( ordSetFocus( "ubicacion" ) )
            LI->( ordScope( 0, upper( rTrim( cUb ) ) ) )
            LI->( ordScope( 1, upper( rTrim( cUb ) ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 5
            // libros de un autor
            LI->( ordSetFocus( "autor" ) )
            LI->( ordScope( 0, upper( rTrim( cAu ) ) ) )
            LI->( ordScope( 1, upper( rTrim( cAu ) ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 6
            // libros de una colección
            LI->( ordSetFocus( "coleccion" ) )
            LI->( ordScope( 0, upper( rTrim( cCl ) ) ) )
            LI->( ordScope( 1, upper( rTrim( cCl ) ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 7
            // libros de una editorial
            LI->( ordSetFocus( "editor" ) )
            LI->( ordScope( 0, upper( rTrim( cEd ) ) ) )
            LI->( ordScope( 1, upper( rTrim( cEd ) ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 8
            // libros editados en un año
            LI->( ordSetFocus( "anoedic" ) )
            LI->( ordScope( 0, str( nAno, 4 ) ) )
            LI->( ordScope( 1, str( nAno, 4 ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 9
            // libros comprados en un periodo
            LI->( ordSetFocus( "fchcompra" ) )
            LI->( ordScope( 0, dTOs( dFch1 ) ) )
            LI->( ordScope( 1, dTOs( dFch2 ) ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 10
            // libros prestados
            LI->( ordSetFocus( "prestados" ) )
            LI->( dbGoTop() )
         case oInforme:nRadio == 11
            // ficha completa del libro seleccionado
            LiImprimirFicha( oInforme, lImg )
         case oInforme:nRadio == 12
            // justificante de préstamo del libro seleccionado
            LiImprimirJustif()
      endcase
      if oInforme:nRadio < 11
         Select LI
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
                     oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
                     oInforme:oReport:EndLine() )
      endif
      oInforme:End(.t.)

      LI->( ordScope( 0, NIL ) )
      LI->( ordScope( 1, NIL ) )
      LI->(DbSetOrder(nOrder))
      LI->(DbGoTo(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .t. )
   oApp():nEdit --


return NIL


/*
 * función .: LiDbfVacia()
 * prec ....: True
 * post ....: Determina si la DBF de libros está vacía o no.
*/

function LiDbfVacia()

   local lReturn := .f.

   if LI->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún libro registrado." ) )
      lReturn := .t.
   endif

return lReturn


/*
 * función .: LiImprimirFicha()
 * prec ....: oFont1 != NIL && oFont2 != NIL && oFont3 != NIL && cTitulo1 != NIL && cTitulo2 != NIL && lImg != NIL
 * post ....: Imprime la ficha del libro actual.
*/

function LiImprimirFicha( oInforme, lImg )
   local nRec  := LI->( recNo() )
   local i     := 0

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(LI->LiTitulo)
   oInforme:cTitulo2 := Rtrim("Ficha del libro")

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

   ACTIVATE REPORT oInforme:oReport FOR LI->( recNo() ) == nRec ;
      ON INIT LiImprimirFicha2( oInforme:oReport, nRec, lImg )

   LI->( dbGoTo( nRec ) )
return NIL


/*
 * función .: LiImprimirFicha2()
 * prec ....: oReport != NIL && oFont1 != NIL && oFont2 != NIL && oFont3 != NIL && cTitulo1 != NIL && cTitulo2 != NIL && lImg != NIL
 * post ....: Rellena la hoja de la ficha del libro actual.
*/

function LiImprimirFicha2( oReport, nRec, lImg )

   local nLines   := 0
   local oRBmp
   local oRImage
   local nFilaBmp := 0
   local nHorz    := 0
   local nVert    := 0
   local nSalto   := 0
   local cBmpFile := ""
   local i        := 0
   local nFila

   LI->( dbGoTo( nRec ) )

   cBmpFile := LI->LiImagen
   if lImg
      if upper( right( rTrim( cBmpFile ), 3 ) ) == "BMP"
         oRBmp    := TBitmap():Define( , lfn2sfn( RTrim( cBmpFile ) ), )
         oReport:StartLine()
         nFilaBmp := oReport:nRow / oReport:nStdLineHeight
         nHorz    := ( oRBmp:nWidth / oReport:nLogPixX ) * 3
         nVert    := ( oRBmp:nHeight / oReport:nLogPixY ) * 3
         nSalto   := ( oRBmp:nHeight / oReport:nStdLineHeight ) * 3
         while nHorz > 6
            nVert  := nVert  * 0.90
            nHorz  := nHorz  * 0.90
            nSalto := nSalto * 0.90
         end while
         oReport:SayBitmap( ( nFilaBMP / 6 ) - 0.1, 1.35, lfn2sfn( rTrim( cBmpFile ) ), nHorz, nVert, 1 )
         oRBmp:Destroy()
         oReport:EndLine()
         for i:= 1 to nSalto + 1
            oReport:StartLine()
            oReport:EndLine()
         next
      else
         oRImage := TImage():Define( , lfn2sfn( rTrim( cBmpFile ) ), )
         oReport:StartLine()
         nFila  := oReport:nRow / oReport:nStdLineHeight
         nHorz  := ( oRImage:nWidth / oReport:nLogPixX ) * 3
         nVert  := ( oRImage:nHeight / oReport:nLogPixY ) * 3
         nSalto := ( oRImage:nHeight / oReport:nStdLineHeight ) * 3
         while nHorz > 6
            nVert  := nVert  * 0.90
            nHorz  := nHorz  * 0.90
            nSalto := nSalto * 0.90
         end while
         oReport:SayImage( ( nFila / 6 ) - 0.1, 1.35, oRImage, nHorz, nVert, 1 )
         oRImage:Destroy()
         oReport:EndLine()
         for i:= 1 to nSalto + 1
            oReport:StartLine()
            oReport:EndLine()
         next
      endif
      oReport:EndLine()
      oReport:StartLine()
   endif

   with object oReport
      :StartLine()
      :Say( 1, i18n("Código:"), 2 )
      :Say( 2, LI->LiCodigo   , 1 )
      :Say( 3, i18n("Título:"), 2 )
      :Say( 4, LI->LiTitulo   , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Tít. Orig.:"), 2 )
      :Say( 2, LI->LiTitOrig      , 1 )
      :Say( 3, i18n("Autor:")     , 2 )
      :Say( 4, LI->LiAutor        , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Materia:"), 2 )
      :Say( 2, LI->LiMateria   , 1 )
      :Say( 3, i18n("Idioma:"), 2 )
      :Say( 4, LI->LiIdioma   , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Propietario:"), 2 )
      :Say( 2, LI->LiPropiet       , 1 )
      :Say( 3, i18n("Ubicación:"), 2 )
      :Say( 4, LI->LiUbicaci     , 1 )
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Editorial:"), 2 )
      :Say( 2, LI->LiEditor      , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Ciudad:"), 2 )
      :Say( 2, LI->LiCiudad   , 1 )
      :Say( 3, i18n("I.S.B.N.:"), 2 )
      :Say( 4, LI->LiIsbn       , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Año Edición:"), 2 )
      :Say( 2, LI->LiAnoEdic       , 1 )
      :Say( 3, i18n("Nº Edición:") , 2 )
      :Say( 4, LI->LiNumEdic       , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Nº Páginas:")    , 2 )
      :Say( 2, LI->LiPaginas          , 1 )
      :Say( 3, i18n("Encuadernación:"), 2 )
      :Say( 4, LI->LiEncuad           , 1 )
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Colección:"), 2 )
      :Say( 2, LI->LiColecc      , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Nº Tomos:"), 2 )
      :Say( 2, LI->LiNumTomos   , 1 )
      :Say( 3, i18n("Tomo Nº:") , 2 )
      :Say( 4, LI->LiEsteTomo   , 1 )
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Centro Compra:"), 2 )
      :Say( 2, LI->LiProveed         , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Fch. Compra:"), 2 )
      :Say( 2, LI->LiFchAdq        , 1 )
      :Say( 3, i18n("Precio:")     , 2 )
      :Say( 4, LI->LiPrecio        , 1 )
      :EndLine()
      :StartLine()
      :Say( 1, i18n("Fch. Lectura:"), 2 )
      :Say( 2, LI->LiFchLec        , 1 )
      :Say( 3, i18n("Valoracióm:") , 2 )
      :Say( 4, LI->LiValoraci      , 1 )
      :EndLine()
      if !empty( LI->LiObserv )
         :StartLine()
         :EndLine()
         :StartLine()
         :EndLine()
         :StartLine()
         :Say( 1, i18n("Comentarios"), 2 )
         :EndLine()
         :StartLine()
         :EndLine()
         nLines := mlCount( LI->LiObserv, 90 )
         for i := 1 to nLines
            :StartLine()
            :Say( 2, memoLine( LI->LiObserv, 90, i ), 1 )
            :EndLine()
         next
      endif
   end with

return NIL

/*_____________________________________________________________________________*/
function LiFilter( i, oCont, oMenu, oVItem )
	local cLi60  := space(60) // autor
	local cLi40	 := space(40) // propietario
	local cLi30  := space(30) // materia
	local cLi15  := space(15) // idioma

	local j
	local aFiltro := {"","","Autor","Materia","Idioma", "Propietario", "Ubicación", "Editorial", "Colección","Fch. compra", "Fch. compra"}
			
	if i == 0
		Li->(DbClearFilter())
		j := 0
	elseif i == 1
		// autor
		AuTabAux( @cLi60, ,"E",oVItem )
		if cLi60 != space(60)
			LI->(DbSetFilter( { || Upper(Rtrim(LI->LiAutor)) == Upper(Rtrim(cLi60)) } ))
			j := 3
		else
			LI->(DbClearFilter())
			j := 0
		endif
	elseif i == 2
		// materia
		MaTabAux( @cLi30, ,"L",oVItem )
		if cLi30 != space(30)
			LI->(DbSetFilter( { || Upper(Rtrim(LI->LiMateria)) == Upper(Rtrim(cLi30)) } ))
			j := 4
		else
			LI->(DbClearFilter())
			j := 0
		endif
	elseif i == 3
		// idioma
		IdTabAux( @cLi15, ,oVItem )
		if cLi15 != space(15)
			LI->(DbSetFilter( { || Upper(Rtrim(LI->LiIdioma)) == Upper(Rtrim(cLi15)) } ))
			j := 5
		else
			LI->(DbClearFilter())
			j := 0
		endif
	elseif i == 4
		// propietario
		AgTabAux( @cLi40, ,"P", oVItem )
		if cLi40 != space(40)
			LI->(DbSetFilter( { || Upper(Rtrim(LI->LiPropiet)) == Upper(Rtrim(cLi40)) } ))
			j := 6
		else
			LI->(DbClearFilter())
			j := 0
		endif
	elseif i == 5
		// ubicación
		UbTabAux( @cLi60, ,"L", oVItem )
		if cLi60 != space(60)
			LI->(DbSetFilter( { || Upper(Rtrim(LI->LiUbicaci)) == Upper(Rtrim(cLi60)) } ))
			j := 7
		else
			LI->(DbClearFilter())
			j := 0
		endif
	elseif i == 6
		// editorial
		EdTabAux( @cLi40, ,"L", oVItem )
		if cLi40 != space(40)
			LI->(DbSetFilter( { || Upper(Rtrim(LI->LiEditor)) == Upper(Rtrim(cLi40)) } ))
			j := 8
		else
			LI->(DbClearFilter())
			j := 0
		endif
	elseif i == 7
		// colección
		ClTabAux( @cLi40, ,"L", , , oVItem )
		if cLi40 != space(40)
			LI->(DbSetFilter( { || Upper(Rtrim(LI->LiColecc)) == Upper(Rtrim(cLi40)) } ))
			j := 8
		else
			LI->(DbClearFilter())
			j := 0
		endif
	elseif i == 10
		// compra en el último mes
		LI->(DbSetFilter( { || LI->LiFchAdq >= (Date() - 31) } )) 
		j := 10
	elseif i == 11
		// compra en el último año
		LI->(DbSetFilter( { || LI->LiFchAdq >= (Date() - 365) } ))
		j := 11
	endif
	LI->(DbGoTop())
	oApp():oGrid:Refresh(.t.)
	For i:=1 to Len(oMenu:aItems)
		oMenu:aItems[i]:SetCheck(.f.)
	Next
	if j==0
		oMenu:aItems[1]:SetCheck(.t.)
		RefreshCont( oCont, "LI", "Libros: " )
		RefreshLiImage()
		oVItem:SetColor(CLR_BLACK)
	else 
		oMenu:aItems[j]:SetCheck(.t.)
		RefreshCont( oCont, "LI", "Libros: ["+aFiltro[j]+"]" )
		RefreshLiImage()
		oVItem:SetColor(CLR_HRED) //oApp():nClrBar)
	endif
return nil
//_____________________________________________________________________________//
