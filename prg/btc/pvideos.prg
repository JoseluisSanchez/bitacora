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
Static oViImage
/*_____________________________________________________________________________*/

function Videos()
   local oBar
   local oCol
   local oCont
	local cTitle := "Videos"
	local cContTitle := cTitle+": "

   local cBrwState := GetIni( , "Browse", "ViAbm-State", "" )
   local nBrwSplit := val( GetIni( , "Browse", "ViAbm-Split", "102" ) )
   local nBrwRecno := val( GetIni( , "Browse", "ViAbm-Recno", "1" ) )
   local nBrwOrder := val( GetIni( , "Browse", "ViAbm-Order", "1" ) )

   local aSoportes := { i18n("VHS"), i18n("DVD"), i18n("DIVX"), i18n("(S)VCD"), i18n("Otro") }

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   VI->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Vídeos y DVD" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

    oApp():oGrid:cAlias := "VI"

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viNumero }
    oCol:cHeader  := i18n( "Código" )
    oCol:nWidth   := 70

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viTitulo }
    oCol:cHeader  := i18n( "Título" )
    oCol:nWidth   := 150

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viOriginal }
    oCol:cHeader  := i18n( "Título original" )
    oCol:nWidth   := 150

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viMateria }
    oCol:cHeader  := i18n( "Materia" )
    oCol:nWidth   := 112

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viIdioma }
    oCol:cHeader  := i18n( "Idioma" )
    oCol:nWidth   := 112

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viPropiet }
    oCol:cHeader  := i18n( "Propietario" )
    oCol:nWidth   := 170

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viUbicaci }
    oCol:cHeader  := i18n( "Ubicación" )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viDurac }
    oCol:cHeader  := i18n( "Duración" )
    oCol:nWidth   := 36

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viInicio }
    oCol:cHeader  := i18n( "Inicio" )
    oCol:nWidth   := 36

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viFinal }
    oCol:cHeader  := i18n( "Final" )
    oCol:nWidth   := 36

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || if( VI->viSoporte != 0, aSoportes[VI->viSoporte], "" ) }
    oCol:cHeader  := i18n( "Soporte" )
    oCol:nWidth   := 80

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viDirector }
    oCol:cHeader  := i18n( "Director" )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viActor }
    oCol:cHeader  := i18n( "Actor" )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viActriz }
    oCol:cHeader  := i18n( "Actriz" )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viFotogra }
    oCol:cHeader  := i18n( "Dir. Fotografía" )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viProduct }
    oCol:cHeader  := i18n( "Productora" )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || str( VI->viAnyo, 4 ) }
    oCol:cHeader  := i18n( "Año Edic." )
    oCol:nWidth   := 42
    oCol:nDataStrAlign := 2

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viColecc }
    oCol:cHeader  := i18n( "Colección" )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || str( VI->viColTot, 6 ) }
    oCol:cHeader  := i18n( "Nº Vídeos" )
    oCol:nWidth   := 55

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || str( VI->viColEst, 6 ) }
    oCol:cHeader  := i18n( "Vídeo Nº" )
    oCol:nWidth   := 55

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viBsoTit }
    oCol:cHeader  := i18n( "Título B.S.O." )
    oCol:nWidth   := 150

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viBsoAut }
    oCol:cHeader  := i18n( "Intérprete B.S.O." )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viBsoEdi }
    oCol:cHeader  := i18n( "Productora B.S.O." )
    oCol:nWidth   := 100

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viCalific }
    oCol:cHeader  := i18n( "Calific. Moral" )
    oCol:nWidth   := 70

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || dTOc( VI->viFchaDQ ) }
    oCol:cHeader  := i18n( "Fch.Compra" )
    oCol:nWidth   := 42

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viProveed }
    oCol:cHeader  := i18n( "Centro de Compra" )
    oCol:nWidth   := 66

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || str( VI->viPrecio )  }
    oCol:cHeader  := i18n( "Precio" )
    oCol:nWidth   := 42

    oCol := oApp():oGrid:AddCol()
    oCol:AddResource( "BR_IMG1" )
    oCol:AddResource( "BR_IMG2" )
    oCol:cHeader       := i18n( "Imagen" )
    oCol:bBmpData      := { || if( !empty( VI->viImagen ), 1, 2 ) }
    oCol:nWidth        := 28
    oCol:nDataBmpAlign := 2

    oCol := oApp():oGrid:AddCol()
    oCol:AddResource( "16_PRES_ON" )
    oCol:AddResource( "16_PRES_OFF" )
    oCol:cHeader       := i18n( "Prestado" )
    oCol:bBmpData      := { || if( IsPrestado( "VI" ), 1, 2 ) }
    oCol:nWidth        := 28
    oCol:nDataBmpAlign := 2

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || dTOc( VI->viFchPres ) }
    oCol:cHeader  := i18n( "Fch.Préstamo" )
    oCol:nWidth   := 74

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viPrestad }
    oCol:cHeader  := i18n( "Prestatario" )
    oCol:nWidth   := 139

	 oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viResumen }
    oCol:cHeader  := i18n( "Resumen" )
    oCol:nWidth   := 150

    oCol := oApp():oGrid:AddCol()
    oCol:bStrData := { || VI->viComenta }
    oCol:cHeader  := i18n( "Comentarios" )
    oCol:nWidth   := 150

    aEval( oApp():oGrid:aCols, { |oCol| oCol:bLDClickData := { || ViForm( oApp():oGrid, "edt", oCont, cContTitle ) } } )

    oApp():oGrid:SetRDD()
    oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := { || RefreshCont( oCont, "VI", cContTitle ), RefreshViImage()  }
   oApp():oGrid:bKeyDown   := { |nKey| ViTeclas( nKey, oApp():oGrid, oCont, oApp():oTab:nOption, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 160 OF oApp():oDlg ;
		COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(VI->(OrdKeyNo()),'@E 999,999')+" / "+tran(VI->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_VIDEOS"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( ViForm( oApp():oGrid, "add", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( ViForm( oApp():oGrid, "edt", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( ViForm( oApp():oGrid, "dup", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( ViBorrar( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( ViBuscar( oApp():oGrid, oCont, oApp():oTab:nOption, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( ViImprimir( oApp():oGrid ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Devolver")           ;
      IMAGE "16_devolver"          ;
      ACTION ( ViDevolver(), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Ver imagen")         ;
      IMAGE "16_imagen"             ;
      ACTION Viximagen( VI->ViImagen, VI->ViTitulo ), oApp():oGrid:setFocus() ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "ViAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ 165, 05 VMENU oBar SIZE nBrwSplit-10, 3*nBrwSplit OF oApp():oDlg  ;
      COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX
	oBar:nClrBox := MIN(GetSysColor(13), GetSysColor(14))

   DEFINE TITLE OF oBar;
      CAPTION i18n("Carátula");
      HEIGHT 25 ;
  		COLOR GetSysColor(9), oApp():nClrBar  	

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
     OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
     ITEMS " "+i18n("Título")+" "       , " "+i18n("Tít. Original")+" ", " "+i18n("Código")+" "   , " "+i18n("Materia")+" "   ,;
           " "+i18n("Propietario")+" "  , " "+i18n("Ubicación")+" ", " "+i18n("Director")+" "  ,;
           " "+i18n("Actor")+" "        , " "+i18n("Actriz")+" "   , " "+i18n("Editor")+" "    ,;
           " "+i18n("Año Edic.")+" "    , " "+i18n("Colección")+" ", " "+i18n("Fch.Compra")+" ",;
           " "+i18n("Fch.Préstamo")+" " ;
     COLOR CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
     ACTION ( ViTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= VI->( ordKeyCount() )
      VI->( dbGoTo( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      ON INIT ( ResizeWndMain(),;
 				    ViBarImage(oBar, nBrwSplit),;
					 ViTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ),;
                oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
              SetIni( , "Browse", "ViAbm-State", oApp():oGrid:SaveState() ),;
              SetIni( , "Browse", "ViAbm-Order", oApp():oTab:nOption ),;
              SetIni( , "Browse", "ViAbm-Recno", VI->( recNo() ) ),;
              SetIni( , "Browse", "ViAbm-Split", lTrim( str( oApp():oSplit:nleft / 2 ) ) ),;
              oBar:End(), oCont:End(), dbCloseAll(),;
              oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .t. )

return nil
/*_____________________________________________________________________________*/
function ViBarImage(oBar, nBrwSplit)
	oViImage := Tximage():TXImage():New( 35, 10, ( 2 * nBrwSplit ) -40, ( 2.6 * nBrwSplit ) -40,,oBar,.t.,.f. )
	if File(lfn2sfn(rtrim(VI->ViImagen)))
      oViImage:SetSource(lfn2sfn(rtrim(VI->ViImagen)))
	else 
		oViImage:Hide()
   endif
return nil

function RefreshViImage()
	oViImage:Hide()
	if File(lfn2sfn(rtrim(VI->ViImagen)))
      oViImage:SetSource(lfn2sfn(rtrim(VI->ViImagen)))
		oViImage:Show()
	endif
	oViImage:Refresh()
return nil
/*_____________________________________________________________________________*/

function ViForm( oBrw, cModo, oCont, cContTitle )
   local oDlg
   local oFld
   local aSay        := array(21)
   local aGet        := array(34)
   local aBtn        := array(20)
   local aBmp        := array(02)
   local oBtnBmp
   local oBtnImg
   local cCaption    := ""
   local lIdOk       := .f.
   local nRecBrw     := VI->( recNo() )
   local nRecAdd     := 0
   local lPrestado   := .f.
   local lPresEdit   := .t.
   local nCalifMoral := 1
   local aCalifMoral := { i18n("TP"), i18n("+7"), i18n("+13"), i18n("+18"), i18n("XXX") }

   local cVinumero   := ""
   local cVipropiet  := ""
   local cVititulo   := ""
   local cViorigina  := ""
   local cVidurac    := ""
   local cViinicio   := ""
   local cVifinal    := ""
   local cVimateria  := ""
   local cViIdioma   := ""
   local cViUbicaci  := ""
   local nViSoporte  := 1
   local nVianyo     := 0
   local cViDirector  := ""
   local cViactor    := ""
   local cViactriz   := ""
   local cViFotogra  := ""
   local cViproduct  := ""
   local mVicomenta
	local cViResumen	:= ""
   local cViprestad  := ""
   local dVifchpres  := date()
   local cViproveed  := ""
   local dVifchadq   := date()
   local nViprecio   := 0
   local cVibsotit   := ""
   local cVibsoaut   := ""
   local cVibsoedi   := ""
   local cVicolecc   := ""
   local nVicoltot   := 0
   local nVicolest   := 0
   local cViImagen   := ""

   if cModo == "edt" .or. cModo == "dup"
      if ViDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if VI->( eof() ) .and. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   cModo := lower( cModo )

   do case
      // nuevo
      case cModo == "add"
         cCaption := i18n( "Añadir un Vídeo" )
         VI->( dbAppend() )
         VI->( dbCommit() )
         nRecAdd := VI->( recNo() )
      // modificar
      case cModo == "edt"
         cCaption    := i18n( "Modificar un Vídeo" )
         nCalifMoral := aScan( aCalifMoral, allTrim( VI->ViCalific ) )
      // duplicar
      case cModo == "dup"
         cCaption    := i18n( "Duplicar un Vídeo" )
         nCalifMoral := aScan( aCalifMoral, allTrim( VI->ViCalific ) )
   end case

   // ambos casos
   cVinumero  := VI->Vinumero
   cVipropiet := VI->Vipropiet
   cVititulo  := VI->Vititulo
   cViorigina := VI->Vioriginal
   cVidurac   := VI->Vidurac
   cViinicio  := VI->Viinicio
   cVifinal   := VI->Vifinal
   cVimateria := VI->Vimateria
   cViIdioma  := VI->ViIdioma
   cViUbicaci := VI->ViUbicaci
   nViSoporte := VI->ViSoporte
   nVianyo    := VI->Vianyo
   cViDirector := VI->Vidirector
   cViactor   := VI->Viactor
   cViactriz  := VI->Viactriz
   cVifotogra := VI->Vifotogra
   cViproduct := VI->Viproduct
	cViResumen := VI->viResumen
   mVicomenta := VI->Vicomenta
   cViprestad := VI->Viprestad
   dVifchpres := VI->Vifchpres
   cViproveed := VI->Viproveed
   dVifchadq  := VI->Vifchadq
   nViprecio  := VI->Viprecio
   cVibsotit  := VI->Vibsotit
   cVibsoaut  := VI->Vibsoaut
   cVibsoedi  := VI->Vibsoedi
   cVicolecc  := VI->Vicolecc
   nVicoltot  := VI->Vicoltot
   nVicolest  := VI->Vicolest
   cViImagen  := VI->ViImagen

   do case
      case cModo == "add" .and. oApp():lCodAut
         GetNewCod( .f., "VI", "ViNumero", @cViNumero )
      case cModo == "dup"
         if oApp():lCodAut
            GetNewCod( .f., "VI", "ViNumero", @cViNumero )
         else
            cViNumero := space( 10 )
         endif
   end case

   lPresEdit := if( cModo == "edt", ( empty( cViPrestad ) .or. dViFchPres == cTOd( "" ) ), .t. )

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "VI_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   // Diálogo principal

   REDEFINE GET aGet[01] ;
      VAR cViTitulo ;
      ID 100 ;
      OF oDlg ;
      WHEN ( lPresEdit )

   REDEFINE GET aGet[02] ;
      VAR cViNumero ;
      ID 101 ;
      OF oDlg ;
      WHEN ( lPresEdit ) ;
      VALID ( ViClave( cViNumero, aGet[02], cModo ) )

   REDEFINE BUTTON aBtn[01];
      ID 113;
      OF oDlg;
      WHEN ( lPresEdit );
      ACTION ( GetNewCod( .t., "VI", "ViNumero", @cViNumero ), aGet[02]:refresh(), aGet[02]:setFocus() )

      aBtn[01]:cToolTip := i18n( "generar código autonumérico" )

   REDEFINE GET aGet[03] ;
      VAR cViOrigina ;
      ID 102 ;
      OF oDlg

   REDEFINE AUTOGET aGet[04] 	;
      VAR cViMateria          ;
		DATASOURCE {}						;
		FILTER MaListV( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 103                  ;
      OF oDlg                 ;
      VALID ( MaClave( @cViMateria, aGet[04], "aux", "V" ) )

   REDEFINE BUTTON aBtn[02];
      ID 114;
      OF oDlg;
      ACTION ( MaTabAux( @cViMateria, aGet[04], "V" ),;
               aGet[04]:setFocus(),;
               SysRefresh() )

      aBtn[02]:cToolTip := i18n( "selecc. materia" )

   REDEFINE AUTOGET aGet[05] 	;
      VAR cViIdioma           ;
		DATASOURCE {}						;
		FILTER IdList( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 104                  ;
      OF oDlg                 ;
      VALID ( IdClave( @cViIdioma, aGet[05], "aux" ) )

   REDEFINE BUTTON aBtn[03];
      ID 115;
      OF oDlg;
      ACTION ( IdTabAux( @cViIdioma, aGet[05] ),;
               aGet[05]:setFocus(),;
               SysRefresh() )

      aBtn[03]:cToolTip := i18n( "selecc. idioma" )

   REDEFINE GET aGet[06] ;
      VAR cViDurac ;
      ID 105 ;
      OF oDlg

   REDEFINE GET aGet[07] ;
      VAR cViInicio ;
      ID 106 ;
      OF oDlg ; // hace la suma y le coloca los espacios restantes por detrás
      VALID ( if( empty( cViFinal ), ( cViFinal := str( val( cViInicio ) + val( cViDurac ),;
       len( allTrim( str( val( cViInicio ) + val( cViDurac ),;
        6 ) ) ) ) + space( 6 - len( allTrim( str( val( cViInicio ) + val( cViDurac ),;
        6 ) ) ) ), aGet[08]:refresh() ), ), .t. )

   REDEFINE GET aGet[08] ;
      VAR cViFinal ;
      ID 107 ;
      OF oDlg

   REDEFINE AUTOGET aGet[09] 	;
      VAR cViPropiet       ;
		DATASOURCE {}						;
		FILTER AgListP( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 108               ;
      OF oDlg              ;
      VALID ( AgClave( @cViPropiet, aGet[09], "aux", "P" ) )

   REDEFINE BUTTON aBtn[04];
      ID 116;
      OF oDlg;
      ACTION ( AgTabAux( @cViPropiet, aGet[09], "P" ),;
               aGet[09]:setFocus(),;
               SysRefresh() )

      aBtn[04]:cToolTip := i18n( "selecc. propietario" )

   REDEFINE AUTOGET aGet[10] 	;
      VAR cViUbicaci          ;
		DATASOURCE {}						;
		FILTER UbListV( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 109                  ;
      OF oDlg                 ;
      VALID ( UbClave( @cViUbicaci, aGet[10], "aux", "V" ) )

   REDEFINE BUTTON aBtn[05];
      ID 117;
      OF oDlg;
      ACTION ( UbTabAux( @cViUbicaci, aGet[10], "V" ),;
               aGet[10]:setFocus(),;
               SysRefresh() )

      aBtn[05]:cToolTip := i18n( "selecc. ubicación" )

   REDEFINE ximage aGet[33] FILE "" ID 118 OF oDlg //SCROLL

   if File(lfn2sfn(rtrim(cViImagen)))
      aGet[33]:SetSource(lfn2sfn(rtrim(cViImagen)))
   endif

   REDEFINE FOLDER oFld ;
      ID 110 ;
      OF oDlg ;
      ITEMS i18n("&Edición"), i18n("Co&lección"), i18n("&Observaciones"), i18n("&Reparto"), i18n("&B.S.O."), i18n("&Imagen"), i18n("Co&mpra"), i18n("&Préstamo") ;
      DIALOGS "VI_FORM_A", "VI_FORM_B", "VI_FORM_C", "VI_FORM_D", "VI_FORM_E", "VI_FORM_F", "VI_FORM_G", "VI_FORM_H"

   // Primer folder: datos de edición

   REDEFINE SAY aSay[01] ID 200 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[03] ID 202 OF oFld:aDialogs[1]

   REDEFINE AUTOGET aGet[11] 	;
      VAR cViProduct          ;
		DATASOURCE {}						;
		FILTER EdListV( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[1]     ;
      VALID ( EdClave( @cViProduct, aGet[11], "aux", "V" ) )

   REDEFINE BUTTON aBtn[06];
      ID 107;
      OF oFld:aDialogs[1];
      ACTION ( EdTabAux( @cViProduct, aGet[11], "V" ),;
               aGet[11]:setFocus(),;
               SysRefresh() )

      aBtn[06]:cToolTip := i18n( "selecc. productora" )

   REDEFINE GET aGet[12] ;
      VAR nViAnyo ;
      ID 101 ;
      OF oFld:aDialogs[1]

   REDEFINE RADIO aGet[13] ;
      VAR nViSoporte ;
      ID 102, 103, 104, 105, 106 ;
      OF oFld:aDialogs[1]

   // Segundo folder: datos de colección

   REDEFINE SAY aSay[04] ID 200 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[05] ID 201 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[06] ID 202 OF oFld:aDialogs[2]

   REDEFINE AUTOGET aGet[14] ;
      VAR cViColecc ;
		DATASOURCE {}						;
		FILTER ClListV( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100 ;
      OF oFld:aDialogs[2] ;
      VALID ( ClClave( @cViColecc, aGet[14], "aux", "V" ) )

   REDEFINE BUTTON aBtn[07];
      ID 103;
      OF oFld:aDialogs[2];
      ACTION ( ClTabAux( @cViColecc, aGet[14], "V", @nViColTot, aGet[15] ),;
               aGet[14]:setFocus(),;
               SysRefresh() )

      aBtn[07]:cToolTip := i18n( "selecc. colección" )

   REDEFINE GET aGet[15] ;
      VAR nViColTot ;
      ID 101 ;
      OF oFld:aDialogs[2] ;
      PICTURE "@E 999,999"

   REDEFINE GET aGet[16] ;
      VAR nViColEst ;
      ID 102 ;
      OF oFld:aDialogs[2] ;
      PICTURE "@E 999,999"

   // Tercer folder: observaciones

   REDEFINE SAY aSay[07] ID 200 OF oFld:aDialogs[3]
   REDEFINE SAY aSay[08] ID 201 OF oFld:aDialogs[3]
	REDEFINE SAY aSay[21] ID 202 OF oFld:aDialogs[3]

   REDEFINE RADIO aGet[17] ;
      VAR nCalifMoral ;
      ID 100, 101, 102, 103, 104 ;
      OF oFld:aDialogs[3]

   REDEFINE GET aGet[18] ;
      VAR mViComenta ;
      ID 105 ;
      OF oFld:aDialogs[3] ;
      MEMO

	REDEFINE GET aGet[34] var cViResumen       ;
		ID 106 OF oFld:aDialogs[3] UPDATE      
	REDEFINE BUTTON aBtn[19]                  ;
		ID 107 OF oFld:aDialogs[3] UPDATE      ;
		ACTION aGet[34]:cText := cGetFile32('*.*','indique la ubicación del resumen',,,,.T.) 
	aBtn[19]:cTooltip := "seleccionar fichero"
	REDEFINE BUTTON aBtn[20]                  ;
		ID 108 OF oFld:aDialogs[3] UPDATE      ;
		ACTION GoFile( cViResumen )            
	aBtn[20]:cTooltip := "ejecutar fichero"

   // Cuarto folder: reparto

   REDEFINE SAY aSay[09] ID 200 OF oFld:aDialogs[4]
   REDEFINE SAY aSay[10] ID 201 OF oFld:aDialogs[4]
   REDEFINE SAY aSay[11] ID 202 OF oFld:aDialogs[4]
   REDEFINE SAY aSay[12] ID 203 OF oFld:aDialogs[4]

   REDEFINE AUTOGET aGet[19] 	;
      VAR cViDirector          ;
		DATASOURCE {}						;
		FILTER AuListT( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[4]     ;
      VALID ( AuClave( @cViDirector, aGet[19], "aux", "T" ) )

   REDEFINE BUTTON aBtn[08];
      ID 104;
      OF oFld:aDialogs[4];
      ACTION ( AuTabAux( @cViDirector, aGet[19], "T" ),;
               aGet[19]:setFocus(),;
               SysRefresh() )

      aBtn[08]:cToolTip := i18n( "selecc. director de cine" )

   REDEFINE AUTOGET aGet[20] 	;
      VAR cViActor            ;
		DATASOURCE {}						;
		FILTER AuListR( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 101                  ;
      OF oFld:aDialogs[4]     ;
      VALID ( AuClave( @cViActor, aGet[20], "aux", "R" ) )

   REDEFINE BUTTON aBtn[09];
      ID 105;
      OF oFld:aDialogs[4];
      ACTION ( AuTabAux( @cViActor, aGet[20], "R" ),;
               aGet[20]:setFocus(),;
               SysRefresh() )

      aBtn[09]:cToolTip := i18n( "selecc. actor" )

   REDEFINE AUTOGET aGet[21] 	;
      VAR cViActriz           ;
		DATASOURCE {}						;
		FILTER AuListR( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 102                  ;
      OF oFld:aDialogs[4]     ;
      VALID ( AuClave( @cViActriz, aGet[21], "aux", "R" ) )

   REDEFINE BUTTON aBtn[10];
      ID 106;
      OF oFld:aDialogs[4];
      ACTION ( AuTabAux( @cViActriz, aGet[21], "R" ),;
               aGet[21]:setFocus(),;
               SysRefresh() )

      aBtn[10]:cToolTip := i18n( "selecc. actriz" )

   REDEFINE AUTOGET aGet[22] 	;
      VAR cVifotogra          ;
		DATASOURCE {}						;
		FILTER AuListF( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 103                  ;
      OF oFld:aDialogs[4]     ;
      VALID ( AuClave( @cVifotogra, aGet[22], "aux", "F" ) )

   REDEFINE BUTTON aBtn[11];
      ID 107;
      OF oFld:aDialogs[4];
      ACTION ( AuTabAux( @cVifotogra, aGet[22], "F" ),;
               aGet[22]:setFocus(),;
               SysRefresh() )

      aBtn[11]:cToolTip := i18n( "selecc. director de fotografía" )

   // Quinto folder: b.s.o.

   REDEFINE SAY aSay[12] ID 200 OF oFld:aDialogs[5]
   REDEFINE SAY aSay[13] ID 201 OF oFld:aDialogs[5]
   REDEFINE SAY aSay[14] ID 202 OF oFld:aDialogs[5]

   REDEFINE GET aGet[23] ;
      VAR cViBsoTit ;
      ID 100 ;
      OF oFld:aDialogs[5]

   REDEFINE AUTOGET aGet[24] ;
      VAR cViBsoAut ;
		DATASOURCE {}						;
		FILTER AuListI( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 101 ;
      OF oFld:aDialogs[5] ;
      VALID ( AuClave( @cViBsoAut, aGet[24], "aux", "I" ) )

   REDEFINE BUTTON aBtn[12];
      ID 103;
      OF oFld:aDialogs[5];
      ACTION ( AuTabAux( @cViBsoAut, aGet[24], "I" ),;
               aGet[24]:setFocus(),;
               SysRefresh() )

      aBtn[12]:cToolTip := i18n( "selecc. intérprete musical" )

   REDEFINE AUTOGET aGet[25] 	;
      VAR cViBsoEdi           ;
		DATASOURCE {}						;
		FILTER EdListD( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 102 ;
      OF oFld:aDialogs[5] ;
      VALID ( EdClave( @cViBsoEdi, aGet[25], "aux", "D" ) )

   REDEFINE BUTTON aBtn[13];
      ID 104;
      OF oFld:aDialogs[5];
      ACTION ( EdTabAux( @cViBsoEdi, aGet[25], "D" ),;
               aGet[25]:setFocus(),;
               SysRefresh() )

      aBtn[13]:cToolTip := i18n( "selecc. productora" )

   // Sexto folder: imagen

   REDEFINE SAY aSay[15] ID 200 OF oFld:aDialogs[6]

   REDEFINE GET aGet[26] ;
      VAR cViImagen ;
      ID 100 ;
      OF oFld:aDialogs[6] ;
      VALID ( aGet[27]:SetSource( , cViImagen ), aGet[27]:refresh(),;
              aGet[33]:SetSource( , cViImagen ), aGet[33]:refresh(), .t. )

   REDEFINE BUTTON aBtn[14];
      ID 103;
      OF oFld:aDialogs[6];
      ACTION ( ViGetImagen( aGet[27], aGet[33], aGet[26], oBtnImg ) )

      aBtn[14]:cToolTip := i18n( "selecc. imagen" )

   REDEFINE ximage aGet[27] FILE "" ID 101 OF oFld:aDialogs[6] //SCROLL

   aGet[27]:SetColor( CLR_RED, CLR_WHITE )

   if File(lfn2sfn(rtrim(cViImagen)))
      aGet[27]:SetSource(lfn2sfn(rtrim(cViImagen)))
   endif

   REDEFINE BUTTON oBtnImg ;
      ID 102 ;
      OF oFld:aDialogs[6] ;
      ACTION Viximagen( cViImagen, cViTitulo, oDlg )

   // Séptimo folder: datos de compra

   REDEFINE SAY aSay[16] ID 200 OF oFld:aDialogs[7]
   REDEFINE SAY aSay[17] ID 201 OF oFld:aDialogs[7]
   REDEFINE SAY aSay[18] ID 202 OF oFld:aDialogs[7]

   REDEFINE AUTOGET aGet[28] 	;
      VAR cViProveed          ;
		DATASOURCE {}						;
		FILTER CcList( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[7]     ;
      VALID ( CcClave( @cViProveed, aGet[28], "aux", "O" ) )

   REDEFINE BUTTON aBtn[15];
      ID 103;
      OF oFld:aDialogs[7];
      ACTION ( CcTabAux( @cViProveed, aGet[28], "O" ),;
               aGet[28]:setFocus(),;
               SysRefresh() )
   aBtn[15]:cToolTip := i18n( "selecc. centro de compra" )

   REDEFINE GET aGet[29] ;
      VAR dViFchAdq ;
      ID 101 ;
      OF oFld:aDialogs[7]

   REDEFINE BUTTON aBtn[16];
      ID 104;
      OF oFld:aDialogs[7];
      ACTION ( SelecFecha( dViFchAdq, aGet[29] ),;
               aGet[29]:setFocus(),;
               SysRefresh() )
	aBtn[16]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[30] ;
      VAR nViPrecio ;
      ID 102 ;
      OF oFld:aDialogs[7] ;
      PICTURE "@E 999,999.99 "

   // Octavo folder: préstamo

   REDEFINE SAY aSay[19] ID 200 OF oFld:aDialogs[8]
   REDEFINE SAY aSay[20] ID 201 OF oFld:aDialogs[8]

   REDEFINE AUTOGET aGet[31]  ;
      VAR cViPrestad          ;
		DATASOURCE {}						;
		FILTER AgListC( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[8]     ;
      VALID ( AgClave( @cViPrestad, aGet[31], "aux", "C" ) )

   REDEFINE BUTTON aBtn[17];
      ID 103;
      OF oFld:aDialogs[8];
      ACTION ( AgTabAux( @cViPrestad, aGet[31], "C" ),;
               aGet[31]:setFocus(),;
               SysRefresh() )

      aBtn[17]:cToolTip := i18n( "selecc. prestatario" )

   REDEFINE BUTTON ;
      ID 101 ;
      OF oFld:aDialogs[8] ;
      WHEN ( !empty( cViPrestad ) .or. dViFchPres != cTOd( "" ) ) ;
      ACTION ( iif( msgYesNo( i18n("¿Desea anotar la devolución del vídeo?") ),;
                     ( cViPrestad := space( 30 ),;
                       aGet[31]:refresh(),;
                       dViFchPres := cTOd( "" ),;
                       aGet[32]:refresh(),;
                       aBmp[02]:reload( "16_pres_off" ),;
                       aBmp[02]:refresh(),;
                       SysRefresh() ), ),;
               aGet[31]:setFocus() )

   REDEFINE GET aGet[32] ;
      VAR dViFchPres ;
      ID 102 ;
      OF oFld:aDialogs[8]

   REDEFINE BUTTON aBtn[18];
      ID 104;
      OF oFld:aDialogs[8];
      ACTION ( SelecFecha( dViFchPres, aGet[32] ),;
               aGet[32]:setFocus(),;
               SysRefresh() )

      aBtn[18]:cToolTip := i18n( "selecc. fecha" )

   // Diálogo principal

   // REDEFINE BITMAP aBmp[01] ID 111 OF oDlg RESOURCE "CLIP_OFF" TRANSPARENT
   // aEval( aGet, { |oGet| oGet:bChange := { || ( aBmp[01]:reload( "CLIP_ON" ), aBmp[01]:refresh() ) } } )
   REDEFINE BITMAP aBmp[02] ID 112 OF oDlg RESOURCE "16_pres_off" TRANSPARENT

   // oFld:setNumFolder()

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
      ON INIT ( oDlg:Center( oApp():oWndMain ), Iif( !empty( cViPrestad ) .or. dViFchPres != cTOd( "" ),;
                 ( aBmp[02]:reload( "16_pres_on"  ), aBmp[02]:refresh() ),;
                 ( aBmp[02]:reload( "16_pres_off" ), aBmp[02]:refresh() ) ) )

   do case
      // nuevo
      case cModo == "add"
         // aceptar
         if lIdOk == .T.
            // alta del vídeo
            VI->( dbGoTo( nRecAdd ) )
            replace VI->Vinumero   with cVinumero
            replace VI->ViPropiet  with cViPropiet
            replace VI->Vititulo   with cVititulo
            replace VI->Vioriginal with cViOrigina
            replace VI->Vidurac    with cVidurac
            replace VI->Viinicio   with cViinicio
            replace VI->Vifinal    with cVifinal
            replace VI->Vimateria  with cVimateria
            replace VI->ViIdioma   with cViIdioma
            replace VI->ViUbicaci  with cViUbicaci
            replace VI->ViSoporte  with nViSoporte
            replace VI->Vianyo     with nVianyo
            replace VI->Vidirector with cViDirector
            replace VI->Viactor    with cViactor
            replace VI->Viactriz   with cViactriz
            replace VI->Vifotogra  with cVifotogra
            replace VI->ViBsoTit   with cViBsoTit
            replace VI->ViBsoAut   with cViBsoAut
            replace VI->ViBsoEdi   with cViBsoEdi
            replace VI->ViProveed  with cViProveed
            replace VI->ViFchAdq   with dViFchAdq
            replace VI->ViPrecio   with nViPrecio
            replace VI->ViProduct  with cViProduct
            replace VI->ViAnyo     with nViAnyo
            replace VI->ViColecc   with cViColecc
            replace VI->ViColTot   with nViColTot
            replace VI->ViColEst   with nViColEst
            replace VI->ViCalific  with aCalifMoral[nCalifMoral]
				replace VI->viResumen  with cViResumen
            replace VI->Vicomenta  with mVicomenta
            replace VI->Viprestad  with cViprestad
            replace VI->Vifchpres  with dVifchpres
            replace VI->ViImagen   with cViImagen
            VI->( dbCommit() )
            nRecBrw := VI->( recNo() )
            // incremento del nº de ejemplares en autores
				AU->(OrdSetFocus("ACTORES"))
				AU->(dbGoTop())
            if AU->( dbSeek( upper( cViActor ) ) )
               replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
               AU->( dbCommit() )
            endif
				if AU->( dbSeek( upper( cViActriz ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				AU->(OrdSetFocus("DIRCINE"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cViDirector ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				AU->(OrdSetFocus("FOTOGRAFIA"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cViFotogra ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				// modificación del nº de ejemplares en productoras
				ED->(OrdSetFocus("EDVIDEOS"))
				ED->(DbGoTop())
				if ED->( dbSeek( upper( cViproduct ) ) )
					replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
					ED->(DbCommit())
				endif
				// modificación del nº de ejemplares en colecciones
				CL->(OrdSetFocus("COVIDEOS"))
				CL->(dbGoTop())
				if CL->( dbSeek( upper( cViColecc ) ) )
					replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
					CL->(dbCommit())
				endif
            // incremento del nº de ejemplares en materias
				MA->(OrdSetFocus("MATERIA"))
				MA->(Dbgotop())
            if MA->( dbSeek( "V" + upper( cViMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumLibr ) + 1
               MA->( dbCommit() )
            endif
            // incremento del nº de ejemplares en ubicaciones
				UB->(OrdSetFocus("UBICACION"))
				UB->(Dbgotop())
            if UB->( dbSeek( "V" + upper( cViUbicaci ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif
            // anotación del préstamo (si es necesario)
            if IsPrestado( "VI" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 3
               replace NO->NoCodigo  with VI->ViNumero
               replace NO->NoFecha   with VI->ViFchPres
               replace NO->NoTitulo  with VI->ViTitulo
               replace NO->NoAQuien  with VI->ViPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  ViImprimirJustif()
               endif
            endif
         // cancelar
         else
            // aquí no ha pasado nada
            VI->( dbGoTo( nRecAdd ) )
            VI->( dbDelete() )
         endif
      // modificar
      case cModo == "edt"
         // aceptar
         if lIdOk == .T.
            // modificación del préstamo (si es necesario)
            do case
               // acaba de anotarse el préstamo
               case !IsPrestado( "VI" ) .and. ( !empty( cViPrestad ) .or. dViFchPres != cTOd( "" ) )
                  NO->( dbAppend() )
                  replace NO->NoTipo    with 3
                  replace NO->NoCodigo  with cViNumero
                  replace NO->NoFecha   with dViFchPres
                  replace NO->NoTitulo  with cViTitulo
                  replace NO->NoAQuien  with cViPrestad
                  NO->( dbCommit() )
                  lPrestado := .T.
               // estaba y sigue estando prestado
               case IsPrestado( "VI" ) .and. ( !empty( cViPrestad ) .or. dViFchPres != cTOd( "" ) )
                  if NO->( dbSeek( "3" + cViNumero ) )
                     replace NO->NoFecha   with dViFchPres
                     replace NO->NoAQuien  with cViPrestad
                     NO->( dbCommit() )
                  endif
               // estaba pero ya no está prestado
               case IsPrestado( "VI" ) .and. ( empty( cViPrestad ) .and. dViFchPres == cTOd( "" ) )
                  if NO->( dbSeek( "3" + VI->ViNumero ) )
                     NO->( dbDelete() )
                  endif
                  NO->( dbCommit() )
            end case
            // modificación del nº de ejemplares en materias
            if ( VI->ViMateria != cViMateria )
					MA->(OrdSetFocus("MATERIA"))
					MA->(Dbgotop())
               do case
                  case ( MA->( dbSeek( "V" + upper( VI->ViMateria ) ) ) )
                     MA->( dbSeek( "V" + upper( cViMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
                     MA->( dbSeek( "V" + upper( VI->ViMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
                     MA->( dbCommit() )
                  case ( empty( VI->ViMateria ) )
                     MA->( dbSeek( "V" + upper( cViMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               end case
            endif
            // modificación del nº de ejemplares en ubicaciones
            if ( VI->ViUbicaci != cViUbicaci )
					UB->(OrdSetFocus("UBICACION"))
					UB->(Dbgotop())
               do case
                  case ( UB->( dbSeek( "V" + upper( VI->ViUbicaci ) ) ) )
                     UB->( dbSeek( "V" + upper( cViUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) + 1
                     UB->( dbSeek( "V" + upper( VI->ViUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) - 1
                     UB->( dbCommit() )
                  case ( empty( VI->ViUbicaci ) )
                     UB->( dbSeek( "V" + upper( cViUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) + 1
               end case
            endif
				// modificación del nº de ejemplares en actor
				if ( Vi->ViActor != cViActor )
					AU->(OrdSetFocus("ACTORES"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( VI->ViActor ) ) ) )
							AU->( dbSeek( upper( cViActor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( VI->ViActor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( Vi->ViActor ) )
							AU->( dbSeek( upper( cViActor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en actriz
				if ( Vi->viActriz != cViactriz )
					AU->(OrdSetFocus("ACTORES"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( VI->viActriz ) ) ) )
							AU->( dbSeek( upper( cViactriz ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( VI->viActriz ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( Vi->viActriz ) )
							AU->( dbSeek( upper( cViactriz ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif
				if ( Vi->viDirector != cViDirector )
					AU->(OrdSetFocus("DIRCINE"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( VI->viDirector ) ) ) )
							AU->( dbSeek( upper( cViDirector ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( VI->viDirector ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( Vi->viDirector ) )
							AU->( dbSeek( upper( cViDirector ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif
				if ( Vi->viFotogra != cViFotogra )
					AU->(OrdSetFocus("FOTOGRAFIA"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( VI->viFotogra ) ) ) )
							AU->( dbSeek( upper( cViFotogra ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( VI->viFotogra ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( Vi->viFotogra ) )
							AU->( dbSeek( upper( cViFotogra ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en productoras
				if ( VI->viProduct != cViproduct )
					ED->(OrdSetFocus("EDVIDEOS"))
					ED->(dbGoTop())
					do case
						case ( ED->( dbSeek( upper( VI->viProduct ) ) ) )
							ED->( dbSeek( upper( cViproduct ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
							ED->( dbSeek( upper( VI->viProduct ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) - 1
							ED->( dbCommit() )
						case ( empty( VI->viProduct ) )
							ED->( dbSeek( upper( cViproduct ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en colecciones
				if ( VI->ViColecc != cViColecc )
					CL->(OrdSetFocus("COVIDEOS"))
					CL->(dbGoTop())
					do case
						case ( CL->( dbSeek( upper( VI->ViColecc ) ) ) )
							CL->( dbSeek( upper( cViColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
							CL->( dbSeek( upper( VI->ViColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) - 1
							CL->( dbCommit() )
						case ( empty( VI->ViColecc ) )
							CL->( dbSeek( upper( cViColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
					endcase
				endif
            // modificación del vídeo
            VI->( dbGoTo( nRecBrw ) )
            replace VI->Vinumero   with cVinumero
            replace VI->ViPropiet  with cViPropiet
            replace VI->Vititulo   with cVititulo
            replace VI->Vioriginal with cViOrigina
            replace VI->Vidurac    with cVidurac
            replace VI->Viinicio   with cViinicio
            replace VI->Vifinal    with cVifinal
            replace VI->Vimateria  with cVimateria
            replace VI->ViIdioma   with cViIdioma
            replace VI->ViUbicaci  with cViUbicaci
            replace VI->ViSoporte  with nViSoporte
            replace VI->Vianyo     with nVianyo
            replace VI->Vidirector with cViDirector
            replace VI->Viactor    with cViactor
            replace VI->Viactriz   with cViactriz
            replace VI->Vifotogra  with cVifotogra
            replace VI->ViBsoTit   with cViBsoTit
            replace VI->ViBsoAut   with cViBsoAut
            replace VI->ViBsoEdi   with cViBsoEdi
            replace VI->ViProveed  with cViProveed
            replace VI->ViFchAdq   with dViFchAdq
            replace VI->ViPrecio   with nViPrecio
            replace VI->ViProduct  with cViProduct
            replace VI->ViAnyo     with nViAnyo
            replace VI->ViColecc   with cViColecc
            replace VI->ViColTot   with nViColTot
            replace VI->ViColEst   with nViColEst
            replace VI->ViCalific  with aCalifMoral[nCalifMoral]
				replace VI->viResumen  with cViResumen
            replace VI->Vicomenta  with mVicomenta
            replace VI->Viprestad  with cViprestad
            replace VI->Vifchpres  with dVifchpres
            replace VI->ViImagen   with cViImagen
            VI->( dbCommit() )
            // impresión del justificante de préstamo (si es necesario)
            if lPrestado
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  ViImprimirJustif()
               endif
            endif
         endif
      // duplicar
      case cModo == "dup"
         // aceptar
         if lIdOk == .T.
            // duplicado del vídeo
            VI->( dbAppend() )
            nRecBrw := VI->( recNo() )
            replace VI->Vinumero   with cVinumero
            replace VI->ViPropiet  with cViPropiet
            replace VI->Vititulo   with cVititulo
            replace VI->Vioriginal with cViOrigina
            replace VI->Vidurac    with cVidurac
            replace VI->Viinicio   with cViinicio
            replace VI->Vifinal    with cVifinal
            replace VI->Vimateria  with cVimateria
            replace VI->ViIdioma   with cViIdioma
            replace VI->ViUbicaci  with cViUbicaci
            replace VI->ViSoporte  with nViSoporte
            replace VI->Vianyo     with nVianyo
            replace VI->Vidirector with cViDirector
            replace VI->Viactor    with cViactor
            replace VI->Viactriz   with cViactriz
            replace VI->Vifotogra  with cVifotogra
            replace VI->ViBsoTit   with cViBsoTit
            replace VI->ViBsoAut   with cViBsoAut
            replace VI->ViBsoEdi   with cViBsoEdi
            replace VI->ViProveed  with cViProveed
            replace VI->ViFchAdq   with dViFchAdq
            replace VI->ViPrecio   with nViPrecio
            replace VI->ViProduct  with cViProduct
            replace VI->ViAnyo     with nViAnyo
            replace VI->ViColecc   with cViColecc
            replace VI->ViColTot   with nViColTot
            replace VI->ViColEst   with nViColEst
            replace VI->ViCalific  with aCalifMoral[nCalifMoral]
            replace VI->viResumen  with cViResumen
				replace VI->Vicomenta  with mVicomenta
            replace VI->Viprestad  with cViprestad
            replace VI->Vifchpres  with dVifchpres
            replace VI->ViImagen   with cViImagen
            VI->( dbCommit() )
            // incremento del nº de ejemplares en autores
				AU->(OrdSetFocus("ACTORES"))
				AU->(dbGoTop())
            if AU->( dbSeek( upper( cViActor ) ) )
               replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
               AU->( dbCommit() )
            endif
				if AU->( dbSeek( upper( cViActriz ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				AU->(OrdSetFocus("DIRCINE"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cViDirector ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				AU->(OrdSetFocus("FOTOGRAFIA"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cViFotogra ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				// modificación del nº de ejemplares en productoras
				ED->(OrdSetFocus("EDVIDEOS"))
				ED->(DbGoTop())
				if ED->( dbSeek( upper( cViproduct ) ) )
					replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
					ED->(DbCommit())
				endif
				// modificación del nº de ejemplares en colecciones
				CL->(OrdSetFocus("COVIDEOS"))
				CL->(dbGoTop())
				if CL->( dbSeek( upper( cViColecc ) ) )
					replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
					CL->(dbCommit())
				endif
            // incremento del nº de ejemplares en materias
				MA->(OrdSetFocus("MATERIA"))
				MA->(Dbgotop())
            if MA->( dbSeek( "V" + upper( cViMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumLibr ) + 1
               MA->( dbCommit() )
            endif
            // incremento del nº de ejemplares en ubicaciones
				UB->(OrdSetFocus("UBICACION"))
				UB->(Dbgotop())
            if UB->( dbSeek( "V" + upper( cViUbicaci ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif
            // anotación del préstamo (si es necesario)
            if IsPrestado( "VI" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 3
               replace NO->NoCodigo  with VI->ViNumero
               replace NO->NoFecha   with VI->ViFchPres
               replace NO->NoTitulo  with VI->ViTitulo
               replace NO->NoAQuien  with VI->ViPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  ViImprimirJustif()
               endif
            endif
         endif
   end case

   // actualización del browse
   VI->( dbGoTo( nRecBrw ) )
   if oCont != nil
      RefreshCont( oCont, "VI", cContTitle )
		RefreshViImage()
   endif
   oBrw:refresh()
   oBrw:setFocus()
   oApp():nEdit--
return nil

/*_____________________________________________________________________________*/

function ViBorrar( oBrw, oCont, cContTitle )

   local nRecord := VI->( recNo() )
   local nNext   := 0

   if ViDbfVacia()
      return nil
   endif

   if IsPrestado( "VI" )
      msgStop( i18n( "No se pueden eliminar vídeos prestados." ) )
      return nil
   endif

   if msgYesNo( i18n( "¿Está seguro de querer borrar este vídeo?" + CRLF + CRLF ;
   + trim( VI->viTitulo ) ) )
      VI->( dbSkip() )
      nNext := VI->( recNo() )
      VI->( dbGoto( nRecord ) )
      // incremento del nº de ejemplares en autores
		AU->(OrdSetFocus("ACTORES"))
		AU->(dbGoTop())
      if AU->( dbSeek( upper( VI->ViActor ) ) )
         replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
         AU->( dbCommit() )
      endif
		if AU->( dbSeek( upper( VI->ViActriz ) ) )
			replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
			AU->( dbCommit() )
		endif
		AU->(OrdSetFocus("DIRCINE"))
		AU->(dbGoTop())
		if AU->( dbSeek( upper( VI->ViDirector ) ) )
			replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
			AU->( dbCommit() )
		endif
		AU->(OrdSetFocus("FOTOGRAFIA"))
		AU->(dbGoTop())
		if AU->( dbSeek( upper( VI->ViFotogra ) ) )
			replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
			AU->( dbCommit() )
		endif
		// modificación del nº de ejemplares en productoras
		ED->(OrdSetFocus("EDVIDEOS"))
		ED->(DbGoTop())
		if ED->( dbSeek( upper( VI->ViProduct ) ) )
			replace ED->EdNumEjem with ( ED->EdNumEjem ) - 1
			ED->(DbCommit())
		endif
		// modificación del nº de ejemplares en colecciones
		CL->(OrdSetFocus("COVIDEOS"))
		CL->(dbGoTop())
		if CL->( dbSeek( upper( VI->ViColecc ) ) )
			replace CL->ClNumEjem with ( CL->ClNumEjem ) - 1
			CL->(dbCommit())
		endif
      // incremento del nº de ejemplares en materias
		MA->(OrdSetFocus("MATERIA"))
		MA->(Dbgotop())
      if MA->( dbSeek( "V" + upper( VI->ViMateria ) ) )
         replace MA->MaNumlibr with ( MA->MaNumLibr ) - 1
         MA->( dbCommit() )
      endif
      // incremento del nº de ejemplares en ubicaciones
		UB->(OrdSetFocus("UBICACION"))
		UB->(Dbgotop())
      if UB->( dbSeek( "V" + upper( VI->ViUbicaci ) ) )
         replace UB->UbItems with ( UB->UbItems ) - 1
         UB->( dbCommit() )
      endif
      VI->( dbDelete() )
      VI->( dbGoto( nNext ) )
      if VI->( eof() ) .or. nNext == nRecord
         VI->( dbGoBottom() )
      endif
   endif

   if oCont != nil
      RefreshCont( oCont, "VI", cContTitle )
		RefreshViImage()
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function ViBuscar( oBrw, oCont, nTabOpc, cChr, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local nRecNo   := VI->( recNo() )
   local lIdOk    := .f.
   local lFecha   := .f.
   local aBrowse  := {}

   if ViDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch nTabOpc
      case 1
         cPrompt := i18n( "Introduzca el Título del Vídeo" )
         cField  := i18n( "Título:" )
         cGet    := space( 60 )
         exit
		case 2
         cPrompt := i18n( "Introduzca el Título original del Vídeo" )
         cField  := i18n( "Título original:" )
         cGet    := space( 60 )
         exit
      case 3
         cPrompt := i18n( "Introduzca el Código del Vídeo" )
         cField  := i18n( "Código:" )
         cGet    := space( 10 )
         exit
      case 4
         cPrompt := i18n( "Introduzca la Materia del Vídeo" )
         cField  := i18n( "Materia:" )
         cGet    := space( 30 )
         exit
      case 5
         cPrompt := i18n( "Introduzca el Propietario del Vídeo" )
         cField  := i18n( "Propietario:" )
         cGet    := space( 40 )
         exit
      case 6
         cPrompt := i18n( "Introduzca la Ubicación del Vídeo" )
         cField  := i18n( "Ubicación:" )
         cGet    := space( 60 )
         exit
      case 7
         cPrompt := i18n( "Introduzca el Director del Vídeo" )
         cField  := i18n( "Director:" )
         cGet    := space( 30 )
         exit
      case 8
         cPrompt := i18n( "Introduzca el Actor principal del Vídeo" )
         cField  := i18n( "Actor:" )
         cGet    := space( 30 )
         exit
      case 9
         cPrompt := i18n( "Introduzca la Actriz principal del Vídeo" )
         cField  := i18n( "Actriz:" )
         cGet    := space( 30 )
         exit
      case 10
         cPrompt := i18n( "Introduzca el Editor del Vídeo" )
         cField  := i18n( "Editor:" )
         cGet    := space( 30 )
         exit
      case 11
         cPrompt := i18n( "Introduzca el Año de Edición del Vídeo" )
         cField  := i18n( "Año de Edición:" )
         cGet    := space( 04 )
         exit
      case 12
         cPrompt := i18n( "Introduzca la Colección del Vídeo" )
         cField  := i18n( "Colección:" )
         cGet    := space( 40 )
         exit
      case 13
         cPrompt := i18n( "Introduzca la Fecha de Compra del Vídeo" )
         cField  := i18n( "Fch. Compra:" )
         cGet    := cTOd( "" )
         exit
      case 14
         cPrompt := i18n( "Introduzca la Fecha de Préstamo del Vídeo" )
         cField  := i18n( "Fch. Préstamo:" )
         cGet    := cTOd( "" )
         exit
   end switch

   lFecha := valType( cGet ) == "D"

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Vídeos" )
   oDlg:SetFont(oApp():oFont)

   REDEFINE SAY PROMPT cPrompt ID 20 OF oDlg
   REDEFINE SAY PROMPT cField  ID 21 OF oDlg

   if cChr != nil
      if ! lFecha
         cGet := cChr + subStr( cGet, 1, len( cGet ) - 1 )
      else
         cGet := cTOd( cChr + " -  -    " )
      endif
   endif

   REDEFINE GET oGet VAR cGet ID 101 OF oDlg

   if cChr != nil
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
            { || ViWildSeek(nTabOpc, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ningún video."))
      else
         ViEjemplares(aBrowse, oApp():oDlg)
      endif
   endif
   ViTabs( oBrw, nTabOpc, oCont)
   RefreshCont( oCont, "VI", cContTitle )
	RefreshViImage()
   oBrw:refresh()
   oBrw:setFocus()
   oApp():nEdit--

return NIL
/*_____________________________________________________________________________*/

function ViWildSeek(nTabOpc, cGet, aBrowse)
   local nRecno   := VI->(Recno())
   do case
      case nTabOpc == 1
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViTitulo)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
		case nTabOpc == 2
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViOriginal)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 3
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViNumero)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 4
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViMateria)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 5
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViPropiet)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 6
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViUbicaci)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 7
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViDirector)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 8
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViActor)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 9
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViActriz)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 10
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViProduct)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 11
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ str(VI->ViAnyo)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 12
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ upper(VI->ViColecc)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 13
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ DtoS(VI->ViFchAdq)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
      case nTabOpc == 14
         VI->(DbGoTop())
         do while ! VI->(eof())
            if cGet $ DtoS(VI->ViFchPres)
               aadd(aBrowse, {VI->ViTitulo, VI->ViMateria, VI->ViDirector, VI->(RecNo())})
            endif
            VI->(DbSkip())
         enddo
   end case
   VI->(DbGoTo(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[1]) < upper(aAut2[1]) } )
return nil
/*_____________________________________________________________________________*/
function ViEjemplares(aBrowse, oParent)
   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := VI->(Recno())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .f.)
   oBrowse:aCols[1]:cHeader := "Título"
   oBrowse:aCols[2]:cHeader := "Materia"
   oBrowse:aCols[3]:cHeader := "Director"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:nWidth  := 140
   oBrowse:aCols[4]:lHide   := .t.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   VI->(OrdSetFocus("titulo"))
   VI->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1])))
   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||VI->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                           ViForm(oBrowse,"edt",,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(VI->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                     ViForm(oBrowse,"edt",,oDlg)),) }
   oBrowse:bChange    := { || VI->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (VI->(DbGoTo(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)
return nil

/*_____________________________________________________________________________*/

function ViTabs( oBrw, nOpc, oCont, cContTitle )
   switch nOpc
      case 1
         VI->( ordSetFocus( "titulo" ) )
         exit
      case 2
         VI->( ordSetFocus( "original" ) )
         exit
		case 3
			VI->( ordSetFocus( "codigo" ) )
			exit
      case 4
         VI->( ordSetFocus( "materia" ) )
         exit
      case 5
         VI->( ordSetFocus( "propietario" ) )
         exit
      case 6
         VI->( ordSetFocus( "propietario" ) )
         exit
      case 7
         VI->( ordSetFocus( "director" ) )
         exit
      case 8
         VI->( ordSetFocus( "actor" ) )
         exit
      case 9
         VI->( ordSetFocus( "actriz" ) )
         exit
      case 10
         VI->( ordSetFocus( "editor" ) )
         exit
      case 11
         VI->( ordSetFocus( "anoedic" ) )
         exit
      case 12
         VI->( ordSetFocus( "coleccion" ) )
         exit
      case 13
         VI->( ordSetFocus( "fchcompra" ) )
         exit
      case 14
         VI->( ordSetFocus( "fchprestamo" ) )
         exit
   end switch
   oBrw:refresh()
   RefreshCont( oCont, "VI", cContTitle )
return nil

/*_____________________________________________________________________________*/

function ViTeclas( nKey, oBrw, oCont, nTabOpc, oDlg )

   switch nKey
      case VK_INSERT
         ViForm( oBrw, "add", oCont )
         exit
      case VK_RETURN
         ViForm( oBrw, "edt", oCont )
         exit
      case VK_DELETE
         ViBorrar( oBrw, oCont )
         exit
      case VK_ESCAPE
         oDlg:End()
         exit
      otherwise
         if nKey >= 97 .and. nKey <= 122
            nKey := nKey - 32
         endif
         if nKey >= 65 .and. nKey <= 90
            ViBuscar( oBrw, oCont, nTabOpc, chr( nKey ) )
         endif
         exit
   end switch

return nil

/*_____________________________________________________________________________*/

function ViImprimirJustif()

   local nRec    := VI->( recNo() )
   local oInforme

   oInforme := TInforme():New( {}, {}, {}, {}, {}, {}, "VI" )

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(VI->ViTitulo)
   oInforme:cTitulo2 := Rtrim("Justificante de préstamo del video")
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

   ACTIVATE REPORT oInforme:oReport FOR VI->( recNo() ) == nRec ;
      ON INIT ViImprimirJustif2( oInforme:oReport, nRec )

   VI->( dbGoTo( nRec ) )

return nil

/*_____________________________________________________________________________*/

function ViImprimirJustif2( oReport, nRec )

   VI->( dbGoTo( nRec ) )

   oReport:StartLine()
   oReport:Say( 1, i18n("Código:"), 1 )
   oReport:Say( 2, VI->ViNumero   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Título:"), 1 )
   oReport:Say( 2, VI->ViTitulo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Director:"), 1 )
   oReport:Say( 2, VI->ViDirector   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, "", 2 )
   oReport:Say( 2, "", 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Propietario:"), 1 )
   oReport:Say( 2, VI->ViPropiet       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fecha de Compra:"), 1 )
   oReport:Say( 2, VI->ViFchAdq            , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Este video ha sido objeto del siguiente préstamo:"), 2 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Prestatario:"), 1 )
   oReport:Say( 2, VI->ViPrestad       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fecha de Préstamo:"), 1 )
   oReport:Say( 2, VI->ViFchPres             , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Firma del Prestatario:"), 2 )
   oReport:EndLine()

return nil

/*_____________________________________________________________________________*/

function ViDevolver()

   if ViDbfVacia()
      return nil
   endif

   if !IsPrestado( "VI" )
      msgStop( i18n( "El vídeo seleccionado no está prestado." ) )
      return nil
   endif

   if msgYesNo( i18n( "¿Desea anotar la devolución de este vídeo?" ) + CRLF + CRLF + ;
                i18n( trim( VI->ViTitulo ) ) )
      if NO->( dbSeek( "3" + VI->ViNumero ) )
         replace VI->ViPrestad with ""
         replace VI->ViFchPres with cTOd( "" )
         VI->( dbCommit() )
         NO->( dbDelete() )
         NO->( dbCommit() )
      else
         msgAlert( i18n( "No se encontró el vídeo seleccionado en el fichero de préstamos. Por favor reindexe los ficheros." ) )
      endif

   endif

return nil

/*_____________________________________________________________________________*/

function ViClave( cClave, oGet, cModo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "VI"
   local cMsgSi  := i18n( "Código de vídeo ya registrado." )
   local cMsgNo  := i18n( "Código de vídeo no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
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
      end case
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

/*_____________________________________________________________________________*/

function ViGetImagen( oImage1, oImage2, oGet, oBtn )
   local cImageFile
   cImageFile := cGetfile32( i18n("Archivos de imagen") + " (bmp,jpg,gif,png,dig,pcx,tga,rle) | *.bmp;*.jpg;*.gif;*.png;*.dig;*.pcx;*.tga;*.rle |",;
                             i18n("Indica la ubicación de la imagen"),,,, .t. )
   if ! empty(cImageFile) .and. File(lfn2sfn(rtrim(cImageFile)))
      oImage1:SetSource(lfn2sfn(rtrim(cImageFile)))
      oImage2:SetSource(lfn2sfn(rtrim(cImageFile)))
      oGet:cText := cImageFile
      oBtn:Refresh()
   endif
return nil

/*_____________________________________________________________________________*/

function Viximagen( cImagen, cTitulo )

   local oDlg
   local oImage

   if ViDbfVacia()
      return nil
   endif

   if empty( rTrim( cImagen ) )
      msgInfo( i18n( "El vídeo no tiene asociada ninguna imagen." ) )
      return nil
   endif

   if ! file( lfn2sfn( rTrim( cImagen ) ) )
      msgInfo( i18n( "No existe el fichero de imagen asociado al vídeo." ) +" "+ ;
              i18n( "Por favor revise la ruta y el nombre del fichero." ) )
      return nil
   endif

   oApp():nEdit++

   DEFINE DIALOG oDlg RESOURCE "DLG_IMGZOOM" TITLE cTitulo
   oDlg:SetFont(oApp():oFont)

   REDEFINE ximage oImage ;
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

return nil

/*_____________________________________________________________________________*/

function ViImprimir( oBrw )
              //  título                   campo         wd  shw  picture          tot
                 //  =======================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Código"         ), "VINUMERO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Título"         ), "VITITULO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Título original"), "VIORIGINAL",  0, .t.,            "NO", .f. },;
                   { i18n("Materia"        ), "VIMATERIA" ,  0, .t.,            "NO", .f. },;
                   { i18n("Idioma"         ), "VIIDIOMA"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Propietario"    ), "VIPROPIET" ,  0, .t.,            "NO", .f. },;
                   { i18n("Ubicación"      ), "VIUBICACI" ,  0, .t.,            "NO", .f. },;
                   { i18n("Duración"       ), "VIDURAC"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Inicio"         ), "VIINICIO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Final"          ), "VIFINAL"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Soporte"        ), "VISOPORTE" ,  8, .t.,        "ARRAY1", .f. },;
                   { i18n("Director"       ), "VIDIRECTOR",  0, .t.,            "NO", .f. },;
                   { i18n("Actor"          ), "VIACTOR"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Actriz"         ), "VIACTRIZ"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Dir. Fotografía"), "VIFOTOGRA" ,  0, .t.,            "NO", .f. },;
                   { i18n("Productora"     ), "VIPRODUCT" ,  0, .t.,            "NO", .f. },;
                   { i18n("Año Edic."      ), "VIANYO"    ,  0, .t.,            "NO", .f. },;
                   { i18n("Colección"      ), "VICOLECC"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Nº Vídeos"      ), "VICOLTOT"  ,  0, .t.,     "@E 99,999", .f. },;
                   { i18n("Vídeo Nº"       ), "VICOLEST"  ,  0, .t.,     "@E 99,999", .f. },;
                   { i18n("Título B.S.O."  ), "VIBSOTIT"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Aut/Dir. B.S.O."), "VIBSOTIT"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Product. B.S.O."), "VIBSOTIT"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Calific. Moral" ), "VICALIFIC" ,  0, .t.,            "NO", .f. },;
                   { i18n("Fch.Compra"     ), "VIFCHADQ"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Centro Compra"  ), "VIPROVEED" ,  0, .t.,            "NO", .f. },;
                   { i18n("Precio"         ), "VIPRECIO"  ,  0, .t., "@E 999,999.99", .t. },;
                   { i18n("Fch.Préstamo"   ), "VIFCHPRES" ,  0, .t.,            "NO", .f. },;
                   { i18n("Prestatario"    ), "VIPRESTAD" ,  0, .t.,            "NO", .f. },;
                   { i18n("Comentarios"    ), "VICOMENTA" , 40, .t.,            "NO", .f. } }
   local nRecno   := VI->(Recno())
   local nOrder   := VI->(OrdSetFocus())
   local aCampos  := { "VINUMERO", "VITITULO", "VIORIGINAL", "VIMATERIA", "VIIDIOMA",;
                       "VIPROPIET", "VIUBICACI", "VIDURAC", "VIINICIO", "VIFINAL",;
                       "VISOPORTE", "VIDIRECTOR", "VIACTOR", "VIACTRIZ", "VIFOTOGRA",;
                       "VIPRODUCT", "VIANYO", "VICOLECC", "VICOLTOT", "VICOLEST",;
                       "VIBSOTIT", "VIBSOAUT", "VIBSOEDI", "VICALIFIC", "VICOMENTA",;
                       "VIFCHADQ", "VIPROVEED", "VIPRECIO", "VIFCHPRES", "VIPRESTAD" }
   local aTitulos := { "Código", "Título", "Tít. original", "Materia", "Idioma",;
                       "Propietario", "Ubicación", "Duración", "Inicio", "Final",;
                       "Soporte", "Director", "Actor", "Actriz", "D. Fotografía",;
                       "Productora", "Año Edic.", "Colección", "Nº Vídeos", "Vídeo Nº",;
                       "Título B.S.O.", "Aut/Dir. B.S.O.", "Product. B.S.O.", "Cal. Moral", "Comentarios",;
                        "Fch.Compra", "Centro Compra", "Precio", "Fch.Préstamo", "Prestatario" }
   local aWidth   := { 10, 20, 20, 10, 10, 10, 10, 10, 10, 10,;
                       10, 10, 10, 10, 10, 10, 10, 10, 10, 10,;
                       10, 10, 10, 10, 10, 10, 10, 10, 10, 10 }
   local aShow    := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t.,;
                       .t., .t., .t., .t., .t., .t., .t., .t., .t., .t.,;
                       .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO",;
                       "VI01", "NO","NO", "NO", "NO", "NO", "NO", "NO", "@E 99,999","@E 99,999",;
                       "NO", "NO", "NO", "NO", "NO", "NO", "NO", "@E 999,999.99", "NO", "NO" }

   local aTotal   := { .f., .f., .f., .f., .f., .f., .f., .f., .f., .f.,;
                       .f., .f., .f., .f., .f., .f., .f., .f., .t., .t.,;
                       .f., .f., .f., .f., .f., .f., .f., .t., .f., .f. }
   local oInforme
   local nAt
   local cAlias   := "VI"
   local cTotal   := "Total videos: "
   local aGet     := array(11)
   local aSay     := array(2)
   local aBtn     := array(2)

   // local aSoporte := { i18n("VHS"), i18n("DVD"), i18n("DIVX"), i18n("(S)VCD"), i18n("Otro") }

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

   local aDi      := {}
   local cDi      := ""
   local nDiOrd   := AU->( ordNumber() )
   local nDiRec   := AU->( recNo() )

   local aAc      := {}
   local cAc      := ""
   local nAcOrd   := AU->( ordNumber() )
   local nAcRec   := AU->( recNo() )

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


   if ViDbfVacia()
      retu nil
   endif

   oApp():nEdit++

   SELECT VI  // imprescindible

   FillCmb( "MA", "vmateria"    , aMa, "MaMateria", nMaOrd, nMaRec, @cMa )
   FillCmb( "AG", "propietarios", aPr, "PeNombre" , nPrOrd, nPrRec, @cPr )
   FillCmb( "UB", "vubicacion"  , aUb, "UbUbicaci", nUbOrd, nUbRec, @cUb )
   FillCmb( "AU", "dircine"     , aDi, "AuNombre" , nDiOrd, nDiRec, @cDi )
   FillCmb( "AU", "actores"     , aAc, "AuNombre" , nAcOrd, nAcRec, @cAc )
   FillCmb( "CL", "covideos"    , aCl, "ClNombre" , nClOrd, nClRec, @cCl )
   FillCmb( "ED", "edvideos"    , aEd, "EdNombre" , nEdOrd, nEdRec, @cEd )

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   REDEFINE SAY aSay[01] ID 200 OF oInforme:oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oInforme:oFld:aDialogs[1]

   REDEFINE RADIO oInforme:oRadio ;
      VAR oInforme:nRadio ;
      ID 100, 101, 103, 122, 105, 107, 109, 111, 113, 115, 118, 119, 121 ;
      OF oInforme:oFld:aDialogs[1]

   if !IsPrestado( "VI" )
      oInforme:oRadio:aItems[13]:disable() // justificante de préstamo
   endif

   REDEFINE COMBOBOX aGet[01] VAR cMa ITEMS aMa ID 102 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 2
   REDEFINE COMBOBOX aGet[02] VAR cPr ITEMS aPr ID 104 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 3
   REDEFINE COMBOBOX aGet[03] VAR cUb ITEMS aUb ID 123 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 4
   REDEFINE COMBOBOX aGet[04] VAR cDi ITEMS aDi ID 106 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 5
   REDEFINE COMBOBOX aGet[05] VAR cAc ITEMS aAc ID 108 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 6
   REDEFINE COMBOBOX aGet[06] VAR cCl ITEMS aCl ID 110 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 7
   REDEFINE COMBOBOX aGet[07] VAR cEd ITEMS aEd ID 112 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 8

   REDEFINE GET aGet[08] ;
      VAR nAno ;
      ID 114 ;
      OF oInforme:oFld:aDialogs[1] ;
      PICTURE "9999" ;
      WHEN oInforme:nRadio == 9

   REDEFINE GET aGet[09] ;
      VAR dFch1 ;
      ID 116 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 10

   REDEFINE BUTTON aBtn[01];
      ID 137;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch1, aGet[09] ),;
               aGet[09]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 10

      aBtn[01]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[10] ;
      VAR dFch2 ;
      ID 117 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 10

   REDEFINE BUTTON aBtn[02];
      ID 138;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch2, aGet[10] ),;
               aGet[10]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 10

      aBtn[02]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE CHECKBOX aGet[11] ;
      VAR lImg ;
      ID 120 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 12 .and. !empty( VI->ViImagen )

   oInforme:Folders()
   if oInforme:Activate()
      nRecno := VI->( recNo() )
      nOrder := VI->( ordNumber() )
      do case
         case oInforme:nRadio == 1
            VI->( dbGoTop() )
         case oInforme:nRadio == 2
            VI->( ordScope( 0, upper( rTrim( cMa ) ) ) )
            VI->( ordScope( 1, upper( rTrim( cMa ) ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 3
            VI->( ordSetFocus( "propietario" ) )
            VI->( ordScope( 0, upper( rTrim( cPr ) ) ) )
            VI->( ordScope( 1, upper( rTrim( cPr ) ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 4
            VI->( ordSetFocus( "ubicacion" ) )
            VI->( ordScope( 0, upper( rTrim( cUb ) ) ) )
            VI->( ordScope( 1, upper( rTrim( cUb ) ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 5
            VI->( ordSetFocus( "director" ) )
            VI->( ordScope( 0, upper( rTrim( cDi ) ) ) )
            VI->( ordScope( 1, upper( rTrim( cDi ) ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 6
            SET FILTER TO upper(rTrim(cAc)) == upper( rTrim(VI->ViActor)  ) .or. ;
                          upper(rTrim(cAc)) == upper( rTrim(VI->ViActriz) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 7
            VI->( ordSetFocus( "coleccion" ) )
            VI->( ordScope( 0, upper( rTrim( cCl ) ) ) )
            VI->( ordScope( 1, upper( rTrim( cCl ) ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 8
            VI->( ordSetFocus( "editor" ) )
            VI->( ordScope( 0, upper( rTrim( cEd ) ) ) )
            VI->( ordScope( 1, upper( rTrim( cEd ) ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 9
            VI->( ordSetFocus( "anoedic" ) )
            VI->( ordScope( 0, str( nAno, 4 ) ) )
            VI->( ordScope( 1, str( nAno, 4 ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 10
            VI->( ordSetFocus( "fchcompra" ) )
            VI->( ordScope( 0, dTOs( dFch1 ) ) )
            VI->( ordScope( 1, dTOs( dFch2 ) ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 11
            VI->( ordSetFocus( "prestados" ) )
            VI->( dbGoTop() )
         case oInforme:nRadio == 12
            ViImprimirFicha(oInforme, lImg)
         case oInforme:nRadio == 13
            ViImprimirJustif()
      end case
      if oInforme:nRadio < 12
         Select VI
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
                     oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
                     oInforme:oReport:EndLine() )
      endif
      oInforme:End(.t.)

      VI->( ordScope( 0, NIL ) )
      VI->( ordScope( 1, NIL ) )
      VI->(DbSetOrder(nOrder))
      VI->(DbGoTo(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .t. )
   oApp():nEdit --
return nil

/*_____________________________________________________________________________*/

function ViDbfVacia()

   local lReturn := .f.

   if VI->( ordKeyVal() ) == nil
      msgStop( i18n( "No hay ningún vídeo registrado." ) )
      lReturn := .t.
   endif

return lReturn

/*_____________________________________________________________________________*/

function ViImprimirFicha( oInforme, lImg )
   local nRec  := VI->( recNo() )
   local i     := 0

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(VI->ViTitulo)
   oInforme:cTitulo2 := Rtrim("Ficha del video")

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

   ACTIVATE REPORT oInforme:oReport FOR VI->( recNo() ) == nRec ;
      ON INIT ViImprimirFicha2( oInforme:oReport, nRec, lImg )

   VI->( dbGoTo( nRec ) )
return NIL

/*_____________________________________________________________________________*/

function ViImprimirFicha2( oReport, cTitulo2, nRec, lImg )

   local nLines    := 0
   local oRBmp
   local oRImage
   local nFilaBmp  := 0
   local nHorz     := 0
   local nVert     := 0
   local nSalto    := 0
   local cBmpFile  := ""
   local i         := 0
   local nFila

   local aSoportes := { i18n("VHS"), i18n("DVD"), i18n("DIVX"), i18n("(S)VCD"), i18n("Otro") }

   VI->( dbGoTo( nRec ) )

   cBmpFile := VI->ViImagen
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

   oReport:StartLine()
   oReport:Say( 1, i18n("Código:"), 2 )
   oReport:Say( 2, VI->ViNumero   , 1 )
   oReport:Say( 3, i18n("Título:"), 2 )
   oReport:Say( 4, VI->ViTitulo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Tít. Orig.:"), 2 )
   oReport:Say( 2, VI->ViOriginal     , 1 )
   oReport:Say( 3, i18n("Materia:")   , 2 )
   oReport:Say( 4, VI->ViMateria      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Idioma:")  , 2 )
   oReport:Say( 2, VI->ViIdioma     , 1 )
   oReport:Say( 3, i18n("Duración:"), 2 )
   oReport:Say( 4, VI->ViDurac      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Inicio:"), 2 )
   oReport:Say( 2, VI->ViInicio   , 1 )
   oReport:Say( 3, i18n("Final:"), 2 )
   oReport:Say( 4, VI->ViFinal   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Propietario:"), 2 )
   oReport:Say( 2, VI->ViPropiet       , 1 )
   oReport:Say( 3, i18n("Ubicación:")  , 2 )
   oReport:Say( 4, VI->ViUbicaci       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Director:"), 2 )
   oReport:Say( 2, VI->ViDirector   , 1 )
   oReport:Say( 3, i18n("Actor:")   , 2 )
   oReport:Say( 4, VI->ViActor      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Actriz:")     , 2 )
   oReport:Say( 2, VI->ViActriz        , 1 )
   oReport:Say( 3, i18n("Dir.Fotogr.:"), 2 )
   oReport:Say( 4, VI->ViFotogra       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Productora:"), 2 )
   oReport:Say( 2, VI->ViProduct      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Año:")            , 2 )
   oReport:Say( 2, VI->ViAnyo              , 1 )
   oReport:Say( 3, i18n("Soporte:")        , 2 )
   oReport:Say( 4, aSoportes[VI->ViSoporte], 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Colección:"), 2 )
   oReport:Say( 2, VI->ViColecc      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Nº Vídeos:"), 2 )
   oReport:Say( 2, VI->ViColTot      , 1 )
   oReport:Say( 3, i18n("Vídeo Nº:") , 2 )
   oReport:Say( 4, VI->ViColEst      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Centro Compra:"), 2 )
   oReport:Say( 2, VI->ViProveed       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fch. Compra:"), 2 )
   oReport:Say( 2, VI->ViFchAdq        , 1 )
   oReport:Say( 3, i18n("Precio:")     , 2 )
   oReport:Say( 4, VI->ViPrecio        , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Título B.S.O.:"), 2 )
   oReport:Say( 2, VI->ViBsoTit          , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Intérp. B.S.O.:"), 2 )
   oReport:Say( 2, VI->ViBsoAut           , 1 )
   oReport:Say( 3, i18n("Produc. B.S.O.:"), 2 )
   oReport:Say( 4, VI->ViBsoEdi           , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
    oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Calif. Moral:"), 2 )
   oReport:Say( 2, VI->ViCalific        , 1 )
   oReport:EndLine()
   if !empty( VI->ViComenta )
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 1, i18n("Comentarios"), 2 )
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      nLines := mlCount( VI->ViComenta, 90 )
      for i := 1 to nLines
         oReport:StartLine()
         oReport:Say( 2, memoLine( VI->ViComenta, 90, i ), 1 )
         oReport:EndLine()
      next
   endif

return NIL
