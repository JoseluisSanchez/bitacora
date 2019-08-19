//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"
#include "Report.ch"
#include "Image.ch"
#include "vMenu.ch"

extern deleted

/*_____________________________________________________________________________*/

function Notas(cTipo)

   local oBar
   local oCol
   local oCont
   local cBitmap    := "BB_NOTAS"
   local cCaption    := ""
   local cTitle      := ""
   local cContTitle  := ""
   local cSplSize
   local cPrefix

   local cBrwState
   local nBrwSplit
   local nBrwRecno
   local nBrwOrder

   if ModalSobreFsdi()
      return nil
   end if

   if ! Db_OpenAll()
      return nil
   end if

   switch cTipo
   case "L"
      NO->( ordSetFocus( "LIBROS" ) )
      cTitle   := i18n( "Libros prestados" )
      cBitmap  := "BB_NOTAS"
      cSplSize := "102"
      cPrefix  := "NoLiAbm-"
      exit
   case "D"
      NO->( ordSetFocus( "DISCOS" ) )
      cTitle   := i18n( "Discos prestados" )
      cBitmap  := "BB_NOTAS"
      cSplSize := "102"
      cPrefix  := "NoDiAbm-"
      exit
   case "V"
      NO->( ordSetFocus( "VIDEOS" ) )
      cTitle   := i18n( "Videos prestados" )
      cBitmap  := "BB_NOTAS"
      cSplSize := "102"
      cPrefix  := "NoViAbm-"
      exit
   case "S"
      NO->( ordSetFocus( "SOFTWARE" ) )
      cTitle   := i18n( "Software prestado" )
      cBitmap  := "BB_NOTAS"
      cSplSize := "102"
      cPrefix  := "NoLiAbm-"
      exit
   endswitch
   cContTitle := cTitle+": "

   NO->( dbGoTop() )
   cBrwState := GetIni( , "Browse", cPrefix + "State", "" )
   nBrwSplit := Val( GetIni( , "Browse", cPrefix + "Split", cSplSize ) )
   nBrwRecno := Val( GetIni( , "Browse", cPrefix + "Recno", "1" ) )
   nBrwOrder := Val( GetIni( , "Browse", cPrefix + "Order", "1" ) )

   oApp():oDlg := TFsdi():New( oApp():oWndMain )
   oApp():oDlg:cTitle := i18n( "Recordatorio de Préstamos" )
   oApp():oWndMain:oClient := oApp():oDlg
   oApp():oDlg:NewGrid( nBrwSplit )

   oApp():oGrid:cAlias := "NO"

   oCol := oApp():oGrid:AddCol()
   oCol:AddResource( "16_LIBROS"   )
   oCol:AddResource( "16_DISCOS"   )
   oCol:AddResource( "16_VIDEOS"   )
   oCol:AddResource( "16_SOFTWARE" )
   oCol:cHeader       := i18n( "Tipo" )
   oCol:bBmpData      := {|| NO->noTipo }
   oCol:nWidth        := 21 //43
   oCol:nDataBmpAlign := 2

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| DToC( NO->noFecha ) }
   oCol:cHeader  := i18n( "Fch.Préstamo" )
   oCol:nWidth   := 74

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| NO->NoTitulo }
   oCol:cHeader  := i18n( "Título" )
   oCol:nWidth   := 222

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| NO->NoCodigo }
   oCol:cHeader  := i18n( "Codigo" )
   oCol:nWidth   := 70

   oCol := oApp():oGrid:AddCol()
   oCol:bStrData := {|| NO->NoAQuien }
   oCol:cHeader  := i18n( "Destinatario" )
   oCol:nWidth   := 200

   AEval( oApp():oGrid:aCols, {|oCol| oCol:bLDClickData := {|| NoDevolver( oApp():oGrid, oCont, cContTitle ) } } )

   oApp():oGrid:SetRDD()
   oApp():oGrid:CreateFromCode()

   oApp():oGrid:RestoreState( cBrwState )
   oApp():oGrid:bChange    := {|| RefreshCont( oCont, "NO", cContTitle ) }
   oApp():oGrid:bKeyDown   := {|nKey| NoTeclas( nKey, oApp():oGrid, oCont, cTipo, oApp():oDlg, cContTitle ) }
   oApp():oGrid:nRowHeight := 21 // 40

   @ 02, 05 VMENU oCont SIZE nBrwSplit-10, 190 OF oApp():oDlg ;
      color CLR_BLACK, GetSysColor(15)       ;
      HEIGHT ITEM 22 XBOX

   DEFINE TITLE OF oCont;
      CAPTION cContTitle+tran(NO->(ordKeyNo()),'@E 999,999')+" / "+tran(NO->(ordKeyCount()),'@E 999,999') ;
      HEIGHT 25;
		COLOR GetSysColor(9), oApp():nClrBar ; 	
      IMAGE "BB_NOTAS"

   DEFINE VMENUITEM OF oCont         ;
      HEIGHT 8 SEPARADOR

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Devolver")           ;
      IMAGE "16_DEVOLVER"          ;
      ACTION ( NoDevolver( oApp():oGrid, oCont, cContTitle ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Imprimir")           ;
      IMAGE "16_IMPRIMIR"          ;
      ACTION ( NoImprimir( oApp():oGrid ) ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      INSET HEIGHT 15

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Configurar rejilla") ;
      IMAGE "16_GRID"              ;
      ACTION ( Ut_BrwColConfig( oApp():oGrid, "NoAbm-State" ), oApp():oGrid:setFocus() ) ;
      LEFT 10

   DEFINE VMENUITEM OF oCont        ;
      CAPTION i18n("Salir")              ;
      IMAGE "16_SALIR"             ;
      ACTION ( oApp():oDlg:End() )       ;
      LEFT 10

   @ oApp():oDlg:nGridBottom, nBrwSplit+2 TABS oApp():oTab ;
      OPTION nBrwOrder SIZE oApp():oWndMain:nWidth()-80, 12 PIXEL OF oApp():oDlg ;
      ITEMS " "+i18n("Titulo")+" " ;
      color CLR_BLACK, GetSysColor(15) - rgb( 30, 30, 30 ) ;// 13362404
   ACTION ( NoTabs( oApp():oGrid, cTipo, oCont, cContTitle ) )

   oApp():oDlg:NewSplitter( nBrwSplit, oCont, )

   if nBrwRecno <= NO->( ordKeyCount() )
      NO->( dbGoto( nBrwRecno ) )
   end if

   ACTIVATE DIALOG oApp():oDlg NOWAIT ;
      on INIT ( ResizeWndMain(),;
      NoTabs( oApp():oGrid, oApp():oTab:nOption, oCont, cContTitle ),;
      oApp():oGrid:SetFocus() ) ;
      VALID ( oApp():oGrid:nLen := 0,;
      SetIni( , "Browse", cPrefix+"State", oApp():oGrid:SaveState() ),;
      SetIni( , "Browse", cPrefix+"Order", oApp():oTab:nOption ),;
      SetIni( , "Browse", cPrefix+"Recno", NO->( RecNo() ) ),;
      SetIni( , "Browse", cPrefix+"Split", LTrim( Str( oApp():oSplit:nleft / 2 ) ) ),;
      oCont:End(), dbCloseAll(),;
      oApp():oDlg := NIL, oApp():oGrid := NIL, oApp():oTab := NIL, oApp():oSplit := NIL, .T. )

return nil

/*_____________________________________________________________________________*/

function NoTabs( oBrw, cTipo, oCont, cContTitle )

   switch cTipo
   case "L"
      NO->(ordSetFocus("LIBROS"))
      exit
   case "D"
      NO->(ordSetFocus("DISCOS"))
      exit
   case "V"
      NO->(ordSetFocus("VIDEOS"))
      exit
   case "S"
      NO->(ordSetFocus("SOFTWARE"))
      exit
   end switch

   oBrw:refresh()
   RefreshCont( oCont, "NO", cContTitle )

return nil

/*_____________________________________________________________________________*/

function NoDevolver( oBrw, oCont, cContTitle )

   local nKey    := NO->( ordKeyNo() )
   local cAlias
   local cFieldPr
   local cFieldFc
   local cMsg

   if NoDbfVacia()
      return nil
   end if

   switch NO->NoTipo
   case 1
      cMsg := i18n("¿Desea anotar la devolución de este Libro?")
      exit
   case 2
      cMsg := i18n("¿Desea anotar la devolución de este Disco?")
      exit
   case 3
      cMsg := i18n("¿Desea anotar la devolución de este Vídeo?")
      exit
   case 4
      cMsg := i18n("¿Desea anotar la devolución de este Software?")
      exit
   end switch


   if msgYesNo( cMsg +CRLF+CRLF+ Trim( NO->NoTitulo ) )

      switch NO->NoTipo
      case 1
         cAlias   := "LI"
         cFieldPr := "LiPrestad"
         cFieldFc := "LiFechaPr"
         cMsg     := i18n( "No se encontró el Libro en el fichero de libros." )
         exit
      case 2
         cAlias   := "MU"
         cFieldPr := "MuPrestad"
         cFieldFc := "MuFchPres"
         cMsg     := i18n( "No se encontró el Disco en el fichero de discos." )
         exit
      case 3
         cAlias   := "VI"
         cFieldPr := "ViPrestad"
         cFieldFc := "ViFchPres"
         cMsg     := i18n( "No se encontró el Vídeo en el fichero de vídeos." )
         exit
      case 4
         cAlias   := "SO"
         cFieldPr := "SoPrestad"
         cFieldFc := "SoFecha"
         cMsg     := i18n( "No se encontró el Software en el fichero de software." )
         exit
      end switch

      ( cAlias )->( ordSetFocus( "codigo" ) )

      if ( cAlias )->( dbSeek( Upper( NO->NoCodigo ) ) )
         replace ( cAlias )->&cFieldPr with ""
         replace ( cAlias )->&cFieldFc with CToD( "" )
         ( cAlias )->( dbCommit() )
         NO->( dbDelete() )
         NO->( dbCommit() )
         if nKey > 1
            nKey --
         end if
      else
         msgAlert( cMsg +" "+ i18n( "Por favor, reindexe los ficheros desde el menú 'Utilidades'." ) )
      end if

   end if
   if oCont != NIL
      RefreshCont( oCont, "CL", cContTitle )
   endif
   if oBrw != NIL
      oBrw:refresh()
      oBrw:setFocus()
   endif

return nil

/*_____________________________________________________________________________*/

function NoTeclas( nKey, oBrw, oCont, cTipo, oDlg, cContTitle )

   switch nKey
   case VK_RETURN
      NoDevolver( oBrw, oCont, cContTitle )
      exit
   case VK_DELETE
      NoDevolver( oBrw, oCont, cContTitle )
      exit
   case VK_ESCAPE
      oDlg:End()
      exit
   end switch

return nil

/*_____________________________________________________________________________*/

function NoImprimir( oBrw )

   local oDlg
   local oReport
   local oRad
   local oCmbDe
   local oGetFch1
   local oGetFch2
   local aSay     := Array(02)
   local aBtn     := Array(02)

   local oFld
   local oLbx
   local oGet
   local oGet1
   local oChk
   local oSay
   local oBtnUp
   local oBtnDown


   local cPrefix  := "No-"
   local i        := 0
   local cToken   := ""
   local cCaption := i18n( "Informes de Préstamos" )
   local nDevice  := 0
   local nRptModo := 0 // 1: listado   2: justificante
   local nRec     := 0
   local nOrder   := 0

   local aDe      := {}
   local cDe      := ""
   local nDeOrd   := AG->( ordNumber() )
   local nDeRec   := AG->( RecNo() )

   local dFch1    := CToD( "" )
   local dFch2    := Date()
   local cAlias       := "NO"
   local bImprimirJustif := {|| NIL }

   //  título                campo         wd  shw  picture          tot
   //  ====================  ============  ==  ===  ===============  ===
   local aInf := { { i18n("Tipo"        ), "NOTIPO", 10, .T.,        "ARRAY1", .F. },;
      { i18n("Fch.Préstamo"), "NOFECHA",  0, .T.,            "NO", .F. },;
      { i18n("Título"      ), "NOTITULO",  0, .T.,            "NO", .F. },;
      { i18n("Código"      ), "NOCODIGO",  0, .T.,            "NO", .F. },;
      { i18n("Destinatario"), "NOAQUIEN",  0, .T.,            "NO", .F. } }
   local aCampos  := { "NOTIPO", "NOFECHA", "NOTITULO", "NOCODIGO", "NOAQUIEN" }
   local aTitulos := { "Tipo", "Fch.Préstamo", "Título", "Código", "Destinatario" }
   local aWidth   := { 10, 10, 20, 10, 10 }
   local aShow    := { .T., .T., .T., .T., .T. }
   local aPicture := { "NO01", "NO", "NO", "NO", "NO" }

   local aTotal   := { .F., .F., .F., .F., .F. }
   local oInforme

   if NoDbfVacia()
      return nil
   end if

   oApp():nEdit++

   select NO  // imprescindible

   oInforme := TInforme():New( aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias )
   oInforme:Dialog()

   // 1º pestaña: tipo de informe

   REDEFINE say aSay[01] ID 200 OF oInforme:oFld:aDialogs[1]
   REDEFINE say aSay[02] ID 201 OF oInforme:oFld:aDialogs[1]

   REDEFINE RADIO oInforme:oRadio ;
      var oInforme:nRadio ;
      ID 100, 101, 102, 103, 104, 105, 107, 110 ;
      OF oInforme:oFld:aDialogs[1]

   REDEFINE COMBOBOX oCmbDe var cDe ITEMS aDe ID 106 OF oInforme:oFld:aDialogs[1] when oInforme:nRadio == 6

   REDEFINE get oGetFch1 ;
      var dFch1 ;
      ID 108 ;
      OF oInforme:oFld:aDialogs[1] ;
      when oInforme:nRadio == 7

   REDEFINE BUTTON aBtn[01];
      ID 111;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch1, oGetFch1 ),;
      oGetFch1:setFocus(),;
      SysRefresh() ) ;
      when oInforme:nRadio == 7

   aBtn[01]:cToolTip := i18n( "selecc. fecha" )

   REDEFINE get oGetFch2 ;
      var dFch2 ;
      ID 109 ;
      OF oInforme:oFld:aDialogs[1] ;
      when oInforme:nRadio == 7

   REDEFINE BUTTON aBtn[02];
      ID 112;
      OF oInforme:oFld:aDialogs[1];
      ACTION ( SelecFecha( dFch2, oGetFch2 ),;
      oGetFch2:setFocus(),;
      SysRefresh() ) ;
      when oInforme:nRadio == 7

   aBtn[02]:cToolTip := i18n( "selecc. fecha" )

   oInforme:Folders()

   if oInforme:Activate()

      nRec   := NO->( RecNo() )
      nOrder := NO->( ordNumber() )

      do case

         // todos los préstamos, con el orden determinado
      case oInforme:nRadio == 1
         nRptModo := 1
         NO->( dbGoTop() )

         // préstamos de libros
      case oInforme:nRadio == 2
         nRptModo := 1
         NO->( ordSetFocus( "tipo" ) )
         NO->( ordScope( 0, "1" ) )
         NO->( ordScope( 1, "1" ) )
         NO->( dbGoTop() )

         // préstamos de discos
      case oInforme:nRadio == 3
         nRptModo := 1
         NO->( ordSetFocus( "tipo" ) )
         NO->( ordScope( 0, "2" ) )
         NO->( ordScope( 1, "2" ) )
         NO->( dbGoTop() )

         // préstamos de vídeos
      case oInforme:nRadio == 4
         nRptModo := 1
         NO->( ordSetFocus( "tipo" ) )
         NO->( ordScope( 0, "3" ) )
         NO->( ordScope( 1, "3" ) )
         NO->( dbGoTop() )

         // préstamos de software
      case oInforme:nRadio == 5
         nRptModo := 1
         NO->( ordSetFocus( "tipo" ) )
         NO->( ordScope( 0, "4" ) )
         NO->( ordScope( 1, "4" ) )
         NO->( dbGoTop() )

         // préstamos a un destinatario
      case oInforme:nRadio == 6
         nRptModo := 1
         NO->( ordSetFocus( "destinatario" ) )
         NO->( ordScope( 0, Upper( RTrim( cDe ) ) ) )
         NO->( ordScope( 1, Upper( RTrim( cDe ) ) ) )
         NO->( dbGoTop() )

         // préstamos realizados en un periodo
      case oInforme:nRadio == 7
         nRptModo := 1
         NO->( ordSetFocus( "fecha" ) )
         NO->( ordScope( 0, DToS( dFch1 ) ) )
         NO->( ordScope( 1, DToS( dFch2 ) ) )
         NO->( dbGoTop() )

         // justificante de préstamo del libro seleccionado
      case oInforme:nRadio == 8
         nRptModo := 2

      end case

      do case
         // listado
      case nRptModo == 1
         oInforme:Report()
         ACTIVATE REPORT oInforme:oReport ;
            on END ( oInforme:oReport:StartLine(), oInforme:oReport:EndLine(), oInforme:oReport:StartLine(),;
            oInforme:oReport:Say( 1, "Total préstamos: " + tran( oInforme:oReport:nCounter, "@E 999,999" ), 1 ),;
            oInforme:oReport:EndLine() )
         oInforme:End()
         NO->( ordScope( 0, NIL ) )
         NO->( ordScope( 1, NIL ) )
         NO->( ordSetFocus( nOrder ) )
         NO->( dbGoto( nRec ) )

         // justificante
      case nRptModo == 2

         switch NO->NoTipo
         case 1
            cAlias       := "LI"
            bImprimirJustif := {|| LiImprimirJustif() }
            exit
         case 2
            cAlias       := "MU"
            bImprimirJustif := {|| MuImprimirJustif() }
            exit
         case 3
            cAlias       := "VI"
            bImprimirJustif := {|| ViImprimirJustif() }
            exit
         case 4
            cAlias       := "SO"
            bImprimirJustif := {|| SoImprimirJustif() }
            exit
         end switch

         ( cAlias )->( ordSetFocus( "codigo" ) )
         ( cAlias )->( dbSeek( Upper( NO->NoCodigo ) ) )
         Eval( bImprimirJustif )
         oInforme:End()
         // no entiendo por qué lo tengo que poner, pero si no no funciona
         NO->( ordScope( 0, NIL ) )
         NO->( ordScope( 1, NIL ) )
         NO->( ordSetFocus( nOrder ) )
         NO->( dbGoto( nRec ) )

      end case

      oBrw:refresh()
      oBrw:setFocus()

   endif

   // PalBmpFree( hBmp )
   // hBmp := 0
   oApp():nEdit--

return nil

/*________d_____________________________________________________________________*/

function NoDbfVacia()

   local lReturn := .F.

   if NO->( ordKeyVal() ) == NIL
      msgStop( i18n( "No hay ningún préstamo registrado." ) )
      lReturn := .T.
   end if

return lReturn
