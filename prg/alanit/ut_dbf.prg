//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "Fivewin.ch"
#include "Report.ch"
#include "DbStruct.ch"
#include "xBrowse.ch"

/*_____________________________________________________________________________*/

function Db_Open( cDbf, cAlias )

   local nDemora

   if File( oApp():cDbfPath + cDbf + ".dbf" ) .AND. File( oApp():cDbfPath + cDbf + ".cdx" )
      use ( oApp():cDbfPath + cDbf + ".dbf" ) ;
         INDEX ( oApp():cDbfPath + cDbf + ".cdx" ) ;
         Alias ( cAlias ) ;
         NEW
   else
      msgStop( i18n( "Uno de los archivos que se intentaba abrir no se ha encontrado." ) + CRLF + CRLF + ;
         i18N( "Por favor reindexe los ficheros del programa." ) )
      return .F.
   end if

   if NetErr()
      msgStop( i18n( "Ha sucedido un error al abrir un fichero." ) + CRLF + ;
         i18n( "Por favor reinicie el programa." ) )
      dbCloseAll()
      return .F.
   endif

return .T.

/*_____________________________________________________________________________*/

function Db_OpenNoIndex( cDbf, cAlias )

   if File( oApp():cDbfPath + cDbf + ".dbf" )
      use ( oApp():cDbfPath + cDbf + ".dbf" ) ;
         Alias ( cAlias ) ;
         NEW
   else
      msgStop( i18n( "Uno de los archivos que se intentaba abrir no se ha encontrado." ) + CRLF + CRLF + ;
         i18N( "Por favor reindexe los ficheros del programa." ) )
      return .F.
   end if

   if NetErr()
      msgStop( i18n( "Ha sucedido un error al abrir un fichero." ) + CRLF + ;
         i18n( "Por favor reinicie el programa." ) )
      dbCloseAll()
      return .F.
   end if

return .T.

/*_____________________________________________________________________________*/

function Db_OpenAll()

   if ! Db_Open( "Libros", "LI" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Musica", "MU" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Cancion", "CN" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "CanDisc", "CD" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Videos", "VI" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Software", "SO" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Internet", "IN" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Materias", "MA" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Ubicaci", "UB" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Idiomas", "ID" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Agenda", "AG" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Autores", "AU" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Editores", "ED" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "CoLibros", "CL" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Categori", "CA" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_Open( "Notas", "NO" )
      dbCloseAll()
      return .F.
   end if

   if ! Db_OpenNoIndex( "Intermed", "MD" )
      dbCloseAll()
      return nil
   end if

   if ! Db_OpenNoIndex( "Soporte", "SM" )
      dbCloseAll()
      return nil
   end if

return .T.

/*_____________________________________________________________________________*/

function Db_AztOpen( cDbf, cAlias )

   local nDemora

   if File( oApp():cAztPath + cDbf + ".dbf" ) .AND. File( oApp():cAztPath + cDbf + ".cdx" )
      use ( oApp():cAztPath + cDbf + ".dbf" ) ;
         INDEX ( oApp():cAztPath + cDbf + ".cdx" ) ;
         Alias ( cAlias ) ;
         NEW
   else
      msgStop( i18n( "No se ha encontrado el fichero "+cDbf ) + CRLF + CRLF + ;
         i18N( "Por favor reindexe los ficheros del programa." ) )
      return .F.
   endif

   if NetErr()
      msgStop( i18n( "Ha sucedido un error al abrir un fichero." ) + CRLF + ;
         i18n( "Por favor reinicie el programa." ) )
      dbCloseAll()
      return .F.
   endif

return .T.

/*_____________________________________________________________________________*/

function Db_AztOpenNoIndex( cDbf, cAlias )

   if File( oApp():cAztPath + cDbf + ".dbf" )
      use ( oApp():cAztPath + cDbf + ".dbf" ) ;
         Alias ( cAlias ) ;
         NEW
   else
      msgStop( i18n( "Uno de los archivos que se intentaba abrir no se ha encontrado." ) + CRLF + CRLF + ;
         i18N( "Por favor reindexe los ficheros del programa." ) )
      return .F.
   endif

   if NetErr()
      msgStop( i18n( "Ha sucedido un error al abrir un fichero." ) + CRLF + ;
         i18n( "Por favor reinicie el programa." ) )
      dbCloseAll()
      return .F.
   endif

return .T.

/*_____________________________________________________________________________*/

function Db_AztOpenAll(lIdioma)

   if ! Db_AztOpen("ARTICULO","ZAR")
      dbCloseAll()
      return .F.
   endif

   if ! Db_AztOpen("PUBLICA","ZPU")
      dbCloseAll()
      return .F.
   endif

   if ! Db_AztOpen("AUTORES","ZAU")
      dbCloseAll()
      return .F.
   endif

   if ! Db_AztOpen("MATERIAS","ZMA")
      dbCloseAll()
      return .F.
   endif

   // atención !! la tabla de idiomas es única y es la de BTC
   if lIdioma == NIL
      if ! Db_Open("IDIOMAS","ID")
         dbCloseAll()
         return .F.
      endif
   endif

   if ! Db_AztOpen("PERIODI","ZPE")
      dbCloseAll()
      return .F.
   endif

   if ! Db_AztOpen("UBICACI","ZUB")
      dbCloseAll()
      return .F.
   endif

   if ! Db_AztOpen("TIPODOC","ZTD")
      dbCloseAll()
      return .F.
   endif

   if ! Db_AztOpen("ETIQUETAS","ZET")
      dbCloseAll()
      return .F.
   endif

return .T.
/*_____________________________________________________________________________*/

function Db_Delete(cAlias)

   local nRecord := (cAlias)->(RecNo())
   local nNext

   select (cAlias)
   (cAlias)->(dbSkip())
   nNext := (cAlias)->(RecNo())
   (cAlias)->(dbGoto(nRecord))

   (cAlias)->(dbDelete())
   (cAlias)->(DbPack())
   (cAlias)->(dbGoto(nNext))

   if (cAlias)->(Eof()) .OR. nNext == nRecord
      (cAlias)->(dbGoBottom())
   endif

return nil
/*_____________________________________________________________________________*/

function Db_Pack()

   pack

return nil

function Db_Zap()

   zap

return nil

/*_____________________________________________________________________________*/

function Db_SwapUp( cAlias, oBrw )

   local aRecNew
   local aRecOld  := Db_Scatter( cAlias )
   local nRecNum  := ( cAlias )->( RecNo() )

   //local nOrder := ( cAlias )->( OrdNumber )
   //( cAlias )->(DbSetOrder(0))

   ? (cAlias)->aanombre
   ( cAlias )->( dbSkip( -1 ) )
   ? (cAlias)->aanombre
   if ( cAlias )->( Bof() )
      Tone(300,1)
      ( cAlias )->( dbGoto( nRecNum ) )
   else
      aRecNew := Db_Scatter( cAlias )
      ( cAlias )->( dbSkip( 1 ) )
      Db_Gather( aRecNew, cAlias )
      ? (cAlias)->aanombre
      ( cAlias )->( dbSkip( -1 ) )
      Db_Gather( aRecOld, cAlias )
      ? (cAlias)->aanombre
   end if

   if oBrw != NIL
      oBrw:Refresh(.T.)
      oBrw:SetFocus(.T.)
   end if

return nil

//--------------------------------------------------------------------------//

function Db_SwapDown( cAlias, oBrw )

   local aRecNew
   local aRecOld := Db_Scatter( cAlias )
   local nRecNum := ( cAlias )->( RecNo() )

   ( cAlias )->( dbSkip( 1 ) )

   if ( cAlias )->( Eof() )
      Tone(300,1)
      ( cAlias )->( dbGoto( nRecNum ) )
   else
      aRecNew := Db_Scatter( cAlias )
      ( cAlias )->( dbSkip( -1 ) )
      Db_Gather( aRecNew, cAlias )
      ( cAlias )->( dbSkip( 1 ) )
      Db_Gather( aRecOld, cAlias )

      if oBrw != NIL
         oBrw:refresh()
      end if

   end if


   if oBrw != NIL
      oBrw:setFocus()
   end if

return nil

//--------------------------------------------------------------------------//

/*
Escribe un registro de disco
*/

function DB_Gather( aField, cAlias, lAppend )

   local i

   default lAppend := .F.

   // dbRLock( cAlias, lAppend )

   for i = 1 to Len( aField )
      (cAlias)->( FieldPut( i, aField[ i ] ) )
   next

   (cAlias)->( dbCommit() )
   // (cAlias)->( dbRunLock() )

return nil

//----------------------------------------------------------------------------//

/*
Lee del disco un registro desde un array
*/

function DB_Scatter( cAlias )

   local nField := (cAlias)->(FCount())
   local aField := {}
   local i

   // Creating requested field array

   for i = 1 to nField
      AAdd( aField, (cAlias)->(FieldGet( i ) ) )
   next

return aField

//----------------------------------------------------------------------------//
