#include "FiveWin.ch"
#include "Report.ch"
#include "xBrowse.ch"
#include "vmenu.ch"

static oReport

function AztUbicaciones()

   local oCol
   local aBrowse
   local cState := GetPvProfString("Browse", "zUbState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "zUbOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "zUbRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "zUbSplit","102", oApp():cIniFile))
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

   select ZUB
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de ubicaciones')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   oApp():oGrid:cAlias := "ZUB"

   aBrowse   := { { {|| ZUB->UbUbicaci }, i18n( "Ubicación" ), 150, 0 },;
      { {|| TRAN( ZUB->UbEjempl, "@E 999,999  " ) }, i18n( "Documentos" ), 90, 1 } }

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
      oCol:bLDClickData  := {|| AztUbEdita(oApp():oGrid,2,oCont,oApp():oDlg) }
   next

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont,"ZUB", "Ubicaciones: ") }
   oApp():oGrid:bKeyDown := {|nKey| AztUbTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21
   oApp():oGrid:RestoreState( cState )

   ZUB->(dbSetOrder(nOrder))
   ZUB->(dbGoto(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION "Ubicaciones: "+tran(ZUB->(ordKeyNo()),'@E 999,999')+" / "+tran(ZUB->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
  		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_ZUBICACI"

   DEFINE VMENUITEM OF oCont        ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Nuevo"              ;
      IMAGE "16_NUEVO"             ;
      ACTION AztUbEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Modificar"          ;
      IMAGE "16_MODIF"             ;
      ACTION AztUbEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Duplicar"           ;
      IMAGE "16_DUPLICAR"           ;
      ACTION AztUbEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Borrar"             ;
      IMAGE "16_BORRAR"            ;
      ACTION AztUbBorra( oApp():oGrid, oCont );
      LEFT 10

   /*
   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Agrupar ubicaciones";
      IMAGE "SH_AGRUPA"            ;
      ACTION UbAgrupa( oApp():oGrid, oCont, oApp():oDlg );
      LEFT 10
   */

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Buscar"              ;
      IMAGE "16_BUSCAR"              ;
      ACTION AztUbBusca(oApp():oGrid,,oCont) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Imprimir"           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION AztUbImprime(oApp():oDlg, oApp():oGrid) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documentos"      ;
      IMAGE "16_DOCUMENT"           ;
      ACTION AztUbEjemplares( oApp():oGrid, oApp():oDlg ) ;
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
      ACTION Ut_BrwColConfig( oApp():oGrid, "zUbState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Salir"              ;
      IMAGE "16_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
      OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS ' Ubicaciones ';
      ACTION ( nOrder := oApp():oTab:nOption,;
      ZUB->(dbSetOrder(nOrder)),;
      ZUB->(dbGoTop()),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont,"ZUB", "Ubicaciones: ") )

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(), oApp():oGrid:SetFocus()) ;
      VALID ( oApp():oGrid:nLen := 0,;
      WritePProString("Browse","zUbState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","zUbOrder",LTrim(Str(ZUB->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","zUbRecno",LTrim(Str(ZUB->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","zUbSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oCont:End(), dbCloseAll(), oApp():oDlg := NIL, .T. )

return nil
//_____________________________________________________________________________//

function AztUbEdita( oGrid, nMode, oCont, oParent, cUbicaci )

   local oDlg, oFld, oBmp
   local aTitle := { i18n( "Añadir una ubicación" ),;
      i18n( "Modificar una ubicación"),;
      i18n( "Duplicar una ubicación") }
   local aGet[1]
   local cUbUbicaci

   // LOCAL nUbEjempl
   local nRecPtr := ZUB->(RecNo())
   local nOrden  := ZUB->(ordNumber())
   local nRecAdd
   local lDuplicado
   local lReturn := .F.

   if ZUB->(Eof()) .AND. nMode != 1
      return nil
   endif

   oApp():nEdit ++

   if nMode == 1
      ZUB->(dbAppend())
      nRecAdd  := ZUB->(RecNo())
   endif

   cUbUbicaci  := iif(nMode==1.AND.cUbicaci!=NIL,cUbicaci,ZUB->UbUbicaci)
   //nUbEjempl    := ZUB->UbEjempl

   if nMode == 3
      ZUB->(dbAppend())
      nRecAdd := ZUB->(RecNo())
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTUBEDIT"   ;
      TITLE aTitle[ nMode ]               ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   REDEFINE say ID 11 OF oDlg
   //REDEFINE SAY ID 13 OF oDlg
   //REDEFINE SAY VAR nUbEjempl     ;
   // PICTURE "@E 99,999" ID 14 OF oDlg

   REDEFINE get aGet[1] var cUbUbicaci    ;
      ID 12 OF oDlg UPDATE                ;
      valid AztUbClave( cUbUbicaci, aGet[1], nMode )

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
         ZUB->(dbGoto(nRecPtr))
      else
         ZUB->(dbGoto(nRecAdd))
      endif
      // ___ actualizo la ubicación en el fichero de documentos _______________//
      if nMode == 2
         if cUbUbicaci != ZUB->UbUbicaci
            msgRun( i18n( "Revisando el fichero de ubicaciones. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
               {|| AztUbCambiaClave( cUbUbicaci, ZUB->UbUbicaci ) } )
         endif
      endif

      // ___ guardo el registro _______________________________________________//

      select ZUB
      replace ZUB->UbUbicaci  with cUbUbicaci
      //Replace ZUB->UbEjempl   with nUbEjempl
      ZUB->(dbCommit())
      if cUbicaci != NIL
         cUbicaci := ZUB->UbUbicaci
      endif
   else
      lReturn := .F.
      if nMode == 1 .OR. nMode == 3

         ZUB->(dbGoto(nRecAdd))
         ZUB->(dbDelete())
         ZUB->(DbPack())
         ZUB->(dbGoto(nRecPtr))

      endif

   endif

   select ZUB

   if oCont != NIL
      RefreshCont(oCont,"ZUB", "Ubicaciones: ")
   endif
   if oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .T. )
   endif
   oApp():nEdit --

return lReturn
//_____________________________________________________________________________//

function AztUbBorra(oGrid,oCont)

   local nRecord  := ZUB->(RecNo())
   local cKeyNext
   local nAuxRecno
   local nAuxOrder

   oApp():nEdit ++

   if msgYesNo( i18n("¿ Está seguro de querer borrar esta ubicación ?") + CRLF + ;
         (Trim(ZUB->UbUbicaci)))

      msgRun( i18n( "Revisando el fichero de ubicaciones. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         {|| AztUbCambiaClave( Space(60), ZUB->UbUbicaci ) } )

      // borrado de la ubicación
      ZUB->(dbSkip())
      cKeyNext := ZUB->(ordKeyVal())
      ZUB->(dbGoto(nRecord))
      ZUB->(dbDelete())
      ZUB->(DbPack())

      if cKeyNext != NIL
         ZUB->(dbSeek(cKeyNext))
      else
         ZUB->(dbGoBottom())
      endif
   endif

   if oCont != NIL
      RefreshCont(oCont,"ZUB", "Ubicaciones: ")
   endif

   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil
//_____________________________________________________________________________//

function AztUbTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztUbEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztUbEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztUbBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztUbBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztUbBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil
//_____________________________________________________________________________//

function AztUbAgrupa( oGrid, oParent )

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

function AztUbSeleccion( cMateria, oControl, oParent )

   local oDlg, oBrowse, oCol
   local oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   local lOk    := .F.
   local nRecno := ZUB->( RecNo() )
   local nOrder := ZUB->( ordNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local cBrwState  := ""

   oApp():nEdit ++
   ZUB->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "UbAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de ubicaciones" )     ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ZUB"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZUB->UbUbicaci }
   oCol:cHeader  := i18n( "Ubicación" )
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztUbTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION AztUbEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION AztUbEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION AztUbBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION AztUbBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .T., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .F., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      on PAINT oDlg:Move(aPoint[1], aPoint[2],,,.T.)

   if lOK
      oControl:cText := ZUB->UbUbicaci
   endif

   SetIni( , "Browse", "UbAux", oBrowse:SaveState() )
   ZUB->( dbSetOrder( nOrder ) )
   ZUB->( dbGoto( nRecno ) )
   oApp():nEdit --

   select (nArea)

return nil
//_____________________________________________________________________________//


function AztUbBusca( oGrid, cChr, oCont, oParent )

   local nOrder   := ZUB->(ordNumber()) // el primer TAG es sin tipo
   local nRecno   := ZUB->(RecNo())
   local oDlg, oGet, cPicture
   local aSay1    := "Introduzca la ubicación a buscar"
   local aSay2    := "Ubicación:"
   local cGet     := Space(60)
   local lSeek    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR'   ;
      TITLE i18n("Búsqueda de ubicaciones") OF oParent
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
      end if
      MsgRun('Realizando la búsqueda...', oApp():cAppName+oApp():cVersion, ;
         {|| AztUbWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ninguna ubicación")
      else
         AztUbEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   ZUB->(ordSetFocus(nOrder))
   // ZUB->(DbGoTo(nRecno))

   RefreshCont(oCont,"ZUB", "Ubicaciones: ")
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztUbWildSeek(nOrder, cGet, aBrowse)

   local nRecno   := ZUB->(RecNo())

   do case
   case nOrder == 1
      ZUB->(dbGoTop())
      do while ! ZUB->(Eof())
         if cGet $ Upper(ZUB->UbUbicaci)
            AAdd(aBrowse, {ZUB->UbUbicaci })
         endif
         ZUB->(dbSkip())
      enddo
   end case
   ZUB->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztUbEncontrados(aBrowse, oParent)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ZUB->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Ubicación"
   oBrowse:aCols[1]:nWidth  := 220
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   ZUB->(ordSetFocus(1))
   ZUB->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ZUB->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztUbEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ZUB->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztUbEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| ZUB->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ZUB->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

//_____________________________________________________________________________//

function AztUbClave( cUbicaci, oGet, nMode )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lReturn  := .F.
   local nRecno   := ZUB->( RecNo() )
   local nOrder   := ZUB->( ordNumber() )
   local nArea    := Select()

   if Empty( cUbicaci )
      if nMode == 4
         return .T.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .F.
      endif
   endif

   select ZUB
   ZUB->( dbSetOrder( 1 ) )
   ZUB->( dbGoTop() )

   if ZUB->( dbSeek( Upper( cUbicaci ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("Ubicación existente.")
      case nMode == 2
         if ZUB->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("Ubicación existente.")
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
         if MsgYesNo("Ubicación inexistente. ¿ Desea darla de alta ahora? ")
            lReturn := AztUbEdita( , 1, , , @cUbicaci )
         else
            lReturn := .F.
         endif
      endif
   endif

   if lReturn == .F.
      oGet:cText( Space(60) )
   else
      oGet:cText := cUbicaci
   endif

   // ZUB->( DbSetOrder( nOrder ) )
   ZUB->( dbGoto( nRecno ) )
   select (nArea)

return lReturn
//_____________________________________________________________________________//

function AztUbCambiaClave( cNew, cOld )

   local nAuxOrder
   local nAuxRecNo

   // cambio la ubicación de documentos
   select ZAR
   nAuxRecno := ZAR->(RecNo())
   nAuxOrder := ZAR->(ordNumber())
   ZAR->(dbSetOrder(0))
   ZAR->(dbGoTop())
   replace ZAR->ArUbicaci      ;
      with cNew               ;
      for Upper(RTrim(ZAR->ArUbicaci)) == Upper(RTrim(cOld))
   ZAR->(dbSetOrder( nAuxOrder ))
   ZAR->(dbGoto( nAuxRecno ))

return nil
//_____________________________________________________________________________//

function AztUbEjemplares( oGrid, oParent )

   local cUbUbicaci  := ZUB->UbUbicaci
   local oDlg, oBrowse, oCol

   if ZUB->UbEjempl == 0
      MsgStop("La ubicación no aparece en ningún documento.")
      retu nil
   endif
   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'MA_EJEMPLARES'    ;
      TITLE 'Documentos de la ubicación: '+RTrim(cUbUbicaci) OF oParent
   oDlg:SetFont(oApp():oFont)

   select ZAR
   ZAR->(dbSetOrder(7))
   ordScope(0, {|| Upper(cUbUbicaci) })
   ordScope(1, {|| Upper(cUbUbicaci) })
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

   select ZUB
   oGrid:Refresh()
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil
//_____________________________________________________________________________//

function AztUbImprime(oParent, oGrid)

   local nRecno   := ZUB->(RecNo())
   local nOrder   := ZUB->(ordSetFocus())
   local aCampos  := { "UbUbicaci", "UbEjempl" }
   local aTitulos := { "Ubicación", "Documentos" }
   local aWidth   := { 40, 20 }
   local aShow    := { .T., .T. }
   local aPicture := { "NO", "NO" }
   local aTotal   := { .F., .T. }
   local oInforme

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ZUB" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()

   if oInforme:Activate()
      ZUB->(dbGoTop())
      oInforme:Report()
      ACTIVATE REPORT oInforme:oReport ;
         on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
         oInforme:oReport:Say(1, 'Total Ubicaciones: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
         oInforme:oReport:EndLine() )

      oInforme:End(.T.)
      ZUB->(dbGoto(nRecno))
   endif

   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil
//_____________________________________________________________________________//
function DbPack()
   pack
return nil

function AztUbList( aList, cData, oSelf )
   local aNewList := {}
   ZUB->( dbSetOrder(1) )
   ZUB->( dbGoTop() )
   while ! ZUB->(Eof())
      if at(Upper(cdata), Upper(ZUB->UbUbicaci)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aNewList, { ZUB->UbUbicaci } )
      endif 
      ZUB->(DbSkip())
   enddo
return aNewlist
