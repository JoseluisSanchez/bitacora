#include "FiveWin.ch"
#include "Report.ch"
#include "splitter.ch"
#include "vmenu.ch"
#include "treeview.ch"

STATIC oReport

function Francesa()
   local oBar, oCont, oLink, xPrompt
   local aBrowse
   // local cState := GetPvProfString("Browse", "VaState","", oApp():cInifile)
   local nOrder := VAL(GetPvProfString("Browse", "MaOrder","1", oApp():cInifile))
   local nSplit := VAL(GetPvProfString("Browse", "MaSplit","102", oApp():cInifile))
   local nRecTab

   if oApp():oDlg != nil
      if oApp():nEdit > 0
         //MsgStop('Por favor, finalice la edición del registro actual.')
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   if ! Db_OpenAll()
      return nil
   endif

   SELECT MA
   IF MA->(RecCount()) == 0
      MA->(DbAppend())
      REPLACE MaMateria WITH "Materia ficticia"
   ENDIF

   oApp():oDlg := TFsdi():New(oApp():oWndMain)
   oApp():oDlg:cTitle := i18n('Gestión de materias y palabras clave')
   oApp():oWndMain:oClient := oApp():oDlg

   @ 0, nSplit+2 TREE oApp():oGrid OF oApp():oDlg ;
      SIZE (oApp():oDlg:nWidth())/2, (oApp():oDlg:nHeight()-26)/2 PIXEL    ;
      BITMAPS { "SH_MATERIA","SH_PCLAVE" }  ;
      TREE STYLE nOr( TVS_HASLINES, TVS_HASBUTTONS ) ; //LBS_OWNERDRAWVARIABLE, LBS_NOINTEGRALHEIGHT, WS_BORDER, WS_VSCROLL, WS_HSCROLL, WS_TABSTOP );//
      ON DBLCLICK FrClickTree(oApp():oGrid)   ;
      ON CHANGE ( oLink := oApp():oGrid:GetLinkAt( oApp():oGrid:GetCursel() ) ,;
                  MA->(DbSeek(oLink:Cargo))                     ,;
                  RefreshCont(oCont,"MA") )
   FrTreeLoad(oApp():oGrid)

   oApp():oGrid:nBottom := oApp():oDlg:nGridBottom // ( oApp():oDlg:nHeight() - 36 ) / 2
   oApp():oGrid:nRight  := oApp():oDlg:nGridRight  // ( oApp():oDlg:nWidth() ) / 2

   MA->(DbGoTop())

	@ 02, 05 VMENU oCont SIZE nSplit-10, 18 OF oApp():oDlg

   DEFINE TITLE OF oCont;
      CAPTION tran(MA->(OrdKeyNo()),'@E 999,999')+" / "+tran(MA->(OrdKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_MATER"

   @ 24, 05 VMENU oBar SIZE nSplit-10, 150 OF oApp():oDlg  ;
      COLOR CLR_BLACK, GetSysColor(15)       ;
      COLOROVER GetSysColor(14), GetSysColor(13) SOLID FILLED;
      HEIGHT ITEM 22

   DEFINE TITLE OF oBar                      ;
      CAPTION "Materias y palabras clave"    ;
      HEIGHT 24                              ;
		COLOR GetSysColor(9), oApp():nClrBar ; 	

   DEFINE VMENUITEM OF obar         ;
      HEIGHT 12

   DEFINE VMENUITEM OF oBar         ;
      CAPTION "Nueva materia"       ;
      IMAGE "SH_MATERIA"            ;
      ACTION FrEdita( oApp():oGrid, 1, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar         ;
      CAPTION "Nueva palabra clave" ;
      IMAGE "SH_PCLAVE"             ;
      ACTION FrEdita( oApp():oGrid, 2, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar         ;
      CAPTION "Modificar"           ;
      IMAGE "SH_MODif"              ;
      ACTION FrEdita( oApp():oGrid, 3, oCont, oApp():oDlg );
      LEFT 10

   DEFINE VMENUITEM OF oBar         ;
      CAPTION "Borrar"              ;
      IMAGE "SH_BORRAR"             ;
      ACTION FrBorra( oApp():oGrid, oCont );
      LEFT 10

   DEFINE VMENUITEM OF oBar         ;
      CAPTION "Ver documentos"      ;
      IMAGE "SH_EJEMPLARES"         ;
      ACTION FrEjemplares( oApp():oGrid,oApp():oDlg ) ;
      LEFT 10

   DEFINE VMENUITEM OF oBar         ;
      CAPTION "Buscar"              ;
      IMAGE "SH_BUSCA"              ;
      ACTION FrBusca( oApp():oGrid,,oApp():oDlg,, )   ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Imprimir"           ;
      IMAGE "SH_IMPRIMIR"          ;
      ACTION FrImprime(oApp():oDlg)         ;
      LEFT 10

   DEFINE VMENUITEM OF oBar        ;
      INSET HEIGHT 18

   DEFINE VMENUITEM OF oBar        ;
      CAPTION "Salir"              ;
      IMAGE "SH_SALIR"             ;
      ACTION oApp():oDlg:End()              ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nSplit+2 TABS oApp():oTab ;
     OPTION nOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
     ITEMS ' Clasificación '

   @ 00, nSplit SPLITTER oApp():oSplit ;
      VERTICAL ;
      PREVIOUS CONTROLS oCont, oBar ;
      HINDS CONTROLS oApp():oGrid, oApp():oTab ;
      SIZE 1, oApp():oDlg:nGridBottom + oApp():oTab:nHeight PIXEL ;
      OF oApp():oDlg ;
      _3DLOOK ;
      UPDATE

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      VALID ( WritePProString("Browse","MaOrder",Ltrim(Str(MA->(OrdNumber()))),oApp():cInifile),;
              WritePProString("Browse","MaSplit",Ltrim(Str(oApp():oSplit:nleft/2)),oApp():cInifile) ,;
              oBar:End(), DbCloseAll(), oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, .t. )

return nil

/*_____________________________________________________________________________*/
function FrTreeLoad( oTree )
   local oDatabase
   local nStep
   local oLink
   local oLink1, oLink2
   local N1 := 0
   local N2 := 0
   local N3 := 0
   local N4 := 0
   // oTree:bRClicked = {|nRow,nCol|  MenuTree(oTree,nRow,nCol)}

   oLink := oTree:GetRoot()

   SELECT MA
   MA->(DbGoTop())

   DO WHILE ! MA->(EOF())
      if Rtrim(MA->MaPClave) == ""
         oLink1 := oLink:AddLastChild(MA->MaMateria,1,1,.t.)
         oLink1:Cargo := Upper(MA->Mamateria)
      else
         oLink2 := oLink1:AddLastChild(MA->MaPClave,2,2,.t.)
         oLink2:Cargo := Upper(MA->Mamateria) + Upper(MA->MaPClave)
      endif
      MA->(DbSkip())
   ENDDO

   oTree:UpdateTV()
   oTree:SetFocus()

return nil

/*_____________________________________________________________________________*/

function FrClickTree( oTree )
   local oLink    := oTree:GetLinkAt( oTree:GetCursel() )
   local cPrompt  := oLink:TreeItem:cPrompt
   // MsgInfo(oLink:Cargo)

return nil
/*_____________________________________________________________________________*/

function FrEdita( oTree, nMode, oCont, oDlgParent )
   // nMode 1 añadir rama, 2 añadir hoja, 3 modificar
   local oDlg
   local aTitle   := { i18n( "Añadir una materia " )   ,;
                       i18n( "Añadir una palabra clave ") ,;
                       i18n( "Modificar una ") }

   local aGet[1]
   local aPrompt  := { i18n( "Materia " )   ,;
                       i18n( "Palabra clave ") ,;
                       "" }

   local oLink       := oTree:GetLinkAt( oTree:GetCursel() )
   local cMateria    := SubStr(oLink:Cargo,1,40)
   local cPrompt
   local cCargo      := oLink:Cargo
   local nLevel      := INT(AT(" 0",cCargo)/2)
   local oParent     := oLink:ParentLink
   local oLChild
   local oNewLink
   local cPCargo     := oParent:cargo
   local lMateria    // indica si el nodo actual es una materia

   oApp():nEdit ++

   MA->(DbSeek(cCargo))

   lMateria := ( Len(cCargo) <= 40 )

   if nMode == 1
      cPrompt  := Space(40)
      lMateria := .t.
   elseif nMode == 2
      cPrompt := Space(45)
      lMateria := .f.
   elseif nMode == 3
      if lMateria
         cPrompt     := oLink:TreeItem:cPrompt + space(40-len(oLink:TreeItem:cPrompt))
         aTitle[3]   := aTitle[3]+ "materia"
         aPrompt[3]  := i18n("Materia")
      else
         cPrompt     := oLink:TreeItem:cPrompt + space(45-len(oLink:TreeItem:cPrompt))
         aTitle[3]   := aTitle[3]+ "palabra clave"
         aPrompt[3]  := i18n("Palabra clave")
      endif
   endif

   DEFINE DIALOG oDlg RESOURCE "MAEDIT" ;
      TITLE aTitle[ nMode ] OF oDlgParent
   oDlg:oFont  := oApp():oFont

   REDEFINE SAY PROMPT aPrompt[nMode] ID 11 OF oDlg

   REDEFINE GET aGet[1] VAR cPrompt ;
      ID 12 OF oDlg UPDATE          ;
      VALID FrClave( cPrompt, aGet[1], nMode, lMateria, cCargo )

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

   if oDlg:nresult == IDOK

      if nMode == 1
         // añado materia
         MA->(DbAppend())
         REPLACE MaMateria WITH cPrompt
         REPLACE MaEjempl  WITH 0
         MA->(DbCommit())
         oNewLink := oParent:AddLastChild(MA->MaMateria,1,1)
         oNewlink:Cargo := MA->MaMateria
         oTree:UpdateTV()
      elseif nMode == 2
         // añado palabra clave
         MA->(DbAppend())
         REPLACE MaMateria WITH cMateria
         REPLACE MaPClave  WITH cPrompt
         REPLACE MaEjempl  WITH 0
         MA->(DbCommit())
         oNewLink := oLink:AddLastChild(MA->MaPClave,2,2)
         oNewlink:Cargo := MA->MaMateria + MA->MaPClave
         oTree:UpdateTV()
         // oTree
      elseif nMode == 3
         select MA
         if lmateria
            FrCambiaClave( cPrompt, MA->MaMateria, .f., lMateria )
            replace MA->MaMateria with cPrompt
         else
            FrCambiaClave( cPrompt, MA->MaPClave, .f., lMateria )
            replace MA->MaPClave  with cPrompt
         endif
         oTree:Modify( ,cPrompt,, )
         oTree:UpdateTV()
      endif
   else
   endif

   if oCont != nil
      RefreshCont(oCont,"MA")
   endif
   SELECT MA

   oApp():nEdit --
   // FrTreeLoad(oTree)

return nil
/*_____________________________________________________________________________*/

function FrBorra( oTree, oCont )
   local oLink       := oTree:GetLinkAt( oTree:GetCursel() )
   local cPrompt     := oLink:TreeItem:cPrompt
   local cCargo      := oLink:Cargo
   local lMateria    := ( Len(cCargo) <= 40 )
   local oParent     := oLink:ParentLink
   local cPCargo     := oParent:cargo
   local cNewCargo   := ""
   local lFrHoja
   local cResto
   local nRecno
   local nNext

   if MA->(RecCount()) == 1
      MsgStop("No se puede borrar todas las materias del fichero. POr favor introduzca otra materia y luego borre esta.")
      retu NIL
   endif

   oApp():nEdit ++
   MA->(DbSeek(cCargo))
   nRecno := MA->(Recno())

   if oLink:IsParent() // ! FR->FrHoja
      MsgStop("No se puede borrar una materia que tiene palabras clave."+CRLF+"Debe borrar primero sus palabras clave.")
      oApp():nEdit --
      return nil
   endif

   if msgYesNo( i18n("¿ Está seguro de borrar esta "+iif(lMateria,"materia ?", "palabra clave?") + CRLF + ;
                cPrompt) )
      oTree:Del()
      oTree:UpdateTV()
      SELECT MA
      MA->(DbSkip())
      nNext := MA->(Recno())
      MA->(DbGoto(nRecno))
      FrCambiaClave( "", cPrompt, !lMateria, lMateria )
      MA->(DbDelete())
      // MA->(DbPack())
      MA->(DbGoto(nNext))
      IF MA->(EOF()) .or. nNext == nRecno
         MA->(DbGoBottom())
      ENDIF

   endif

   if oCont != nil
      RefreshCont(oCont,"MA")
   endif
   oApp():nEdit --

return nil
/*_____________________________________________________________________________*/

FUNCTION FrCambiaClave( cNew, cOld, lDelete, lMateria )
   LOCAL nAuxOrder
   LOCAL nAuxRecNo
   cOld := upper(rtrim(cOld))
   if lMateria
      Select AR
      nAuxRecno := AR->(RecNo())
      nAuxOrder := AR->(OrdNumber())
      AR->(DbSetOrder(0))
      AR->(DbGoTop())
      do while ! AR->(EoF())
         if Upper(Rtrim(AR->ArMateria)) == cOld
            Replace AR->ArMateria with cNew
         endif
         AR->(DbSkip())
      enddo
      AR->(DbSetOrder( nAuxOrder ))
      AR->(DbGoTo( nAuxRecno ))
   else
      Select AC
      nAuxRecno := AC->(RecNo())
      nAuxOrder := AC->(OrdNumber())
      AC->(DbSetOrder(0))
      AC->(DbGoTop())
      do while ! AC->(EOF())
         if Upper(Rtrim(AC->AcClave)) == cOld
            if ! lDelete
               Replace AC->AcClave with cNew
            else
               AC->(DbDelete())
            endif
         endif
         AC->(DbSkip())
      enddo
      AC->(DbSetOrder( nAuxOrder ))
      AC->(DbGoTo( nAuxRecno ))
   endif
   SELECT MA
RETURN NIL

//_____________________________________________________________________________//

FUNCTION FrMaClave( cMateria, oGet, nMode )
   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   LOCAL lReturn  := .f.
   LOCAL nRecno   := MA->( RecNo() )
   LOCAL nOrder   := MA->( OrdNumber() )
   LOCAL nArea    := Select()

   IF Empty( cMateria )
      IF nMode == 4
         RETURN .t.
      ELSE
         MsgStop("Es obligatorio rellenar este campo.")
         RETURN .f.
      ENDIF
   ENDIF

   SELECT MA
   MA->( DbSetOrder( 1 ) )
   MA->( DbGoTop() )

   IF MA->( DbSeek( UPPER( cMateria ) ) )
      DO CASE
         Case nMode == 1 .OR. nMode == 3
            lReturn := .f.
            MsgStop("Materia existente.")
         Case nMode == 2
            IF MA->( Recno() ) == nRecno
               lReturn := .t.
            ELSE
               lReturn := .f.
               MsgStop("Materia existente.")
            ENDIF
         Case nMode == 4
            lReturn := .t.
      END CASE
   ELSE
      IF nMode < 4
         lReturn := .t.
      ELSE
         IF MsgYesNo("Materia inexistente en el fichero de materias."+CRLF+"¿ Desea darla de alta ? ")
            lReturn := FrEdita( , 1, , , @cMateria )
         ELSE
            lReturn := .f.
         ENDIF
      ENDIF
   ENDIF
   IF lReturn == .f.
      oGet:cText( space(30) )
   ELSE
      oGet:cText( cMateria )
   ENDIF

   // MA->( DbSetOrder( nOrder ) )
   MA->( DbGoTo( nRecno ) )
   Select (nArea)

RETURN lReturn
//_____________________________________________________________________________//

function FrMaSeleccion( cMateria, oControl, oParent )
   local oDlg, oTree, oBtnAceptar, oBtnCancel, oB1, oB2, oB3, oB4, oB5
   local lOk    := .f.
   local nRecno := MA->( RecNo() )
   local nOrder := MA->( OrdNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local oLink

   DEFINE DIALOG oDlg RESOURCE 'DLG_TREE_AUX';
      TITLE "Selección de materias" OF oParent
   oDlg:oFont  := oApp():oFont

   SELECT MA
   MA->(DbSetOrder( 2 ) )
   MA->(DbGoTop())

   REDEFINE TREE oTree ID 110 OF oDlg  ;
      BITMAPS { "SH_MATERIA","SH_PCLAVE" }  ;
      TREE STYLE nOr( TVS_HASLINES, TVS_HASBUTTONS, WS_VSCROLL ) ;
      ON DBLCLICK oBtnAceptar:Click()  ;
      ON CHANGE ( oLink := oTree:GetLinkAt( oTree:GetCursel() ) ,;
                  MA->(DbSeek(oLink:Cargo)) )

   FrTreeLoad(oTree)

   REDEFINE BUTTON oB1     ;
      ID 410 OF oDlg       ;
      ACTION FrEdita( oTree, 1,,oDlg )

   REDEFINE BUTTON oB2     ;
      ID 411 OF oDlg       ;
      ACTION FrEdita( oTree, 2,,oDlg ) ;
      WHEN .f.

   REDEFINE BUTTON oB3     ;
      ID 412 OF oDlg       ;
      ACTION FrEdita( oTree, 3,,oDlg )

   REDEFINE BUTTON oB4     ;
      ID 413 OF oDlg       ;
      ACTION FrBorra( oTree )

   REDEFINE BUTTON oB5     ;
      ID 414 OF oDlg       ;
      ACTION FrBusca( oTree,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (oLink     := oTree:GetLinkAt(oTree:GetCursel()) ,;
              cMateria  := oLink:TreeItem:cPrompt  ,;
              lOk := .t., oDlg:End())

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .f., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      ON PAINT oDlg:Move(aPoint[1], aPoint[2],,,.t.)

   if lOK
      oControl:cText := cMateria
   endif

   MA->( DbSetOrder( nOrder ) )
   MA->( DbGoTo( nRecno ) )

   Select (nArea)

return nil
/*_____________________________________________________________________________*/

FUNCTION FrPlClave( cPlClave, oGet, nMode, lMateria, cMateria )
   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   LOCAL lReturn  := .f.
   LOCAL nRecno   := MA->( RecNo() )
   LOCAL nOrder   := MA->( OrdNumber() )
   LOCAL nArea    := Select()

   IF Empty( cMateria )
      IF nMode == 4
         RETURN .t.
      ELSE
         MsgStop("Es obligatorio rellenar este campo.")
         RETURN .f.
      ENDIF
   ENDIF

   SELECT MA
   MA->( DbSetOrder( 1 ) )
   MA->( DbGoTop() )

   IF MA->( DbSeek( UPPER( cMateria ) ) )
      DO CASE
         Case nMode == 1 .OR. nMode == 3
            lReturn := .f.
            MsgStop("Materia existente.")
         Case nMode == 2
            IF MA->( Recno() ) == nRecno
               lReturn := .t.
            ELSE
               lReturn := .f.
               MsgStop("Materia existente.")
            ENDIF
         Case nMode == 4
            lReturn := .t.
      END CASE
   ELSE
      IF nMode < 4
         lReturn := .t.
      ELSE
         IF MsgYesNo("Materia inexistente en el fichero de materias."+CRLF+"¿ Desea darla de alta ? ")
            lReturn := FrEdita( , 1, , , @cMateria )
         ELSE
            lReturn := .f.
         ENDIF
      ENDIF
   ENDIF
   IF lReturn == .f.
      oGet:cText( space(30) )
   ELSE
      oGet:cText( cMateria )
   ENDIF

   // MA->( DbSetOrder( nOrder ) )
   MA->( DbGoTo( nRecno ) )
   Select (nArea)

RETURN lReturn
/*_____________________________________________________________________________*/

function FrPlSeleccion( cPalClave, oControl, cMateria, oParent )
   local oDlg, oTree, oBtnAceptar, oBtnCancel, oB1, oB2, oB3, oB4, oB5
   local lOk    := .f.
   local nRecno := MA->( RecNo() )
   local nOrder := MA->( OrdNumber() )
   local nArea  := Select()
   local aPoint := AdjustWnd( oControl, 271*2, 150*2 )
   local oLink, oLink1, oLink2

   DEFINE DIALOG oDlg RESOURCE 'DLG_TREE_AUX';
      TITLE "Selección de palabras clave" OF oParent
   oDlg:oFont  := oApp():oFont

   SELECT MA
   MA->(DbSetOrder( 1 ) )
   MA->(DbGoTop())

   REDEFINE TREE oTree ID 110 OF oDlg  ;
      BITMAPS { "SH_MATERIA","SH_PCLAVE" }  ;
      TREE STYLE nOr( TVS_HASLINES, TVS_HASBUTTONS, WS_VSCROLL ) ;
      ON DBLCLICK oBtnAceptar:Click()  ;
      ON CHANGE ( oLink := oTree:GetLinkAt( oTree:GetCursel() ) ,;
                  MA->(DbSeek(oLink:Cargo)) )

   oLink := oTree:GetRoot()

   SELECT MA
   MA->(DbSeek(Upper(cMateria)))

   DO WHILE ! MA->(EOF()) .AND. rtrim(upper(MA->MaMateria)) == rtrim(upper(cMateria))
      if rtrim(MA->MaPClave) == ""
         oLink1 := oLink:AddLastChild(MA->MaMateria,1,1,.t.)
         oLink1:Cargo := Upper(MA->Mamateria)
      else
         oLink2 := oLink1:AddLastChild(MA->MaPClave,2,2,.t.)
         oLink2:Cargo := Upper(MA->Mamateria) + Upper(MA->MaPClave)
      endif
      MA->(DbSkip())
   ENDDO

   oTree:UpdateTV()
   oTree:SetFocus()

   REDEFINE BUTTON oB1     ;
      ID 410 OF oDlg       ;
      ACTION FrEdita( oTree, 1,,oDlg ) ;
      WHEN .f.

   REDEFINE BUTTON oB2     ;
      ID 411 OF oDlg       ;
      ACTION FrEdita( oTree, 2,,oDlg )

   REDEFINE BUTTON oB3     ;
      ID 412 OF oDlg       ;
      ACTION FrEdita( oTree, 3,,oDlg )

   REDEFINE BUTTON oB4     ;
      ID 413 OF oDlg       ;
      ACTION FrBorra( oTree )

   REDEFINE BUTTON oB5     ;
      ID 414 OF oDlg       ;
      ACTION FrBusca( oTree,,oDlg )

   REDEFINE BUTTON oBtnAceptar   ;
      ID IDOK OF oDlg            ;
      ACTION (oLink     := oTree:GetLinkAt(oTree:GetCursel())  ,;
              iif(len(oLink:cargo)<41,MsgAlert("No puede seleccionar una materia"),;
              (cPalClave := oLink:TreeItem:cPrompt, lOk := .t., oDlg:End())))

   REDEFINE BUTTON oBtnCancel    ;
      ID IDCANCEL OF oDlg        ;
      ACTION (lOk := .f., oDlg:End())

   ACTIVATE DIALOG oDlg CENTERED       ;
      ON PAINT oDlg:Move(aPoint[1], aPoint[2],,,.t.)

   if lOK
      oControl:cText := cPalClave
   endif

   MA->( DbSetOrder( nOrder ) )
   MA->( DbGoTo( nRecno ) )

   Select (nArea)

return nil
/*_____________________________________________________________________________*/

function FrBusca( oTree, cChr,oParent, xFrCargo, xFrTipo )

   local nOrder   := MA->(OrdNumber())
   local nRecno   := MA->(Recno())
   local nIndex
   local oDlg, oGet, cPicture, oLink
   local aSay1    := { "Introduzca la materia o palabra clave"  }
   local aSay2    := { "Denominación:" }
   local cGet     := space(30)
   local lSeek    := .f.
   local lFecha   := .f.
   local aBrowse  := {}

   oApp():nEdit ++

   DEFINE DIALOG oDlg RESOURCE 'DLG_BUSCAR' ;
      TITLE i18n("Búsqueda de materias y palabras clave") OF oParent
   oDlg:oFont  := oApp():oFont

   REDEFINE SAY PROMPT aSay1[nOrder] ID 20 OF oDlg
   REDEFINE SAY PROMPT aSay2[nOrder] ID 21 OF Odlg

   /*__ si he pasado un caracter lo meto en la cadena a buscar ________________*/

   if cChr != nil
      cGet := cChr+SubStr(cGet,1,len(cGet)-1)
   endif

   REDEFINE GET oGet VAR cGet PICTURE "@!" ID 101 OF oDlg

   if cChr != nil
      oGet:bGotFocus := { || ( oGet:SetColor( CLR_BLACK, RGB(255,255,127) ), oGet:SetPos(2) ) }
   endif

   REDEFINE BUTTON ID IDOK OF oDlg ;
      PROMPT i18n( "&Aceptar" )   ;
      ACTION (lSeek := .t., oDlg:End())
   REDEFINE BUTTON ID IDCANCEL OF oDlg CANCEL ;
      PROMPT i18n( "&Cancelar" )  ;
      ACTION (lSeek := .f., oDlg:End())

   sysrefresh()

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain) // , Iif(cChr!=nil,oGet:SetPos(2),), oGet:Refresh() )

   if lSeek
      cGet := rTrim( upper( cGet ) )
      MsgRun('Realizando la búsqueda...', oApp():cAppName+oApp():cVersion, ;
         { || FrWildSeek(nOrder, rtrim(upper(cGet)), aBrowse ) } )
      if len(aBrowse) == 0
         MsgStop("No se ha encontrado ninguna materia o palabra clave")
      else
         FrEncontrados(aBrowse, oApp():oDlg)
      endif
   end if
   MA->(OrdSetFocus(nOrder))
   MA->(DbGoTo(nRecno))

   // RefreshCont( oCont, "MA" )
   oTree:refresh()
   oTree:setFocus()

   oApp():nEdit--

return NIL
/*_____________________________________________________________________________*/
function FrWildSeek(nOrder, cGet, aBrowse)
   local nRecno   := MA->(Recno())
   local cOldMateria := " "

   MA->(DbGoTop())
   do while ! MA->(eof())
      // ? cOldMateria + '**' + MA->MaMateria
      if cGet $ upper(MA->MaMateria) .AND. Upper(Rtrim(MA->MaMateria)) != cOldMateria
         aadd(aBrowse, { 1, MA->MaMateria, })
         cOldMateria := Upper(Rtrim(MA->MaMateria))
      endif
      if cGet $ upper(MA->MaPClave)
         aadd(aBrowse, { 2, MA->MaMateria, MA->MaPClave })
      endif
      MA->(DbSkip())
   enddo
   MA->(DbGoTo(nRecno))
   // ASort( aBrowse,,, { |aAut1, aAut2| upper(aAut1[2]) < upper(aAut2[2]) } )
return nil
/*_____________________________________________________________________________*/
function FrEncontrados(aBrowse, oParent)
   local oDlg, oBrowse, oBtn, lOk

   DEFINE DIALOG oDlg RESOURCE "DLG_DOCUMENTOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:oFont  := oApp():oFont

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .f.)
   oBrowse:aCols[1]:AddResource("SH_MATERIA")
   oBrowse:aCols[1]:AddResource("SH_PCLAVE")
   oBrowse:aCols[1]:bBmpData:= { || aBrowse[oBrowse:nArrayAt,1] }
   oBrowse:aCols[1]:cHeader := " "
   oBrowse:aCols[1]:nWidth  := 22
   oBrowse:aCols[2]:cHeader := "Materia"
   oBrowse:aCols[2]:nWidth  := 220
   oBrowse:aCols[3]:cHeader := "Palabra Clave"
   oBrowse:aCols[3]:nWidth  := 220

   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 110 )

   aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||MA->(OrdSetFocus(1)),;
                                                           ID->(DbGoTop()),;
                                                           ID->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 2]))),;
                                                           IdEdita( , 2,, oApp():oDlg ) }} )
   oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(ID->(OrdSetFocus(1)),;
                                                     ID->(DbGoTop()),;
                                                     ID->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 2]))),;
                                                     IdEdita( , 2,, oApp():oDlg )),) }
   oBrowse:lHScroll  := .f.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtn ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg ;
      ON INIT DlgCenter(oDlg,oApp():oWndMain)

return nil
/*

   if lSeek
      cGet := rtrim(Upper(cGet))
      MA->( DbSetOrder(1) )
      MA->( DbGoTop() )
      if ! FR->(DbSeek( cGet, .t. ))
         msgAlert( i18n( "No encuentro esa denominación." ) )
         FR->(DbGoTo(nRecno))
      else
         FR->( DbSetOrder(1) )
         nIndex := FR->(OrdKeyNo())
         oTree:SetCurSel( nIndex - 1 )
         oTree:UpdateTV()
         oLink    := oTree:GetLinkAt( oTree:GetCursel() )
         xFrCargo := oLink:Cargo
         xFrTipo  := oLink:TreeItem:cPrompt
      endif
      FR->( DbSetOrder(1) )
   endif
   oApp():nEdit --
*/
return nil

/*_____________________________________________________________________________*/

function FrClave( cPrompt, oGet, nMode, lMateria, cCargo )
   // nMode    1 nuevo registro
   //          2 modificación de registro
   //          3 duplicación de registro
   //          4 clave ajena
   local lreturn  := .f.
   local nRecno   := MA->( RecNo() )
   local nOrder   := MA->( OrdNumber() )
   local nArea    := Select()
   local cClave

   if Empty( cPrompt )
      if nMode == 4
         return .t.
      else
         MsgStop("Es obligatorio rellenar este campo.")
         return .f.
      endif
   endif

   select MA
   if lMateria
      MA->(DbSetOrder(2))
      cClave := upper(cPrompt)
   else
      MA->(DbSetOrder(1))
      cClave := substr(cCargo,1,40)+cPrompt
   endif

   MA->( DbGoTop() )

   if MA->( DbSeek( UPPER( cClave ) ) )
      DO CASE
         Case nMode == 1 .OR. nMode == 3
            lreturn := .f.
            if lmateria
               MsgStop("Materia existente.")
            else
               MsgStop("Palabra clave existente.")
            endif
         Case nMode == 2
            if MA->( Recno() ) == nRecno
               lreturn := .t.
            else
               lreturn := .f.
               if lmateria
                  MsgStop("Materia existente.")
               else
                  MsgStop("Palabra clave existente.")
               endif
            endif
         Case nMode == 4
            IF ! oApp():thefull
               Registrame()
            ENDIF
            lreturn := .t.
      END CASE
   else
      if nMode < 4
         lreturn := .t.
      else
         lreturn := .f.
         if lmateria
            MsgStop("Materia inexistente.")
         else
            MsgStop("Palabra clave inexistente.")
         endif
      endif
   endif

   if lreturn == .f.
      if lmateria
         oGet:cText(space(40))
      else
         oGet:cText(space(45))
      endif
   endif

   MA->( DbSetOrder( nOrder ) )
   MA->( DbGoTo( nRecno ) )

   Select (nArea)

return lreturn
/*_____________________________________________________________________________*/

function FrEjemplares( oTree, oDlgParent )
   local oDlg, oBrowse, oCol
   local oLink       := oTree:GetLinkAt( oTree:GetCursel() )
   local cPrompt     := oLink:TreeItem:cPrompt
   local lPClave     := upper(rtrim(cPrompt)) != upper(rtrim(oLink:Cargo))
   local aBrowse     := {}

   DEFINE DIALOG oDlg RESOURCE 'DLG_DOCUMENTOS' ;
      TITLE 'Documentos de la '+iif(lPClave,'palabra clave: ','materia: ')+rtrim(cPrompt) OF oDlgParent
   oDlg:oFont  := oApp():oFont

   oApp():nEdit ++
   if lPClave
      select AR
      AR->(OrdSetFocus(1))
      SELECT AC
      AC->(DbGoTop())
      do while ! AC->(EoF())
         if Upper(Rtrim(AC->AcClave)) == upper(rtrim(cPrompt))
            SELECT AR
            AR->(DbGoTop())
            AR->(DbSeek(upper(AC->AcTitulo)))
            aadd(aBrowse, {AR->ArTitulo, AR->ArAutor, AR->ArMateria})
            select AC
         endif
         AC->(DbSkip())
      enddo
   else
      SELECT AR
      AR->(DbGoTop())
      do while ! AR->(EOF())
         if upper(rtrim(cPrompt)) == upper(rtrim(AR->ArMateria))
            aadd(aBrowse, {AR->ArTitulo, AR->ArAutor, AR->ArMateria})
         endif
         AR->(DbSkip())
      enddo
   endif
   if len(aBrowse) == 0
      MsgStop("No hay documentos de la "+iif(lPClave,"palabra clave.","materia."))
   else
      oBrowse := TXBrowse():New( oDlg )
      oBrowse:SetArray(aBrowse, .f.)
      oBrowse:aCols[1]:cHeader := "Título"
      oBrowse:aCols[2]:cHeader := "Autor"
      oBrowse:aCols[3]:cHeader := "Materia"
      oBrowse:aCols[1]:nWidth  := 220
      oBrowse:aCols[2]:nWidth  := 120
      oBrowse:aCols[3]:nWidth  := 140
      Ut_BrwRowConfig( oBrowse )

      oBrowse:CreateFromResource( 110 )

      aEval( oBrowse:aCols, { |oCol| oCol:bLDClickData := { ||AR->(OrdSetFocus(1)),;
                                                              AR->(DbGoTop()),;
                                                              AR->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1]))),;
                                                              AztArEdita( , 2,, oApp():oDlg ) }} )
      oBrowse:bKeyDown  := {|nKey| IIF(nKey==VK_RETURN,(AR->(OrdSetFocus(1)),;
                                                        AR->(DbGoTop()),;
                                                        AR->(DbSeek(upper(aBrowse[oBrowse:nArrayAt, 1]))),;
                                                        AztArEdita( , 2,, oApp():oDlg )),) }

      oBrowse:lHScroll  := .f.
      oDlg:oClient      := oBrowse
      oBrowse:nRowHeight:= 20

      REDEFINE BUTTON ID IDOK OF oDlg ;
         PROMPT i18n( "&Aceptar" )   ;
         ACTION oDlg:End()

      ACTIVATE DIALOG oDlg ;
         ON INIT DlgCenter(oDlg,oApp():oWndMain)
   endif

   SELECT MA
   oTree:Refresh()
   oTree:SetFocus(.t.)
   oApp():nEdit --

return nil

/*_____________________________________________________________________________*/

function FrImprime(oGrid, oParent)
   LOCAL nRecno   := MA->(Recno())
   LOCAl nOrder   := MA->(OrdSetFocus())
   LOCAL aCampos  := { "MaMateria","MaPClave" }
   LOCAL aTitulos := { "Materia", "Palabra clave" }
   LOCAL aWidth   := { 40, 40 }
   LOCAL aShow    := { .t., .t. }
   LOCAL aPicture := { "NO", "NO" }
   LOCAL aTotal   := { .f., .f. }
   LOCAL oInforme
   LOCAL aControls[3]
   LOCAL cMateria := space(40)

   oApp():nEdit ++
   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, "MA" )
   oInforme:Dialog()

   REDEFINE RADIO oInforme:oRadio VAR oInforme:nRadio ID 300, 301 OF oInforme:oFld:aDialogs[1]
   REDEFINE SAY aControls[1] ID 111 OF oInforme:oFld:aDialogs[1]
   REDEFINE GET aControls[2] VAR cMateria  ;
      ID 112 OF oInforme:oFld:aDialogs[1] UPDATE ;
      VALID FrMaClave( @cMateria, aControls[2], 4 )
   REDEFINE BUTTON aControls[3]              ;
      ID 113 OF oInforme:oFld:aDialogs[1]    ;
      ACTION FrMaSeleccion( cMateria, aControls[2], oInforme:oFld:aDialogs[1] )
   aControls[3]:cTooltip := "seleccionar materia"

   oInforme:Folders()

   IF oInforme:Activate()
      if oInforme:nRadio == 1
         select MA
         copy stru to matemp
         use matemp alias "MT" new
         MA->(DbGoTop())
         cMateria := " "
         do while ! MA->(eof())
            MT->(DbAppend())
            if MA->MaMateria != cMateria
               replace MT->MaMateria with MA->MaMateria
               if ! Empty(MA->MaPClave)
                  MT->(DbAppend())
                  replace MT->MaPClave with MA->MaPClave
               endif
               cMateria := MA->MaMateria
            else
               replace MT->MaPClave with MA->MaPClave
            endif
            MA->(DbSkip())
         enddo
         select MT
         DbGoTop()
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
                     oInforme:oReport:Say(1, 'Total materias + palabras clave: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
                     oInforme:oReport:EndLine() )
         oInforme:End(.t.)
         close MT
         delete file "matemp.dbf"
         select MA
      elseif oInforme:nRadio == 2
         select MA
         DbGoTop()
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            FOR upper(rtrim(MA->MaMateria)) == upper(rtrim(cMateria)) .AND. ! Empty(MA->MaPClave) ;
            ON END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(), ;
                     oInforme:oReport:Say(1, 'Palabras clave: '+Tran(oInforme:oReport:nCounter, '@E 999,999'), 1),;
                     oInforme:oReport:EndLine() )
         oInforme:End(.t.)
         select MA

      endif
   ENDIF
   MA->(DbGoTo(nRecno))
   oGrid:Refresh()
   oGrid:SetFocus( .t. )
   oApp():nEdit --

return nil
/*_____________________________________________________________________________*/


