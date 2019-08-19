#include "Report.ch"
#include "FiveWin.ch"
#include "xBrowse.ch"
#include "vmenu.ch"

static oReport

function AztMaterias()

   local oCol
   local aBrowse
   local cState := GetPvProfString("Browse", "zMaState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "zMaOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "zMaRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "zMaSplit","102", oApp():cIniFile))
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

   select ZMA
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de materias')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   Ut_BrwRowConfig( oApp():oGrid )

   oApp():oGrid:cAlias := "ZMA"

   aBrowse   := { { {|| ZMA->MaMateria  }, i18n("Materia"), 150, 0 },;
      { {|| Trans(ZMA->MaEjempl, "@E 9,999") }, i18n("Nº Artículos"), 44, 1 } }

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
      oCol:bLDClickData  := {|| AztMaEdita(oApp():oGrid,2,oCont,oApp():oDlg) }
   next

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont,"ZMA", "Materias: ") }
   oApp():oGrid:bKeyDown := {|nKey| AztMaTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21

   oApp():oGrid:RestoreState( cState )

   ZAR->(dbSetOrder(nOrder))
   ZAR->(dbGoto(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION "Materias: "+tran(ZMA->(ordKeyNo()),'@E 999,999')+" / "+tran(ZMA->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_MATERIAS"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 // NOINSET

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Nuevo"              ;
      IMAGE "16_NUEVO"             ;
      ACTION AztMaEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Modificar"          ;
      IMAGE "16_MODIF"             ;
      ACTION AztMaEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Duplicar"           ;
      IMAGE "16_DUPLICAR"           ;
      ACTION AztMaEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Borrar"             ;
      IMAGE "16_BORRAR"            ;
      ACTION AztMaBorra( oApp():oGrid, oCont );
      LEFT 10

   /*
 DEFINE VMENUITEM OF oCont        ;
      CAPTION "Agrupar materias"   ;
      IMAGE "16_AGRUPA"            ;
      ACTION AztMaAgrupa( oApp():oGrid, oCont, oApp():oDlg );
      LEFT 10
 */

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Buscar"             ;
      IMAGE "16_BUSCAR"             ;
      ACTION AztMaBusca(oApp():oGrid,,oCont) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Imprimir"           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION AztMaImprime(oApp():oDlg)         ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documentos"     ;
      IMAGE "16_DOCUMENT"        ;
      ACTION AztMaEjemplares( oApp():oGrid, oApp():oDlg ) ;
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
      ACTION Ut_BrwColConfig( oApp():oGrid, "MaState" ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Salir"              ;
      IMAGE "16_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ (oApp():oDlg:nHeight/2)-13, nSplit+2 TABS oApp():oTab ;
      OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS ' Materias ';
      ACTION ( nOrder := oApp():oTab:nOption + 1,;
      ZMA->(dbSetOrder(nOrder)),;
      ZMA->(dbGoTop()),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont,"ZMA", "Materias: "))

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(), oApp():oGrid:SetFocus() ) ;
      VALID ( WritePProString("Browse","zMaState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","zMaOrder",LTrim(Str(ZMA->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","zMaRecno",LTrim(Str(ZMA->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","zMaSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oCont:End(), dbCloseAll(), oApp():oDlg := NIL, .T. )

return nil
//_____________________________________________________________________________//

function AztMaEdita( oGrid, nMode, oCont, oParent, cMateria )

   local oDlg, oFld, oBmp
   local aTitle := { i18n( "Añadir materia" ),;
      i18n( "Modificar materia"),;
      i18n( "Duplicar materia") }
   local aGet[1]
   local cMaMateria
   local nRecPtr := ZMA->(RecNo())
   local nOrden  := ZMA->(ordNumber())
   local nRecAdd
   local lDuplicado
   local lReturn := .F.

   if ZMA->(Eof()) .AND. nMode != 1
      return nil
   endif

   oApp():nEdit ++

   if nMode == 1
      ZMA->(dbAppend())
      nRecAdd := ZMA->(RecNo())
   endif

   cMaMateria  := iif(nMode==1.AND.cMateria!=NIL,cMateria,ZMA->MaMateria)

   if nMode == 3
      ZMA->(dbAppend())
      nRecAdd := ZMA->(RecNo())
   endif

   if oParent == NIL
      oParent := oApp():oDlg
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTMAEDIT"   ;
      TITLE aTitle[ nMode ]               ;
      OF oParent

   REDEFINE say ID 11 OF oDlg

   REDEFINE get aGet[1] var cMaMateria    ;
      ID 12 OF oDlg UPDATE                ;
      valid AztMaClave( cMaMateria, aGet[1], nMode )

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
         if cMaMateria != ZMA->MaMateria
            msgRun( i18n( "Revisando el fichero de materias. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
               {|| AztMaCambiaClave( cMaMateria, ZMA->MaMateria ) } )
         endif
      endif

      // ___ guardo el registro _______________________________________________//
      select ZMA
      replace ZMA->MaMateria  with cMaMateria
      // Replace ZMA->MaEjempl   with nMaEjempl
      ZMA->(dbCommit())
      if cMateria != NIL
         cMateria := ZMA->MaMateria
      endif
      oAGet():lzMa := .T.
      oAGet():Load()
   else
      lReturn := .F.
      if nMode == 1 .OR. nMode == 3

         ZMA->(dbGoto(nRecAdd))
         ZMA->(dbDelete())
         ZMA->(DbPack())
         ZMA->(dbGoto(nRecPtr))

      endif

   endif

   select ZMA

   if oCont != NIL
      RefreshCont(oCont,"ZMA", "Materias: ")
   endif
   if oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .T. )
   endif

   oApp():nEdit --

return lReturn
//_____________________________________________________________________________//

function AztMaBorra(oGrid,oCont)

   local nRecord  := ZMA->(RecNo())
   local cKeyNext
   local nAuxRecno
   local nAuxOrder

   oApp():nEdit ++

   if msgYesNo( i18n("¿ Está seguro de querer borrar esta materia ?") + CRLF + ;
         (Trim(ZMA->MaMateria)))

      msgRun( i18n( "Revisando el fichero de materias. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         {|| AztMaCambiaClave( Space(30), ZMA->MaMateria ) } )

      // borrado de la materia
      ZMA->(dbSkip())
      cKeyNext := ZMA->(ordKeyVal())
      ZMA->(dbGoto(nRecord))
      ZMA->(dbDelete())
      ZMA->(DbPack())
      oAGet():lzMa := .t.
      oAGet():Load()
      if cKeyNext != NIL
         ZMA->(dbSeek(cKeyNext))
      else
         ZMA->(dbGoBottom())
      endif
   endif

   if oCont != NIL
      RefreshCont(oCont,"ZMA", "Materias: ")
   endif

   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil
//_____________________________________________________________________________//

function AztMaTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztMaEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztMaEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztMaBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztMaBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztMaBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil

//_____________________________________________________________________________//

function AztMaSeleccion( cMateria, oControl, oParent )

   local oDlg, oBrowse, oCol
   local oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   local lOk    := .F.
   local nRecno := ZMA->( RecNo() )
   local nOrder := ZMA->( ordNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local cBrwState  := ""

   oApp():nEdit ++
   ZMA->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "MaAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de Materias" )     ;
      OF oParent

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ZMA"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZMA->MaMateria }
   oCol:cHeader  := i18n( "Materia" )
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztMaTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20
   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION AztMaEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION AztMaEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION AztMaBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION AztMaBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .T., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .F., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      on PAINT oDlg:Move(aPoint[1], aPoint[2],,,.T.)

   if lOK
      oControl:cText := ZMA->Mamateria
   endif

   SetIni( , "Browse", "MaAux", oBrowse:SaveState() )
   ZMA->( dbSetOrder( nOrder ) )
   ZMA->( dbGoto( nRecno ) )
   oApp():nEdit --

   select (nArea)

return nil
//_____________________________________________________________________________//


function AztMaBusca( oGrid, cChr, oCont, oParent )

   local nOrder   := ZMA->(ordNumber()) // el primer TAG es sin tipo
   local nRecno   := ZMA->(RecNo())
   local oDlg, oGet, cPicture
   local aSay1    := "Introduzca la materia a buscar"
   local aSay2    := "Materia:"
   local cGet     := Space(30)
   local lSeek    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR'   ;
      TITLE i18n("Búsqueda de materias") OF oParent

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
         {|| AztMaWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ninguna materia")
      else
         AztMaEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   ZMA->(ordSetFocus(nOrder))

   RefreshCont(oCont,"ZMA", "Materias: ")
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztMaWildSeek(nOrder, cGet, aBrowse)
   local nRecno   := ZMA->(RecNo())

   do case
   case nOrder == 1
      ZMA->(dbGoTop())
      do while ! ZMA->(Eof())
         if cGet $ Upper(ZMA->MaMateria)
            AAdd(aBrowse, {ZMA->MaMateria })
         endif
         ZMA->(dbSkip())
      enddo
   end case
   ZMA->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztMaEncontrados(aBrowse, oParent)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ZMA->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Materia"
   oBrowse:aCols[1]:nWidth  := 220
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   ZMA->(ordSetFocus(1))
   ZMA->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ZMA->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztMaEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ZMA->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztMaEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| ZMA->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ZMA->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

//_____________________________________________________________________________//

function AztMaClave( cMateria, oGet, nMode )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lReturn  := .F.
   local nRecno   := ZMA->( RecNo() )
   local nOrder   := ZMA->( ordNumber() )
   local nArea    := Select()

   if Empty( cMateria )
      if nMode == 4
         return .T.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .F.
      endif
   endif

   select ZMA
   ZMA->( dbSetOrder( 1 ) )
   ZMA->( dbGoTop() )

   if ZMA->( dbSeek( Upper( cMateria ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("Materia existente.")
      case nMode == 2
         if ZMA->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("Materia existente.")
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
         if MsgYesNo("Materia inexistente en el fichero de materias."+CRLF+"¿ Desea darla de alta ? ")
            lReturn := AztMaEdita( , 1, , , @cMateria )
         else
            lReturn := .F.
         endif
      endif
   endif
   if lReturn == .F.
      oGet:cText( Space(30) )
   else
      oGet:cText( cMateria )
   endif

   // ZMA->( DbSetOrder( nOrder ) )
   ZMA->( dbGoto( nRecno ) )
   select (nArea)

return lReturn
//_____________________________________________________________________________//

function AztMaCambiaClave( cNew, cOld )

   local nAuxOrder
   local nAuxRecNo

   // cambio la materia de documentos
   select ZAR
   nAuxRecno := ZAR->(RecNo())
   nAuxOrder := ZAR->(ordNumber())
   ZAR->(dbSetOrder(0))
   ZAR->(dbGoTop())
   replace ZAR->ArMateria      ;
      with cNew               ;
      for Upper(RTrim(ZAR->ArMateria)) == Upper(RTrim(cOld))
   ZAR->(dbSetOrder( nAuxOrder ))
   ZAR->(dbGoto( nAuxRecno ))

   // cambio la materia de autores
   select ZAU
   nAuxRecno := ZAU->(RecNo())
   nAuxOrder := ZAU->(ordNumber())
   ZAU->(dbSetOrder(0))
   ZAU->(dbGoTop())
   replace ZAU->AuMateria      ;
      with cNew               ;
      for Upper(RTrim(ZAU->AuMateria)) == Upper(RTrim(cOld))
   ZAU->(dbSetOrder( nAuxOrder ))
   ZAU->(dbGoto( nAuxRecno ))

   // cambio la materia de publicaciones
   select ZPU
   nAuxRecno := ZPU->(RecNo())
   nAuxOrder := ZPU->(ordNumber())
   ZPU->(dbSetOrder(0))
   ZPU->(dbGoTop())
   replace ZPU->PuMateria      ;
      with cNew               ;
      for Upper(RTrim(ZPU->PuMateria)) == Upper(RTrim(cOld))
   ZPU->(dbSetOrder( nAuxOrder ))
   ZPU->(dbGoto( nAuxRecno ))

return nil
//_____________________________________________________________________________//

function AztMaEjemplares( oGrid, oParent )

   local cMaMateria  := ZMA->MaMateria
   local oDlg, oBrowse, oCol

   if ZMA->MaEjempl == 0
      MsgStop("La materia no aparece en ningún documento.")
      return nil
   endif

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'MA_EJEMPLARES'    ;
      TITLE 'Documentos de la materia: '+cMaMateria OF oParent

   select ZAR
   ZAR->(dbSetOrder(3))
   ordScope(0, {|| Upper(cMaMateria) })
   ordScope(1, {|| Upper(cMaMateria) })
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
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| AztArEdita( oBrowse, 2,,oDlg ) } } )
   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 100 )
   oDlg:oClient := oBrowse

   // oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztMaTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON ID IDOK OF oDlg ;
      prompt i18n( "&Aceptar" )   ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

   ordScope( 0, )
   ordScope( 1, )

   select ZMA
   oGrid:Refresh()
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil

//_____________________________________________________________________________//

function AztMaImprime(oGrid, oParent)
   local nRecno   := ZMA->(RecNo())
   local nOrder   := ZMA->(ordSetFocus())
   local aCampos  := { "MaMateria","MaEjempl" }
   local aTitulos := { "Materia", "Documentos" }
   local aWidth   := { 40, 40 }
   local aShow    := { .T., .T. }
   local aPicture := { "NO", "@E 99,999" }
   local aTotal   := { .F., .F. }
   local oInforme
   local aControls[3]
   local cMateria := Space(40)

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ZMA" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()

   if oInforme:Activate()
      if oInforme:nRadio == 1
         select ZMA
         dbGoTop()
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
            oInforme:oReport:Say(1, 'Total materias: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
         select ZMA
      endif
   endif
   ZMA->(dbGoto(nRecno))
   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil
//_____________________________________________________________________________//

function AztMaList( aList, cData, oSelf )
   local aNewList := {}
   ZMA->( dbSetOrder(1) )
   ZMA->( dbGoTop() )
   while ! ZMA->(Eof())
      if at(Upper(cdata), Upper(ZMA->Mamateria)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aNewList, { ZMA->MaMateria } )
      endif 
      ZMA->(DbSkip())
   enddo
return aNewlist
