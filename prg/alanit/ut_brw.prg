#include "Fivewin.ch"
#include "DbStruct.ch"
#include "xBrowse.ch"
#include "FileXLS.ch"
/*_____________________________________________________________________________*/

function Ut_BrwColConfig( oBrowse, cIniEntry )

   local oDlg, oGet, oBtnShow, oBtnHide, oBtnUp, oBtnDown
   local nLen   := Len( oBrowse:aCols )
   local aHeader[ nLen ]
   local aShow[ nlen ]
   local aSizes[ nLen ]
   local aArray[ nLen ]
   local hBmp   := LoadBitmap( 0, 32760 ) // MCS
   local oLbx
   local nShow  := 0
   local cState
   local n, i, oCol

   // Guardo posibles modificaciones manuales
   WritePProString("Browse",cIniEntry,oBrowse:SaveState(),oApp():cIniFile)
   cState := GetPvProfString("Browse", cIniEntry,"", oApp():cIniFile)

   for n := 1 to nLen
      aHeader[ n ] := oBrowse:aCols[ n ]:cHeader
      aShow[ n ] := ! oBrowse:aCols[ n ]:lHide
      aSizes[ n ] := oBrowse:aCols[ n ]:nWidth
      aArray[ n ] := {aShow[n],aHeader[n]}
   next

   DEFINE DIALOG oDlg OF oApp():oWndMain RESOURCE "UT_BRWCONFIG_ES" ;
      TITLE "Configuración de columnas de la rejilla" FONT oApp():oFont

   oLbx := TXBrowse():New( oDlg )
   oLbx:SetArray(aArray)
   Ut_BrwRowConfig( oLbx )
   oLbx:nDataType     := 1 // array

   oLbx:aCols[1]:cHeader  := i18n("Ver")
   oLbx:aCols[1]:nWidth   := 24
   oLbx:aCols[1]:AddResource("16_CHECK")
   oLbx:aCols[1]:AddResource(" ")
   oLbx:aCols[1]:bBmpData := {|| if(aArray[oLbx:nArrayAt,1]==.T.,1,2)}
   olbx:aCols[1]:bStrData := {|| NIL }

   oLbx:aCols[2]:cHeader  := i18n("Columna")
   oLbx:aCols[2]:nWidth   := 40

   for i := 1 to Len(oLbx:aCols)
      oCol := oLbx:aCols[ i ]
      oCol:bLDClickData  :=  {|| iif(aShow[ oLbx:nArrayAt ],oBtnHide:Click(),oBtnShow:Click()) }
   next

   oLbx:CreateFromResource( 100 )

   REDEFINE get oGet var aSizes[ oLbx:nArrayAt ] ;
      ID       101   ;
      SPINNER        ;
      MIN      1     ;
      MAX      999   ;
      picture  "999" ;
      valid    aSizes[ oLbx:nArrayAt ] > 0 ;
      OF       oDlg

   oGet:bLostFocus := {|| ( oGet:SetColor( GetSysColor( 8 ), GetSysColor( 5 ) ),;
      oBrowse:aCols[oLbx:nArrayAt]:nWidth := aSizes[ oLbx:nArrayAt ],;
      oBrowse:Refresh( .T. ) ) }
   REDEFINE BUTTON ;
      ID       400 ;
      OF       oDlg ;
      ACTION   oDlg:end( IDOK )

   REDEFINE BUTTON ;
      ID       401 ;
      OF       oDlg ;
      ACTION   ( oBrowse:RestoreState( cState ), oDlg:end() )

   REDEFINE BUTTON oBtnShow ;
      ID       402          ;
      OF       oDlg         ;
      ACTION   ( aShow[ oLbx:nArrayAt ] := .T.,;
      oLbx:aArrayData[oLbx:nArrayAt,1] := .T., oLbx:Refresh(),;
      oBrowse:aCols[ oLbx:nArrayAt ]:lHide := .F., oBrowse:Refresh( .T. ) )

   REDEFINE BUTTON oBtnHide ;
      ID       403          ;
      OF       oDlg         ;
      ACTION   IF(Len(oLbx:aArrayData)>1,;
      ( aShow[ oLbx:nArrayAt ] := .F.,;
      oLbx:aArrayData[oLbx:nArrayAt,1] := .F., oLbx:Refresh(),;
      oBrowse:aCols[ oLbx:nArrayAt ]:lHide := .T., oBrowse:Refresh( .T. ) ),;
      msgAlert(i18n('No se puede ocultar la columna.'))   )

   REDEFINE BUTTON oBtnUp     ;
      ID       404            ;
      OF       oDlg           ;
      ACTION iif( oLbx:nArrayAt > 1,;
      ( oBrowse:SwapCols( oBrowse:aCols[ oLbx:nArrayAt], oBrowse:aCols[ oLbx:nArrayAt - 1 ], .T. ),;
      SwapUpArray( aHeader, oLbx:nArrayAt ),;
      SwapUpArray( aShow, oLbx:nArrayAt ),;
      SwapUpArray( aSizes, oLbx:nArrayAt ),;
      SwapUpArray( aSizes, oLbx:nArrayAt ),;
      SwapUpArray( oLbx:aArrayData, oLbx:nArrayAt ),;
      oLbx:nArrayAt--,;
      oLbx:Refresh()                   ),;
      MsgStop("No se puede desplazar la columna." ))

   REDEFINE BUTTON oBtnDown   ;
      ID       405            ;
      OF       oDlg           ;
      ACTION iif( oLbx:nArrayAt < nLen,;
      ( oBrowse:SwapCols( oBrowse:aCols[ oLbx:nArrayAt], oBrowse:aCols[ oLbx:nArrayAt + 1 ], .T. ),;
      SwapDwArray( aHeader, oLbx:nArrayAt ),;
      SwapDwArray( aShow, oLbx:nArrayAt ),;
      SwapDwArray( aSizes, oLbx:nArrayAt ),;
      SwapDwArray( oLbx:aArrayData, oLbx:nArrayAt ),;
      oLbx:nArrayAt++,;
      oLbx:Refresh()                   ),;
      MsgStop("No se puede desplazar la columna." ))

   ACTIVATE DIALOG oDlg ;
      on init DlgCenter(oDlg,oApp():oWndMain)

return nil

/*_____________________________________________________________________________*/

function Ut_BrwRowConfig7( oBrw )

   oBrw:nRowSel      := 1
   oBrw:nColSel      := 1
   oBrw:nColOffset   := 1
   oBrw:nFreeze      := 0
   oBrw:nCaptured    := 0
   oBrw:nLastEditCol := 0

   oBrw:l2007          := .F.
   oBrw:lMultiselect        := .F.
   oBrw:lTransparent    := .F.
   oBrw:nMarqueeStyle       := MARQSTYLE_HIGHLWIN7
   oBrw:nStretchCol     := STRETCHCOL_WIDEST // -1 // STRETCHCOL_LAST-1 // STRETCHCOL_LAST
   oBrw:bClrStd         := {|| { CLR_BLACK, CLR_WHITE } }
   oBrw:lColDividerComplete := .T.
   oBrw:lRecordSelector     := .T.
   oBrw:nColDividerStyle    := LINESTYLE_LIGHTGRAY
   oBrw:nHeaderHeight       := 24
   oBrw:nRowHeight          := 20
   oBrw:nMarqueeStyle       := MARQSTYLE_HIGHLWIN7  // MARQSTYLE_SOLIDCELL
   oBrw:nRowDividerStyle    := LINESTYLE_NOLINES

return nil

FUNCTION Ut_BrwRowConfig( oBrw )

oBrw:nRowSel      := 1
   oBrw:nColSel      := 1
   oBrw:nColOffset   := 1
   oBrw:nFreeze      := 0
   oBrw:nCaptured    := 0
   oBrw:nLastEditCol := 0
	oBrw:l2007	  	  			 := .f.
	oBrw:lMultiselect        := .f.
	oBrw:lTransparent 		 := .f.
	oBrw:nMarqueeStyle		 := MARQSTYLE_HIGHLROW
	oBrw:nStretchCol 			 := STRETCHCOL_WIDEST // -1 // STRETCHCOL_LAST 
   oBrw:bClrStd   	   	 := {|| { CLR_BLACK, CLR_WHITE } }
	oBrw:bClrRowFocus   	    := {|| { CLR_BLACK, oApp():nClrHL }} // RGB(206,227,252) } }
   oBrw:bClrSelFocus  		 := {|| { CLR_BLACK, oApp():nClrHL }} // RGB(56,145,247) } }
	oBrw:lColDividerComplete := .t.
   oBrw:lRecordSelector     := .t.
   oBrw:nColDividerStyle    := LINESTYLE_LIGHTGRAY
	oBrw:nRowDividerStyle    := LINESTYLE_LIGHTGRAY
	oBrw:nHeaderHeight       := 24
	oBrw:nRowHeight          := 22
	oBrw:lExcelCellWise		 := .f.

RETURN nil
/*_____________________________________________________________________________*/

function Ut_PaintCol( oCol, hDC, cData, aRect )

   if oCol:oBrw:VGetPos() == (oCol:oBrw:cAlias)->( ordKeyNo() )
      GradientFill( hDC, aRect[ 1 ] - 2, aRect[ 2 ] - 3, aRect[ 3 ] + 1, aRect[ 4 ] + 5,;
         { { 1, RGB( 220, 235, 252 ), RGB( 193, 219, 252 ) } }, .T. )
      RoundBox( hDC, 2, aRect[ 1 ] - 1, WndWidth( oCol:oBrw:hWnd ) - 22, aRect[ 3 ] + 1, 2, 2,;
         RGB( 235, 244, 253 ), 1 )
      RoundBox( hDC, 1, aRect[ 1 ] - 2, WndWidth( oCol:oBrw:hWnd ) - 21, aRect[ 3 ] + 2, 2, 2,;
         RGB( 125, 162, 206 ), 1 )
   endif

   SetTextColor( hDC, 0 )
   DrawTextEx( hDC, cData, aRect, oCol:nDataStyle )

return nil
/*_____________________________________________________________________________*/

function Ut_PaintColArray( oCol, hDC, cData, aRect )

   if oCol:oBrw:VGetPos() == (oCol:oBrw:nArrayAt)
      GradientFill( hDC, aRect[ 1 ] - 2, aRect[ 2 ] - 3, aRect[ 3 ] + 1, aRect[ 4 ] + 5,;
         { { 1, RGB( 220, 235, 252 ), RGB( 193, 219, 252 ) } }, .T. )
      RoundBox( hDC, 2, aRect[ 1 ] - 1, WndWidth( oCol:oBrw:hWnd ) - 22, aRect[ 3 ] + 1, 2, 2,;
         RGB( 235, 244, 253 ), 1 )
      RoundBox( hDC, 1, aRect[ 1 ] - 2, WndWidth( oCol:oBrw:hWnd ) - 21, aRect[ 3 ] + 2, 2, 2,;
         RGB( 125, 162, 206 ), 1 )
   endif

   SetTextColor( hDC, 0 )
   DrawTextEx( hDC, cData, aRect, oCol:nDataStyle )

return nil
/*_____________________________________________________________________________*/
/*
#pragma BEGINDUMP

#include <windows.h>
#include <hbapi.h>

HB_FUNC( ROUNDBOX )
{
   HDC hDC = ( HDC ) hb_parni( 1 );
   HBRUSH hBrush = ( HBRUSH ) GetStockObject( 5 );
   HBRUSH hOldBrush = ( HBRUSH ) SelectObject( hDC, hBrush );
   HPEN hPen, hOldPen ;

   if( hb_pcount() > 8 )
      hPen = CreatePen( PS_SOLID, hb_parnl( 9 ), ( COLORREF ) hb_parnl( 8 ) );
   else
      hPen = CreatePen( PS_SOLID, 1, ( COLORREF ) hb_parnl( 8 ) );

   hOldPen = ( HPEN ) SelectObject( hDC, hPen );
   hb_retl( RoundRect( hDC ,
                                 hb_parni( 2 ),
                                 hb_parni( 3 ),
                                 hb_parni( 4 ),
                                 hb_parni( 5 ),
                                 hb_parni( 6 ),
                                 hb_parni( 7 ) ) );

   SelectObject( hDC, hOldBrush );
   DeleteObject( hBrush );
   SelectObject( hDC, hOldPen );
   DeleteObject( hPen );
}

#pragma ENDDUMP
*/
function Ut_ExportXLS( oBrw )

   local oXLS, nFormat, nFormat2, nFont, nLen, nCol, nFila, x, cText, cValor
   local cAlias := oBrw:cAlias

   XLS oXLS FILE ".\file.xls" AUTOEXEC
   DEFINE XLS format nFormat picture '#,##0.00'
   DEFINE XLS format nFormat2 picture '#0'

   @ 1,1 XLS say "MI XLS BROWSE" OF oXls
   @ 1,8 XLS say "Fecha:" + DToC( Date() ) OF oXls

   // CABECERAS
   nLen  := Len( oBrw:aCols )
   nCol  := 1
   nFila := 3
   for x := 1 to nLen
      if !oBrw:aCols[x]:lHide  // Si la columna no es oculta
         cValor := oBrw:aCols[x]:cHeader
         XLS COL nCol WIDTH oBrw:aCols[x]:nDataLen OF oXLS
         @ nFila,nCol XLS say cValor BORDER OF oXls
         nCol++  // Las columnas solo las que estan visibles
      endif
   next

   nCol  := 1
   nFila++   // Una fila despues del Header

   // DATOS
   dbSelectArea( cAlias )
   (cAlias)->(dbGoTop())// oDbf:GoTop()
   while ! (cAlias)->(Eof())//oDbf:Eof()
      for x := 1 to nLen
         if !oBrw:aCols[x]:lHide  // Si la columna no es oculta
            cText := oBrw:aCols[x]:Value()
            if ValType( cText ) = "N" // Si es numeric
               if oBrw:aCols[x]:nDataDec = 0
                  @ nFila, nCol XLS say cText format nFormat2 OF oXls
               else
                  @ nFila, nCol XLS say cText format nFormat OF oXls
               endif
            else
               @ nFila, nCol XLS say OemToAnsi( cText )  OF oXls
            endif
            nCol++  // Las columnas solo las que estan visibles
         endif
      next
      nFila++
      nCol := 1
      (cAlias)->(dbSkip())// oDbf:Skip()
   end while

   ENDXLS oXLS

return nil
