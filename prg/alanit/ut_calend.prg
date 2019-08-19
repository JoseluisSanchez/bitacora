#include "FiveWin.ch"
#include "calendar.ch"

function SelecFecha(dFechaPres, oGet)

   local oDlg, oButton1, oButton2, oSayFecha, oCalendar
   local lOk := .f.
   local dFecha
   local aPoint := AdjustWnd(oGet, 97*2, 88*2)

   IF Empty(dFechaPres)
      dFecha := Date()
   ELSE
      dFecha := dFechaPres
   ENDIF

   DEFINE DIALOG oDlg RESOURCE 'Ut_Calendar'       ;
      TITLE "Selección de fecha"                   ;
      COLOR GetSysColor(18), GetSysColor(15)
   oDlg:lHelpIcon = .f.
   oDlg:SetFont(oApp():oFont)

   REDEFINE CALENDAR oCalendar VAR dFecha ;
      ID 11 OF oDlg DBLCLICK  ( lOk := .t., oDlg:End()) 

   oCalendar:SetFont(oApp():oFont)
	oCalendar:oCursor := TCursor():New(,'HAND')

   ACTIVATE DIALOG oDlg               ;
      ON PAINT ( oDlg:Move(aPoint[1], aPoint[2],,,.t.), ;
                 oCalendar:SetFocus(.t.) )

   if lOK
      oGet:cText( oCalendar:dDate )
      sysrefresh()
   endif

return nil

static function nDiasMes( dDate )

   local nMes, cYear
   local dDay
   local aDays := {31,28,31,30,31,30,31,31,30,31,30,31}
   local nreturn
   local dateformat := Set( _SET_DATEFORMAT )

   if Empty( dDate )
      return 0
   endif
   set( _SET_DATEFORMAT, "dd-mm-yyyy" )
   nMes := Month( dDate )
   cYear := Str( Year( dDate ),4 )
   if nMes == 2
      if Day( CToD( "29-02-" + cYear ) ) != 0
         nreturn := 29
      else
         nreturn := 28
      endif
   else
      nreturn := aDays[ nMes ]
   endif
   set( _SET_DATEFORMAT, dateformat )

return nreturn

static function Month2Str(dDate)

   local creturn

   if oApp():cLanguage == 'ES'
      creturn := ( {  "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto",;
         "Septiembre", "Octubre", "Noviembre", "Diciembre" }[ Month( dDate ) ] )
   elseif oApp():cLanguage == 'EN'
      creturn := ( {  "January", "Febrary", "March", "April", "May", "June", "July", "August",;
         "September", "October", "November", "December" }[ Month( dDate ) ] )
   endif

return creturn

static function Ns2date1( nDia, nMes, nAnio )

   local dreturn
   local dateformat := Set( _SET_DATEFORMAT, "dd-mm-yyyy" )

   dreturn := CToD(StrZero(nDia,2)+"-"+StrZero(nMes,2)+"-"+Str(nAnio,4) )
   set( _SET_DATEFORMAT, dateformat )

return dreturn
