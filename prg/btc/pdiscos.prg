**
* PROYECTO ..: Cuaderno de Bitácora
* COPYRIGHT .: (c) alanit software
* URL .......: www.alanit.com
**

#include "FiveWin.ch"
#include "Report.ch"
#include "vMenu.ch"
#include "AutoGet.ch"

extern deleted
Static oMuImage
/*_____________________________________________________________________________*/

function Discos()

   local oBar
   local oCol
   local oCont
	local cTitle 	  := "Discos"
	local cContTitle := cTitle+": "

   local cBrwState := GetIni( , "Browse", "MuAbm-State", "" )
   local nBrwSplit := val( GetIni( , "Browse", "MuAbm-Split", "102" ) )
   local nBrwRecno := val( GetIni( , "Browse", "MuAbm-Recno", "1" ) )
   local nBrwOrder := val( GetIni( , "Browse", "MuAbm-Order", "1" ) )

   local aSoportes := { i18n("CD"), i18n("Casette"), i18n("MiniDisc"), i18n("Vinilo"), i18n("Otro"), i18n("DVD") }

   if ModalSobreFsdi()
      retu NIL
   endif

   if ! Db_OpenAll()
      retu NIL
   endif

   MU->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Discos Musicales" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "MU"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muCodigo }
   oCol:cHeader  := i18n( "Código" )
   oCol:nWidth   := 70

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muTitulo }
   oCol:cHeader  := i18n( "Título" )
   oCol:nWidth   := 141

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muAutor }
   oCol:cHeader  := i18n( "Intérprete" )
   oCol:nWidth   := 153

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muMateria }
   oCol:cHeader  := i18n( "Género" )
   oCol:nWidth   := 112

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muIdioma }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 80

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muAutor2 }
   oCol:cHeader  := i18n( "Compositor" )
   oCol:nWidth   := 141

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muDirector }
   oCol:cHeader  := i18n( "Director" )
   oCol:nWidth   := 142

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muPropiet }
   oCol:cHeader  := i18n( "Propietario" )
   oCol:nWidth   := 137

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muUbicaci }
   oCol:cHeader  := i18n( "Ubicación" )
   oCol:nWidth   := 100

   //oCol := oApp():oGrid:AddCol()
   //oCol:bStrData := { || aSoportes[Max(MU->muSoporte,1)] }
   //oCol:cHeader  := i18n( "Soporte" )
   //oCol:nWidth   := 59

	oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muSopTxt }
   oCol:cHeader  := i18n( "Soporte" )
   oCol:nWidth   := 59

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muEditor }
   oCol:cHeader  := i18n( "Productora" )
   oCol:nWidth   := 100

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( MU->muAnoEdic, 4 ) }
   oCol:cHeader  := i18n( "Año Edic." )
   oCol:nWidth   := 53

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muColecc }
   oCol:cHeader  := i18n( "Colección" )
   oCol:nWidth   := 85

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( MU->muNumTomos, 6 ) }
   oCol:cHeader  := i18n( "Nº Discos" )
   oCol:nWidth   := 55

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( MU->muEsteTomo, 6 ) }
   oCol:cHeader  := i18n( "Disco Nº" )
   oCol:nWidth   := 55

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || dTOc( MU->muFchAdq ) }
   oCol:cHeader  := i18n( "Fch.Compra" )
   oCol:nWidth   := 65

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muProveed }
   oCol:cHeader  := i18n( "Centro Compra" )
   oCol:nWidth   := 95

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( MU->muPrecio ) }
   oCol:cHeader  := i18n( "Precio" )
   oCol:nWidth   := 47

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "BR_IMG1" )
   oCol:AddResource( "BR_IMG2" )
   oCol:cHeader       := i18n( "Imagen" )
   oCol:bBmpData      := { || if( !empty( MU->MuImagen ), 1, 2 ) }
   oCol:nWidth        := 28
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "16_PRES_ON" )
   oCol:AddResource( "16_PRES_OFF" )
   oCol:cHeader       := i18n( "Prestado" )
   oCol:bBmpData      := { || if( IsPrestado( "MU" ), 1, 2 ) }
   oCol:nWidth        := 28
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || dTOc( MU->muFchPres ) }
   oCol:cHeader  := i18n( "Fch.Préstamo" )
   oCol:nWidth   := 74

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muPrestad }
   oCol:cHeader  := i18n( "Prestatario" )
   oCol:nWidth   := 128

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muObserv }
   oCol:cHeader  := i18n( "Comentarios" )
   oCol:nWidth   := 150


   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || MU->muResumen }
   oCol:cHeader  := i18n( "Resumen" )
   oCol:nWidth   := 150

   aEval( oApp():oGrid:aCols, { |oCol| oCol:bLDClickData := { || MuForm( oApp():oGrid, "edt", oCont, cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := { || RefreshCont( oCont, "MU", cContTitle ), RefreshMuImage() }
   oApp():oGrid:bKeyDown   := { |nKey| MuTeclas( nKey, oApp():oGrid, oCont, oApp():oTab:nOption, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 160 OF oApp():oDlg ;
		COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(MU->(OrdKeyNo()),'@E 999,999')+" / "+tran(MU->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_DISCOS"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( MuForm( oApp():oGrid, "add", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( MuForm( oApp():oGrid, "edt", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( MuForm( oApp():oGrid, "dup", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( MuBorrar( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( MuBuscar( oApp():oGrid, oCont, oApp():oTab:nOption, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( MuImprimir( oApp():oGrid ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Devolver")           ;
      IMAGE "16_devolver"          ;
      ACTION ( MuDevolver(), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Ver imagen")         ;
      IMAGE "16_imagen"             ;
      ACTION Muximagen( MU->MuImagen, MU->MuTitulo ), oApp():oGrid:setFocus() ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "MuAbm-State" ), oApp():oGrid:setFocus() ) ;
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
     ITEMS " "+i18n("Título")+" "     , " "+i18n("Código")+" "    , " "+i18n("Intérprete")+" " ,;
           " "+i18n("Género")+" "     , " "+i18n("Compositor")+" ", " "+i18n("Director")+" "   ,;
           " "+i18n("Propietario")+" ", " "+i18n("Ubicación")+" " , " "+i18n("Editor")+" "     ,;
           " "+i18n("Año Edic.")+" "  , " "+i18n("Colección")+" " , " "+i18n("Fch.Compra")+" " ,;
           " "+i18n("Fch.Préstamo")+" ";
     COLOR CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
     ACTION ( MuTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar, oMuImage )

   if nBrwRecno <= MU->( ordKeyCount() )
      MU->( dbGoTo( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      ON INIT ( ResizeWndMain(),;
 				    MuBarImage(oBar, nBrwSplit),;
					 MuTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ),;
                oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
              SetIni( , "Browse", "MuAbm-State", oApp():oGrid:SaveState() ),;
              SetIni( , "Browse", "MuAbm-Order", oApp():oTab:nOption ),;
              SetIni( , "Browse", "MuAbm-Recno", MU->( recNo() ) ),;
              SetIni( , "Browse", "MuAbm-Split", lTrim( str( oApp():oSplit:nleft / 2 ) ) ),;
              oBar:End(), oCont:End(), dbCloseAll(),;
              oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .t. )

return NIL
/*_____________________________________________________________________________*/
function MuBarImage(oBar, nBrwSplit)
	oMuImage := TXImage():New( 35, 10, ( 2 * nBrwSplit ) -40, ( 2.6 * nBrwSplit ) -40,,oBar,.t.,.f. )
	if File(lfn2sfn(rtrim(MU->MuImagen)))
      oMuImage:SetSource(lfn2sfn(rtrim(MU->MuImagen)))
	else 
		oMuImage:Hide()
   endif
return nil

function RefreshMuImage()
	oMuImage:Hide()
	if File(lfn2sfn(rtrim(MU->MuImagen)))
      oMuImage:SetSource(lfn2sfn(rtrim(MU->MuImagen)))
		oMuImage:Show()
	endif
	oMuImage:Refresh()
return nil
/*_____________________________________________________________________________*/

function MuForm( oBrw, cModo, oCont, cContTitle )

   local oDlg
   local oFld
   local aSay       := array(16)
   local aGet       := array(25)
   local aBtn       := array(18)
   local aBmp       := array(02)
   local oBtnBmp
   local oBtnImg
   local oBrwCn
   local oCol

   local cCaption   := ""
   local lIdOk      := .f.
   local nRecBrw    := MU->( recNo() )
   local nRecAdd    := 0
   local lPrestado  := .f.
   local lPresEdit  := .t.
   local cBrwState  := GetIni( , "Browse", "MuExtCa-State", "" )
   local cOldCod    := ""

   local cMuCodigo   := ""
   local cMuTitulo   := ""
   local cMuAutor    := ""
   local cMuAutor2   := ""
   local cMuIdioma   := ""
   local cMuUbicaci  := ""
   local cMuEditor   := ""
   local cMuDirector := ""
   local nMuAnoEdic  := 0
   local nMuPrecio   := 0
   local nMuSoporte  := 1
	local cMuSopTxt	:= ""
   local cMuMateria  := ""
   local cMuPrestad  := ""
   local dMuFchPres  := date()
   local dMuFchAdq   := date()
   local cMuProveed  := ""
   local cMuColecc   := ""
   local nMuNumTomo  := 0
   local nMuEsteTom  := 0
   local cMuImagen   := ""
   local cMuPropiet  := ""
	local cMuResumen  := ""
   local mMuObserv

   local bSetScope := { || CD->( ordScope( 0, NIL ) ),;
                           CD->( ordScope( 1, NIL ) ),;
                           CD->( ordSetFocus( "CdMuCodigo" ) ),;
                           CD->( ordScope( 0, cMuCodigo ) ),;
                           CD->( ordScope( 1, cMuCodigo ) ),;
                           CD->( dbGoTop() ),;
                           oBrwCn:refresh(),;
                           oBrwCn:setFocus() }

   if cModo == "edt" .or. cModo == "dup"
      if MuDbfVacia()
         retu NIL
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if MU->( eof() ) .and. cModo != "add"
      retu NIL
   endif

   oApp():nEdit++

   cModo := lower( cModo )

   do case
      // nuevo
      case cModo == "add"
         cCaption := i18n( "Añadir un Disco" )
         MU->( dbAppend() )
         Replace MU->MuSoporte with 1
         MU->( dbCommit() )
         nRecAdd := MU->( recNo() )
      // modificar
      case cModo == "edt"
         cCaption := i18n( "Modificar un Disco" )
      // duplicar
      case cModo == "dup"
         cCaption := i18n( "Duplicar un Disco" )
   end case

   // ambos casos
   cMuCodigo   := MU->MuCodigo
   cMuTitulo   := MU->MuTitulo
   cMuAutor    := MU->MuAutor
   cMuAutor2   := MU->MuAutor2
   cMuDirector := MU->MuDirector
   cMuEditor   := MU->MuEditor
   nMuAnoEdic  := MU->MuAnoEdic
   nMuPrecio   := MU->MuPrecio
   nMuSoporte  := MIN(MAX(MU->MuSoporte,1),6)
	cMuSopTxt	:= MU->MuSopTxt
   cMuMateria  := MU->MuMateria
   cMuIdioma   := MU->MuIdioma
   cMuUbicaci  := MU->MuUbicaci
   cMuPrestad  := MU->MuPrestad
   dMuFchPres  := MU->MuFchPres
   cMupropiet  := MU->Mupropiet
   dMufchadq   := MU->Mufchadq
   cMuproveed  := MU->Muproveed
   cMucolecc   := MU->Mucolecc
   nMunumtomo  := MU->Munumtomos
   nMuestetom  := MU->Muestetomo
   cMuImagen   := MU->MuImagen
	cMuResumen	:= MU->MuResumen
   mMuObserv   := MU->MuObserv

   do case
      case cModo == "add" .and. oApp():lCodAut
         GetNewCod( .f., "MU", "MuCodigo", @cMuCodigo )
      case cModo == "dup"
         if oApp():lCodAut
            GetNewCod( .f., "MU", "MuCodigo", @cMuCodigo )
         else
            cMuCodigo := space( 10 )
         endif
   end case

   lPresEdit := if( cModo == "edt", ( empty( cMuPrestad ) .or. dMuFchPres == cTOd( "" ) ), .t. )

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "MU_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   // Diálogo principal

   REDEFINE GET aGet[01] ;
      VAR cMuTitulo ;
      ID 100 ;
      OF oDlg ;
      WHEN ( lPresEdit )

   REDEFINE GET aGet[02] ;
      VAR cMuCodigo ;
      ID 101 ;
      OF oDlg ;
      WHEN ( cOldCod := cMuCodigo, lPresEdit ) ;
      VALID ( MuClave( cMuCodigo, aGet[02], cModo, cOldCod, oBrwCn ) )

   REDEFINE BUTTON aBtn[01];
      ID 110;
      OF oDlg;
      WHEN ( cOldCod := cMuCodigo, lPresEdit ) ;
      ACTION ( GetNewCod( .t., "MU", "MuCodigo", @cMuCodigo ), aGet[02]:refresh(), aGet[02]:setFocus() )

      aBtn[01]:cToolTip := i18n( "generar código autonumérico" )

   REDEFINE AUTOGET aGet[03] ;
      VAR cMuAutor ;
		Datasource {}						;
		Filter AulistI( Udatasource, Cdata, Self );     
		Heightlist 100 ;
      ID 102 ;
      OF oDlg ;
      VALID ( AuClave( @cMuAutor, aGet[03], "aux", "I" ) )		

   REDEFINE BUTTON aBtn[02];
      ID 111;
      OF oDlg;
      ACTION ( AuTabAux( @cMuAutor, aGet[03], "I" ),;
               aGet[03]:setFocus(),;
               SysRefresh() )

      aBtn[02]:cToolTip := i18n( "selecc. intérprete" )

   REDEFINE AUTOGET aGet[04] ;
      VAR cMuMateria ;
		DATASOURCE {}						;
		FILTER MaListM( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 103 ;
      OF oDlg ;
      VALID ( MaClave( @cMuMateria, aGet[04], "aux", "M" ) )

   REDEFINE BUTTON aBtn[03];
      ID 112;
      OF oDlg;
      ACTION ( MaTabAux( @cMuMateria, aGet[04], "M" ),;
               aGet[04]:setFocus(),;
               SysRefresh() )

      aBtn[03]:cToolTip := i18n( "selecc. género" )

   REDEFINE AUTOGET aGet[05] ;
      VAR cMuIdioma ;
		DATASOURCE {}						;
		FILTER IdList( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 104 ;
      OF oDlg ;
      VALID ( IdClave( @cMuIdioma, aGet[05], "aux" ) )

   REDEFINE BUTTON aBtn[04];
      ID 113;
      OF oDlg;
      ACTION ( IdTabAux( @cMuIdioma, aGet[05] ),;
               aGet[05]:setFocus(),;
               SysRefresh() )

      aBtn[04]:cToolTip := i18n( "selecc. idioma" )

   REDEFINE AUTOGET aGet[06] ;
      VAR cMuPropiet ;
		DATASOURCE {}						;
		FILTER AgListP( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 105 ;
      OF oDlg ;
      VALID ( AgClave( @cMuPropiet, aGet[06], "aux", "P" ) )

   REDEFINE BUTTON aBtn[05];
      ID 114;
      OF oDlg;
      ACTION ( AgTabAux( @cMuPropiet, aGet[06], "P" ),;
               aGet[06]:setFocus(),;
               SysRefresh() )

      aBtn[05]:cToolTip := i18n( "selecc. propietario" )

   REDEFINE AUTOGET aGet[07]  ;
      VAR cMuUbicaci          ;
		DATASOURCE {}						;
		FILTER UbListM( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 106                  ;
      OF oDlg                 ;
      VALID ( UbClave( @cMuUbicaci, aGet[07], "aux", "M" ) )

   REDEFINE BUTTON aBtn[06];
      ID 115;
      OF oDlg;
      ACTION ( UbTabAux( @cMuUbicaci, aGet[07], "M" ),;
               aGet[07]:setFocus(),;
               SysRefresh() )

      aBtn[06]:cToolTip := i18n( "selecc. ubicación" )

   REDEFINE ximage aGet[24] FILE "" ID 117 OF oDlg //SCROLL

   if File(lfn2sfn(rtrim(cMuImagen)))
      aGet[24]:SetSource(lfn2sfn(rtrim(cMuImagen)))
   endif

   REDEFINE FOLDER oFld ;
      ID 107 ;
      OF oDlg ;
      ITEMS i18n("E&dición"), i18n("Co&lección"), i18n("&Observaciones"), i18n("A&utores"), i18n("Ca&nciones"), i18n("&Imagen"), i18n("C&ompra"), i18n("&Préstamo") ;
      DIALOGS "MU_FORM_A", "MU_FORM_B", "MU_FORM_C", "MU_FORM_D", "MU_FORM_E", "MU_FORM_F", "MU_FORM_G", "MU_FORM_H"

   // Primer folder: datos de edición
   REDEFINE SAY aSay[01] ID 200 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oFld:aDialogs[1]
   REDEFINE SAY aSay[03] ID 202 OF oFld:aDialogs[1]

   REDEFINE AUTOGET aGet[08]  ;
      VAR cMuEditor           ;
		DATASOURCE {}						;
		FILTER EdListD( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100                  ;
      OF oFld:aDialogs[1]     ;
      VALID ( EdClave( @cMuEditor, aGet[08], "aux", "D" ) )

   REDEFINE BUTTON aBtn[07];
      ID 101;
      OF oFld:aDialogs[1];
      ACTION ( EdTabAux( @cMuEditor, aGet[08], "D" ),;
               aGet[08]:setFocus(),;
               SysRefresh() )

      aBtn[07]:cToolTip := i18n( "selecc. productora" )

   REDEFINE GET aGet[09] ;
      VAR nMuAnoEdic ;
      ID 102 ;
      OF oFld:aDialogs[1] ;
      PICTURE "9999"

   REDEFINE AUTOGET aGet[10]  ;
      VAR cMuSopTxt           ;
		DATASOURCE {}						;
		FILTER SmList( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 103                  ;
      OF oFld:aDialogs[1]     ;
      VALID ( SmClave( @cMuSopTxt, aGet[10], "aux" ) )

   REDEFINE BUTTON aBtn[16];
      ID 104;
      OF oFld:aDialogs[1];
      ACTION ( SmTabAux( @cMuSopTxt, aGet[10] ),;
               aGet[10]:setFocus(),;
               SysRefresh() )

      aBtn[16]:cToolTip := i18n( "selecc. soporte" )

   // Segundo folder: datos de colección

   REDEFINE SAY aSay[04] ID 200 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[05] ID 201 OF oFld:aDialogs[2]
   REDEFINE SAY aSay[06] ID 202 OF oFld:aDialogs[2]

   REDEFINE AUTOGET aGet[11]   ;
      VAR cMuColecc        ;
		DATASOURCE {}						;
		FILTER ClListD( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100               ;
      OF oFld:aDialogs[2]  ;
      VALID ( ClClave( @cMuColecc, aGet[11], "aux", "D" ) )

   REDEFINE BUTTON aBtn[08];
      ID 103;
      OF oFld:aDialogs[2];
      ACTION ( ClTabAux( @cMuColecc, aGet[11], "D", @nMuNumTomo, aGet[12] ),;
               aGet[11]:setFocus(),;
               SysRefresh() )

      aBtn[08]:cToolTip := i18n( "selecc. colección" )

   REDEFINE GET aGet[12] ;
      VAR nMuNumTomo ;
      PICTURE "@E 999,999" ;
      ID 101 ;
      OF oFld:aDialogs[2]

   REDEFINE GET aGet[13] ;
      VAR nMuEsteTom ;
      PICTURE "@E 999,999" ;
      ID 102 ;
      OF oFld:aDialogs[2]

   // Tercer folder: observaciones

   REDEFINE SAY aSay[15] ID 200 OF oFld:aDialogs[3]
	REDEFINE SAY aSay[16] ID 201 OF oFld:aDialogs[3]

   REDEFINE GET aGet[23] VAR mMuObserv ID 100 OF oFld:aDialogs[3] MEMO
	
	REDEFINE GET aGet[25] var cMuResumen       ;
      ID 101 OF oFld:aDialogs[3] UPDATE      
   REDEFINE BUTTON aBtn[17]                  ;
      ID 102 OF oFld:aDialogs[3] UPDATE      ;
      ACTION aGet[25]:cText := cGetFile32('*.*','indique la ubicación del resumen',,,,.T.) 
   aBtn[17]:cTooltip := "seleccionar fichero"
   REDEFINE BUTTON aBtn[18]                  ;
      ID 103 OF oFld:aDialogs[3] UPDATE      ;
      ACTION GoFile( cMuResumen )            
   aBtn[18]:cTooltip := "ejecutar fichero"

   // Cuarto folder: datos de autores

   REDEFINE SAY aSay[07] ID 200 OF oFld:aDialogs[4]
   REDEFINE SAY aSay[08] ID 201 OF oFld:aDialogs[4]

   REDEFINE AUTOGET aGet[14]   ;
      VAR cMuAutor2        ;
		DATASOURCE {}						;
		FILTER AuListC( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100               ;
      OF oFld:aDialogs[4]  ;
      VALID ( AuClave( @cMuAutor2, aGet[14], "aux", "C" ) )

   REDEFINE BUTTON aBtn[09];
      ID 102;
      OF oFld:aDialogs[4];
      ACTION ( AuTabAux( @cMuAutor2, aGet[14], "C" ),;
               aGet[14]:setFocus(),;
               SysRefresh() )

      aBtn[09]:cToolTip := i18n( "selecc. compositor" )

   REDEFINE AUTOGET aGet[15]  ;
      VAR cMuDirector         ;
		DATASOURCE {}						;
		FILTER AuListD( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 101                  ;
      OF oFld:aDialogs[4]     ;
      VALID ( AuClave( @cMuDirector, aGet[15], "aux", "D" ) )

   REDEFINE BUTTON aBtn[10];
      ID 103;
      OF oFld:aDialogs[4];
      ACTION ( AuTabAux( @cMuDirector, aGet[15], "D" ),;
               aGet[15]:setFocus(),;
               SysRefresh() )

      aBtn[10]:cToolTip := i18n( "selecc. director musical" )

   // Quinto folder: datos de canciones del disco

   oBrwCn := TXBrowse():New( oFld:aDialogs[5] )
      oBrwCn:cAlias := "CD"
      Ut_BrwRowConfig( oBrwCn )
      oCol := oBrwCn:AddCol()
      oCol:bStrData := { || CD->cdOrden }
      oCol:cHeader  := i18n( "Orden" )
      oCol:nWidth   := 19

      oCol := oBrwCn:AddCol()
      oCol:bStrData := { || CD->cdCaTitulo }
      oCol:cHeader  := i18n( "Canción" )
      oCol:nWidth   := 164

      oCol := oBrwCn:AddCol()
      oCol:bStrData := { || CD->cdCaAutor }
      oCol:cHeader  := i18n( "Compositor" )
      oCol:nWidth   := 102

      oCol := oBrwCn:AddCol()
      oCol:bStrData := { || CD->cdCaDuracc }
      oCol:cHeader  := i18n( "Durac." )
      oCol:nWidth   := 39

      aEval( oBrwCn:aCols, { |oCol| oCol:bLDClickData := { || MuCdForm( oBrwCn, cMuCodigo, cMuTitulo, cMuAutor, "edt" ) } } )

      // oBrwCn:lHScroll := .f.
      oBrwCn:SetRDD()
      oBrwCn:CreateFromResource( 100 )
      //oFld:aDialogs[6]:oClient := oBrwCn
      oBrwCn:RestoreState( cBrwState )

      eval( bSetScope )

   REDEFINE BUTTON ID 101 OF oFld:aDialogs[5] ;
      ACTION ( MuCdForm( oBrwCn, cMuCodigo, cMuTitulo, cMuAutor, "add" ),;
               if( cModo == "add" .or. cModo == "dup", eval( bSetScope ), ) )
               // si no lo pongo, al añadir mientras estoy dando de alta un disco no sale
               // la canción en el browse.

   REDEFINE BUTTON ID 102 OF oFld:aDialogs[5] ;
      WHEN ( CD->( OrdKeyVal() ) != NIL ) ;
      ACTION ( MuCdForm( oBrwCn, cMuCodigo, cMuTitulo, cMuAutor, "edt" ) )

   REDEFINE BUTTON ID 103 OF oFld:aDialogs[5] ;
      WHEN ( CD->( OrdKeyVal() ) != NIL ) ;
      ACTION ( MuCdBorrar( oBrwCn ) )

   // Sexto folder: imagen

   REDEFINE SAY aSay[09] ID 200 OF oFld:aDialogs[6]

   REDEFINE GET aGet[16] ;
      VAR cMuImagen ;
      ID 100 ;
      OF oFld:aDialogs[6] ;
      VALID ( aGet[17]:SetSource( , cMuImagen ), aGet[17]:refresh(),;
              aGet[24]:SetSource( , cMuImagen ), aGet[24]:refresh(), .t. )

   REDEFINE BUTTON aBtn[11];
      ID 103;
      OF oFld:aDialogs[6];
      ACTION ( MuGetImagen( aGet[17], aGet[24], aGet[16], oBtnImg ) )

      aBtn[11]:cToolTip := i18n( "selecc. imagen" )

   REDEFINE ximage aGet[17] FILE "" ID 101 OF oFld:aDialogs[6] //SCROLL

   aGet[17]:SetColor( CLR_RED, CLR_WHITE )

   if File(lfn2sfn(rtrim(cMuImagen)))
      aGet[17]:SetSource(lfn2sfn(rtrim(cMuImagen)))
   endif

   REDEFINE BUTTON oBtnImg ;
      ID 102 ;
      OF oFld:aDialogs[6] ;
      ACTION Muximagen( cMuImagen, cMuTitulo )

   // Séptimo folder: datos de compra

   REDEFINE SAY aSay[10] ID 200 OF oFld:aDialogs[7]
   REDEFINE SAY aSay[11] ID 201 OF oFld:aDialogs[7]
   REDEFINE SAY aSay[12] ID 202 OF oFld:aDialogs[7]

   REDEFINE AUTOGET aGet[18] ;
      VAR cMuProveed ;
		DATASOURCE {}						;
		FILTER CcList( uDataSource, cData, Self );        
		HEIGHTLIST 100 ;
      ID 100 ;
      OF oFld:aDialogs[7] ;
      VALID ( CcClave( @cMuProveed, aGet[18], "aux", "O" ) )

   REDEFINE BUTTON aBtn[12];
      ID 103;
      OF oFld:aDialogs[7];
      ACTION ( CcTabAux( @cMuProveed, aGet[18], "O" ),;
               aGet[18]:setFocus(),;
               SysRefresh() )
	aBtn[12]:cToolTip := i18n( "selecc. centro de compra" )

   REDEFINE GET aGet[19] ;
      VAR dMuFchAdq ;
      ID 101 ;
      OF oFld:aDialogs[7]

   REDEFINE BUTTON aBtn[13];
      ID 104;
      OF oFld:aDialogs[7];
      ACTION ( SelecFecha( dMuFchAdq, aGet[19] ),;
               aGet[19]:setFocus(),;
               SysRefresh() )

      aBtn[13]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[20] ;
      VAR nMuPrecio ;
      ID 102 ;
      OF oFld:aDialogs[7] ;
      PICTURE "@E 999,999.99 "

   // Octavo folder: datos de préstamo

   REDEFINE SAY aSay[13] ID 200 OF oFld:aDialogs[8]
   REDEFINE SAY aSay[14] ID 201 OF oFld:aDialogs[8]

   REDEFINE AUTOGET aGet[21] ;
      VAR cMuPrestad ;
		DATASOURCE {}						;
		FILTER AgListC( uDataSource, cData, Self );     
		HEIGHTLIST 100 ;
      ID 100 ;
      OF oFld:aDialogs[8];
      VALID ( AgClave( @cMuPrestad, aGet[21], "aux", "C" ) )

   REDEFINE BUTTON aBtn[14];
      ID 103;
      OF oFld:aDialogs[8];
      ACTION ( AgTabAux( @cMuPrestad, aGet[21], "C" ),;
               aGet[21]:setFocus(),;
               SysRefresh() )

      aBtn[14]:cToolTip := i18n( "selecc. prestatario" )

   REDEFINE BUTTON ;
      ID 101 ;
      OF oFld:aDialogs[8] ;
      WHEN ( !empty( cMuPrestad ) .or. dMuFchPres != cTOd( "" ) ) ;
      ACTION ( iif( msgYesNo( i18n("¿Desea anotar la devolución del disco?") ),;
                     ( cMuPrestad := space( 30 ),;
                       aGet[21]:refresh(),;
                       dMuFchPres := cTOd( "" ),;
                       aGet[22]:refresh(),;
                       aBmp[02]:reload( "16_pres_off" ),;
                       aBmp[02]:refresh(),;
                       SysRefresh() ), ), aGet[21]:setFocus() )

   REDEFINE GET aGet[22] ;
      VAR dMuFchPres ;
      ID 102 ;
      OF oFld:aDialogs[8]

   REDEFINE BUTTON aBtn[15];
      ID 104;
      OF oFld:aDialogs[8];
      ACTION ( SelecFecha( dMuFchPres, aGet[22] ),;
               aBmp[01]:reload( "CLIP_ON" ),;
               aBmp[01]:refresh(),;
               aGet[22]:setFocus(),;
               SysRefresh() )

      aBtn[15]:cToolTip := i18n( "selecc. fecha" )

   // Diálogo principal

   REDEFINE BITMAP aBmp[02] ID 109 OF oDlg RESOURCE "16_pres_off" TRANSPARENT

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
      ON INIT ( oDlg:Center( oApp():oWndMain ), Iif( !empty( cMuPrestad ) .or. dMuFchPres != cTOd( "" ),;
                 ( aBmp[02]:reload( "16_pres_on"  ), aBmp[02]:refresh() ),;
                 ( aBmp[02]:reload( "16_pres_off" ), aBmp[02]:refresh() ) ) )

   do case
      // nuevo
      case cModo == "add"
         // aceptar
         if lIdOk == .T.
            // alta del disco
            MU->( dbGoTo( nRecAdd ) )
            replace MU->MuCodigo   with cMuCodigo
            replace MU->MuTitulo   with cMuTitulo
            replace MU->MuAutor    with cMuAutor
            replace MU->MuAutor2   with cMuAutor2
            replace MU->MuDirector with cMuDirector
            replace MU->MuEditor   with cMuEditor
            replace MU->MuAnoEdic  with nMuAnoEdic
            replace MU->MuSoporte  with nMuSoporte
            replace MU->MuSopTxt   with cMuSopTxt
            replace MU->MuPrecio   with nMuPrecio
            replace MU->MuMateria  with cMuMateria
            replace MU->MuIdioma   with cMuIdioma
            replace MU->MuUbicaci  with cMuUbicaci
            replace MU->MuPrestad  with cMuPrestad
            replace MU->MuFchPres  with dMuFchPres
            replace MU->MuPropiet  with cMuPropiet
            replace MU->Mufchadq   with dMufchadq
            replace MU->Muproveed  with cMuproveed
            replace MU->Mucolecc   with cMucolecc
            replace MU->Munumtomos with nMunumtomo
            replace MU->Muestetomo with nMuestetom
            replace MU->MuImagen   with cMuImagen
            replace MU->muResumen  with cMuResumen
            replace MU->MuObserv   with mMuObserv
				MU->( dbCommit() )
            nRecBrw := MU->( recNo() )
            // incremento del nº de ejemplares en autores
				AU->(OrdSetFocus("INTERPRETES"))
				AU->(dbGoTop())
            if AU->( dbSeek( upper( cMuAutor ) ) )
               replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
               AU->( dbCommit() )
            endif
				AU->(OrdSetFocus("COMPOSITOR"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cMuAutor2 ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				AU->(OrdSetFocus("DIRMUSICA"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cMuDirector ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				// modificación del nº de ejemplares en productoras
				ED->(OrdSetFocus("EDDISCOS"))
				ED->(DbGoTop())
				if ED->( dbSeek( upper( cMuEditor ) ) )
					replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
					ED->(DbCommit())
				endif
				// modificación del nº de ejemplares en colecciones
				CL->(OrdSetFocus("CODISCOS"))
				CL->(dbGoTop())
				if CL->( dbSeek( upper( cMuColecc ) ) )
					replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
					CL->(dbCommit())
				endif
            // incremento del nº de ejemplares en materias
				MA->(OrdSetFocus("MATERIA"))
				MA->(Dbgotop())
            if MA->( dbSeek( "M" + upper( cMuMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumLibr ) + 1
               MA->( dbCommit() )
            endif
            // incremento del nº de ejemplares en ubicaciones
				UB->(OrdSetFocus("UBICACION"))
				UB->(Dbgotop())
            if UB->( dbSeek( "M" + upper( cMuUbicaci ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif

            // anotación del préstamo (si es necesario)
            if IsPrestado( "MU" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 2
               replace NO->NoCodigo  with MU->MuCodigo
               replace NO->NoFecha   with MU->MuFchPres
               replace NO->NoTitulo  with MU->MuTitulo
               replace NO->NoAQuien  with MU->MuPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  MuImprimirJustif()
               endif
            endif

         // cancelar
         else
            // borro las canciones que pueda haber añadido al disco
            CD->( ordScope( 0, NIL ) )
            CD->( ordScope( 1, NIL ) )
            CD->( dbGoTop() )
            while ! CD->( eof() )
               if CD->CdMuCodigo == cMuCodigo
                  CD->( dbDelete() )
               endif
               CD->( dbSkip() )
            end while

            // aquí no ha pasado nada
            MU->( dbGoTo( nRecAdd ) )
            MU->( dbDelete() )

         endif

      // modificar
      case cModo == "edt"

         // aceptar
         if lIdOk == .T.
            // modificación del préstamo (si es necesario)
            do case
               // acaba de anotarse el préstamo
               case !IsPrestado( "MU" ) .and. ( !empty( cMuPrestad ) .or. dMuFchPres != cTOd( "" ) )
                  NO->( dbAppend() )
                  replace NO->NoTipo    with 2
                  replace NO->NoCodigo  with cMuCodigo
                  replace NO->NoFecha   with dMuFchPres
                  replace NO->NoTitulo  with cMuTitulo
                  replace NO->NoAQuien  with cMuPrestad
                  NO->( dbCommit() )
                  lPrestado := .T.
               // estaba y sigue estando prestado
               case IsPrestado( "MU" ) .and. ( !empty( cMuPrestad ) .or. dMuFchPres != cTOd( "" ) )
                  if NO->( dbSeek( "2" + cMuCodigo ) )
                     replace NO->NoFecha   with dMuFchPres
                     replace NO->NoAQuien  with cMuPrestad
                     NO->( dbCommit() )
                  endif
               // estaba pero ya no está prestado
               case IsPrestado( "MU" ) .and. ( empty( cMuPrestad ) .and. dMuFchPres == cTOd( "" ) )
                  if NO->( dbSeek( "2" + MU->MuCodigo ) )
                     NO->( dbDelete() )
                  endif
                  NO->( dbCommit() )
            end case

            // modificación del nº de ejemplares en materias
            if ( MU->MuMateria != cMuMateria )
					MA->(OrdSetFocus("MATERIA"))
					MA->(Dbgotop())
               do case
                  case ( MA->( dbSeek( "M" + upper( MU->MuMateria ) ) ) )
                     MA->( dbSeek( "M" + upper( cMuMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
                     MA->( dbSeek( "M" + upper( MU->MuMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
                     MA->( dbCommit() )
                  case ( empty( MU->MuMateria ) )
                     MA->( dbSeek( "M" + upper( cMuMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               end case
            endif

            // modificación del nº de ejemplares en ubicaciones
            if ( MU->MuUbicaci != cMuUbicaci )
					UB->(OrdSetFocus("UBICACION"))
					UB->(Dbgotop())
               do case
                  case ( UB->( dbSeek( "M" + upper( MU->MuUbicaci ) ) ) )
                     UB->( dbSeek( "M" + upper( cMuUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) + 1
                     UB->( dbSeek( "M" + upper( MU->MuUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) - 1
                     UB->( dbCommit() )
                  case ( empty( MU->MuUbicaci ) )
                     UB->( dbSeek( "M" + upper( cMuUbicaci ) ) )
                     replace UB->UbItems with ( UB->UbItems ) + 1
               end case
            endif
				// modificación del nº de ejemplares en intérprete
				if ( MU->MuAutor != cMuAutor )
					AU->(OrdSetFocus("INTERPRETES"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( MU->MuAutor ) ) ) )
							AU->( dbSeek( upper( cMuAutor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( MU->MuAutor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( MU->MuAutor ) )
							AU->( dbSeek( upper( cMuAutor ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en compositor
				if ( MU->MuAutor2 != cMuAutor2 )
					AU->(OrdSetFocus("COMPOSITORES"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( MU->MuAutor2 ) ) ) )
							AU->( dbSeek( upper( cMuAutor2 ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( MU->MuAutor2 ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( MU->MuAutor2 ) )
							AU->( dbSeek( upper( cMuAutor2 ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif

				// modificación del nº de ejemplares en director
				if ( MU->MuDirector != cMuDirector )
					AU->(OrdSetFocus("DIRMUSICA"))
					AU->(dbGoTop())
					do case
						case ( AU->( dbSeek( upper( MU->MuDirector ) ) ) )
							AU->( dbSeek( upper( cMuDirector ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
							AU->( dbSeek( upper( MU->muDirector ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
							AU->( dbCommit() )
						case ( empty( MU->MuDirector ) )
							AU->( dbSeek( upper( cMuDirector ) ) )
							replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en productoras
				if ( MU->MuEditor != cMuEditor )
					ED->(OrdSetFocus("EDDISCOS"))
					ED->(dbGoTop())
					do case
						case ( ED->( dbSeek( upper( MU->MuEditor ) ) ) )
							ED->( dbSeek( upper( cMuEditor ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
							ED->( dbSeek( upper( MU->MuEditor ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) - 1
							ED->( dbCommit() )
						case ( empty( MU->MuEditor ) )
							ED->( dbSeek( upper( cMuEditor ) ) )
							replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
					endcase
				endif
				// modificación del nº de ejemplares en colecciones
				if ( MU->MuColecc != cMuColecc )
					CL->(OrdSetFocus("CODISCOS"))
					CL->(dbGoTop())
					do case
						case ( CL->( dbSeek( upper( MU->MuColecc ) ) ) )
							CL->( dbSeek( upper( cMuColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
							CL->( dbSeek( upper( MU->MuColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) - 1
							CL->( dbCommit() )
						case ( empty( MU->MuColecc ) )
							CL->( dbSeek( upper( cMuColecc ) ) )
							replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
					endcase
				endif

            // cambio de título en el fichero de canciones de discos
            // MU->( dbGoTo( nRecBrw ) )
            if MU->MuTitulo != cMuTitulo
               CD->( dbSetOrder( 0 ) )
               CD->( dbGoTop() )
               MsgRun( i18n( "Revisando el fichero de canciones de discos. Espere un momento..." ),;
                oApp():cAppName,;
                  { || CD->( dbEval( { || _FIELD->CD->CdMuTitulo := rTrim( cMuTitulo ) },;
                  { || rTrim( CD->CdMuCodigo ) == rTrim( MU->MuCodigo ) },,,, .f. ) ) } )
               CD->( dbCommit() )
               CD->( ordSetFocus( "CdMuCodigo" ) )
            endif

            // cambio de intérprete en el fichero de canciones de discos
            if MU->MuAutor != cMuAutor
               CD->( dbSetOrder( 0 ) )
               CD->( dbGoTop() )
               MsgRun( i18n( "Revisando el fichero de canciones de discos. Espere un momento..." ),;
                oApp():cAppName,;
                  { || CD->( dbEval( { || _FIELD->CD->CdMuInterp := rTrim( cMuAutor ) },;
                  { || rTrim( CD->CdMuCodigo ) == rTrim( MU->MuCodigo ) },,,, .f. ) ) } )
               CD->( dbCommit() )
               CD->( ordSetFocus( "CdMuCodigo" ) )
            endif

            // modificación del disco
            replace MU->MuCodigo   with cMuCodigo
            replace MU->MuTitulo   with cMuTitulo
            replace MU->MuAutor    with cMuAutor
            replace MU->MuAutor2   with cMuAutor2
            replace MU->MuDirector with cMuDirector
            replace MU->MuEditor   with cMuEditor
            replace MU->MuAnoEdic  with nMuAnoEdic
            replace MU->MuSoporte  with nMuSoporte
				replace MU->MuSopTxt   with cMuSopTxt
            replace MU->MuPrecio   with nMuPrecio
            replace MU->MuMateria  with cMuMateria
            replace MU->MuIdioma   with cMuIdioma
            replace MU->MuUbicaci  with cMuUbicaci
            replace MU->MuPrestad  with cMuPrestad
            replace MU->MuFchPres  with dMuFchPres
            replace MU->MuPropiet  with cMuPropiet
            replace MU->Mufchadq   with dMufchadq
            replace MU->Muproveed  with cMuproveed
            replace MU->Mucolecc   with cMucolecc
            replace MU->Munumtomos with nMunumtomo
            replace MU->Muestetomo with nMuestetom
            replace MU->MuImagen   with cMuImagen
				replace MU->muResumen  with cMuResumen
            replace MU->MuObserv   with mMuObserv
            MU->( dbCommit() )

            // impresión del justificante de préstamo (si es necesario)
            if lPrestado
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  MuImprimirJustif()
               endif
            endif

         // cancelar
         else
            // restauro código en canciones si lo había cambiado
            if cModo == "edt"
               if cMuCodigo != MU->MuCodigo
                  CD->( ordSetFocus( "CdMuCodigo" ) )
                  CD->( ordScope( 0, NIL ) )
                  CD->( ordScope( 1, NIL ) )
                  CD->( dbGoTop() )
                  while ! CD->( eof() )
                     if CD->CdMuCodigo == cMuCodigo
                        replace CD->CdMuCodigo with MU->MuCodigo
                     endif
                     CD->( dbSkip() )
                  end while
               endif
            endif
         endif
      // duplicar
      case cModo == "dup"
         // aceptar
         if lIdOk == .T.
            // duplicado del disco
            MU->( dbAppend() )
            nRecBrw := MU->( recNo() )
            replace MU->MuCodigo   with cMuCodigo
            replace MU->MuTitulo   with cMuTitulo
            replace MU->MuAutor    with cMuAutor
            replace MU->MuAutor2   with cMuAutor2
            replace MU->MuDirector with cMuDirector
            replace MU->MuEditor   with cMuEditor
            replace MU->MuAnoEdic  with nMuAnoEdic
            replace MU->MuSoporte  with nMuSoporte
				replace MU->MuSopTxt   with cMuSopTxt
            replace MU->MuPrecio   with nMuPrecio
            replace MU->MuMateria  with cMuMateria
            replace MU->MuIdioma   with cMuIdioma
            replace MU->MuUbicaci  with cMuUbicaci
            replace MU->MuPrestad  with cMuPrestad
            replace MU->MuFchPres  with dMuFchPres
            replace MU->MuPropiet  with cMuPropiet
            replace MU->Mufchadq   with dMufchadq
            replace MU->Muproveed  with cMuproveed
            replace MU->Mucolecc   with cMucolecc
            replace MU->Munumtomos with nMunumtomo
            replace MU->Muestetomo with nMuestetom
            replace MU->MuImagen   with cMuImagen
				replace MU->MuResumen  with cMuResumen
            replace MU->MuObserv   with mMuObserv
            MU->( dbCommit() )

				// incremento del nº de ejemplares en autores
				AU->(OrdSetFocus("INTERPRETES"))
				AU->(dbGoTop())
            if AU->( dbSeek( upper( cMuAutor ) ) )
               replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
               AU->( dbCommit() )
            endif
				AU->(OrdSetFocus("COMPOSITOR"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cMuAutor2 ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				AU->(OrdSetFocus("DIRMUSICA"))
				AU->(dbGoTop())
				if AU->( dbSeek( upper( cMuDirector ) ) )
					replace AU->AuNumEjem with ( AU->AuNumEjem ) + 1
					AU->( dbCommit() )
				endif
				// modificación del nº de ejemplares en productoras
				ED->(OrdSetFocus("EDDISCOS"))
				ED->(DbGoTop())
				if ED->( dbSeek( upper( cMuEditor ) ) )
					replace ED->EdNumEjem with ( ED->EdNumEjem ) + 1
					ED->(DbCommit())
				endif
				// modificación del nº de ejemplares en colecciones
				CL->(OrdSetFocus("CODISCOS"))
				CL->(dbGoTop())
				if CL->( dbSeek( upper( cMuColecc ) ) )
					replace CL->ClNumEjem with ( CL->ClNumEjem ) + 1
					CL->(dbCommit())
				endif
            // incremento del nº de ejemplares en materias
				MA->(OrdSetFocus("MATERIA"))
				MA->(Dbgotop())
            if MA->( dbSeek( "M" + upper( cMuMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumLibr ) + 1
               MA->( dbCommit() )
            endif

            // incremento del nº de ejemplares en ubicaciones
				UB->(OrdSetFocus("UBICACION"))
				UB->(Dbgotop())
            if UB->( dbSeek( "M" + upper( cMuUbicaci ) ) )
               replace UB->UbItems with ( UB->UbItems ) + 1
               UB->( dbCommit() )
            endif
            // anotación del préstamo (si es necesario)
            if IsPrestado( "MU" )
               NO->( dbAppend() )
               replace NO->NoTipo    with 2
               replace NO->NoCodigo  with MU->MuCodigo
               replace NO->NoFecha   with MU->MuFchPres
               replace NO->NoTitulo  with MU->MuTitulo
               replace NO->NoAQuien  with MU->MuPrestad
               NO->( dbCommit() )
               if msgYesNo( i18n( "¿Desea imprimir el justificante de préstamo?" ) )
                  MuImprimirJustif()
               endif
            endif
         // cancelar
         else
            // borro las canciones que pueda haber añadido al disco
            CD->( ordScope( 0, NIL ) )
            CD->( ordScope( 1, NIL ) )
            CD->( dbGoTop() )
            while ! CD->( eof() )
               if CD->CdMuCodigo == cMuCodigo
                  CD->( dbDelete() )
               endif
               CD->( dbSkip() )
            end while
         endif

   end case

   CD->( ordScope( 0, NIL ) )
   CD->( ordScope( 1, NIL ) )
   CD->( dbGoTop() )

   SetIni( , "Browse", "MuExtCa-State", oBrwCn:SaveState()  )

   // actualización del browse
   MU->( dbGoTo( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "MU", cContTitle )
		RefreshMuImage()
   endif
   oBrw:refresh()
   oBrw:setFocus()
   oApp():nEdit--
return NIL

/*_____________________________________________________________________________*/

function MuBorrar( oBrw, oCont, cContTitle )
   local nRecord := MU->( recNo() )
   local nNext   := 0
   if MuDbfVacia()
      return NIL
   endif
   if IsPrestado( "MU" )
      msgStop( i18n( "No se pueden eliminar discos prestados." ) )
      return NIL
   endif

   if msgYesNo( i18n( "¿Está seguro de querer borrar este disco?" + CRLF + CRLF ;
   + trim( MU->MuTitulo ) ) )
      MU->( dbSkip() )
      nNext := MU->( recNo() )
      MU->( dbGoto( nRecord ) )
		// decremento del nº de ejemplares en autores
		AU->(OrdSetFocus("INTERPRETES"))
		AU->(dbGoTop())
      if AU->( dbSeek( upper( MU->MuAutor ) ) )
         replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
         AU->( dbCommit() )
      endif
		AU->(OrdSetFocus("COMPOSITOR"))
		AU->(dbGoTop())
		if AU->( dbSeek( upper( MU->MuAutor2 ) ) )
			replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
			AU->( dbCommit() )
		endif
		AU->(OrdSetFocus("DIRMUSICA"))
		AU->(dbGoTop())
		if AU->( dbSeek( upper( MU->MuDirector ) ) )
			replace AU->AuNumEjem with ( AU->AuNumEjem ) - 1
			AU->( dbCommit() )
		endif
		// modificación del nº de ejemplares en productoras
		ED->(OrdSetFocus("EDDISCOS"))
		ED->(DbGoTop())
		if ED->( dbSeek( upper( MU->MuEditor ) ) )
			replace ED->EdNumEjem with ( ED->EdNumEjem ) - 1
			ED->(DbCommit())
		endif
		// modificación del nº de ejemplares en colecciones
		CL->(OrdSetFocus("CODISCOS"))
		CL->(dbGoTop())
		if CL->( dbSeek( upper( MU->MuColecc ) ) )
			replace CL->ClNumEjem with ( CL->ClNumEjem ) - 1
			CL->(dbCommit())
		endif
      // incremento del nº de ejemplares en materias
		MA->(OrdSetFocus("MATERIA"))
		MA->(Dbgotop())
      if MA->( dbSeek( "M" + upper( MU->MuMateria ) ) )
         replace MA->MaNumlibr with ( MA->MaNumLibr ) - 1
         MA->( dbCommit() )
      endif

      // incremento del nº de ejemplares en ubicaciones
		UB->(OrdSetFocus("UBICACION"))
		UB->(Dbgotop())
      if UB->( dbSeek( "M" + upper( MU->MuUbicaci ) ) )
         replace UB->UbItems with ( UB->UbItems ) - 1
         UB->( dbCommit() )
      endif

      // canciones del disco
      CD->( dbGoTop() )
      while ! CD->( eof() )
         if CD->CdMuCodigo == MU->MuCodigo
            CD->( dbDelete() )
         endif
         CD->( dbSkip() )
      end while
      // disco
      MU->( dbDelete() )
      MU->( dbGoto( nNext ) )
      if MU->( eof() ) .or. nNext == nRecord
         MU->( dbGoBottom() )
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "MU", cContTitle )
		RefreshMuImage()
   endif
   oBrw:refresh()
   oBrw:setFocus()

return NIL

/*_____________________________________________________________________________*/

function MuBuscar( oBrw, oCont, nTabOpc, cChr, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local nRecNo   := MU->( recNo() )
   local lIdOk    := .f.
   local lFecha   := .f.
   local aBrowse  := {}

   if MuDbfVacia()
      return NIL
   endif

   oApp():nEdit++

   switch nTabOpc
      case 1
         cPrompt := i18n( "Introduzca el Título del Disco" )
         cField  := i18n( "Título:" )
         cGet    := space( 60 )
         exit
      case 2
         cPrompt := i18n( "Introduzca el Código del Disco" )
         cField  := i18n( "Código:" )
         cGet    := space( 10 )
         exit
      case 3
         cPrompt := i18n( "Introduzca el Intérprete del Disco" )
         cField  := i18n( "Intérprete:" )
         cGet    := space( 40 )
         exit
      case 4
         cPrompt := i18n( "Introduzca el Género del Disco" )
         cField  := i18n( "Género:" )
         cGet    := space( 30 )
         exit
      case 5
         cPrompt := i18n( "Introduzca el Compositor del Disco" )
         cField  := i18n( "Compositor:" )
         cGet    := space( 40 )
         exit
      case 6
         cPrompt := i18n( "Introduzca el Director del Disco" )
         cField  := i18n( "Director:" )
         cGet    := space( 40 )
         exit
      case 7
         cPrompt := i18n( "Introduzca el Propietario del Disco" )
         cField  := i18n( "Propietario:" )
         cGet    := space( 40 )
         exit
      case 8
         cPrompt := i18n( "Introduzca la ubicación del Disco" )
         cField  := i18n( "Ubicación:" )
         cGet    := space( 40 )
         exit
      case 9
         cPrompt := i18n( "Introduzca el Editor del Disco" )
         cField  := i18n( "Editor:" )
         cGet    := space( 40 )
         exit
      case 10
         cPrompt := i18n( "Introduzca el Año de Edición del Disco" )
         cField  := i18n( "Año de Edición:" )
         cGet    := space( 04 )
         exit
      case 11
         cPrompt := i18n( "Introduzca la Colección del Disco" )
         cField  := i18n( "Colección:" )
         cGet    := space( 40 )
         exit
      case 12
         cPrompt := i18n( "Introduzca la Fecha de Compra del Disco" )
         cField  := i18n( "Fch. Compra:" )
         cGet    := cTOd( "" )
         exit
      case 13
         cPrompt := i18n( "Introduzca la Fecha de Préstamo del Disco" )
         cField  := i18n( "Fch. Préstamo:" )
         cGet    := cTOd( "" )
         exit
   end switch

   lFecha := valType( cGet ) == "D"

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Discos" )
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
            { || MuWildSeek(nTabOpc, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ningún disco."))
      else
         MuEncontrados(aBrowse, oApp():oDlg)
      endif
   endif
   MuTabs( oBrw, nTabOpc, oCont, cContTitle)
   RefreshCont( oCont, "MU", cContTitle )
	RefreshMuImage()
   oBrw:refresh()
   oBrw:setFocus()
   oApp():nEdit--
return NIL
/*_____________________________________________________________________________*/

function MuWildSeek(nTabOpc, cGet, aBrowse)
   local nRecno   := MU->(Recno())
   do case
      case nTabOpc == 1
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuTitulo)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 2
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuCodigo)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 3
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuAutor)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 4
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuMateria)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 5
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuAutor2)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 6
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuDirector)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 7
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuPropiet)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 8
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuUbicaci)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 9
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuEditor)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 10
         MU->(DbGoTop())
         do while ! MU->(eof())
            if VAL(cGet) == MU->MuAnoEdic
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 11
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet $ upper(MU->MuColecc)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 12
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet == dTOs(MU->MuFchAdq)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
      case nTabOpc == 13
         MU->(DbGoTop())
         do while ! MU->(eof())
            if cGet == dTOs(MU->MuFechaPr)
               aadd(aBrowse, {MU->MuTitulo, MU->MuAutor, MU->MuMateria, MU->(RecNo())})
            endif
            MU->(DbSkip())
         enddo
   end case
   MU->(DbGoTo(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[1]) < upper(aAut2[1]) } )
return nil
/*_____________________________________________________________________________*/
function MuEncontrados(aBrowse, oParent)
   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := MU->(Recno())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .f.)
   oBrowse:aCols[1]:cHeader := "Título"
   oBrowse:aCols[2]:cHeader := "Intérprete"
   oBrowse:aCols[3]:cHeader := "Género"
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:nWidth  := 140
   oBrowse:aCols[4]:lHide   := .t.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   MU->(OrdSetFocus("titulo"))
   MU->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1])))
   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||MU->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                           MuForm(oBrowse,"edt", ,) }} )
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(MU->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                     MuForm(oBrowse,"edt", , )),) }
   oBrowse:bChange    := { || MU->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (MU->(DbGoTo(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function MuTabs( oBrw, nOpc, oCont, cContTitle )

   switch nOpc
      case 1
         MU->( ordSetFocus( "titulo" ) )
         exit
      case 2
         MU->( ordSetFocus( "codigo" ) )
         exit
      case 3
         MU->( ordSetFocus( "interprete" ) )
         exit
      case 4
         MU->( ordSetFocus( "materia" ) )
         exit
      case 5
         MU->( ordSetFocus( "compositor" ) )
         exit
      case 6
         MU->( ordSetFocus( "director" ) )
         exit
      case 7
         MU->( ordSetFocus( "propietario" ) )
         exit
      case 8
         MU->( ordSetFocus( "ubicacion" ) )
         exit
      case 9
         MU->( ordSetFocus( "editor" ) )
         exit
      case 10
         MU->( ordSetFocus( "anoedic" ) )
         exit
      case 11
         MU->( ordSetFocus( "coleccion" ) )
         exit
      case 12
         MU->( ordSetFocus( "fchcompra" ) )
         exit
      case 13
         MU->( ordSetFocus( "fchprestamo" ) )
         exit
   end switch
   oBrw:refresh()
   RefreshCont( oCont, "MU", cContTitle )
return NIL

/*_____________________________________________________________________________*/

function MuTeclas( nKey, oBrw, oCont, nTabOpc, oDlg, cContTitle )
   switch nKey
      case VK_INSERT
         MuForm( oBrw, "add", oCont, cContTitle )
         exit
      case VK_RETURN
         MuForm( oBrw, "edt", oCont, cContTitle )
         exit
      case VK_DELETE
         MuBorrar( oBrw, oCont, cContTitle )
         exit
      case VK_ESCAPE
         oDlg:End()
         exit
      otherwise
         if nKey >= 97 .and. nKey <= 122
            nKey := nKey - 32
         endif
         if nKey >= 65 .and. nKey <= 90
            MuBuscar( oBrw, oCont, nTabOpc, chr( nKey ), cContTitle )
         endif
         exit
   end switch
return NIL

/*_____________________________________________________________________________*/

function MuImprimirJustif()
   local nRec    := MU->( recNo() )
   local oInforme

   oInforme := TInforme():New( {}, {}, {}, {}, {}, {}, "MU" )

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(MU->MuTitulo)
   oInforme:cTitulo2 := Rtrim("Justificante de préstamo del disco")
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

   ACTIVATE REPORT oInforme:oReport FOR MU->( recNo() ) == nRec ;
      ON INIT MuImprimirJustif2( oInforme:oReport, nRec )

   MU->( dbGoTo( nRec ) )
return NIL

/*_____________________________________________________________________________*/

function MuImprimirJustif2( oReport, nRec )

   MU->( dbGoTo( nRec ) )

   oReport:StartLine()
   oReport:Say( 1, i18n("Código:"), 1 )
   oReport:Say( 2, MU->MuCodigo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Título:"), 1 )
   oReport:Say( 2, MU->MuTitulo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Intérprete:"), 1 )
   oReport:Say( 2, MU->MuAutor        , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, "", 1 )
   oReport:Say( 2, "", 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Propietario:"), 1 )
   oReport:Say( 2, MU->MuPropiet       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fecha de Compra:"), 1 )
   oReport:Say( 2, MU->MuFchAdq            , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Este disco ha sido objeto del siguiente préstamo:"), 2 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Prestatario:"), 1 )
   oReport:Say( 2, MU->MuPrestad       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fecha de Préstamo:"), 1 )
   oReport:Say( 2, MU->MuFchPres             , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Firma del Prestatario:"), 2 )
   oReport:EndLine()

return NIL

/*_____________________________________________________________________________*/

function MuCdForm( oBrw, cCdMuCodigo, cCdMuTitulo, cCdMuInterp, cModo )

   local oDlg
   local aGet        := array(08)
   local aBtn        := array(03)

   local lIdOk       := .F.
   local nRecBrw     := CD->( recNo() )
   local nRecAdd
   local lDuplicado
   local lEditEx     := .F.
   local cCaption    := ""

   local cCdCaTitulo := ""
   local cCdCaAutor  := ""
   local cCdCaDuracc := ""
   local cCdOrden    := ""
   local cCdCaIdioma := ""

   if empty( cCdMuCodigo )
      msgStop( i18n( "Para introducir canciones en el disco debe primero asignarle un código." ) )
      return NIL
   endif

   cModo := lower( cModo )

   do case

      // nuevo
      case cModo == "add"
         cCaption := i18n( "Añadir una Canción a un Disco" )
         CD->( dbAppend() )
         replace CD->CdMuCodigo with cCdMuCodigo
         replace CD->CdMuTitulo with cCdMuTitulo
         replace CD->CdMuInterp with cCdMuInterp
         CD->( dbCommit() )
         nRecAdd := CD->( recNo() )

      // modificar
      case cModo == "edt"
         cCaption := i18n( "Modificar una Canción de un Disco" )

   end case

   // ambos casos
   cCdCaTitulo := CD->CdCaTitulo
   cCdCaAutor  := CD->CdCaAutor
   cCdCaDuracc := CD->CdCaDuracc
   cCdOrden    := CD->CdOrden
   cCdCaIdioma := CD->CdCaIdioma

   DEFINE DIALOG oDlg RESOURCE "CD_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE GET aGet[01] VAR cCdMuCodigo ID 100 OF oDlg PICTURE "@!" WHEN .f. //COLOR CLR_HBLUE, GetSysColor(15)
   REDEFINE GET aGet[02] VAR cCdMuTitulo ID 101 OF oDlg WHEN .f. //COLOR CLR_HBLUE, GetSysColor(15)
   REDEFINE GET aGet[03] VAR cCdMuInterp ID 102 OF oDlg WHEN .f. //COLOR CLR_HBLUE, GetSysColor(15)

   REDEFINE GET aGet[04] ;
      VAR cCdOrden ;
      ID 103 ;
      PICTURE "99" ;
      OF oDlg ;
      VALID ( cCdOrden := strZero( val( cCdOrden ), 2 ), aGet[04]:refresh(), .t. )

   REDEFINE GET aGet[05] ;
      VAR cCdCaTitulo ;
      ID 104 ;
      OF oDlg ;
      VALID ( CnClave( @cCdCaTitulo, aGet[05], "aux" ) )

   REDEFINE BUTTON aBtn[01];
      ID 109;
      OF oDlg;
      ACTION ( CnTabAux( @cCdCaTitulo, aGet[05],;
                         @cCdCaAutor , aGet[06],;
                         @cCdCaDuracc, aGet[07],;
                         @cCdCaIdioma, aGet[08] ),;
               aGet[05]:setFocus(),;
               SysRefresh() )

      aBtn[01]:cToolTip := i18n( "selecc. canción" )

   REDEFINE GET aGet[06] ;
      VAR cCdCaAutor ;
      ID 105 ;
      OF oDlg ;
      VALID ( AuClave( @cCdCaAutor, aGet[06], "aux", "C" ) )

   REDEFINE BUTTON aBtn[02];
      ID 110;
      OF oDlg;
      ACTION ( AuTabAux( @cCdCaAutor, aGet[06], "C" ),;
               aGet[06]:setFocus(),;
               SysRefresh() )

      aBtn[02]:cToolTip := i18n( "selecc. compositor" )

   REDEFINE GET aGet[07] ;
      VAR cCdCaDuracc ;
      ID 106 ;
      OF oDlg

   REDEFINE GET aGet[08] ;
      VAR cCdCaIdioma ;
      ID 107 ;
      OF oDlg ;
      VALID ( IdClave( @cCdCaIdioma, aGet[08], "aux" ) )

   REDEFINE BUTTON aBtn[03];
      ID 111;
      OF oDlg;
      ACTION ( IdTabAux( @cCdCaIdioma, aGet[08] ),;
               aGet[08]:setFocus(),;
               SysRefresh() )

      aBtn[03]:cToolTip := i18n( "selecc. idioma" )

   // REDEFINE BITMAP aBmp[01] ID 108 OF oDlg RESOURCE "CLIP_OFF" TRANSPARENT
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

      // añadir
      case cModo == "add"

         // aceptar
         if lIdOk

            replace CD->CdCaTitulo with cCdCaTitulo
            replace CD->CdCaAutor  with cCdCaAutor
            replace CD->CdCaDuracc with cCdCaDuracc
            replace CD->CdOrden    with cCdOrden
            replace CD->CdCaIdioma with cCdCaIdioma
            CD->( dbCommit() )
            nRecBrw := CD->( recNo() )

         // cancelar
         else

            CD->( dbGoTo( nRecAdd ) )
            CD->( dbDelete() )

         endif

      // modificar
      case cModo == "edt"

         // aceptar
         if lIdOk

            replace CD->CdCaTitulo with cCdCaTitulo
            replace CD->CdCaAutor  with cCdCaAutor
            replace CD->CdCaDuracc with cCdCaDuracc
            replace CD->CdOrden    with cCdOrden
            replace CD->CdCaIdioma with cCdCaIdioma
            CD->( dbCommit() )
            nRecBrw := CD->( recNo() )

         // cancelar
         else


         endif

   end case

   CD->( dbGoTo( nRecBrw ) )
   oBrw:refresh()
   oBrw:setFocus()

return NIL

/*_____________________________________________________________________________*/

function MuCdBorrar( oBrw )

   local nRecord := CD->( recNo() )
   local nNext   := 0

   if msgYesNo( i18n( "¿Está seguro de querer borrar esta canción de este disco?" + CRLF + CRLF ;
   + "'" + trim( CD->CdCaTitulo ) + i18n( "' de " ) + trim( CD->CdMuTitulo ) ) )
      CD->( dbSkip() )
      nNext := CD->( recNo() )
      CD->( dbGoto( nRecord ) )
      CD->( dbDelete() )
      CD->( dbGoto( nNext ) )
      if CD->( eof() ) .or. nNext == nRecord
         CD->( dbGoBottom() )
      endif
   endif

   oBrw:refresh()
   oBrw:setFocus()

return NIL

/*_____________________________________________________________________________*/

function MuDevolver()

   if MuDbfVacia()
      return NIL
   endif

   if !IsPrestado( "MU" )
      msgStop( i18n( "El disco seleccionado no está prestado." ) )
      return NIL
   endif

   if msgYesNo( i18n( "¿Desea anotar la devolución de este disco?" ) + CRLF + CRLF + ;
                i18n( trim( MU->MuTitulo ) ) )
      if NO->( dbSeek( "2" + MU->MuCodigo ) )
         replace MU->MuPrestad with ""
         replace MU->MuFchPres with cTOd( "" )
         MU->( dbCommit() )
         NO->( dbDelete() )
         NO->( dbCommit() )
      else
         msgAlert( i18n( "No se encontró el disco seleccionado en el fichero de préstamos. Por favor reindexe los ficheros." ) )
      endif

   endif

return NIL

/*_____________________________________________________________________________*/

function MuGetImagen( oImage1, oImage2, oGet, oBtn )

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

function Muximagen( cImagen, cTitulo )

   local oDlg
   local oImage

   if MuDbfVacia()
      return NIL
   endif

   if empty( rTrim( cImagen ) )
      msgAlert( i18n( "El disco no tiene asociada ninguna imagen." ) )
      return NIL
   endif

   if ! file( lfn2sfn( rTrim( cImagen ) ) )
      msgAlert( i18n( "No existe el fichero de imagen asociado al disco." ) + ;
              i18n( " Por favor revise la ruta y el nombre del fichero." ) )
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

function MuClave( cClave, oGet, cModo, cOldCod, oBrwCn )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "MU"
   local cMsgSi  := i18n( "Código de disco ya registrado." )
   local cMsgNo  := i18n( "Código de disco no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
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
      // actualización de canciones si hay cambio de código
      if cModo == "edt"
         if cClave != cOldCod
            CD->( ordSetFocus( "CdMuCodigo" ) )
            CD->( ordScope( 0, NIL ) )
            CD->( ordScope( 1, NIL ) )
            CD->( dbGoTop() )
            while ! CD->( eof() )
               if CD->CdMuCodigo == cOldCod
                  replace CD->CdMuCodigo with cClave
               endif
               CD->( dbSkip() )
            end while
            CD->( ordScope( 0, cClave ) )
            CD->( ordScope( 1, cClave ) )
            CD->( dbGoTop() )
            oBrwCn:refresh()
         endif
      endif
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

function MuImprimir( oBrw )
                 //  título                 campo         wd  shw  picture          tot
                 //  =====================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Código"       ), "MUCODIGO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Título"       ), "MUTITULO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Intérprete"   ), "MUAUTOR"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Género"       ), "MUMATERIA" ,  0, .t.,            "NO", .f. },;
                   { i18n("Idioma"       ), "MUIDIOMA"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Compositor"   ), "MUAUTOR2"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Director"     ), "MUDIRECTOR",  0, .t.,            "NO", .f. },;
                   { i18n("Propietario"  ), "MUPROPIET" ,  0, .t.,            "NO", .f. },;
                   { i18n("Ubicación"    ), "MUUBICACI" ,  0, .t.,            "NO", .f. },;
                   { i18n("Soporte"      ), "MUSOPTXT"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Productora"   ), "MUEDITOR"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Año Edic."    ), "MUANOEDIC" ,  0, .t.,            "NO", .f. },;
                   { i18n("Colección"    ), "MUCOLECC"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Nº Discos"    ), "MUNUMTOMOS",  0, .t.,     "@E 99,999", .f. },;
                   { i18n("Disco Nº"     ), "MUESTETOMO",  0, .t.,     "@E 99,999", .f. },;
                   { i18n("Fch.Compra"   ), "MUFCHADQ"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Centro Compra"), "MUPROVEED" ,  0, .t.,            "NO", .f. },;
                   { i18n("Precio"       ), "MUPRECIO"  ,  0, .t., "@E 999,999.99", .t. },;
                   { i18n("Fch.Préstamo" ), "MUFCHPRES" ,  0, .t.,            "NO", .f. },;
                   { i18n("Prestatario"  ), "MUPRESTAD" ,  0, .t.,            "NO", .f. },;
                   { i18n("Comentarios"  ), "MUOBSERV"  , 40, .t.,            "NO", .f. } }
   local nRecno   := MU->(Recno())
   local nOrder   := MU->(OrdSetFocus())
   local aCampos  := { "MUCODIGO", "MUTITULO", "MUAUTOR", "MUMATERIA", "MUIDIOMA",;
                       "MUAUTOR2", "MUDIRECTOR", "MUPROPIET", "MUUBICACI", "MUSOPTXT",;
                       "MUEDITOR", "MUANOEDIC", "MUCOLECC", "MUNUMTOMOS", "MUESTETOMO",;
                       "MUFCHADQ", "MUPROVEED", "MUPRECIO", "MUFCHPRES", "MUPRESTAD", "MUOBSERV" }
   local aTitulos := { "Código", "Título", "Intérprete", "Genero", "Idioma",;
                       "Compositor", "Director", "Propietario", "Ubicación", "Soporte",;
                       "Productora", "Año Edic.", "Colección", "Nº Discos", "Disco Nº",;
                        "Fch.Compra", "Centro Compra", "Precio", "Fch.Préstamo", "Prestatario", "Comentarios" }
   local aWidth   := { 10, 20, 20, 10, 10, 10, 10, 10, 10, 10,;
                       10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 }
   local aShow    := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t.,;
                       .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO",;
                       "NO", "NO", "NO", "@E 99,999", "@E 99,999", "NO", "NO", "@E 999,999.99", "NO", "NO", "NO" }

   local aTotal   := { .f., .f., .f., .f., .f., .f., .f., .f., .f., .f.,;
                       .f., .f., .f., .f., .f., .f., .f., .t., .f., .f., .f. }
   local oInforme
   local nAt
   local cAlias   := "MU"
   local cTotal   := "Total discos: "
   local aGet     := array(11)
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

   local aIn      := {}
   local cIn      := ""
   local nInOrd   := AU->( ordNumber() )
   local nInRec   := AU->( recNo() )

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
   local aSm      := {}
   local cSm      := ""
	local nSmOrd   := SM->( ordNumber() )
   local nSmRec   := SM->( recNo() )

   if MuDbfVacia()
      return NIL
   endif

   oApp():nEdit++

   SELECT MU  // imprescindible

   FillCmb( "MA", "mmateria"    , aMa, "MaMateria", nMaOrd, nMaRec, @cMa )
   FillCmb( "AG", "propietarios", aPr, "PeNombre" , nPrOrd, nPrRec, @cPr )
   FillCmb( "UB", "mubicacion"  , aUb, "UbUbicaci", nUbOrd, nUbRec, @cUb )
   FillCmb( "AU", "interpretes" , aIn, "AuNombre" , nInOrd, nInRec, @cIn )
   FillCmb( "CL", "codiscos"    , aCl, "ClNombre" , nClOrd, nClRec, @cCl )
   FillCmb( "ED", "eddiscos"    , aEd, "EdNombre" , nEdOrd, nEdRec, @cEd )
	FillCmb( "SM", "soporte"     , aSm, "SmSoporte", nSmOrd, nSmRec, @cSm )

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   REDEFINE SAY aSay[01] ID 200 OF oInforme:oFld:aDialogs[1]
   REDEFINE SAY aSay[02] ID 201 OF oInforme:oFld:aDialogs[1]

   REDEFINE RADIO oInforme:oRadio ;
      VAR oInforme:nRadio ;
      ID 100, 101, 103, 122, 105, 107, 109, 120, 111, 113, 116, 117, 119 ;
      OF oInforme:oFld:aDialogs[1]

   if !IsPrestado( "MU" )
      oInforme:oRadio:aItems[13]:disable() // justificante de préstamo
   endif

   REDEFINE COMBOBOX aGet[01] VAR cMa ITEMS aMa ID 102 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 2
   REDEFINE COMBOBOX aGet[02] VAR cPr ITEMS aPr ID 104 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 3
   REDEFINE COMBOBOX aGet[03] VAR cUb ITEMS aUb ID 123 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 4
   REDEFINE COMBOBOX aGet[04] VAR cIn ITEMS aIn ID 106 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 5
   REDEFINE COMBOBOX aGet[05] VAR cCl ITEMS aCl ID 108 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 6
   REDEFINE COMBOBOX aGet[06] VAR cEd ITEMS aEd ID 110 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 7
   REDEFINE COMBOBOX aGet[07] VAR cSm ITEMS aSm ID 121 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 8

   REDEFINE GET aGet[08] ;
      VAR nAno ;
      ID 112 ;
      OF oInforme:oFld:aDialogs[1] ;
      PICTURE "9999" ;
      WHEN oInforme:nRadio == 9

   REDEFINE GET aGet[09] ;
      VAR dFch1 ;
      ID 114 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 10

   REDEFINE BUTTON aBtn[01];
      ID 124;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch1, aGet[09] ),;
               aGet[09]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 10

      aBtn[01]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[10] ;
      VAR dFch2 ;
      ID 115 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 10

   REDEFINE BUTTON aBtn[02];
      ID 125;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch2, aGet[10] ),;
               aGet[10]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 10

      aBtn[02]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE CHECKBOX aGet[11] ;
      VAR lImg ;
      ID 118 ;
      OF oInforme:oFld:aDialogs[1] ;
      WHEN oInforme:nRadio == 12 .and. !empty( MU->MuImagen )

   oInforme:Folders()
   if oInforme:Activate()
      nRecno := MU->( recNo() )
      nOrder := MU->( ordNumber() )
      do case
         case oInforme:nRadio == 1
            // todos los discos, con el orden determinado
            MU->( dbGoTop() )
         case oInforme:nRadio == 2
            // discos de un género
            MU->( ordSetFocus( "materia" ) )
            MU->( ordScope( 0, upper( rTrim( cMa ) ) ) )
            MU->( ordScope( 1, upper( rTrim( cMa ) ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 3
            // discos de un propietario
            MU->( ordSetFocus( "propietario" ) )
            MU->( ordScope( 0, upper( rTrim( cPr ) ) ) )
            MU->( ordScope( 1, upper( rTrim( cPr ) ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 4
            // discos de una ubicación
            MU->( ordSetFocus( "ubicacion" ) )
            MU->( ordScope( 0, upper( rTrim( cUb ) ) ) )
            MU->( ordScope( 1, upper( rTrim( cUb ) ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 5
            // discos de un intérprete
            MU->( ordSetFocus( "interprete" ) )
            MU->( ordScope( 0, upper( rTrim( cIn ) ) ) )
            MU->( ordScope( 1, upper( rTrim( cIn ) ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 6
            // discos de una colección
            MU->( ordSetFocus( "coleccion" ) )
            MU->( ordScope( 0, upper( rTrim( cCl ) ) ) )
            MU->( ordScope( 1, upper( rTrim( cCl ) ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 7
            // discos de una productora
            MU->( ordSetFocus( "editor" ) )
            MU->( ordScope( 0, upper( rTrim( cEd ) ) ) )
            MU->( ordScope( 1, upper( rTrim( cEd ) ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 8
            // discos de un soporte
            MU->( ordSetFocus( "soporte" ) )
            MU->( ordScope( 0, aScan( aSm, cSm ) ) )
            MU->( ordScope( 1, aScan( aSm, cSm ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 9
            // discos editados en un año
            MU->( ordSetFocus( "anoedic" ) )
            MU->( ordScope( 0, str( nAno, 4 ) ) )
            MU->( ordScope( 1, str( nAno, 4 ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 10
            // discos comprados en un periodo
            MU->( ordSetFocus( "fchcompra" ) )
            MU->( ordScope( 0, dTOs( dFch1 ) ) )
            MU->( ordScope( 1, dTOs( dFch2 ) ) )
            MU->( dbGoTop() )
         case oInforme:nRadio == 11
            // discos prestados
            MU->( ordSetFocus( "prestados" ) )
            MU->( dbGoTop() )
         // ficha completa del discos seleccionado
         case oInforme:nRadio == 12
            MuImprimirFicha( oInforme, lImg )
         // justificante de préstamo del discos seleccionado
         case oInforme:nRadio == 13
            MuImprimirJustif()
      end case
      if oInforme:nRadio < 12
         Select MU
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
                     oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
                     oInforme:oReport:EndLine() )
      endif
      oInforme:End(.t.)

      MU->( ordScope( 0, NIL ) )
      MU->( ordScope( 1, NIL ) )
      MU->(DbSetOrder(nOrder))
      MU->(DbGoTo(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .t. )
   oApp():nEdit --
return NIL

/*_____________________________________________________________________________*/

function MuDbfVacia()

   local lReturn := .f.

   if MU->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún disco registrado." ) )
      lReturn := .t.
   endif

return lReturn

/*_____________________________________________________________________________*/

function MuImprimirFicha( oInforme, lImg )
   local nRec  := MU->( recNo() )
   local i     := 0

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(MU->MuTitulo)
   oInforme:cTitulo2 := Rtrim("Ficha del disco")

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
      COLUMN TITLE " " DATA " " SIZE  3
      COLUMN TITLE " " DATA " " SIZE 25
      COLUMN TITLE " " DATA " " SIZE 12
      COLUMN TITLE " " DATA " " SIZE 13
      COLUMN TITLE " " DATA " " SIZE  5
      COLUMN TITLE " " DATA " " SIZE 10
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

   ACTIVATE REPORT oInforme:oReport FOR MU->( recNo() ) == nRec ;
      ON INIT MuImprimirFicha2( oInforme:oReport, nRec, lImg )

   MU->( dbGoTo( nRec ) )

return NIL

/*_____________________________________________________________________________*/

function MuImprimirFicha2( oReport, nRec, lImg )

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

   MU->( dbGoTo( nRec ) )

   cBmpFile := MU->MuImagen
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
   oReport:Say( 2, MU->MuCodigo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Título:")    , 2 )
   oReport:Say( 2, MU->MuTitulo       , 1 )
   oReport:Say( 4, i18n("Intérprete:"), 2 )
   oReport:Say( 5, MU->MuAutor        , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Género:"), 2 )
   oReport:Say( 2, MU->MuMateria  , 1 )
   oReport:Say( 4, i18n("Idioma:"), 2 )
   oReport:Say( 5, MU->MuIdioma   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Propietario:"), 2 )
   oReport:Say( 2, MU->MuPropiet       , 1 )
   oReport:Say( 4, i18n("Ubicación:")  , 2 )
   oReport:Say( 5, MU->MuUbicaci       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Compositor:"), 2 )
   oReport:Say( 2, MU->MuAutor2       , 1 )
   oReport:Say( 4, i18n("Director:")  , 2 )
   oReport:Say( 5, MU->MuDirector     , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Productora:"), 2 )
   oReport:Say( 2, MU->MuEditor       , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Año Edición:")    , 2 )
   oReport:Say( 2, MU->MuAnoEdic           , 1 )
   oReport:Say( 4, i18n("Soporte:")        , 2 )
   oReport:Say( 5, MU->MuSopTxt, 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Colección:"), 2 )
   oReport:Say( 2, MU->MuColecc      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Nº Discos:"), 2 )
   oReport:Say( 2, MU->MuNumTomos    , 1 )
   oReport:Say( 4, i18n("Disco Nº:") , 2 )
   oReport:Say( 5, MU->MuEsteTomo    , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Centro Compra:"), 2 )
   oReport:Say( 2, MU->MuProveed         , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Fch. Compra:"), 2 )
   oReport:Say( 2, MU->MuFchAdq        , 1 )
   oReport:Say( 4, i18n("Precio:")     , 2 )
   oReport:Say( 5, MU->MuPrecio        , 1 )
   oReport:EndLine()

   // canciones
   CD->( ordSetFocus( "CdMuCodigo" ) )
   if CD->( dbSeek( MU->MuCodigo ) )
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 1, i18n("Canciones"), 2 )
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 2, i18n("Nº")        , 2 )
      oReport:Say( 3, i18n("Título")    , 2 )
      oReport:Say( 4, i18n("Compositor"), 2 )
      oReport:Say( 6, i18n("Durac.")    , 2 )
      oReport:Say( 7, i18n("Idioma")    , 2 )
      oReport:EndLine()
      CD->( ordScope( 0, MU->MuCodigo ) )
      CD->( ordScope( 1, MU->MuCodigo ) )
      CD->( dbGoTop() )
      while ! CD->( eof() )
         oReport:StartLine()
         oReport:Say( 2, CD->CdOrden   , 1 )
         oReport:Say( 3, CD->CdCaTitulo, 1 )
         oReport:Say( 4, CD->CdCaAutor , 1 )
         oReport:Say( 6, CD->CdCaDuracc, 1 )
         oReport:Say( 7, CD->CdCaIdioma, 1 )
         oReport:EndLine()
         CD->( dbSkip() )
      end while
      CD->( ordScope( 0, NIL ) )
      CD->( ordScope( 1, NIL ) )

   endif

   if !empty( MU->MuObserv )
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 1, i18n("Comentarios"), 2 )
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      nLines := mlCount( MU->MuObserv, 90 )
      for i := 1 to nLines
         oReport:StartLine()
         oReport:Say( 2, memoLine( MU->MuObserv, 90, i ), 1 )
         oReport:EndLine()
      next
   endif

return NIL
