//*
// PROYECTO ...: Cuaderno de Bitácora
// COPYRIGHT ..: (c) alanit software
// URL ........: www.alanit.com
//*

#include "Fivewin.ch"

/*_____________________________________________________________________________*/

function msginfo(cText, cCaption)

   local oDlgInfo, oPage
   local oBmp

   default cCaption := oApp():cAppName+oApp():cVersion

   DEFINE DIALOG oDlgInfo RESOURCE "UT_INFO" TITLE cCaption
   oDlgInfo:SetFont(oApp():oFont)

   //REDEFINE PAGES oPage ID 110 OF oDlgInfo ;
   //   DIALOGS "UT_INFO_PAGE"
   //oPage:oFont := oApp():oFont

   REDEFINE say prompt cText ID 10 OF oDlgInfo
   REDEFINE BITMAP oBmp ID 111 OF oDlgInfo RESOURCE "xpinfo" TRANSPARENT

   REDEFINE BUTTON ID IDOK OF oDlgInfo  ;
      ACTION oDlgInfo:End()

   ACTIVATE DIALOG oDlgInfo ;
      on init oDlgInfo:Center( oApp():oWndMain )

return nil

/*_____________________________________________________________________________*/
function msgstop(cText, cCaption)

   local oDlgStop, oPage
   local oBmp

   default cCaption := oApp():cAppName+oApp():cVersion

   DEFINE DIALOG oDlgStop RESOURCE "UT_INFO" TITLE cCaption
   oDlgStop:SetFont(oApp():oFont)

   //REDEFINE PAGES oPage ID 110 OF oDlgStop ;
   //   DIALOGS "UT_INFO_PAGE"
   //oPage:oFont := oApp():oFont

   REDEFINE say prompt cText ID 10 OF oDlgStop
   REDEFINE BITMAP oBmp ID 111 OF oDlgStop RESOURCE "xpstop" TRANSPARENT

   REDEFINE BUTTON ID IDOK OF oDlgStop  ;
      ACTION oDlgStop:End()

   ACTIVATE DIALOG oDlgStop ;
      on init oDlgStop:Center( oApp():oWndMain )

return nil

/*_____________________________________________________________________________*/

function msgAlert(cText,cCaption)

   local oDlgAlert, oPage
   local oBmp

   default cCaption := oApp():cAppName+oApp():cVersion

   DEFINE DIALOG oDlgAlert RESOURCE "UT_INFO" TITLE cCaption
   oDlgAlert:SetFont(oApp():oFont)

   //REDEFINE PAGES oPage ID 110 OF oDlgAlert ;
   //   DIALOGS "UT_INFO_PAGE"
   //oPage:oFont := oApp():oFont

   REDEFINE say prompt cText ID 10 OF oDlgAlert
   REDEFINE BITMAP oBmp ID 111 OF oDlgAlert RESOURCE "xpalert" TRANSPARENT

   REDEFINE BUTTON ID IDOK OF oDlgAlert ;
      ACTION oDlgAlert:End()

   ACTIVATE DIALOG oDlgAlert ;
      on init oDlgAlert:Center( oApp():oWndMain )

return nil

/*_____________________________________________________________________________*/

function MsgYesNo(cText, cCaption )

   local oDlgYesNo, oPage
   local oBmp
   local lRet := .T.

   default cCaption := oApp():cAppName+oApp():cVersion

   DEFINE DIALOG oDlgYesNo RESOURCE "UT_YESNO" TITLE cCaption
   oDlgYesNo:SetFont(oApp():oFont)

   //REDEFINE PAGES oPage ID 110 OF oDlgYesNo ;
   //   DIALOGS "UT_YESNO_PAGE"
   //oPage:oFont := oApp():oFont

   REDEFINE say prompt cText ID 10 OF oDlgYesNo
   REDEFINE BITMAP oBmp ID 111 OF oDlgYesNo RESOURCE "xpquest" TRANSPARENT

   REDEFINE BUTTON ID IDOK OF oDlgYesNo ;
      ACTION (lRet := .T., oDlgYesNo:End())
   REDEFINE BUTTON ID IDCANCEL OF oDlgYesNo ;
      ACTION (lRet := .F., oDlgYesNo:End())

   ACTIVATE DIALOG oDlgYesNo ;
      on init oDlgYesNo:Center( oApp():oWndMain )

return lRet

/*_____________________________________________________________________________*/

function c5yesnobig(cText, cCaption)

   local oDlgYesNo
   local oBmp
   local lRet := .T.

   default cCaption := oApp():cAppName+oApp():cVersion

   DEFINE DIALOG oDlgYesNo RESOURCE "m5yesnobig" TITLE cCaption
   oDlgYesNo:nStyle := nOr( oDlgYesNo:nStyle, 4 )

   REDEFINE say prompt cText ID 10 OF oDlgYesNo
   REDEFINE BITMAP oBmp ID 111 OF oDlgYesNo RESOURCE "xpquest" TRANSPARENT

   REDEFINE BUTTON ID 400 OF oDlgYesNo ;
      ACTION (lRet := .T., oDlgYesNo:End())
   REDEFINE BUTTON ID 401 OF oDlgYesNo ;
      ACTION (lRet := .F., oDlgYesNo:End())

   ACTIVATE DIALOG oDlgYesNo ;
      on init oDlgYesNo:Center( oApp():oWndMain )

return lRet
