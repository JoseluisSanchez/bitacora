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
Static oSoImage
/*_____________________________________________________________________________*/

function Software()

   local oBar
   local oCol
   local oCont
	local cTitle 	  := "Software"
	local cContTitle := cTitle+": "

   local cBrwState := GetIni( , "Browse", "SoAbm-State", "" )
   local nBrwSplit := val( GetIni( , "Browse", "SoAbm-Split", "102" ) )
   local nBrwRecno := val( GetIni( , "Browse", "SoAbm-Recno", "1" ) )
   local nBrwOrder := val( GetIni( , "Browse", "SoAbm-Order", "1" ) )

   local aEntorno  := { i18n("DOS"), i18n("Windows"), i18n("Linux"), i18n("MacOS"), i18n("Otro") }

   if ModalSobreFsdi()
      retu NIL
   endif

   if ! Db_OpenAll()
      retu NIL
   endif

   SO->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Software" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "SO"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soCodigo }
   oCol:cHeader  := i18n( "Código" )
   oCol:nWidth   := 70

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soTitulo }
   oCol:cHeader  := i18n( "Nombre" )
   oCol:nWidth   := 147

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soDescri }
   oCol:cHeader  := i18n( "Descripción" )
   oCol:nWidth   := 150

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soMateria }
   oCol:cHeader  := i18n( "Materia" )
   oCol:nWidth   := 190

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soIdioma }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 80

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soPropiet }
   oCol:cHeader  := i18n( "Propietario" )
   oCol:nWidth   := 141

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soGuardado }
   oCol:cHeader  := i18n( "Ubicación" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soEditor }
   oCol:cHeader  := i18n( "Compañía" )
   oCol:nWidth   := 150

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soNumSer }
   oCol:cHeader  := i18n( "Nº Serie" )
   oCol:nWidth   := 79

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || aEntorno[Max(SO->soEntorno6,1)] }
   oCol:cHeader  := i18n( "Entorno" )
   oCol:nWidth   := 70

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "BR_DEMO1" )
   oCol:AddResource( "BR_DEMO2" )
   oCol:cHeader       := i18n( "Demo" )
   oCol:bBmpData      := { || if( SO->soDemo, 1, 2 ) }
   oCol:nWidth        := 28
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "BR_DISK1" )
   oCol:AddResource( "BR_DISK2" )
   oCol:cHeader       := i18n( "Disquette" )
   oCol:bBmpData      := { || if( SO->soDiscos, 1, 2 ) }
   oCol:nWidth        := 28
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( SO->soNumDisk, 2 ) }
   oCol:cHeader  := i18n( "Nº Discos" )
   oCol:nWidth   := 30

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "BR_CD1" )
   oCol:AddResource( "BR_CD2" )
   oCol:cHeader       := i18n( "CD" )
   oCol:bBmpData      := { || if( SO->soCD, 1, 2 ) }
   oCol:nWidth        := 28
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soUbicaci }
   oCol:cHeader  := i18n( "Título CD" )
   oCol:nWidth   := 126

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soNomDir }
   oCol:cHeader  := i18n( "Dir./Nombre CD" )
   oCol:nWidth   := 130

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || dTOc( SO->soFchComp ) }
   oCol:cHeader  := i18n( "Fch.Compra" )
   oCol:nWidth   := 65

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soProveed }
   oCol:cHeader  := i18n( "Centro Compra" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( SO->soPrecio ) }
   oCol:cHeader  := i18n( "Precio" )
   oCol:nWidth   := 56

   oCol := oApp():oGrid:AddCol()   
   oCol:bStrData := { || SO->SoResumen }
   oCol:cHeader  := i18n( "Resumen" )
   oCol:nWidth   := 150

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "BR_IMG1" )
   oCol:AddResource( "BR_IMG2" )
   oCol:cHeader       := i18n( "Imagen" )
   oCol:bBmpData      := { || if( !empty( SO->SoImagen ), 1, 2 ) }
   oCol:nWidth        := 28
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "16_PRES_ON" )
   oCol:AddResource( "16_PRES_OFF" )
   oCol:cHeader       := i18n( "Prestado" )
   oCol:bBmpData      := { || if( IsPrestado( "SO" ), 1, 2 ) }
   oCol:nWidth        := 28
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || dTOc( SO->soFecha ) }
   oCol:cHeader  := i18n( "Fch.Préstamo" )
   oCol:nWidth   := 74

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || SO->soPrestad }
   oCol:cHeader  := i18n( "Prestatario" )
   oCol:nWidth   := 150

   aEval( oApp():oGrid:aCols, { |oCol| oCol:bLDClickData := { || SoForm( oApp():oGrid, "edt", oCont, cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := { || RefreshCont( oCont, "SO", cContTitle ), RefreshSoImage() }
   oApp():oGrid:bKeyDown   := { |nKey| SoTeclas( nKey, oApp():oGrid, oCont, oApp():oTab:nOption, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 160 OF oApp():oDlg ;
		COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX
	
   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(SO->(OrdKeyNo()),'@E 999,999')+" / "+tran(SO->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
  		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_SOFTWARE"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( SoForm( oApp():oGrid, "add", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( SoForm( oApp():oGrid, "edt", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( SoForm( oApp():oGrid, "dup", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( SoBorrar( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( SoBuscar( oApp():oGrid, oCont, oApp():oTab:nOption, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( SoImprimir( oApp():oGrid ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Devolver")           ;
      IMAGE "16_devolver"          ;
      ACTION ( SoDevolver(), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Ver imagen")         ;
      IMAGE "16_imagen"             ;
      ACTION Soximagen( SO->SoImagen, SO->SoTitulo ), oApp():oGrid:setFocus() ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "SoAbm-State" ), oApp():oGrid:setFocus() ) ;
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
      CAPTION i18n("Icono");
      HEIGHT 25 ;
		COLOR GetSysColor(9), oApp():nClrBar 	

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
     OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
     ITEMS " "+i18n("Nombre")+" "     , " "+i18n("Código")+" "      , " "+i18n("Materia")+" "  ,;
           " "+i18n("Propietario")+" ", " "+i18n("Ubicación")+" "   , " "+i18n("Compañía")+" " ,;
           " "+i18n("Fch.Compra")+" " , " "+i18n("Fch.Préstamo")+" ";
     COLOR CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
     ACTION ( SoTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= SO->( ordKeyCount() )
      SO->( dbGoTo( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      ON INIT ( ResizeWndMain(),;
					 SoBarImage(oBar, nBrwSplit),;
					 SoTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ),;
                oApp():oGrid:SetFocus() );
      VALID ( oApp():oGrid:nLen := 0,;
              SetIni( , "Browse", "SoAbm-State", oApp():oGrid:SaveState() ),;
              SetIni( , "Browse", "SoAbm-Order", oApp():oTab:nOption ),;
              SetIni( , "Browse", "SoAbm-Recno", SO->( recNo() ) ),;
              SetIni( , "Browse", "SoAbm-Split", lTrim( str( oApp():oSplit:nleft / 2 ) ) ),;
              oBar:End(), oCont:End(), dbCloseAll(),;
              oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .t. )
return NIL
/*_____________________________________________________________________________*/
function SoBarImage(oBar, nBrwSplit)
	oSoImage := Tximage():TXImage():New( 35, 10, ( 2 * nBrwSplit ) -40, ( 2.6 * nBrwSplit ) -40,,oBar,.t.,.f. )
	if File(lfn2sfn(rtrim(SO->SoImagen)))
      oSoImage:SetSource(lfn2sfn(rtrim(SO->SoImagen)))
   else 
      oSoImage:Hide()
   endif
return nil

function RefreshSoImage()
   oSoImage:Hide()
	if File(lfn2sfn(rtrim(SO->SoImagen)))
	   oSoImage:SetSource(lfn2sfn(rtrim(SO->SoImagen)))
     	oSoImage:Show()
	endif
	oSoImage:Refresh()
return nil
/*_____________________________________________________________________________*/

function SoForm( oBrw, cModo, oCont, cContTitle )

   local oDlg
   local oFld
   local aSay        := array(15)
   local aGet        := array(25)
   local aBtn        := array(13)
   local aBmp        := array(02)
   local oBtnBmp
   local oBtnImg

   local cCaption    := ""
   local lIdOk       := .f.
   local nRecBrw     := SO->( recNo() )
   local nRecAdd     := 0
   local lPrestado   := .f.
   local lPresEdit   := .t.

   local cSoCodigo   := ""
   local cSoTitulo   := ""
   local cSoMateria  := ""
   local cSoIdioma   := ""
   local cSoEditor   := ""
   local cSoPropiet  := ""
   local cSoNumSer   := ""
   local nSoPrecio   := 0
   local dSoFchComp  := date()
   local cSoProveed  := ""
   local mSoDescri
   local cSoGuardado := ""
   local cSoNomDir   := ""
   local lSoDos      := .F.
   local lSoWin31    := .F.
   local lSoWin95    := .F.
   local lSoDemo     := .F.
   local lSoDiscos   := .F.
   local nSoNumDisk  := 0
   local nSoEntorno  := 0
   local lSoCD       := .F.
   local cSoUbicaci  := ""
   local cSoPrestad  := ""
   local dSoFecha    := date()
   local cSoImagen   := ""
   local cSoResumen  := ""

   if cModo == "edt" .or. cModo == "dup"
      if SoDbfVacia()
         retu NIL
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if SO->( eof() ) .and. cModo != "add"
      retu NIL
   endif

   oApp():nEdit++

   cModo := lower( cModo )

   do case
      // nuevo
      case cModo == "add"
         cCaption := i18n( "Añadir un Software" )
         SO->( dbAppend() )
         replace SO->SoEntorno6 with 2
         SO->( dbCommit() )
         nRecAdd := SO->( recNo() )
      // modificar
      case cModo == "edt"
         cCaption := i18n( "Modificar un Software" )
      // duplicar
      case cModo == "dup"
         cCaption := i18n( "Duplicar un Software" )
   end case

   // ambos casos
   cSoCodigo   := SO->SoCodigo
   cSoTitulo   := SO->SoTitulo
   cSoMateria  := SO->SoMateria
   cSoIdioma   := SO->SoIdioma
   cSoEditor   := SO->SoEditor
   cSoPropiet  := SO->SoPropiet
   cSoNumSer   := SO->SoNumSer
   nSoPrecio   := SO->SoPrecio
   dSoFchComp  := SO->SoFchComp
   cSoProveed  := SO->SoProveed
   mSoDescri   := SO->SoDescri
   cSoGuardado := SO->SoGuardado
   nSoEntorno  := SO->SoEntorno6
   lSoDemo     := SO->SoDemo
   lSoDiscos   := SO->SoDiscos
   nSoNumDisk  := SO->SoNumDisk
   lSoCD       := SO->SoCD
   cSoUbicaci  := SO->SoUbicaci
   cSoNomDir   := SO->SoNomDir
   cSoPrestad  := SO->SoPrestad
   dSoFecha    := SO->SoFecha
   cSoImagen   := SO->SoImagen
   cSoResumen  := SO->SoResumen

   do case
      case cModo == "add" .and. oApp():lCodAut
         GetNewCod( .f., "SO", "SoCodigo", @cSoCodigo )
      case cModo == "dup"
         if oApp():lCodAut
            GetNewCod( .f., "SO", "SoCodigo", @cSoCodigo )
         else
            cSoCodigo := space( 10 )
         endif
   end case

   lPresEdit := if( cModo == "edt", ( empty( cSoPrestad ) .or. dSoFecha == cTOd( "" ) ), .t. )

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "SO_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)
   // Diálogo principal

   REDEFINE GET aGet[01] ;
      VAR cSoTitulo ;
      ID 100 ;
      OF oDlg ;
      WHEN ( lPresEdit )

   REDEFINE GET aGet[02] ;
      VAR cSoCodigo ;
      ID 101 ;
      OF oDlg ;
      WHEN ( lPresEdit ) ;
      VALID ( SoClave( cSoCodigo, aGet[02], cModo ) )

   REDEFINE BUTTON aBtn[01];
      ID 109;
      OF oDlg;
      WHEN ( lPresEdit );
      ACTION ( GetNewCod( .t., "SO", "SoCodigo", @cSoCodigo ), aGet[02]:refresh(), aGet[02]:setFocus() )

      aBtn[01]:cToolTip := i18n( "generar código autonumérico" )

   REDEFINE AUTOGET aGet[03] 	;
      VAR cSoMateria          ;
      DATASOURCE {}						;
      FILTER MaListS( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 102                  ;
      OF oDlg                 ;
      VALID ( MaClave( @cSoMateria, aGet[03], "aux", "S" ) )

   REDEFINE BUTTON aBtn[02];
      ID 110;
      OF oDlg;
      ACTION ( MaTabAux( @cSoMateria, aGet[03], "S" ),;
               aGet[03]:setFocus(),;
               SysRefresh() )

      aBtn[02]:cToolTip := i18n( "selecc. materia" )

   REDEFINE AUTOGET aGet[04] 	;
      VAR cSoIdioma           ;
      DATASOURCE {}						;
      FILTER IdList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 103                  ;
      OF oDlg ;
      VALID ( IdClave( @cSoIdioma, aGet[04], "aux" ) )

   REDEFINE BUTTON aBtn[03];
      ID 111;
      OF oDlg;
      ACTION ( IdTabAux( @cSoIdioma, aGet[04] ),;
               aGet[04]:setFocus(),;
               SysRefresh() )
      aBtn[03]:cToolTip := i18n( "selecc. idioma" )

   REDEFINE AUTOGET aGet[05] 	;
      VAR cSoPropiet          ;
      DATASOURCE {}						;
      FILTER AgListP( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 104                  ;
      OF oDlg                 ;
      VALID ( AgClave( @cSoPropiet, aGet[05], "aux", "P" ) )

   REDEFINE BUTTON aBtn[04];
      ID 112;
      OF oDlg;
      ACTION ( AgTabAux( @cSoPropiet, aGet[05], "P" ),;
               aGet[05]:setFocus(),;
               SysRefresh() )
      aBtn[04]:cToolTip := i18n( "selecc. propietario" )

   REDEFINE AUTOGET aGet[06] 	;
      VAR cSoGuardado         ;
      DATASOURCE {}						;
      FILTER UbListS( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 105                  ;
      OF oDlg                 ;
      VALID ( UbClave( @cSoGuardado, aGet[06], "aux", "S" ) )

   REDEFINE BUTTON aBtn[05];
      ID 113;
      OF oDlg;
      ACTION ( UbTabAux( @cSoGuardado, aGet[06], "S" ),;
               aGet[06]:setFocus(),;
               SysRefresh() )

      aBtn[05]:cToolTip := i18n( "selecc. ubicación" )

   REDEFINE ximage aGet[24] FILE "" ID 117 OF oDlg //SCROLL

   if File(lfn2sfn(rtrim(cSoImagen)))
      aGet[24]:SetSource(lfn2sfn(rtrim(cSoImagen)))
   endif

   REDEFINE FOLDER oFld ;
      ID 106 ;
      OF oDlg ;
      ITEMS i18n("&Edición"), i18n("&Soporte"), i18n("&Observaciones"), i18n("&Imagen"), i18n("Co&mpra"), i18n("&Préstamo") ;
      DIALOGS "SO_FORM_A", "SO_FORM_B", "SO_FORM_C", "SO_FORM_D", "SO_FORM_E", "SO_FORM_F"

   // Primer folder: datos de edición

   REDEFINE SAY aSay[01] ID 200 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[03] ID 202 OF oFld:aDialogs[1]

   REDEFINE AUTOGET aGet[07]  ;
      VAR cSoEditor           ;
      DATASOURCE {}						;
      FILTER EdListS( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[1]     ;
      VALID ( EdClave( @cSoEditor, aGet[07], "aux", "S" ) )

   REDEFINE BUTTON aBtn[06];
      ID 108;
      OF oFld:aDialogs[1];
      ACTION ( EdTabAux( @cSoEditor, aGet[07], "S" ),;
               aGet[07]:setFocus(),;
               SysRefresh() )

      aBtn[06]:cToolTip := i18n( "selecc. compañía" )

   REDEFINE GET aGet[08] ;
      VAR cSoNumSer ;
      ID 101 ;
      OF oFld:aDialogs[1]

   REDEFINE RADIO aGet[09] ;
      VAR nSoEntorno ;
      ID 102, 103, 104, 105, 106 ;
      OF oFld:aDialogs[1]

   REDEFINE CHECKBOX aGet[10] ;
      VAR lSoDemo ;
      ID 107 ;
      OF oFld:aDialogs[1]

   // Segundo folder: datos de soporte

   REDEFINE SAY aSay[04] ID 200 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[05] ID 201 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[06] ID 202 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[07] ID 203 OF oFld:aDialogs[2]

   REDEFINE CHECKBOX aGet[11] ;
      VAR lSoDiscos ;
      ID 100 ;
      OF oFld:aDialogs[2]

   REDEFINE GET aGet[12] ;
      VAR nSoNumDisk ;
      ID 101 ;
      OF oFld:aDialogs[2] ;
      WHEN lSoDiscos

   REDEFINE CHECKBOX aGet[13] ;
      VAR lSoCD ;
      ID 102 ;
      OF oFld:aDialogs[2]

   REDEFINE GET aGet[14] ;
      VAR cSoUbicaci ;
      ID 103 ;
      OF oFld:aDialogs[2] ;
      WHEN lSoCD

   REDEFINE GET aGet[15] ;
      VAR cSoNomDir ;
      ID 104 ;
      OF oFld:aDialogs[2] ;
      WHEN lSoCD

   // Tercer folder: datos de observaciones

   REDEFINE SAY aSay[08] ID 200 OF oFld:aDialogs[3]
   REDEFINE SAY aSay[15] ID 201 OF oFld:aDialogs[3]

   REDEFINE GET aGet[16] ;
      VAR mSoDescri ;
      ID 100 ;
      OF oFld:aDialogs[3] ;
      MEMO

   REDEFINE GET aGet[25] var cSoResumen       ;
      ID 101 OF oFld:aDialogs[3] UPDATE      
   REDEFINE BUTTON aBtn[12]                  ;
      ID 102 OF oFld:aDialogs[3] UPDATE      ;
      ACTION aGet[25]:cText := cGetFile32('*.*','indique la ubicación del resumen',,,,.T.) 
   aBtn[12]:cTooltip := "seleccionar fichero"
   REDEFINE BUTTON aBtn[13]                  ;
      ID 103 OF oFld:aDialogs[3] UPDATE      ;
      ACTION GoFile( cSoResumen )            
   aBtn[13]:cTooltip := "ejecutar fichero"

   // Cuarto folder: datos de imagen

   REDEFINE SAY aSay[09] ID 200 OF oFld:aDialogs[4]

   REDEFINE GET aGet[17] ;
      VAR cSoImagen ;
      ID 100 ;
      OF oFld:aDialogs[4] ;
      VALID ( aGet[18]:SetSource( , cSoImagen ), aGet[18]:refresh(),;
              aGet[24]:SetSource( , cSoImagen ), aGet[24]:refresh(), .t. )

   REDEFINE BUTTON aBtn[07];
      ID 103;
      OF oFld:aDialogs[4];
      ACTION ( SoGetImagen( aGet[18], aGet[24], aGet[17], oBtnImg ) )

      aBtn[07]:cToolTip := i18n( "selecc. imagen" )

   REDEFINE ximage aGet[18] FILE "" ID 101 OF oFld:aDialogs[4] //SCROLL

   aGet[18]:SetColor( CLR_RED, CLR_WHITE )

   if File(lfn2sfn(rtrim(cSoImagen)))
      aGet[18]:SetSource(lfn2sfn(rtrim(cSoImagen)))
   endif

   REDEFINE BUTTON oBtnImg ;
      ID 102 ;
      OF oFld:aDialogs[4] ;
      ACTION Soximagen( cSoImagen, cSoTitulo )

   // Quinto folder: datos de compra

   REDEFINE SAY aSay[10] ID 200 OF oFld:aDialogs[5]
   REDEFINE SAY aSay[11] ID 201 OF oFld:aDialogs[5]
   REDEFINE SAY aSay[12] ID 202 OF oFld:aDialogs[5]

   REDEFINE AUTOGET aGet[19] 	;
      VAR cSoProveed          ;
      DATASOURCE {}						;
      FILTER CcList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[5]     ;
      VALID ( CcClave( @cSoProveed, aGet[19], "aux", "O" ) )

   REDEFINE BUTTON aBtn[08];
      ID 103;
      OF oFld:aDialogs[5];
      ACTION ( CcTabAux( @cSoProveed, aGet[19], "O" ),;
               aGet[19]:setFocus(),;
               SysRefresh() )
   aBtn[08]:cToolTip := i18n( "selecc. centro de compra" )

   REDEFINE GET aGet[20] ;
      VAR dSoFchComp ;
      ID 101 ;
      OF oFld:aDialogs[5]

   REDEFINE BUTTON aBtn[09];
      ID 104;
      OF oFld:aDialogs[5];
      ACTION ( SelecFecha( dSoFchComp, aGet[20] ),;
               aGet[20]:setFocus(),;
               SysRefresh() )

      aBtn[09]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[21] ;
      VAR nSoPrecio ;
      ID 102 ;
      OF oFld:aDialogs[5] ;
      PICTURE "@E 999,999.99"

   // Sexto folder: datos de préstamo

   REDEFINE SAY aSay[13] ID 200 OF oFld:aDialogs[6]
   REDEFINE SAY aSay[14] ID 201 OF oFld:aDialogs[6]

   REDEFINE AUTOGET aGet[22]  ;
      VAR cSoPrestad          ;
      DATASOURCE {}						;
      FILTER AgListC( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[6]     ;
      VALID ( AgClave( @cSoPrestad, aGet[22], "aux", "C" ) )

   REDEFINE BUTTON aBtn[10];
      ID 103;
      OF oFld:aDialogs[6];
      ACTION ( AgTabAux( @cSoPrestad, aGet[22], "C" ),;
               aGet[22]:setFocus(),;
               SysRefresh() )

      aBtn[10]:cToolTip := i18n( "selecc. prestatario" )

   REDEFINE BUTTON ;
      ID 101 ;
      OF oFld:aDialogs[6] ;
      WHEN ( !empty( cSoPrestad ) .or. dSoFecha != cTOd( "" ) ) ;
      ACTION ( iif( msgYesNo( i18n("¿Desea anotar la devolución del software?") ),;
                     ( cSoPrestad := space( 30 ),;
                       aGet[22]:refresh(),;
                       dSoFecha   := cTOd( "" ),;
                       aGet[23]:refresh(),;
                       aBmp[02]:reload( "16_pres_off" ),;
                       aBmp[02]:refresh(),;
                       SysRefresh() ), ), aGet[22]:setFocus() )

   REDEFINE GET aGet[23] ;
      VAR dSoFecha ;
      ID 102 ;
      OF oFld:aDialogs[6]

   REDEFINE BUTTON aBtn[11];
      ID 104;
      OF oFld:aDialogs[6];
      ACTION ( SelecFecha( dSoFecha, aGet[23] ),;
               aGet[23]:setFocus(),;
               SysRefresh() )

      aBtn[11]:cToolTip := i18n( "selecc. fecha" )

   // Diálogo principal

   // REDEFINE BITMAP aBmp[01] ID 107 OF oDlg RESOURCE "CLIP_OFF" TRANSPARENT
	//	aEval( aGet, { |oGet| oGet:bChange := { || ( aBmp[01]:reload( "CLIP_ON" ), aBmp[01]:refresh() ) } } )
   REDEFINE BITMAP aBmp[02] ID 108 OF oDlg RESOURCE "16_pres_off" TRANSPARENT

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
		ON INIT ( oDlg:Center( oApp():oWndMain ), Iif( !empty( cSoPrestad ) .or. dSoFecha != cTOd( "" ),;
                 ( aBmp[02]:reload( "16_pres_on"  ), aBmp[02]:refresh() ),;
                 ( aBmp[02]:reload( "16_pres_off" ), aBmp[02]:refresh() ) ) )

   do case
      // nuevo
      case cModo == "add"
         // aceptar
         if lIdOk == .T.
            // alta del software
            SO->( dbGoTo( nRecAdd ) )
            replace SO->SoCodigo   with cSoCodigo
            replace SO->SoTitulo   with cSoTitulo
            replace SO->SoMateria  with cSoMateria
            replace SO->SoIdioma   with cSoIdioma
            replace SO->SoPropiet  with cSoPropiet
            replace SO->SoEditor   with cSoEditor
            replace SO->SoNumSer   with cSoNumSer
            replace SO->SoPrecio   with nSoPrecio
            replace SO->SoDescri   with mSoDescri
            replace SO->SoGuardado with cSoGuardado
            replace SO->SoEntorno6 with nSoEntorno
            replace SO->SoDemo     with lSoDemo
            replace SO->SoDiscos   with lSoDiscos
            replace SO->SoNumDisk  with nSoNumDisk
            replace SO->SoCD       with lSoCD
            replace SO->SoUbicaci  with cSoUbicaci
            replace SO->SoNomDir   with cSoNomDir
            replace SO->SoPrestad  with cSoPrestad
            replace SO->SoFecha    with dSoFecha
            replace SO->SoFchComp  with dSoFchComp
            replace SO->SoProveed  with cSoProveed
            replace SO->SoImagen   with cSoImagen
            replace SO->SoResumen  with cSoResumen
            SO->( dbCommit() )
            nRecBrw := SO->( recNo() )
            // incremento del nº de ejemplares en materias
            if MA->( dbSeek( "S" + upper( cSoMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               MA->( dbCommit() )
            endif
            // incremento del nº de ejemplares en ubicaciones
            if UB->( dbSeek( "S" + upper( cSoGuardado ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif
            // anotación del préstamo (si es necesario)
            if IsPrestado( "SO" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 4
               replace NO->NoCodigo  with SO->SoCodigo
               replace NO->NoFecha   with SO->SoFecha
               replace NO->NoTitulo  with SO->SoTitulo
               replace NO->NoAQuien  with SO->SoPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo" ) )
                     SoImprimirJustif()
               endif
            endif
         // cancelar
         else
            SO->( dbGoTo( nRecAdd ) )
            SO->( dbDelete() )
         endif
      // modificar
      case cModo == "edt"
         // aceptar
         if lIdOk == .T.
            // modificación del préstamo (si es necesario)
            do case
               // acaba de anotarse el préstamo
               case !IsPrestado( "SO" ) .and. ( !empty( cSoPrestad ) .or. dSoFecha != cTOd( "" ) )
                  NO->( dbAppend() )
                  replace NO->NoTipo    with 4
                  replace NO->NoCodigo  with cSoCodigo
                  replace NO->NoFecha   with dSoFecha
                  replace NO->NoTitulo  with cSoTitulo
                  replace NO->NoAQuien  with cSoPrestad
                  NO->( dbCommit() )
                  lPrestado := .T.
               // estaba y sigue estando prestado
               case IsPrestado( "SO" ) .and. ( !empty( cSoPrestad ) .or. dSoFecha != cTOd( "" ) )
                  if NO->( dbSeek( "4" + cSoCodigo ) )
                     replace NO->NoFecha   with dSoFecha
                     replace NO->NoAQuien  with cSoPrestad
                     NO->( dbCommit() )
                  endif
               // estaba pero ya no está prestado
               case IsPrestado( "SO" ) .and. ( empty( cSoPrestad ) .and. dSoFecha == cTOd( "" ) )
                  if NO->( dbSeek( "4" + SO->SoCodigo ) )
                     NO->( dbDelete() )
                  endif
                  NO->( dbCommit() )
            end case
            // modificación del nº de ejemplares en materias
            if ( SO->SoMateria != cSoMateria )
               do case
                  case ( MA->( dbSeek( "S" + upper( SO->SoMateria ) ) ) )
                     MA->( dbSeek( "S" + upper( cSoMateria ) ) ) // ¿sobra?
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
                     MA->( dbSeek( "S" + upper( SO->SoMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
                     MA->( dbCommit() )
                  case ( empty( SO->SoMateria ) )
                     MA->( dbSeek( "S" + upper( cSoMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               end case
            endif
            // modificación del nº de ejemplares en ubicaciones
            if ( SO->SoGuardado != cSoGuardado )
               do case
                  case ( UB->( dbSeek( "S" + upper( SO->SoGuardado ) ) ) )
                     UB->( dbSeek( "S" + upper( cSoGuardado ) ) ) // ¿sobra?
                     replace UB->UbItems with ( UB->UbItems ) + 1
                     UB->( dbSeek( "S" + upper( SO->SoGuardado ) ) )
                     replace UB->UbItems with ( UB->UbItems ) - 1
                     UB->( dbCommit() )
                  case ( empty( SO->SoGuardado ) )
                     UB->( dbSeek( "S" + upper( cSoGuardado ) ) )
                     replace UB->UbItems with ( UB->UbItems ) + 1
               end case
            endif
            // modificación del software
            SO->( dbGoTo( nRecBrw ) )
            replace SO->SoCodigo   with cSoCodigo
            replace SO->SoTitulo   with cSoTitulo
            replace SO->SoMateria  with cSoMateria
            replace SO->SoIdioma   with cSoIdioma
            replace SO->SoPropiet  with cSoPropiet
            replace SO->SoEditor   with cSoEditor
            replace SO->SoNumSer   with cSoNumSer
            replace SO->SoPrecio   with nSoPrecio
            replace SO->SoDescri   with mSoDescri
            replace SO->SoGuardado with cSoGuardado
            replace SO->SoEntorno6 with nSoEntorno
            replace SO->SoDemo     with lSoDemo
            replace SO->SoDiscos   with lSoDiscos
            replace SO->SoNumDisk  with nSoNumDisk
            replace SO->SoCD       with lSoCD
            replace SO->SoUbicaci  with cSoUbicaci
            replace SO->SoNomDir   with cSoNomDir
            replace SO->SoPrestad  with cSoPrestad
            replace SO->SoFecha    with dSoFecha
            replace SO->SoFchComp  with dSoFchComp
            replace SO->SoProveed  with cSoProveed
            replace SO->SoImagen   with cSoImagen
            replace SO->SoResumen  with cSoResumen
            SO->( dbCommit() )
            // impresión del justificante de préstamo (si es necesario)
            if lPrestado
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  SoImprimirJustif()
               endif
            endif
         endif
      // nuevo
      case cModo == "dup"
         // aceptar
         if lIdOk == .T.
            // duplicado del software
            SO->( dbAppend() )
            replace SO->SoCodigo   with cSoCodigo
            replace SO->SoTitulo   with cSoTitulo
            replace SO->SoMateria  with cSoMateria
            replace SO->SoIdioma   with cSoIdioma
            replace SO->SoPropiet  with cSoPropiet
            replace SO->SoEditor   with cSoEditor
            replace SO->SoNumSer   with cSoNumSer
            replace SO->SoPrecio   with nSoPrecio
            replace SO->SoDescri   with mSoDescri
            replace SO->SoGuardado with cSoGuardado
            replace SO->SoEntorno6 with nSoEntorno
            replace SO->SoDemo     with lSoDemo
            replace SO->SoDiscos   with lSoDiscos
            replace SO->SoNumDisk  with nSoNumDisk
            replace SO->SoCD       with lSoCD
            replace SO->SoUbicaci  with cSoUbicaci
            replace SO->SoNomDir   with cSoNomDir
            replace SO->SoPrestad  with cSoPrestad
            replace SO->SoFecha    with dSoFecha
            replace SO->SoFchComp  with dSoFchComp
            replace SO->SoProveed  with cSoProveed
            replace SO->SoImagen   with cSoImagen
            replace SO->SoResumen  with cSoResumen
            SO->( dbCommit() )
            nRecBrw := SO->( recNo() )
            // incremento del nº de ejemplares en materias
            if MA->( dbSeek( "S" + upper( cSoMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               MA->( dbCommit() )
            endif
            // incremento del nº de ejemplares en ubicaciones
            if UB->( dbSeek( "S" + upper( cSoGuardado ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif
            // anotación del préstamo (si es necesario)
            if IsPrestado( "SO" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 4
               replace NO->NoCodigo  with SO->SoCodigo
               replace NO->NoFecha   with SO->SoFecha
               replace NO->NoTitulo  with SO->SoTitulo
               replace NO->NoAQuien  with SO->SoPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo" ) )
                     SoImprimirJustif()
               endif
            endif
         endif
   end case

   SO->( dbGoTo( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "SO", cContTitle )
		RefreshSoImage()
   endif
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return NIL

/*_____________________________________________________________________________*/

function SoBorrar( oBrw, oCont, cContTitle )

   local nRecord := SO->( recNo() )
   local nNext

   if SoDbfVacia()
      return NIL
   endif

   if IsPrestado( "SO" )
      msgStop( i18n( "No se puede eliminar software prestado." ) )
      return NIL
   endif

   if msgYesNo( i18n( "¿Está seguro de querer borrar este software?" + CRLF + CRLF ;
   + trim( SO->SoTitulo ) ) )
      SO->( dbSkip() )
      nNext := SO->( recNo() )
      SO->( dbGoto( nRecord ) )
      if MA->( dbSeek( "S" + upper( SO->SoMateria ) ) )
         replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
      endif
      if UB->( dbSeek( "S" + upper( SO->SoGuardado ) ) )
         replace UB->UbItems with ( UB->UbItems ) - 1
      endif
      SO->( dbDelete() )
      SO->( dbGoto( nNext ) )
      if SO->( eof() ) .or. nNext == nRecord
         SO->( dbGoBottom() )
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "SO", cContTitle )
		RefreshSoImage()
   endif
   oBrw:refresh()
   oBrw:setFocus()

return NIL

/*_____________________________________________________________________________*/

function SoBuscar( oBrw, oCont, nTabOpc, cChr, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local nRecNo   := SO->( recNo() )
   local lIdOk    := .f.
   local lFecha   := .f.
   local aBrowse  := {}

   if SoDbfVacia()
      return NIL
   endif

   oApp():nEdit++

   switch nTabOpc
      case 1
         cPrompt := i18n( "Introduzca el Nombre del Software" )
         cField  := i18n( "Nombre:" )
         cGet    := space( 60 )
         exit
      case 2
         cPrompt := i18n( "Introduzca el Código del Software" )
         cField  := i18n( "Código:" )
         cGet    := space( 10 )
         exit
      case 3
         cPrompt := i18n( "Introduzca la Materia del Software" )
         cField  := i18n( "Materia:" )
         cGet    := space( 30 )
         exit
      case 4
         cPrompt := i18n( "Introduzca el Propietario del Software" )
         cField  := i18n( "Propietario:" )
         cGet    := space( 40 )
         exit
      case 5
         cPrompt := i18n( "Introduzca la Ubicación del Software" )
         cField  := i18n( "Ubicación:" )
         cGet    := space( 60 )
         exit
      case 6
         cPrompt := i18n( "Introduzca la Compañía del Software" )
         cField  := i18n( "Compañia:" )
         cGet    := space( 40 )
         exit
      case 7
         cPrompt := i18n( "Introduzca la Fecha de Compra del Software" )
         cField  := i18n( "Fch. Compra:" )
         cGet    := cTOd( "" )
         exit
      case 8
         cPrompt := i18n( "Introduzca la Fecha de Préstamo del Software" )
         cField  := i18n( "Fch. Préstamo:" )
         cGet    := cTOd( "" )
         exit
   end switch

   lFecha := valType( cGet ) == "D"

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Software" )
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
            { || SoWildSeek(nTabOpc, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ningún software."))
      else
         SoEncontrados(aBrowse, oApp():oDlg)
      endif
   endif
   SoTabs( oBrw, nTabOpc, oCont, cContTitle)
   RefreshCont( oCont, "SO", cContTitle )
	RefreshSoImage()
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return NIL
/*_____________________________________________________________________________*/
function SoWildSeek(nTabOpc, cGet, aBrowse)
   local nRecno   := SO->(Recno())

   do case
      case nTabOpc == 1
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ upper(SO->SoTitulo)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
      case nTabOpc == 2
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ upper(SO->SoCodigo)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
      case nTabOpc == 3
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ upper(SO->SoMateria)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
      case nTabOpc == 4
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ upper(SO->SoPropiet)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
      case nTabOpc == 5
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ upper(SO->SoUbicaci)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
      case nTabOpc == 6
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ upper(SO->SoEditor)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
      case nTabOpc == 7
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ dTOS(SO->SoFchComp)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
      case nTabOpc == 8
         SO->(DbGoTop())
         do while ! SO->(eof())
            if cGet $ dTOs(SO->SoFecha)
               aadd(aBrowse, {SO->SoTitulo, SO->SoMateria, SubStr(SO->SoDescri,1,30), SO->(RecNo())})
            endif
            SO->(DbSkip())
         enddo
   end case
   SO->(DbGoTo(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[1]) < upper(aAut2[1]) } )
return nil
/*_____________________________________________________________________________*/
function SoEncontrados(aBrowse, oParent)
   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := SO->(Recno())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .f.)
   oBrowse:aCols[1]:cHeader := "Nombre"
   oBrowse:aCols[2]:cHeader := "Materia"
   oBrowse:aCols[3]:cHeader := "Descripción"
   oBrowse:aCols[1]:nWidth  := 160
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:nWidth  := 240
   oBrowse:aCols[4]:lHide   := .t.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   SO->(OrdSetFocus("titulo"))
   SO->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1])))
   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||SO->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                           SoForm(oBrowse,"edt",,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(SO->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                     SoForm(oBrowse,"edt",,oDlg)),) }
   oBrowse:bChange    := { || SO->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (SO->(DbGoTo(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

return nil

/*_____________________________________________________________________________*/

function SoTabs( oBrw, nOpc, oCont, cContTitle )

   switch nOpc
      case 1
         SO->( ordSetFocus( "titulo" ) )
         exit
      case 2
         SO->( ordSetFocus( "codigo" ) )
         exit
      case 3
         SO->( ordSetFocus( "materia" ) )
         exit
      case 4
         SO->( ordSetFocus( "propietario" ) )
         exit
      case 5
         SO->( ordSetFocus( "ubicacion" ) )
         exit
      case 6
         SO->( ordSetFocus( "editor" ) )
         exit
      case 7
         SO->( ordSetFocus( "fchcompra" ) )
         exit
      case 8
         SO->( ordSetFocus( "fchprestamo" ) )
         exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "SO", cContTitle )

return NIL

/*_____________________________________________________________________________*/

function SoTeclas( nKey, oBrw, oCont, nTabOpc, oDlg, cContTitle )

   switch nKey
      case VK_INSERT
         SoForm( oBrw, "add", oCont, cContTitle )
         exit
      case VK_RETURN
         SoForm( oBrw, "edt", oCont, cContTitle )
         exit
      case VK_DELETE
         SoBorrar( oBrw, oCont, cContTitle )
         exit
      case VK_ESCAPE
         oDlg:End()
         exit
      otherwise
         if nKey >= 97 .and. nKey <= 122
            nKey := nKey - 32
         endif
         if nKey >= 65 .and. nKey <= 90
            SoBuscar( oBrw, oCont, nTabOpc, chr( nKey ), cContTitle )
         endif
         exit
   end switch

return NIL

/*_____________________________________________________________________________*/

function SoImprimirJustif()

   local nRec    := SO->( recNo() )
   local oInforme

   oInforme := TInforme():New( {}, {}, {}, {}, {}, {}, "SO" )

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(SO->SoTitulo)
   oInforme:cTitulo2 := Rtrim("Justificante de préstamo de la aplicación")
   oInforme:nDevice := 1

   // oInforme:cTitulo2 := "Año: "+cAnyo
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

   ACTIVATE REPORT oInforme:oReport FOR SO->( recNo() ) == nRec ;
      ON INIT SoImprimirJustif2( oInforme:oReport, nRec )

   SO->( dbGoTo( nRec ) )

return NIL

/*_____________________________________________________________________________*/

function SoImprimirJustif2( oReport, nRec )

   SO->( dbGoTo( nRec ) )

   oReport:StartLine()
   oReport:Say( 1, i18n("Código:"), 1 )
   oReport:Say( 2, SO->SoCodigo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Nombre:"), 1 )
   oReport:Say( 2, SO->SoTitulo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, "", 1 )
   oReport:Say( 2, "", 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, "", 1 )
   oReport:Say( 2, "", 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Propietario:"), 1 )
   oReport:Say( 2, SO->SoPropiet       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fecha de Compra:"), 1 )
   oReport:Say( 2, SO->SoFchComp           , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Este software ha sido objeto del siguiente préstamo:"), 2 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Prestatario:"), 1 )
   oReport:Say( 2, SO->SoPrestad       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fecha de Préstamo:"), 1 )
   oReport:Say( 2, SO->SoFecha               , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Firma del Prestatario:"), 2 )
   oReport:EndLine()

return NIL

/*_____________________________________________________________________________*/

function SoDevolver()

   if SoDbfVacia()
      return NIL
   endif

   if !IsPrestado( "SO" )
      msgStop( i18n( "El software seleccionado no está prestado." ) )
      return NIL
   endif

   if msgYesNo( i18n( "¿Desea anotar la devolución de este software?" ) + CRLF + CRLF + ;
                i18n( trim( SO->SoTitulo ) ) )
      if NO->( dbSeek( "4" + SO->SoCodigo ) )
         replace SO->SoPrestad with ""
         replace SO->SoFecha   with cTOd( "" )
         SO->( dbCommit() )
         NO->( dbDelete() )
         NO->( dbCommit() )
      else
         msgAlert( i18n( "No se encontró el software seleccionado en el fichero de préstamos. Por favor reindexe los ficheros." ) )
      endif
   endif

return NIL

/*_____________________________________________________________________________*/

function SoGetImagen( oImage1, oImage2, oGet, oBtn )

   local cImageFile

   cImageFile := cGetfile32( i18n("Archivos de imagen") + " (bmp,jpg,gif,png,dig,pcx,tga,rle) | *.bmp;*.jpg;*.gif;*.png;*.dig;*.pcx;*.tga;*.rle |",;
                             i18n("Indica la ubicación de la imagen"),,,, .t. )

   if ! empty(cImageFile) .and. File(lfn2sfn(rtrim(cImageFile)))
      oImage1:SetSource(lfn2sfn(rtrim(cImageFile)))
      oImage2:SetSource(lfn2sfn(rtrim(cImageFile)))
      oGet:cText := cImageFile
      oBtn:Refresh()
   endif

return NIL

/*_____________________________________________________________________________*/

function Soximagen( cImagen, cTitulo )

   local oDlg
   local oImage

   if SoDbfVacia()
      return NIL
   endif

   if empty( rTrim( cImagen ) )
      msgInfo( i18n( "El software no tiene asociada ninguna imagen." ) )
      return NIL
   endif

   if ! file( lfn2sfn( rTrim( cImagen ) ) )
      msgInfo( i18n( "No existe el fichero de imagen asociado al software." ) + " " + ;
              i18n( "Por favor revise la ruta y el nombre del fichero." ) )
      return NIL
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

return NIL

/*_____________________________________________________________________________*/

function SoClave( cClave, oGet, cModo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "SO"
   local cMsgSi  := i18n( "Código de software ya registrado." )
   local cMsgNo  := i18n( "Código de software no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
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

function SoImprimir( oBrw )
   local aInf := { { i18n("Código"         ), "SOCODIGO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Nombre"         ), "SOTITULO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Descripción"    ), "SODESCRI"  , 40, .t.,            "NO", .f. },;
                   { i18n("Materia"        ), "SOMATERIA" ,  0, .t.,            "NO", .f. },;
                   { i18n("Idioma"         ), "SOIDIOMA"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Propietario"    ), "SOPROPIET" ,  0, .t.,            "NO", .f. },;
                   { i18n("Ubicación"      ), "SOGUARDADO",  0, .t.,            "NO", .f. },;
                   { i18n("Compañía"       ), "SOEDITOR"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Nº Serie"       ), "SONUMSER"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Entorno"        ), "SOENTORNO6", 10, .t.,          "SO01", .f. },;
                   { i18n("Demo"           ), "SODEMO"    ,  5, .t.,          "SO02", .f. },;
                   { i18n("Disquette"      ), "SODISCOS"  ,  8, .t.,          "SO03", .f. },;
                   { i18n("CD"             ), "SOCD"      ,  3, .t.,          "SO04", .f. },;
                   { i18n("Título CD"      ), "SOUBICACI" ,  0, .t.,            "NO", .f. },;
                   { i18n("Dir./Nombre CD" ), "SONOMDIR"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Fch.Compra"     ), "SOFCHCOMP" ,  0, .t.,            "NO", .f. },;
                   { i18n("Centro Compra"  ), "SOPROVEED" ,  0, .t.,            "NO", .f. },;
                   { i18n("Precio"         ), "SOPRECIO"  ,  0, .t., "@E 999,999.99", .t. },;
                   { i18n("Fch.Préstamo"   ), "SOFECHA"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Prestatario"    ), "SOPRESTAD" ,  0, .t.,            "NO", .f. } }

   local nRecno   := SO->(Recno())
   local nOrder   := SO->(OrdSetFocus())
   local aCampos  := { "SOCODIGO", "SOTITULO", "SODESCRI", "SOMATERIA", "SOIDIOMA",;
                       "SOPROPIET", "SOGUARDADO", "SOEDITOR", "SONUMSER", "SOENTORNO6",;
                       "SODEMO", "SODISCOS", "SOCD", "SOUBICACI", "SONOMDIR",;
                       "SOFCHCOMP", "SOPROVEED", "SOPRECIO", "SOFECHA", "SOPRESTAD" }
   local aTitulos := { "Código", "Nombre", "Descripción", "Materia", "Idioma",;
                       "Propietario", "Ubicación", "Compañía", "Nº Serie", "Entorno",;
                       "Demo", "Disquette", "CD", "Título CD", "Dir./Nombre CD",;
                        "Fch.Compra", "Centro Compra", "Precio", "Fch.Préstamo", "Prestatario" }
   local aWidth   := { 10, 20, 20, 10, 10, 10, 10, 10, 10, 10,;
                       10, 10, 10, 10, 10, 10, 10, 10, 10, 10 }
   local aShow    := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t.,;
                       .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "SO01",;
                       "SO02", "SO03", "SO04", "NO","NO", "NO", "NO", "@E 999,999.99", "NO", "NO" }
   local aTotal   := { .f., .f., .f., .f., .f., .f., .f., .f., .f., .f.,;
                       .f., .f., .f., .f., .f., .f., .f., .t., .f., .f. }
   local oInforme
   local nAt
   local cAlias   := "SO"
   local cTotal   := "Total software: "
   local aGet     := array(8)
   local aSay     := array(2)
   local aBtn     := array(2)

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

   local aEd      := {}
   local cEd      := ""
   local nEdOrd   := ED->( ordNumber() )
   local nEdRec   := ED->( recNo() )

   local dFch1    := cTOd( "" )
   local dFch2    := date()
   local lImg     := .f.

   if SoDbfVacia()
      retu NIL
   endif

   oApp():nEdit++

   SELECT SO  // imprescindible

   FillCmb( "MA", "smateria"    , aMa, "MaMateria", nMaOrd, nMaRec, @cMa )
   FillCmb( "AG", "propietarios", aPr, "PeNombre" , nPrOrd, nPrRec, @cPr )
   FillCmb( "UB", "subicacion"  , aUb, "UbUbicaci", nUbOrd, nUbRec, @cUb )
   FillCmb( "ED", "edsoftware"  , aEd, "EdNombre" , nEdOrd, nEdRec, @cEd )

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   REDEFINE SAY aSay[01] ID 200 OF oInforme:oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oInforme:oFld:aDialogs[1]

   REDEFINE RADIO oInforme:oRadio ;
      VAR oInforme:nRadio ;
      ID 100, 101, 103, 114, 105, 107, 110, 111, 113 ;
      OF oInforme:oFld:aDialogs[1]

   if !IsPrestado( "SO" )
      oInforme:oRadio:aItems[09]:disable() // justificante de préstamo
   endif

   REDEFINE COMBOBOX aGet[01] VAR cMa ITEMS aMa ID 102 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 2
   REDEFINE COMBOBOX aGet[02] VAR cPr ITEMS aPr ID 104 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 3
   REDEFINE COMBOBOX aGet[03] VAR cUb ITEMS aUb ID 115 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 4
   REDEFINE COMBOBOX aGet[04] VAR cEd ITEMS aEd ID 106 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 5

   REDEFINE GET aGet[5] ;
      VAR dFch1         ;
      ID 108            ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 6

   REDEFINE BUTTON aBtn[01];
      ID 116;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch1, aGet[5] ),;
               aGet[5]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 6

      aBtn[01]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[6] ;
      VAR dFch2         ;
      ID 109            ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 6

   REDEFINE BUTTON aBtn[02];
      ID 117;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch2, aGet[6] ),;
               aGet[6]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 6

      aBtn[02]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE CHECKBOX aGet[7]  ;
      VAR lImg                ;
      ID 112                  ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 8 .and. !empty( SO->SoImagen )

   oInforme:Folders()
   if oInforme:Activate()
      nRecno := SO->( recNo() )
      nOrder := SO->( ordNumber() )
      do case
         case oInforme:nRadio == 1
            // todo el software, con el orden determinado
            // nRptModo := 1
            SO->( dbGoTop() )
         case oInforme:nRadio == 2
             // software de una materia
            // nRptModo := 1
            SO->( ordSetFocus( "materia" ) )
            SO->( ordScope( 0, upper( rTrim( cMa ) ) ) )
            SO->( ordScope( 1, upper( rTrim( cMa ) ) ) )
            SO->( dbGoTop() )
         case oInforme:nRadio == 3
            // software de un propietario
            // nRptModo := 1
            SO->( ordSetFocus( "propietario" ) )
            SO->( ordScope( 0, upper( rTrim( cPr ) ) ) )
            SO->( ordScope( 1, upper( rTrim( cPr ) ) ) )
            SO->( dbGoTop() )
         case oInforme:nRadio == 4
            // software de una ubicación
            // nRptModo := 1
            SO->( ordSetFocus( "ubicacion" ) )
            SO->( ordScope( 0, upper( rTrim( cUb ) ) ) )
            SO->( ordScope( 1, upper( rTrim( cUb ) ) ) )
            SO->( dbGoTop() )
         case oInforme:nRadio == 5
            // software de una compañía
            // nRptModo := 1
            SO->( ordSetFocus( "editor" ) )
            SO->( ordScope( 0, upper( rTrim( cEd ) ) ) )
            SO->( ordScope( 1, upper( rTrim( cEd ) ) ) )
            SO->( dbGoTop() )
         case oInforme:nRadio == 6
            // software comprado en un periodo
            // nRptModo := 1
            SO->( ordSetFocus( "fchcompra" ) )
            SO->( ordScope( 0, dTOs( dFch1 ) ) )
            SO->( ordScope( 1, dTOs( dFch2 ) ) )
            SO->( dbGoTop() )
         case oInforme:nRadio == 7
            // software prestado
            // nRptModo := 1
            SO->( ordSetFocus( "prestados" ) )
            SO->( dbGoTop() )
         case oInforme:nRadio == 8
            // ficha completa del software seleccionado
            SoImprimirFicha(oInforme, lImg)
            // nRptModo := 2
         case oInforme:nRadio == 9
            // justificante de préstamo del software seleccionado
            SoImprimirJustif()
            // nRptModo := 3
      end case
      if oInforme:nRadio < 8
         Select SO
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
                     oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
                     oInforme:oReport:EndLine() )
      endif
      oInforme:End(.t.)

      SO->( ordScope( 0, NIL ) )
      SO->( ordScope( 1, NIL ) )
      SO->(DbSetOrder(nOrder))
      SO->(DbGoTo(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .t. )
   oApp():nEdit --
return NIL

/*_____________________________________________________________________________*/

function SoDbfVacia()

   local lReturn := .f.

   if SO->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún software registrado." ) )
      lReturn := .t.
   endif

return lReturn

/*_____________________________________________________________________________*/

function SoImprimirFicha( oInforme, lImg )
   local nRec  := SO->( recNo() )
   local i     := 0

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(SO->SoTitulo)
   oInforme:cTitulo2 := Rtrim("Ficha de la aplicación")

   // oInforme:cTitulo2 := "Año: "+cAnyo
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

   ACTIVATE REPORT oInforme:oReport FOR SO->( recNo() ) == nRec ;
      ON INIT SoImprimirFicha2( oInforme:oReport, nRec, lImg )

   SO->( dbGoTo( nRec ) )

return NIL

/*_____________________________________________________________________________*/

function SoImprimirFicha2( oReport, nRec, lImg )

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

   local aEntornos := { i18n("DOS"), i18n("Windows"), i18n("Linux"), i18n("MacOS"), i18n("Otro") }

   SO->( dbGoTo( nRec ) )

   cBmpFile := SO->SoImagen
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
   oReport:Say( 2, SO->SoCodigo   , 1 )
   oReport:Say( 3, i18n("Nombre:"), 2 )
   oReport:Say( 4, SO->SoTitulo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Materia:"), 2 )
   oReport:Say( 2, SO->SoMateria   , 1 )
   oReport:Say( 3, i18n("Idioma:") , 2 )
   oReport:Say( 4, SO->SoIdioma    , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Propietario:"), 2 )
   oReport:Say( 2, SO->SoPropiet       , 1 )
   oReport:Say( 3, i18n("Ubicación:")  , 2 )
   oReport:Say( 4, SO->SoGuardado      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Compañía:"), 2 )
   oReport:Say( 2, SO->SoEditor     , 1 )
   oReport:Say( 3, i18n("Nº Serie:"), 2 )
   oReport:Say( 4, SO->SoNumSer   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Entorno:")                        , 2 )
   oReport:Say( 2, aEntornos[SO->SoEntorno6]               , 1 )
   oReport:Say( 3, i18n("Demo:")                           , 2 )
   oReport:Say( 4, if( SO->SoDemo, i18n("Sí"), i18n("No") ), 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Disquette:")                        , 2 )
   oReport:Say( 2, if( SO->SoDiscos, i18n("Sí"), i18n("No") ), 1 )
   oReport:Say( 3, i18n("Nº Discos:")                        , 2 )
   oReport:Say( 4, SO->SoNumDisk                             , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("CD:")                           , 2 )
   oReport:Say( 2, if( SO->SoCD, i18n("Sí"), i18n("No") ), 1 )
   oReport:Say( 3, i18n("Título CD:") , 2 )
   oReport:Say( 4, SO->SoNomDir       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 3, i18n("Dir/Nombre:"), 2 )
   oReport:Say( 4, SO->SoUbicaci      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Centro Compra:"), 2 )
   oReport:Say( 2, SO->SoProveed         , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fch. Compra:"), 2 )
   oReport:Say( 2, SO->SoFchComp       , 1 )
   oReport:Say( 3, i18n("Precio:")     , 2 )
   oReport:Say( 4, SO->SoPrecio        , 1 )
   oReport:EndLine()
   if !empty( SO->SoDescri )
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 1, i18n("Descripción"), 2 )
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      nLines := mlCount( SO->SoDescri, 90 )
      for i := 1 to nLines
         oReport:StartLine()
         oReport:Say( 2, memoLine( SO->SoDescri, 90, i ), 1 )
         oReport:EndLine()
      next
   endif

return NIL
