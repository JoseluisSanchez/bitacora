**
* PROYECTO ...: Hemerot
* COPYRIGHT ..: (c) alanit software
* URL ........: www.alanit.com
**

#include "FiveWin.ch"
#include "Report.ch"
#include "Splitter.ch"
#include "vMenu.ch"

//_____________________________________________________________________________//

FUNCTION Idiomas()
   LOCAL oBar
   LOCAL oCol
   LOCAL cState := GetPvProfString("Browse", "IdState","", oApp():cIniFile)
   LOCAL nOrder := VAL(GetPvProfString("Browse", "IdOrder","1", oApp():cIniFile))
   LOCAL nRecno := VAL(GetPvProfString("Browse", "IdRecno","1", oApp():cIniFile))
   LOCAL nSplit := VAL(GetPvProfString("Browse", "IdSplit","102", oApp():cIniFile))
   LOCAL oCont
   LOCAL i

   IF oApp():oDlg != NIL
      IF oApp():nEdit > 0
         RETURN NIL
      ELSE
         oApp():oDlg:End()
         SysRefresh()
      ENDIF
   ENDIF

   IF ! Db_OpenAll()
      return NIL
   ENDIF

   SELECT ID
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de idiomas')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   oApp():oGrid:cAlias := "ID"

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := { || ID->IdIdioma }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 479
   oCol:bLDClickData  := {|| IdEdita(oApp():oGrid,2,oCont,oApp():oDlg) }

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := { || RefreshCont(oCont,"ID") }
   oApp():oGrid:bKeyDown := {|nKey| IdTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21
   oApp():oGrid:RestoreState( cState )

   ID->(DbSetOrder(nOrder))
   ID->(DbGoTo(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 18 OF oApp():oDlg

   DEFINE TITLE OF oCont;
      CAPTION tran(ID->(OrdKeyNo()),'@E 999,999')+" / "+tran(ID->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_TABLA"

   @ 24, 05 VMENU oBar SIZE nSplit-10, 150 OF oApp():oDlg  ;
      COLOR CLR_BLACK, GetSysColor(15)       ;
      COLOROVER GetSysColor(14), GetSysColor(13) SOLID FILLED;
      HEIGHT ITEM 22

   DEFINE TITLE OF oBar       ;
      CAPTION "idiomas"       ;
      HEIGHT 24               ;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMGBTN "TB_UP", "TB_DOWN" ;
      OPENCLOSE RADIOBTN 15 ROUNDSQUARE

   DEFINE VMENUITEM OF obar         ;
      HEIGHT 10 // NOINSET

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Nuevo"              ;
      IMAGE "SH_NUEVO"             ;
      ACTION IdEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Modificar"          ;
      IMAGE "SH_MODIF"             ;
      ACTION IdEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Duplicar"           ;
      IMAGE "SH_DUPLICA"           ;
      ACTION IdEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Borrar"             ;
      IMAGE "SH_BORRAR"            ;
      ACTION IdBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Buscar"             ;
      IMAGE "SH_BUSCA"             ;
      ACTION IdBusca(oApp():oGrid,,oCont) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Imprimir"           ;
      IMAGE "SH_IMPRIMIR"          ;
      ACTION IdImprime(oApp():oDlg)         ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Configurar columnas" ;
      IMAGE "SH_GRID"              ;
      ACTION Ut_BrwColConfig( oApp():oGrid, "IdState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Salir"              ;
      IMAGE "SH_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
     OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
     ITEMS ' Idioma ';
     ACTION ( nOrder := oApp():oTab:nOption  ,;
              ID->(DbSetOrder(nOrder)),;
              ID->(DbGoTop())         ,;
              oApp():oGrid:Refresh(.t.)      ,;
              RefreshCont(oCont, "ID") )

   @ 00, nSplit SPLITTER oApp():oSplit ;
      VERTICAL ;
      PREVIOUS CONTROLS oCont, oBar ;
      HINDS CONTROLS oApp():oGrid, oApp():oTab ;
      SIZE 1, oApp():oDlg:nGridBottom + oApp():oTab:nHeight PIXEL ;
      OF oApp():oDlg ;
      _3DLOOK ;
      UPDATE

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      ON INIT oApp():oGrid:SetFocus() ;
      VALID ( oApp():oGrid:nLen := 0 ,;
              WritePProString("Browse","IdState",oApp():oGrid:SaveState(),oApp():cIniFile) ,;
              WritePProString("Browse","IdOrder",Ltrim(Str(ID->(OrdNumber()))),oApp():cIniFile) ,;
              WritePProString("Browse","IdRecno",Ltrim(Str(ID->(Recno()))),oApp():cIniFile) ,;
              WritePProString("Browse","IdSplit",Ltrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile) ,;
              oBar:End(), DbCloseAll(), oApp():oDlg := NIL, .t. )

RETURN NIL
//_____________________________________________________________________________//

FUNCTION IdEdita( oGrid, nMode, oCont, oParent, cIdioma )
   LOCAL oDlg, oFld, oBmp
   LOCAL aTitle := { i18n( "Añadir idioma" )   ,;
                     i18n( "Modificar idioma") ,;
                     i18n( "Duplicar idioma") }
   LOCAL aGet[1]
   LOCAL cIdIdioma
   LOCAL nRecPtr  := ID->(RecNo())
   LOCAL nOrden   := ID->(OrdNumber())
   LOCAL nRecAdd
   LOCAL lDuplicado
   LOCAL lReturn  := .f.

   IF ID->(EOF()) .AND. nMode != 1
      RETURN NIL
   ENDIF

   oApp():nEdit ++

   if nMode == 1
      ID->(DbAppend())
      nRecAdd  := ID->(RecNo())
   endif

   cIdIdioma   := IIF(nMode==1.AND.cIdioma!=NIL,cIdioma,ID->IdIdioma)

   if nMode == 3
      ID->(DbAppend())
      nRecAdd := ID->(RecNo())
   endif

   IF oParent == NIL
      oParent := oApp():oDlg
   ENDIF

   DEFINE DIALOG oDlg RESOURCE "IDEDIT"   ;
      TITLE aTitle[ nMode ]               ;
      OF oParent
   oDlg:oFont  := oApp():oFont

   REDEFINE SAY ID 11 OF oDlg
   REDEFINE GET aGet[1] VAR cIdIdioma     ;
      ID 12 OF oDlg UPDATE               ;
      VALID IdClave( cIdIdioma, aGet[1], nMode )

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
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

   IF oDlg:nresult == IDOK
      lReturn := .t.
      if nMode == 2
         ID->(DbGoTo(nRecPtr))
      else
         ID->(DbGoTo(nRecAdd))
      endif
      // ___ actualizo la tipo de documento en el fichero de documentos _______//

      IF nMode == 2
         IF ID->IdIdioma != cIdIdioma
            msgRun( i18n( "Revisando el fichero de idiomas. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
                  { || IdCambiaClave( cIdIdioma, ID->IdIdioma ) } )
         ENDIF
      ENDIF

      // ___ guardo el registro _______________________________________________//

      Select ID
      REPLACE ID->IdIdioma WITH cIdIdioma
      ID->( dbCommit() )
      IF cIdioma != NIL
         cIdioma := ID->IdIdioma
      ENDIF
   ELSE
      lReturn := .f.
      IF nMode == 1 .OR. nMode == 3
         ID->(DbGoTo(nRecAdd))
         ID->(DbDelete())
         ID->(DbPack())
         ID->(DbGoTo(nRecPtr))
      ENDIF
   ENDIF

   SELECT ID

   IF oCont != NIL
      RefreshCont(oCont,"ID")
   ENDIF
   IF oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .t. )
   ENDIF

   oApp():nEdit --

RETURN lReturn
//_____________________________________________________________________________//

Function IdBorra(oGrid,oCont)
   LOCAL nRecord  := ID->(Recno())
   LOCAL cKeyNext
   LOCAL nAuxRecno
   LOCAL nAuxOrder

   oApp():nEdit ++

   IF msgYesNo( i18n("¿ Está seguro de querer borrar este idioma ?") + CRLF + ;
                (trim(ID->IdIdioma)))

      msgRun( i18n( "Revisando el fichero de idiomas. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         { || IdCambiaClave( SPACE(15), ID->IdIdioma ) } )

      // borrado de la tipo de documento
      ID->(DbSkip())
      cKeyNext := ID->(OrdKeyVal())
      ID->(DbGoto(nRecord))
      ID->(DbDelete())
      ID->(DbPack())

      IF cKeyNext != NIL
         ID->(DbSeek(cKeyNext))
      ELSE
         ID->(DbGoBottom())
      ENDIF
   ENDIF

   IF oCont != NIL
      RefreshCont(oCont,"ID")
   ENDIF

   oGrid:Refresh(.t.)
   oGrid:SetFocus(.t.)
   oApp():nEdit --
return nil
//_____________________________________________________________________________//

Function IdTecla(nKey,oGrid,oCont,oDlg)
Do case
   case nKey==VK_RETURN
      IdEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      IdEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      IdBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   OTHERWISE
      IF nKey >= 96 .AND. nKey <= 105
         IdBusca(oGrid,STR(nKey-96,1),oCont,oDlg)
      ELSEIF HB_ISSTRING(CHR(nKey))
         IdBusca(oGrid,CHR(nKey),oCont,oDlg)
      ENDIF
EndCase

return nil

//_____________________________________________________________________________//

FUNCTION IdSeleccion( cIdioma, oControl, oParent )
   LOCAL oDlg, oBrowse, oCol
   LOCAL oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   LOCAL lOk    := .f.
   LOCAL nRecno := ID->( RecNo() )
   LOCAL nOrder := ID->( OrdNumber() )
   LOCAL nArea  := Select()
   LOCAL aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   LOCAL cBrwState  := ""

   oApp():nEdit ++
   ID->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "IdAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de idiomas" )      ;
      OF oParent
   oDlg:oFont  := oApp():oFont

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ID"

   oCol := oBrowse:AddCol()
   oCol:bStrData := { || ID->IdIdioma }
   oCol:cHeader  := i18n( "Idioma" )
   oCol:nWidth   := 250

   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { || lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .f.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := { |nKey| IdTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION IdEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION IdEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION IdBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION IdBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .t., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .f., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      ON PAINT oDlg:Move(aPoint[1], aPoint[2],,,.t.)

   if lOK
      oControl:cText := ID->IdIdioma
   endif

   SetIni( , "Browse", "IdAux", oBrowse:SaveState() )
   ID->( DbSetOrder( nOrder ) )
   ID->( DbGoTo( nRecno ) )
   oApp():nEdit --

   Select (nArea)
RETURN nil
//_____________________________________________________________________________//

FUNCTION IdBusca( oGrid, cChr, oCont, oParent )

   LOCAL nOrder   := ID->(OrdNumber()) // el primer TAG es sin tipo
   LOCAL nRecno   := ID->(Recno())
   LOCAL oDlg, oGet, cPicture
   LOCAL aSay1    := "Introduzca el idioma a buscar"
   LOCAL aSay2    := "Idioma:"
   LOCAL cGet     := space(15)
   LOCAL lSeek    := .f.
   LOCAL lFecha   := .f.
   LOCAL aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR'   ;
      TITLE i18n("Búsqueda de idiomas") OF oParent
   oDlg:oFont  := oApp():oFont

   REDEFINE SAY PROMPT aSay1 ID 20 OF oDlg
   REDEFINE SAY PROMPT aSay2 ID 21 OF Odlg

   //__ si he pasado un caracter lo meto en la cadena a buscar ________________//

   IF cChr != NIL
      IF .NOT. lFecha
         cGet := cChr+SubStr(cGet,1,len(cGet)-1)
      ELSE
         cGet := CtoD(cChr+' -  -    ')
      ENDIF
   ENDIF

   IF ! lFecha
      REDEFINE GET oGet VAR cGet PICTURE "@!" ID 101 OF oDlg
   ELSE
      REDEFINE GET oGet VAR cGet ID 101 OF oDlg
   ENDIF

   IF cChr != NIL
      oGet:bGotFocus := { || ( oGet:SetColor( CLR_BLACK, RGB(255,255,127) ), oGet:SetPos(2) ) }
   ENDIF

   REDEFINE BUTTON ID IDOK OF oDlg ;
      PROMPT i18n( "&Aceptar" )   ;
      ACTION (lSeek := .t., oDlg:End())
   REDEFINE BUTTON ID IDCANCEL OF oDlg CANCEL ;
      PROMPT i18n( "&Cancelar" )  ;
      ACTION oDlg:End()

   sysrefresh()

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain) // , IIF(cChr!=NIL,oGet:SetPos(2),), oGet:Refresh() )

   if lSeek
      if ! lFecha
         cGet := rTrim( upper( cGet ) )
      else
         cGet := dTOs( cGet )
      end if
      MsgRun('Realizando la búsqueda...', oApp():cAppName+oApp():cVersion, ;
         { || IdWildSeek(nOrder, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop("No se ha encontrado ningún idioma")
      else
         IdEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   ID->(OrdSetFocus(nOrder))
   // ID->(DbGoTo(nRecno))

   RefreshCont( oCont, "ID" )
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return NIL
/*_____________________________________________________________________________*/
function IdWildSeek(nOrder, cGet, aBrowse)
   local nRecno   := ID->(Recno())

   do case
      case nOrder == 1
         ID->(DbGoTop())
         do while ! ID->(eof())
            if cGet $ upper(ID->IdIdioma)
               aadd(aBrowse, { ID->IdIdioma })
            endif
            ID->(DbSkip())
         enddo
   end case
   ID->(DbGoTo(nRecno))
   ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[1]) < upper(aAut2[1]) } )
return nil
/*_____________________________________________________________________________*/
function IdEncontrados(aBrowse, oParent)
   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ID->(Recno())

   DEFINE DIALOG oDlg RESOURCE "DLG_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:oFont  := oApp():oFont

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .f.)
   oBrowse:aCols[1]:cHeader := "Idioma"
   oBrowse:aCols[1]:nWidth  := 220
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 110 )
   ID->(OrdSetFocus(1))
   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||ID->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1]))),;
                                                           IdEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(ID->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1]))),;
                                                     IdEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := { || ID->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ID->(DbGoTo(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

return nil

//_____________________________________________________________________________//

FUNCTION IdCambiaClave( cVar, cOld )

   LOCAL nOrder
   LOCAL nRecNo

   // cambio el idoma de documentos
   Select AR
   nRecno := AR->(RecNo())
   nOrder := AR->(OrdNumber())
   AR->(DbSetOrder(0))
   AR->(DbGoTop())
   Replace AR->ArIdioma    ;
      with cVar            ;
      for Upper(Rtrim(AR->ArIdioma)) == Upper(rtrim(cOld))
   AR->(DbSetOrder(nOrder))
   AR->(DbGoTo(nRecno))

   // cambio el idoma en publicaciones
   Select PU
   nRecno := PU->(RecNo())
   nOrder := PU->(OrdNumber())
   PU->(DbSetOrder(0))
   PU->(DbGoTop())
   Replace PU->PuIdioma    ;
      with cVar            ;
      for Upper(Rtrim(PU->PuIdioma)) == Upper(rtrim(cOld))
   PU->(DbSetOrder(nOrder))
   PU->(DbGoTo(nRecno))

RETURN nil

//_____________________________________________________________________________//

FUNCTION IdClave( cIdioma, oGet, nMode )
   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   LOCAL lReturn  := .f.
   LOCAL nRecno   := ID->( RecNo() )
   LOCAL nOrder   := ID->( OrdNumber() )
   LOCAL nArea    := Select()

   IF Empty( cIdioma )
      IF nMode == 4
         RETURN .t.
      ELSE
         MsgStop("Es obligatorio rellenar este campo.")
         RETURN .f.
      ENDIF
   ENDIF

   SELECT ID
   ID->( DbSetOrder( 1 ) )
   ID->( DbGoTop() )

   IF ID->( DbSeek( UPPER( cIdioma ) ) )
      DO CASE
         Case nMode == 1 .OR. nMode == 3
            lReturn := .f.
            MsgStop("Idioma existente.")
         Case nMode == 2
            IF ID->( Recno() ) == nRecno
               lReturn := .t.
            ELSE
               lReturn := .f.
               MsgStop("Idioma existente.")
            ENDIF
         Case nMode == 4
            IF ! oApp():thefull
               Registrame()
            ENDIF
            lReturn := .t.
      END CASE
   ELSE
      IF nMode < 4
         lReturn := .t.
      ELSE
         IF MsgYesNo("Idioma inexistente. ¿ Desea darlo de alta ahora? ")
            lReturn := IdEdita( , 1, , , @cIdioma )
         ELSE
            lReturn := .f.
         ENDIF
      ENDIF
   ENDIF

   IF lReturn == .f.
      oGet:cText( space(15) )
   ELSE
      oGet:cText( cIdioma )
   ENDIF

   ID->( DbGoTo( nRecno ) )
   Select (nArea)
RETURN lReturn

//_____________________________________________________________________________//

FUNCTION IdImprime( oGrid )
   LOCAL nRecno   := ID->(Recno())
   LOCAl nOrder   := ID->(OrdSetFocus())
   LOCAL aCampos  := { "IdIdioma" }
   LOCAL aTitulos := { "Idioma" }
   LOCAL aWidth   := { 40 }
   LOCAL aShow    := { .t. }
   LOCAL aPicture := { "NO" }
   LOCAL aTotal   := { .f. }
   LOCAL oInforme

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ID" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio VAR oInforme:nRadio ID 300 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()

   IF oInforme:Activate()
      ID->(DbGoTop())
      oInforme:Report()
      ACTIVATE REPORT oInforme:oReport ;
         ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
                  oInforme:oReport:Say(1, 'Total idiomas: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
                  oInforme:oReport:EndLine() )

      oInforme:End(.t.)
      ID->(DbGoTo(nRecno))
   ENDIF

   oGrid:Refresh()
   oGrid:SetFocus( .t. )
   oApp():nEdit --
RETURN nil

//_____________________________________________________________________________//

FUNCTION IdIsDbfEmpty()

   LOCAL lReturn := .f.

   IF ID->( ordKeyVal() ) == nil
      msgStop( i18n( "No hay ningún idioma registrado." ) )
      lReturn := .t.
   ENDIF

RETURN lReturn

