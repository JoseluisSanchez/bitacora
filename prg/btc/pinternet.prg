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

function Internet()

   local oBar
   local oCol
   local oCont
	local cTitle 	  := "Internet"
	local cContTitle := cTitle+": "
	local oClp

   local cBrwState := GetIni( , "Browse", "InAbm-State", "" )
   local nBrwSplit := val( GetIni( , "Browse", "InAbm-Split", "102" ) )
   local nBrwRecno := val( GetIni( , "Browse", "InAbm-Recno", "1" ) )
   local nBrwOrder := val( GetIni( , "Browse", "InAbm-Order", "1" ) )

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   IN->( dbGoTop() )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Direcciones de Internet" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "IN"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || IN->inCodigo }
   oCol:cHeader  := i18n( "Código" )
   oCol:nWidth   := 70

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || IN->inNombre }
   oCol:cHeader  := i18n( "Título" )
   oCol:nWidth   := 139

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || IN->inMateria }
   oCol:cHeader  := i18n( "Materia" )
   oCol:nWidth   := 170

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || IN->inDirecc }
   oCol:cHeader  := i18n( "Dirección web" )
   oCol:nWidth   := 157

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( IN->inDiseno, 1 ) }
   oCol:cHeader  := i18n( "V.Diseño" )
   oCol:nWidth   := 23

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( IN->inConteni, 1 ) }
   oCol:cHeader  := i18n( "V.Contenido" )
   oCol:nWidth   := 23

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || str( IN->inValorac, 1 ) }
   oCol:cHeader  := i18n( "V.Global" )
   oCol:nWidth   := 24

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || IN->inIdiomaC }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 70

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || dTOc( IN->inFchVis ) }
   oCol:cHeader  := i18n( "Fch.Visita" )
   oCol:nWidth   := 59

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || IN->inEmail }
   oCol:cHeader  := i18n( "E-mail" )
   oCol:nWidth   := 130

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || IN->inServic }
   oCol:cHeader  := i18n( "Servicio" )
   oCol:nWidth   := 46

   aEval( oApp():oGrid:aCols, { |oCol| oCol:bLDClickData := { || InForm( oApp():oGrid, "edt", oCont, cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := { || RefreshCont( oCont, "IN", cContTitle ) }
   oApp():oGrid:bKeyDown   := { |nKey| InTeclas( nKey, oApp():oGrid, oCont, oApp():oTab:nOption, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21

   DEFINE CLIPBOARD oClp OF oApp():oDlg

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 175 OF oApp():oDlg ;
		COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(IN->(OrdKeyNo()),'@E 999,999')+" / "+tran(IN->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_INTERNET"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nueva")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( InForm( oApp():oGrid, "add", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( InForm( oApp():oGrid, "edt", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( InForm( oApp():oGrid, "dup", oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( InBorrar( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( InBuscar( oApp():oGrid, oCont, oApp():oTab:nOption, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( InImprimir( oApp():oGrid ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Copiar dirección")  ;
      IMAGE "16_copiar"             ;
      ACTION ( if( !InDbfVacia(), InCopy( oApp():oGrid, oClp ), oApp():oGrid:setFocus() ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Visitar sitio web")  ;
      IMAGE "16_internet"             ;
      ACTION ( if( !InDbfVacia(), GoWeb( IN->InDirecc ), oApp():oGrid:setFocus() ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Enviar e-mail")      ;
      IMAGE "16_email"          ;
      ACTION ( if( !InDbfVacia(), GoMail( IN->InEmail ), oApp():oGrid:setFocus() ) ) ;
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
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "InAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ 180, 05 VMENU oBar SIZE nBrwSplit-10, 150 OF oApp():oDlg  ;
      COLOR CLR_BLACK, GetSysColor(15)       ;
		HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oBar;
      CAPTION i18n("Importar y Exportar");
      HEIGHT 25 ;
		COLOR GetSysColor(9), oApp():nClrBar 	

   DEFINE VMENUITEM OF oBar  ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oBar ;
      CAPTION i18n("Exportar a archivo .BTC") ;
      IMAGE "16_EXPORT"             ;
      ACTION ( InExport(), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar ;
      CAPTION i18n("Importar desde archivo .BTC") ;
      IMAGE "16_IMPORT"             ;
      ACTION ( InImport( oApp():oDlg, oApp():oGrid ) ) ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
     OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
     ITEMS " "+i18n("Título")+" "   , " "+i18n("Código")+" "    , " "+i18n("Materia")+" "    ,;
           " "+i18n("Dirección")+" ", " "+i18n("V.Diseño")+" "  , " "+i18n("V.Contenido")+" ",;
           " "+i18n("V.Global")+" " , " "+i18n("Fch.Visita")+" ", " "+i18n("Servicio")+" "    ;
     COLOR CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
     ACTION ( InTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, oBar )

   if nBrwRecno <= IN->( ordKeyCount() )
      IN->( dbGoTo( nBrwRecno ) )
   endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      ON INIT ( ResizeWndMain(),;
					 InTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ),;
                oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
              SetIni( , "Browse", "InAbm-State", oApp():oGrid:SaveState() ),;
              SetIni( , "Browse", "InAbm-Order", oApp():oTab:nOption ),;
              SetIni( , "Browse", "InAbm-Recno", IN->( recNo() ) ),;
              SetIni( , "Browse", "InAbm-Split", lTrim( str( oApp():oSplit:nleft / 2 ) ) ),;
              oBar:End(), oBar:End(), oCont:End(), dbCloseAll(),;
              oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .t. )

return nil

/*_____________________________________________________________________________*/

function InForm( oBrw, cModo, oCont, cContTitle )

   local oDlg
   local oFld
   local aGet       := array(12)
   local aBtn       := array(06)
   local aBmp       := array(01)

   local cCaption   := ""
   local lIdOk      := .F.
   local nRecBrw    := IN->( recNo() )
   local nRecAdd    := 0
   local aServic    := { i18n("web"), i18n("ftp"), i18n("e-mail"), i18n("news"), i18n("gopher"), i18n("archie") }

   local cInCodigo  := ""
   local cInNombre  := ""
   local cIndirecc  := ""
   local cInIdiomaC := ""
   local cInmateria := ""
   local nServic    := 0
   local nInDiseno  := 0
   local nInConteni := 0
   local nInValorac := 0
   local dInFchVis  := date()
   local cInEmail   := ""
   local mIndescri

   if cModo == "edt" .or. cModo == "dup"
      if InDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if IN->( eof() ) .and. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   cModo := lower( cModo )

   do case
      // nuevo
      case cModo == "add"
         cCaption := i18n( "Añadir una Dirección de Internet" )
         IN->( dbAppend() )
         replace IN->InDiseno  with 1
         replace IN->InConteni with 1
         replace IN->InValorac with 1
         replace IN->InFchVis  with date()
         IN->( dbCommit() )
         nRecAdd := IN->( recNo() )
      // modificar
      case cModo == "edt"
         cCaption := i18n( "Modificar una Dirección de Internet" )
      // duplicar
      case cModo == "dup"
         cCaption := i18n( "Duplicar una Dirección de Internet" )
   end case

   // ambos casos
   cInCodigo  := IN->InCodigo
   cInNombre  := IN->InNombre
   cIndirecc  := IN->Indirecc
   cInmateria := IN->Inmateria
   cInIdiomaC := IN->InIdiomaC
   mIndescri  := IN->Indescri
   nInDiseno  := Iif( IN->InDiseno  > 0, IN->InDiseno , 1 )
   nInConteni := Iif( IN->InConteni > 0, IN->InConteni, 1 )
   nInValorac := Iif( IN->InValorac > 0, IN->InValorac, 1 )
   dInFchVis  := IN->InFchVis
   cInEmail   := IN->InEmail
   nServic    := max( aScan( aServic, IN->InServic ), 1 )

   do case
      case cModo == "add" .and. oApp():lCodAut
         GetNewCod( .f., "IN", "InCodigo", @cInCodigo )
      case cModo == "dup"
         if oApp():lCodAut
            GetNewCod( .f., "IN", "InCodigo", cInCodigo )
         else
            cInCodigo := space( 10 )
         endif
   end case

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "IN_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE GET aGet[01] ;
      VAR cInNombre ;
      ID 100 ;
      OF oDlg

   REDEFINE GET aGet[02] ;
      VAR cInCodigo ;
      ID 101 ;
      OF oDlg ;
      VALID ( InClave( cInCodigo, aGet[02], cModo ) )

   REDEFINE BUTTON aBtn[01];
      ID 118;
      OF oDlg;
      ACTION ( GetNewCod( .t., "IN", "InCodigo", @cInCodigo ), aGet[02]:refresh(), aGet[02]:setFocus() )

      aBtn[01]:cToolTip := i18n( "generar código autonumérico" )

   REDEFINE GET aGet[03] ;
      VAR cIndirecc ;
      ID 102 ;
      OF oDlg

   REDEFINE BUTTON aBtn[02];
      ID 119;
      OF oDlg;
      ACTION ( GoWeb( cIndirecc ) )

      aBtn[02]:cToolTip := i18n( "visitar web" )

   REDEFINE RADIO aGet[04] ;
      VAR nServic ;
      ID 103, 104, 105, 106, 107, 108 ;
      OF oDlg

   REDEFINE AUTOGET aGet[05] 	;
      VAR cInIdiomaC          ;
      DATASOURCE {}						;
      FILTER IdList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 109                  ;
      OF oDlg                 ;
      VALID ( IdClave( @cInIdiomaC, aGet[05], "aux" ) )

   REDEFINE BUTTON aBtn[03];
      ID 120;
      OF oDlg;
      ACTION ( IdTabAux( @cInIdiomaC, aGet[05] ),;
               aGet[05]:setFocus(),;
               SysRefresh() )

      aBtn[03]:cToolTip := i18n( "selecc. idioma" )

   REDEFINE AUTOGET aGet[06] 	;
      VAR cInMateria          ;
      DATASOURCE {}						;
      FILTER MaListI( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 110                  ;
      OF oDlg                 ;
      VALID ( MaClave( @cInMateria, aGet[06], "aux", "I" ) )

   REDEFINE BUTTON aBtn[04];
      ID 121;
      OF oDlg;
      ACTION ( MaTabAux( @cInMateria, aGet[06], "I" ),;
               aGet[06]:setFocus(),;
               SysRefresh() )

      aBtn[04]:cToolTip := i18n( "selecc. materia" )

   REDEFINE GET aGet[07] ;
      VAR dInFchVis ;
      ID 111 ;
      OF oDlg

   REDEFINE BUTTON aBtn[05];
      ID 122;
      OF oDlg;
      ACTION ( SelecFecha( dInFchVis, aGet[07] ),;
               aGet[07]:setFocus(),;
               SysRefresh() )

      aBtn[05]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[08] ;
      VAR nInDiseno ;
      ID 112 ;
      OF oDlg ;
      SPINNER ;
      MIN 1 ;
      MAX 5 ;
      PICTURE "9" ;
      VALID ( nInDiseno > 0 .and. nInDiseno < 6 )

   REDEFINE GET aGet[09] ;
      VAR nInConteni ;
      ID 113 ;
      OF oDlg ;
      SPINNER ;
      MIN 1 ;
      MAX 5 ;
      PICTURE "9" ;
      VALID ( nInConteni > 0 .and. nInConteni < 6 )

   REDEFINE GET aGet[10] ;
      VAR nInValorac ;
      ID 114 ;
      OF oDlg ;
      SPINNER ;
      MIN 1 ;
      MAX 5 ;
      PICTURE "9" ;
      VALID ( nInValorac > 0 .and. nInValorac < 6 )

   REDEFINE GET aGet[11] ;
      VAR cInEmail ;
      ID 115 ;
      OF oDlg

   REDEFINE BUTTON aBtn[06];
      ID 123;
      OF oDlg;
      ACTION ( GoMail( cInEmail ) )

      aBtn[06]:cToolTip := i18n( "selecc. e-mail" )

   REDEFINE GET aGet[12] ;
      VAR mInDescri ;
      ID 116 ;
      OF oDlg ;
      MEMO

   // REDEFINE BITMAP aBmp[01] ID 117 OF oDlg RESOURCE "CLIP_OFF" TRANSPARENT
   // aEval( aGet, { |oGet| oGet:bChange := { || ( aBmp[01]:reload( "CLIP_ON" ), aBmp[01]:refresh() ) } } )

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlg ;
      ACTION ( if( eval( aGet[02]:bValid ), ( lIdOk := .T., oDlg:end() ), ) )

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

            // alta de la dirección
            IN->( dbGoTo( nRecAdd ) )
            replace In->InCodigo  with cInCodigo
            replace In->InNombre  with cInnombre
            replace In->Indirecc  with cIndirecc
            replace In->Inmateria with cInmateria
            replace In->InIdiomaC with cInIdiomaC
            replace In->Indescri  with mIndescri
            replace In->Indiseno  with nInDiseno
            replace In->InValorac with nInValorac
            replace In->InConteni with nInConteni
            replace In->InFchVis  with dInFchVis
            replace IN->InEmail   with cInEmail
            replace IN->InServic  with aServic[nServic]
            IN->( dbCommit() )
            nRecBrw := IN->( recNo() )

            // incremento del nº de ejemplares en materias
            if MA->( dbSeek( "I" + upper( cInMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               MA->( dbCommit() )
            endif

         // cancelar
         else

            IN->( dbGoTo( nRecAdd ) )
            IN->( dbDelete() )

         endif

      // modificar
      case cModo == "edt"

         // aceptar
         if lIdOk == .T.

            // modificación del nº de ejemplares en materias
            if ( IN->InMateria != cInMateria )
               do case
                  case ( MA->( dbSeek( "I" + upper( IN->InMateria ) ) ) )
                     MA->( dbSeek( "I" + upper( cInMateria ) ) ) // ¿sobra?
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
                     MA->( dbSeek( "I" + upper( IN->InMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
                     MA->( dbCommit() )
                  case ( empty( IN->InMateria ) )
                     MA->( dbSeek( "I" + upper( cInMateria ) ) )
                     replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               end case
            endif

            IN->( dbGoTo( nRecBrw ) )
            replace In->InCodigo  with cInCodigo
            replace In->Innombre  with cInnombre
            replace In->Indirecc  with cIndirecc
            replace In->Inmateria with cInmateria
            replace In->InIdiomaC with cInIdiomaC
            replace IN->InServic  with aServic[nServic]
            replace In->Indescri  with mIndescri
            replace In->Indiseno  with nInDiseno
            replace In->InValorac with nInValorac
            replace In->InConteni with nInConteni
            replace In->InFchVis  with dInFchVis
            replace IN->InEmail   with cInEmail
            IN->( dbCommit() )

         // cancelar
         else

         endif

      // duplicar
      case cModo == "dup"

         // aceptar
         if lIdOk == .T.

            // duplicado de la dirección
            IN->( dbAppend() )
            replace In->InCodigo  with cInCodigo
            replace In->InNombre  with cInnombre
            replace In->Indirecc  with cIndirecc
            replace In->Inmateria with cInmateria
            replace In->InIdiomaC with cInIdiomaC
            replace In->Indescri  with mIndescri
            replace In->Indiseno  with nInDiseno
            replace In->InValorac with nInValorac
            replace In->InConteni with nInConteni
            replace In->InFchVis  with dInFchVis
            replace IN->InEmail   with cInEmail
            replace IN->InServic  with aServic[nServic]
            IN->( dbCommit() )
            nRecBrw := IN->( recNo() )

            // incremento del nº de ejemplares en materias
            if MA->( dbSeek( "I" + upper( cInMateria ) ) )
               replace MA->MaNumlibr with ( MA->MaNumlibr ) + 1
               MA->( dbCommit() )
            endif

         // cancelar
         else


         endif

   end case

   IN->( dbGoTo( nRecBrw ) )
   if oCont != nil
      RefreshCont( oCont, "IN", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil

/*_____________________________________________________________________________*/

function InBorrar( oBrw, oCont, cContTitle )

   local nRecord := IN->( recNo() )
   local nNext   := 0

   if InDbfVacia()
      return nil
   endif

   if msgYesNo( i18n( "¿Está seguro de querer borrar esta dirección?" ) +CRLF+CRLF ;
   + trim( IN->InNombre ) )
      IN->( dbSkip() )
      nNext := IN->( recNo() )
      IN->( dbGoto( nRecord ) )
      if MA->( dbSeek( "I" + upper( IN->InMateria ) ) )
         replace MA->MaNumlibr with ( MA->MaNumlibr ) - 1
      endif
      IN->( dbDelete() )
      IN->( dbGoto( nNext ) )
      if IN->( eof() ) .or. nNext == nRecord
         IN->( dbGoBottom() )
      endif
   endif

   if oCont != nil
      RefreshCont( oCont, "IN", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function InBuscar( oBrw, oCont, nTabOpc, cChr, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local nRecNo   := IN->( recNo() )
   local lIdOk    := .f.
   local lFecha   := .f.
   local aBrowse  := {}

   if InDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch nTabOpc
      case 1
         cPrompt := i18n( "Introduzca el Título de la Dirección" )
         cField  := i18n( "Título:" )
         cGet    := space( 60 )
         exit
      case 2
         cPrompt := i18n( "Introduzca el Código de la Dirección" )
         cField  := i18n( "Código:" )
         cGet    := space( 10 )
         exit
      case 3
         cPrompt := i18n( "Introduzca la Materia de la Dirección" )
         cField  := i18n( "Materia:" )
         cGet    := space( 30 )
         exit
      case 4
         cPrompt := i18n( "Introduzca la Dirección web" )
         cField  := i18n( "Dirección:" )
         cGet    := space( 60 )
         exit
      case 5
         cPrompt := i18n( "Introduzca la Valoración de Diseño de la Dirección" )
         cField  := i18n( "V. Diseño:" )
         cGet    := space( 1 )
         exit
      case 6
         cPrompt := i18n( "Introduzca la Valoración de Contenido de la Dirección" )
         cField  := i18n( "V. Contenido:" )
         cGet    := space( 1 )
         exit
      case 7
         cPrompt := i18n( "Introduzca la Valoración Global de la Dirección" )
         cField  := i18n( "V. Global:" )
         cGet    := space( 1 )
         exit
      case 8
         cPrompt := i18n( "Introduzca la Fecha de Visita de la Dirección" )
         cField  := i18n( "Fecha de Visita:" )
         cGet    := cTOd( "" )
         exit
      case 9
         cPrompt := i18n( "Introduzca el Servicio de la Dirección" )
         cField  := i18n( "Servicio:" )
         cGet    := space( 06 )
         exit
   end switch

   lFecha := valType( cGet ) == "D"

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "DLG_BUSCAR" TITLE i18n( "Búsqueda de Direcciones" )
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
      ON INIT ( oDlg:Center( oApp():oWndMain ) )

   if lIdOk
      if ! lFecha
         cGet := rTrim( upper( cGet ) )
      else
         cGet := dTOs( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
            { || InWildSeek(nTabOpc, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop(i18n("No se ha encontrado ninguna dirección de internet."))
      else
         InEncontrados(aBrowse, oApp():oDlg)
      endif
   endif
   InTabs( oBrw, nTabOpc, oCont, cContTitle)
   RefreshCont( oCont, "IN", cContTitle )
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return NIL
/*_____________________________________________________________________________*/
function InWildSeek(nTabOpc, cGet, aBrowse)
   local nRecno   := IN->(Recno())

   do case
      case nTabOpc == 1
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ upper(In->InNombre)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 2
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ upper(In->InCodigo)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 3
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ upper(In->InMateria)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 4
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ upper(In->InDirecc)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 5
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ STR(In->InDiseno,1)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 6
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ STR(In->InConteni,1)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 7
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ STR(In->InValorac,1)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 8
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ dTOs(In->InFchVis)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
      case nTabOpc == 9
         IN->(DbGoTop())
         do while ! IN->(eof())
            if cGet $ upper(In->InServic)
               aadd(aBrowse, {IN->InNombre, IN->InMateria, IN->InDirecc, IN->(RecNo())})
            endif
            IN->(DbSkip())
         enddo
   end case
   IN->(DbGoTo(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[1]) < upper(aAut2[1]) } )
return nil
/*_____________________________________________________________________________*/
function InEncontrados(aBrowse, oParent)
   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := IN->(Recno())

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
   IN->(OrdSetFocus("titulo"))
   IN->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1])))
   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||IN->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                           InForm(oBrowse,"edt",,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(IN->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])),;
                                                     InForm(oBrowse,"edt",,oDlg)),) }
   oBrowse:bChange    := { || IN->(DbGoTo(aBrowse[oBrowse:nArrayAt, 4])) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (IN->(DbGoTo(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function InTabs( oBrw, nOpc, oCont, cContTitle )

   switch nOpc
      case 1
         IN->( ordSetFocus( "titulo" ) )
         exit
      case 2
         IN->( ordSetFocus( "codigo" ) )
         exit
      case 3
         IN->( ordSetFocus( "materia" ) )
         exit
      case 4
         IN->( ordSetFocus( "direccion" ) )
         exit
      case 5
         IN->( ordSetFocus( "vdiseno" ) )
         exit
      case 6
         IN->( ordSetFocus( "vcontenido" ) )
         exit
      case 7
         IN->( ordSetFocus( "vglobal" ) )
         exit
      case 8
         IN->( ordSetFocus( "fchvisita" ) )
         exit
      case 9
         IN->( ordSetFocus( "servicio" ) )
         exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "IN", cContTitle )

return nil

/*_____________________________________________________________________________*/

function InTeclas( nKey, oBrw, oCont, nTabOpc, oDlg, cContTitle )

   switch nKey
      case VK_INSERT
         InForm( oBrw, "add", oCont, cContTitle )
         exit
      case VK_RETURN
         InForm( oBrw, "edt", oCont, cContTitle )
         exit
      case VK_DELETE
         InBorrar( oBrw, oCont, cContTitle )
         exit
      case VK_ESCAPE
         oDlg:End()
         exit
      otherwise
         if nKey >= 97 .and. nKey <= 122
            nKey := nKey - 32
         endif
         if nKey >= 65 .and. nKey <= 90
            InBuscar( oBrw, oCont, nTabOpc, chr( nKey ), cContTitle )
         endif
         exit
   end switch

return nil

/*_____________________________________________________________________________*/

function InClave( cClave, oGet, cModo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "IN"
   local cMsgSi  := i18n( "Código de dirección de internet ya registrado." )
   local cMsgNo  := i18n( "Código de dirección de internet no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
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

function InExport()

   local oDlgOpt
   local aGet       := array(06)
   local aBtn       := array(02)

   local nRad       := 1
   local cInMateria := ""
   local dInicio    := cTOd("")
   local dFinal     := cTOd("")
   local cDescri    := space(40)
   local cArchiv    := space(90)

   local aMaterias  := {}
   local lIdOk      := .t.

   local oDlgMtr
   local aSay       := array( 02 )
   local oBmp
   local oMeter

   local nVar       := 1

   local nInOrd     := IN->( ordNumber() )
   local nInRec     := IN->( recNo() )

   if InDbfVacia()
      return nil
   endif

   oApp():nEdit++

   msgRun( i18n( "Preparando la exportación. Espere un momento..." ), oApp():cAppName, ;
          { || FillCmb( "MA", "imateria", aMaterias, "MaMateria",,, @cInMateria ) } )

   DEFINE DIALOG oDlgOpt ;
      OF oApp():oDlg ;
      RESOURCE "IN_EXPORTAR" ;
      TITLE i18n( "Exportar Direcciones de Internet" )
   oDlgOpt:SetFont(oApp():oFont)

   REDEFINE RADIO aGet[01] ;
      VAR nRad ;
      ID 100, 101, 103 ;
      OF oDlgOpt

   REDEFINE COMBOBOX aGet[02] ;
      VAR cInMateria ;
      ITEMS aMaterias ;
      ID 102 ;
      OF oDlgOpt ;
      WHEN nRad == 2

   REDEFINE GET aGet[03] ;
      VAR dInicio ;
      ID 104 ;
      OF oDlgOpt;
      WHEN nRad == 3 ;

   REDEFINE BUTTON aBtn[01];
      ID 108;
      OF oDlgOpt;
      WHEN nRad == 3 ;
      ACTION ( SelecFecha( dInicio, aGet[03] ),;
               aGet[03]:setFocus(),;
               SysRefresh() )

      aBtn[01]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[04] ;
      VAR dFinal ;
      ID 105 ;
      OF oDlgOpt;
      WHEN nRad == 3 ;

   REDEFINE BUTTON aBtn[02];
      ID 109;
      OF oDlgOpt;
      WHEN nRad == 3 ;
      ACTION ( SelecFecha( dFinal, aGet[04] ),;
               aGet[04]:setFocus(),;
               SysRefresh() )

      aBtn[02]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[06] VAR cArchiv ID 106 OF oDlgOpt ;
      VALID ValEmpty( cArchiv, aGet[06] ) ;

   REDEFINE GET aGet[05] VAR cDescri ID 107 OF oDlgOpt MEMO

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlgOpt ;
      ACTION ( if( eval( aGet[06]:bValid ), ( lIdOk := .T., oDlgOpt:end() ), ) )

   REDEFINE BUTTON ;
      ID IDCANCEL ;
      OF oDlgOpt ;
      CANCEL ;
      ACTION ( lIdOk := .F., oDlgOpt:end() )

   ACTIVATE DIALOG oDlgOpt CENTERED

   if lIdOk

      DEFINE DIALOG oDlgMtr OF oApp():oDlg RESOURCE "UT_INDEXAR";
         TITLE oApp():cAppName
      oDlgMtr:SetFont(oApp():oFont)

      REDEFINE BITMAP oBmp ID 111 OF oDlgMtr RESOURCE "BB_INTERNET" TRANSPARENT

      REDEFINE SAY aSay[01] ID  99 OF oDlgMtr PROMPT i18n( "Exportando direcciones..." )
      REDEFINE SAY aSay[02] ID 100 OF oDlgMtr PROMPT ""

      oMeter := TProgress():Redefine( 101, oDlgMtr )

      oDlgMtr:bStart := { || SysRefresh(), InExport2( oMeter, nVar, nRad, cInMateria, dInicio, dFinal, cDescri, cArchiv ), oDlgMtr:End() }

      ACTIVATE DIALOG oDlgMtr ;
      ON INIT oDlgMtr:Center( oApp():oWndMain )

      msgInfo( i18n( "La exportación se realizó correctamente." ) + CRLF + CRLF + ;
               i18n( "El fichero generado es:" ) + CRLF + CRLF + ;
                     lower( oApp():cBtcPath ) + rTrim( cArchiv ) + ".BTC" )

   endif

   IN->( ordSetFocus( nInOrd ) )
   IN->( dbGoTo( nInRec ) )

   oApp():nEdit--

return nil

/*_____________________________________________________________________________*/

function InExport2( oMeter, nVar, nRad, cInMateria, dInicio, dFinal, cDescri, cArchiv )

   local lExport
   local cMemo

   oMeter:setRange( 0, IN->( lastRec() ) )
   oMeter:setPos( 0 )
   SysRefresh()

   SELECT MD
   ZAP
   MD->( dbAppend() )
   replace MD->Linea with "0" + rTrim( cDescri )
   MD->( dbCommit() )

   IN->( dbGoTop() )
   while ! IN->( eof() )
      lExport := .F.
      switch nRad
         case 1
            lExport := .T.
            exit
         case 2
            if IN->InMateria == cInMateria
               lExport := .T.
            endif
            exit
         case 3
            if dInicio <= IN->InFchVis .and. IN->InFchVis <= dFinal
               lExport := .T.
            endif
            exit
      end switch
      if lExport
         MD->( dbAppend() )
         replace MD->Linea with "1" + IN->InNombre
         MD->(DbAppend())
         replace MD->Linea with "2" + IN->InDirecc
         MD->(DbAppend())
         replace MD->Linea with "3" + str( IN->InIdioma, 1 )
         MD->(DbAppend())
         replace MD->Linea with "4" + IN->InOtroid
         MD->(DbAppend())
         replace MD->Linea with "5" + IN->InServic
         MD->(DbAppend())
         replace MD->Linea with "6" + IN->InMateria
         MD->(DbAppend())
         replace MD->Linea with "7" + str( IN->InDiseno, 1 )
         MD->(DbAppend())
         replace MD->Linea with "8" + str( IN->InConteni, 1 )
         MD->(DbAppend())
         replace MD->Linea with "9" + str( IN->InValorac, 1 )
         MD->(DbAppend())
         replace MD->Linea with "A" + dTOc( IN->InFchVis )
         MD->(DbAppend())
         replace MD->Linea with "B" + IN->InEMail
         MD->(DbAppend())
         replace MD->Linea with "D" + IN->InCodigo
         MD->(DbAppend())
         replace MD->Linea with "E" + IN->InIdiomaC
         cMemo := strTran( IN->InDescri, CRLF, space( 01 ) )
         while len( cMemo ) > 75
            MD->( dbAppend() )
            replace MD->Linea with "C" + subStr( cMemo, 1, 75 )
            cMemo := subStr( cMemo, 76 )
         end while
         MD->( dbAppend() )
         replace MD->Linea with "C" + cMemo
         MD->( dbCommit() )
      endif
      IN->( dbSkip() )
      oMeter:setPos( nVar++ )
      Sysrefresh()
   end while

   SELECT MD
   COPY TO ( oApp():cBtcPath + rTrim( cArchiv ) + ".btc" ) SDF
   ZAP

return nil

/*_____________________________________________________________________________*/

function InImport( oFsdi, oBrw )

   local oDlg
   local aSay     := array( 02 )
   local oBmp
   local oMeter

   local cArchivo := ""
   local nVar     := 1
   local cDescri

   cArchivo := cGetFile32( "*.btc", i18n( "Indica la ubicación del archivo de direcciones" ),, oApp():cBtcPath,, .t. )
   if empty( cArchivo )
      oBrw:setFocus()
      return nil
   endif

   SELECT MD
   ZAP
   APPEND FROM &cArchivo SDF
   MD->( dbGoTop() )
   cDescri := rTrim( subStr( MD->Linea, 2 ) )
   MD->( dbSkip() )
   if ! msgYesNo( i18n( "¿Desea incorporar estas direcciones?" ) + CRLF + CRLF + cDescri )
      SELECT MD
      ZAP
      oBrw:setFocus()
      return nil
   endif

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "UT_INDEXAR";
         TITLE oApp():cAppName
   oDlg:SetFont(oApp():oFont)

   REDEFINE BITMAP oBmp ID 111 OF oDlg RESOURCE "BB_INTERNET" TRANSPARENT

   REDEFINE SAY aSay[01] ID  99 OF oDlg PROMPT i18n( "Importando direcciones..." )
   REDEFINE SAY aSay[02] ID 100 OF oDlg PROMPT ""

   oMeter := TProgress():Redefine( 101, oDlg )

   oDlg:bStart := { || SysRefresh(), InImport2( oMeter, nVar, cArchivo ), oDlg:End() }

   ACTIVATE DIALOG oDlg ;
      ON INIT oDlg:Center( oApp():oWndMain )

   msgInfo( i18n( "La importación se realizó correctamente." ) )

   oFsdi:end()
   Ut_Indexar(.f.)
   Internet()

   /* DURANTE UN TIEMPO TUVE ESTO PUESTO PERO DEJÓ DE FUNCIONAR Y AHORA TIRA SIN PONERLO:
      Lo siguiente corrije un fallo: si no abro la dbf IN, cuando el usuario pulsa "salir"
      del mantenimiento, el flujo llega a aquí, y vuelve de nuevo al mantenimiento
      "anterior" [desde el que fue llamada esta función InImport()], que trata de cerrarse
      pero sin tener IN abierta, por lo que casca al intentar guardar el registro actual en
      el archivo .INI.

      En esta parte hay una pequeña chapucilla de recursividad, pero no encuentro otra
      forma de conseguir que se reindexen los ficheros automáticamente. */

/*
   if ! Db_Open( "Internet", "IN" )
      return nil
   endif
*/

return nil

/*_____________________________________________________________________________*/

function InImport2( oMeter, nVar, cArchivo )

   local cMemo

   oMeter:setRange( 0, MD->( lastRec() ) )
   oMeter:setPos( 0 )
   SysRefresh()

   while ! MD->( eof() )
      IN->( dbAppend() )
      while subStr( MD->Linea, 1, 1 ) != "C" .and. ! MD->( eof() )
         switch subStr( MD->Linea, 1, 1 )
            case "1"
               replace IN->InNombre  with  rTrim( subStr( MD->Linea, 2 ) )
               exit
            case "2"
               replace IN->InDirecc  with  rTrim( subStr( MD->Linea, 2 ) )
               exit
            case "3"
               replace IN->InIdioma  with  val( rTrim( subStr( MD->Linea, 2 ) ) )
               exit
            case "4"
               replace IN->InOtroId  with  rTrim( subStr( MD->Linea, 2 ) )
               exit
            case "5"
               replace IN->InServic  with  rTrim( subStr( MD->Linea, 2 ) )
               exit
            case "6"
               replace IN->InMateria with  rTrim( subStr( MD->Linea, 2 ) )
               exit
            case "7"
               replace IN->InDiseno  with  val( rTrim( subStr( MD->Linea, 2 ) ) )
               exit
            case "8"
               replace IN->InConteni with  val( rTrim( subStr( MD->Linea, 2 ) ) )
               exit
            case "9"
               replace IN->InValorac with  val( rTrim( subStr( MD->Linea, 2 ) ) )
               exit
            case "A"
               replace IN->InFchVis  with  cTOd( rTrim( subStr( MD->Linea, 2 ) ) )
               exit
            case "B"
               replace IN->InEmail   with  rTrim( subStr( MD->Linea, 2 ) )
               exit
            case "D"
               if ! FindRec( "IN", rTrim( subStr( MD->Linea, 2 ) ), "codigo" )
                  replace IN->InCodigo  with  rTrim( subStr( MD->Linea, 2 ) )
               else
                  replace IN->InCodigo  with  space( 10 )
               endif
               exit
            case "E"
               replace IN->InIdiomaC with  rTrim( subStr( MD->Linea, 2 ) )
               exit
         end switch
         MD->( dbSkip() )
         oMeter:setPos( nVar++ )
         SysRefresh()
      end while
      cMemo := ""
      while subStr( MD->Linea, 1, 1 ) == "C" .and. ! MD->( eof() )
         cMemo := cMemo + rTrim( subStr( MD->Linea, 2 ) )
         MD->( dbSkip() )
         oMeter:setPos( nVar++ )
         SysRefresh()
      end while
      replace IN->InDescri with cMemo
      IN->( dbCommit() )
   end while
   SELECT MD
   ZAP

return nil

/*_____________________________________________________________________________*/

function InCopy( oBrw, oClp )

   if IN->( ordKeyVal() ) == nil
      msgStop( i18n( "No hay ningúna dirección introducida." ) )
      return nil
   endif

   oClp:setText( rTrim( IN->InDirecc ) )
   msgInfo( i18n( "Dirección copiada al portapapeles." ) )
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function InImprimir( oBrw )
                 //  título                 campo         wd  shw  picture          tot
                 //  =====================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Código"       ), "INCODIGO"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Título"       ), "INNOMBRE"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Dirección URL"), "INDIRECC"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Servicio"     ), "INSERVIC"  ,  0, .t.,            "NO", .f. },;
                   { i18n("Idioma"       ), "INIDIOMAC" ,  0, .t.,            "NO", .f. },;
                   { i18n("Materia"      ), "INMATERIA" ,  0, .t.,            "NO", .f. },;
                   { i18n("Fch.Visita"   ), "INFCHVIS"  ,  0, .t.,            "NO", .f. },;
                   { i18n("V.Diseño"     ), "INDISENO"  ,  0, .t.,     "@E 99,999", .f. },;
                   { i18n("V.Contenido"  ), "INCONTENI" ,  0, .t.,     "@E 99,999", .f. },;
                   { i18n("V.Global"     ), "INVALORAC" ,  0, .t.,     "@E 99,999", .f. },;
                   { i18n("E-mail"       ), "INEMAIL"   ,  0, .t.,            "NO", .f. },;
                   { i18n("Descripción"  ), "INDESCRI"  , 40, .t.,            "NO", .f. } }
   local nRecno   := IN->(Recno())
   local nOrder   := IN->(OrdSetFocus())
   local aCampos  := { "INCODIGO", "INNOMBRE", "INDIRECC", "INSERVIC", "INIDIOMAC",;
                       "INMATERIA", "INFCHVIS", "INDISENO", "INCONTENI", "INVALORAC",;
                       "INEMAIL", "INDESCRI" }
   local aTitulos := { "Código", "Título", "Dirección URL", "Servicio", "Idioma",;
                       "Materia", "Fch.Visita", "V.Diseño", "V.Contenido", "V.Global",;
                       "E-mail", "Descripción" }
   local aWidth   := { 10, 20, 20, 10, 10, 10, 10, 10, 10, 10, 10, 10 }
   local aShow    := { .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t., .t. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "@E 99,999" , "@E 99,999", "@E 99,999", "NO", "NO" }
   local aTotal   := { .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f., .f. }
   local oInforme
   local nAt
   local cAlias   := "IN"
   local cTotal   := "Total direcciones de internet: "
   local aGet     := array(8)
   local aMa      := {}
   local cMa      := ""
   local aSe      := { i18n("web"), i18n("ftp"), i18n("e-mail"), i18n("news"), i18n("gopher"), i18n("archie") }
   local cSe      := aSe[1]
   local dFch1    := cTOd( "" )
   local dFch2    := date()

   if InDbfVacia()
      retu NIL
   end if

   oApp():nEdit++

   FillCmb( "MA", "imateria" , aMa, "MaMateria", nOrder, nRecno, @cMa )

   SELECT IN  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio;
      VAR oInforme:nRadio        ;
      ID 100, 101, 103, 105, 108 ;
      OF oInforme:oFld:aDialogs[1]

   REDEFINE SAY aGet[01] ID 200 OF oInforme:oFld:aDialogs[1]
   REDEFINE SAY aGet[02] ID 201 OF oInforme:oFld:aDialogs[1]

   REDEFINE COMBOBOX aGet[03] VAR cMa ITEMS aMa ID 102 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 2
   REDEFINE COMBOBOX aGet[04] VAR cSe ITEMS aSe ID 104 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 3

   REDEFINE GET aGet[05] VAR dFch1 ID 106 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 4

   REDEFINE BUTTON aGet[06] ID 109 OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch1, aGet[05] ),;
               aGet[05]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 4

      aGet[06]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE GET aGet[07] VAR dFch2 ID 107 OF oInforme:oFld:aDialogs[1] WHEN oInforme:nRadio == 4

   REDEFINE BUTTON aGet[08] ID 110 OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch2, aGet[07] ),;
               aGet[07]:setFocus(),;
               SysRefresh() ) ;
      WHEN oInforme:nRadio == 4

      aGet[08]:cToolTip := i18n( "selecc. fecha" )

   oInforme:Folders()
   if oInforme:Activate()
      Do Case
         Case oInforme:nRadio == 1
            // Todas Las Direcciones, Con El Orden Determinado
            // Nrptmodo := 1
            IN->( Dbgotop() )
         Case oInforme:nRadio == 2
            // Direcciones De Una Materia
            // Nrptmodo := 1
            IN->( Ordsetfocus( "Materia" ) )
            IN->( Ordscope( 0, Upper( Rtrim( Cma ) ) ) )
            IN->( Ordscope( 1, Upper( Rtrim( Cma ) ) ) )
            IN->( Dbgotop() )
          Case oInforme:nRadio == 3
             // Direcciones De Un Servicio
             // Nrptmodo := 1
            In->( Ordsetfocus( "Servicio" ) )
            In->( Ordscope( 0, Upper( Rtrim( Cse ) ) ) )
            In->( Ordscope( 1, Upper( Rtrim( Cse ) ) ) )
            In->( Dbgotop() )
         Case oInforme:nRadio == 4
            // Direcciones Visitadas En Un Periodo
            // Nrptmodo := 1
            In->( Ordsetfocus( "Fchvisita" ) )
            In->( Ordscope( 0, Dtos( Dfch1 ) ) )
            In->( Ordscope( 1, Dtos( Dfch2 ) ) )
            In->( Dbgotop() )
         Case oInforme:nRadio == 5
            InImprimirFicha(oInforme)
      End Case
      if oInforme:nRadio != 5
         Select IN
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
                     oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
                     oInforme:oReport:EndLine() )
      endif
      oInforme:End(.t.)
      IN->( ordScope( 0, NIL ) )
      IN->( ordScope( 1, NIL ) )
      IN->(DbSetOrder(nOrder))
      IN->(DbGoTo(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .t. )
   oApp():nEdit --
return nil

/*_____________________________________________________________________________*/

function InDbfVacia()

   local lReturn := .f.

   if IN->( ordKeyVal() ) == nil
      msgStop( i18n( "No hay ninguna dirección registrada." ) )
      lReturn := .t.
   endif

return lReturn

/*_____________________________________________________________________________*/

function InImprimirFicha( oInforme )

   local nRec    := IN->( recNo() )
   local i        := 0

  	oInforme:oFont1 := TFont():New( Rtrim( oInforme:acFont[ 1 ] ), 0, Val( oInforme:acSizes[ 1 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 1 ] ),,,,,,, )
   oInforme:oFont2 := TFont():New( Rtrim( oInforme:acFont[ 2 ] ), 0, Val( oInforme:acSizes[ 2 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 2 ] ),,,,,,, )
   oInforme:oFont3 := TFont():New( Rtrim( oInforme:acFont[ 3 ] ), 0, Val( oInforme:acSizes[ 3 ] ),,( i18n("Negrita") $ oInforme:acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ oInforme:acEstilo[ 3 ] ),,,,,,, )
   oInforme:cTitulo1 := Rtrim(IN->InNombre)
   oInforme:cTitulo2 := Rtrim("Ficha del sitio web")

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

   ACTIVATE REPORT oInforme:oReport FOR IN->( recNo() ) == nRec ;
      ON INIT InImprimirFicha2( oInforme:oReport, nRec )

   IN->( dbGoTo( nRec ) )

return NIL

/*_____________________________________________________________________________*/

function InImprimirFicha2( oReport, nRec )

   local nLines   := 0
   local i        := 0

   IN->( dbGoTo( nRec ) )
   oReport:StartLine()
   oReport:Say( 1, i18n("Código:"), 2 )
   oReport:Say( 2, IN->InCodigo   , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Título:")   , 2 )
   oReport:Say( 2, IN->InNombre      , 1 )
   oReport:Say( 3, i18n("Direc.URL:"), 2 )
   oReport:Say( 4, IN->InDirecc      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Servicio:"), 2 )
   oReport:Say( 2, IN->InServic     , 1 )
   oReport:Say( 3, i18n("Idioma:")  , 2 )
   oReport:Say( 4, IN->InIdiomaC    , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Materia:")    , 2 )
   oReport:Say( 2, IN->InMateria       , 1 )
   oReport:Say( 3, i18n("Fch. Visita:"), 2 )
   oReport:Say( 4, IN->InFchVis        , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Val.Global:"), 2 )
   oReport:Say( 2, IN->InValorac      , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("Val.Diseño:")   , 2 )
   oReport:Say( 2, IN->InDiseno          , 1 )
   oReport:Say( 3, i18n("Val.Contenido:"), 2 )
   oReport:Say( 4, IN->InConteni         , 1 )
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:EndLine()
   oReport:StartLine()
   oReport:Say( 1, i18n("E-mail:"), 2 )
   oReport:Say( 2, IN->InEmail    , 1 )
   oReport:EndLine()
   if !empty( IN->InDescri )
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      oReport:StartLine()
      oReport:Say( 1, i18n("Descripción"), 2 )
      oReport:EndLine()
      oReport:StartLine()
      oReport:EndLine()
      nLines := mlCount( IN->InDescri, 90 )
      for i := 1 to nLines
         oReport:StartLine()
         oReport:Say( 2, memoLine( IN->InDescri, 90, i ), 1 )
         oReport:EndLine()
      next
   endif

return NIL
