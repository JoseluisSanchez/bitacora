//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"
#include "AutoGet.ch"

extern deleted

/*_____________________________________________________________________________*/
function Autores( cTipo )

   local oBar
   local oCol
   local oCont

   local cCaption    := ""
   local cTitle      := ""
   local cContTitle
   local cBitmap     := "BB_TABLAS"
   local cSplSize    := ""
   local cPrefix     := ""
   local cHdrMateria := ""
   local cHdrEjempl  := ""
   local cTbBmpEjemp := ""
   local cTbTxtEjemp := ""

   local cBrwState   := ""
   local nBrwSplit   := 0
   local nBrwRecno   := 0
   local nBrwOrder   := 0

   if ModalSobreFsdi()
      retu nil
   endif

   if ! Db_OpenAll()
      retu nil
   endif

   switch cTipo
   case "E"
      AU->( ordSetFocus( "escritores" ) )
      cCaption    := i18n( "Gestión de Escritores" )
      cTitle      := i18n( "Escritores" )
      cSplSize    := "102"
      cPrefix     := "AuLiEsAbm-"
      cHdrMateria := i18n( "Materia" )
      cHdrEjempl  := i18n( "Nº Libros" )
      cTbBmpEjemp := "16_libros"
      cTbTxtEjemp := "Ver libros"
      cBitmap     := "BB_LAUTOR"
      exit
   case "I"
      AU->( ordSetFocus( "interpretes" ) )
      cCaption := i18n( "Gestión de Intérpretes Musicales" )
      cTitle   := i18n( "Intérpretes" )
      cSplSize := "102"
      cPrefix  := "AuMuInAbm-"
      cHdrMateria := i18n( "Género" )
      cHdrEjempl  := i18n( "Nº Discos" )
      cTbBmpEjemp := "16_discos"
      cTbTxtEjemp := "Ver discos"
      cBitmap     := "BB_MINTERP"
      exit
   case "C"
      AU->( ordSetFocus( "compositores" ) )
      cCaption := i18n( "Gestión de Compositores" )
      cTitle   := i18n( "Compositores" )
      cSplSize := "102"
      cPrefix  := "AuMuCoAbm-"
      cHdrMateria := i18n( "Género" )
      cHdrEjempl  := i18n( "Nº Discos" )
      cTbBmpEjemp := "16_discos"
      cTbTxtEjemp := "Ver discos"
      cBitmap  := "BB_MCOMPOSI"
      exit
   case "D"
      AU->( ordSetFocus( "dirmusica" ) )
      cCaption := i18n( "Gestión de Directores Musicales" )
      cTitle   := i18n( "Directores" )
      cSplSize := "102"
      cPrefix  := "AuMuDiAbm-"
      cHdrMateria := i18n( "Género" )
      cHdrEjempl  := i18n( "Nº Discos" )
      cTbBmpEjemp := "16_discos"
      cTbTxtEjemp := "Ver discos"
      cBitmap  := "BB_MDIRECC"
      exit
   case "T"
      AU->( ordSetFocus( "dircine" ) )
      cCaption := i18n( "Gestión de Directores de Cine" )
      cTitle   := i18n( "Directores" )
      cSplSize := "102"
      cPrefix  := "AuViDiAbm-"
      cHdrMateria := i18n( "Género" )
      cHdrEjempl  := i18n( "Nº Videos" )
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      cBitmap  := "BB_VDIRECC"
      exit
   case "R"
      AU->( ordSetFocus( "actores" ) )
      cCaption := i18n( "Gestión de Actores/Actrices" )
      cTitle   := i18n( "Actores/Actrices" )
      cSplSize := "102"
      cPrefix  := "AuViAcAbm-"
      cHdrMateria := i18n( "Género" )
      cHdrEjempl  := i18n( "Nº Videos" )
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      cBitmap  := "BB_VACTOR"
      exit
   case "F"
      AU->( ordSetFocus( "fotografia" ) )
      cCaption := i18n( "Gestión de Directores de Fotografía" )
      cTitle   := i18n( "Directores" )
      cSplSize := "102"
      cPrefix  := "AuViFoAbm-"
      cHdrMateria := i18n( "Materia" )
      cHdrEjempl  := i18n( "Nº Videos" )
      cTbBmpEjemp := "16_videos"
      cTbTxtEjemp := "Ver videos"
      cBitmap  := "BB_VFOTO"
      exit
   end switch

   cContTitle := cTitle+": "

   AU->( dbGoTop() )

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )
   nBrwSplit := Val( GetIni( , "Browse", cPrefix + "Split", cSplSize ) )
   nBrwRecno := Val( GetIni( , "Browse", cPrefix + "Recno", "1" ) )
   nBrwOrder := Val( GetIni( , "Browse", cPrefix + "Order", "1" ) )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Gestión de Autores" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "AU"

   ADD oCol TO oApp():oGrid DATA AU->AuNombre ;
      HEADER "Nombre"   WIDTH 180

   ADD oCol TO oApp():oGrid DATA AU->AuMateria ;
      HEADER cHdrMateria   WIDTH 180

   ADD oCol TO oApp():oGrid DATA AU->AuDirecc  ;
      HEADER "Dirección"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA AU->AuLocali  ;
      HEADER "Localidad"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA AU->AuPais ;
      HEADER "País"   WIDTH 150
   
   ADD oCol TO oApp():oGrid DATA AU->AuTelefono ;
      HEADER "Teléfono"   WIDTH 80

   ADD oCol TO oApp():oGrid DATA AU->AuEmail ;
      HEADER "E-mail"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA AU->AuURL ;
      HEADER "Sitio web"   WIDTH 150

   ADD oCol TO oApp():oGrid DATA AU->AuNotas ;
      HEADER "Notas"   WIDTH 280

   ADD oCol TO oApp():oGrid DATA AU->AuNumEjem ;
      HEADER cHdrEjempl PICTURE "@E 999,999" ;
      TOTAL 0 WIDTH 80

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| AuForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()
   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "AU", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| AuTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21
   oApp():oGrid:lFooter    := .t.
	oApp():oGrid:bClrFooter := {|| { CLR_HRED, GetSysColor(15) } }
 	oApp():oGrid:MakeTotals()


   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(AU->(ordKeyNo()),'@E 999,999')+" / "+tran(AU->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE cBitmap

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Nuevo")              ;
      IMAGE "16_nuevo"             ;
      ACTION ( AuForm( oApp():oGrid, "add", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Modificar")          ;
      IMAGE "16_modif"             ;
      ACTION ( AuForm( oApp():oGrid, "edt", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Duplicar")           ;
      IMAGE "16_duplicar"           ;
      ACTION ( AuForm( oApp():oGrid, "dup", cTipo, oCont, , cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Borrar")             ;
      IMAGE "16_borrar"            ;
      ACTION ( AuBorrar( oApp():oGrid, oCont, cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Buscar")             ;
      IMAGE "16_buscar"             ;
      ACTION ( AuBuscar( oApp():oGrid, oCont, , cTipo, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_imprimir"          ;
      ACTION ( AuImprimir( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Visitar sitio web")  ;
      IMAGE "16_internet"             ;
      ACTION ( if( !AuDbfVacia(), GoWeb( AU->auUrl ), oApp():oGrid:setFocus() ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Enviar e-mail")      ;
      IMAGE "16_email"          ;
      ACTION ( if( !AuDbfVacia(), GoMail( AU->auEmail ), oApp():oGrid:setFocus() ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont   ;
      CAPTION cTbTxtEjemp      ;
      IMAGE cTbBmpEjemp        ;
      ACTION ( AuEjemplares( oApp():oGrid, cTipo ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION "Enviar a Excel"     ;
      IMAGE "16_EXCEL"             ;
      ACTION (CursorWait(), oApp():oGrid:ToExcel(), CursorArrow());
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Configurar rejilla") ;
      IMAGE "16_grid"              ;
      ACTION ( Ut_BrwColConfig( oApp():oGrid, cPrefix + "State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_salir"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Nombre")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( AuTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont )

   //if nBrwRecno <= AU->( ordKeyCount() )
   AU->( dbGoto( nBrwRecno ) )
   //endif

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      AuTabs( oApp():oGrid, nBrwOrder, cTipo, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() )  ;
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", cPrefix + "State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", cPrefix + "Order", oApp():oTab:nOption ),;
      SetIni( , "Browse", cPrefix + "Recno", AU->( RecNo() ) ),;
      SetIni( , "Browse", cPrefix + "Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function AuForm( oBrw, cModo, cTipo, oCont, cClave, cContTitle )

   local oDlg
   local aGet        := Array(09)
   local aBtn        := Array(03)
   local aSay        := Array(01)

   local lIdOk       := .F.
   local nRecBrw     := AU->( RecNo() )
   local nRecAdd     := 0
   local cCaption    := ""
   local cTipo2      := ""
   local cSay        := ""

   local cAuNombre   := ""
   local cAuMateria  := ""
   local cAuNotas    := ""
   local cAuDirecc   := ""
   local cAuTelefon  := ""
   local cAuPais     := ""
   local cAuLocali   := ""
   local cAuEmail    := ""
   local cAuUrl      := ""

   if cModo == "edt" .OR. cModo == "dup"
      if AuDbfVacia()
         retu nil
      endif
   endif

   // evita la aparición de registro fantasma al hacer doble click en el browse
   if AU->( Eof() ) .AND. cModo != "add"
      retu nil
   endif

   oApp():nEdit++

   cModo := Lower( cModo )

   do case
      // nuevo
   case cModo == "add"
      switch cTipo
      case "E"
         cCaption := i18n("Añadir un Escritor")
         exit
      case "I"
         cCaption := i18n("Añadir un Intérprete Musical")
         exit
      case "C"
         cCaption := i18n("Añadir un Compositor Musical")
         exit
      case "D"
         cCaption := i18n("Añadir un Director Musical")
         exit
      case "T"
         cCaption := i18n("Añadir un Director de Cine")
         exit
      case "R"
         cCaption := i18n("Añadir un Actor/Actriz")
         exit
      case "F"
         cCaption := i18n("Añadir un Director de Fotografía")
         exit
      end switch
      AU->( dbAppend() )
      replace AU->AuCategor with cTipo
      if cClave != NIL
         caunombre := cClave
      else
         caunombre := Space(60)
      endif
      AU->( dbCommit() )
      nRecAdd := AU->( RecNo() )
      // modificar
   case cModo == "edt"
      switch cTipo
      case "E"
         cCaption := i18n("Modificar un Escritor")
         exit
      case "I"
         cCaption := i18n("Modificar un Intérprete Musical")
         exit
      case "C"
         cCaption := i18n("Modificar un Compositor Musical")
         exit
      case "D"
         cCaption := i18n("Modificar un Director Musical")
         exit
      case "T"
         cCaption := i18n("Modificar un Director de Cine")
         exit
      case "R"
         cCaption := i18n("Modificar un Actor/Actriz")
         exit
      case "F"
         cCaption := i18n("Modificar un Director de Fotografía")
         exit
      end switch
      caunombre  := au->aunombre
      // duplicar
   case cModo == "dup"
      switch cTipo
      case "E"
         cCaption := i18n("Duplicar un Escritor")
         exit
      case "I"
         cCaption := i18n("Duplicar un Intérprete Musical")
         exit
      case "C"
         cCaption := i18n("Duplicar un Compositor Musical")
         exit
      case "D"
         cCaption := i18n("Duplicar un Director Musical")
         exit
      case "T"
         cCaption := i18n("Duplicar un Director de Cine")
         exit
      case "R"
         cCaption := i18n("Duplicar un Actor/Actriz")
         exit
      case "F"
         cCaption := i18n("Duplicar un Director de Fotografía")
         exit
      end switch
      caunombre  := au->aunombre
   endcase

   switch cTipo
   case "E"
      cTipo2 := "L"
      cSay   := i18n( "Materia" )
      exit
   case "I"
   case "C"
   case "D"
      cTipo2 := "M"
      cSay   := i18n( "Género" )
      exit
   case "T"
   case "R"
   case "F"
      cTipo2 := "V"
      cSay   := i18n( "Materia" )
      exit
   end switch

   caumateria := au->aumateria
   caunotas   := au->aunotas
   caudirecc  := au->audirecc
   cautelefon := au->autelefono
   caulocali  := au->aulocali
   cauPais    := au->aupais
   cauemail   := au->auemail
   cauurl     := au->auurl

   DEFINE DIALOG oDlg RESOURCE "AU_FORM" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE get aGet[01] ;
      var cAuNombre ;
      ID 100 ;
      OF oDlg ;
      valid AuClave( cAuNombre, aGet[01], cModo, cTipo )

   REDEFINE say aSay[01] ID 201 OF oDlg prompt cSay

   do case
      case cTipo2=='L'   
         REDEFINE AUTOGET aGet[02] ;
            VAR cAuMateria ; 
            DATASOURCE {}						;
            FILTER MaListL( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 101 ;
            OF oDlg ;
            VALID ( MaClave( @cAuMateria, aGet[02], "aux", cTipo2 ) ) 
      case cTipo2=='M'   
         REDEFINE AUTOGET aGet[02] ;
            VAR cAuMateria ; 
            DATASOURCE {}						;
            FILTER MaListM( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 101 ;
            OF oDlg ;
            VALID ( MaClave( @cAuMateria, aGet[02], "aux", cTipo2 ) ) 
      case cTipo2=='V'   
         REDEFINE AUTOGET aGet[02] ;
            VAR cAuMateria ; 
            DATASOURCE {}						;
            FILTER MaListV( uDataSource, cData, Self );     
            HEIGHTLIST 100 ;
            ID 101 ;
            OF oDlg ;
            VALID ( MaClave( @cAuMateria, aGet[02], "aux", cTipo2 ) )
   endcase

   //REDEFINE get aGet[02] ;
   //   var cAuMateria ;
   //   ID 101 ;
   //   OF oDlg;
   //   VALID ( MaClave( @cAuMateria, aGet[02], "aux", cTipo2 ) )

   REDEFINE BUTTON aBtn[01];
      ID 110;
      OF oDlg;
      ACTION ( MaTabAux( @cAuMateria, aGet[02], cTipo2 ),;
      aGet[02]:setFocus(),;
      SysRefresh() )

   aBtn[01]:cToolTip := i18n( "selecc. materia" )

   REDEFINE get aGet[03] var cAuDirecc  ID 102 OF oDlg
   REDEFINE get aGet[04] var cAuLocali  ID 103 OF oDlg
   REDEFINE get aGet[05] var cAuPais    ID 104 OF oDlg
   REDEFINE get aGet[06] var cAuTelefon ID 105 OF oDlg

   REDEFINE get aGet[07] ;
      var cAuEmail ;
      ID 106 ;
      OF oDlg

   REDEFINE BUTTON aBtn[02];
      ID 111;
      OF oDlg;
      ACTION ( GoMail( cAuEmail ) )

   aBtn[02]:cToolTip := i18n( "enviar e-mail" )

   REDEFINE get aGet[08] ;
      var cAuUrl ;
      ID 107 ;
      OF oDlg

   REDEFINE BUTTON aBtn[03];
      ID 112;
      OF oDlg;
      ACTION ( GoWeb( cAuUrl ) )

   aBtn[03]:cToolTip := i18n( "visitar web" )

   REDEFINE get aGet[09] var cAuNotas ID 108 OF oDlg MEMO

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:end() )

   REDEFINE BUTTON ;
      ID IDCANCEL ;
      OF oDlg ;
      CANCEL ;
      ACTION ( lIdOk := .F., oDlg:end() )

   ACTIVATE DIALOG oDlg ;
      on init oDlg:Center( oApp():oWndMain )

   do case
      // nuevo
   case cModo == "add"
      // aceptar
      AU->( dbGoto( nRecAdd ) )
      if lIdOk == .T.
         replace au->aunombre   with caunombre
         replace au->aumateria  with caumateria
         replace au->aunotas    with caunotas
         replace au->audirecc   with caudirecc
         replace au->autelefono with cautelefon
         replace au->aulocali   with caulocali
         replace au->aupais     with caupais
         replace au->auemail    with cauemail
         replace au->auurl      with cauurl
         AU->( dbCommit() )
         nRecBrw := AU->( RecNo() )
         if cClave != NIL
            cClave := cAuNombre
         endif
         // cancelar
      else
         AU->( dbGoto( nRecAdd ) )
         AU->( dbDelete() )
      endif
      // modificar
   case cModo == "edt"
      // aceptar
      if lIdOk == .T.
         if AU->AuNombre != cAuNombre
            msgRun( i18n("Revisando ficheros relacionados. Espere un momento..."), oApp():cAppName,;
               {|| AuR( cAuNombre, AU->AuNombre, cTipo ) } )
         endif
         AU->( dbGoto( nRecBrw ) )
         replace AU->aunombre   with caunombre
         replace AU->aumateria  with caumateria
         replace AU->aunotas    with caunotas
         replace AU->audirecc   with caudirecc
         replace AU->autelefono with cautelefon
         replace AU->aulocali   with caulocali
         replace AU->aupais     with caupais
         replace AU->auemail    with cauemail
         replace AU->auurl      with cauurl
         AU->( dbCommit() )
      endif
      // duplicar
   case cModo == "dup"
      // aceptar
      if lIdOk == .T.
         AU->( dbAppend() )
         replace AU->AuCategor  with cTipo
         replace au->aunombre   with caunombre
         replace au->aumateria  with caumateria
         replace au->aunotas    with caunotas
         replace au->audirecc   with caudirecc
         replace au->autelefono with cautelefon
         replace au->aulocali   with caulocali
         replace au->aupais     with caupais
         replace au->auemail    with cauemail
         replace au->auurl      with cauurl
         AU->( dbCommit() )
         nRecBrw := AU->( RecNo() )
      endif
   end case
   if lIdOk == .T.
      switch cTipo
      case "E"
         oAGet():lAuLi := .T.
         exit
      case "I"
         oAGet():lAuMI := .T.
         exit
      case "C"
         oAGet():lAuMC := .T.
         exit
      case "D"
         oAGet():lAuMD := .T.
         exit
      case "T"
         oAGet():lAuVT := .T.
         exit
      case "R"
         oAGet():lAuVR := .T.
         exit
      case "F"
         oAGet():lAuVF := .T.
         exit
      end switch
      oAGet():Load()
   endif

   AU->( dbGoto( nRecBrw ) )
   if oCont != NIL
      RefreshCont( oCont, "AU", cContTitle )
   endif
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   endif

   oApp():nEdit--

return lIdOk

/*_____________________________________________________________________________*/

function AuBorrar( oBrw, oCont, cTipo, cContTitle )

   local nRecord := AU->( RecNo() )
   local nNext
   local cMsg    := ""

   if AuDbfVacia()
      return nil
   endif

   switch cTipo
   case "E"
      cMsg := i18n( "Si borra este Escritor, se borrará en todos los libros en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   case "I"
      cMsg := i18n( "Si borra este Intérprete Musical, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   case "C"
      cMsg := i18n( "Si borra este Compositor Musical, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   case "D"
      cMsg := i18n( "Si borra este Director Musical, se borrará en todos los discos en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   case "T"
      cMsg := i18n( "Si borra este Director de Cine, se borrará en todos los vídeos en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   case "R"
      cMsg := i18n( "Si borra este Actor/Actriz, se borrará en todos los vídeos en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   case "F"
      cMsg := i18n( "Si borra este Director de Fotografía, se borrará en todos los vídeos en que aparezca. ¿Está seguro de querer eliminarlo?" )
      exit
   end switch

   if msgYesNo( cMsg +CRLF+CRLF+ Trim( AU->auNombre )  )
      msgRun( i18n( "Revisando ficheros relacionados. Espere un momento..." ), oApp():cAppName,;
         {|| AuDelR( AU->AuNombre, cTipo ) } )
      AU->( dbSkip() )
      nNext := AU->( RecNo() )
      AU->( dbGoto( nRecord ) )
      AU->( dbDelete() )
      AU->( dbGoto( nNext ) )
      if AU->( Eof() ) .OR. nNext == nRecord
         AU->( dbGoBottom() )
      endif
      switch cTipo
      case "E"
         oAGet():lAuLi := .T.
         exit
      case "I"
         oAGet():lAuMI := .T.
         exit
      case "C"
         oAGet():lAuMC := .T.
         exit
      case "D"
         oAGet():lAuMD := .T.
         exit
      case "T"
         oAGet():lAuVT := .T.
         exit
      case "R"
         oAGet():lAuVR := .T.
         exit
      case "F"
         oAGet():lAuMF := .T.
         exit
      end switch
      oAGet():Load()
   endif

   if oCont != NIL
      RefreshCont( oCont, "AU", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

return nil

/*_____________________________________________________________________________*/

function AuBuscar( oBrw, oCont, cChr, cTipo, cContTitle )

   local oDlg
   local oGet

   local cPrompt  := ""
   local cField   := ""
   local cGet     := ""
   local cCaption := ""
   local cNoFind  := ""
   local nRecNo   := AU->( RecNo() )
   local lIdOk    := .F.
   local lFecha   := .F.
   local aBrowse  := {}

   if AuDbfVacia()
      return nil
   endif

   oApp():nEdit++

   switch cTipo
   case "E"
      cPrompt  := i18n( "Introduzca el Nombre del Escritor" )
      cCaption := i18n( "Búsqueda de Escritores" )
      cNoFind  := i18n( "No encuentro ese Escritor." )
      exit
   case "I"
      cPrompt  := i18n( "Introduzca el Nombre del Intérprete Musical" )
      cCaption := i18n( "Búsqueda de Intérpretes Musicales" )
      cNoFind  := i18n( "No encuentro ese Intérprete Musical." )
      exit
   case "C"
      cPrompt  := i18n( "Introduzca el Nombre del Compositor Musical" )
      cCaption := i18n( "Búsqueda de Compositores Musicales" )
      cNoFind  := i18n( "No encuentro ese Compositor Musical." )
      exit
   case "D"
      cPrompt  := i18n( "Introduzca el Nombre del Director Musical" )
      cCaption := i18n( "Búsqueda de Directores Musicales" )
      cNoFind  := i18n( "No encuentro ese Director Musical." )
      exit
   case "T"
      cPrompt  := i18n( "Introduzca el Nombre del Director de Cine" )
      cCaption := i18n( "Búsqueda de Directores de Cine" )
      cNoFind  := i18n( "No encuentro ese Director de Cine." )
      exit
   case "R"
      cPrompt  := i18n( "Introduzca el Nombre del Nombre del Actor/Actriz" )
      cCaption := i18n( "Búsqueda de Actores/Actrices" )
      cNoFind  := i18n( "No encuentro ese Actor/Actriz." )
      exit
   case "F"
      cPrompt  := i18n( "Introduzca el Nombre del Director de Fotografía" )
      cCaption := i18n( "Búsqueda de Directores de Fotografía" )
      cNoFind  := i18n( "No encuentro ese Director de Fotografía." )
      exit
   end switch

   cField  := i18n( "Nombre:" )
   cGet    := Space( 60 )

   lFecha := ValType( cGet ) == "D" // para un futuro

   DEFINE DIALOG oDlg RESOURCE "DLG_BUSCAR" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   REDEFINE say prompt cPrompt ID 20 OF oDlg
   REDEFINE say prompt cField  ID 21 OF oDlg

   if cChr != NIL
      if ! lFecha
         cGet := cChr + SubStr( cGet, 1, Len( cGet ) - 1 )
      else
         cGet := CToD( cChr + " -  -    " )
      endif
   endif

   REDEFINE get oGet var cGet ID 101 OF oDlg

   if cChr != NIL
      oGet:bGotFocus := {|| ( oGet:SetColor( CLR_BLACK, rgb( 255, 255, 127 ) ), oGet:SetPos( 2 ) ) }
   endif

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:end() )

   REDEFINE BUTTON ;
      ID IDCANCEL ;
      OF oDlg ;
      CANCEL ;
      ACTION ( lIdOk := .F., oDlg:end() )

   SysRefresh()

   ACTIVATE DIALOG oDlg ;
      on INIT ( oDlg:Center( oApp():oWndMain ) )

   if lIdOk
      if ! lFecha
         cGet := RTrim( Upper( cGet ) )
      else
         cGet := DToS( cGet )
      endif
      MsgRun('Realizando la búsqueda...', oApp():cVersion, ;
         {|| AuWildSeek(cTipo, RTrim(Upper(cGet)), aBrowse ) } )
      if Len(aBrowse) == 0
         msgStop( cNoFind )
         AU->(dbGoto(nRecno))
      else
         AuEncontrados(aBrowse, oApp():oDlg, cTipo)
      endif
   endif

   if oCont != NIL
      RefreshCont( oCont, "AU", cContTitle )
   endif
   oBrw:refresh()
   oBrw:setFocus()

   oApp():nEdit--

return nil
/*_____________________________________________________________________________*/
function AuWildSeek(cTipo, cGet, aBrowse)

   local nRecno   := AU->(RecNo())

   AU->(dbGoTop())
   do while ! AU->(Eof())
      if cGet $ Upper(AU->AuNombre)
         AAdd(aBrowse, {AU->AuNombre, AU->AuMateria, AU->(RecNo())})
      endif
      AU->(dbSkip())
   enddo

   AU->(dbGoto(nRecno))
   ASort( aBrowse,,, {|aAut1, aAut2| Upper(aAut1[1]) < Upper(aAut2[1]) } )

return nil
/*_____________________________________________________________________________*/
function AuEncontrados(aBrowse, oParent, cTipo)

   local oDlg, oBrowse, oBtnOk, oBtnCancel, lOk
   local nRecno := AU->(RecNo())

   DEFINE DIALOG oDlg RESOURCE "MA_ENCONTRADOS" ;
      TITLE i18n( "Resultado de la búsqueda" ) ;
      OF oParent
   oDlg:SetFont(oApp():oFont)

   oBrowse := TXBrowse():New( oDlg )
   oBrowse:SetArray(aBrowse, .F.)
   switch cTipo
   case "E"
      oBrowse:aCols[1]:cHeader := i18n( "Escritor" )
      oBrowse:aCols[2]:cHeader := i18n( "Materia" )
      exit
   case "I"
      oBrowse:aCols[1]:cHeader := i18n( "Intérprete" )
      oBrowse:aCols[2]:cHeader := i18n( "Género musical" )
      exit
   case "C"
      oBrowse:aCols[1]:cHeader := i18n( "Compositor" )
      oBrowse:aCols[2]:cHeader := i18n( "Género musical" )
      exit
   case "D"
      oBrowse:aCols[1]:cHeader := i18n( "Director musical" )
      oBrowse:aCols[2]:cHeader := i18n( "Género musical" )
      exit
   case "T"
      oBrowse:aCols[1]:cHeader := i18n( "Director de cine" )
      oBrowse:aCols[2]:cHeader := i18n( "Género cinematográfico" )
      exit
   case "R"
      oBrowse:aCols[1]:cHeader := i18n( "Actor / Actriz" )
      oBrowse:aCols[2]:cHeader := i18n( "Género cinematográfico" )
      exit
   case "F"
      oBrowse:aCols[1]:cHeader := i18n( "Director de fotografia" )
      oBrowse:aCols[2]:cHeader := i18n( "Género cinematográfico" )
      exit
   end switch
   oBrowse:aCols[1]:nWidth  := 260
   oBrowse:aCols[2]:nWidth  := 160
   oBrowse:aCols[3]:lHide   := .T.
   Ut_BrwRowConfig( oBrowse )

   oBrowse:CreateFromResource( 100 )
   AU->(dbSeek(Upper(aBrowse[oBrowse:nArrayAt, 1])))
   AEval( oBrowse:aCols, {|oCol| oCol:bLDClickData := {||AU->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      AuForm(oBrowse,"edt",cTipo,oDlg) }} )
   oBrowse:bKeyDown  := {|nKey| iif(nKey==VK_RETURN,(AU->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])),;
      AuForm(oBrowse,"edt",cTipo,oDlg)),) }
   oBrowse:bChange    := {|| AU->(dbGoto(aBrowse[oBrowse:nArrayAt, 3])) }
   oBrowse:lHScroll  := .F.
   oDlg:oClient      := oBrowse
   oBrowse:nRowHeight:= 20

   REDEFINE BUTTON oBtnOk ;
      ID IDOK OF oDlg   ;
      ACTION oDlg:End()

   REDEFINE BUTTON oBtnCancel ;
      ID IDCANCEL OF oDlg   ;
      ACTION (AU->(dbGoto(nRecno)), oDlg:End())

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil
/*_____________________________________________________________________________*/

function AuTabAux( cGet, oGet, cTipo, oVItem )
   local oDlg
   local oBrw
   local oCol
   local aBtn       := Array( 06 )
   local lIdOk      := .F.
   local aPoint := iif(oGet!=NIL,AdjustWnd( oGet, 271*2, 150*2 ),{1.3*oVItem:nTop(),oApp():oGrid:nLeft})
   local cCaption   := ""
   local nOrder     := AU->( ordNumber() )
   local cPrefix    := ""

   local cBrwState  := ""

   cTipo := Upper( cTipo )

   switch cTipo
   case "E"
      AU->( ordSetFocus( "escritores" ) )
      cCaption := i18n( "Selección de Escritores" )
      cPrefix  := "AuLiEsAux-"
      exit
   case "I"
      AU->( ordSetFocus( "interpretes" ) )
      cCaption := i18n( "Selección de Intérpretes Musicales" )
      cPrefix  := "AuMuInAux-"
      exit
   case "C"
      AU->( ordSetFocus( "compositores" ) )
      cCaption := i18n( "Selección de Compositores Musicales" )
      cPrefix  := "AuMuCoAux-"
      exit
   case "D"
      AU->( ordSetFocus( "dirmusica" ) )
      cCaption := i18n( "Selección de Directores Musicales" )
      cPrefix  := "AuMuDiAux-"
      exit
   case "T"
      AU->( ordSetFocus( "dircine" ) )
      cCaption := i18n( "Selección de Directores de Cine" )
      cPrefix  := "AuViDiAux-"
      exit
   case "R"
      AU->( ordSetFocus( "actores" ) )
      cCaption := i18n( "Selección de Actores/Actrices" )
      cPrefix  := "AuViAcAux-"
      exit
   case "F"
      AU->( ordSetFocus( "fotografia" ) )
      cCaption := i18n( "Selección de Directores de Fotografía" )
      cPrefix  := "AuViFoAux-"
      exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   AU->( dbGoTop() )

   DEFINE DIALOG oDlg RESOURCE "DLG_TABLA_AUX" TITLE cCaption
   oDlg:SetFont(oApp():oFont)

   oBrw := TXBrowse():New( oDlg )

   Ut_BrwRowConfig( oBrw )

   oBrw:cAlias := "AU"

   oCol := oBrw:AddCol()
   oCol:bStrData := {|| AU->auNombre }
   oCol:cHeader  := i18n( "Nombre" )
   oCol:nWidth   := 250

   AEval( oBrw:aCols, {|oCol| oCol:bLDClickData := {|| lIdOk := .T., oDlg:End() } } )

   oBrw:lHScroll := .F.
   oBrw:SetRDD()
   oBrw:CreateFromResource( 110 )

   oDlg:oClient := oBrw

   oBrw:RestoreState( cBrwState )
   oBrw:bKeyDown := {|nKey| AuTeclas( nKey, oBrw, , cTipo, , oDlg, ) }
   oBrw:nRowHeight := 20

   REDEFINE BUTTON aBtn[01] ID 410 OF oDlg ;
      ACTION ( AuForm( oBrw, "add", cTipo ) )

   REDEFINE BUTTON aBtn[02] ID 411 OF oDlg ;
      ACTION ( AuForm( oBrw, "edt", cTipo ) )

   REDEFINE BUTTON aBtn[03] ID 412 OF oDlg ;
      ACTION ( AuBorrar( oBrw, , cTipo ) )

   REDEFINE BUTTON aBtn[04] ID 413 OF oDlg ;
      ACTION ( AuBuscar( oBrw, , , cTipo ) )

   REDEFINE BUTTON aBtn[05] ID IDOK     OF oDlg ;
      ACTION ( lIdOk := .T., oDlg:End() )

   REDEFINE BUTTON aBtn[06] ID IDCANCEL OF oDlg ;
      ACTION ( lIdOk := .F., oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on PAINT ( oDlg:Move( aPoint[1], aPoint[2],,, .T. ), oBrw:setFocus() )

   if lIdOK
      cGet := AU->AuNombre
      if oget != NIL
         oGet:Refresh()
      endif
   endif

   AU->( dbSetOrder( nOrder ) )

   SetIni( , "Browse", cPrefix + "State", oBrw:SaveState()    )

return nil
/*_____________________________________________________________________________*/

function AuR( cVar, cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // escritores
   case "E"

      // libros: autor
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiAutor ) ) == RTrim( Upper( cOld ) )
            replace LI->LiAutor with cVar
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )
      exit

      // intérpretes musicales
   case "I"

      // discos: intérprete
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuAutor ) ) == RTrim( Upper( cOld ) )
            replace MU->MuAutor with cVar
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // canciones de discos: intérprete
      nOrder := CD->( ordNumber() )
      nRecNo := CD->( RecNo()     )
      CD->( dbSetOrder( 0 ) )
      CD->( dbGoTop() )
      while ! CD->( Eof() )
         if RTrim( Upper( CD->CdMuInterp ) ) == RTrim( Upper( cOld ) )
            replace CD->CdMuInterp with cVar
            CD->( dbCommit() )
         endif
         CD->( dbSkip() )
      end while
      CD->( dbSetOrder( nOrder ) )
      CD->( dbGoto( nRecNo )     )

      // vídeos: bso autor/director
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViBsoAut ) ) == RTrim( Upper( cOld ) )
            replace VI->ViBsoAut with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // compositores musicales
   case "C"

      // discos: compositor
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuAutor2 ) ) == RTrim( Upper( cOld ) )
            replace MU->MuAutor2 with cVar
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // canciones: compositor
      nOrder := CN->( ordNumber() )
      nRecNo := CN->( RecNo()     )
      CN->( dbSetOrder( 0 ) )
      CN->( dbGoTop() )
      while ! CN->( Eof() )
         if RTrim( Upper( CN->CaAutor ) ) == RTrim( Upper( cOld ) )
            replace CN->CaAutor with cVar
            CN->( dbCommit() )
         endif
         CN->( dbSkip() )
      end while
      CN->( dbSetOrder( nOrder ) )
      CN->( dbGoto( nRecNo )     )

      // canciones de discos: compositor
      nOrder := CD->( ordNumber() )
      nRecNo := CD->( RecNo()     )
      CD->( dbSetOrder( 0 ) )
      CD->( dbGoTop() )
      while ! CD->( Eof() )
         if RTrim( Upper( CD->CdCaAutor ) ) == RTrim( Upper( cOld ) )
            replace CD->CdCaAutor with cVar
            CN->( dbCommit() )
         endif
         CD->( dbSkip() )
      end while
      CD->( dbSetOrder( nOrder ) )
      CD->( dbGoto( nRecNo )     )
      exit

      // directores musicales
   case "D"

      // discos: director
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuDirector ) ) == RTrim( Upper( cOld ) )
            replace MU->MuDirector with cVar
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )
      exit

      // directores de cine
   case "T"

      // vídeos: director
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViDirector ) ) == RTrim( Upper( cOld ) )
            replace VI->ViDirector with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // actores / atrices
   case "R"

      // vídeos: actor
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViActor ) ) == RTrim( Upper( cOld ) )
            replace VI->ViActor with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // vídeos: actriz
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViActriz ) ) == RTrim( Upper( cOld ) )
            replace VI->ViActriz with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // directores de fotografía
   case "F"

      // vídeos: director de fotografía
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViFotogra ) ) == RTrim( Upper( cOld ) )
            replace VI->ViFotogra with cVar
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function AuDelR( cOld, cTipo )

   local nOrder := 0
   local nRecNo := 0

   switch cTipo

      // escritores
   case "E"

      // libros: autor
      nOrder := LI->( ordNumber() )
      nRecNo := LI->( RecNo()     )
      LI->( dbSetOrder( 0 ) )
      LI->( dbGoTop() )
      while ! LI->( Eof() )
         if RTrim( Upper( LI->LiAutor ) ) == RTrim( Upper( cOld ) )
            replace LI->LiAutor with Space( 38 )
            LI->( dbCommit() )
         endif
         LI->( dbSkip() )
      end while
      LI->( dbSetOrder( nOrder ) )
      LI->( dbGoto( nRecNo )     )
      exit

      // intérpretes musicales
   case "I"

      // discos: intérprete
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuAutor ) ) == RTrim( Upper( cOld ) )
            replace MU->MuAutor with Space( 40 )
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // canciones de discos: intérprete
      nOrder := CD->( ordNumber() )
      nRecNo := CD->( RecNo()     )
      CD->( dbSetOrder( 0 ) )
      CD->( dbGoTop() )
      while ! CD->( Eof() )
         if RTrim( Upper( CD->CdMuInterp ) ) == RTrim( Upper( cOld ) )
            replace CD->CdMuInterp with Space( 40 )
            CD->( dbCommit() )
         endif
         CD->( dbSkip() )
      end while
      CD->( dbSetOrder( nOrder ) )
      CD->( dbGoto( nRecNo )     )

      // vídeos: bso autor/director
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViBsoAut ) ) == RTrim( Upper( cOld ) )
            replace VI->ViBsoAut with Space( 30 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // compositores musicales
   case "C"

      // discos: compositor
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuAutor2 ) ) == RTrim( Upper( cOld ) )
            replace MU->MuAutor2 with Space( 40 )
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )

      // canciones: compositor
      nOrder := CN->( ordNumber() )
      nRecNo := CN->( RecNo()     )
      CN->( dbSetOrder( 0 ) )
      CN->( dbGoTop() )
      while ! CN->( Eof() )
         if RTrim( Upper( CN->CaAutor ) ) == RTrim( Upper( cOld ) )
            replace CN->CaAutor with Space( 40 )
            CN->( dbCommit() )
         endif
         CN->( dbSkip() )
      end while
      CN->( dbSetOrder( nOrder ) )
      CN->( dbGoto( nRecNo )     )

      // canciones de discos: compositor
      nOrder := CD->( ordNumber() )
      nRecNo := CD->( RecNo()     )
      CD->( dbSetOrder( 0 ) )
      CD->( dbGoTop() )
      while ! CD->( Eof() )
         if RTrim( Upper( CD->CdCaAutor ) ) == RTrim( Upper( cOld ) )
            replace CD->CdCaAutor with Space( 40 )
            CN->( dbCommit() )
         endif
         CD->( dbSkip() )
      end while
      CD->( dbSetOrder( nOrder ) )
      CD->( dbGoto( nRecNo )     )
      exit

      // directores musicales
   case "D"

      // discos: director
      nOrder := MU->( ordNumber() )
      nRecNo := MU->( RecNo()     )
      MU->( dbSetOrder( 0 ) )
      MU->( dbGoTop() )
      while ! MU->( Eof() )
         if RTrim( Upper( MU->MuDirector ) ) == RTrim( Upper( cOld ) )
            replace MU->MuDirector with Space( 40 )
            MU->( dbCommit() )
         endif
         MU->( dbSkip() )
      end while
      MU->( dbSetOrder( nOrder ) )
      MU->( dbGoto( nRecNo )     )
      exit

      // directores de cine
   case "T"

      // vídeos: director
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViDirector ) ) == RTrim( Upper( cOld ) )
            replace VI->ViDirector with Space( 30 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // actores / atrices
   case "R"

      // vídeos: actor
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViActor ) ) == RTrim( Upper( cOld ) )
            replace VI->ViActor with Space( 30 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )

      // vídeos: actriz
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViActriz ) ) == RTrim( Upper( cOld ) )
            replace VI->ViActriz with Space( 30 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

      // directores de fotografía
   case "F"

      // vídeos: director de fotografía
      nOrder := VI->( ordNumber() )
      nRecNo := VI->( RecNo()     )
      VI->( dbSetOrder( 0 ) )
      VI->( dbGoTop() )
      while ! VI->( Eof() )
         if RTrim( Upper( VI->ViFotogra ) ) == RTrim( Upper( cOld ) )
            replace VI->ViFotogra with Space( 30 )
            VI->( dbCommit() )
         endif
         VI->( dbSkip() )
      end while
      VI->( dbSetOrder( nOrder ) )
      VI->( dbGoto( nRecNo )     )
      exit

   end switch

return nil

/*_____________________________________________________________________________*/

function AuClave( cClave, oGet, cModo, cTipo )

   // cModo    'add': nuevo registro
   //          'edt': modificación de registro
   //          'dup': duplicado de registro
   //          'aux': tabla auxiliar (clave ajena)

   local cAlias  := "AU"
   local cMsgSi  := ""
   local cMsgNo  := ""
   local nPkOrd  := 0

   local lReturn := .F.
   local nRecno  := ( cAlias )->( RecNo() )
   local nOrder  := ( cAlias )->( ordNumber() )

   switch cTipo
   case "E"
      cMsgSi := i18n( "Escritor ya registrado." )
      cMsgNo := i18n( "Escritor no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 1
      exit
   case "I"
      cMsgSi := i18n( "Intérprete Musical ya registrado."   )
      cMsgNo := i18n( "Intérprete Musical no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 3
      exit
   case "C"
      cMsgSi := i18n( "Compositor Musical ya registrado."   )
      cMsgNo := i18n( "Compositor Musical no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 5
      exit
   case "D"
      cMsgSi := i18n( "Director Musical ya registrado."   )
      cMsgNo := i18n( "Director Musical no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 7
      exit
   case "T"
      cMsgSi := i18n( "Director de Cine ya registrado."   )
      cMsgNo := i18n( "Director de Cine no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 9
      exit
   case "R"
      cMsgSi := i18n( "Actor/Actriz ya registrado."   )
      cMsgNo := i18n( "Actor/Actriz no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 11
      exit
   case "F"
      cMsgSi := i18n( "Director de Fotografía ya registrado."   )
      cMsgNo := i18n( "Director de Fotografía no registrado." ) +CRLF+CRLF+ i18n("¿Desea darlo de alta ahora?")
      nPkOrd := 13
      exit
   end switch

   if Empty( cClave )
      if cModo == "aux"
         return .T.
      else
         msgStop( i18n( "Es obligatorio rellenar este campo." ) )
         return .F.
      endif
   endif

   ( cAlias )->( dbSetOrder( nPkOrd ) )
   ( cAlias )->( dbGoTop() )

   if ( cAlias )->( dbSeek( Upper( cClave ) ) )
      do case
      case cModo == "add" .OR. cModo == "dup"
         lReturn := .F.
         msgStop( cMsgSi )
      case cModo == "edt"
         if ( cAlias )->( RecNo() ) == nRecno
            lReturn := .T.
         else
            lReturn := .F.
            MsgStop( cMsgSi )
         endif
      case cModo == "aux"
         IF ! oApp():thefull
            Registrame()
         ENDIF
         lReturn := .T.
      end case
   else
      do case
      case cModo == "add" .OR. cModo == "edt" .OR. cModo == "dup"
         lReturn := .T.
      case cModo == "aux"
         if msgYesNo( cMsgNo )
            lReturn := AuForm( , "add", cTipo, , @cClave )
            oGet:Refresh()
         else
            lReturn := .F.
         endif
      end case
   endif

   ( cAlias )->( dbSetOrder( nOrder ) )
   ( cAlias )->( dbGoto( nRecno ) )

return lReturn

/*_____________________________________________________________________________*/

function AuTeclas( nKey, oBrw, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_INSERT
      AuForm( oBrw, "add", cTipo, oCont, , cContTitle )
      exit
   case VK_RETURN
      AuForm( oBrw, "edt", cTipo, oCont, , cContTitle )
      exit
   case VK_DELETE
      AuBorrar( oBrw, oCont, cTipo, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   otherwise
      if nKey >= 97 .AND. nKey <= 122
         nKey := nKey - 32
      endif
      if nKey >= 65 .AND. nKey <= 90
         AuBuscar( oBrw, oCont, Chr( nKey ), cTipo, cContTitle )
      endif
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function AuTabs( oBrw, nOpc, cTipo, oCont, cContTitle )

   switch cTipo
   case "E"
      switch nOpc
      case 1
         AU->( ordSetFocus( "escritores" ) )
         exit
      end switch
      exit
   case "I"
      switch nOpc
      case 1
         AU->( ordSetFocus( "interpretes" ) )
         exit
      end switch
      exit
   case "C"
      switch nOpc
      case 1
         AU->( ordSetFocus( "compositores" ) )
         exit
      end switch
      exit
   case "D"
      switch nOpc
      case 1
         AU->( ordSetFocus( "dirmusica" ) )
         exit
      end switch
      exit
   case "T"
      switch nOpc
      case 1
         AU->( ordSetFocus( "dircine" ) )
         exit
      end switch
      exit
   case "R"
      switch nOpc
      case 1
         AU->( ordSetFocus( "actores" ) )
         exit
      end switch
      exit
   case "F"
      switch nOpc
      case 1
         AU->( ordSetFocus( "fotografia" ) )
         exit
      end switch
      exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "AU", cContTitle )

return nil
/*_____________________________________________________________________________*/

function AuEjemplares( oBrw, cTipo )

   local oDlg
   local oBrwEj
   local oBrwEjCol
   local oBtn

   local cCaption   := ""
   local cAlias     := ""
   local cAutor     := AU->AuNombre
   local bLDClick   := {|| NIL }
   local cPrefix    := ""
   local cOrdName   := ""

   local cBrwState  := ""

   if AuDbfVacia()
      return nil
   end if

   oApp():nEdit++

   switch cTipo
   case "E"
      // escritores de libros
      cCaption  := i18n( "Libros de" ) + " " + cAutor
      cAlias    := "LI"
      cPrefix   := "AuExtEjLi-"
      bLDClick  := {|| LiForm( oBrwEj, "edt" ) }
      cOrdName  := "AUTOR"
      exit
   case "I"
      // intérpretes musicales
      cCaption  := i18n( "Discos de" ) + " " + cAutor
      cAlias    := "MU"
      cPrefix   := "AUExtEjMuIn-"
      bLDClick  := {|| MuForm( oBrwEj, "edt" ) }
      cOrdName  := "INTERPRETE"
      exit
   case "C"
      // compositores musicales
      cCaption  := i18n( "Discos de" ) + " " + cAutor
      cAlias    := "MU"
      cPrefix   := "MaExtEjMuCo-"
      bLDClick  := {|| MuForm( oBrwEj, "edt" ) }
      cOrdName  := "COMPOSITOR"
      exit
   case "D"
      // directores musicales
      cCaption  := i18n( "Discos de" ) + " " + cAutor
      cAlias    := "MU"
      cPrefix   := "MaExtEjMuDi-"
      bLDClick  := {|| MuForm( oBrwEj, "edt" ) }
      cOrdName  := "DIRECTOR"
      exit
   case "R"
      // actores y actrices
      cCaption  := i18n( "Vídeos de" ) + " " + cAutor
      cAlias    := "VI"
      cPrefix   := "MaExtEjAcVi-"
      bLDClick  := {|| ViForm( oBrwEj, "edt" ) }
      cOrdName  := "ACTOR"
      exit
   case "T"
      // directores de cine
      cCaption  := i18n( "Vídeos de" ) + " " + cAutor
      cAlias    := "VI"
      cPrefix   := "MaExtEjCiVi-"
      bLDClick  := {|| ViForm( oBrwEj, "edt" ) }
      cOrdName  := "DIRECTOR"
      exit
   case "F"
      // director de fotografía
      cCaption  := i18n( "Vídeos de" ) + " " + cAutor
      cAlias    := "VI"
      cPrefix   := "MaExtEjFoVi-"
      bLDClick  := {|| ViForm( oBrwEj, "edt" ) }
      cOrdName  := "FOTOGRAFIA"
      exit
   case "S"
      cCaption  := i18n( "Software de" ) + " " + cAutor
      cAlias    := "SO"
      cPrefix   := "MaExtEjSo-"
      bLDClick  := {|| SoForm( oBrwEj, "edt" ) }
      exit
   //case "I"
   //   cCaption  := i18n( "Direcciones de Internet de" ) + " " + cAutor
   //   cAlias    := "IN"
   //   cPrefix   := "MaExtEjIn-"
   //   bLDClick  := {|| InForm( oBrwEj, "edt" ) }
   //   exit
   end switch

   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )

   DEFINE DIALOG oDlg OF oApp():oDlg RESOURCE "MA_EJEMPLARES" TITLE cCaption
   oDlg:SetFont(oApp():oFont)
   oBrwEj := TXBrowse():New( oDlg )
   Ut_BrwRowConfig( oBrwEj )
   oBrwEj:cAlias := cAlias

   // browse: columnas
   switch cTipo
      // libros
   case "E"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| LI->LiCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| LI->LiTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| LI->LiAutor }
      oBrwEjCol:cHeader  := i18n( "Autor" )
      oBrwEjCol:nWidth   := 115
      exit

      // intérpretes musicales
   case "I"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuAutor }
      oBrwEjCol:cHeader  := i18n( "Intérprete" )
      oBrwEjCol:nWidth   := 115
      exit
      // compositores musicales
   case "C"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| MU->MuAutor }
      oBrwEjCol:cHeader  := i18n( "Intérprete" )
      oBrwEjCol:nWidth   := 115
      exit
      // vídeos
   case "R"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViNumero }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViDirector }
      oBrwEjCol:cHeader  := i18n( "Director" )
      oBrwEjCol:nWidth   := 120
      exit
   case "T"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViNumero }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViActor }
      oBrwEjCol:cHeader  := i18n( "Actor" )
      oBrwEjCol:nWidth   := 120
      exit
   case "F"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViNumero }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViTitulo }
      oBrwEjCol:cHeader  := i18n( "Título" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| VI->ViDirector }
      oBrwEjCol:cHeader  := i18n( "Director" )
      oBrwEjCol:nWidth   := 120
      exit
      // software
   case "S"
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| SO->SoCodigo }
      oBrwEjCol:cHeader  := i18n( "Código" )
      oBrwEjCol:nWidth   := 70
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| SO->SoTitulo }
      oBrwEjCol:cHeader  := i18n( "Nombre" )
      oBrwEjCol:nWidth   := 175
      oBrwEjCol := oBrwEj:AddCol()
      oBrwEjCol:bStrData := {|| SO->SoNumSer }
      oBrwEjCol:cHeader  := i18n( "Nº Serie" )
      oBrwEjCol:nWidth   := 110
      exit
      // internet
   //case "I"
   //   oBrwEjCol := oBrwEj:AddCol()
   //   oBrwEjCol:bStrData := {|| IN->InCodigo }
   //   oBrwEjCol:cHeader  := i18n( "Código" )
   //   oBrwEjCol:nWidth   := 70
   //   oBrwEjCol := oBrwEj:AddCol()
   //   oBrwEjCol:bStrData := {|| IN->InNombre }
   //   oBrwEjCol:cHeader  := i18n( "Título" )
   //   oBrwEjCol:nWidth   := 100
   //   oBrwEjCol := oBrwEj:AddCol()
   //   oBrwEjCol:bStrData := {|| IN->InDirecc }
   //   oBrwEjCol:cHeader  := i18n( "Dirección" )
   //   oBrwEjCol:nWidth   := 100
   //   oBrwEjCol := oBrwEj:AddCol()
   //   oBrwEjCol:bStrData := {|| IN->InServic }
   //   oBrwEjCol:cHeader  := i18n( "Servicio" )
   //   oBrwEjCol:nWidth   := 90
   //   exit

   end switch

   // browse: configuración
   AEval( oBrwEj:aCols, {|oCol| oCol:bLDClickData := {|| Eval( bLDClick ) } } )
   oBrwEj:lHScroll := .F.
   oBrwEj:SetRDD()
   oBrwEj:CreateFromResource( 100 )
   oDlg:oClient    := oBrwEj
   oBrwEj:RestoreState( cBrwState )
   oBrwEj:nRowHeight := 20

   ( cAlias )->( ordSetFocus( cOrdName ) )
   ( cAlias )->( ordScope( 0, Upper( cAutor ) ) )
   ( cAlias )->( ordScope( 1, Upper( cAutor ) ) )
   ( cAlias )->( dbGoTop() )

   REDEFINE BUTTON oBtn ID IDOK OF oDlg ;
      ACTION ( oDlg:End() )

   ACTIVATE DIALOG oDlg ;
      on INIT ( oDlg:Center( oApp():oWndMain ),;
      oBrwEj:Refresh(), oBrwEj:SetFocus() )

   ( cAlias )->( ordScope( 0, NIL ) )
   ( cAlias )->( ordScope( 1, NIL ) )
   ( cAlias )->( dbGoTop() )

   SetIni( , "Browse", cPrefix + "State", oBrwEj:SaveState() )

   oBrw:setFocus()

   oApp():nEdit--

return nil

/*_____________________________________________________________________________*/

function AuImprimir( oBrw, cTipo )

   //  título             campo         wd  shw  picture          tot
   //  =================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Nombre"   ), "AUNOMBRE",  0, .T.,            "NO", .F. },;
      { i18n("Materia"  ), "AUMATERIA",  0, .T.,            "NO", .F. },;
      { i18n("Dirección"), "AUDIRECC",  0, .T.,            "NO", .F. },;
      { i18n("Localidad"), "AULOCALI",  0, .T.,            "NO", .F. },;
      { i18n("País"     ), "AUPAIS",  0, .T.,            "NO", .F. },;
      { i18n("Teléfono" ), "AUTELEFONO",  0, .T.,            "NO", .F. },;
      { i18n("E-mail"   ), "AUEMAIL",  0, .T.,            "NO", .F. },;
      { i18n("Sitio web"), "AUURL",  0, .T.,            "NO", .F. },;
      { i18n("Notas"    ), "AUNOTAS", 40, .T.,            "NO", .F. } }
   local nRecno   := AU->(RecNo())
   local nOrder   := AU->(ordSetFocus())
   local aCampos  := { "AUNOMBRE", "AUMATERIA", "AUDIRECC", "AULOCALI", "AUPAIS", "AUTELEFONO", "AUEMAIL", "AUURL", "AUNUMEJEM" }
   local aTitulos := { "Nombre", "Materia", "Dirección", "Localidad", "Pais", "Teléfono", "E-mail", "Sitio web", "" }
   local aWidth   := { 20, 20, 20, 20, 10, 20, 20, 20, 20 }
   local aShow    := { .T., .T., .T., .T., .T., .T., .T., .T., .T. }
   local aPicture := { "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO", "NO" }
   local aTotal   := { .F., .F., .F., .F., .F., .F., .F., .F.,.T. }
   local oInforme
   local nAt
   local cAlias
   local cTotal

   if AuDbfVacia()
      retu nil
   endif

   oApp():nEdit++

   switch cTipo
   case "E"
      cAlias   := "AULI"
      cTotal   := "Total escritores:"
      aTitulos[9] := "Nº Libros"
      exit
   case "I"
      cAlias   := "AUMI"
      cTotal   := "Total intérpretes musicales:"
      aTitulos[2] := "Género"
      aTitulos[9] := "Nº Discos"
      exit
   case "C"
      cAlias   := "AUMC"
      cTotal   := "Total compositores:"
      aTitulos[2] := "Género"
      aTitulos[9] := "Nº Discos"
      exit
   case "D"
      cAlias   := "AUMD"
      cTotal   := "Total directores musicales:"
      aTitulos[2] := "Género"
      aTitulos[9] := "Nº Discos"
      exit
   case "T"
      cAlias   := "AUVD"
      cTotal   := "Total directores de cine:"
      aTitulos[2] := "Género"
      aTitulos[9] := "Nº Videos"
      exit
   case "R"
      cAlias   := "AUVA"
      cTotal   := "Total actores/actrices:"
      aTitulos[2] := "Género"
      aTitulos[9] := "Nº Videos"
      exit
   case "F"
      cAlias   := "AUVF"
      cTotal   := "Total directores de fotografía:"
      aTitulos[2] := "Género"
      aTitulos[9] := "Nº Videos"
      exit
   end switch

   select AU  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()
   REDEFINE RADIO oInforme:oRadio var oInforme:nRadio ID 100 OF oInforme:oFld:aDialogs[1]

   oInforme:Folders()
   if oInforme:Activate()
      select AU
      if oInforme:nRadio == 1
         AU->(dbGoTop())
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
            oInforme:oReport:Say( 1, cTotal + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
            oInforme:oReport:EndLine() )
         oInforme:End(.T.)
      endif
      AU->(dbSetOrder(nOrder))
      AU->(dbGoto(nRecno))
   endif
   oBrw:Refresh()
   oBrw:SetFocus( .T. )
   oApp():nEdit --

return nil

/*_____________________________________________________________________________*/

function AuDbfVacia()

   local lReturn := .F.

   if AU->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún registro." ) )
      lReturn := .T.
   endif

return lReturn
/*_____________________________________________________________________________*/

function AuListE( aList, cData, oSelf )
   local aNewList := {}
   AU->( dbSetOrder(1) )
   AU->( dbGoTop() )
   aNewList := AuListAll(cData)
return aNewList
function AuListI( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AU->( dbSetOrder(3) )
   AU->( dbGoTop() )
   aNewList := AuListAll(cData)
return aNewList
function AuListC( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AU->( dbSetOrder(5) )
   AU->( dbGoTop() )
   aNewList := AuListAll(cData)
return aNewList
function AuListD( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AU->( dbSetOrder(7) )
   AU->( dbGoTop() )
   aNewList := AuListAll(cData)
return aNewList
function AuListT( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AU->( dbSetOrder(9) )
   AU->( dbGoTop() )
   aNewList := AuListAll(cData)
return aNewList
function AuListR( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AU->( dbSetOrder(11) )
   AU->( dbGoTop() )
   aNewList := AuListAll(cData)
return aNewList
function AuListF( aList, cData, oSelf )
   local aNewList := {}
   local nPkOrd
   AU->( dbSetOrder(13) )
   AU->( dbGoTop() )
   aNewList := AuListAll(cData)
return aNewList

Function AuListAll(cData)
   local aList := {}
   while ! AU->(Eof())
      if at(Upper(cdata), Upper(AU->AuNombre)) != 0 // UPPER( SubStr( oApp():amaterias[i,1], 1, Len( cData ) ) ) == UPPER( cData )
         AAdd( aList, { AU->AuNombre } )
      endif 
      AU->(DbSkip())
   enddo
return alist

function AuList()
retu NIL