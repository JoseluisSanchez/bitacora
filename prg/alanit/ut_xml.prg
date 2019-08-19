#include "FiveWin.ch"
#include "FileIo.ch"

function GenXML()

   if oApp():oDlg != NIL
      if oApp():nEdit > 0
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif
   MsgRun('Generando ficheros XML. Espere un momento...', oApp():cAppName, ;
      {|| DoXML() } )
   MsgInfo("Proceso terminado."+CRLF+"Los ficheros XML generados se encuentran en "+oApp():cXmlPath)
   retu nil

function DoXML()

   local aFields
   local cBuffer
   local cDbfFile
   local cXmlFile
   local cValue
   local cTable
   local nHandle
   local nFields
   local nField
   local nPos
   local aCTipo := {"C","N","L","M","D"}
   local aDTipo := {"Character","Numeric","Logical","Memo","Date"}
   local aFiles := {}
   local aDir   := {}
   local i

   aDir  := Directory(oApp():cDbfPath+"*.dbf")
   for i := 1 to Len( aDir )
      AAdd(aFiles, aDir[i,1])
   next

   for i := 1 to Len(aFiles)
      cDbfFile := Lower(aFiles[i])
      cXMLFile := oApp():cXmlPath+StrTran( cDbfFile, ".dbf", ".xml" )
      if File( cXmlFile )
         delete File ( cXmlFile )
      endif

      Db_OpenNoIndex( "Materias", "MA" )
      use (oApp():cDbfPath+cDbfFile)

      nHandle := FCreate( cXmlFile, FC_NORMAL )

      //------------------
      // Writes XML header
      //------------------
      FWrite( nHandle, [<?xml version="1.0" encoding="ISO-8859-1" ?>] + CRLF )
      FWrite( nHandle, Space( 0 ) + '<ROOT DATABASE="'  + cDbfFile + '">' + CRLF )

      nFields := FCount()
      aFields := dbStruct()
      FWrite( nHandle, Space( 2 ) + "<Structure>"  + CRLF )
      for nField := 1 to Len(aFields)
         FWrite( nHandle, Space( 2 ) + "<Field>"  + CRLF )
         cBuffer := Space( 2 ) + "<Field_name>"+aFields[nField,1]+"</Field_name>"+CRLF
         FWrite( nHandle, cBuffer )
         cBuffer := Space( 2 ) + "<Field_type>"+aDTipo[AScan(aCTipo,aFields[nField,2])]+"</Field_type>"+CRLF
         FWrite( nHandle, cBuffer )
         if aFields[nField,2] $ "CN"
            cBuffer := Space( 2 ) + "<Field_length>"+Str(aFields[nField,3])+"</Field_length>"+CRLF
            FWrite( nHandle, cBuffer )
            cBuffer := Space( 2 ) + "<Field_decimals>"+Str(aFields[nField,4])+"</Field_decimals>"+CRLF
            FWrite( nHandle, cBuffer )
         endif
         FWrite( nHandle, Space( 2 ) + "</Field>"  + CRLF )
      next
      FWrite( nHandle, Space( 2 ) + "</Structure>"  + CRLF )
      FWrite( nHandle, Space( 2 ) + "<Data>"  + CRLF )
      do while ! Eof()
         cBuffer := Space( 2 ) + "<Record>"  + CRLF
         FWrite( nHandle, cBuffer )
         for nField := 1 to nFields
            //-------------------
            // Beginning Record Tag
            //-------------------

            cBuffer:= Space( 4 ) + "<" + FieldName( nField ) + ">"

            do case
            case aFields[nField, 2] == "D"
               cValue := DToS( FieldGet( nField ))
            case aFields[nField, 2] == "N"
               cValue := Str( FieldGet( nField ))
            case aFields[nField, 2] == "L"
               cValue := If( FieldGet( nField ), "True", "False" )
            case aFields[nField, 2] == "M"
               cValue := MemoTran( FieldGet( nField ) )
            otherwise
               cValue := FieldGet( nField )
            endcase

            //--- Convert special characters
            cValue:= StrTran(cValue,"&","&amp;")
            cValue:= StrTran(cValue,"<","&lt;")
            cValue:= StrTran(cValue,">","&gt;")
            cValue:= StrTran(cValue,"'","&apos;")
            cValue:= StrTran(cValue,["],[&quot;])

            cBuffer := cBuffer             + ;
               AllTrim( cValue )   + ;
               "</"                + ;
               FieldName( nField ) + ;
               ">"                 + ;
               CRLF

            FWrite( nHandle, cBuffer )
         next nField

         //------------------
         // Ending Record Tag
         //------------------
         FWrite( nHandle, Space( 2 ) + "</Record>"  + CRLF )
         skip
      enddo

      dbCloseAll()
      FWrite( nHandle, Space(0) + "</Data>" + CRLF )
      FWrite( nHandle, Space(0) + "</ROOT>" + CRLF )
      FClose( nHandle )
   next

return nil
