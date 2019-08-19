#include "FiveWin.ch"
#include "Report.ch"

CLASS TInforme
   DATA aCampos, aTitulos, aWidth, aShow, aPicture, aTotal  AS ARRAY
   DATA hBmp
   DATA cReport, cRptFont           //AS STRING
   DATA nRadio                      AS NUMERIC
   DATA nPrevRadio                  AS NUMERIC
   DATA cTitulo1, cTitulo2, cTitulo3, cAlias  //AS STRING
   DATA cDlgTitle

   DATA aArray, aoFont, aoSizes, aoEstilo, acSizes, acEstilo, acFont, aSizes, aEstilo, aFont AS ARRAY
   DATA nDevice                     AS NUMERIC
   DATA oDlg, oFld, oRadio, oLbx, oGet, oSay, oCheck, oGet1, oGet2, oGet3  AS OBJECT
   DATA oBtnUp, oBtnDown, oBtnShow, oBtnHide, oFont1, oFont2, oFont3 AS OBJECT
   DATA oReport AS OBJECT
   DATA lSummary
	DATA cPdfFile

   METHOD New(aCampos, aTitulos, aWidth, aShow, aPicture, aTotal)    CONSTRUCTOR
   METHOD Dialog()
   METHOD Folders()
	METHOD Change()
	METHOD Load()
	METHOD Save()
   METHOD Activate()
   METHOD Report()
   METHOD ReportEnd()
   METHOD End()
ENDCLASS
//______________________________________________________________________________________//
METHOD New(aCampos, aTitulos, aWidth, aShow, aPicture, aTotal, cAlias) CLASS TInforme
   LOCAL i, cToken

   ::aCampos   := aCampos
   ::aTitulos  := aTitulos
   ::aWidth    := aWidth
   ::aShow     := aShow
   ::aPicture  := aPicture
   ::aTotal    := aTotal
   ::cAlias    := cAlias
   ::nRadio    := VAL(GetPvProfString("Report", ::cAlias+"Radio",1,oApp():cIniFile))
	::nPrevRadio:= ::nRadio

	::Load()
   do case
      case ::cAlias == "IN"
         ::cDlgTitle := "Informes de direcciones de internet"
      case ::cAlias == "CO"
         ::cDlgTitle := "Informes de colecciones"
      case ::cAlias == "CA"
         ::cDlgTitle := "Informes de categorías de ocio"
      case ::cAlias == "ID"
         ::cDlgTitle := "Informes de idiomas"
      case ::cAlias == "CLLI"
         ::cDlgTitle := "Informes de colecciones de libros"
      case ::cAlias == "CLDI"
         ::cDlgTitle := "Informes de colecciones de discos"
      case ::cAlias == "CLVI"
         ::cDlgTitle := "Informes de colecciones de videos"
      case ::cAlias == "EDLI"
         ::cDlgTitle := "Informes de editores de libros"
      case ::cAlias == "EDDI"
         ::cDlgTitle := "Informes de productoras de discos"
      case ::cAlias == "EDVI"
         ::cDlgTitle := "Informes de productoras de videos"
      case ::cAlias == "EDSO"
         ::cDlgTitle := "Informes de compañías de software"
      case ::cAlias == "AULI"
         ::cDlgTitle := "Informes de escritores"
      case ::cAlias == "AUMI"
         ::cDlgTitle := "Informes de intérpretes musicales"
      case ::cAlias == "AUMC"
         ::cDlgTitle := "Informes de compositores"
      case ::cAlias == "AUMD"
         ::cDlgTitle := "Informes de directores musicales"
      case ::cAlias == "AUVD"
         ::cDlgTitle := "Informes de directores de cine"
      case ::cAlias == "AUVA"
         ::cDlgTitle := "Informes de actores/actrices"
      case ::cAlias == "AUVF"
         ::cDlgTitle := "Informes de directores de fotografía"
      case ::cAlias == "UBLI"
         ::cDlgTitle := "Informes de ubicaciones de libros"
      case ::cAlias == "UBDI"
         ::cDlgTitle := "Informes de ubicaciones de discos"
      case ::cAlias == "UBVI"
         ::cDlgTitle := "Informes de ubicaciones de videos"
      case ::cAlias == "UBSO"
         ::cDlgTitle := "Informes de ubicaciones de software"
      case ::cAlias == "MALI"
         ::cDlgTitle := "Informes de materias de libros"
      case ::cAlias == "MADI"
         ::cDlgTitle := "Informes de géneros musicales"
      case ::cAlias == "MAVI"
         ::cDlgTitle := "Informes de materias de videos"
      case ::cAlias == "MASO"
         ::cDlgTitle := "Informes de materias de software"
      case ::cAlias == "MAIN"
         ::cDlgTitle := "Informes de materias de internet"
      case ::cAlias == "IN"
         ::cDlgTitle := "Informes de internet"
      case ::cAlias == "SO"
         ::cDlgTitle := "Informes de software"
      case ::cAlias == "VI"
         ::cDlgTitle := "Informes de videos"
      case ::cAlias == "CN"
         ::cDlgTitle := "Informes de canciones"
      case ::cAlias == "MU"
         ::cDlgTitle := "Informes de discos"
      case ::cAlias == "LI"
         ::cDlgTitle := "Informes de libros"
		case ::cAlias == "NO"
         ::cDlgTitle := "Informes de recordatorios de préstamos"
		case ::cAlias == "AGP"
         ::cDlgTitle := "Informes de propietarios de ejemplares"
		case ::cAlias == "AGC"
         ::cDlgTitle := "Informes de la agenda de contactos"
		case ::cAlias == "AGO"
			::cDlgTitle := "Informes de centros de compras"
		// azeta
		case ::cAlias == "AR"
			::cDlgTitle := "Informes de documentos"
		case ::cAlias == "ZMA"
			::cDlgTitle := "Informes de materias de documentos"
		case ::cAlias == "ZET"
			::cDlgTitle := "Informes de etiquetas de documentos"
		case ::cAlias == "ZAU"
			::cDlgTitle := "Informes de autores de documentos"
		case ::cAlias == "ZAU"
			::cDlgTitle := "Informes de publicaciones de documentos"
   endcase
RETURN Self
//______________________________________________________________________________________//

METHOD Load() CLASS TInforme
   LOCAL i, cToken
	LOCAL aArray := {}
   ::cReport   := GetPvProfString("Report", ::cAlias+StrZero(::nRadio,2)+"Report","",oApp():cIniFile)
   ::cRptFont  := GetPvProfString("Report", ::cAlias+StrZero(::nRadio,2)+"RptFont","",oApp():cIniFile)
   ::cTitulo1  := GetPvProfString("Report", ::cAlias+StrZero(::nRadio,2)+"Titulo1",space(50),oApp():cIniFile)
   ::cTitulo2  := GetPvProfString("Report", ::cAlias+StrZero(::nRadio,2)+"Titulo2",space(50),oApp():cIniFile)
	::cTitulo3	:= NIL
	::cPdfFile  := GetPvProfString("Report", ::cAlias+StrZero(::nRadio,2)+"PdfFile","listado.pdf",oApp():cIniFile)
	::cPdfFile  := ::cPdfFile+Space(50-Len(::cPdfFile))

   ::hBmp      := LoadBitmap( 0, 32760 )

   ::aoFont    := { , , }
   ::aoSizes   := { , , }
   ::aoEstilo  := { , , }
   ::acSizes   := { "24", "20", "12" }
   ::acEstilo  := { "Normal", "Normal", "Normal" }
   ::acFont    := { "Trebuchet MS", "Trebuchet MS", "Trebuchet MS" }
   ::aSizes    := { "08", "10", "12", "14", "16", "18", "20", "22", "24", "26", "28", "36", "48", "72" }
   ::aEstilo   := { i18n("Cursiva"), i18n("Negrita"), i18n("Negrita Cursiva"),  i18n("Normal") }
   ::nDevice   := 0

   ::cTitulo1  := Rtrim(::cTitulo1)+Space(50-LEN(::cTitulo1))
   ::cTitulo2  := Rtrim(::cTitulo2)+Space(50-LEN(::cTitulo2))
   ::lSummary  := .f.
   IF ! empty(::cReport)
      FOR i := 1 TO Len(::aCampos)
         cToken         := StrToken(::cReport,i,";")
         ::aCampos[i]   := StrToken(cToken,1,":")
         ::aTitulos[i]  := StrToken(cToken,2,":")
         ::aWidth[i]    := VAL(StrToken(cToken,3,":"))
         ::aShow[i]     := AllTrim(StrToken( cToken, 4, ":" ) ) == "S"
         ::aPicture[i]  := StrToken(cToken,5,":")
         ::aTotal[i]    := AllTrim(StrToken( cToken, 6, ":" ) ) == "S"
      NEXT
   ENDIF
	// lleno el aArray de campos
	For i := 1 to len(::aTitulos)
		Aadd( aArray, {::aShow[i],::aTitulos[i],::aWidth[i]} )
	Next
	::aArray := aArray
   IF ! empty(:: cRptFont)
      FOR i:=1 TO 3
         cToken         := StrToken(::cRptFont,i,";")
         ::acFont[i]    := StrToken(cToken,1,":")
         ::acSizes[i]   := StrToken(cToken,2,":")
         ::acEstilo[i]  := StrToken(cToken,3,":")
      NEXT
   ENDIF
   ::aFont := aGetFont( oApp():oWndMain )
RETURN NIL
//______________________________________________________________________________________//
METHOD Dialog() CLASS TInforme

   DEFINE DIALOG ::oDlg RESOURCE "INFORME" ; //OF oApp():oDlg  ;
      TITLE ::cDlgTitle
   ::oDlg:SetFont(oApp():oFont)

   REDEFINE FOLDER ::oFld ;
      ID 100 OF ::oDlg    ;
      ITEMS " &Tipo de informe ", " &Selección de campos ", " &Encabezado y tipografía ", " PDF ";
      DIALOGS "INFORME1"+::cAlias, "INFORME2", "INFORME3", "INFORME4" ;
      OPTION 1

RETURN NIL
//______________________________________________________________________________________//

METHOD Folders() CLASS TInforme
	local i
	local aArray := {}
	local oCol

	::oRadio:bChange := {|| ::Change() }

	::oLbx := TXBrowse():New( ::oFld:aDialogs[2] )

	::oLbx:SetArray(::aArray)
	Ut_BrwRowConfig( ::oLbx )
   ::oLbx:nDataType 	:= 1 // array
	::oLbx:bChange		:= { || (::oGet:Refresh(),::oCheck:Refresh(),::oFld:aDialogs[2]:AEvalWhen() ) }


   ::oLbx:aCols[1]:cHeader  := i18n("Mostrar")
   ::oLbx:aCols[1]:nWidth   := 44
  	::oLbx:aCols[1]:AddResource("16_CHECK")
   ::oLbx:aCols[1]:AddResource(" ")
   ::oLbx:aCols[1]:bBmpData := { || if(::aArray[::oLbx:nArrayAt,1]==.t.,1,2)}
 	::olbx:aCols[1]:bStrData := {|| NIL }

   ::oLbx:aCols[2]:cHeader  := i18n("Columna")
   ::oLbx:aCols[2]:nWidth   := 134

   ::oLbx:aCols[3]:cHeader  := i18n("Ancho")
   ::oLbx:aCols[3]:nWidth   := 70

   FOR i := 1 TO LEN(::oLbx:aCols)
      oCol := ::oLbx:aCols[ i ]
		oCol:bLDClickData  := { || IIF(::aShow[ ::oLbx:nArrayAt ],::oBtnHide:Click(),::oBtnShow:Click()) }
   NEXT
	::oLbx:CreateFromResource( 200 )

   REDEFINE Say ::oSay ID 210 OF ::oFld:aDialogs[2]

   REDEFINE GET ::oGet VAR ::aWidth[ ::oLbx:nArrayAt ] ;
      ID       211   ;
      SPINNER        ;
      MIN      1     ;
      MAX      99    ;
      PICTURE  "99"  ;
      VALID    ::aWidth[ ::oLbx:nArrayAt ] > 0 ;
      OF       ::oFld:aDialogs[2]
	::oGet:bChange    := {|| (::oLbx:aArrayData[::oLbx:nArrayAt,3] := ::aWidth[::oLbx:nArrayAt], ::oLbx:Refresh()) }
	::oGet:bLostFocus := {|| (::oLbx:aArrayData[::oLbx:nArrayAt,3] := ::aWidth[::oLbx:nArrayAt], ::oLbx:Refresh()) }

   REDEFINE CHECKBOX ::oCheck VAR ::aTotal[ ::oLbx:nArrayAt ] ;
      ID 212 OF ::oFld:aDialogs[2] UPDATE          ;
      WHEN ::aPicture[ ::oLbx:nArrayAt ] != "NO"

   REDEFINE BUTTON ::oBtnUp       ;
      ID       201                ;
      OF       ::oFld:aDialogs[2] ;
      WHEN ::oLbx:nArrayAt > 1    ;
      ACTION IIF( ::oLbx:nArrayAt > 1,;
                ( SwapUpArray( ::aShow   , ::oLbx:nArrayAt ) ,;
                  SwapUpArray( ::aTitulos, ::oLbx:nArrayAt ) ,;
                  SwapUpArray( ::aCampos , ::oLbx:nArrayAt ) ,;
                  SwapUpArray( ::aWidth  , ::oLbx:nArrayAt ) ,;
                  SwapUpArray( ::aPicture, ::oLbx:nArrayAt ) ,;
                  SwapUpArray( ::oLbx:aArrayData, ::oLbx:nArrayAt ) ,;
						::oLbx:nArrayAt -- ,;
                  ::oLbx:Refresh()  ),;
                MsgStop("No se puede desplazar la columna." ))

   REDEFINE BUTTON ::oBtnDown   ;
      ID    202                 ;
      OF    ::oFld:aDialogs[2]  ;
      WHEN ::oLbx:nArrayAt < Len(::aTitulos) ;
      ACTION IIF( ::oLbx:nArrayAt < Len(::aTitulos),  ;
                ( SwapDwArray( ::aShow   , ::oLbx:nArrayAt ) ,;
                  SwapDwArray( ::aTitulos, ::oLbx:nArrayAt ) ,;
                  SwapDwArray( ::aCampos , ::oLbx:nArrayAt ) ,;
                  SwapDwArray( ::aWidth  , ::oLbx:nArrayAt ) ,;
                  SwapDwArray( ::aPicture, ::oLbx:nArrayAt ) ,;
						SwapDwArray( ::oLbx:aArrayData, ::oLbx:nArrayAt ) ,;
                  ::oLbx:nArrayAt ++ ,;
                  ::oLbx:Refresh()  ),;
                MsgStop("No se puede desplazar la columna." ))

   REDEFINE BUTTON ::oBtnShow   ;
      ID    203                 ;
      OF    ::oFld:aDialogs[2]  ;
      WHEN ( ! ::aShow[ ::oLbx:nArrayAt ] ) ;
      ACTION ( ::aShow[ ::oLbx:nArrayAt ] := .t., ;
					::oLbx:aArrayData[::oLbx:nArrayAt,1] := .t., ::oLbx:Refresh(),;
					::oLbx:SetFocus(), ::oLbx:Refresh() )

   REDEFINE BUTTON ::oBtnHide   ;
      ID     204                ;
      OF     ::oFld:aDialogs[2] ;
      WHEN ( ::aShow[ ::oLbx:nArrayAt ] .AND. aScanN( ::aShow, .t. ) > 1 ) ;
      ACTION ( ::aShow[ ::oLbx:nArrayAt ] := .f.,;
 					::oLbx:aArrayData[::oLbx:nArrayAt,1] := .f., ::oLbx:Refresh(),;
					::oLbx:SetFocus(), ::oLbx:Refresh() )

   REDEFINE SAY ID 100 OF ::oFld:aDialogs[3]
   REDEFINE SAY ID 101 OF ::oFld:aDialogs[3]
   REDEFINE SAY ID 102 OF ::oFld:aDialogs[3]
   REDEFINE GET ::oGet1 VAR ::cTitulo1 ;
      ID 200 OF ::oFld:aDialogs[3] UPDATE
   REDEFINE GET ::oGet2 VAR ::cTitulo2 ;
      ID 201 OF ::oFld:aDialogs[3] UPDATE

   REDEFINE SAY ID 211 OF ::oFld:aDialogs[3]
   REDEFINE SAY ID 212 OF ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoFont[1] VAR ::acFont[1] ;
      ID       213 ;
      ITEMS    ::aFont ;
      OF       ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoSizes[1] VAR ::acSizes[1] ;
      ID       214 ;
      ITEMS    ::aSizes ;
      OF       ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoEstilo[1] VAR ::acEstilo[1] ;
      ID       215 ;
      ITEMS    ::aEstilo ;
      OF       ::oFld:aDialogs[3]

   REDEFINE SAY ID 216 OF ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoFont[2] VAR ::acFont[2] ;
      ID       217 ;
      ITEMS    ::aFont ;
      OF       ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoSizes[2] VAR ::acSizes[2] ;
      ID       218 ;
      ITEMS    ::aSizes ;
      OF       ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoEstilo[2] VAR ::acEstilo[2] ;
      ID       219 ;
      ITEMS    ::aEstilo ;
      OF       ::oFld:aDialogs[3]

   REDEFINE SAY ID 220 OF ::oFld:aDialogs[3]
   REDEFINE COMBOBOX ::aoFont[3] VAR ::acFont[3] ;
      ID       221 ;
      ITEMS    ::aFont ;
      OF       ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoSizes[3] VAR ::acSizes[3] ;
      ID       222 ;
      ITEMS    ::aSizes ;
      OF       ::oFld:aDialogs[3]

   REDEFINE COMBOBOX ::aoEstilo[3] VAR ::acEstilo[3] ;
      ID       223 ;
      ITEMS    ::aEstilo ;
      OF       ::oFld:aDialogs[3]

	// 4º folder: PDF
	REDEFINE SAY ID 100 OF ::oFld:aDialogs[4]
	REDEFINE SAY ID 101 OF ::oFld:aDialogs[4]

	REDEFINE GET ::oGet3 VAR ::cPdfFile  ;
		ID 200 OF ::oFld:aDialogs[4]    ;
		VALID PdfFileValid(::cPdfFile, ::oGet3)

	REDEFINE SAY ID 211 OF ::oFld:aDialogs[4]
	REDEFINE SAY ID 212 OF ::oFld:aDialogs[4] ;
	PROMPT oApp():cPdfPath

   REDEFINE BUTTON ;
      ID       101 ;
      OF       ::oDlg ;
      ACTION   ( ::nDevice := 1, ::oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       102 ;
      OF       ::oDlg ;
      ACTION   ( ::nDevice := 2, ::oDlg:end( IDOK ) )

   REDEFINE BUTTON ;
      ID       103 ;
      OF       ::oDlg ;
      ACTION   ::oDlg:end( IDCANCEL )

RETURN Nil

METHOD Change() CLASS TInforme
	::Save()
	::nPrevRadio := ::nRadio
	::Load()

	//::oDlg:Refresh()
	::oLbx:SetArray(::aArray)
	::oLbx:nArrayAt := 1
	::oLbx:Refresh()
	::oBtnShow:Refresh()
	::oBtnHide:Refresh()

	::oGet1:Refresh()
	::oGet2:Refresh()
	if ::aoFont[1] != NIL
		::aoFont[1]:Refresh()
		::aoSizes[1]:Refresh()
		::aoEstilo[1]:Refresh()
		::aoFont[2]:Refresh()
		::aoSizes[2]:Refresh()
		::aoEstilo[2]:Refresh()
		::aoFont[3]:Refresh()
		::aoSizes[3]:Refresh()
		::aoEstilo[3]:Refresh()
	endif

	::oGet3:Refresh()
RETURN NIL

METHOD Activate() CLASS TInforme
   local o := self
   ACTIVATE DIALOG ::oDlg ;
      ON INIT DlgCenter(o:oDlg,oApp():oWndMain)

RETURN ( ::oDlg:nResult == IDOK )

METHOD Report(lResumen) CLASS TInforme
   LOCAL i
   LOCAL aSoEntorno := { i18n("DOS"), i18n("Windows"), i18n("Linux"), i18n("MacOS"), i18n("Otro") }
   LOCAL aViSoporte := { i18n("VHS"), i18n("DVD"), i18n("DIVX"), i18n("(S)VCD"), i18n("Otro") }
   LOCAL aViCalific := { i18n("TP"), i18n("+7"), i18n("+13"), i18n("+18"), i18n("XXX") }
   LOCAL aMuSoporte := { i18n("CD"), i18n("Casette"), i18n("MiniDisc"), i18n("Vinilo"), i18n("Otro"), i18n("DVD") }
	local aNoTipos   := { i18n("Libro"), i18n("Disco"), i18n("Vídeo"), i18n("Software") }
   DEFAULT lResumen := .f.

   ::lSummary := lResumen

   ::oFont1 := TFont():New( Rtrim( ::acFont[ 1 ] ), 0, Val( ::acSizes[ 1 ] ),,( i18n("Negrita") $ ::acEstilo[ 1 ] ),,,,( i18n("Cursiva") $ ::acEstilo[ 1 ] ),,,,,,, )
   ::oFont2 := TFont():New( Rtrim( ::acFont[ 2 ] ), 0, Val( ::acSizes[ 2 ] ),,( i18n("Negrita") $ ::acEstilo[ 2 ] ),,,,( i18n("Cursiva") $ ::acEstilo[ 2 ] ),,,,,,, )
   ::oFont3 := TFont():New( Rtrim( ::acFont[ 3 ] ), 0, Val( ::acSizes[ 3 ] ),,( i18n("Negrita") $ ::acEstilo[ 3 ] ),,,,( i18n("Cursiva") $ ::acEstilo[ 3 ] ),,,,,,, )

   ::cTitulo1 := Rtrim(::cTitulo1)
   ::cTitulo2 := Rtrim(::cTitulo2)

   IF ::nDevice == 1
      IF ! ::lSummary
         REPORT ::oReport ;
         TITLE  " ",::cTitulo1,::cTitulo2,iif(::cTitulo3!=NIL,::cTitulo3," ") CENTERED;
         FONT   ::oFont3, ::oFont2, ::oFont1 ;
         HEADER ' ', oApp():cAppName+oApp():cVersion, oApp():cUser   ;
         FOOTER ' ', "Fecha: "+dtoc(date())+ "   Página.: "+str(::oReport:nPage,3) ;
         CAPTION oApp():cAppName+oApp():cVersion PREVIEW
      ELSE
         REPORT ::oReport ;
         TITLE  " ",::cTitulo1,::cTitulo2,iif(::cTitulo3!=NIL,::cTitulo3," ") CENTERED;
         FONT   ::oFont3, ::oFont2, ::oFont1 ;
         HEADER ' ', oApp():cAppName+oApp():cVersion, oApp():cUser   ;
         FOOTER ' ', "Fecha: "+dtoc(date())+ "   Página.: "+str(::oReport:nPage,3) ;
         CAPTION oApp():cAppName+oApp():cVersion PREVIEW SUMMARY
      ENDIF
   ELSEIF ::nDevice == 2
      IF ! ::lSummary
         REPORT ::oReport ;
         TITLE  " ",::cTitulo1,::cTitulo2,iif(::cTitulo3!=NIL,::cTitulo3," ") CENTERED;
         FONT   ::oFont3, ::oFont2, ::oFont1 ;
         HEADER ' ', oApp():cAppName+oApp():cVersion, oApp():cUser   ;
         FOOTER ' ', "Fecha: "+dtoc(date())+ "   Página.: "+str(::oReport:nPage,3) ;
         CAPTION oApp():cAppName+oApp():cVersion // PREVIEW
      ELSE
         REPORT ::oReport ;
         TITLE  " ",::cTitulo1,::cTitulo2,iif(::cTitulo3!=NIL,::cTitulo3," ") CENTERED;
         FONT   ::oFont3, ::oFont2, ::oFont1 ;
         HEADER ' ', oApp():cAppName+oApp():cVersion, oApp():cUser   ;
         FOOTER ' ', "Fecha: "+dtoc(date())+ "   Página.: "+str(::oReport:nPage,3) ;
         CAPTION oApp():cAppName+oApp():cVersion SUMMARY // PREVIEW SUMMARY
      ENDIF
   ENDIF

   FOR i := 1 TO Len(::aTitulos)
      IF ::aShow[i]
         if ::aPicture[i] == "NO"
            RptAddColumn( {bTitulo(::aTitulos,i)},,{bCampo(::aCampos,i)},::aWidth[i],{},{||1},.F.,,,.F.,.F.,)
         elseif ::aPicture[i] == "AP01"
            COLUMN TITLE "Imp. Neto" DATA IIF(AP->ApTipo=="I",AP->ApImpNeto,(-1)*AP->ApImpNeto) SIZE ::aWidth[i] FONT 1 PICTURE "@E 9,999,999.99" TOTAL
         elseif ::aPicture[i] == "AP02"
            COLUMN TITLE "Imp. Total" DATA IIF(AP->ApTipo=="I",AP->ApImpTotal,(-1)*AP->ApImpTotal) SIZE ::aWidth[i] FONT 1 PICTURE "@E 9,999,999.99" TOTAL
         elseif ::aPicture[i] == "PE01"
            COLUMN TITLE "Imp. Neto" DATA IIF(PE->PeTipo=="I",PE->PeImpNeto,(-1)*PE->PeImpNeto) SIZE ::aWidth[i] FONT 1 PICTURE "@E 9,999,999.99"
         elseif ::aPicture[i] == "PE02"
            COLUMN TITLE "Imp. Total" DATA IIF(PE->PeTipo=="I",PE->PeImpTotal,(-1)*PE->PeImpTotal) SIZE ::aWidth[i] FONT 1 PICTURE "@E 9,999,999.99"
         elseif ::aPicture[i] == "SO01"
            COLUMN TITLE "Entorno" DATA if( SO->( ordKeyCount() ) > 0, aSoEntorno[SO->SoEntorno6], "" ) SIZE ::aWidth[i] FONT 1
         elseif ::aPicture[i] == "SO02"
            COLUMN TITLE "Demo" DATA if( SO->( ordKeyCount() ) > 0, if( SO->SoDemo, "Sí", "No" ), "" ) SIZE ::aWidth[i] FONT 1
         elseif ::aPicture[i] == "SO03"
            COLUMN TITLE "Disquette" DATA if( SO->( ordKeyCount() ) > 0, if( SO->SoDiscos, "Sí", "No" ), "" ) SIZE ::aWidth[i] FONT 1
         elseif ::aPicture[i] == "SO04"
            COLUMN TITLE "CD" DATA if( SO->( ordKeyCount() ) > 0, if( SO->SoCD, "Sí", "No" ), "" ) SIZE ::aWidth[i] FONT 1
         elseif ::aPicture[i] == "VI01"
            COLUMN TITLE "Soporte" DATA if( VI->( ordKeyCount() ) > 0, aViSoporte[VI->ViSoporte], "" ) SIZE ::aWidth[i] FONT 1
         elseif ::aPicture[i] == "MU01"
            COLUMN TITLE "Soporte" DATA if( MU->( ordKeyCount() ) > 0, aMuSoporte[MU->MuSoporte], "" ) SIZE ::aWidth[i] FONT 1
			elseif ::aPicture[i] == "NO01"
				COLUMN TITLE "Tipo" DATA if( NO->( ordKeyCount() ) > 0, aNoTipos[NO->NoTipo], "" ) SIZE ::aWidth[i] FONT 1
         else
            // ? ::aTitulos[i]
            RptAddColumn( {bTitulo(::aTitulos,i)},,{bCampo(::aCampos,i)},::aWidth[i],{bPicture(::aPicture,i)},{||1},::aTotal[i],,,.F.,.F.,)
         endif
      ENDIF
   NEXT
   // defino los grupos para los informes

   ::oReport:Cargo := ::cPdfFile
   END REPORT

   IF ::oReport:lCreated
      ::oReport:nTitleUpLine     := RPT_SINGLELINE
      ::oReport:nTitleDnLine     := RPT_SINGLELINE
      ::oReport:oTitle:aFont[2]  := {|| 3 }
      ::oReport:oTitle:aFont[3]  := {|| 2 }
      ::oReport:nTopMargin       := 0.1
      ::oReport:nDnMargin        := 0.1
      ::oReport:nLeftMargin      := 0.1
      ::oReport:nRightMargin     := 0.1
      ::oReport:oDevice:lPrvModal:= .t.
   ENDIF
RETURN NIL

METHOD Save() CLASS TINFORME
   LOCAL i
   ::cReport   := ""
   FOR i:=1 TO Len(::aCampos)
      ::cReport := ::cReport + ::aCampos[i]+":"
      ::cReport := ::cReport + ::aTitulos[i]+":"
      ::cReport := ::cReport + STR(::aWidth[i],2)+":"
      ::cReport := ::cReport + IIF(::aShow[i],"S","N")+":"
      ::cReport := ::cReport + ::aPicture[i]+":"
      ::cReport := ::cReport + IIF(::aTotal[i],"S","N")+";"
   NEXT

   ::cRptFont  := ""
   FOR i:=1 TO 3
      ::cRptFont := ::cRptFont + ::acFont[i]+":"
      ::cRptFont := ::cRptFont + ::acSizes[i]+":"
      ::cRptFont := ::cRptFont + ::acEstilo[i]+";"
   NEXT

   WritePProString("Report",::cAlias+StrZero(::nPrevRadio,2)+"Report",::cReport,oApp():cIniFile)
   WritePProString("Report",::cAlias+StrZero(::nPrevRadio,2)+"RptFont",::cRptFont,oApp():cIniFile)
   WritePProString("Report",::cAlias+"Radio",Ltrim(Str(::nRadio)),oApp():cIniFile)
   //if lSaveTitle
      WritePProString("Report",::cAlias+StrZero(::nPrevRadio,2)+"Titulo1",::cTitulo1,oApp():cIniFile)
      WritePProString("Report",::cAlias+StrZero(::nPrevRadio,2)+"Titulo2",::cTitulo2,oApp():cIniFile)
   //endif
	WritePProString("Report",::cAlias+StrZero(::nPrevRadio,2)+"PdfFile",::cPdfFile,oApp():cIniFile)
RETURN NIL

METHOD End(lSaveTitle) CLASS TInforme
	::Save(lSaveTitle)
   RELEASE FONT ::oFont1
   RELEASE FONT ::oFont2
   RELEASE FONT ::oFont3
RETURN NIL

METHOD ReportEnd() CLASS TInforme
   END REPORT
   IF ::oReport:lCreated
      ::oReport:nTitleUpLine     := RPT_SINGLELINE
      ::oReport:nTitleDnLine     := RPT_SINGLELINE
      ::oReport:oTitle:aFont[2]  := {|| 3 }
      ::oReport:oTitle:aFont[3]  := {|| 2 }
      ::oReport:nTopMargin       := 0.1
      ::oReport:nDnMargin        := 0.1
      ::oReport:nLeftMargin      := 0.1
      ::oReport:nRightMargin     := 0.1
      ::oReport:oDevice:lPrvModal:= .t.
   ENDIF
RETURN NIL

Function PdfFileValid(cPdfFile, oGet)
   if Lower(Right(RTrim(cPdfFile),4))!=".pdf"
      cPdfFile := RTrim(cPdfFile) + ".pdf"
   endif
   oGet:cText( cPdfFile )
return .t.
