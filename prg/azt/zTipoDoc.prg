#include "FiveWin.ch"
#include "Report.ch"
#include "xBrowse.ch"
#include "vmenu.ch"

static oReport

function AztTipoDoc()

   local oCol
   local aBrowse
   local cState := GetPvProfString("Browse", "zTdState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "zTdOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "zTdRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "zTdSplit","102", oApp():cIniFile))
   local oCont
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

   select ZTD
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de tipos de documento')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   oApp():oGrid:cAlias := "ZTD"

   aBrowse   := { { {|| ZTD->TdTipoDoc }, i18n( "Tipo de documento" ), 150, 0 },;
      { {|| TRAN( ZTD->TdEjempl, "@E 99,999  " ) }, i18n( "Documentos" ), 90, 1 } }

   for i := 1 to Len(aBrowse)
      oCol := oApp():oGrid:AddCol()
      oCol:bStrData := aBrowse[ i, 1 ]
      oCol:cHeader  := aBrowse[ i, 2 ]
      oCol:nWidth   := aBrowse[ i, 3 ]
      oCol:nDataStrAlign := aBrowse[ i, 4 ]
      oCol:nHeadStrAlign := aBrowse[ i, 4 ]
   next

   for i := 1 to Len(oApp():oGrid:aCols)
      oCol := oApp():oGrid:aCols[ i ]
      oCol:bLDClickData  := {|| AztTdEdita(oApp():oGrid,2,oCont,oApp():oDlg) }
   next

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont, "ZTD", "Tipos de documento: ") }
   oApp():oGrid:bKeyDown := {|nKey| AztTdTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21
   oApp():oGrid:RestoreState( cState )

   ZTD->(dbSetOrder(nOrder))
   ZTD->(dbGoto(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION "Tipos de documento: "+tran(ZTD->(ordKeyNo()),'@E 999,999')+" / "+tran(ZTD->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_TIPODOC"

   DEFINE VMENUITEM OF oCont        ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Nuevo"              ;
      IMAGE "16_NUEVO"             ;
      ACTION AztTdEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Modificar"          ;
      IMAGE "16_MODIF"             ;
      ACTION AztTdEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Duplicar"           ;
      IMAGE "16_DUPLICAR"           ;
      ACTION AztTdEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Borrar"             ;
      IMAGE "16_BORRAR"            ;
      ACTION AztTdBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Buscar"             ;
      IMAGE "16_BUSCAR"             ;
      ACTION AztTdBusca(oApp():oGrid,,oCont) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Imprimir"           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION AztTdImprime(oApp():oDlg, oApp():oGrid) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documentos"     ;
      IMAGE "16_DOCUMENT"        ;
      ACTION AztTdEjemplares( oApp():oGrid, oApp():oDlg ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar a Excel"     ;
      IMAGE "16_EXCEL"             ;
      ACTION (CursorWait(), oApp():oGrid:ToExcel(), CursorArrow());
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Configurar rejilla" ;
      IMAGE "16_GRID"              ;
      ACTION Ut_BrwColConfig( oApp():oGrid, "zTdState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Salir"              ;
      IMAGE "16_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
      OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS ' Tipo de documento ';
      ACTION ( nOrder := oApp():oTab:nOption,;
      ZTD->(dbSetOrder(nOrder)),;
      ZTD->(dbGoTop()),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont, "ZTD", "Tipos de documento: ") )

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(), oApp():oGrid:SetFocus()) ;
      VALID ( oApp():oGrid:nLen := 0,;
      WritePProString("Browse","zTdState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","zTdOrder",LTrim(Str(ZTD->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","zTdRecno",LTrim(Str(ZTD->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","zTdSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oCont:End(), dbCloseAll(), oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, .T. )

return nil
//_____________________________________________________________________________//

function AztTdEdita( oGrid, nMode, oCont, oParent, cTipoDoc )

   local oDlg, oFld, oBmp
   local aTitle := { i18n( "Añadir un tipo de documento" ),;
      i18n( "Modificar un tipo de documento"),;
      i18n( "Duplicar un tipo de documento") }
   local aGet[1]
   local cTdTipoDoc

   // LOCAL nTdEjempl
   local nRecPtr := ZTD->(RecNo())
   local nOrden  := ZTD->(ordNumber())
   local nRecAdd
   local lDuplicado
   local lReturn := .F.

   if ZTD->(Eof()) .AND. nMode != 1
      return nil
   endif

   oApp():nEdit ++

   if nMode == 1
      ZTD->(dbAppend())
      nRecAdd  := ZTD->(RecNo())
   endif

   cTdTipoDoc  := iif(nMode==1.AND.cTipoDoc!=NIL,cTipoDoc,ZTD->TdTipoDoc)
   // nTdEjempl   := ZTD->TdEjempl

   if nMode == 3
      ZTD->(dbAppend())
      nRecAdd := ZTD->(RecNo())
   endif

   if oParent == NIL
      oParent := oApp():oDlg
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTTDEDIT"   ;
      TITLE aTitle[ nMode ]               ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   REDEFINE say ID 11 OF oDlg
   //REDEFINE SAY ID 13 OF oDlg
   //REDEFINE SAY VAR nTdEjempl     ;
   // PICTURE "@E 99,999" ID 14 OF oDlg

   REDEFINE get aGet[1] var cTdTipoDoc    ;
      ID 12 OF oDlg UPDATE                ;
      valid AztTdClave( cTdTipoDoc, aGet[1], nMode )

   // TLine():Redefine(oDlg,500)

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
         ZTD->(dbGoto(nRecPtr))
      else
         ZTD->(dbGoto(nRecAdd))
      endif
      // ___ actualizo la tipo de documento en el fichero de documentos _______//
      if nMode == 2
         if cTdTipoDoc != ZTD->TdTipoDoc
            msgRun( i18n( "Revisando el fichero de tipos de documento. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
               {|| AztTdCambiaClave( cTdTipoDoc, ZTD->TdTipoDoc ) } )
         endif
      endif

      // ___ guardo el registro _______________________________________________//

      select ZTD
      replace ZTD->TdTipoDoc  with cTdTipoDoc
      // Replace ZTD->TdEjempl   with nTdEjempl
      ZTD->(dbCommit())
      if cTipoDoc != NIL
         cTipoDoc := ZTD->TdTipoDoc
      endif
      oAGet():lzTd := .T.
      oAGet():Load()
   else
      lReturn := .F.
      if nMode == 1 .OR. nMode == 3

         ZTD->(dbGoto(nRecAdd))
         ZTD->(dbDelete())
         ZTD->(DbPack())
         ZTD->(dbGoto(nRecPtr))

      endif

   endif

   select ZTD

   if oCont != NIL
      RefreshCont(oCont, "ZTD", "Tipos de documento: ")
   endif
   if oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .T. )
   endif

   oApp():nEdit --

return lReturn
//_____________________________________________________________________________//

function AztTdBorra(oGrid,oCont)

   local nRecord  := ZTD->(RecNo())
   local cKeyNext
   local nAuxRecno
   local nAuxOrder

   oApp():nEdit ++

   if msgYesNo( i18n("¿ Está seguro de querer borrar este tipo de documento ?") + CRLF + ;
         (Trim(ZTD->TdTipoDoc)))

      msgRun( i18n( "Revisando el fichero de tipos de documento. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         {|| AztTdCambiaClave( Space(30), ZTD->TdTipoDoc ) } )

      // borrado de la tipo de documento
      ZTD->(dbSkip())
      cKeyNext := ZTD->(ordKeyVal())
      ZTD->(dbGoto(nRecord))
      ZTD->(dbDelete())
      ZTD->(DbPack())
      oAGet():lzTd := .T.
      oAGet():Load()
      if cKeyNext != NIL
         ZTD->(dbSeek(cKeyNext))
      else
         ZTD->(dbGoBottom())
      endif
   endif

   if oCont != NIL
      RefreshCont(oCont, "ZTD", "Tipos de documento: ")
   endif

   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil
//_____________________________________________________________________________//

function AztTdTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztTdEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztTdEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztTdBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztTdBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztTdBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil
//_____________________________________________________________________________//

function TdAgrupa( oGrid, oParent )

   MsgAlert('opción no disponible')
/*
   LOCAL oDlg, oFld, oBmp
   LOCAL cTitle := i18n( "Agrupar temáticas" )
   LOCAL aSay[4]

   LOCAL cPlPlato  ,;
         cPltipo   ,;
         nPlRecetas

   LOCAL nRecno  := ZUB->(RecNo())
   LOCAL nOrden  := ZUB->(OrdNumber())
   LOCAL nRecAdd
   LOCAL lDuplicado
   LOCAL aPlatos := {}

   oApp():nEdit ++

   cPlPlato    := ZUB->PlPlato
   cPlTipo     := ZUB->PlTipo
   nPlRecetas  := ZUB->PlRecetas

   ZUB->(DbGoTop())
   DO WHILE ! ZUB->(EOF())
      AADD(aPlatos,ZUB->PlTipo)
      ZUB->(DbSkip())
   ENDDO
   cPlato := aPlatos[1]

   DEFINE DIALOG oDlg RESOURCE "PLATOS3" ;
      TITLE cTitle + cTitulo OF oParent

   REDEFINE SAY aSay[1]       ;
      ID 10 OF oDlg COLOR CLR_BLACK, CLR_WHITE

   REDEFINE SAY aSay[2]       ;
      ID 11 OF oDlg

   REDEFINE SAY aSay[3]       ;
      PROMPT cPlTipo          ;
      COLOR CLR_HBLUE, GetSysColor(15) ;
      ID 12 OF oDlg

   REDEFINE SAY aSay[4]       ;
      ID 13 OF oDlg

   REDEFINE COMBOBOX oCom01   ;
      VAR cPlato              ;
      ITEMS aplatos           ;
      ID 14 OF oDlg

   TLine():Redefine(oDlg,500)

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
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

   IF oDlg:nresult == IDOK

      // ___ actualizo el tipo de plato en la receta___________________________//
      Select RE
      RE->(DbSetOrder(0))
      RE->(DbGoTop())
      IF cPlPlato $ '12345'
      Replace RE->ReTipo      ;
         with cPlato          ;
         for Upper(Rtrim(RE->ReTipo)) == Upper(rtrim(cPltipo))
      ELSE
         Replace RE->ReTipoCoc   ;
         with cPlato             ;
         for Upper(Rtrim(RE->ReTipoCoc)) == Upper(rtrim(cPltipo))
      ENDIF

      // ___ borro el tipo de plato y reposiciono el puntero___________________//

      Select PL
      ZUB->(DbGoTo(nRecno))
      nRecetas := ZUB->PlRecetas
      ZUB->(DbDelete())

      ZUB->(DbSeek(cPlato))

      Replace ZUB->PlRecetas  with ZUB->PlRecetas + nRecetas

      ZUB->(DbCommit())

   ELSE

      ZUB->(DbGoTo(nRecno))

   ENDIF

   SELECT PL

   oGrid:Refresh(.t.)
   oGrid:SetFocus(.t.)
   oApp():nEdit --
*/

return nil

//_____________________________________________________________________________//

function AztTdSeleccion( cMateria, oControl, oParent )

   local oDlg, oBrowse, oCol
   local oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   local lOk    := .F.
   local nRecno := ZTD->( RecNo() )
   local nOrder := ZTD->( ordNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local cBrwState  := ""

   oApp():nEdit ++
   ZTD->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "TdAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de tipos de documento" )    ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ZTD"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZTD->TdTipodoc }
   oCol:cHeader  := i18n( "tipo de documento" )
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztTdTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION AztTdEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION AztTdEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION AztTdBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION AztTdBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .T., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .F., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      on PAINT oDlg:Move(aPoint[1], aPoint[2],,,.T.)

   if lOK
      oControl:cText := ZTD->TdTipoDoc
   endif

   SetIni( , "Browse", "TdAux", oBrowse:SaveState() )
   ZTD->( dbSetOrder( nOrder ) )
   ZTD->( dbGoto( nRecno ) )
   oApp():nEdit --

   select (nArea)

return nil
//_____________________________________________________________________________//


function AztTdBusca( oGrid, cChr, oCont, oParent )

   local nOrder   := ZTD->(ordNumber()) // el primer TAG es sin tipo
   local nRecno   := ZTD->(RecNo())
   local oDlg, oGet, cPicture
   local aSay1    := "Introduzca el tipo de documento a buscar"
   local aSay2    := "tipo de documento:"
   local cGet     := Space(60)
   local lSeek    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR'   ;
      TITLE i18n("Búsqueda de tipos de documento") OF oParent
   oDlg:SetFont(oApp():oFont)

   REDEFINE say prompt aSay1 ID 20 OF oDlg
   REDEFINE say prompt aSay2 ID 21 OF Odlg

   //__ si he pasado un caracter lo meto en la cadena a buscar ________________//

   if cChr != NIL
      if ! lFecha
         cGet := cChr+SubStr(cGet,1,Len(cGet)-1)
      else
         cGet := CToD(cChr+' -  -    ')
      endif
   endif

   if ! lFecha
      REDEFINE get oGet var cGet picture "@!" ID 101 OF oDlg
   else
      REDEFINE get oGet var cGet ID 101 OF oDlg
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
      on init DlgCenter(oDlg,oApp():oWndMain) // , IIF(cChr!=NIL,oGet:SetPos(2),), oGet:Refresh() )

   if lSeek
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cAppName+oApp():cVersion, ;
         {|| AztTdWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ningún tipo de documento")
      else
         AztTdEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   ZTD->(ordSetFocus(nOrder))
   // ZTD->(DbGoTo(nRecno))

   RefreshCont(oCont, "ZTD", "Tipos de documento: ")
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztTdWildSeek(nOrder, cGet, aBrowse)

   local nRecno   := ZTD->(RecNo())

   do case
   case nOrder == 1
      ZTD->(dbGoTop())
      do while ! ZTD->(Eof())
         if cGet $ Upper(ZTD->TdTipoDoc)
            AAdd(aBrowse, {ZTD->TdTipoDoc })
         endif
         ZTD->(dbSkip())
      enddo
   end case
   ZTD->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztTdEncontrados(aBrowse, oParent)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ZTD->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Tipo de documento"
   oBrowse:aCols[1]:nWidth  := 220
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   ZTD->(ordSetFocus(1))
   ZTD->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ZTD->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztTdEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ZTD->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztTdEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| ZTD->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ZTD->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

//_____________________________________________________________________________//

function AztTdClave( cTipodoc, oGet, nMode )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lReturn  := .F.
   local nRecno   := ZTD->( RecNo() )
   local nOrder   := ZTD->( ordNumber() )
   local nArea    := Select()

   if Empty( cTipodoc )
      if nMode == 4
         return .T.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .F.
      endif
   endif

   select ZTD
   ZTD->( dbSetOrder( 1 ) )
   ZTD->( dbGoTop() )

   if ZTD->( dbSeek( Upper( cTipodoc ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("tipo de documento existente.")
      case nMode == 2
         if ZTD->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("tipo de documento existente.")
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
         if MsgYesNo("Tipo de documento inexistente en el fichero de tipos de documento."+CRLF+"¿ Desea darlo de alta ? ")
            lReturn := AztTdEdita( , 1, , , @cTipoDoc )
         else
            lReturn := .F.
         endif
      endif
   endif

   if lReturn == .F.
      oGet:cText( Space(30) )
   else
      oGet:cText( cTipoDoc )
   endif

   ZTD->( dbGoto( nRecno ) )
   select (nArea)

return lReturn
//_____________________________________________________________________________//

function AztTdCambiaClave( cNew, cOld )

   local nAuxOrder
   local nAuxRecNo

   // cambio la materia de documentos
   select ZAR
   nAuxRecno := ZAR->(RecNo())
   nAuxOrder := ZAR->(ordNumber())
   ZAR->(dbSetOrder(0))
   ZAR->(dbGoTop())
   replace ZAR->ArTipodoc      ;
      with cNew               ;
      for Upper(RTrim(ZAR->ArTipodoc)) == Upper(RTrim(cOld))
   ZAR->(dbSetOrder( nAuxOrder ))
   ZAR->(dbGoto( nAuxRecno ))

return nil
//_____________________________________________________________________________//

function AztTdEjemplares( oGrid, oParent )

   local cTdTipodoc  := ZTD->TdTipoDoc
   local oDlg, oBrowse, oCol

   if ZTD->TdEjempl == 0
      MsgStop("El tipo de documento no aparece en ningún documento.")
      return nil
   endif

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'MA_EJEMPLARES'    ;
      TITLE 'Documentos del tipo de documento: '+RTrim(cTdTipodoc) OF oParent
   oDlg:SetFont(oApp():oFont)

   select ZAR
   ZAR->(dbSetOrder(6))
   ordScope(0, {|| Upper(cTdTipodoc) })
   ordScope(1, {|| Upper(cTdTipodoc) })
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

   // oBrowse:RestoreState( cBrwState )
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON ID IDOK OF oDlg ;
      prompt i18n( "&Aceptar" )   ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

   ordScope( 0, )
   ordScope( 1, )

   select ZTD
   oGrid:Refresh()
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil

//_____________________________________________________________________________//

function AztTdImprime(oParent, oGrid)

   local nRecno   := ZTD->(RecNo())
   local nOrder   := ZTD->(ordSetFocus())
   local aCampos  := { "TdTipoDoc", "TdEjempl" }
   local aTitulos := { "Tipo Documento", "Documentos" }
   local aWidth   := { 40, 20 }
   local aShow    := { .T., .T. }
   local aPicture := { "NO", "NO" }
   local aTotal   := { .F., .T. }
   local oInforme

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ZTD" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()

   if oInforme:Activate()
      ZTD->(dbGoTop())
      oInforme:Report()
      ACTIVATE REPORT oInforme:oReport ;
         on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
         oInforme:oReport:Say(1, 'Total tipos de documentos: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
         oInforme:oReport:EndLine() )

      oInforme:End(.T.)
      ZTD->(dbGoto(nRecno))
   endif

   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil
//_____________________________________________________________________________//

function AztTdList( aList, cData, oSelf )
   local aNewList := {}
   ZTD->( dbSetOrder(1) )
   ZTD->( dbGoTop() )
   while ! ZTD->(Eof())
      if at(Upper(cdata), Upper(ZTD->TdTipoDoc)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aNewList, { ZTD->TdTipoDoc } )
      endif 
      ZTD->(DbSkip())
   enddo
return aNewlist
