// PROYECTO ...: Hemerot
//*
// COPYRIGHT ..: (c) alanit software
// URL ........: www.alanit.com
//*

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"

extern deleted

//_____________________________________________________________________________//

function Periodicidad()

   local oBar
   local oCol
   local cState := GetPvProfString("Browse", "PeState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "PeOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "PeRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "PeSplit","102", oApp():cIniFile))
   local oCont
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

   select PE
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de periodicidades')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   oApp():oGrid:cAlias := "ZPE"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| PE->PePeriodi }
   oCol:cHeader  := i18n( "Periodicidad" )
   oCol:nWidth   := 479
   oCol:bLDClickData  := {|| AztPeEdita(oApp():oGrid,2,oCont,oApp():oDlg) }

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont,"ZPE") }
   oApp():oGrid:bKeyDown := {|nKey| AztPeTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21
   oApp():oGrid:RestoreState( cState )

   PE->(dbSetOrder(nOrder))
   PE->(dbGoto(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 18 OF oApp():oDlg

   DEFINE TITLE OF oCont;
      CAPTION tran(PE->(ordKeyNo()),'@E 999,999')+" / "+tran(PE->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
      color GetSysColor(9), GetSysColor(3), GetSysColor(2);
      VERTICALGRADIENT;
      IMAGE "BB_TABLA"

   @ 24, 05 VMENU oBar SIZE nSplit-10, 150 OF oApp():oDlg  ;
      color CLR_BLACK, GetSysColor(15)       ;
      COLOROVER GetSysColor(14), GetSysColor(13) SOLID FILLED;
      HEIGHT ITEM 22

   DEFINE TITLE OF oBar       ;
      CAPTION "periodicidades";
      HEIGHT 24               ;
      color GetSysColor(9), GetSysColor(3), GetSysColor(2);
      VERTICALGRADIENT

   DEFINE VMENUITEM OF obar         ;
      HEIGHT 10 // NOINSET

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Nuevo"              ;
      IMAGE "SH_NUEVO"             ;
      ACTION AztPeEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Modificar"          ;
      IMAGE "SH_MODIF"             ;
      ACTION AztPeEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Duplicar"           ;
      IMAGE "SH_DUPLICA"           ;
      ACTION AztPeEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Borrar"             ;
      IMAGE "SH_BORRAR"            ;
      ACTION AztPeBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Buscar"             ;
      IMAGE "SH_BUSCA"             ;
      ACTION AztPeBusca(oApp():oGrid,,oCont) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Imprimir"           ;
      IMAGE "SH_IMPRIMIR"          ;
      ACTION AztPeImprime(oApp():oDlg)         ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar a Excel"     ;
      IMAGE "16_EXCEL"             ;
      ACTION (CursorWait(), oApp():oGrid:ToExcel(), CursorArrow());
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Configurar columnas" ;
      IMAGE "SH_GRID"              ;
      ACTION Ut_BrwColConfig( oApp():oGrid, "PeState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Salir"              ;
      IMAGE "SH_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
      OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS ' Periodicidad ';
      ACTION ( nOrder := oApp():oTab:nOption,;
      PE->(dbSetOrder(nOrder)),;
      PE->(dbGoTop()),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont, "ZME") )

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on init oApp():oGrid:SetFocus() ;
      VALID ( oApp():oGrid:nLen := 0,;
      WritePProString("Browse","PeState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","PeOrder",LTrim(Str(PE->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","PeRecno",LTrim(Str(PE->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","PeSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oBar:End(), dbCloseAll(), oApp():oDlg := NIL, .T. )

return nil
//_____________________________________________________________________________//

function AztPeEdita( oGrid, nMode, oCont, oParent, cPeriodi )

   local oDlg, oFld, oBmp
   local aTitle := { i18n( "Añadir periodicidad" ),;
      i18n( "Modificar periodicidad"),;
      i18n( "Duplicar periodicidad") }
   local aGet[1]
   local cPePeriodi
   local nRecPtr := PE->(RecNo())
   local nOrden  := PE->(ordNumber())
   local nRecAdd
   local lDuplicado
   local lReturn := .F.

   if PE->(Eof()) .AND. nMode != 1
      return nil
   endif

   oApp():nEdit ++

   if nMode == 1
      PE->(dbAppend())
      nRecAdd  := PE->(RecNo())
   endif

   cPePeriodi  := iif(nMode==1.AND.cPeriodi!=NIL,cPeriodi,PE->PePeriodi)

   if nMode == 3
      PE->(dbAppend())
      nRecAdd := PE->(RecNo())
   endif

   if oParent == NIL
      oParent := oApp():oDlg
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTPEEDIT"   ;
      TITLE aTitle[ nMode ]               ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   REDEFINE say ID 11 OF oDlg
   REDEFINE get aGet[1] var cPePeriodi    ;
      ID 12 OF oDlg UPDATE               ;
      valid AztPeClave( cPePeriodi, aGet[1], nMode )

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
         PE->(dbGoto(nRecPtr))
      else
         PE->(dbGoto(nRecAdd))
      endif
      // ___ actualizo la tipo de documento en el fichero de documentos _______//

      if nMode == 2
         if PE->PePeriodi != cPePeriodi
            msgRun( i18n( "Revisando el fichero de periodicidades. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
               {|| AztPeCambiaClave( cPePeriodi, PE->PePeriodi ) } )
         endif
      endif

      // ___ guardo el registro _______________________________________________//

      select PE
      replace PE->PePeriodi with cPePeriodi
      ID->( dbCommit() )
   else
      lReturn := .F.
      if nMode == 1 .OR. nMode == 3
         PE->(dbGoto(nRecAdd))
         PE->(dbDelete())
         PE->(DbPack())
         PE->(dbGoto(nRecPtr))
      endif
   endif

   select PE

   if oCont != NIL
      RefreshCont(oCont,"ZPE")
   endif
   if oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .T. )
   endif

   oApp():nEdit --

return lReturn
//_____________________________________________________________________________//

function AztPeBorra(oGrid,oCont)

   local nRecord  := PE->(RecNo())
   local cKeyNext
   local nAuxRecno
   local nAuxOrder

   oApp():nEdit ++

   if msgYesNo( i18n("¿ Está seguro de querer borrar esta periodicidad ?") + CRLF + ;
         (Trim(PE->PePeriodi)) )
      msgRun( i18n( "Revisando el fichero de periodicidades. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         {|| AztPeCambiaClave( Space(15), PE->PePeriodi ) } )
      // borrado de la tipo de documento
      PE->(dbSkip())
      cKeyNext := PE->(ordKeyVal())
      PE->(dbGoto(nRecord))
      PE->(dbDelete())
      PE->(DbPack())

      if cKeyNext != NIL
         PE->(dbSeek(cKeyNext))
      else
         PE->(dbGoBottom())
      endif
   endif

   if oCont != NIL
      RefreshCont(oCont,"ZPE")
   endif

   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil
//_____________________________________________________________________________//

function AztPeTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztPeEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztPeEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztPeBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztPeBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztPeBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil

//_____________________________________________________________________________//

function AztPeSeleccion( cPeriodi, oControl, oParent )

   local oDlg, oBrowse, oCol
   local oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   local lOk    := .F.
   local nRecno := PE->( RecNo() )
   local nOrder := PE->( ordNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local cBrwState  := ""

   oApp():nEdit ++
   PE->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "PeAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de periodicidades" )     ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ZPE"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| PE->PePeriodi }
   oCol:cHeader  := i18n( "Periodicidad" )
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztPeTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION AztPeEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION AztPeEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION AztPeBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION AztPeBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .T., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .F., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      on PAINT oDlg:Move(aPoint[1], aPoint[2],,,.T.)

   if lOK
      oControl:cText := PE->PePeriodi
   endif

   SetIni( , "Browse", "PeAux", oBrowse:SaveState() )
   PE->( dbSetOrder( nOrder ) )
   PE->( dbGoto( nRecno ) )
   oApp():nEdit --

   select (nArea)

return nil
//_____________________________________________________________________________//

function AztPeBusca( oGrid, cChr, oCont, oParent )

   local nOrder   := PE->(ordNumber()) // el primer TAG es sin tipo
   local nRecno   := PE->(RecNo())
   local oDlg, oGet, cPicture
   local aSay1    := "Introduzca la periodicidad"
   local aSay2    := "Periodicidad:"
   local cGet     := Space(15)
   local lSeek    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR'   ;
      TITLE i18n("Búsqueda de periodicidades") OF oParent
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
         {|| AztPeWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ninguna periodicidad")
      else
         AztPeEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   PE->(ordSetFocus(nOrder))
   //PE->(DbGoTo(nRecno))
   RefreshCont( oCont, "ZPE" )
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztPeWildSeek(nOrder, cGet, aBrowse)

   local nRecno   := PE->(RecNo())

   do case
   case nOrder == 1
      PE->(dbGoTop())
      do while ! PE->(Eof())
         if cGet $ Upper(PE->PePeriodi)
            AAdd(aBrowse, { PE->PePeriodi })
         endif
         PE->(dbSkip())
      enddo
   end case
   PE->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztPeEncontrados(aBrowse, oParent)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := PE->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "DLG_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Periodicidad"
   oBrowse:aCols[1]:nWidth  := 220
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   PE->(ordSetFocus(1))
   PE->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||PE->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztPeEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(PE->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztPeEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| PE->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (PE->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

//_____________________________________________________________________________//

function AztPeCambiaClave( cVar, cOld )

   local nOrder
   local nRecNo

   // cambio la materia de publicaciones
   select ZPU
   nRecno := ZPU->(RecNo())
   nOrder := ZPU->(ordNumber())
   ZPU->(dbSetOrder(0))
   ZPU->(dbGoTop())
   replace ZPU->PuPeriodi;
      with cVar         ;
      for Upper(RTrim(ZPU->PuPeriodi)) == Upper(RTrim(cOld))
   ZPU->(dbSetOrder(nOrder))
   ZPU->(dbGoto(nRecno))

return nil

//_____________________________________________________________________________//

function AztPeClave( cPeriodi, oGet, nMode )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lReturn  := .F.
   local nRecno   := PE->( RecNo() )
   local nOrder   := PE->( ordNumber() )
   local nArea    := Select()

   if Empty( cPeriodi )
      if nMode == 4
         return .T.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .F.
      endif
   endif

   select PE
   PE->( dbSetOrder( 1 ) )
   PE->( dbGoTop() )

   if ID->( dbSeek( Upper( cPeriodi ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("Periodicidad existente.")
      case nMode == 2
         if ID->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("Periodicidad existente.")
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
         if MsgYesNo("Periodicidad inexistente en el fichero de periodicidades."+CRLF+"¿ Desea darla de alta ? ")
            lReturn := AztPeEdita( , 1, , , cPeriodi )
         else
            lReturn := .F.
         endif
      endif
   endif

   if lReturn == .F.
      oGet:cText( Space(15) )
   endif
   PE->( dbGoto( nRecno ) )
   select (nArea)

return lReturn
//_____________________________________________________________________________//

function AztPeImprime( oGrid )

   local nRecno   := PE->(RecNo())
   local nOrder   := PE->(ordSetFocus())
   local aCampos  := { "PePeriodi" }
   local aTitulos := { "Periodicidad" }
   local aWidth   := { 40 }
   local aShow    := { .T. }
   local aPicture := { "NO" }
   local aTotal   := { .F. }
   local oInforme

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "PE" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()

   if oInforme:Activate()
      PE->(dbGoTop())
      oInforme:Report()
      ACTIVATE REPORT oInforme:oReport ;
         on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
         oInforme:oReport:Say(1, 'Total periodicidades: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
         oInforme:oReport:EndLine() )

      oInforme:End(.T.)
      PE->(dbGoto(nRecno))
   endif

   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil

//_____________________________________________________________________________//

function AztPeIsDbfEmpty()

   local lReturn := .F.

   if PE->( ordKeyVal() ) == nil
      msgStop( i18n( "No hay ninguna periodicidad registrada." ) )
      lReturn := .T.
   endif

return lReturn
