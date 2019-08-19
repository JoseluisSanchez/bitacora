#include "FiveWin.ch"
#include "FiveWin.ch"
#include "FiveWin.ch"
#include "Report.ch"
#include "xBrowse.ch"
#include "vmenu.ch"
#include "AutoGet.ch"

static oReport

function AztArticulos()

   local oCol
   local aBrowse
   local cState := GetPvProfString("Browse", "zArState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "zArOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "zArRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "zArSplit","102", oApp():cIniFile))
   local oCont

   // LOCAL oSplit
   local i

   if oApp():oDlg != NIL
      if oApp():nEdit > 0
         //MsgStop('Por favor, finalice la edición del registro actual.')
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   if ! Db_AztOpenAll()
      return nil
   endif

   select ZAR
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de documentos')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   Ut_BrwRowConfig( oApp():oGrid )

   oApp():oGrid:cAlias := "ZAR"

   aBrowse   := { { {|| ZAR->ArTitulo  }, i18n("Título"), 150, 0 },;
      { {|| ZAR->ArCodigo  }, i18n("Código"), 20, 0 },;
      { {|| ZAR->ArMateria }, i18n("Materia"), 60, 0 },;
      { {|| ZAR->ArTags    }, i18n("Etiquetas"), 160, 0 },;
      { {|| ZAR->ArAutores }, i18n("Autores"), 50, 0 },;
      { {|| ZAR->ArIdioma  }, i18n("Idioma"), 15, 0 },;
      { {|| ZAR->ArPublicac}, i18n("Publicación"), 60, 0 },;
      { {|| ZAR->ArNumero  }, i18n("Numero"), 6, 0 },;
      { {|| Trans(ZAR->ArNumPag, "@E 9,999") }, i18n("Nº Páginas"), 44, 1 },;
      { {|| DToC(ZAR->ArFechaEd)}, i18n("Fch. public."), 12, 1 },;
      { {|| ZAR->ArUbicaci }, i18n("Ubicación"), 60, 0 },;
      { {|| ZAR->ArTipoDoc }, i18n("Tipo documento"), 60, 0 },;
      { {|| ZAR->ArLocaliz }, i18n("Localizador"), 20, 0 },;
      { {|| ZAR->ArPath    }, i18n("Fichero"), 120, 0 },;
      { {|| ZAR->ArResumen }, i18n("Resumen"), 120, 0 },;
      { {|| ZAR->ArURL     }, i18n("U.R.L." ), 120, 0 } }

   for i := 1 to Len(aBrowse)
      oCol := oApp():oGrid:AddCol()
      oCol:bStrData := aBrowse[ i, 1 ]
      oCol:cHeader  := aBrowse[ i, 2 ]
      oCol:nWidth   := aBrowse[ i, 3 ]
      oCol:nDataStrAlign := aBrowse[ i, 4 ]
      oCol:nHeadStrAlign := aBrowse[ i, 4 ]
   next

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource("BR_UBICA1")
   oCol:AddResource("BR_UBICA2")
   oCol:cHeader       := i18n("Ubi")
   oCol:bBmpData      := {|| iif(!Empty(ZAR->ArUbicaci),1,2) }
   oCol:nWidth        := 35
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource("BR_ELEC1")
   oCol:AddResource("BR_ELEC2")
   oCol:cHeader       := i18n("Doc")
   oCol:bBmpData      := {|| iif(!Empty(ZAR->ArPath),1,2) }
   oCol:nWidth        := 35
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource("BR_WEB1")
   oCol:AddResource("BR_WEB2")
   oCol:cHeader       := i18n("Web")
   oCol:bBmpData      := {|| iif(!Empty(ZAR->ArUrl),1,2) }
   oCol:nWidth        := 35
   oCol:nDataBmpAlign := 2

   // añado columnas con bitmaps
   /*
   oCol := oApp():oGrid:AddCol()
   oCol:AddResource("BR_SUSC1")
   oCol:AddResource("BR_SUSC2")
   oCol:cHeader       := i18n("Suscrito")
   oCol:bBmpData      := { || IIF(ZAR->PuSuscrip,1,2) } // { || IIF(EMPTY(CL->ClInternet),2,1) }
   oCol:nWidth        := 23
   oCol:nDataBmpAlign := 2
   */
   for i := 1 to Len(oApp():oGrid:aCols)
      oCol := oApp():oGrid:aCols[ i ]
      oCol:bLDClickData  := {|| AztArEdita(oApp():oGrid,2,oCont,oApp():oDlg) }
   next

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont,"ZAR", "Documentos: ") }
   oApp():oGrid:bKeyDown := {|nKey| AztArTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21

   oApp():oGrid:RestoreState( cState )

   ZAR->(dbSetOrder(nOrder))
   ZAR->(dbGoto(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION "Documentos: "+tran(ZAR->(ordKeyNo()),'@E 999,999')+" / "+tran(ZAR->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_DOCUMENT"

   DEFINE VMENUITEM OF oCont        ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Nuevo"              ;
      IMAGE "16_NUEVO"             ;
      ACTION AztArEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Modificar"          ;
      IMAGE "16_MODIF"             ;
      ACTION AztArEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Duplicar"           ;
      IMAGE "16_DUPLICAR"           ;
      ACTION AztArEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Borrar"             ;
      IMAGE "16_BORRAR"            ;
      ACTION AztArBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Buscar"             ;
      IMAGE "16_BUSCAR"             ;
      ACTION AztArBusca(oApp():oGrid,,oCont,oApp():oDlg)  ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Imprimir"           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION AztArImprime(oApp():oGrid,oApp():oDlg)         ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documento en internet"  ;
      IMAGE "16_INTERNET"          ;
      ACTION GoWeb(ZAR->ArUrl)      ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ejecutar archivo"   ;
      IMAGE "16_EXPRES"            ;
      ACTION GoFile(ZAR->ArPath)    ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar a Excel"     ;
      IMAGE "16_EXCEL"             ;
      ACTION (CursorWait(), oApp():oGrid:ToExcel(), CursorArrow());
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Configurar columnas" ;
      IMAGE "16_GRID"              ;
      ACTION Ut_BrwColConfig( oApp():oGrid, "PuState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Salir"              ;
      IMAGE "16_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
      OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS ' Título ', ' Código ', ' Materia ',' Autor ', ' Publicación ', ' Tipo de documento ', ' Ubicación ', ' Localizador ';
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( nOrder := oApp():oTab:nOption,;
      ZAR->(dbSetOrder(nOrder)),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont,"ZAR", "Documentos: ") )

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(), oApp():oGrid:SetFocus()) ;
      VALID ( oApp():oGrid:nLen := 0,;
      WritePProString("Browse","zArState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","zArOrder",LTrim(Str(ZAR->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","zArRecno",LTrim(Str(ZAR->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","zArSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oCont:End(), dbCloseAll(), oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil
//_____________________________________________________________________________//

function AztArEdita( oGrid, nMode, oCont, oParent )

   local oDlg, oFld, oTags, oAutores, oCol
   local aTitle := { i18n( "Añadir un documento" ),;
      i18n( "Modificar un documento"),;
      i18n( "Duplicar un documento") }
   local aGet[32]
   local aSay[18]
   local cArTitulo,;
      cArCodigo,;
      cArAutores,;
      cArMateria,;
      cArTags,;
      cArPublicac,;
      cArNumero,;
      dArFechaEd,;
      mArDescrip,;
      cArSelect,;
      lArPapel,;
      lArElectro,;
      cArUbicaci,;
      cArLocaliz,;
      cArPath,;
      cArTipo,;
      cArVolumen,;
      dArFechaLec,;
      nArPagIni,;
      nArPagFin,;
      nArNumPag,;
      cArTipoDoc,;
      cArUnico,;
      cArIdioma,;
      cArURL,;
      cArResumen
   local nRecPtr := ZAR->(RecNo())
   local nOrden  := ZAR->(ordNumber())
   local nRecAdd
   local lDuplicado
   local i
   local aTags  := {}
   local aTagsB := {}
   local aAutores  := {}
   local aAutoresB := {}

   if ZAR->(Eof()) .AND. nMode != 1
      retu nil
   endif

   oApp():nEdit ++

   if nMode == 1
      ZAR->(dbAppend())
      nRecAdd  := ZAR->(RecNo())
   endif

   cArTitulo   := ZAR->ARTITULO
   cArCodigo   := ZAR->ARCODIGO
   cArAutores  := ZAR->ARAUTORES
   cArMateria  := ZAR->ARMATERIA
   cArPublicac := ZAR->ARPUBLICAC
   cArNumero   := ZAR->ARNUMERO
   dArFechaEd  := ZAR->ARFECHAED
   mArDescrip  := ZAR->ARDESCRIP
   cArSelect   := ZAR->ARSELECT
   lArPapel    := ZAR->ARPAPEL
   lArElectro  := ZAR->ARELECTRO
   cArUbicaci  := ZAR->ARUBICACI
   cArLocaliz  := ZAR->ARLOCALIZ
   cArPath     := ZAR->ARPATH
   cArTipo     := ZAR->ARTIPO
   cArVolumen  := ZAR->ARVOLUMEN
   dArFechaLec := ZAR->ARFECHALEC
   nArPagIni   := ZAR->ARPAGINI
   nArPagFin   := ZAR->ARPAGFIN
   nArNumPag   := ZAR->ARNUMPAG
   cArTipoDoc  := ZAR->ARTIPODOC
   cArUnico    := iif( nMode!=2, DToS(Date())+Str(Seconds()*100,7), ZAR->ARUNICO )
   cArIdioma   := ZAR->ARIDIOMA
   cArURL      := ZAR->ARURL
   cArResumen  := ZAR->ARRESUMEN
   cArTags  := RTrim(ZAR->Artags)
   aTags       := iif(At(';',cArTags)!=0, hb_ATokens( cArTags, ";"), {})
   if Len(aTags) > 1
      ASize( aTags, Len(aTags)-1)
      for i:=1 to Len(aTags)
         aTags[i] := AllTrim(aTags[i])
         AAdd(aTagsB, aTags[i])
      next
   endif
   aAutores  := iif(At(';',cArAutores)!=0, hb_ATokens( cArAutores, ";"), {})
   if Len(aAutores) > 1
      ASize( aAutores, Len(aAutores)-1)
      for i:=1 to Len(aAutores)
         aAutores[i] := AllTrim(aAutores[i])
         AAdd(aAutoresB, aAutores[i])
      next
   endif

   if nMode == 3
      ZAR->(dbAppend())
      nRecAdd := ZAR->(RecNo())
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTAREDIT" OF oParent ;
      TITLE aTitle[nMode]
   oDlg:SetFont(oApp():oFont)

   REDEFINE say aSay[01] ID 201 OF oDlg
   REDEFINE say aSay[02] ID 202 OF oDlg
   REDEFINE say aSay[03] ID 203 OF oDlg
   REDEFINE say aSay[04] ID 204 OF oDlg
   REDEFINE say aSay[05] ID 205 OF oDlg

   REDEFINE get aGet[1] var cArTitulo        ;
      ID 101 OF oDlg UPDATE                  ;
      valid AztArClave( cArTitulo, aGet[1], nMode, 1 )

   REDEFINE get aGet[2] var cArCodigo        ;
      ID 102 OF oDlg UPDATE                  ;
      valid AztArClave( cArCodigo, aGet[2], nMode, 2 )

   REDEFINE AUTOGET aGet[3] ;
      var cArMateria ;
      DATASOURCE {}						;
      FILTER AztMaList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 103 ;
      OF oDlg ;
      VALID ( AztMaClave( @cArMateria, aGet[3], 4, .T., ) )

   //REDEFINE GET aGet[3] VAR cArMateria       ;
   //   ID 103 OF oDlg UPDATE                  ;
   //   VALID AztMaClave( @cArMateria, aGet[3], 4, .t.,  )

   REDEFINE BUTTON aGet[4]                   ;
      ID 104 OF oDlg UPDATE                  ;
      ACTION AztMaSeleccion( cArMateria, aGet[3], oDlg )
   aGet[4]:cTooltip := "seleccionar materia"

   REDEFINE AUTOGET aGet[5] ;
      var cArTipoDoc     ;
      DATASOURCE {}						;
      FILTER AztTdList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 105 ;
      OF oDlg ;
      VALID ( AztTdClave( @cArTipoDoc, aGet[5], 4, .T., ) )

   REDEFINE BUTTON aGet[6]                   ;
      ID 106 OF oDlg UPDATE                  ;
      ACTION AztTdSeleccion( cArTipoDoc, aGet[5], oDlg )
   aGet[6]:cTooltip := "seleccionar tipo de documento"

   //REDEFINE GET aGet[7] VAR cArIdioma        ;
   //   ID 107 OF oDlg UPDATE                  ;
   //   VALID IdClave( @cArIdioma, aGet[7], 4 )

   //REDEFINE BUTTON aGet[8]                   ;
   //   ID 108 OF oDlg UPDATE                  ;
   //   ACTION IdSeleccion( cArIdioma, aGet[7], oDlg )
   //aGet[8]:cTooltip := "seleccionar idioma"

   REDEFINE AUTOGET aGet[7] ;
      var cArIdioma ;
      DATASOURCE {}						;
      FILTER IdList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 107 ;
      OF oDlg ;
      VALID ( IdClave( @cArIdioma, aGet[07], "aux" ) )

   REDEFINE BUTTON aGet[8];
      ID 108;
      OF oDlg;
      ACTION ( IdTabAux( @cArIdioma, aGet[07] ),;
      aGet[07]:setFocus(),;
      SysRefresh() )

   REDEFINE FOLDER oFld                      ;
      ID 110 OF oDlg                         ;
      ITEMS " &Publicación ", " &Autores ", " &Etiquetas ", " &Soporte ", " &Resumen " ;
      DIALOGS "AZTAREDIT_B", "AZTAREDIT_D", "AZTAREDIT_D", "AZTAREDIT_E", "AZTAREDIT_F" ;
      OPTION 1

   REDEFINE say aSay[07] ID 221 OF oFld:aDialogs[1]
   REDEFINE say aSay[08] ID 222 OF oFld:aDialogs[1]
   REDEFINE say aSay[09] ID 223 OF oFld:aDialogs[1]
   REDEFINE say aSay[10] ID 224 OF oFld:aDialogs[1]
   REDEFINE say aSay[11] ID 225 OF oFld:aDialogs[1]
   REDEFINE say aSay[06] ID 226 OF oFld:aDialogs[1]
   REDEFINE say aSay[17] ID 227 OF oFld:aDialogs[1]

	REDEFINE AUTOGET aGet[11] ;
      var cArPublicac ;
      DATASOURCE {}						;
      FILTER AztPuList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 121 ;
      OF oFld:aDialogs[1] ;
      VALID ( AztPuClave( @cArPublicac, aGet[11], 4, .T., ) )

   REDEFINE BUTTON aGet[12]                     ;
      ID 122 OF oFld:aDialogs[1] UPDATE      ;
      ACTION AztPuSeleccion( cArPublicac, aGet[11], oDlg )
   aGet[12]:cTooltip := "seleccionar publicación"

   REDEFINE get aGet[13] var cArNumero       ;
      ID 123 OF oFld:aDialogs[1] UPDATE

   REDEFINE get aGet[14] var dArFechaEd      ;
      ID 124 OF oFld:aDialogs[1] UPDATE

   REDEFINE BUTTON aGet[15]                  ;
      ID 125 OF oFld:aDialogs[1] UPDATE      ;
      ACTION SelecFecha( dArFechaEd, aGet[14] )
   aGet[15]:cTooltip := "seleccionar fecha"

   REDEFINE get aGet[16] var nArPagIni       ;
      ID 126 OF oFld:aDialogs[1] UPDATE      ;
      picture "@E 9,999"

   REDEFINE get aGet[17] var nArPagFin       ;
      ID 127 OF oFld:aDialogs[1] UPDATE      ;
      picture "@E 9,999"

   REDEFINE get aGet[9] var dArFechaLec      ;
      ID 128 OF oFld:aDialogs[1] UPDATE

   REDEFINE BUTTON aGet[10]                  ;
      ID 129 OF oFld:aDialogs[1] UPDATE      ;
      ACTION SelecFecha( dArFechaLec, aGet[9] )
   aget[10]:cTooltip := "seleccionar fecha"

   REDEFINE get aGet[29] var nArNumPag       ;
      ID 130 OF oFld:aDialogs[1] UPDATE      ;
      picture "@E 9,999"

   // Autores
   oAutores := TTagEver():Redefine(110, oFld:aDialogs[2], oApp():oFont, aAutores )

   REDEFINE BUTTON ;
      ID 111 OF oFld:aDialogs[2] UPDATE      ;
      ACTION AztAuSeleccion( @aAutores, oAutores, oDlg )

   // Etiquetas
   oTags := TTagEver():Redefine(110, oFld:aDialogs[3], oApp():oFont, aTags )

   REDEFINE BUTTON ;
      ID 111 OF oFld:aDialogs[3] UPDATE      ;
      ACTION AztEtSeleccion( @aTags, oTags, oDlg )

   // soporte
   REDEFINE say aSay[12] ID 251 OF oFld:aDialogs[4]
   REDEFINE say aSay[13] ID 252 OF oFld:aDialogs[4]
   REDEFINE say aSay[14] ID 253 OF oFld:aDialogs[4]
   REDEFINE say aSay[15] ID 254 OF oFld:aDialogs[4]

   REDEFINE CHECKBOX aGet[18] var lArPapel ID 151 OF oFld:aDialogs[4]

   REDEFINE AUTOGET aGet[19] var cArUbicaci      ;
      DATASOURCE {}						;
      FILTER AztUbList( uDataSource, cData, Self );     
      HEIGHTLIST 100 ;
      ID 152 OF oFld:aDialogs[4] UPDATE      ;
      valid AztUbClave( @cArUbicaci, aGet[19], 4 ) ;
      when lArPapel
   
   REDEFINE BUTTON aGet[20]                  ;
      ID 153 OF oFld:aDialogs[4] UPDATE      ;
      ACTION AztUbSeleccion( cArUbicaci, aGet[19] )   ;
      when lArPapel
   aGet[20]:cTooltip := "seleccionar ubicación"

   REDEFINE get aGet[21] var cArLocaliz      ;
      ID 154 OF oFld:aDialogs[4] UPDATE      ;
      when lArPapel

   REDEFINE CHECKBOX aGet[22] var lArElectro ID 155 OF oFld:aDialogs[4]

   REDEFINE get aGet[23] var cArPath         ;
      ID 156 OF oFld:aDialogs[4] UPDATE      ;
      when lArElectro
   REDEFINE BUTTON aGet[24]                  ;
      ID 157 OF oFld:aDialogs[4] UPDATE      ;
      ACTION aGet[23]:cText := cGetFile32('*.*','indique la ubicación del documento',,,,.T.) ;
      when lArElectro
   aGet[24]:cTooltip := "seleccionar fichero"
   REDEFINE BUTTON aGet[25]                  ;
      ID 158 OF oFld:aDialogs[4] UPDATE      ;
      ACTION GoFile( cArPath )               ;
      when lArElectro
   aGet[25]:cTooltip := "ejecutar fichero"

   REDEFINE get aGet[26] var cArURL          ;
      ID 159 OF oFld:aDialogs[4] UPDATE      ;
      when lArElectro
   REDEFINE BUTTON aGet[27]                  ;
      ID 150 OF oFld:aDialogs[4] UPDATE      ;
      ACTION GoWeb(cArURL)                   ;
      when lArElectro
   aGet[27]:cTooltip := "visitar sitio web"

   // resumen
   REDEFINE say aSay[16] ID 261 OF oFld:aDialogs[5]
   REDEFINE say aSay[17] ID 262 OF oFld:aDialogs[5]

   REDEFINE get aGet[28] var mArDescrip      ;
      ID 161 MEMO OF oFld:aDialogs[5] UPDATE

   REDEFINE get aGet[29] var cArResumen       ;
      ID 162 OF oFld:aDialogs[5] UPDATE      
   REDEFINE BUTTON aGet[30]                  ;
      ID 163 OF oFld:aDialogs[5] UPDATE      ;
      ACTION aGet[29]:cText := cGetFile32('*.*','indique la ubicación del resumen',,,,.T.) 
   aGet[30]:cTooltip := "seleccionar fichero"
   REDEFINE BUTTON aGet[31]                  ;
      ID 164 OF oFld:aDialogs[5] UPDATE      ;
      ACTION GoFile( cArResumen )            
   aGet[31]:cTooltip := "ejecutar fichero"
   ///
   // dialogo principal
   REDEFINE BUTTON   ;
      ID    IDOK     ;
      OF    oDlg     ;
      ACTION   ( aTags:=oTags:aItems, aAutores:=oAutores:aItems, oDlg:end( IDOK ) )

   REDEFINE BUTTON   ;
      ID    IDCANCEL ;
      OF    oDlg     ;
      CANCEL         ;
      ACTION   ( oDlg:end( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

   if oDlg:nresult == IDOK
      if nMode == 2
         ZAR->(dbGoto(nRecPtr))
      else
         ZAR->(dbGoto(nRecAdd))
      endif
      // ___ actualizo el número de documentos en materias _____________________//
      if Upper(RTrim(ZAR->ArMateria)) != Upper(RTrim(cArMateria))
         select ZMA
         ZMA->(dbSeek(Upper(cArMateria)))
         replace ZMA->MaEjempl with ZMA->MaEjempl + 1
         if nMode == 2
            ZMA->(dbSeek(Upper(ZAR->ArMateria)))
            replace ZMA->MaEjempl with ZMA->MaEjempl - 1
         endif
      endif
      // ___ actualizo el número de documentos en publicaciones ________________//
      if Upper(RTrim(ZAR->ArPublicac)) != Upper(RTrim(cArPublicac))
         select ZPU
         ZPU->(dbSeek(Upper(cArPublicac)))
         replace ZPU->PuEjempl with ZPU->PuEjempl + 1
         if nMode == 2
            ZPU->(dbSeek(Upper(ZAR->ArPublicac)))
            replace ZPU->PuEjempl with ZPU->PuEjempl - 1
         endif
      endif
      // ___ actualizo el número de documentos en ubicaciones __________________//
      if Upper(RTrim(ZAR->ArUbicaci)) != Upper(RTrim(cArUbicaci))
         select ZUB
         ZUB->(dbSeek(Upper(cArUbicaci)))
         replace ZUB->UbEjempl with ZUB->UbEjempl + 1
         if nMode == 2
            ZUB->(dbSeek(Upper(ZAR->ArUbicaci)))
            replace ZUB->UbEjempl with ZUB->UbEjempl - 1
         endif
      endif
      // ___ actualizo el número de documentos en tipos de documentos __________//
      if Upper(RTrim(ZAR->ArTipoDoc)) != Upper(RTrim(cArTipoDoc))
         select ZTD
         ZTD->(dbSeek(Upper(cArTipoDoc)))
         replace ZTD->TdEjempl with ZTD->TdEjempl + 1
         if nMode == 2
            ZTD->(dbSeek(Upper(ZAR->ArTipoDoc)))
            replace ZTD->TdEjempl with ZTD->TdEjempl - 1
         endif
      endif
      // ___ actualizo el número de documentos en etiquetas __________//
      select ZET
      ZET->(dbSetOrder(1))
      if Len(aTags) > 0
         for i := 1 to Len(aTags)
            // TTagEver transforma aTags en un array multidimensional
            if ValType(aTags[i]) == 'A'
               aTags[i] := aTags[i,1]
            endif
            ZET->(dbSeek(Upper(RTrim(aTags[i]))))
            replace ZET->EtEjempl with ZET->EtEjempl + 1
         next
         ZET->(dbCommit())
         if nMode == 2
            for i := 1 to Len(aTagsB)
               ZET->(dbSeek(Upper(RTrim(aTagsB[i]))))
               replace ZET->EtEjempl with ZET->EtEjempl - 1
            next
         endif
      endif
      // ___ actualizo el número de documentos en autores __________//
      select ZAU
      ZAU->(dbSetOrder(1))
      if Len(aAutores) > 0
         for i := 1 to Len(aAutores)
            // TTagEver transforma aAutores en un array multidimensional
            if ValType(aAutores[i]) == 'A'
               aAutores[i] := aAutores[i,1]
            endif
            ZAU->(dbSeek(Upper(RTrim(aAutores[i]))))
            replace ZAU->AuEjempl with ZAU->AuEjempl + 1
         next
         ZAU->(dbCommit())
         if nMode == 2
            for i := 1 to Len(aAutoresB)
               ZAU->(dbSeek(Upper(RTrim(aAutoresB[i]))))
               replace ZAU->AuEjempl with ZAU->AuEjempl - 1
            next
         endif
      endif
      // ___ guardo el registro _______________________________________________//
      select ZAR
      if nMode == 2
         ZAR->(dbGoto(nRecPtr))
      else
         ZAR->(dbGoto(nRecAdd))
      endif
      replace ZAR->ARTITULO     with  cArTitulo
      replace ZAR->ARCODIGO     with  cArCodigo
      replace ZAR->ARMATERIA    with  cArMateria
      replace ZAR->ARPUBLICAC   with  cArPublicac
      replace ZAR->ARNUMERO     with  cArNumero
      replace ZAR->ARFECHAED    with  dArFechaEd
      replace ZAR->ARDESCRIP    with  mArDescrip
      replace ZAR->ARSELECT     with  cArSelect
      replace ZAR->ARPAPEL      with  lArPapel
      replace ZAR->ARELECTRO    with  lArElectro
      replace ZAR->ARUBICACI    with  cArUbicaci
      replace ZAR->ARLOCALIZ    with  cArLocaliz
      replace ZAR->ARPATH       with  cArPath
      replace ZAR->ARTIPO       with  cArTipo
      replace ZAR->ARVOLUMEN    with  cArVolumen
      replace ZAR->ARFECHALEC   with  dArFechaLec
      replace ZAR->ARPAGINI     with  nArPagIni
      replace ZAR->ARPAGFIN     with  nArPagFin
      replace ZAR->ARNUMPAG     with  nArNumPag
      replace ZAR->ARTIPODOC    with  cArTipoDoc
      replace ZAR->ArUnico      with  cArUnico
      replace ZAR->ARIDIOMA     with  cArIdioma
      replace ZAR->ARURL        with  cArURL
      replace ZAR->ARRESUMEN    with  cArResumen
      cArTags := ''
      if Len(aTags) > 0
         for i := 1 to Len(aTags)
            cArTags := cArTags + aTags[i]+'; '
         next
      endif
      replace ZAR->ArTags    with cArTags
      cArAutores := ''
      if Len(aAutores) > 0
         for i := 1 to Len(aAutores)
            cArAutores := cArAutores + aAutores[i]+'; '
         next
      endif
      replace ZAR->ArAutores    with cArAutores
      ZAR->(dbCommit())
   else
      if nMode == 1 .OR. nMode == 3
         ZAR->(dbGoto(nRecAdd))
         ZAR->(dbDelete())
         ZAR->(DbPack())
         ZAR->(dbGoto(nRecPtr))
      endif
   endif

   select ZAR

   if oCont != NIL
      RefreshCont(oCont,"ZAR", "Documentos: ")
   endif

   oApp():nEdit --
   if oGrid != NIL
      oGrid:Refresh( .T. )
      oGrid:SetFocus( .T. )
   endif

return nil
//_____________________________________________________________________________//

function AztArBorra( oGrid, oCont )

   local nRecord := ZAR->( RecNo() )
   local nNext

   oApp():nEdit ++
   if msgYesNo( i18n("¿ Está seguro de querer borrar este documento ?") + CRLF + ;
         (Trim(ZAR->ArTitulo)))
      // ___ actualizo el número de documentos en materias _____________________//
      select ZMA
      ZMA->(dbSeek(Upper(ZAR->ArMateria)))
      replace ZMA->MaEjempl with ZMA->MaEjempl - 1
      // ___ actualizo el número de documentos en publicaciones ________________//
      select ZPU
      ZPU->(dbSeek(Upper(ZAR->ArPublicac)))
      replace ZPU->PuEjempl with ZPU->PuEjempl - 1
      // ___ actualizo el número de documentos en ubicaciones __________________//
      select ZUB
      ZUB->(dbSeek(Upper(ZAR->ArUbicaci)))
      replace ZUB->UbEjempl with ZUB->UbEjempl - 1
      // ___ actualizo el número de documentos en tipos de documentos __________//
      select ZTD
      ZTD->(dbSeek(Upper(ZAR->ArTipoDoc)))
      replace ZTD->TdEjempl with ZTD->TdEjempl - 1

      // borro el documento
      select ZAR
      ZAR->(dbSkip())
      nNext := ZAR->(RecNo())
      ZAR->(dbGoto(nRecord))

      ZAR->(dbDelete())
      ZAR->(DbPack())
      ZAR->(dbGoto(nNext))
      if ZAR->(Eof()) .OR. nNext == nRecord
         ZAR->(dbGoBottom())
      endif
   endif

   if oCont != NIL
      RefreshCont(oCont,"ZAR", "Documentos: ")
   endif

   oApp():nEdit --
   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)

return nil
//_____________________________________________________________________________//


function AztArTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztArEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztArEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztArBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztArBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztArBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil
//_____________________________________________________________________________//

function AztArBusca( oGrid, cChr, oCont, oParent )

   local nOrder    := ZAR->(ordNumber())
   local nRecno    := ZAR->(RecNo())
   local oDlg, oGet, cGet, cPicture
   local aSay1    := { " Introduzca el título del documento",;
      " Introduzca el código del documento",;
      " Introduzca la materia del documento",;
      " Introduzca el autor principal del documento",;
      " Introduzca la publicación del documento",;
      " Introduzca el tipo de documento",;
      " Introduzca la ubicación del documento",;
      " Introduzca el localizador del documento"    }
   local aSay2    := { "Título:", "Código:", "Materia:","Autor:",;
      "Publicación:","Tipo de doc.:","Ubicación:", "Localizador:" }
   local aGet     := { Space(150), Space(20), Space(40), Space(50),;
      Space(50), Space(30), Space(60), Space(20) }
   local lSeek     := .F.
   local lFecha    := .F.
   local aBrowse   := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR' OF oParent  ;
      TITLE i18n("Búsqueda de documentos")
   oDlg:SetFont(oApp():oFont)

   REDEFINE say prompt aSay1[nOrder] ID 20 OF oDlg
   REDEFINE say prompt aSay2[nOrder] ID 21 OF Odlg

   cGet  := aGet[nOrder]

   //__ si he pasado un caracter lo meto en la cadena a buscar ________________//

   if cChr != NIL
      if ! lFecha
         cGet := cChr+SubStr(cGet,1,Len(cGet)-1)
      else
         cGet := CToD('  -  -    ')
      endif
   endif

   if ! lFecha
      REDEFINE get oGet var cGet picture "@!" ID 101 OF oDlg
   else
      REDEFINE get oGet var cGet ID 101 OF oDlg
      // oGet:cText := cChr+' -  -    '
   endif

   if cChr != NIL
      oGet:bGotFocus := {|| ( oGet:SetColor( CLR_BLACK, RGB(255,255,127) ), oGet:SetPos(2) ) }
   endif

   REDEFINE BUTTON ID IDOK OF oDlg ;
      prompt i18n( "&Aceptar" )   ;
      ACTION (lSeek := .T., oDlg:End())
   REDEFINE BUTTON ID IDCANCEL OF oDlg CANCEL ;
      prompt i18n( "&Cancelar" )  ;
      ACTION oDlg:End()

   sysrefresh()

   ACTIVATE DIALOG oDlg ;
      on INIT ( DlgCenter(oDlg,oApp():oWndMain) )// , IIF(cChr!=NIL,oGet:SetPos(2),), oGet:Refresh() )

   if lSeek
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      end if
      MsgRun('Realizando la búsqueda...', oApp():cAppName+oApp():cVersion, ;
         {|| AztArWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ningún documento")
      else
         AztArEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   ZAR->(ordSetFocus(nOrder))
   // ZAR->(DbGoTo(nRecno))
   RefreshCont(oCont,"ZAR", "Documentos: ")
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztArWildSeek(nOrder, cGet, aBrowse)

   local nRecno   := ZAR->(RecNo())

   do case
   case nOrder == 1
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArTitulo)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   case nOrder == 2
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArCodigo)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   case nOrder == 3
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArMateria)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   case nOrder == 4
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArAutor)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   case nOrder == 5
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArPublicac)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   case nOrder == 6
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArTipoDoc)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   case nOrder == 7
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArUbicaci)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   case nOrder == 8
      ZAR->(dbGoTop())
      do while ! ZAR->(Eof())
         if cGet $ Upper(ZAR->ArLocaliz)
            AAdd(aBrowse, {ZAR->ArTitulo, ZAR->ArAutor, ZAR->ArMateria})
         endif
         ZAR->(dbSkip())
      enddo
   end case
   ZAR->(dbGoto(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztArEncontrados(aBrowse, oParent, nOrder)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ZAR->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent

   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Título"
   oBrowse:aCols[2]:cHeader := "Autor"
   oBrowse:aCols[3]:cHeader := "Materia"
   oBrowse:aCols[1]:nWidth  := 220
   oBrowse:aCols[2]:nWidth  := 120
   oBrowse:aCols[3]:nWidth  := 140
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   ZAR->(ordSetFocus(1))
   ZAR->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ZAR->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztArEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ZAR->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztArEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| ZAR->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ZAR->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

//_____________________________________________________________________________//

function AztArClave( cPublica, oGet, nMode, nTag )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   // nTag     1 documento
   //          2 código
   local lReturn  := .F.
   local nRecno   := ZAR->( RecNo() )
   local nOrder   := ZAR->( ordNumber() )
   local nArea    := Select()

   if Empty( cPublica )
      if nMode == 4
         return .T.
      else
         if nTag == 2
            return .T.
         else
            MsgStop("Es obligatorio rellenar este campo.")
            return .F.
         endif
      endif
   endif

   select ZAR
   ZAR->( dbSetOrder( nTag ) )
   ZAR->( dbGoTop() )

   if ZAR->( dbSeek( Upper( cPublica ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("Documento existente.")
      case nMode == 2
         if ZAR->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("Documento existente.")
         endif
      case nMode == 4
         IF ! oApp():thefull
            Registrame()
         ENDIF
         lReturn := .T.
      end case
   else
      if nMode < 4
         lReturn := .T.
      else
         lReturn := .F.
         MsgStop("Documento inexistente.")
      endif
   endif

   if lReturn == .F.
      if nTag == 1
         oGet:cText( Space(150) )
      else
         oGet:cText( Space(20) )
      endif
   endif

   ZAR->( dbSetOrder( nOrder ) )
   ZAR->( dbGoto( nRecno ) )

   select (nArea)

return lReturn

//_____________________________________________________________________________//

function AztArImprime(oGrid,oParent)

   local nRecno   := ZAR->(RecNo())
   local nOrder   := ZAR->(ordSetFocus())
   local aCampos  := { "ARTITULO", "ARCODIGO", "ARMATERIA", "ARAUTORES", "ARIDIOMA", "ARTAGS", ;
      "ARPUBLICAC", "ARNUMERO", "ARNUMPAG", "ARFECHAED", "ARUBICACI",;
      "ARTIPODOC", "ARLOCALIZ", "ARPATH", "ARURL" }
   local aTitulos := { "Título", "Código", "Materia", "Autores", "Idioma", "Etiquetas", ;
      "Publicación", "Número", "Nº Pag.", "Fch.Edición", "Ubicación",;
      "Tipo Doc.", "Localizador", "Archivo","Sitio web" }
   local aWidth   := { 50, 10, 30, 20, 10, 30, 30, 10, 10, 10, 20, 10, 15, 30, 30 }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO","NO","NO","NO","NO", "NO","NO","NO","NO","NO","NO","NO","NO","NO","NO" }
   local aTotal   := { .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F. }
   local oInforme
   local aControls[9]
   local cMateria := Space(40)
   local cAutor   := Space(50)
   local cPublica := Space(50)
   local aDocumen := {}

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "AR" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300, 301, 302, 303 OF oInforme:oFld:aDialogs[1]

   REDEFINE say aControls[1] ID 111 OF oInforme:oFld:aDialogs[1]
   REDEFINE get aControls[2] var cMateria  ;
      ID 112 OF oInforme:oFld:aDialogs[1] UPDATE ;
      valid AztMaClave( @cMateria, aControls[2], 4 ) ;
      when oInforme:nRadio == 2
   REDEFINE BUTTON aControls[3]              ;
      ID 113 OF oInforme:oFld:aDialogs[1]    ;
      ACTION AztMaSeleccion( cMateria, aControls[2], oInforme:oFld:aDialogs[1] ) ;
      when oInforme:nRadio == 2
   aControls[3]:cTooltip := "seleccionar materia"

   REDEFINE say aControls[4] ID 121 OF oInforme:oFld:aDialogs[1]
   REDEFINE get aControls[5] var cAutor      ;
      ID 122 OF oInforme:oFld:aDialogs[1] UPDATE ;
      valid AuClave( @cAutor, aControls[5], 4 );
      when oInforme:nRadio == 3
   REDEFINE BUTTON aControls[6]              ;
      ID 123 OF oInforme:oFld:aDialogs[1]    ;
      ACTION AztAuSeleccion( @cAutor, aControls[5], oInforme:oFld:aDialogs[1] ) ;
      when oInforme:nRadio == 3
   aControls[6]:cTooltip := "seleccionar autor"

   REDEFINE say aControls[7] ID 131 OF oInforme:oFld:aDialogs[1]
   REDEFINE get aControls[8] var cPublica        ;
      ID 132 OF oInforme:oFld:aDialogs[1] UPDATE ;
      valid AztPuClave( @cPublica, aControls[8], 4 );
      when oInforme:nRadio == 4
   REDEFINE BUTTON aControls[9]              ;
      ID 133 OF oInforme:oFld:aDialogs[1]    ;
      ACTION AztPuSeleccion( @cPublica, aControls[8], oInforme:oFld:aDialogs[1] ) ;
      when oInforme:nRadio == 4
   aControls[9]:cTooltip := "seleccionar publicación"

   oInforme:Folders()

   if oInforme:Activate()
      select ZAR
      ZAR->(dbGoTop())
      if oInforme:nRadio == 1
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
            oInforme:oReport:Say(1, 'Total documentos: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
      elseif oInforme:nRadio == 2
         oInforme:cTitulo1  := RTrim(cMateria)
         oInforme:cTitulo2  := "relación de documentos de la materia"
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            for Upper(RTrim(ZAR->ArMateria)) == Upper(RTrim(cMateria))
         oInforme:End(.T.)
      elseif oInforme:nRadio == 3
         cAutor := Upper(RTrim(cAutor))
         ? "Pendiente"
   /*
         SELECT AA
         //AA->(OrdSetFocus(1))
         AA->(DbGoTop())
         do while ! AA->(EoF())
            if Upper(Rtrim(AA->AaNombre)) ==cAutor
               aadd(aDocumen, AA->AaUnico)
            endif
            AA->(DbSkip())
         enddo
   */
         select ZAR
         oInforme:cTitulo1  := RTrim(cAutor)
         oInforme:cTitulo2  := "relación de documentos del autor"
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            for AScan(aDocumen, ZAR->ArUnico) != 0
         oInforme:End(.T.)
      elseif oInforme:nRadio == 4
         oInforme:cTitulo1  := RTrim(cPublica)
         oInforme:cTitulo2  := "relación de documentos de la publicación"
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            for Upper(RTrim(ZAR->ArPublicac)) == Upper(RTrim(cPublica))
         oInforme:End(.T.)
      endif
      ZAR->(dbGoto(nRecno))
   endif

   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil

//_____________________________________________________________________________//

function GoFile( cFile )

   cFile := AllTrim( cFile )
   if cFile == ""
      MsgStop("La ruta del fichero está vacia.")
      return nil
   endif
   WinExec("rundll32.exe url.dll,FileProtocolHandler " + cFile)

return nil
