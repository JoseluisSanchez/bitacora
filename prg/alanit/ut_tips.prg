/*
 *  Programmer ..: Kevin S. Gallagher
 *  Description .: function to mimic Microsoft's Tip of the day routine
 *  CopyRights ..: Public Domain
*/

#include "Fivewin.ch"

/*_____________________________________________________________________________*/

function TipOfDay( cIniFile, lFromInit )

   local cMessage
   local cTip
   local cShow
   local oDlg
   local oText
   local lNext
   local nNextTip
   local nTotals
   local oMs10Font
   local oBmp
   local oBtnNext
   local oBtnEnd

   cTip := "Tip"

   if ModalSobreFsdi()
      return nil
   end if

   if !file(cIniFile) .or. empty(cIniFile)
      return nil
   end if

   lNext := val( GetPvProfString( "Options", "ShowTip", "1", cIniFile ) ) != 0

   if lFromInit .and. !lNext
      return nil
   end if

   nTotals  := val( GetPvProfString( "Total Tips", "Total Tips", "0", cIniFile ) )
   nNextTip := val( GetPvProfString( "Next Tip", "TipNo", "0", cIniFile ) )
   cTip     += lTrim( str(nNextTip) )
   cMessage := GetPvProfString( "Tips", cTip, "Error", cIniFile )

   nNextTip += 1
   if nNextTip > nTotals
      nNextTip := 1
   end if

   if nTotals < nNextTip
      WritePProString( "Next Tip", "TipNo", "1", cIniFile )
   else
      WritePProString( "Next Tip", "TipNo", lTrim( str(nNextTip) ), cIniFile )
   end if

   DEFINE DIALOG oDlg;
      NAME "UT_TIP";
      TITLE oApp():cAppName;
      OF oApp():oWndMain // FONT oWndMain:oFont
   oDlg:oFont:= oApp():oFont

   REDEFINE CHECKBOX lNext;
      ID 104;
      ON CHANGE ShowMyTip(lNext,cIniFile);
      OF oDlg

   REDEFINE BITMAP oBmp;
      ID 100;
      OF oDlg;
      RESOURCE "TIP";
      TRANSPARENT

   REDEFINE SAY;
      ID 101;
      OF oDlg

   REDEFINE BUTTON oBtnNext;
      ID 105;
      ACTION NextTip( nNextTip, cIniFile, oText )

   REDEFINE BUTTON oBtnEnd;
      ID 106;
      ACTION oDlg:End()

   REDEFINE GET oText;
      VAR cMessage;
      ID 103;
      OF oDlg;
      COLOR CLR_BLUE, CLR_WHITE;
      MEMO;
      READONLY

   ACTIVATE DIALOG oDlg;
      ON INIT DlgCenter( oDlg, oApp():oWndMain )

   if ! WritePProString( "Next Tip", "TipNo", lTrim( str(nNextTip) ), cIniFile )
      msgStop( i18n("Escribiendo al fichero de trucos"), "error Tips-111" )
   end if

return nil

/*_____________________________________________________________________________*/

function NextTip( nNextTip, cIniFile, oText )

   local nTotals
   local cMessage
   local cTip

   cTip := "Tip"

   nNextTip := val( GetPvProfString( "Next Tip", "TipNo", "0", cIniFile ) )
   cTip     += lTrim( str(nNextTip) )
   cMessage := GetPvProfString( "Tips", cTip, "", cIniFile )

   if empty(cMessage)
      cMessage := i18n("error al leer el truco #Tips-121")  // whatever...
   end if

   oText:cText := cMessage
   oText:Refresh()
   nNextTip += 1

   nTotals := val( GetPvProfString( "Total Tips", "Total Tips", "0", cIniFile ) )

   if nNextTip > nTotals
      nNextTip := 1
   end if

   if nTotals < nNextTip
      WritePProString( "Next Tip", "TipNo", "1", cIniFile )
   else
      WritePProString( "Next Tip", "TipNo", lTrim( str(nNextTip) ), cIniFile )
   end if

return nil

/*_____________________________________________________________________________*/

function ShowMyTip( lNext, cIniFile )

   if ! lNext
      WritePProString( "Options", "ShowTip", "0", cIniFile )
   else
      WritePProString( "Options", "ShowTip", "1", cIniFile )
   end if

return nil

