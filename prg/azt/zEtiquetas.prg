#include "FiveWin.ch"
#include "Report.ch"
#include "xBrowse.ch"
#include "vmenu.ch"

static oReport

function AztEtiquetas()

   local oCol
   local aBrowse
   local cState := GetPvProfString("Browse", "zEtState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "zEtOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "zEtRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "zEtSplit","102", oApp():cIniFile))
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

   select ZET
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de Etiquetas')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   oApp():oGrid:cAlias := "ZET"

   aBrowse   := { { {|| ZET->EtTag }, i18n("Etiqueta"), 150, 0 },;
      { {|| TRAN( ZET->EtEjempl, "@E 99,999  " ) }, i18n( "Documentos" ), 90, 1 } }


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
      oCol:bLDClickData  := {|| AztEtEdita(oApp():oGrid,2,oCont,oApp():oDlg) }
   next

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont, "ZET", "Etiquetas: ") }
   oApp():oGrid:bKeyDown := {|nKey| AztEtTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21

   oApp():oGrid:RestoreState( cState )

   ZET->(dbSetOrder(nOrder))
   ZET->(dbGoto(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION "Etiquetas: "+tran(ZET->(ordKeyNo()),'@E 999,999')+" / "+tran(ZET->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_TAG"

   DEFINE VMENUITEM OF oCont        ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Nueva"              ;
      IMAGE "16_NUEVO"             ;
      ACTION AztEtEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Modificar"          ;
      IMAGE "16_MODIF"             ;
      ACTION AztEtEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Duplicar"           ;
      IMAGE "16_DUPLICAR"           ;
      ACTION AztEtEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Borrar"             ;
      IMAGE "16_BORRAR"            ;
      ACTION AztEtBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documentos"     ;
      IMAGE "16_DOCUMENT"          ;
      ACTION AztEtEjemplares( oApp():oGrid, oApp():oDlg ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Buscar"             ;
      IMAGE "16_BUSCAR"             ;
      ACTION AztEtBusca(oApp():oGrid,,oCont,oApp():oDlg)  ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Imprimir"           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION AztEtImprime(oApp():oGrid,oApp():oDlg)   ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

	DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documentos"     ;
      IMAGE "16_DOCUMENT"        ;
      ACTION AztEtEjemplares( oApp():oGrid, oApp():oDlg ) ;
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
      ACTION Ut_BrwColConfig( oApp():oGrid, "zAuState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Salir"              ;
      IMAGE "16_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
      OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS ' Etiquetas ';
      ACTION ( nOrder := oApp():oTab:nOption,;
      ZET->(dbSetOrder(nOrder)),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont, "ZET", "Etiquetas: ") )

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(), oApp():oGrid:SetFocus()) ;
      VALID ( oApp():oGrid:nLen := 0,;
      WritePProString("Browse","zEtState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","zEtOrder",LTrim(Str(ZET->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","zEtRecno",LTrim(Str(ZET->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","zEtSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oCont:End(), dbCloseAll(), oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, .T. )

return nil
/*_____________________________________________________________________________*/


function AztEtEdita( oGrid, nMode, oCont, oParent, cEtiqueta )

   local oDlg
   local aTitle := { i18n( "Añadir etiqueta" ),;
      i18n( "Modificar etiqueta"),;
      i18n( "Duplicar etiqueta") }
   local aGet[1]
   local cEtTag
   local nRecPtr := ZET->(RecNo())
   local nOrden  := ZET->(ordNumber())
   local nRecAdd
   local lDuplicado
   local lReturn := .F.

   if ZET->(Eof()) .AND. nMode != 1
      return nil
   endif

   oApp():nEdit ++

   if nMode == 1
      ZET->(dbAppend())
      nRecAdd := ZET->(RecNo())
   endif

   cEtTag  := iif(nMode==1.AND.cEtiqueta!=NIL,cEtiqueta,ZET->EtTag)

   if nMode == 3
      ZET->(dbAppend())
      nRecAdd := ZMA->(RecNo())
   endif

   if oParent == NIL
      oParent := oApp():oDlg
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTETEDIT"   ;
      TITLE aTitle[ nMode ]               ;
      OF oParent

   REDEFINE say ID 11 OF oDlg

   REDEFINE get aGet[1] var cEtTag      ;
      ID 12 OF oDlg UPDATE              ;
      valid AztEtClave( cEtTag, aGet[1], nMode )

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
      // ___ actualizo el tipo de materia en el documento_______________________//
      if nMode == 2
         if cEtTag != ZET->EtTag
            msgRun( i18n( "Revisando el fichero de documentos. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
               {|| AztEtCambiaClave( cEtTag, ZET->EtTag, .f. ) } )
         endif
      endif

      // ___ guardo el registro _______________________________________________//
      select ZET
      replace ZET->EtTag  with cEtTag
      // Replace ZMA->MaEjempl   with nMaEjempl
      ZET->(dbCommit())
      if cEtiqueta != NIL
         cEtiqueta := ZET->EtTag
      endif
   else
      lReturn := .F.
      if nMode == 1 .OR. nMode == 3
         ZET->(dbGoto(nRecAdd))
         ZET->(dbDelete())
         ZET->(DbPack())
         ZET->(dbGoto(nRecPtr))
      endif
   endif

   select ZET

   if oCont != NIL
      RefreshCont(oCont, "ZET", "Etiquetas: ")
   endif
   if oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .T. )
   endif

   oApp():nEdit --

return lReturn
/*_____________________________________________________________________________*/

function AztEtBorra(oGrid,oCont)

   local nRecord := ZET->(RecNo())
   local nNext

   oApp():nEdit ++

   if msgYesNo( i18n("¿ Está seguro de querer borrar esta etiqueta ?") + CRLF + ;
         (Trim(ZET->EtTag)))
      msgRun( i18n( "Revisando el fichero de etiquetas. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         {|| AztEtCambiaClave( Space(40), ZET->EtTag, .t. ) } )

      select ZET
      ZET->(dbSkip())
      nNext := ZET->(RecNo())
      ZET->(dbGoto(nRecord))

      ZET->(dbDelete())
      ZET->(DbPack())
      ZET->(dbGoto(nNext))
      if ZET->(Eof()) .OR. nNext == nRecord
         ZET->(dbGoBottom())
      endif
   endif

   if oCont != NIL
      RefreshCont(oCont, "ZET", "Etiquetas: ")
   endif

   oApp():nEdit --
   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)

return nil
/*_____________________________________________________________________________*/

function AztEtTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztEtEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztEtEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztEtBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztEtBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztEtBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil
/*_____________________________________________________________________________*/

function AztEtSeleccion( aItems, oControl, oParent )

   local oDlg, oBrowse, oCol
   local oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   local lOk    := .F.
   local nRecno := ZET->( RecNo() )
   local nOrder := ZET->( ordNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local cBrwState  := ""

   oApp():nEdit ++
   ZET->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "AuAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de etiquetas" )      ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ZET"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZET->EtTag }
   oCol:cHeader  := i18n( "Etiqueta" )
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztEtTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION AztEtEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION AztEtEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION AztEtBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION AztEtBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .T., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .F., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      on PAINT oDlg:Move(aPoint[1], aPoint[2],,,.T.)

   if lOK
      if AScan(aItems, RTrim(ZET->EtTag)) == 0
         oControl:Additem(RTrim(ZET->EtTag))
         AAdd(aItems,RTrim(ZET->EtTag))
         oControl:Refresh()
      else
         msgAlert('La etiqueta ya aparece en el documento.')
      endif
   endif

   ZET->( dbSetOrder( nOrder ) )
   ZET->( dbGoto( nRecno ) )
   oApp():nEdit --

   select (nArea)

return nil
/*_____________________________________________________________________________*/


function AztEtBusca( oGrid, cChr, oCont, oParent )

   local nOrder   := ZET->(ordNumber())
   local nRecno   := ZET->(RecNo())
   local oDlg, oGet, cGet, cPicture
   local lSeek    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR' OF oParent  ;
      TITLE i18n("Búsqueda de etiquetas")
   oDlg:SetFont(oApp():oFont)

   if nOrder == 1
      REDEFINE say prompt i18n( "Introduzca la etiqueta" ) ID 20 OF oDlg
      REDEFINE say prompt i18n( "Etiqueta" )+":" ID 21 OF Odlg
      cGet     := Space(40)
   endif

   /*__ si he pasado un caracter lo meto en la cadena a buscar ________________*/

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
      ACTION (lSeek := .F., oDlg:End())

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
         {|| AztEtWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ninguna etiqueta")
      else
         AztEtEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   ZET->(ordSetFocus(nOrder))
   RefreshCont(oCont, "ZET", "Etiquetas: ")
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztEtWildSeek(nOrder, cGet, aBrowse)

   local nRecno   := ZET->(RecNo())

   do case
   case nOrder == 1
      ZET->(dbGoTop())
      do while ! ZET->(Eof())
         if cGet $ Upper(ZET->EtTag)
            AAdd(aBrowse, {ZET->EtTag, ZET->EtEjempl})
         endif
         ZET->(dbSkip())
      enddo
   end case
   ZAU->(dbGoto(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztEtEncontrados(aBrowse, oParent)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ZAU->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Etiqueta"
   oBrowse:aCols[2]:cHeader := "Documentos"
   oBrowse:aCols[1]:nWidth  := 220
   oBrowse:aCols[2]:nWidth  := 220
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )

   ZET->(ordSetFocus(1))
   ZET->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ZET->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztEtEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ZET->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztEtEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| ZET->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ZET->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

/*_____________________________________________________________________________*/

function AztEtClave( cEtiqueta, oGet, nMode )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lReturn  := .F.
   local nRecno   := ZET->( RecNo() )
   local nOrder   := ZET->( ordNumber() )
   local nArea    := Select()

   if Empty( cEtiqueta )
      if nMode == 4
         return .T.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .F.
      endif
   endif

   select ZET
   ZET->( dbSetOrder( 1 ) )
   ZET->( dbGoTop() )

   if ZET->( dbSeek( Upper( cEtiqueta ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("Etiqueta existente.")
      case nMode == 2
         if ZET->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("Etiqueta existente.")
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
         if MsgYesNo("Etiqueta inexistente. ¿ Desea darla de alta ahora? ")
            lReturn := AztEtEdita( , 1, , , @cEtiqueta )
         else
            lReturn := .F.
         endif
      endif
   endif

   if lReturn == .F.
      oGet:cText( Space(40) )
   else
      oGet:cText( cEtiqueta )
   endif

   ZET->( dbSetOrder( nOrder ) )
   ZET->( dbGoto( nRecno ) )

   select (nArea)

return lReturn

/*_____________________________________________________________________________*/

function AztEtCambiaClave( cNew, cOld, lDelete )
   local nAuxOrder
   local nAuxRecNo
   local nLen

   cOld := rtrim(cOld)
   cNew := rtrim(cNew)
   nLen := Len(cOld)
   Select ZAR
   nAuxRecno := ZAR->(RecNo())
   nAuxOrder := ZAR->(OrdNumber())
   ZAR->(DbSetOrder(0))
   ZAR->(DbGoTop())
   do while ! ZAR->(EoF())
      if At(cOld,ZAR->ArTags) != 0
         if lDelete
            replace ZAR->ArTags with Stuff(ZAR->ArTags, At(cOld,ZAR->ArTags), nLen+1, "")
         else
            replace ZAR->ArTags with Stuff(ZAR->ArTags, At(cOld,ZAR->ArTags), nLen, cNew)
         endif
      endif
      ZAR->(DbSkip())
   enddo
   ZAR->(DbSetOrder( nAuxOrder ))
   ZAR->(DbGoTo( nAuxRecno ))
return nil

//_____________________________________________________________________________//

function AztEtEjemplares( oGrid, oParent )

   local cEtTag := RTrim(ZET->EtTag)
   local oDlg, oBrowse, oCol
   local aBrowse := {}

   if ZET->EtEjempl == 0
      MsgStop("La etiqueta no aparece en ningún documento.")
      return nil
   endif

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'MA_EJEMPLARES'    ;
      TITLE 'Documentos de la etiqueta: '+RTrim(cEtTag) OF oParent
   oDlg:SetFont(oApp():oFont)

   select ZAR
   ZAR->(dbSetOrder(1))
   ZAR->(dbGoTop())
   do while ! ZAR->(Eof())
      if At(cEtTag, ZAR->ArTags) != 0
         AAdd(aBrowse, { ZAR->ArTitulo, ZAR->ArMateria })
      endif
      ZAR->(dbSkip())
   enddo
   if Len(abrowse) == 0
      MsgStop("La etiqueta no aparece en ningún documento.")
      select ZET
      oGrid:Refresh()
      oGrid:SetFocus(.T.)
      oApp():nEdit --
      retu nil
   endif
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )
   oBrowse := TXBrowse():New( oDlg )
   Ut_BrwRowConfig( oBrowse )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Título"
   oBrowse:aCols[1]:nWidth   := 250
   oBrowse:aCols[2]:cHeader := "Materia"
   oBrowse:aCols[2]:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| (ZAR->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt,1]))),;
      AztArEdita(,2,,oDlg)) } } )
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

   select ZET
   oGrid:Refresh()
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil
/*_____________________________________________________________________________*/

function AztEtImprime(oGrid,oParent)
   local nRecno   := ZET->(RecNo())
   local nOrder   := ZET->(ordSetFocus())
   local aCampos  := { "EtTag","EtEjempl" }
   local aTitulos := { "Etiqueta", "Documentos" }
   local aWidth   := { 40, 40 }
   local aShow    := { .T., .T. }
   local aPicture := { "NO", "@E 99,999" }
   local aTotal   := { .F., .F. }
   local oInforme
   local aControls[3]
   local cMateria := Space(40)

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ZET" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()

   if oInforme:Activate()
      if oInforme:nRadio == 1
         select ZET
         dbGoTop()
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
            oInforme:oReport:Say(1, 'Total etiquetas: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
         select ZET
      endif
   endif
   ZET->(dbGoto(nRecno))
   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --
return nil
//_____________________________________________________________________________//
