#include "FiveWin.ch"
#include "Report.ch"
#include "xBrowse.ch"
#include "vmenu.ch"
#include "TAutoGet.ch"

static oReport

function AztPublicaciones()

   local oCont
   local oCol
   local aBrowse
   local cState := GetPvProfString("Browse", "zPuState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "zPuOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "zPuRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "zPuSplit","102", oApp():cIniFile))
   local i

   if oApp():oDlg != NIL
      if oApp():nEdit > 0
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   if ! Db_AztOpenAll()
      return nil
   endif

   select ZPU
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de publicaciones')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   oApp():oGrid:cAlias := "ZPU"

   aBrowse   := { { {|| ZPU->PuNombre }, i18n("Nombre"), 150, 0 },;
      { {|| ZPU->PuMateria }, i18n("Materia"), 60, 0 },;
      { {|| ZPU->PuIdioma }, i18n("Idioma"), 30, 0 },;
      { {|| ZPU->PuPeriodi }, i18n("Periodicidad"), 60, 0 },;
      { {|| Trans(ZPU->PuPrecio, "@E 999,999.99") }, i18n("Precio"), 44, 1 },;
      { {|| Trans(ZPU->PuEjempl, "@E 999,999  ") }, i18n("Documentos"), 44, 1 },;
      { {|| ZPU->PuEditor }, i18n("Editor"), 150, 0 },;
      { {|| ZPU->PuDirecc }, i18n("Dirección"), 120, 0 },;
      { {|| ZPU->PuLocali }, i18n("Localidad"), 120, 0 },;
      { {|| ZPU->PuPais   }, i18n("Pais"), 120, 0 },;
      { {|| ZPU->PuTelefono }, i18n("Telefono"), 120, 0 },;
      { {|| ZPU->PuFax }, i18n("Fax"), 120, 0 },;
      { {|| ZPU->PuEmail }, i18n("E-mail"), 150, 0 },;
      { {|| ZPU->PuURL }, i18n("Sitio web"), 150, 0 },;
      { {|| DToC(ZPU->PuFchPago) }, i18n("Fch. Pago"), 120, 0 },;
      { {|| DToC(ZPU->PuFchCad) }, i18n("Fch. Expiración"), 120, 0 } }

   for i := 1 to Len(aBrowse)
      oCol := oApp():oGrid:AddCol()
      oCol:bStrData := aBrowse[ i, 1 ]
      oCol:cHeader  := aBrowse[ i, 2 ]
      oCol:nWidth   := aBrowse[ i, 3 ]
      oCol:nDataStrAlign := aBrowse[ i, 4 ]
      oCol:nHeadStrAlign := aBrowse[ i, 4 ]
   next

   // añado columnas con bitmaps

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource("BR_SUSC1")
   oCol:AddResource("BR_SUSC2")
   oCol:cHeader       := i18n("Suscrito")
   oCol:bBmpData      := {|| iif(ZPU->PuSuscrip,1,2) } // { || IIF(EMPTY(CL->ClInternet),2,1) }
   oCol:nWidth        := 23
   oCol:nDataBmpAlign := 2

   for i := 1 to Len(oApp():oGrid:aCols)
      oCol := oApp():oGrid:aCols[ i ]
      oCol:bLDClickData  := {|| AztPuEdita(oApp():oGrid,2,oCont,oApp():oDlg) }
   next

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont,"ZPU", "Publicaciones: ") }
   oApp():oGrid:bKeyDown := {|nKey| AztPuTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21

   oApp():oGrid:RestoreState( cState )

   ZPU->(dbSetOrder(nOrder))
   ZPU->(dbGoto(nRecno))


   @ 02, 05 VMENU oCont SIZE nSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION "Publicaciones: "+tran(ZPU->(ordKeyNo()),'@E 999,999')+" / "+tran(ZPU->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_PUBLICAC"

   DEFINE VMENUITEM OF oCont        ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Nuevo"              ;
      IMAGE "16_NUEVO"             ;
      ACTION AztPuEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Modificar"          ;
      IMAGE "16_MODIF"             ;
      ACTION AztPuEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Duplicar"           ;
      IMAGE "16_DUPLICAR"           ;
      ACTION AztPuEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Borrar"             ;
      IMAGE "16_BORRAR"            ;
      ACTION AztPuBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Buscar"             ;
      IMAGE "16_BUSCAR"             ;
      ACTION AztPuBusca(oApp():oGrid,,oCont,oApp():oDlg)  ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Imprimir"           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION AztPuImprime(oApp():oGrid,oApp():oDlg)         ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Visitar sitio web"  ;
      IMAGE "16_INTERNET"          ;
      ACTION GoWeb(ZPU->PuUrl)      ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar e-mail"      ;
      IMAGE "16_EMAIL"             ;
      ACTION GoMail(ZPU->PuEmail)   ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documentos"     ;
      IMAGE "16_DOCUMENT"          ;
      ACTION AztPuEjemplares( oApp():oGrid, oApp():oDlg ) ;
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
      ACTION Ut_BrwColConfig( oApp():oGrid, "zPuState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Salir"              ;
      IMAGE "16_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
      OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS ' Publicación ', ' Materia ',' Idioma ', ' Fecha expiración suscripción ';
      ACTION ( nOrder := oApp():oTab:nOption,;
      ZPU->(dbSetOrder(nOrder)),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont,"ZPU", "Publicaciones: ") )

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(), oApp():oGrid:SetFocus()) ;
      VALID ( oApp():oGrid:nLen := 0,;
      WritePProString("Browse","zPuState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","zPuOrder",LTrim(Str(ZPU->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","zPuRecno",LTrim(Str(ZPU->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","zPuSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oCont:End(), dbCloseAll(), oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, .T. )

return nil
//_____________________________________________________________________________//

function AztPuEdita( oGrid, nMode, oCont, oParent, cPublica )

   local oDlg, oFld, oBmp
   local aTitle := { i18n( "Añadir una publicación" ),;
      i18n( "Modificar una publicación"),;
      i18n( "Duplicar una publicación") }
   local aGet[25]
   local aSay[17]
   local cPunombre,;
      cPuPeriodi,;
      nPuprecio,;
      cPuMateria,;
      cPuIdioma,;
      cPueditor,;
      cPudirecc,;
      cPuLocali,;
      cPuPais,;
      cPutelefono,;
      cPufax,;
      cPuemail,;
      cPuurl,;
      cPunotas,;
      lPususcrip,;
      nPupresus,;
      dPufchpago,;
      dPufchcad

   local nRecPtr := ZPU->(RecNo())
   local nOrden  := ZPU->(ordNumber())
   local nRecAdd
   local lDuplicado
   local lReturn := .F.

   if ZPU->(Eof()) .AND. nMode != 1
      return nil
   endif

   oApp():nEdit ++

   if nMode == 1
      ZPU->(dbAppend())
      nRecAdd := ZPU->(RecNo())
   endif

   cPunombre   := iif(nMode==1.AND.cPublica!=NIL,cPublica,ZPU->PuNombre)
   cPuMateria  := ZPU->PuMateria
   cPuIdioma   := ZPU->PuIdioma
   cPuPeriodi  := ZPU->PuPeriodi
   nPuprecio   := ZPU->Puprecio
   cPueditor   := ZPU->Pueditor
   cPudirecc   := ZPU->Pudirecc
   cPulocali   := ZPU->Pulocali
   cPuPais     := ZPU->PuPais
   cPutelefono := ZPU->Putelefono
   cPufax      := ZPU->Pufax
   cPuemail    := ZPU->Puemail
   cPuurl      := ZPU->Puurl
   cPunotas    := ZPU->Punotas
   lPususcrip  := ZPU->Pususcrip
   nPupresus   := ZPU->Pupresus
   dPufchpago  := ZPU->Pufchpago
   dPufchcad   := ZPU->Pufchcad

   if nMode == 3
      ZPU->(dbAppend())
      nRecAdd := ZPU->(RecNo())
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTPUEDIT" OF oParent ;
      TITLE aTitle[nMode]
   oDlg:SetFont(oApp():oFont)

   REDEFINE say aSay[01] ID 201 OF oDlg
   REDEFINE say aSay[02] ID 202 OF oDlg
   REDEFINE say aSay[03] ID 203 OF oDlg
   REDEFINE say aSay[04] ID 204 OF oDlg
   REDEFINE say aSay[05] ID 205 OF oDlg

   REDEFINE get aGet[1] var cPuNombre        ;
      ID 101 OF oDlg UPDATE                  ;
      valid AztPuClave( cPuNombre, aGet[1], nMode )

   REDEFINE AUTOGET aGet[2] ;
      var cPuMateria ;
      ITEMS oAGet():aZMA ;
      ID 102 ;
      OF oDlg ;
      VALID ( AztMaClave( @cPuMateria, aGet[2], 4, .T., ) )

   REDEFINE BUTTON aGet[19]                     ;
      ID 103 OF oDlg                         ;
      ACTION AztMaSeleccion( cPuMateria, aGet[2], oDlg )
   aGet[19]:cTooltip := "seleccionar materia"

   REDEFINE AUTOGET aGet[3] ;
      var cPuIdioma ;
      ITEMS oAGet():aId ;
      ID 104 ;
      OF oDlg ;
      VALID ( IdClave( @cPuIdioma, aGet[3], "aux" ) )

   REDEFINE BUTTON aGet[20];
      ID 105;
      OF oDlg;
      ACTION ( IdTabAux( @cPuIdioma, aGet[3] ),;
      aGet[3]:setFocus(),;
      SysRefresh() )
   aGet[20]:cTooltip := "seleccionar idioma"

   REDEFINE get aGet[4] var cPuPeriodi       ;
      ID 106 OF oDlg UPDATE                  ;
      valid AztPeClave( cPuPeriodi, aget[4], 4 )
   REDEFINE BUTTON aGet[21]                  ;
      ID 107 OF oDlg                         ;
      ACTION AztPeSeleccion( cPuPeriodi, aGet[4], oDlg )
   aGet[21]:cTooltip := "seleccionar periodicidad"

   REDEFINE get aGet[5] var nPuPrecio        ;
      ID 108 OF oDlg UPDATE                  ;
      picture "@E 99,999.99"

   REDEFINE FOLDER oFld                      ;
      ID 110 OF oDlg                         ;
      ITEMS ' &Editor ', ' &Suscripción ', ' &Internet ',  ' &Notas ' ;
      DIALOGS "AZTPUEDIT_A", "AZTPUEDIT_D", "AZTPUEDIT_B", "AZTPUEDIT_C" ;
      OPTION 1

   REDEFINE say aSay[06] ID 211 OF oFld:aDialogs[1]
   REDEFINE say aSay[07] ID 212 OF oFld:aDialogs[1]
   REDEFINE say aSay[08] ID 213 OF oFld:aDialogs[1]
   REDEFINE say aSay[09] ID 214 OF oFld:aDialogs[1]
   REDEFINE say aSay[10] ID 215 OF oFld:aDialogs[1]
   REDEFINE say aSay[11] ID 216 OF oFld:aDialogs[1]
   REDEFINE say aSay[12] ID 221 OF oFld:aDialogs[2]
   REDEFINE say aSay[13] ID 222 OF oFld:aDialogs[2]
   REDEFINE say aSay[14] ID 223 OF oFld:aDialogs[2]
   REDEFINE say aSay[15] ID 231 OF oFld:aDialogs[3]
   REDEFINE say aSay[16] ID 232 OF oFld:aDialogs[3]
   REDEFINE say aSay[17] ID 241 OF oFld:aDialogs[4]

   REDEFINE get aGet[6] var cPuEditor        ;
      ID 111 OF oFld:aDialogs[1] UPDATE

   REDEFINE get aGet[7] var cPuTelefono      ;
      ID 112 OF oFld:aDialogs[1] UPDATE

   REDEFINE get aGet[8] var cPuFax           ;
      ID 113 OF oFld:aDialogs[1] UPDATE

   REDEFINE get aGet[9] var cPuDirecc        ;
      ID 114 OF oFld:aDialogs[1] UPDATE

   REDEFINE get aGet[10] var cPuLOCALi       ;
      ID 115 OF oFld:aDialogs[1] UPDATE

   REDEFINE get aGet[11] var cPuPais         ;
      ID 116 OF oFld:aDialogs[1] UPDATE

   REDEFINE CHECKBOX aGet[12] var lPuSuscrip    ;
      ID 120 OF oFld:aDialogs[2] UPDATE

   REDEFINE get aGet[13] var dPuFchPago      ;
      ID 121 OF oFld:aDialogs[2] UPDATE
   REDEFINE BUTTON aGet[24]                  ;
      ID 124 OF oFld:aDialogs[2]             ;
      ACTION SelecFecha( dPuFchPago, aGet[13] )
   aGet[24]:cTooltip := "seleccionar fecha"

   REDEFINE get aGet[14] var dPuFchCad       ;
      ID 122 OF oFld:aDialogs[2] UPDATE
   REDEFINE BUTTON aGet[25]                  ;
      ID 125 OF oFld:aDialogs[2]             ;
      ACTION SelecFecha( dPuFchCad, aGet[14] )
   aGet[25]:cTooltip := "seleccionar fecha"

   REDEFINE get aGet[15] var nPuPreSus       ;
      ID 123 OF oFld:aDialogs[2] UPDATE      ;
      picture "@E 99,999.99"

   REDEFINE get aGet[16] var cPuEmail        ;
      ID 131 OF oFld:aDialogs[3] UPDATE
   REDEFINE BUTTON aGet[22]                  ;
      ID 132 OF oFld:aDialogs[3]             ;
      ACTION GoMail( cPuEmail )
   aGet[22]:cTooltip := "enviar e-mail"

   REDEFINE get aGet[17] var cPuUrl          ;
      ID 133 OF oFld:aDialogs[3] UPDATE
   REDEFINE BUTTON aGet[23]                  ;
      ID 134 OF oFld:aDialogs[3]             ;
      ACTION GoWeb( cPuUrl )
   aGet[23]:cTooltip := "visitar sitio web"

   REDEFINE get aGet[18] var cPuNotas        ;
      ID 141 OF oFld:aDialogs[4] MULTILINE UPDATE

   REDEFINE BUTTON   ;
      ID    IDOK     ;
      OF    oDlg     ;
      ACTION   ( oDlg:end( IDOK ) )

   REDEFINE BUTTON   ;
      ID    IDCANCEL ;
      OF    oDlg     ;
      CANCEL         ;
      ACTION   ( oDlg:end( IDCANCEL ) )

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

   if oDlg:nresult == IDOK
      lReturn := .T.
      if nMode == 2
         ZPU->(dbGoto(nRecPtr))
      else
         ZPU->(dbGoto(nRecAdd))
      endif
      // ___ actualizo el nombre de la publicación en los documentos __________//
      if nMode == 2
         if Upper(RTrim(cPuNombre)) != Upper(RTrim(ZPU->PuNombre))
            msgRun( i18n( "Revisando el fichero de publicaciones. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
               {|| AztPuCambiaClave( cPuNombre, ZPU->PuNombre ) } )
         endif
      endif
      // ___ guardo el registro _______________________________________________//
      select ZPU
      replace ZPU->punombre      with  cPunombre
      replace ZPU->pumateria     with  cPumateria
      replace ZPU->puidioma      with  cPuidioma
      replace ZPU->PuPeriodi      with  cPuPeriodi
      replace ZPU->Puprecio      with  nPuprecio
      replace ZPU->Pueditor      with  cPueditor
      replace ZPU->Pudirecc      with  cPudirecc
      replace ZPU->PuLOCALi      with  cPuLOCALi
      replace ZPU->Pupais        with  cPuPais
      replace ZPU->Putelefono    with  cPutelefono
      replace ZPU->PuFax         with  cPuFax
      replace ZPU->Puemail       with  cPuemail
      replace ZPU->Puurl         with  cPuurl
      replace ZPU->Punotas       with  cPunotas
      replace ZPU->Pususcrip     with  lPususcrip
      replace ZPU->Pupresus      with  nPupresus
      replace ZPU->Pufchpago     with  dPufchpago
      replace ZPU->Pufchcad      with  dPufchcad
      ZPU->(dbCommit())
      if cPublica != NIL
         cPublica := ZPU->PuNombre
      endif
		oAGet():lzPu := .T.
      oAGet():Load()
   else
      lReturn := .F.
      if nMode == 1 .OR. nMode == 3

         ZPU->(dbGoto(nRecAdd))
         ZPU->(dbDelete())
         ZPU->(DbPack())
         ZPU->(dbGoto(nRecPtr))

      endif

   endif

   select ZPU

   oApp():nEdit --
   if oCont != NIL
      RefreshCont(oCont,"ZPU", "Publicaciones: ")
   endif
   if oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .T. )
   endif

return lReturn
//_____________________________________________________________________________//

function AztPuBorra( oGrid, oCont )

   local nRecord := ZPU->( RecNo() )
   local nNext

   oApp():nEdit ++
   if msgYesNo( i18n("¿ Está seguro de querer borrar esta publicación ?") + CRLF + ;
         (Trim(ZPU->PuNombre)))
      // dejo en blanco los documentos de la publicación
      msgRun( i18n( "Revisando el fichero de publicaciones. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         {|| AztPuCambiaClave( Space(50), ZPU->PuNombre ) } )
      // borro la publicación
      select ZPU
      ZPU->(dbSkip())
      nNext := ZPU->(RecNo())
      ZPU->(dbGoto(nRecord))

      ZPU->(dbDelete())
      ZPU->(DbPack())
      ZPU->(dbGoto(nNext))
      if ZPU->(Eof()) .OR. nNext == nRecord
         ZPU->(dbGoBottom())
      endif
		oAGet():lzPu := .T.
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont(oCont,"ZPU","Publicaciones: ")
   endif

   oApp():nEdit --
   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)

return nil
//_____________________________________________________________________________//


function AztPuTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztPuEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztPuEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztPuBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztPuBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztPuBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil
//_____________________________________________________________________________//

function AztPuSeleccion( cPublica, oControl, oParent )

   local oDlg, oBrowse, oCol
   local oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   local lOk    := .F.
   local nRecno := ZPU->( RecNo() )
   local nOrder := ZPU->( ordNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local cBrwState  := ""

   oApp():nEdit ++
   ZPU->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "PuAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de Publicaciones" )      ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ZPU"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZPU->PuNombre }
   oCol:cHeader  := i18n( "Publicación" )
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztPuTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION AztPuEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION AztPuEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION AztPuBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION AztPuBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .T., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .F., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      on PAINT oDlg:Move(aPoint[1], aPoint[2],,,.T.)

   if lOK
      oControl:cText := ZPU->PuNombre
      #ifndef __REGISTRADA__
         Registrame()
      #endif
   endif

   SetIni( , "Browse", "PuAux", oBrowse:SaveState() )
   ZPU->( dbSetOrder( nOrder ) )
   ZPU->( dbGoto( nRecno ) )
   oApp():nEdit --

   select (nArea)

return nil
//_____________________________________________________________________________//


function AztPuBusca( oGrid, cChr, oCont, oParent )

   local nOrder    := ZPU->(ordNumber())
   local nRecno    := ZPU->(RecNo())
   local oDlg, oGet, cGet, cPicture
   local aSay1    := { " Introduzca el nombre de la publicación",;
      " Introduzca la materia",;
      " Introduzca el idioma",;
      " Introduzca la fecha de expiración de la suscripción"    }
   local aSay2    := { "Publicación:",;
      "Materia:",;
      "Idioma:",;
      "Fecha:"        }
   local aGet     := { Space(50),;
      Space(30),;
      Space(15),;
      CToD("")  }

   local cNombre   := Space(50)
   local cPeriodo  := Space(10)
   local dFecha    := CToD('')
   local lSeek     := .F.
   local lFecha    := .F.
   local aBrowse   := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR' OF oParent  ;
      TITLE i18n("Búsqueda de publicaciones")
   oDlg:SetFont(oApp():oFont)

   REDEFINE say prompt aSay1[nOrder] ID 20 OF oDlg
   REDEFINE say prompt aSay2[nOrder] ID 21 OF Odlg

   cGet  := aGet[nOrder]

   if nOrder == 4
      lFecha := .T.
   endif
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
      endif
      MsgRun('Realizando la búsqueda...', oApp():cAppName+oApp():cVersion, ;
         {|| AztPuWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ninguna publicación")
      else
         AztPuEncontrados(aBrowse, oApp():oDlg)
      endif
   endif
   ZPU->(ordSetFocus(nOrder))
   //ZPU->(DbGoTo(nRecno))

   RefreshCont(oCont,"ZPU","Publicaciones: " )
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztPuWildSeek(nOrder, cGet, aBrowse)

   local nRecno   := ZPU->(RecNo())

   do case
   case nOrder == 1
      ZPU->(dbGoTop())
      do while ! ZPU->(Eof())
         if cGet $ Upper(ZPU->PuNombre)
            AAdd(aBrowse, {ZPU->PuNombre, ZPU->PuMateria, ZPU->PuIdioma })
         endif
         ZPU->(dbSkip())
      enddo
   case nOrder == 2
      ZPU->(dbGoTop())
      do while ! ZPU->(Eof())
         if cGet $ Upper(ZPU->PuMateria)
            AAdd(aBrowse, {ZPU->PuNombre, ZPU->PuMateria, ZPU->PuIdioma })
         endif
         ZPU->(dbSkip())
      enddo
   case nOrder == 3
      ZPU->(dbGoTop())
      do while ! ZPU->(Eof())
         if cGet $ Upper(ZPU->PuIdioma)
            AAdd(aBrowse, {ZPU->PuNombre, ZPU->PuMateria, ZPU->PuIdioma })
         endif
         ZPU->(dbSkip())
      enddo
   case nOrder == 4
      ZPU->(dbGoTop())
      do while ! ZPU->(Eof())
         if cGet $ DToS(ZPU->PuFchCad)
            AAdd(aBrowse, {ZPU->PuNombre, ZPU->PuMateria, ZPU->PuIdioma })
         endif
         ZPU->(dbSkip())
      enddo
   end case
   ZPU->(dbGoto(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztPuEncontrados(aBrowse, oParent)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ZPU->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Publicación"
   oBrowse:aCols[2]:cHeader := "Materia"
   oBrowse:aCols[3]:cHeader := "Idioma"
   oBrowse:aCols[1]:nWidth  := 220
   oBrowse:aCols[2]:nWidth  := 120
   oBrowse:aCols[3]:nWidth  := 140
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   ZPU->(ordSetFocus(1))
   ZPU->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ZPU->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztPuEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ZPU->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztPuEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| ZPU->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ZPU->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

//_____________________________________________________________________________//

function AztPuClave( cPublica, oGet, nMode )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lReturn  := .F.
   local nRecno   := ZPU->( RecNo() )
   local nOrder   := ZPU->( ordNumber() )
   local nArea    := Select()

   if Empty( cPublica )
      if nMode == 4
         return .T.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .F.
      endif
   endif

   select ZPU
   ZPU->( dbSetOrder( 1 ) )
   ZPU->( dbGoTop() )

   if ZPU->( dbSeek( Upper( cPublica ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("Publicación existente.")
      case nMode == 2
         if ZPU->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("Publicación existente.")
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
         if MsgYesNo("Publicación inexistente. ¿ Desea darla de alta ahora ? ")
            lReturn := AztPuEdita( , 1, , , @cPublica )
         else
            lReturn := .F.
         endif
      endif
   endif

   if lReturn == .F.
      oGet:cText( Space(50) )
   else
      oGet:cText( cPublica )
   endif

   ZPU->( dbSetOrder( nOrder ) )
   ZPU->( dbGoto( nRecno ) )

   select (nArea)

return lReturn
//_____________________________________________________________________________//

function AztPuCambiaClave( cVar, cOld )

   local nOrder
   local nRecNo

   cOld := Upper(RTrim(cOld))
   // cambio la materia de publicaciones
   //? 'PuCambiaClave'
   select ZAR
   nRecno := ZAR->(RecNo())
   nOrder := ZAR->(ordNumber())
   ZAR->(dbSetOrder(0))
   ZAR->(dbGoTop())
   do while ! ZAR->(Eof())
      if Upper(RTrim(ZAR->ArPublicac)) == cOld
         replace ZAR->ArPublicac with cVar
      endif
      ZAR->(dbSkip())
   enddo
   ZAR->(dbSetOrder(nOrder))
   ZAR->(dbGoto(nRecno))

return nil
//_____________________________________________________________________________//

function AztPuImprime(oGrid,oParent)

   local nRecno   := ZPU->(RecNo())
   local nOrder   := ZPU->(ordSetFocus())
   local aCampos  := { "PUNOMBRE","PUMATERIA","PUIDIOMA","PUPERIODI","PUPRECIO",;
      "PUEJEMPL","PUEDITOR","PUDIRECC","PULOCALI","PUPAIS",;
      "PUTELEFONO","PUFAX","PUEMAIL","PUURL","PUFCHPAGO","PUFCHCAD" }
   local aTitulos := { "Publicación", "Materia", "Idioma","Periodicidad","Precio",;
      "Documentos", "Editor","Direccion","Localidad","Pais",;
      "Teléfono", "Fax", "e-mail","Sitio web", "Inicio Susc.","Fin Susc." }
   local aWidth   := { 50, 30, 20, 30, 10, 10, 30, 30, 30, 30, 20, 20, 20, 20, 20, 20 }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO","NO","NO","NO","NO","NO","NO","NO", "NO","NO","NO","NO","NO","NO","NO","NO" }
   local aTotal   := { .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F., .F. }
   local oInforme
   local aControls[3]
   local cPuMateria := Space(40)

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ZPU" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300, 301 OF oInforme:oFld:aDialogs[1]

   REDEFINE say aControls[1] ID 111 OF oInforme:oFld:aDialogs[1]
   REDEFINE get aControls[2] var cPuMateria  ;
      ID 112 OF oInforme:oFld:aDialogs[1] UPDATE ;
      valid AztMaClave( @cPuMateria, aControls[2], 4 )
   REDEFINE BUTTON aControls[3]              ;
      ID 113 OF oInforme:oFld:aDialogs[1]    ;
      ACTION AztMaSeleccion( cPuMateria, aControls[2], oInforme:oFld:aDialogs[1] )
   aControls[3]:cTooltip := "seleccionar materia"

   oInforme:Folders()

   if oInforme:Activate()
      ZPU->(dbGoTop())
      if oInforme:nRadio == 1
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
            oInforme:oReport:Say(1, 'Total publicaciones: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
      elseif oInforme:nRadio == 2
         oInforme:cTitulo1  := RTrim(cPuMateria)
         oInforme:cTitulo2  := "relación de publicaciones de la materia"
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            for Upper(RTrim(ZPU->PuMateria)) == Upper(RTrim(cPuMateria))
         oInforme:End(.F.)
      endif
      ZPU->(dbGoto(nRecno))
   endif

   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil
//_____________________________________________________________________________//
function AztPuEjemplares( oGrid, oParent )

   local cPuNombre   := ZPU->PuNombre
   local oDlg, oBrowse, oCol

   if ZPU->PuEjempl == 0
      MsgStop("La publicación no aparece en ningún documento.")
      return nil
   endif
	#ifndef __REGISTRADA__
	   Registrame()
	#endif

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'MA_EJEMPLARES'    ;
      TITLE 'Documentos de la publicación: '+RTrim(cPuNombre) OF oParent
   oDlg:SetFont(oApp():oFont)

   select ZAR
   ZAR->(dbSetOrder(5))
   ordScope(0, {|| Upper(cPuNombre) })
   ordScope(1, {|| Upper(cPuNombre) })
   ZAR->(dbGoTop())

   oBrowse := TXBrowse():New( oDlg )
   Ut_BrwRowConfig( oBrowse )
   oBrowse:cAlias := "ZAR"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZAR->ArTitulo }
   oCol:cHeader  := i18n( "Título" )
   oCol:nWidth   := 250
   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZAR->ArAutor }
   oCol:cHeader  := i18n( "Autor princ." )
   oCol:nWidth   := 100
   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZAR->ArMateria }
   oCol:cHeader  := i18n( "Materia" )
   oCol:nWidth   := 150

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| AztArEdita( oBrowse, 2,,oDlg ) } } )
   oBrowse:bKeyDown := {|nKey| AztArTecla( nKey, oBrowse, , oDlg ) }

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 100 )
   oDlg:oClient := oBrowse
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON ID IDOK OF oDlg ;
      prompt i18n( "&Aceptar" )   ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

   ordScope( 0, )
   ordScope( 1, )

   select ZPU
   oGrid:Refresh()
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil

function AztPuList( aList, cData, oSelf )
   local aNewList := {}
   ZPU->( dbSetOrder(1) )
   ZPU->( dbGoTop() )
   while ! ZPU->(Eof())
      if at(Upper(cdata), Upper(ZPU->PuNombre)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aNewList, { ZPU->PuNombre } )
      endif 
      ZPU->(DbSkip())
   enddo
return aNewlist
