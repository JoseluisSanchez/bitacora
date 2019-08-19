#include "FiveWin.ch"
#include "Report.ch"
#include "xBrowse.ch"
#include "vmenu.ch"
#include "TAutoGet.ch"

static oReport

function AztAutores()

   local oCol
   local aBrowse
   local cState := GetPvProfString("Browse", "zAuState","", oApp():cIniFile)
   local nOrder := Val(GetPvProfString("Browse", "zAuOrder","1", oApp():cIniFile))
   local nRecno := Val(GetPvProfString("Browse", "zAuRecno","1", oApp():cIniFile))
   local nSplit := Val(GetPvProfString("Browse", "zAuSplit","102", oApp():cIniFile))
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

   select ZAU
   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de autores de documentos')
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nSplit )

   oApp():oGrid:cAlias := "ZAU"

   aBrowse   := { { {|| ZAU->AuNombre }, i18n("Nombre"), 150, 0 },;
      { {|| ZAU->AuMateria }, i18n("Materia"), 120, 0 },;
      { {|| TRAN( ZAU->AuEjempl, "@E 99,999  " ) }, i18n( "Documentos" ), 90, 1 },;
      { {|| ZAU->AuDirecc }, i18n("Dirección"), 120, 0 },;
      { {|| ZAU->AuLocali }, i18n("Localidad"), 120, 0 },;
      { {|| ZAU->AuTelefono }, i18n("Telefono"), 120, 0 },;
      { {|| ZAU->AuPais }, i18n("Pais"), 120, 0 },;
      { {|| ZAU->AuEmail }, i18n("E-mail"), 150, 0 },;
      { {|| ZAU->AuURL }, i18n("Sitio web"), 150, 0 } }


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
      oCol:bLDClickData  := {|| AztAuEdita(oApp():oGrid,2,oCont,oApp():oDlg) }
   next

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:bChange  := {|| RefreshCont(oCont, "ZAU", "Autores: ") }
   oApp():oGrid:bKeyDown := {|nKey| AztAuTecla(nKey,oApp():oGrid,oCont,oApp():oDlg) }
   oApp():oGrid:nRowHeight  := 21

   oApp():oGrid:RestoreState( cState )

   ZAU->(dbSetOrder(nOrder))
   ZAU->(dbGoto(nRecno))

   @ 02, 05 VMENU oCont SIZE nSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION "Autores: "+tran(ZAU->(ordKeyNo()),'@E 999,999')+" / "+tran(ZAU->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_LAUTOR"

   DEFINE VMENUITEM OF oCont        ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Nuevo"              ;
      IMAGE "16_NUEVO"             ;
      ACTION AztAuEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Modificar"          ;
      IMAGE "16_MODIF"             ;
      ACTION AztAuEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Duplicar"           ;
      IMAGE "16_DUPLICAR"           ;
      ACTION AztAuEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Borrar"             ;
      IMAGE "16_BORRAR"            ;
      ACTION AztAuBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Buscar"             ;
      IMAGE "16_BUSCAR"             ;
      ACTION AztAuBusca(oApp():oGrid,,oCont,oApp():oDlg)  ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Imprimir"           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION AztAuImprime(oApp():oGrid,oApp():oDlg)   ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Visitar sitio web"  ;
      IMAGE "16_INTERNET"          ;
      ACTION GoWeb(ZAU->AuUrl)      ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar e-mail"      ;
      IMAGE "16_EMAIL"             ;
      ACTION GoMail(ZAU->AuEmail)   ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Ver documentos"     ;
      IMAGE "16_DOCUMENT"          ;
      ACTION AztAuEjemplares( oApp():oGrid, oApp():oDlg ) ;
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
      ITEMS ' Autor ', ' Materia ', ' Pais ';
      ACTION ( nOrder := oApp():oTab:nOption,;
      ZAU->(dbSetOrder(nOrder)),;
      oApp():oGrid:Refresh(.T.),;
      RefreshCont(oCont, "ZAU", "Autores: ") )

   oApp():oDlg:NewSplitter( nSplit, oCont, oCont )

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(), oApp():oGrid:SetFocus()) ;
      VALID ( oApp():oGrid:nLen := 0,;
      WritePProString("Browse","zAuState",oApp():oGrid:SaveState(),oApp():cIniFile),;
      WritePProString("Browse","zAuOrder",LTrim(Str(ZAU->(ordNumber()))),oApp():cIniFile),;
      WritePProString("Browse","zAuRecno",LTrim(Str(ZAU->(RecNo()))),oApp():cIniFile),;
      WritePProString("Browse","zAuSplit",LTrim(Str(oApp():oSplit:nleft/2)),oApp():cIniFile),;
      oCont:End(), dbCloseAll(), oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, .T. )

return nil
/*_____________________________________________________________________________*/

function AztAuEdita(oGrid,nMode,oCont,oParent,cAutor)

   local oDlg, oFld, oBmp
   local aTitle := { i18n( "Añadir un autor de documentos" ),;
      i18n( "Modificar un autor de documentos"),;
      i18n( "Duplicar un autor de documentos") }
   local aGet[12]
   local cAunombre,;
      cAuMateria,;
      cAuNotas,;
      cAudirecc,;
      cAuLocali,;
      cAutelefono,;
      cAuPais,;
      cAuemail,;
      cAuurl

   local nRecPtr  := ZAU->(RecNo())
   local nOrden   := ZAU->(ordNumber())
   local nRecAdd
   local lDuplicado
   local lReturn  := .F.

   if ZAU->(Eof()) .AND. nMode != 1
      return nil
   endif
   oApp():nEdit ++

   if nMode == 1
      ZAU->(dbAppend())
      nRecAdd := ZAU->(RecNo())
   endif

   cAunombre   := iif(nMode==1.AND.cAutor!=NIL,cAutor,ZAU->AuNombre)
   cAuMateria  := ZAU->Aumateria
   cAudirecc   := ZAU->Audirecc
   cAuLocali   := ZAU->AuLocali
   cAutelefono := ZAU->Autelefono
   cAuPais     := ZAU->AuPais
   cAuemail    := ZAU->Auemail
   cAuurl      := ZAU->Auurl
   cAunotas    := ZAU->Aunotas

   if nMode == 3
      ZAU->(dbAppend())
      nRecAdd := ZAU->(RecNo())
   endif

   DEFINE DIALOG oDlg RESOURCE "AZTAUEDIT" OF oParent;
      TITLE aTitle[ nMode ]
   oDlg:SetFont(oApp():oFont)

   REDEFINE get aGet[1] var cAuNombre  ;
      ID 101 OF oDlg UPDATE            ;
      valid AztAuClave( cAuNombre, aGet[1], nMode )

   REDEFINE AUTOGET aGet[2] ;
      var cAuMateria ;
      ITEMS oAGet():aZMA ;
      ID 109 ;
      OF oDlg ;
      VALID ( AztMaClave( @cAuMateria, aGet[2], 4 ) )

   REDEFINE BUTTON aGet[10]                  ;
      ID 110 OF oDlg                         ;
      ACTION AztMaSeleccion( cAuMateria, aGet[2], oDlg )
   aGet[10]:cTooltip := "seleccionar materia"

   REDEFINE get aGet[3] var cAuemail ;
      ID 102 OF oDlg UPDATE

   REDEFINE BUTTON aGet[11]         ;
      ID 111 OF oDlg                ;
      ACTION GoMail( cAuEmail )
   aGet[11]:cTooltip := "enviar e-mail"

   REDEFINE get aGet[4] var cAuURL    ;
      ID 103 OF oDlg UPDATE

   REDEFINE BUTTON aGet[12]         ;
      ID 112 OF oDlg                ;
      ACTION GoWeb( cAuURL )
   aGet[12]:ctooltip := "visitar sitio web"

   REDEFINE get aGet[5] var cAuDirecc  ;
      ID 104 OF oDlg UPDATE

   REDEFINE get aGet[6] var cAuLocali  ;
      ID 105 OF oDlg UPDATE

   REDEFINE get aGet[7] var cAupais    ;
      ID 106 OF oDlg UPDATE

   REDEFINE get aGet[8] var cAuTelefono;
      ID 107 OF oDlg UPDATE

   REDEFINE get aGet[9] var cAuNotas   ;
      MULTILINE ID 108 OF oDlg UPDATE

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
         ZAU->(dbGoto(nRecPtr))
      else
         ZAU->(dbGoto(nRecAdd))
      endif
      // ___ actualizo el nombre del autor en los documentos__________________//
      if nMode == 2
         if cAuNombre != ZAU->AuNombre
            msgRun( i18n( "Revisando el fichero de autores. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
               {|| AztAuCambiaClave( cAuNombre, ZAU->AuNombre, .F. ) } )
         endif
      endif

      // ___ guardo el registro _______________________________________________//
      replace ZAU->Aunombre   with cAunombre
      replace ZAU->Aumateria  with cAumateria
      replace ZAU->Audirecc   with cAudirecc
      replace ZAU->AuLocali   with cAuLocali
      replace ZAU->Autelefono with cAutelefono
      replace ZAU->Aupais     with cAupais
      replace ZAU->Auemail    with cAuemail
      replace ZAU->Auurl      with cAuurl
      replace ZAU->Aunotas    with cAunotas
      ZAU->(dbCommit())
      if cAutor != NIL
         cAutor := ZAU->AuNombre
      endif
   else
      lReturn := .F.
      if nMode == 1 .OR. nMode == 3
         ZAU->(dbGoto(nRecAdd))
         ZAU->(dbDelete())
         ZAU->(DbPack())
         ZAU->(dbGoto(nRecPtr))
      endif
   endif

   select ZAU
   if oCont != NIL
      RefreshCont(oCont, "ZAU", "Autores: ")
   endif

   oApp():nEdit --
   if oGrid != NIL
      oGrid:Refresh()
      oGrid:SetFocus( .T. )
   endif

return lReturn
/*_____________________________________________________________________________*/

function AztAuBorra(oGrid,oCont)

   local nRecord := ZAU->(RecNo())
   local nNext

   oApp():nEdit ++

   if msgYesNo( i18n("¿ Está seguro de querer borrar este autor ?") + CRLF + ;
         (Trim(ZAU->AuNombre)))
      msgRun( i18n( "Revisando el fichero de autores. Espere un momento..." ), oApp():cAppName+oApp():cVersion, ;
         {|| AztAuCambiaClave( Space(50), ZAU->AuNombre, .T. ) } )

      select ZAU
      ZAU->(dbSkip())
      nNext := ZAU->(RecNo())
      ZAU->(dbGoto(nRecord))

      ZAU->(dbDelete())
      ZAU->(DbPack())
      ZAU->(dbGoto(nNext))
      if ZAU->(Eof()) .OR. nNext == nRecord
         ZAU->(dbGoBottom())
      endif
   endif

   if oCont != NIL
      RefreshCont(oCont, "ZAU", "Autores: ")
   endif

   oApp():nEdit --
   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)

return nil
/*_____________________________________________________________________________*/

function AztAuTecla(nKey,oGrid,oCont,oDlg)

   do case
   case nKey==VK_RETURN
      AztAuEdita(oGrid,2,oCont,oDlg)
   case nKey==VK_INSERT
      AztAuEdita(oGrid,1,oCont,oDlg)
   case nKey==VK_DELETE
      AztAuBorra(oGrid,oCont)
   case nKey==VK_ESCAPE
      oDlg:End()
   otherwise
      if nKey >= 96 .AND. nKey <= 105
         AztAuBusca(oGrid,Str(nKey-96,1),oCont,oDlg)
      elseif HB_ISSTRING(Chr(nKey))
         AztAuBusca(oGrid,Chr(nKey),oCont,oDlg)
      endif
   endcase

return nil
/*_____________________________________________________________________________*/

function AztAuSeleccion( aItems, oControl, oParent )

   local oDlg, oBrowse, oCol
   local oBtnAceptar, oBtnCancel, oBNew, oBMod, oBDel, oBBus
   local lOk    := .F.
   local nRecno := ZAU->( RecNo() )
   local nOrder := ZAU->( ordNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local cBrwState  := ""

   oApp():nEdit ++
   ZAU->( dbGoTop() )

   cBrwState := GetIni( , "Browse", "AuAux", "" )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" ;
      TITLE i18n( "Selección de autores" )      ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrowse )

   oBrowse:cAlias := "ZAU"

   oCol := oBrowse:AddCol()
   oCol:bStrData := {|| ZAU->AuNombre }
   oCol:cHeader  := i18n( "Autor" )
   oCol:nWidth   := 250

   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {|| lOk := .T., oDlg:End() } } )

   oBrowse:lHScroll := .F.
   oBrowse:SetRDD()
   oBrowse:CreateFromResource( 110 )
   oDlg:oClient := oBrowse

   oBrowse:RestoreState( cBrwState )
   oBrowse:bKeyDown := {|nKey| AztAuTecla( nKey, oBrowse, , oDlg ) }
   oBrowse:nRowHeight := 20

   REDEFINE BUTTON oBNew   ;
      ID 410 OF oDlg       ;
      ACTION AztAuEdita( oBrowse, 1,,oDlg )

   REDEFINE BUTTON oBMod   ;
      ID 411 OF oDlg       ;
      ACTION AztAuEdita( oBrowse, 2,,oDlg )

   REDEFINE BUTTON oBDel   ;
      ID 412 OF oDlg       ;
      ACTION AztAuBorra( oBrowse, )

   REDEFINE BUTTON oBBus   ;
      ID 413 OF oDlg       ;
      ACTION AztAuBusca( oBrowse,,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (lOk := .T., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .F., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      on PAINT oDlg:Move(aPoint[1], aPoint[2],,,.T.)


   if lOK
      if AScan(aItems, RTrim(ZAU->AuNombre)) == 0
         oControl:Additem(RTrim(ZAU->AuNombre))
         AAdd(aItems,RTrim(ZAU->AuNombre))
         oControl:Refresh()
      else
         msgAlert('El autor ya aparece en el documento.')
      endif
   endif

   SetIni( , "Browse", "AuAux", oBrowse:SaveState() )
   ZAU->( dbSetOrder( nOrder ) )
   ZAU->( dbGoto( nRecno ) )
   oApp():nEdit --

   select (nArea)

return nil
/*_____________________________________________________________________________*/


function AztAuBusca( oGrid, cChr, oCont, oParent )

   local nOrder   := ZAU->(ordNumber())
   local nRecno   := ZAU->(RecNo())
   local oDlg, oGet, cGet, cPicture
   local lSeek    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR' OF oParent  ;
      TITLE i18n("Búsqueda de autores de documentos")
   oDlg:SetFont(oApp():oFont)

   if nOrder == 1
      REDEFINE say prompt i18n( "Introduzca el nombre del autor" ) ID 20 OF oDlg
      REDEFINE say prompt i18n( "Nombre" )+":" ID 21 OF Odlg
      cGet     := Space(50)
   elseif nOrder == 2
      REDEFINE say prompt i18n( "Introduzca la materia del autor" ) ID 20 OF oDlg
      REDEFINE say prompt i18n( "Materia" )+":" ID 21 OF Odlg
      cGet     := Space(30)
   elseif nOrder == 3
      REDEFINE say prompt i18n( "Introduzca el país del autor" ) ID 20 OF oDlg
      REDEFINE say prompt i18n( "País" )+":" ID 21 OF Odlg
      cGet     := Space(30)
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
         {|| AztAuWildSeek(nOrder, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         MsgStop("No se ha encontrado ningún autor")
      else
         AztAuEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   ZAU->(ordSetFocus(nOrder))
   RefreshCont(oCont, "ZAU", "Autores: ")
   oGrid:refresh()
   oGrid:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AztAuWildSeek(nOrder, cGet, aBrowse)

   local nRecno   := ZAU->(RecNo())

   do case
   case nOrder == 1
      ZAU->(dbGoTop())
      do while ! ZAU->(Eof())
         if cGet $ Upper(ZAU->AuNombre)
            AAdd(aBrowse, {ZAU->AuNombre, ZAU->AuMateria, ZAU->AuPais })
         endif
         ZAU->(dbSkip())
      enddo
   case nOrder == 2
      ZAU->(dbGoTop())
      do while ! ZAU->(Eof())
         if cGet $ Upper(ZAU->AuMateria)
            AAdd(aBrowse, {ZAU->AuNombre, ZAU->AuMateria, ZAU->AuPais })
         endif
         ZAU->(dbSkip())
      enddo
   case nOrder == 3
      ZAU->(dbGoTop())
      do while ! ZAU->(Eof())
         if cGet $ Upper(ZAU->AuPais)
            AAdd(aBrowse, {ZAU->AuNombre, ZAU->AuMateria, ZAU->AuPais })
         endif
         ZAU->(dbSkip())
      enddo
   end case
   ZAU->(dbGoto(nRecno))
   // ordeno la tabla por el 2 elemento
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AztAuEncontrados(aBrowse, oParent)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := ZAU->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   oBrowse:aCols[1]:cHeader := "Autor"
   oBrowse:aCols[2]:cHeader := "Materia"
   oBrowse:aCols[3]:cHeader := "Pais"
   oBrowse:aCols[1]:nWidth  := 220
   oBrowse:aCols[2]:nWidth  := 120
   oBrowse:aCols[3]:nWidth  := 140
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )

   ZAU->(ordSetFocus(1))
   ZAU->(dbSeek(Upper(aBrowse[1, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||ZAU->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztAuEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(ZAU->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))),;
      AztAuEdita( , 2,, oApp():oDlg )),) }
   oBrowse:bChange    := {|| ZAU->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1]))) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg     ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg ;
      ACTION (ZAU->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

/*_____________________________________________________________________________*/

function AztAuClave( cAutor, oGet, nMode )

   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lReturn  := .F.
   local nRecno   := ZAU->( RecNo() )
   local nOrder   := ZAU->( ordNumber() )
   local nArea    := Select()

   if Empty( cAutor )
      if nMode == 4
         return .T.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .F.
      endif
   endif

   select ZAU
   ZAU->( dbSetOrder( 1 ) )
   ZAU->( dbGoTop() )

   if ZAU->( dbSeek( Upper( cAutor ) ) )
      do case
      case nMode == 1 .OR. nMode == 3
         lReturn := .F.
         MsgStop("Autor existente.")
      case nMode == 2
         if ZAU->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop("Autor existente.")
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
         if MsgYesNo("Autor inexistente. ¿ Desea darlo de alta ahora? ")
            lReturn := AztAuEdita( , 1, , , @cAutor )
         else
            lReturn := .F.
         endif
      endif
   endif

   if lReturn == .F.
      oGet:cText( Space(50) )
   else
      oGet:cText( cAutor )
   endif

   ZAU->( dbSetOrder( nOrder ) )
   ZAU->( dbGoto( nRecno ) )

   select (nArea)

return lReturn

/*_____________________________________________________________________________*/

function AztAuCambiaClave( cNew, cOld, lDelete )
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
      if At(cOld,ZAR->ArAutores) != 0
         if lDelete
            replace ZAR->ArAutores with Stuff(ZAR->ArAutores, At(cOld,ZAR->ArAutores), nLen+1, "")
         else
            replace ZAR->ArAutores with Stuff(ZAR->ArAutores, At(cOld,ZAR->ArAutores), nLen, cNew)
         endif
      endif
      ZAR->(DbSkip())
   enddo
   ZAR->(DbSetOrder( nAuxOrder ))
   ZAR->(DbGoTo( nAuxRecno ))
return nil

//_____________________________________________________________________________//

function AztAuEjemplares( oGrid, oParent )

   local cAuNombre := RTrim(ZAU->AuNombre)
   local oDlg, oBrowse, oCol
   local aBrowse := {}

   if ZAU->AuEjempl == 0
      MsgStop("El autor no aparece en ningún documento.")
      return nil
   endif

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'MA_EJEMPLARES'    ;
      TITLE 'Documentos del autor: '+RTrim(cAuNombre) OF oParent
   oDlg:SetFont(oApp():oFont)

   select ZAR
   ZAR->(dbSetOrder(1))
   ZAR->(dbGoTop())
   do while ! ZAR->(Eof())
      if At(cAunombre, ZAR->ArAutores) != 0
         AAdd(aBrowse, { ZAR->ArTitulo, ZAR->ArMateria })
      endif
      ZAR->(dbSkip())
   enddo
   if Len(abrowse) == 0
      MsgStop("El autor no aparece en ningún documento.")
      select ZAU
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

   ordScope( 0, )
   ordScope( 1, )

   select ZAU
   oGrid:Refresh()
   oGrid:SetFocus(.T.)
   oApp():nEdit --

return nil
/*_____________________________________________________________________________*/

function AztAuImprime(oGrid,oParent)

   local nRecno   := ZAU->(RecNo())
   local nOrder   := ZAU->(ordSetFocus())
   local aCampos  := { "AUNOMBRE", "AUDIRECC", "AUTELEFONO", "AUMATERIA", "AUEJEMPL", ;
      "AULOCALI", "AUPAIS", "AUEMAIL", "AUURL" }
   local aTitulos := { "Autor", "Dirección", "Teléfono", "Materia", "Documentos",;
      "Localidad", "Pais", "e-mail", "Sitio web " }
   local aWidth   := { 30, 50, 10, 20, 10, 50, 30, 20, 20 }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO","NO","NO","NO","NO","NO","NO","NO", "NO" }
   local aTotal   := { .F., .F., .F., .F., .F., .F., .F., .F., .F. }
   local oInforme
   local aControls[3]
   local cAuMateria := Space(40)

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "ZAU" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 300, 301 OF oInforme:oFld:aDialogs[1]

   REDEFINE say aControls[1] ID 111 OF oInforme:oFld:aDialogs[1]
   REDEFINE get aControls[2] var cAuMateria  ;
      ID 112 OF oInforme:oFld:aDialogs[1] UPDATE ;
      valid AztMaClave( @cAuMateria, aControls[2], 4 )
   REDEFINE BUTTON aControls[3]              ;
      ID 113 OF oInforme:oFld:aDialogs[1]    ;
      ACTION AztMaSeleccion( cAuMateria, aControls[2], oInforme:oFld:aDialogs[1] )
   aControls[3]:cTooltip := "seleccionar materia"

   oInforme:Folders()

   if oInforme:Activate()
      ZAU->(dbGoTop())
      if oInforme:nRadio == 1
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
            oInforme:oReport:Say(1, 'Total autores: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
      elseif oInforme:nRadio == 2
         oInforme:cTitulo1  := RTrim(cAuMateria)
         oInforme:cTitulo2  := "relación de autores de la materia"
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            for Upper(RTrim(ZAU->AuMateria)) == Upper(RTrim(cAuMateria))
         oInforme:End(.F.)
      endif
      ZAU->(dbGoto(nRecno))
   endif

   oGrid:Refresh()
   oGrid:SetFocus( .T. )
   oApp():nEdit --

return nil
/*_____________________________________________________________________________

function AztAaNuevo( oGrid, aAA, lBlank )

   local oDlg, oSay
   local cTitle := "Asignar autor"
   local aGet[1]
   local cAaNombre := Space(50)
   local nRecAdd
   local lDuplicado

   DEFINE DIALOG oDlg RESOURCE "AZTXAAEDIT" TITLE cTitle
   oDlg:SetFont(oApp():oFont)

   REDEFINE say oSay prompt "Autor:" ID 11 OF oDlg
   REDEFINE get aGet[1] var cAaNombre        ;
      ID 101 OF oDlg UPDATE                  ;
      valid AztAuClave( @cAaNombre, aGet[1], 4 )

   REDEFINE BUTTON ID 102 OF oDlg      ;
      ACTION AztAuSeleccion( cAaNombre, aGet[1] )

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
      if lBlank
         aAA[1] := cAaNombre
         lBlank := .F.
      else
         AAdd(aAA, cAaNombre )
      endif
   endif

   oGrid:Refresh()
   oGrid:SetFocus( .T. )

return nil

function AztAaBorra( oGrid, aAA, lBlank )

   if msgYesNo( i18n("¿ Está seguro de querer borrar este autor ?") + CRLF + ;
         Trim(aAA[oGrid:nRowSel]) )
      if oGrid:nRowSel == Len(aAA)
         if oGrid:nRowSel == 1
            aAA[1] := " "
            lBlank := .T.
         else
            ADel(aAA,oGrid:nRowSel)
            ASize(aAA,Len(aAA)-1)
         endif
      else
         ADel(aAA,oGrid:nRowSel)
         ASize(aAA,Len(aAA)-1)
      endif
   endif
   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)

return nil

function AztAaSwapUp(oGrid)

   local nRecPtr := XAA->(RecNo())
   local nOrden  := XAA->(ordNumber())
   local nKeyNo  := XAA->(ordKeyNo())
   local nArea   := Select()

   select XAA
   ? nKeyNo
   ? XAA->AaNombre
   replace XAA->AaOrden with "00"
   XAA->(dbSkip(-1))
   ? XAA->AaNombre
   replace XAA->AaOrden with StrZero(nKeyNo,2)
   XAA->(dbGoTop())
   ? XAA->AaNombre
   replace XAA->AaOrden with StrZero(nKeyNo-1,2)
   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)
   select (nArea)

return nil

function AztAaSwapDown(oGrid)

   local nRecPtr := XAA->(RecNo())
   local nOrden  := XAA->(ordNumber())
   local nKeyNo  := XAA->(ordKeyNo())

   replace XAA->AaOrden with "00"
   XAA->(dbGoto(nkeyNo))
   replace XAA->AaOrden with StrZero(nKeyNo,2)
   XAA->(dbGoTop())
   replace XAA->AaOrden with StrZero(nKeyNo-1,2)
   oGrid:Refresh(.T.)
   oGrid:SetFocus(.T.)

return nil
_____________________________________________________________________________*/
