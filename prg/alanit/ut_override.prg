#include "FiveWin.ch"

#xcommand OVERRIDE METHOD <!Message!> [IN] CLASS <!Class!> ;
                             WITH [METHOD] <!Method!> [SCOPE <Scope>] => ;
            __clsModMsg( <Class>():classH, #<Message>, @<Method>() )

function Ut_override()
   
   OVERRIDE METHOD New         IN CLASS TApplication WITH TApplicationNew

return nil

Function TApplicationNew()
   local cAAAA, cBBBB, cCCCC, cHHHH, cGGGG1, cGGGG2, cCfg
   local Self := HB_QSelf()

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
   ::cUrlCompra  := "http://www.alanit.com/comprar"
   ::cEmail      := "correo@alanit.com"
   ::cMsgBar     := ::cCopyright + " * alanit software - 2018 "
   ::cHelpFile   := RTrim(TakeOffExt(GetModuleFileName(GetInstance())))+".chm"
   ::nSeconds	  := Seconds()

   if File( ::cExePath + "user.nit" )
      hb_UnZipFile( ::cExePath+"user.nit",NIL,.F.,"deomnirescibilietquibusdamaliis",::cExePath,"user.lic" )
      cCfg  := ::cExePath + "user.lic"
      cAAAA := GetPvProfString( "Usuario", "AAAA", "", cCfg )
      cBBBB := GetPvProfString( "Usuario", "BBBB", "", cCfg )
      cCCCC := GetPvProfString( "Usuario", "CCCC", "", cCfg )
      cHHHH := StrTran( SubStr( cBBBB, 1, 15 ), ' ', '' ) + ;
               StrTran( SubStr( cCCCC, 1, 15 ), ' ', '' )
      if Len(cHHHH) < 20
         ::cUser := Space(15)
      else
         cGGGG1 := F0F3( cHHHH, 'B' )
         cGGGG2 := F0F3( cHHHH, 'D' )
      endif
      // ? cAAAA+CRLF+cBBBB+CRLF+cCCCC+CRLF+cGGGG1+CRLF+cGGGG2
      if cAAAA==cGGGG1 .OR. cAAAA==cGGGG2
         ::cUser := cBBBB
         ::thefull := .t.
			::cEdicion := " Edición registrada"
      else
         ? "Fichero de registro erroneo."+CRLF+"Solicite su clave de registro por correo electrónico a la dirección correo@alanit.com"
         ::cUser := Space(15)
         ::thefull := .f.
			::cEdicion := " Edición gratuita"

      //quit
      endif
      delete File (::cExePath+"user.lic")
   else
      ::cUser := Space(15)
      ::thefull := .f.
		::cEdicion := " Edición gratuita"
   endif
   
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


function F0F3(cKey1, cProgram)

   local i
   local cKey2    := ""
   local cKey3    := ""
   local DNT_1 := "áéíóúqpwoeirutyalskdjfhgzmxncbv1234567890MNBVCXZASDFGHJKLPOIUYTREWQ"
   local DNT_2 := "mnbvcxzasdfghjklpoiuytrewq0987654321QWERTYUIOPLKJHGFDSAZXCVBNM"
   local PCH_1 := "áéíóúqpwoeirutyxncbv1234567890MNBalskdjfhgzmVCXZASDFGHJKLPOIUYTREWQ"
   local PCH_2 := "qpwoeirutyalskdj1234567890MNBVCXZASDFGHJfhgzmxncbvKLPOIUYTREWQ"
   local BTC_1 := "mnbvcáéíóúxzasdfghjklpoiuytrewq0987654321QWERTYUIOPLKJHGFDSAZXCVBNM"
   local BTC_2 := "mnbvcxzasdfghjklpoiuytrewq0987654321QWERTYUIOPLKJHGFDSAZXCVBNM"
   local AZT_1 := "KJHGFDSAZXCVBNQWERTYUIOPLMmnbvcáéíóúxzasdfghjklpoiuytrewq0987654321"
   local AZT_2 := "KJHGFDSAZXCVBNQWERTYUIOPLMmnbvcxzasdfghjklpoiuytrewq0987654321"
   local FDM_1 := "KJHGFDSAZXCVBNQasdfghjklpoiuytrewq0987654321WERTYUIOPLMmnbvcáéíóúxz"
   local FDM_2 := "KJHGFDSAZXCVBNQasdfghjklpoiuytrewq0987654321WERTYUIOPLMmnbvcxz"
   local Str_1, Str_2

   do case
   case cProgram == 'B'
      Str_1 := BTC_1
      Str_2 := BTC_2
   case cProgram == 'P'
      Str_1 := PCH_1
      Str_2 := PCH_2
   case cProgram == 'Z'
      Str_1 := AZT_1
      Str_2 := AZT_2
   case cProgram == 'F'
      Str_1 := FDM_1
      Str_2 := FDM_2
   case cProgram == 'D'
      Str_1 := DNT_1
      Str_2 := DNT_2
   endcase
   cKey2 := ""
   for i := 1 to 20
      cKey2 := cKey2 + LTrim(Str(At(SubStr(cKey1,i,1),Str_1),2))
   next
   cKey2 := Str(Val(SubStr(cKey2,1,10))*123456789)
   cKey3 := ""
   for i := 1 to 20
      cKey3 := cKey3 + SubStr(Str_2,Mod(Val(SubStr(cKey2,Len(cKey2)-i-1,2)),62),1)
   next

return cKey3

function F0F4(lForced)

   local lExit := .F.

   if oApp():cUser == Space(15)
      if Int(hb_Random(5))==0 .OR. ! lForced
         Donacion()
      endif
      lExit := .T.
   endif

return lExit
