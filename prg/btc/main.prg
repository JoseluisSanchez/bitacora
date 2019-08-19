//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"
#include "Ribbon.ch"
#include "SayRef.ch"
#include "TAutoGet.ch"
request DBFCDX
request DBFFPT
request HB_LANG_ES
request HB_CODEPAGE_ESWIN

memvar oApp
memvar oAGet

/*
 * función .: Main()
 * prec ....: True
 * post ....: Punto de entrada al programa.
*/

function Main()

   public oApp

   rddSetDefault( "DBFCDX" )
   setHandleCount( 100 )

   set date format "dd-mm-yyyy"
   set deleted on
   set century on
   set epoch to Year( Date() ) - 20
   set multiple off

   oAGet  := TAGet():New()    // inicializo el objeto para los autoget
   
   ut_override()
   with object oApp := TApplication():New()
      :Activate()
   end

return nil

class TApplication

   data cAppName
   data cVersion
   data cEdicion
   data cBuild
   data cUser
   data cUserMail
   data nSeconds
   data oTmr
   data cCopyright
   data cUrl
   data cUrlDonativo
   data cUrlCompra
   data cEmail
   data cMsgBar
   data cIniFile
   data cTipFile
   data cExePath
   data cDbfPath
   data cAztPath
   data cZipPath
   data cAztZipPath
   data cAztPdfPath
   data cXMLPath
   data cBtcPath
   data cPdfPath
   data cAztPdfPath
   data cXlsPath
   data cAztXlsPath
   data lCodAut
   data lCodOblig  // .t. si quiero codigo obligatorio
   data lCodZero
   data lCodReord
   data nBarHeight
   data oWndMain
   data oImgList, oRebar, oToolbar
   data oFont
   data oBar
   data oPopMenuTablas
   data oExit
   data oIcon
	data nIcon
   data oMsgItem1
   data oMsgItem2
   data oMsgItem3
   data oDlg
   data oGrid
   data oTab
   data oSplit
   data nEdit

   data cLanguage
   data lRibbon
   data nRibbon
   data lSoftonic
   data cHelpFile
   data nClrHL
	data nClrBar
   DATA TheFull
	DATA nSeconds

   method New() constructor

   method Activate()

   method BuildMenu()
   method BuildBtnBar()
   method BuildRibbon()

   method end()

   method CheckDirs()
   method CheckFiles()
   method CheckAztFiles()
   method ExitFromX()
   method ExitFromBtn()
   method ExitFromSource()
   // method Nit()

endclass


/*
 * función .: TApplication:New()
 * prec ....: True
 * post ....: Construye la ventana principal del programa.
*/

method New() class TApplication

   local cAAAA, cBBBB, cCCCC, cHHHH, cGGGG1, cGGGG2, cCfg

   ::cIniFile    := cFilePath( GetModuleFileName( GetInstance() ) ) + "bitacora.ini"
   ::cTipFile    := cFilePath( GetModuleFileName( GetInstance() ) ) + "tips.ini"
   ::cExePath    := cFilePath( GetModuleFileName( GetInstance() ) )
   ::cUser       := Space(15)
   ::Cdbfpath    := GetIni( ::cIniFile, "Config", "Dbf", cFilePath( GetModuleFileName( GetInstance() ) ) + "datos\" )
   ::cAztPath    := GetIni( ::cIniFile, "Config", "Azt", cFilePath( GetModuleFileName( GetInstance() ) ) + "azeta\" )
   ::cZipPath    := GetIni( ::cIniFile, "Config", "Zip", cFilePath( GetModuleFileName( GetInstance() ) ) + "zip\" )
   ::cAztZipPath := GetIni( ::cIniFile, "Config", "AztZip", cFilePath( GetModuleFileName( GetInstance() ) ) + "azetazip\" )
   ::cAztPdfPath := GetIni( ::cIniFile, "Config", "AztPdf", cFilePath( GetModuleFileName( GetInstance() ) ) + "azetapdf\" )
   ::cBtcPath    := GetIni( ::cIniFile, "Config", "Btc", cFilePath( GetModuleFileName( GetInstance() ) ) + "btc\" )
   ::cXmlPath    := GetIni( ::cIniFile, "Config", "Xml", cFilePath( GetModuleFileName( GetInstance() ) ) + "xml\" )
   ::cPdfPath    := GetIni( ::cIniFile, "Config", "Pdf", cFilePath( GetModuleFileName( GetInstance() ) ) + "pdf\" )
   ::cXlsPath    := GetIni( ::cIniFile, "Config", "Xls", cFilePath( GetModuleFileName( GetInstance() ) ) + "xls\" )
   ::lCodAut     := GetIni( ::cIniFile, "Config", "CodAut", .T. )
   ::lCodOblig   := GetIni( ::cIniFile, "Config", "CodOblig", .F. )
   ::lCodZero    := GetIni( ::cIniFile, "Config", "CodZero", .F. )
   ::lCodReord   := GetIni( ::cIniFile, "Config", "CodReord", .F. )
	::nIcon       := Val(GetIni( ::cIniFile, "Config", "nIcon", "1" ))

   ::cLanguage   := "ES" // "EN"

   ::oDlg        := NIL
   ::nEdit       := 0
   ::lSoftonic   := .F.
   ::lRibbon     := .T.
   ::nClrHL		  := RGB(204,232,255)
	::nClrbar	  := RGB(165,186,204)

   // hb_i18nSetBaseLanguage( "es_ES", "Español" )
   // hb_i18nSetPath( ".\i18n\" )
   hb_SetCodepage("ESWIN")

   if ::cLanguage == 'ES'
      // hb_i18nSetLanguage( "es_ES" )
      request HB_LANG_ES
      hb_langSelect('ES')
      set date ITALIAN
   elseif ::cLanguage == 'EN'
      // HB_I18NSetLanguage( "en_US" )
      request HB_LANG_EN
      hb_langSelect('EN')
      set date AMERICAN
   endif

   ::cAppName  := "Cuaderno de Bitácora "
   ::cVersion  := "8.31.a" // "7.01"
   ::cBuild    := i18n("build 19.08.2019")
   ::cCopyright  := "© José Luis Sánchez Navarro"
   ::cUrl        := "http://www.alanit.com"
   ::cUrlDonativo:= "http://www.alanit.com/donativos"
   ::cUrlCompra  := "http://www.alanit.com/registrar"
   ::cEmail      := "correo@alanit.com"
   ::cMsgBar     := ::cCopyright + " * alanit software - 2019 "
   ::cHelpFile   := RTrim(TakeOffExt(GetModuleFileName(GetInstance())))+".chm"
   ::nSeconds	  := Seconds()

   ::cUser := Space(15)
   ::thefull := .f.
	::cEdicion := " Edición gratuita"
   ::oFont = TFont():New( GetDefaultFontName(), 0, GetDefaultFontHeight(),, )

if ::nIcon == 1
	DEFINE ICON ::oIcon RESOURCE "BTC"
else
	DEFINE ICON ::oIcon RESOURCE "AZT"
endif

DEFINE WINDOW ::oWndMain ;
      TITLE ::cAppName + ::cVersion + ::cEdicion;
      MENU ::BuildMenu() ;
      color CLR_BLACK, GetSysColor( 15 ) - Rgb( 30, 30, 30 ) ;
      ICON ::oIcon

set message OF ::oWndMain TO ::cMsgBar CENTER NOINSET
::oWndMain:oMsgBar:oFont := ::oFont

DEFINE MSGITEM ::oMsgItem2;
      OF ::oWndMain:oMsgBar;
      prompt iif(::cUser!=Space(15),::cUser,"acerca de Cuaderno de Bitácora");
      SIZE Len(::cUser)*15;
      BITMAPS "MSG_LOTUS", "MSG_LOTUS";
      TOOLTIP " " + i18n("Acerca de...") + " "
   if ::thefull
      ::oMsgItem2:bAction := { || AppAcercade( .f. ) }
   else
      ::oMsgItem2:bAction := { || Registrame(1) }
   endif

DEFINE MSGITEM ::oMsgItem3 OF ::oWndMain:oMsgBar ;
      SIZE 152 FONT ::oFont;
      prompt "www.alanit.com" ;
      color RGB(3,95,156), GetSysColor(15)    ;
      BITMAPS "MSG_ALANIT", "MSG_ALANIT";
      TOOLTIP i18n("visitar la web de alanit");
      ACTION WinExec('start '+'.\alanit.url', 0)

::oWndmain:oMsgBar:DateOn()
if ::lRibbon
   ::BuildRibbon()
else
   ::BuildBtnBar()
endif
set Helpfile to ::cHelpFile

return Self

/*
 * función .: TApplication:Activate()
 * prec ....: True
 * post ....: Activa la ventana principal del programa.
*/

method Activate() class TApplication

   GetWinCoors( ::oWndMain, ::cInifile )
   ::oWndMain:bInit := {|| ::CheckDirs(), ::CheckFiles(), ::CheckAztFiles(), TipOfDay( ::cTipFile, .T. ), AppAcercade(.T.) }
   ::oWndMain:bResized := {|| ResizeWndMain() }
   ACTIVATE WINDOW ::oWndMain ;
      VALID ::ExitFromX()

   if ::lRibbon
      ::oRebar():End()
   endif
   ::oFont:End()

return nil


/*
 * función .: TApplication:BuildMenu()
 * prec ....: True
 * post ....: Construye el menú principal del programa.
*/

method BuildMenu() class TApplication

   local oMenu

   menu oMenu 2010
   MENUITEM i18n("&Archivo")
   menu
   MENUITEM i18n( "&1 Libros" ) ;
      ACTION Libros() ;
      message i18n("Gestión de Libros")
   MENUITEM i18n( "&2 Discos" ) ;
      ACTION Discos() ;
      message i18n("Gestión de Discos Musicales")
   MENUITEM i18n( "&3 Canciones" ) ;
      ACTION Canciones() ;
      message i18n("Gestión de Canciones y Piezas Musicales")
   MENUITEM i18n( "&4 Vídeos" ) ;
      ACTION Videos() ;
      message i18n("Gestión de Vídeos y DVD")
   MENUITEM i18n( "&5 Software" ) ;
      ACTION Software() ;
      message i18n("Gestión de Software")
   MENUITEM i18n( "&6 Internet" ) ;
      ACTION Internet() ;
      message i18n("Gestión de Direcciones de Internet")
   SEPARATOR
   MENUITEM i18n( "&7 Materias" ) ;
      ACTION Materias() ;
      message i18n("Gestión de colecciones por Materias")
   MENUITEM i18n( "&8 Ubicaciones" ) ;
      ACTION Ubicaciones() ;
      message i18n("Gestión de colecciones por Ubicaciones")
   MENUITEM i18n( "&9 Tablas auxiliares" )
   menu
   MENUITEM i18n( "&1 Tablas Auxiliares de Libros" )
   menu
   MENUITEM i18n( "&1 Escritores" ) ;
      ACTION Autores( "E" ) ;
      message i18n("Gestión de Escritores")
   SEPARATOR
   MENUITEM i18n( "&2 Editoriales" ) ;
      ACTION Editores( "L" ) ;
      message i18n("Gestión de Editoriales")
   MENUITEM i18n( "&3 Colecciones" ) ;
      ACTION Colecciones( "L" ) ;
      message i18n("Gestión de Colecciones de Libros")
   ENDMENU
   MENUITEM i18n( "&2 Tablas Auxiliares de Discos" )
   menu
   MENUITEM i18n( "&1 Intérpretes" ) ;
      ACTION Autores( "I" ) ;
      message i18n("Gestión de Intérpretes Musicales")
   MENUITEM i18n( "&2 Compositores" ) ;
      ACTION Autores( "C" ) ;
      message i18n("Gestión de Compositores Musicales")
   MENUITEM i18n( "&3 Directores" ) ;
      ACTION Autores( "D" ) ;
      message i18n("Gestión de Directores Musicales")
   SEPARATOR
   MENUITEM i18n( "&4 Productoras" ) ;
      ACTION Editores( "D" ) ;
      message i18n("Gestión de Productoras de Discos")
   MENUITEM i18n( "&5 Colecciones" ) ;
      ACTION Colecciones( "D" ) ;
      message i18n("Gestión de Colecciones de Discos")
   ENDMENU
   MENUITEM i18n( "&3 Tablas Auxiliares de Vídeos" )
   menu
   MENUITEM i18n( "&1 Directores de Cine" ) ;
      ACTION Autores( "T" ) ;
      message i18n("Gestión de Directores de Cine")
   MENUITEM i18n( "&2 Actores/Actrices" ) ;
      ACTION Autores( "R" ) ;
      message i18n("Gestión de Actores/Actrices")
   MENUITEM i18n( "&3 Directores de Fotografía" ) ;
      ACTION Autores( "F" ) ;
      message i18n("Gestión de Directores de Fotografía")
   SEPARATOR
   MENUITEM i18n( "&4 Productoras" ) ;
      ACTION Editores( "V" ) ;
      message i18n("Gestión de Productoras de Cine")
   MENUITEM i18n( "&5 Colecciones" ) ;
      ACTION Colecciones( "V" ) ;
      message i18n("Gestión de Colecciones de Vídeos")
   ENDMENU
   MENUITEM i18n( "&4 Tablas Auxiliares de Software" )
   menu
   MENUITEM i18n( "&1 Compañías" ) ;
      ACTION Editores( "S" ) ;
      message i18n("Gestión de Compañías de Software")
   ENDMENU
   MENUITEM i18n( "&5 Tablas Auxiliares de Contactos" )
   menu
   MENUITEM i18n( "&1 Categorías de Ocio" ) ;
      ACTION Categorias( "O" ) ;
      message i18n("Gestión de Categorías de Ocio")
   ENDMENU
   SEPARATOR
   MENUITEM i18n( "&6 Tabla auxiliar de Idiomas" ) ;
      ACTION Idiomas() ;
      message i18n("Gestión de Idiomas")
   ENDMENU
   SEPARATOR
   MENUITEM i18n( "&A Propietarios" ) ;
      ACTION Agenda("P") ;
      message i18n("Gestión de propietarios")
   MENUITEM i18n( "&B Contactos" ) ;
      ACTION Agenda("C") ;
      message i18n("Gestión de la agenda de Contactos")
   MENUITEM i18n( "&C Centros de compra" ) ;
      ACTION CCompras() ;
      message i18n("Gestión de centros de compras")
   MENUITEM i18n( "&D Préstamos" ) ;
      ACTION Notas() ;
      message i18n("Recordatorio de Préstamos")
   SEPARATOR
   MENUITEM i18n( "&E Especificar impresora" ) ;
      ACTION PrinterSetup() ;
      message i18n("Establecer la Configuración de su impresora")
   SEPARATOR
   MENUITEM i18n( "&D Salir" ) ;
      ACTION ::ExitFromBtn() ;
      message i18n("Terminar la ejecución del programa")
   ENDMENU
   MENUITEM i18n( "&Utilidades" )
   menu
   MENUITEM i18n( "&1 Configuración del programa" ) ;
      ACTION UtConfigApp(.F.) ;
      message i18n("Cambiar la configuración del programa")
   SEPARATOR
   MENUITEM i18n( "&2 Reindexar ficheros del programa" ) ;
      ACTION ( Ut_Actualizar(.F.), Ut_Indexar(.T.) ) ;
      message i18n("Reindexar ficheros del programa")
   MENUITEM i18n( "&3 Importar datos de versión antigua" ) ;
      ACTION ( UtImportarVersion() ) ;
      message i18n("Importar ficheros de datos de una versión antigua")
   MENUITEM i18n( "&4 Reordenar códigos de ejemplares" ) ;
      ACTION UtReordenarCodigos() ;
      message i18n("Reordenar códigos de ejemplares")
   SEPARATOR
   MENUITEM i18n( "&5 Hacer Copia de Seguridad" ) ;
      ACTION ZipBackup(oApp():cDbfPath) ;
      message i18n("Hacer copia de Seguridad")
   MENUITEM i18n( "&6 Restaurar Copia de Seguridad" ) ;
      ACTION ZipRestore(oApp():cDbfPath) ;
      message i18n("Restaurar copia de Seguridad")
   SEPARATOR
   MENUITEM i18n("&7 Generar XML")  ACTION GenXML() ;
      message i18n("Generar ficheros XML con los datos del programa")
   ENDMENU
   MENUITEM i18n( "A&yuda" )
   menu
   MENUITEM i18n( "&1 Ayuda del programa" ) ;
      ACTION iif(!IsWinNt(),;
      winExec("start "+RTrim(TakeOffExt(GetModuleFileName(GetInstance()))+".chm")),;
      ShellExecute(GetActiveWindow(),'Open',TakeOffExt(GetModuleFileName(GetInstance()))+".chm",,,4));
      message i18n("Obtener ayuda de la aplicación" )
   MENUITEM i18n("&2 Truco del día")  ACTION TipOfDay('.\tips.ini', .F.) ;
      message i18n("Mostrar el truco del día")
   SEPARATOR
   MENUITEM i18n("&3 Visitar web de alanit")  ACTION GoWeb("http://www.alanit.com") ;
      message "Visitar la web de alanit en internet"
   MENUITEM i18n("&5 Contactar por e-mail con el autor del programa")   ;
      ACTION iif(!IsWinNt(),;
      winexec('start mailto:correo.alanit@gmail.com?subject=Consulta sobre Cuaderno de Bitácora',0),;
      Winexec('rundll32.exe url.dll,FileProtocolHandler mailto:correo.alanit@gmail.com?subject=Consulta sobre Cuaderno de Bitácora' )) ;
      message i18n("Enviar un e-mail al autor del programa")
   MENUITEM i18n("&6 Comprar la edición registrada por 20 euros")    ;
      ACTION GoWeb(oApp():cUrlCompra)  ;
      message i18n("Comprar la edición registrada del programa.")
   SEPARATOR
   MENUITEM i18n("&7 Acerca de Cuaderno de Bitácora")  ACTION AppAcercade( .F. ) ;
      message i18n(" Información sobre la aplicación")
   ENDMENU
   ENDMENU
   if ::lRibbon
      oMenu := NIL
   endif

return oMenu

/*_____________________________________________________________________________*/
/*
 * función .: TApplication:BuildBtnBar()
 * prec ....: True
 * post ....: Construye la barra de botones principal del programa.
*/
method BuildBtnBar() class TApplication

   local oBtnTbl

   ::oImgList := TImageList():New( 36, 36 ) // width and height of bitmaps
   ::oImgList:AddMasked( TBitmap():Define( "BB_LIBROS",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_DISCOS",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_MCANCIONES",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_VIDEOS",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_SOFTWARE",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_INTERNET",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_MATERIAS",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_UBICACIONES",, ::oWndMain ),nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_TABLAS",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_PROPIET",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_AGENDA",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_COMPRA",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_NOTAS",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_INDEX",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_AYUDA",, ::oWndMain ), nRGB( 240, 240, 240 ) )
   ::oImgList:AddMasked( TBitmap():Define( "BB_SALIR",, ::oWndMain ), nRGB( 240, 240, 240 ) )

   ::oReBar := TReBar():New( ::oWndMain )
   ::oToolBar := TToolBar():New( ::oReBar, 38, 40, ::oImgList, .T. )
   ::oReBar:InsertBand( ::oToolBar )
   ::nBarHeight := ::oToolbar:nHeight

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Libros() ;
      TOOLTIP i18n("Gestión de libros");
      message i18n("Gestión de libros.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Discos() ;
      TOOLTIP i18n("Gestión de discos musicales");
      message i18n("Gestión de discos musicales.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Canciones() ;
      TOOLTIP i18n("Gestión de canciones y piezas musicales");
      message i18n("Gestión de canciones y piezas musicales.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Videos() ;
      TOOLTIP i18n("Gestión de videos y DVD");
      message i18n("Gestión de videos y DVD.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Software() ;
      TOOLTIP i18n("Gestión de software");
      message i18n("Gestión de software.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Internet() ;
      TOOLTIP i18n("Gestión de direcciones de internet");
      message i18n("Gestión de direcciones de internet.")

   DEFINE TBSEPARATOR OF ::oToolbar

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Materias() ;
      TOOLTIP i18n("Gestión de colecciones por materias");
      message i18n("Gestión de colecciones por materias.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Ubicaciones() ;
      TOOLTIP i18n("Gestión de colecciones por ubicaciones");
      message i18n("Gestión de colecciones por materias.")

   DEFINE TBSEPARATOR OF ::oToolbar

   DEFINE TBMENU OF ::oToolBar ;
      ACTION  ActivatePopMenuTablas( ::oToolbar:aButtons[9] ) ;
      TOOLTIP i18n("Gestión de tablas auxiliares");
      message i18n("Gestión de tablas auxiliares.") ;
      menu    BuildPopMenuTablas()

   DEFINE TBSEPARATOR OF ::oToolbar

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Agenda("P") ;
      TOOLTIP i18n("Gestión de propietarios");
      message i18n("Gestión de propietarios de ejemplares.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Agenda("C") ;
      TOOLTIP i18n("Gestión de la agenda de contactos");
      message i18n("Gestión de la agenda de contactos.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  CCompras() ;
      TOOLTIP i18n("Gestión de compras");
      message i18n("Gestión de centros de compra.")

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION  Notas() ;
      TOOLTIP i18n("Gestión de recordatorios de préstamos");
      message i18n("Gestión de recordatorios de préstamos.")

   DEFINE TBSEPARATOR OF ::oToolbar

   DEFINE TBBUTTON OF ::oToolBar ;
      ACTION ( Ut_Actualizar(.F.), Ut_Indexar(.T.), Ut_AztActualizar(.F.), Ut_AztIndexar(.T.) ) ;
      TOOLTIP i18n("Reindexar ficheros del programa") ;
      message i18n( "Reindexar ficheros del programa." ) ;

      DEFINE TBBUTTON OF ::oToolBar ;
      ACTION iif(!IsWinNt(),;
      winExec("start "+RTrim(TakeOffExt(GetModuleFileName(GetInstance()))+".chm")),;
      ShellExecute(GetActiveWindow(),'Open',TakeOffExt(GetModuleFileName(GetInstance()))+".chm",,,4));
      TOOLTIP i18n("Ayuda de la aplicación") ;
      message i18n( "Obtener ayuda del uso de la aplicación." )

   DEFINE TBSEPARATOR OF ::oToolbar

   DEFINE TBBUTTON OF ::oToolBar  ;
      ACTION ::ExitFromBtn() ;
      TOOLTIP i18n( "Salir del programa" ) ;
      message i18n( "Finalizar el uso del programa." )

return Self
/*_____________________________________________________________________________*/
/*
 * función .: TApplication:BuildBtnBar()
 * prec ....: True
 * post ....: Construye la barra de botones principal del programa.
*/
method BuildRibbon() class TApplication

   local aRbPrompts :=  {"Libros", "Discos", "Videos", "Software - Internet", "Documentos", "Utilidades"}
   local oGrL1, oGrL2, oGrL3
   local oGrD1, oGrD2, oGrD3
   local oGrV1, oGrV2, oGrV3
   local oGrU1, oGrU2, oGrU3
   local oGrS1, oGrI1, oGrS2
   local oGrA1, oGrA2, oGrA3
   local nOption := Val(GetPvProfString("Config", "Ribbon","1", ::cIniFile))

   ::oRebar := TRibbonBar():New(::oWndMain, aRbPrompts,,,,110,30,,,,,,,,,,.T.,)
   ::nBarHeight := ::oRebar:nHeight

   // DEFINE QUICKBUTTON OF ::oRebar BITMAP "16_btc" // ACTION AbreMenu( oWnd )
   // 1 libros
   ADD GROUP oGrL1 RIBBON ::oRebar to OPTION 1 WIDTH 290// PROMPT "Libros"

   @ 04,05 ADD BUTTON prompt "Libros" BITMAP "BB_LIBROS";
      GROUP oGrL1 SIZE 60,65 top ROUND ACTION Libros() TOOLTIP "Gestión de libros"

   @ 04,65 ADD BUTTON prompt "Escritores" BITMAP "BB_LAUTOR";
      GROUP oGrL1 SIZE 70,65 top ROUND ACTION Autores("E") TOOLTIP "Gestión de escritores"

   @ 04,135 ADD BUTTON prompt "Editoriales" BITMAP "BB_LEDITOR";
      GROUP oGrL1 SIZE 70,65 top ROUND ACTION Editores("L") TOOLTIP "Gestión de editoriales"

   @ 04,205 ADD BUTTON prompt "Colecciones" BITMAP "BB_LCOLECC";
      GROUP oGrL1 SIZE 80,65 top ROUND ACTION Colecciones("L") TOOLTIP "Gestión de colecciones"

   ADD GROUP oGrL2 RIBBON ::oRebar to OPTION 1 WIDTH 150

   @ 04,05 ADD BUTTON prompt "Materias" BITMAP "BB_MATERIAS";
      GROUP oGrL2 SIZE 60,65 top ROUND ACTION Materias("L") TOOLTIP "Gestión de materias de libros"

   @ 04,65 ADD BUTTON prompt "Ubicaciones" BITMAP "BB_UBICACIONES";
      GROUP oGrL2 SIZE 80,65 top ROUND ACTION Ubicaciones("L") TOOLTIP "Gestión de ubicaciones de libros"

   ADD GROUP oGrL3 RIBBON ::oRebar to OPTION 1 WIDTH 290

   @ 04,05 ADD BUTTON prompt "Propietarios" BITMAP "BB_PROPIET";
      GROUP oGrL3 SIZE 80,65 top ROUND ACTION Agenda("P") TOOLTIP "Gestión de propietarios"

   @ 04,85 ADD BUTTON prompt "Contactos" BITMAP "BB_AGENDA";
      GROUP oGrL3 SIZE 70,65 top ROUND ACTION Agenda("C") TOOLTIP "Gestión de contactos"

   @ 04,155 ADD BUTTON prompt "Compras" BITMAP "BB_COMPRA";
      GROUP oGrL3 SIZE 60,65 top ROUND ACTION CCompras() TOOLTIP "Gestión de centros de compras"

   @ 04,215 ADD BUTTON prompt "Préstamos" BITMAP "BB_NOTAS";
      GROUP oGrL3 SIZE 70,65 top ROUND ACTION Notas("L") TOOLTIP "Gestión de préstamos"

   // 2 Discos
   ADD GROUP oGrD1 RIBBON ::oRebar to OPTION 2 WIDTH 585// PROMPT "Libros"

   @ 04,05 ADD BUTTON prompt "Discos" BITMAP "BB_DISCOS";
      GROUP oGrD1 SIZE 60,65 top ROUND ACTION Discos() TOOLTIP "Gestión de discos"

   @ 04,65 ADD BUTTON prompt "Canciones" BITMAP "BB_MCANCIONES";
      GROUP oGrD1 SIZE 70,65 top ROUND ACTION Canciones() TOOLTIP "Gestión de canciones"

   @ 04,135 ADD BUTTON prompt "Intérpretes" BITMAP "BB_MINTERP";
      GROUP oGrD1 SIZE 70,65 top ROUND ACTION Autores("I") TOOLTIP "Gestión de escritores"

   @ 04,205 ADD BUTTON prompt "Compositores" BITMAP "BB_MCOMPOSI";
      GROUP oGrD1 SIZE 85,65 top ROUND ACTION Autores("C") TOOLTIP "Gestión de compositores"

   @ 04,285 ADD BUTTON prompt "Directores" BITMAP "BB_MDIRECC";
      GROUP oGrD1 SIZE 70,65 top ROUND ACTION Autores("D") TOOLTIP "Gestión de directores"

   @ 04,355 ADD BUTTON prompt "Productoras" BITMAP "BB_MEDITOR";
      GROUP oGrD1 SIZE 70,65 top ROUND ACTION Editores("D") TOOLTIP "Gestión de productoras musicales"

   @ 04,425 ADD BUTTON prompt "Colecciones" BITMAP "BB_LCOLECC";
      GROUP oGrD1 SIZE 80,65 top ROUND ACTION Colecciones("D") TOOLTIP "Gestión de colecciones de discos"

   @ 04,505 ADD BUTTON prompt "Soportes" BITMAP "BB_SOPORTES";
      GROUP oGrD1 SIZE 70,65 top ROUND ACTION Soportes() TOOLTIP "Gestión de soportes de discos"

   ADD GROUP oGrD2 RIBBON ::oRebar to OPTION 2 WIDTH 150

   @ 04,05 ADD BUTTON prompt "Géneros" BITMAP "BB_MATERIAS";
      GROUP oGrD2 SIZE 60,65 top ROUND ACTION Materias("M") TOOLTIP "Gestión de generos musicales"

   @ 04,65 ADD BUTTON prompt "Ubicaciones" BITMAP "BB_UBICACIONES";
      GROUP oGrD2 SIZE 80,65 top ROUND ACTION Ubicaciones("M") TOOLTIP "Gestión de ubicaciones de discos"

   ADD GROUP oGrD3 RIBBON ::oRebar to OPTION 2 WIDTH 290

   @ 04,05 ADD BUTTON prompt "Propietarios" BITMAP "BB_PROPIET";
      GROUP oGrD3 SIZE 80,65 top ROUND ACTION Agenda("P") TOOLTIP "Gestión de propietarios"

   @ 04,85 ADD BUTTON prompt "Contactos" BITMAP "BB_AGENDA";
      GROUP oGrD3 SIZE 70,65 top ROUND ACTION Agenda("C") TOOLTIP "Gestión de contactos"

   @ 04,155 ADD BUTTON prompt "Compras" BITMAP "BB_COMPRA";
      GROUP oGrD3 SIZE 60,65 top ROUND ACTION CCompras() TOOLTIP "Gestión de centros de compras"

   @ 04,215 ADD BUTTON prompt "Préstamos" BITMAP "BB_NOTAS";
      GROUP oGrD3 SIZE 70,65 top ROUND ACTION Notas("D") TOOLTIP "Gestión de préstamos"

   // 3 Videos
   ADD GROUP oGrV1 RIBBON ::oRebar to OPTION 3 WIDTH 430// PROMPT "Videos"

   @ 04,05 ADD BUTTON prompt "Videos" BITMAP "BB_VIDEOS";
      GROUP oGrV1 SIZE 60,65 top ROUND ACTION Videos() TOOLTIP "Gestión de videos"

   @ 04,65 ADD BUTTON prompt "Actores" BITMAP "BB_VACTOR";
      GROUP oGrV1 SIZE 60,65 top ROUND ACTION Autores("R") TOOLTIP "Gestión de actores y actrices"

   @ 04,125 ADD BUTTON prompt "Directores" BITMAP "BB_VDIRECC";
      GROUP oGrV1 SIZE 70,65 top ROUND ACTION Autores("T") TOOLTIP "Gestión de directores de cine"

   @ 04,195 ADD BUTTON prompt "Fotografía" BITMAP "BB_VFOTO";
      GROUP oGrV1 SIZE 70,65 top ROUND ACTION Autores("F") TOOLTIP "Gestión de directores de fotografía"

   @ 04,265 ADD BUTTON prompt "Productoras" BITMAP "BB_VEDITOR";
      GROUP oGrV1 SIZE 80,65 top ROUND ACTION Editores("V") TOOLTIP "Gestión de productoras cinematográficas"

   @ 04,345 ADD BUTTON prompt "Colecciones" BITMAP "BB_LCOLECC";
      GROUP oGrV1 SIZE 80,65 top ROUND ACTION Colecciones("V") TOOLTIP "Gestión de colecciones de videos"

   ADD GROUP oGrV2 RIBBON ::oRebar to OPTION 3 WIDTH 150

   @ 04,05 ADD BUTTON prompt "Géneros" BITMAP "BB_MATERIAS";
      GROUP oGrV2 SIZE 60,65 top ROUND ACTION Materias("V") TOOLTIP "Gestión de generos cinematográficos"

   @ 04,65 ADD BUTTON prompt "Ubicaciones" BITMAP "BB_UBICACIONES";
      GROUP oGrV2 SIZE 80,65 top ROUND ACTION Ubicaciones("V") TOOLTIP "Gestión de ubicaciones de videos"

   ADD GROUP oGrV3 RIBBON ::oRebar to OPTION 3 WIDTH 290

   @ 04,05 ADD BUTTON prompt "Propietarios" BITMAP "BB_PROPIET";
      GROUP oGrV3 SIZE 80,65 top ROUND ACTION Agenda("P") TOOLTIP "Gestión de propietarios"

   @ 04,85 ADD BUTTON prompt "Contactos" BITMAP "BB_AGENDA";
      GROUP oGrV3 SIZE 70,65 top ROUND ACTION Agenda("C") TOOLTIP "Gestión de contactos"

   @ 04,155 ADD BUTTON prompt "Compras" BITMAP "BB_COMPRA";
      GROUP oGrV3 SIZE 60,65 top ROUND ACTION CCompras() TOOLTIP "Gestión de centros de compras"

   @ 04,215 ADD BUTTON prompt "Préstamos" BITMAP "BB_NOTAS";
      GROUP oGrV3 SIZE 70,65 top ROUND ACTION Notas("V") TOOLTIP "Gestión de préstamos"

   ADD GROUP oGrS1 RIBBON ::oRebar to OPTION 4 WIDTH 280 prompt "Software"

   @ 04,05 ADD BUTTON prompt "Software" BITMAP "BB_SOFTWARE";
      GROUP oGrS1 SIZE 60,65 top ROUND ACTION Software() TOOLTIP "Gestión de software"

   @ 04,65 ADD BUTTON prompt "Compañias" BITMAP "BB_SEDITOR";
      GROUP oGrS1 SIZE 70,65 top ROUND ACTION Editores("S") TOOLTIP "Gestión de compañías de software"

   @ 04,135 ADD BUTTON prompt "Materias" BITMAP "BB_MATERIAS";
      GROUP oGrS1 SIZE 60,65 top ROUND ACTION Materias("S") TOOLTIP "Gestión de materias de software"

   @ 04,195 ADD BUTTON prompt "Ubicaciones" BITMAP "BB_UBICACIONES";
      GROUP oGrS1 SIZE 80,65 top ROUND ACTION Ubicaciones("S") TOOLTIP "Gestión de ubicaciones de software"

   ADD GROUP oGrI1 RIBBON ::oRebar to OPTION 4 WIDTH 130 prompt "Internet"

   @ 04,05 ADD BUTTON prompt "Internet" BITMAP "BB_INTERNET";
      GROUP oGrI1 SIZE 60,65 top ROUND ACTION Internet() TOOLTIP "Gestión de direcciones de internet"

   @ 04,65 ADD BUTTON prompt "Materias" BITMAP "BB_MATERIAS";
      GROUP oGrI1 SIZE 60,65 top ROUND ACTION Materias("I") TOOLTIP "Gestión de materias de internet"

   ADD GROUP oGrS2 RIBBON ::oRebar to OPTION 4 WIDTH 290

   @ 04,05 ADD BUTTON prompt "Propietarios" BITMAP "BB_PROPIET";
      GROUP oGrS2 SIZE 80,65 top ROUND ACTION Agenda("P") TOOLTIP "Gestión de propietarios"

   @ 04,85 ADD BUTTON prompt "Contactos" BITMAP "BB_AGENDA";
      GROUP oGrS2 SIZE 70,65 top ROUND ACTION Agenda("C") TOOLTIP "Gestión de contactos"

   @ 04,155 ADD BUTTON prompt "Compras" BITMAP "BB_COMPRA";
      GROUP oGrS2 SIZE 60,65 top ROUND ACTION CCompras() TOOLTIP "Gestión de centros de compras"

   @ 04,215 ADD BUTTON prompt "Préstamos" BITMAP "BB_NOTAS";
      GROUP oGrS2 SIZE 70,65 top ROUND ACTION Notas("S") TOOLTIP "Gestión de préstamos"

   ADD GROUP oGrA1 RIBBON ::oRebar to OPTION 5 WIDTH 350// PROMPT "Azeta"

   @ 04,05 ADD BUTTON prompt "Documentos" BITMAP "BB_DOCUMENT";
      GROUP oGrA1 SIZE 80,65 top ROUND ACTION AztArticulos() TOOLTIP "Gestión de documentos"

   @ 04,85 ADD BUTTON prompt "Materias" BITMAP "BB_MATERIAS";
      GROUP oGrA1 SIZE 60,65 top ROUND ACTION AztMaterias() TOOLTIP "Gestión de materias"

   @ 04,145 ADD BUTTON prompt "Etiquetas" BITMAP "BB_TAG";
      GROUP oGrA1 SIZE 60,65 top ROUND ACTION AztEtiquetas() TOOLTIP "Gestión de etiquetas"

   @ 04,205 ADD BUTTON prompt "Autores" BITMAP "BB_LAUTOR";
      GROUP oGrA1 SIZE 60,65 top ROUND ACTION AztAutores() TOOLTIP "Gestión de autores de documentos"

   @ 04,265 ADD BUTTON prompt "Publicaciones" BITMAP "BB_PUBLICAC";
      GROUP oGrA1 SIZE 80,65 top ROUND ACTION AztPublicaciones() TOOLTIP "Gestión de publicaciones"

   ADD GROUP oGrA2 RIBBON ::oRebar to OPTION 5 WIDTH 150// PROMPT "Azeta"

   @ 04,05 ADD BUTTON prompt "Tipos" BITMAP "BB_TIPODOC";
      GROUP oGrA2 SIZE 60,65 top ROUND ACTION AztTipodoc() TOOLTIP "Gestión de tipos de documento"

   @ 04,65 ADD BUTTON prompt "Ubicaciones" BITMAP "BB_ZUBICACI";
      GROUP oGrA2 SIZE 80,65 top ROUND ACTION AztUbicaciones() TOOLTIP "Gestión de ubicaciones"

   ADD GROUP oGrU1 RIBBON ::oRebar to OPTION 6 WIDTH 220// PROMPT "Utilidades"

   @ 04,05 ADD BUTTON prompt "Configuración" BITMAP "BB_U_CONFIG";
      GROUP oGrU1 SIZE 80,65 top ROUND ACTION UtConfigApp(.F.) TOOLTIP "Configuración del programa"

   @ 04,85 ADD BUTTON prompt "Importar" BITMAP "BB_U_IMPORT";
      GROUP oGrU1 SIZE 60,65 top ROUND ACTION UtImportarVersion() TOOLTIP "Importar datos desde una versión anterior a la 6.0"

   @ 04,145 ADD BUTTON prompt "Reordenar" BITMAP "BB_U_REORDER";
      GROUP oGrU1 SIZE 70,65 top ROUND ACTION UtReordenarCodigos() TOOLTIP "Reordenar códigos de ejemplares" WHEN ::lCodReord

   ADD GROUP oGrU2 RIBBON ::oRebar to OPTION 6 WIDTH 350// PROMPT "Utilidades"

   @ 04,05 ADD BUTTON prompt "Reindexar" BITMAP "BB_INDEX";
      GROUP oGrU2 SIZE 70,65 top ROUND ACTION (Ut_Actualizar(.F.), Ut_Indexar(.T.), Ut_AztActualizar(.F.), Ut_AztIndexar(.T.)) TOOLTIP "Regenerar índices de los ficheros de datos"

   @ 04,75 ADD BUTTON prompt "Copiar" BITMAP "BB_U_BBTC";
      GROUP oGrU2 SIZE 60,65 top ROUND ACTION ZipBackup(oApp():cDbfPath, oApp():cZipPath()) TOOLTIP "Haced copia de seguridad de los ficheros de datos de Cuaderno de Bitácora"
   
   @ 04,135 ADD BUTTON prompt "Copiar" BITMAP "BB_U_BAZT";
      GROUP oGrU2 SIZE 60,65 top ROUND ACTION ZipBackup(oApp():cAztPath, oApp():cAztZipPath()) TOOLTIP "Haced copia de seguridad de los ficheros de datos de Azeta"

   @ 04,200 ADD BUTTON prompt "Restaurar" BITMAP "BB_U_RBTC";
      GROUP oGrU2 SIZE 70,65 top ROUND ACTION ZipRestore(oApp():cDbfPath, oApp():cZipPath()) TOOLTIP "Restaurar copia de los ficheros de datos de Cuaderno de Bitácora"

   @ 04,275 ADD BUTTON prompt "Restaurar" BITMAP "BB_U_RAZT";
      GROUP oGrU2 SIZE 70,65 top ROUND ACTION ZipRestore(oApp():cAztPath, oApp():cAztZipPath()) TOOLTIP "Restaurar copia de los ficheros de datos de Azeta"

   ADD GROUP oGrU3 RIBBON ::oRebar to OPTION 6 WIDTH 260// PROMPT "Ayuda"

   @ 04,05 ADD BUTTON prompt "Ayuda" BITMAP "BB_AYUDA";
      GROUP oGrU3 SIZE 60,65 top ROUND ACTION (HelpIndex(), HelpTopic( "Introducción")) ;
      TOOLTIP "Ayuda del programa"

   @ 04,65 ADD BUTTON prompt "Truco" BITMAP "BB_TIP";
      GROUP oGrU3 SIZE 60,65 top ROUND ACTION TipOfDay('.\tips.ini', .F.) ;
      TOOLTIP "Truco del día"

   @ 04,125 ADD BUTTON prompt "Web" BITMAP "BB_ALANIT";
      GROUP oGrU3 SIZE 60,65 top ROUND ACTION GoWeb('http://www.alanit.com') ;
      TOOLTIP "Visitar la web de alanit.com"

   @ 04,185 ADD BUTTON prompt "Acerca de" BITMAP "BB_ACERCADE";
      GROUP oGrU3 SIZE 60,65 top ROUND ACTION AppAcercade(.F.) ;
      TOOLTIP "Acerca de Cuaderno de Bitácora"

   ::oRebar:SetOption(nOption)
 
return self
//______________________________________________________________________________
/*
 * función .: TApplication:BuildPopMenuTablas()
 * prec ....: True
 * post ....: Construye el menú popup de tablas auxiliares.


method BuildPopMenuTablas() class TApplication

   MENU ::oPopMenuTablas POPUP
      MENUITEM i18n( "&1 Tablas Auxiliares de Libros" )
         MENU
            MENUITEM i18n( "&1 Escritores" ) ;
               ACTION Autores( "E" ) ;
               MESSAGE i18n("Gestión de Escritores")
            SEPARATOR
            MENUITEM i18n( "&2 Editoriales" ) ;
               ACTION Editores( "L" ) ;
               MESSAGE i18n("Gestión de Editoriales")
            MENUITEM i18n( "&3 Colecciones" ) ;
               ACTION Colecciones( "L" ) ;
               MESSAGE i18n("Gestión de Colecciones de Libros")
         ENDMENU
      MENUITEM i18n( "&2 Tablas Auxiliares de Discos" )
         MENU
            MENUITEM i18n( "&1 Intérpretes" ) ;
               ACTION Autores( "I" ) ;
               MESSAGE i18n("Gestión de Intérpretes Musicales")
            MENUITEM i18n( "&2 Compositores" ) ;
               ACTION Autores( "C" ) ;
               MESSAGE i18n("Gestión de Compositores Musicales")
            MENUITEM i18n( "&3 Directores" ) ;
               ACTION Autores( "D" ) ;
               MESSAGE i18n("Gestión de Directores Musicales")
            SEPARATOR
            MENUITEM i18n( "&4 Productoras" ) ;
               ACTION Editores( "D" ) ;
               MESSAGE i18n("Gestión de Productoras de discos")
            MENUITEM i18n( "&5 Colecciones" ) ;
               ACTION Colecciones( "D" ) ;
               MESSAGE i18n("Gestión de Colecciones de Libros")
         ENDMENU
      MENUITEM i18n( "&3 Tablas Auxiliares de Vídeos" )
         MENU
            MENUITEM i18n( "&1 Directores de Cine" ) ;
               ACTION Autores( "T" ) ;
               MESSAGE i18n("Gestión de Directores de Cine")
            MENUITEM i18n( "&2 Actores/Actrices" ) ;
               ACTION Autores( "R" ) ;
               MESSAGE i18n("Gestión de Actores/Actrices")
            MENUITEM i18n( "&3 Directores de Fotografía" ) ;
               ACTION Autores( "F" ) ;
               MESSAGE i18n("Gestión de Directores de Fotografía")
            SEPARATOR
            MENUITEM i18n( "&4 Productoras" ) ;
               ACTION Editores( "V" ) ;
               MESSAGE i18n("Gestión de Productoras de cine")
            MENUITEM i18n( "&5 Colecciones" ) ;
               ACTION Colecciones( "V" ) ;
               MESSAGE i18n("Gestión de Colecciones de Vídeos")
         ENDMENU
      MENUITEM i18n( "&4 Tablas Auxiliares de Software" )
         MENU
            MENUITEM i18n( "&1 Compañías" ) ;
               ACTION Editores( "S" ) ;
               MESSAGE i18n("Gestión de Compañías de Software")
         ENDMENU
      MENUITEM i18n( "&5 Tablas Auxiliares de Contactos" )
         MENU
            MENUITEM i18n( "&1 Categorías de Ocio" ) ;
               ACTION Categorias( "O" ) ;
               MESSAGE i18n("Gestión de Categorías de Ocio")
         ENDMENU
      SEPARATOR
      MENUITEM i18n( "&6 Tabla auxiliar de Idiomas" ) ;
         ACTION Idiomas() ;
         MESSAGE i18n("Gestión de Idiomas")
   ENDMENU

return ::oPopMenuTablas
*/
function BuildPopMenuTablas()

   local oPopMenuTablas, oReturn

   menu oPopMenuTablas POPUP 2010
   MENUITEM i18n( "&1 Tablas Auxiliares de Libros" )
   menu
   MENUITEM i18n( "&1 Escritores" ) ;
      ACTION Autores( "E" ) ;
      message i18n("Gestión de Escritores")
   SEPARATOR
   MENUITEM i18n( "&2 Editoriales" ) ;
      ACTION Editores( "L" ) ;
      message i18n("Gestión de Editoriales")
   MENUITEM i18n( "&3 Colecciones" ) ;
      ACTION Colecciones( "L" ) ;
      message i18n("Gestión de Colecciones de Libros")
   ENDMENU
   MENUITEM i18n( "&2 Tablas Auxiliares de Discos" )
   menu
   MENUITEM i18n( "&1 Intérpretes" ) ;
      ACTION Autores( "I" ) ;
      message i18n("Gestión de Intérpretes Musicales")
   MENUITEM i18n( "&2 Compositores" ) ;
      ACTION Autores( "C" ) ;
      message i18n("Gestión de Compositores Musicales")
   MENUITEM i18n( "&3 Directores" ) ;
      ACTION Autores( "D" ) ;
      message i18n("Gestión de Directores Musicales")
   SEPARATOR
   MENUITEM i18n( "&4 Productoras" ) ;
      ACTION Editores( "D" ) ;
      message i18n("Gestión de Productoras de discos")
   MENUITEM i18n( "&5 Colecciones" ) ;
      ACTION Colecciones( "D" ) ;
      message i18n("Gestión de Colecciones de Libros")
   ENDMENU
   MENUITEM i18n( "&3 Tablas Auxiliares de Vídeos" )
   menu
   MENUITEM i18n( "&1 Directores de Cine" ) ;
      ACTION Autores( "T" ) ;
      message i18n("Gestión de Directores de Cine")
   MENUITEM i18n( "&2 Actores/Actrices" ) ;
      ACTION Autores( "R" ) ;
      message i18n("Gestión de Actores/Actrices")
   MENUITEM i18n( "&3 Directores de Fotografía" ) ;
      ACTION Autores( "F" ) ;
      message i18n("Gestión de Directores de Fotografía")
   SEPARATOR
   MENUITEM i18n( "&4 Productoras" ) ;
      ACTION Editores( "V" ) ;
      message i18n("Gestión de Productoras de cine")
   MENUITEM i18n( "&5 Colecciones" ) ;
      ACTION Colecciones( "V" ) ;
      message i18n("Gestión de Colecciones de Vídeos")
   ENDMENU
   MENUITEM i18n( "&4 Tablas Auxiliares de Software" )
   menu
   MENUITEM i18n( "&1 Compañías" ) ;
      ACTION Editores( "S" ) ;
      message i18n("Gestión de Compañías de Software")
   ENDMENU
   MENUITEM i18n( "&5 Tablas Auxiliares de Contactos" )
   menu
   MENUITEM i18n( "&1 Categorías de Ocio" ) ;
      ACTION Categorias( "O" ) ;
      message i18n("Gestión de Categorías de Ocio")
   ENDMENU
   SEPARATOR
   MENUITEM i18n( "&6 Tabla auxiliar de Idiomas" ) ;
      ACTION Idiomas() ;
      message i18n("Gestión de Idiomas")
   ENDMENU

return oPopMenuTablas
/*
 * función .: TApplication:ActivatePopMenuTablas()
 * prec ....: True
 * post ....: Activa el menú popup de tablas auxiliares.
*/

function ActivatePopMenuTablas( oBtn ) // class TApplication

   local oMenu

   local aPoint[2]
   local nId:=9  // Número de Boton
   local oPopMenuTablas := BuildPopMenuTablas()

   aPoint[1]:=44
   aPoint[2]:=(44*(nID-1)) + 10 // + ((36/2.5)*(nID-1)) //-25

   oPopMenuTablas:activate(aPoint[1],aPoint[2],oApp():oWndMain,.T.)

return nil


/*
 * función .: TApplication:CheckDirs()
 * prec ....: True
 * post ....: Controla la existencia de los subdirectorios necesarios.
*/

method CheckDirs() class TApplication

   if !lIsDir( Lower( ::cDbfPath ) )
      lMkDir( Lower( ::cDbfPath ) )
   end

   if !lIsDir( Lower( ::cAztPath ) )
      lMkDir( Lower( ::cAztPath ) )
   endif

   if !lIsDir( Lower( ::cZipPath ) )
      lMkDir( Lower( ::cZipPath ) )
   end
   
   if !lIsDir( Lower( ::cAztZipPath ) )
         lMkDir( Lower( ::cAztZipPath ) )
      end

   if !lIsDir( Lower( ::cBtcPath ) )
      lMkDir( Lower( ::cBtcPath ) )
   end

   if !lIsDir( Lower( ::cXmlPath ) )
      lMkDir( Lower( ::cXmlPath ) )
   end
   
   if !lIsDir( Lower( ::cPdfPath ) )
      lMkDir( Lower( ::cPdfPath ) )
   end
   if !lIsDir( Lower( ::cAztPdfPath ) )
      lMkDir( Lower( ::cAztPdfPath ) )
   end
   
   //if !lIsDir( Lower( ::cAztPdfPath ) )
   //   lMkDir( Lower( ::cAztPdfPath ) )
   //end

   if !lIsDir( Lower( ::cXlsPath ) )
      lMkDir( Lower( ::cXlsPath ) )
   endif
   
   //if !lIsDir( Lower( ::cAztXlsPath ) )
   //      lMkDir( Lower( ::cAztXlsPath ) )
   //endif

   // 2º intento, => no ha podido crear la carpeta => no existe la ruta
   if !lIsDir( Lower( ::cDbfPath ) )
      msgAlert( i18n("No se han podido encontrar los ficheros de la " + ;
         "aplicación en la ruta indicada en la configuración " + ;
         "del programa" + CRLF + "Por favor, indique la " + ;
         "ubicación correcta en la casilla 'DATOS'") )
      UtConfigApp(.T.)
   end

return Self


/*
 * función .: TApplication:CheckFiles()
 * prec ....: True
 * post ....: Controla la existencia de los ficheros necesarios.
*/

method CheckFiles() class TApplication

   local i
   local nLen
   local aFiles   := {}
   local cOldVersion := GetPvProfString("Config", "Version","", oApp():cIniFile)

   aFiles :=  { "agenda.dbf", "agenda.cdx", "agenda.fpt",;
      "autores.dbf", "autores.cdx",;
      "cancion.dbf", "cancion.cdx",;
      "candisc.dbf", "candisc.cdx",;
      "categori.dbf", "categori.cdx",;
      "colibros.dbf", "colibros.cdx",;
      "editores.dbf", "editores.cdx",;
      "idiomas.dbf", "idiomas.cdx",;
      "intermed.dbf",;
      "internet.dbf", "internet.cdx", "internet.fpt",;
      "libros.dbf", "libros.cdx", "libros.fpt",;
      "materias.dbf", "materias.cdx",;
      "musica.dbf", "musica.cdx", "musica.fpt",;
      "notas.dbf", "notas.cdx",;
      "soporte.dbf", "soporte.cdx",;
      "software.dbf", "software.cdx", "software.fpt",;
      "videos.dbf", "videos.cdx", "videos.fpt",;
      "ubicaci.dbf", "ubicaci.cdx"                  }

   nLen := Len( aFiles )

   for i := 1 to nLen
      if !File( ::cDbfPath + aFiles[i] )
         Ut_Actualizar(.F.)
         Ut_Indexar(.F.)
         exit
      end
   next
   // compruebo la versión
   if cOldversion != ::cVersion
      MsgAlert("Se ha detectado un cambio de versión."+CRLF+"A continuación se actualizarán los ficheros de la aplicación.")
      DelIniSection( "Browse", oApp():cIniFile )
      DelIniSection( "Report", oApp():cIniFile )
      Ut_Actualizar(.F.)
      Ut_Indexar(.T.)
   endif
   if ! Db_OpenAll() .OR. ! Db_AztOpenAll(.F.)
      retu nil
   else
      oAGet:Load()
      dbCloseAll()
   endif
   WritePProString("Config","Version",LTrim(::cVersion),oApp():cIniFile)

return Self

method CheckAztFiles() class tApplication

   local i      := 0
   local nLen   := 0
   local aFiles := { "articulo.dbf", "articulo.fpt", "articulo.cdx",;
      "autores.dbf", "autores.cdx",;
      "etiquetas.dbf", "etiquetas.cdx",;
      "tipodoc.dbf", "tipodoc.cdx",;
      "materias.dbf", "materias.cdx",;
      "publica.dbf", "publica.cdx",;
      "ubicaci.dbf", "ubicaci.cdx"   }

   nLen := Len( aFiles )
   for i := 1 to nLen
      if !File( ::cAztPath + aFiles[i] )
         if msgYesNo("Fichero de AZETA no encontrado. ¿ Desea configurar la ruta a los archivos de AZETA ?")
				UtConfigApp(.f., 3)
			endif
         Ut_AztActualizar(.F.)
         Ut_AztIndexar(.F.)
         exit
      end
   next

return Self
/*
 * función .: TApplication:ExitFromBtn()
 * prec ....: True
 * post ....: Cierra el programa desde el botón de la barra de botones.
*/

method ExitFromBtn() class TApplication

   if ModalSobreFsdi()
      return nil
   end if

   if msgYesNo( i18n("¿ Desea finalizar el programa ?") )
      if ::lRibbon
         WritePProString("Config","Ribbon",::oRebar:nOption,oApp():cIniFile)
      endif
      ::oWndMain:End()
   end

return nil


/*
 * función .: TApplication:ExitFromX()
 * prec ....: True
 * post ....: Cierra el programa desde la X de la ventana principal.
*/

method ExitFromX() class TApplication

   if ModalSobreFsdi()
      return .F.
   end if

   SetWinCoors( ::oWndMain, ::cIniFile )

return .T.


/*
 * función .: TApplication:ExitFromSource()
 * prec ....: True
 * post ....: Cierra el programa desde código fuente.
*/

method ExitFromSource() class TApplication

   ::oWndMain:bValid := {|| SetWinCoors( ::oWndMain, ::cIniFile ), .T. }
   ::oWndMain:End()

return nil


/*
 * función .: TApplication:End()
 * prec ....: True
 * post ....: Ejecuta las sentencias de cierre del programa.
*/

method end() class TApplication

   if ::oDlg != nil
      if ::nEdit > 0
         return nil
      elseif msgYesNo( i18n("¿Desea finalizar el programa?") )
         ::oDlg:End()
         SetWinCoors( ::oWndMain, ::cIniFile )
         ::oWndMain:End()
      end if
   else
      if ::cUser != "***"
         if msgYesNo( i18n("¿Desea finalizar el programa?") )
            SetWinCoors( ::oWndMain, ::cIniFile )
            ::oWndMain:End()
         end if
      else
         ::oWndMain:End()
      end if
   end if
   // ResAllFree()

return nil


/*
 * función .: oApp()
 * prec ....: True
 * post ....: Devuelve el objeto oApp del programa para evitar un warning.
*/

function oApp()
return oApp

/*
 * función .: hAGet()
 * prec ....: True
 * post ....: Devuelve el objeto hAGet del programa para evitar un warning.
*/

function oAGet()
return oAGet


/*
 * función .: AppAcercade()
 * prec ....: lForced != NIL
 * post ....: Muestra el diálogo 'acerca de' del programa.
*/


function AppAcercade( lForced )

   local oDlg
   local oBmp
   local oSay
   local oTel
   local oURL1
   local oURL2
   local cCfg, cAAAA, cBBBB, cCCCC, CDDDD
   local lOtravez   := GetIni( , "Config", "Again", "SI" ) == "SI"

   //if F0F4(lForced) //.and. ! lForced
   // retu nil
   //endif
   if lForced .AND. lOtravez == .F.
      retu nil
   endif

   IF oApp():thefull
      if ! File( oApp():cExePath + "user.nit" )
         MsgAlert("Fichero de registro no encontrado."+CRLF+CRLF+"Solicite su fichero de registro por correo electrónico a la dirección correo.alanit@gmail.com")
         retu nil
      endif
      DEFINE DIALOG oDlg;
         TITLE i18n("acerca de...");
         from  0, 0 to 242, 330 PIXEL;
         color CLR_BLACK, CLR_WHITE
      oDlg:SetFont(oApp():oFont)

      @ 04,26 BITMAP oBmp RESOURCE 'acercade' ;
         SIZE 110, 30 OF oDlg PIXEL NOBORDER

      @ 32,13 say oSay;
         prompt i18n("versión")+" "+oApp:cVersion+" "+oApp:cBuild;
         SIZE 140,15 PIXEL;
         OF oDlg;
         color CLR_GRAY, CLR_WHITE;
         CENTERED

      @ 40,13 say oTel;
         prompt oApp:cCopyright;
         SIZE 140,9 PIXEL;
         OF oDlg;
         color CLR_GRAY, CLR_WHITE;
         CENTERED

      // @ 52, 10 to 100, 156 PIXEL OF oDlg

      @ 52,20 say oSay;
         prompt " "+i18n("Programa registrado por:")+" ";
         SIZE 80,9 PIXEL;
         OF oDlg;
         color CLR_GRAY, CLR_WHITE
      @ 65,13 say oSay     ;
         prompt cBBBB      ;
         SIZE 140,9 PIXEL  ;
         OF oDlg;
         color GetSysColor(2), CLR_WHITE;
         CENTERED
      @ 75,13 say oSay     ;
         prompt cCCCC      ;
         SIZE 140,9 PIXEL  ;
         OF oDlg ;
         color GetSysColor(2), CLR_WHITE;
         CENTERED
      @ 85,13 say oSay     ;
         prompt cDDDD      ;
         SIZE 140,9 PIXEL  ;
         OF oDlg;
         color GetSysColor(2), CLR_WHITE;
         CENTERED
      @ 106,13 CHECKBOX lOtravez;
         prompt i18n("Mostrar la próxima vez que arranque el programa");
         SIZE 130, 9 PIXEL;
         OF oDlg;
         color GetSysColor(2), CLR_WHITE

      ACTIVATE DIALOG oDlg ;
         on INIT ( DlgCenter( oDlg, oApp:oWndMain ) );
         on CLICK oDlg:End()

      SetIni( , "Config", "Again", iif( lOtravez, "SI", "NO" ) )
   else
      Registrame()
   endif

return nil

function Donacion()

   local oDlg
   local oBmp01
   local oBmp02
   local oSay
   local oTel
   local lDonativo := .F.
   local oFontBold := TFont():New( GetDefaultFontName(), 0, GetDefaultFontHeight(),,.T. )

   DEFINE DIALOG oDlg;
      TITLE i18n("Donación");
      from  0, 0 to 260, 324 PIXEL;
      color CLR_BLACK, CLR_WHITE
   oDlg:SetFont(oApp():oFont)

   @ 00,22 BITMAP oBmp01 OF oDlg;
      RESOURCE 'acercade';
      SIZE 110, 30 PIXEL;
      NOBORDER

   @ 32,10 say oSay;
      prompt i18n("versión")+" "+oApp:cVersion+" "+oApp:cBuild;
      SIZE 140,15 PIXEL;
      OF oDlg;
      color CLR_GRAY, CLR_WHITE;
      CENTERED

   @ 40,10 say oTel;
      prompt oApp():cCopyright ;
      SIZE 140,9 PIXEL;
      OF oDlg;
      color CLR_GRAY, CLR_WHITE;
      CENTERED

   @ 50, 10 say oSay;
      prompt i18n("¡ Gracias por utilizar Cuaderno de Bitácora !");
      SIZE 140, 9 PIXEL;
      OF oDlg;
      color CLR_BLACK, CLR_WHITE;
      CENTERED FONT oFontBold

   @ 60, 12 say oSay;
      prompt i18n("He pasado muchas noches creando este programa. Si es útil para ti " + ;
      "puedes contribuir a su desarrollo realizando un donativo. Eso me animará a seguir mejorándolo."+CRLF+CRLF+;
      "Al realizar el donativo recibirás una clave de donante que desactivará este mensaje y pondrá tu nombre en todos los listados del programa.");
      SIZE 140, 56 PIXEL;
      OF oDlg;
      color CLR_BLACK, CLR_WHITE

   @ 110, 75 BUTTON i18n("Donativo") OF oDlg;
      SIZE 36,12 PIXEL;
      ACTION ( lDonativo := .T., oDlg:End() )

   @ 110, 115 BUTTON i18n("Ahora no") OF oDlg;
      SIZE 36,12 PIXEL;
      ACTION oDlg:End()

   ACTIVATE DIALOG oDlg ;
      on INIT ( DlgCenter( oDlg, oApp:oWndMain ) )

   oFontBold:End()
   if lDonativo
      GoWeb( oApp():cUrlDonativo )
   endif

return nil
//___ manejo de fuentes © Paco García 2006 ____________________________________//

#pragma BEGINDUMP
#include "Windows.h"
#include "hbapi.h"

HB_FUNC( GETDEFAULTFONTNAME )
{
   LOGFONT lf;
   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
   hb_retc( lf.lfFaceName );
}

HB_FUNC( GETDEFAULTFONTHEIGHT )
{
   LOGFONT lf;
   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
   hb_retni( lf.lfHeight );
}

HB_FUNC( GETDEFAULTFONTWIDTH )
{
   LOGFONT lf;
   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
   hb_retni( lf.lfWidth );
}

HB_FUNC( GETDEFAULTFONTITALIC )
{
   LOGFONT lf;
   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
   hb_retl( (BOOL) lf.lfItalic );
}

HB_FUNC( GETDEFAULTFONTUNDERLINE )
{
   LOGFONT lf;
   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
   hb_retl( (BOOL) lf.lfUnderline );
}

HB_FUNC( GETDEFAULTFONTBOLD )
{
   LOGFONT lf;
   GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
   hb_retl( (BOOL) ( lf.lfWeight == 700 ) );
}

HB_FUNC( GETDEFAULTFONTSTRIKEOUT )
{
      LOGFONT lf;
      GetObject( ( HFONT ) GetStockObject( DEFAULT_GUI_FONT )  , sizeof( LOGFONT ), &lf );
      hb_retl( (BOOL) lf.lfStrikeOut );
}

#pragma ENDDUMP

function ResizeWndMain()

   local aClient
   
   if oApp():oDlg != nil
      aClient := GetClientRect (oApp():oWndMain:hWnd )
      oApp():oDlg:SetSize( aClient[4], aClient[3] - oApp():nBarHeight + iif(oApp():lRibbon, 2, -4) - oApp():oWndMain:oMsgBar:nHeight )
      oApp():oDlg:Refresh()
      oApp():oSplit:SetSize( oApp():oSplit:nWidth, oApp():oDlg:nHeight)
      oApp():oSplit:Refresh()
      if oApp():oGrid != nil
         oApp():oGrid:SetSize( aClient[4]-oApp():oGrid:nLeft, oApp():oDlg:nHeight - 26 )
         oApp():oGrid:Refresh()
         oApp():oTab:nTop := oApp():oDlg:nHeight - 26
         oApp():oTab:Refresh()
      endif
      oApp():oWndMain:oMsgBar:Refresh()
      // SysRefresh()
   endif
   
   IF ! oApp():thefull
      Registrame()
   ENDIF

return nil
