//*
// PROYECTO ..: Cuaderno de Bitácora
// COPYRIGHT .: (c) alanit software
// URL .......: www.alanit.com
//*

#include "FiveWin.ch"

/*_____________________________________________________________________________*/

function ut_Actualizar()

   local oDlgProgress, oSay01, oSay02, oBmp, oProgress
   local cDir := oApp():cDbfPath

   if oApp():oDlg != nil
      if oApp():nEdit > 0
         //MsgStop('Por favor, finalice la edición del registro actual.')
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   DEFINE DIALOG oDlgProgress RESOURCE 'UT_INDEXAR_' + oApp():cLanguage OF oApp():oWndMain
   oDlgProgress:SetFont(oApp():oFont)
   REDEFINE BITMAP oBmp ID 111 OF oDlgProgress RESOURCE 'BB_INDEX' TRANSPARENT
   REDEFINE say oSay01 prompt i18n( "Actualizando ficheros de datos" ) ID 99  OF oDlgProgress
   REDEFINE say oSay02 prompt Space( 30 ) ID 10  OF oDlgProgress

   oProgress := TProgress():Redefine( 101, oDlgProgress )

   oDlgProgress:bStart := {|| SysRefresh(), Ut_CrearDbf( oDlgProgress, cDir, oSay02, oProgress ), oDlgProgress:End() }
   ACTIVATE DIALOG oDlgProgress ;
      on init DlgCenter( oDlgProgress, oApp():oWndMain )

return nil

/*_____________________________________________________________________________*/

function Ut_CrearDbf( oDlgT, cDir, oSay, oProgress )

   CursorWait()

   // agenda
   oSay:SetText( i18n( "Fichero de Agenda" ) )
   dbCreate( cDir + "na", { { "PENOMBRE", "C",  50,   0 },;
      { "PENOTAS", "M",  10,   0 },;
      { "PEDIBU", "N",   1,   0 },;
      { "PETELEFO", "C",  20,   0 },;
      { "PEOTROS", "C",  40,   0 },;
      { "PEPROPIET", "L",   1,   0 },;
      { "PECOMPRAS", "L",   1,   0 },;
      { "PEPERSONAL", "L",   1,   0 },;
      { "PENEGOCIOS", "L",   1,   0 },;
      { "PEOCIO", "L",   1,   0 },;
      { "PEPDIRECC", "C",  40,   0 },;
      { "PEPCODPOS", "C",   5,   0 },;
      { "PEPLOCALI", "C",  30,   0 },;
      { "PEPTELEFO1", "C",  20,   0 },;
      { "PEPTELEFO2", "C",  20,   0 },;
      { "PEPFAX", "C",  20,   0 },;
      { "PEPEMAIL", "C",  40,   0 },;
      { "PEPURL", "C",  60,   0 },;
      { "PEPFCHNAC", "D",   8,   0 },;
      { "PEPNACINS", "L",   1,   0 },;
      { "PEPFCHANIV", "D",   8,   0 },;
      { "PEPANYINS", "L",   1,   0 },;
      { "PEPCONY", "C",  40,   0 },;
      { "PENEMPRESA", "C",  50,   0 },;
      { "PENCONTAC", "C",  50,   0 },;
      { "PENDIRECC", "C",  40,   0 },;
      { "PENCODPOS", "C",   5,   0 },;
      { "PENLOCALI", "C",  30,   0 },;
      { "PENTELEFO1", "C",  20,   0 },;
      { "PENTELEFO2", "C",  20,   0 },;
      { "PENFAX", "C",  20,   0 },;
      { "PENEMAIL", "C",  40,   0 },;
      { "PENURL", "C",  60,   0 },;
      { "PEOCATEGOR", "C",  30,   0 },;
      { "PEODIRECC", "C",  40,   0 },;
      { "PEOCODPOS", "C",   5,   0 },;
      { "PEOLOCALI", "C",  30,   0 },;
      { "PEOTELEFO1", "C",  20,   0 },;
      { "PEOTELEFO2", "C",  20,   0 },;
      { "PEOFAX", "C",  20,   0 },;
      { "PEOEMAIL", "C",  40,   0 },;
      { "PEOURL", "C",  60,   0 }  } )
   dbCloseAll()
   dbUseArea( .T.,, cDir + "na" )
   select na
   if File( cDir + "agenda.dbf" )
      FErase( cDir + "agenda.cdx" )
      dbAppendfrom(cDir+"agenda")
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "agenda.dbf" )
      FErase( cDir + "agenda.fpt" )
   endif
   dbCloseAll()
   FRename(cDir+"na.dbf", cDir+"agenda.dbf")
   FRename(cDir+"na.fpt", cDir+"agenda.fpt")

   // autores
   oSay:SetText( i18n( "Fichero de Autores" ) )
   dbCreate( cDir + "na", { { "AUCATEGOR", "C",   1,   0 },;
      { "AUNOMBRE", "C",  60,   0 },;
      { "AUMATERIA", "C",  30,   0 },;
      { "AUNOTAS", "C", 255,   0 },;
      { "AUDIRECC", "C",  50,   0 },;
      { "AUTELEFONO", "C",  30,   0 },;
      { "AULOCALI", "C",  50,   0 },;
      { "AUPAIS", "C",  30,   0 },;
      { "AUEMAIL", "C",  50,   0 },;
      { "AUURL", "C",  50,   0 },;
      { "AUNUMEJEM", "N",   6,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir + "na" )
   select na
   if File( cDir + "autores.dbf" )
      FErase( cDir + "autores.cdx" )
      dbAppendFrom(cDir+"autores")
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "autores.dbf" )
   endif
   dbCloseAll()
   FRename(cDir + "na.dbf",cDir + "autores.dbf" )

   // categorias
   oSay:SetText( i18n( "Fichero de Categorias" ) )
   dbCreate( cDir + "na", { { "TIPO", "C",   1,   0 },;
      { "CATEGORIA", "C",  30,   0 }  } )
   dbCloseAll()
   dbUseArea(.T.,,cDir+"na")
   select na
   if File( cDir + "categori.dbf" )
      FErase( cDir + "categori.cdx" )
      dbAppendFrom(cDir+"categori")
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "categori.dbf" )
   endif
   dbCloseAll()
   FRename(cDir+"na.dbf", cDir+"categori.dbf")

   // idiomas
   oSay:SetText( i18n( "Fichero de Idiomas" ) )
   dbCreate( cDir + "na", { { "IDIOMA", "C", 15, 0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir + "na" )
   select na
   if File( cDir + "idiomas.dbf" )
      FErase(cDir+"idiomas.cdx")
      dbAppendFrom(cDir+"idiomas")
      dbCommitAll()
      dbCloseAll()
      FErase(cDir+"idiomas.dbf")
   endif
   dbCloseAll()
   FRename(cDir+"na.dbf", cDir+"idiomas.dbf")

   // soportes de música
   oSay:SetText( i18n( "Fichero de Soportes" ) )
   dbCreate( cDir + "na", { { "SMSOPORTE", "C", 20, 0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "soporte.dbf" )
      FErase( cDir + "soporte.cdx" )
      dbAppendFrom( cDir + "soporte" )
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "soporte.dbf" )
   endif
   dbCloseAll()
   FRename( cDir + "na.dbf", cDir + "soporte.dbf" )

   // colibros
   oSay:SetText( i18n( "Fichero de Colecciones" ) )
   dbCreate( cDir + "na", { { "CLTIPO", "C",   1,   0 },;
      { "CLNOMBRE", "C",  40,   0 },;
      { "CLTOMOS", "N",   6,   0 },;
      { "CLEDITOR", "C",  30,   0 },;
      { "CLMATERIA", "C",  30,   0 },;
      { "CLPRECIO", "N",  13,   2 },;
      { "CLNOTAS", "C", 255,   0 },;
      { "CLNUMEJEM", "N",   6,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "colibros.dbf" )
      FErase( cdir + "colibros.cdx" )
      dbAppendFrom ( cdir + "colibros" )
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "colibros.dbf" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "colibros.dbf" )

   // editores
   oSay:SetText( i18n( "Fichero de Editores" ) )
   dbCreate( cDir + "na", { { "EDTIPO", "C",   1,   0 },;
      { "EDNOMBRE", "C",  40,   0 },;
      { "EDDIRECC", "C",  40,   0 },;
      { "EDLOCALI", "C",  40,   0 },;
      { "EDPAIS", "C",  20,   0 },;
      { "EDTELEFO", "C",  20,   0 },;
      { "EDFAX", "C",  20,   0 },;
      { "EDURL", "C",  40,   0 },;
      { "EDEMAIL", "C",  40,   0 },;
      { "EDNOTAS", "C", 255,   0 },;
      { "EDNUMEJEM", "N",   6,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "editores.dbf" )
      FErase( cDir + "editores.cdx" )
      dbAppendFrom ( cDir + "editores" )
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "editores.dbf" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "editores.dbf" )

   // intermed
   dbCreate( cDir + "intermed", { { "LINEA", "C",  81,   0 }  } )

   // internet
   oSay:SetText( i18n( "Fichero de Direcciones Internet" ) )
   dbCreate( cDir + "na", { { "INCODIGO", "C",  10,   0 },;
      { "INNOMBRE", "C",  60,   0 },;
      { "INDIRECC", "C",  60,   0 },;
      { "INIDIOMA", "N",   1,   0 },;
      { "INIDIOMAC", "C",  15,   0 },;
      { "INOTROID", "C",  15,   0 },;
      { "INSERVIC", "C",   6,   0 },;
      { "INMATERIA", "C",  30,   0 },;
      { "INDESCRI", "M",  10,   0 },;
      { "INDISENO", "N",   1,   0 },;
      { "INCONTENI", "N",   1,   0 },;
      { "INVALORAC", "N",   1,   0 },;
      { "INFCHVIS", "D",   8,   0 },;
      { "INEMAIL", "C",  40,   0 }  } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "internet.dbf" )
      FErase( cDir + "internet.cdx" )
      dbAppendFrom ( cDir + "internet" )
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "internet.dbf" )
      FErase( cDir + "internet.fpt" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "internet.dbf" )
   rename ( cDir + "na.fpt" ) to ( cDir + "internet.fpt" )

   // libros
   oSay:SetText( i18n( "Fichero de Libros" ) )
   dbCreate( cDir + "na", { { "LITITULO", "C",  70,   0 },;
      { "LITITORIG", "C",  60,   0 },;
      { "LICODIGO", "C",  10,   0 },;
      { "LIPROPIET", "C",  40,   0 },;
      { "LIAUTOR", "C",  60,   0 },;
      { "LIEDITOR", "C",  40,   0 },;
      { "LIANOEDIC", "N",   4,   0 },;
      { "LINUMEDIC", "N",   3,   0 },;
      { "LIISBN", "C",  20,   0 },;
      { "LIPRECIO", "N",   9,   2 },;
      { "LIFCHADQ", "D",   8,   0 },;
      { "LIPROVEED", "C",  40,   0 },;
      { "LIMATERIA", "C",  30,   0 },;
      { "LIIDIOMA", "C",  15,   0 },;
      { "LIPRESTAD", "C",  30,   0 },;
      { "LIFECHAPR", "D",   8,   0 },;
      { "LIUBICACI", "C",  60,   0 },;
      { "LICIUDAD", "C",  15,   0 },;
      { "LIPAGINAS", "N",   4,   0 },;
      { "LIENCUAD", "C",  15,   0 },;
      { "LIVALORACI", "N",   2,   0 },;
      { "LIFCHLEC", "D",   8,   0 },;
      { "LIOBSERV", "M",  10,   0 },;
      { "LIRESUMEN", "C",  80,   0 },;
      { "LICOLECC", "C",  40,   0 },;
      { "LINUMTOMOS", "N",   6,   0 },;
      { "LIESTETOMO", "N",   6,   0 },;
      { "LIIMAGEN", "C", 120,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "libros.dbf" )
      FErase( cDir + "libros.cdx" )
      dbAppendFrom ( cDir + "libros" )
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "libros.dbf" )
      FErase( cDir + "libros.fpt" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "libros.dbf" )
   rename ( cDir + "na.fpt" ) to ( cDir + "libros.fpt" )

   // materias
   oSay:SetText( i18n( "Fichero de Materias" ) )
   dbCreate( cDir + "na", { { "MATIPO", "C",   1,   0 },;
      { "MAMATERIA", "C",  30,   0 },;
      { "MANUMLIBR", "N",   6,   0 }  } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "materias.dbf" )
      FErase( cDir + "materias.cdx" )
      dbAppendFrom ( cDir + "materias" )
      dbCommitAll()
      dbCloseAll()
      FErase( cDir + "materias.dbf" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "materias.dbf" )

   // ubicaciones
   oSay:SetText( i18n( "Fichero de Ubicaciones" ) )
   dbCreate( cDir + "na", { { "UBTIPO", "C",   1,   0 },;
      { "UBUBICACI", "C",  60,   0 },;
      { "UBITEMS", "N",   6,   0 }  } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "ubicaci.dbf" )
      FErase( cdir + "ubicaci.cdx" )
      dbAppendFrom ( cdir + "ubicaci" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "ubicaci.dbf" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "ubicaci.dbf" )

   // musica
   oSay:SetText( i18n( "Fichero de Discos" ) )
   dbCreate( cDir + "na", { { "MUCODIGO", "C",  10,   0 },;
      { "MUTITULO", "C",  60,   0 },;
      { "MUPROPIET", "C",  40,   0 },;
      { "MUAUTOR", "C",  60,   0 },; // intérprete
      { "MUAUTOR2", "C",  60,   0 },; // compositor
      { "MUDIRECTOR", "C",  60,   0 },; // director de orquesta
      { "MUMATERIA", "C",  30,   0 },;
      { "MUIDIOMA", "C",  15,   0 },;
      { "MUEDITOR", "C",  40,   0 },;
      { "MUANOEDIC", "N",   4,   0 },;
      { "MUSOPORTE", "N",   1,   0 },;
      { "MUSOPTXT", "C",  20,   0 },;
      { "MUUBICACI", "C",  60,   0 },;
      { "MUPRECIO", "N",   9,   2 },;
      { "MUPRESTAD", "C",  30,   0 },;
      { "MUFCHPRES", "D",   8,   0 },;
      { "MUPROVEED", "C",  40,   0 },;
      { "MUFCHADQ", "D",   8,   0 },;
      { "MUCOLECC", "C",  40,   0 },;
      { "MUNUMTOMOS", "N",   6,   0 },;
      { "MUESTETOMO", "N",   6,   0 },;
      { "MUIMAGEN", "C", 120,   0 },;
      { "MURESUMEN", "C",  80,   0 },;
      { "MUOBSERV", "M",  10,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "musica.dbf" )
      FErase( cDir + "musica.cdx" )
      dbAppendFrom ( cDir + "musica" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "musica.dbf" )
      FErase( cdir + "musica.fpt" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "musica.dbf" )
   rename ( cdir + "na.fpt" ) to ( cdir + "musica.fpt" )

   // canciones
   oSay:SetText( i18n( "Fichero de Canciones" ) )
   dbCreate( cDir + "na", { { "CATITULO", "C",  60,   0 },;
      { "CAMATERIA", "C",  40,   0 },;
      { "CAAUTOR", "C",  60,   0 },;
      { "CAINTERP", "C",  60,   0 },;
      { "CADURACC", "C",  10,   0 },;
      { "CAIDIOMA", "C",  15,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "cancion.dbf" )
      FErase( cdir + "cancion.cdx" )
      dbAppendFrom ( cdir + "cancion" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "cancion.dbf" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "cancion.dbf" )

   // canciones en discos
   oSay:SetText( i18n( "Fichero de Canciones" ) )
   dbCreate( cDir + "na", { { "CDMUCODIGO", "C",  10,   0 },;
      { "CDMUTITULO", "C",  60,   0 },;
      { "CDMUINTERP", "C",  60,   0 },;
      { "CDCATITULO", "C",  60,   0 },;
      { "CDCAAUTOR", "C",  60,   0 },;
      { "CDCADURACC", "C",  10,   0 },;
      { "CDCAIDIOMA", "C",  15,   0 },;
      { "CDORDEN", "C",   2,   0 }  } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "candisc.dbf" )
      FErase( cDir + "candisc.cdx" )
      dbAppendFrom ( cDir + "candisc" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "candisc.dbf" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "candisc.dbf" )

   // notas
   oSay:SetText( i18n( "Fichero de Anotaciones" ) )
   dbCreate( cDir + "na", { { "NOTIPO", "N",   1,   0 },;
      { "NOFECHA", "D",   8,   0 },;
      { "NOFECHA2", "D",   8,   0 },;
      { "NOCODIGO", "C",  10,   0 },;
      { "NOTITULO", "C",  70,   0 },;
      { "NOAQUIEN", "C",  50,   0 }  } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "notas.dbf" )
      FErase( cDir + "notas.cdx" )
      dbAppendFrom ( cDir + "notas" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "notas.dbf" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "notas.dbf" )

   // software
   oSay:SetText( i18n( "Fichero de Software" ) )
   dbCreate( cDir + "na", { { "SOCODIGO", "C",  10,   0 },;
      { "SOTITULO", "C",  60,   0 },;
      { "SOPROPIET", "C",  40,   0 },;
      { "SOMATERIA", "C",  30,   0 },;
      { "SOIDIOMA", "C",  15,   0 },;
      { "SONUMSER", "C",  35,   0 },;
      { "SOEDITOR", "C",  40,   0 },;
      { "SOPRECIO", "N",   9,   2 },;
      { "SOFCHCOMP", "D",   8,   0 },;
      { "SOPROVEED", "C",  40,   0 },;
      { "SODESCRI", "M",  10,   0 },;
      { "SORESUMEN", "C",  80,   0 },;
      { "SOGUARDADO", "C",  40,   0 },;
      { "SONOMDIR", "C",  40,   0 },;
      { "SOENTORNO", "N",   1,   0 },;
      { "SOENTORNO6", "N",   1,   0 },;
      { "SODEMO", "L",   1,   0 },;
      { "SODISCOS", "L",   1,   0 },;
      { "SONUMDISK", "N",   2,   0 },;
      { "SOCD", "L",   1,   0 },;
      { "SOUBICACI", "C",  60,   0 },;
      { "SOPRESTAD", "C",  30,   0 },;
      { "SOFECHA", "D",   8,   0 },;
      { "SOIMAGEN", "C", 120,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "software.dbf" )
      FErase( cdir + "software.cdx" )
      dbAppendFrom ( cdir + "software" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "software.dbf" )
      FErase( cdir + "software.fpt" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "software.dbf" )
   rename ( cDir + "na.fpt" ) to ( cDir + "software.fpt" )

   // vídeos
   oSay:SetText( i18n( "Fichero de Videos" ) )
   dbCreate( cDir + "na", { { "VINUMERO", "C",  10,   0 },;
      { "VIPROPIET", "C",  40,   0 },;
      { "VITITULO", "C",  60,   0 },;
      { "VIORIGINAL", "C",  60,   0 },;
      { "VIDURAC", "C",   6,   0 },;
      { "VIINICIO", "C",   6,   0 },;
      { "VIFINAL", "C",   6,   0 },;
      { "VIMATERIA", "C",  30,   0 },;
      { "VIIDIOMA", "C",  15,   0 },;
      { "VIUBICACI", "C",  60,   0 },;
      { "VIANYO", "N",   4,   0 },;
      { "VIDIRECTOR", "C",  60,   0 },;
      { "VIACTOR", "C",  60,   0 },;
      { "VIACTRIZ", "C",  60,   0 },;
      { "VIFOTOGRA", "C",  60,   0 },;
      { "VIPRODUCT", "C",  30,   0 },;
      { "VISOPORTE", "N",   1,   0 },;
      { "VICALIFIC", "C",  30,   0 },;
      { "VIRESUMEN", "C",  80,   0 },;
      { "VICOMENTA", "M",  10,   0 },;
      { "VIPRESTAD", "C",  30,   0 },;
      { "VIFCHPRES", "D",   8,   0 },;
      { "VIPROVEED", "C",  30,   0 },;
      { "VIFCHADQ", "D",   8,   0 },;
      { "VIPRECIO", "N",   9,   2 },;
      { "VIBSOTIT", "C",  60,   0 },;
      { "VIBSOAUT", "C",  60,   0 },;
      { "VIBSOEDI", "C",  30,   0 },;
      { "VICOLECC", "C",  40,   0 },;
      { "VICOLTOT", "N",   6,   0 },;
      { "VICOLEST", "N",   6,   0 },;
      { "VIIMAGEN", "C", 120,   0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "videos.dbf" )
      FErase( cdir + "videos.cdx" )
      dbAppendFrom ( cdir + "videos" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "videos.dbf" )
      FErase( cdir + "videos.fpt" )
   endif
   dbCloseAll()
   rename ( cdir + "na.dbf" ) to ( cdir + "videos.dbf" )
   rename ( cDir + "na.fpt" ) to ( cDir + "videos.fpt" )
   dbCloseAll()

   //if lMsg
   //   msgInfo( i18n( "Los datos se actualizaron correctamente." ) )
   //endif

   oDlgT:End()

   CursorArrow()

return nil

/*_____________________________________________________________________________*/

function Ut_Indexar( lMsg )

   local oDlgProgress, oSay01, oSay02, oBmp, oProgress
   local nVar   := 0

   if oApp():oDlg != nil
      if oApp():nEdit > 0
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   DEFINE DIALOG oDlgProgress RESOURCE 'UT_INDEXAR_' + oApp():cLanguage OF oApp():oWndMain
   oDlgProgress:SetFont(oApp():oFont)

   REDEFINE BITMAP oBmp ID 111 OF oDlgProgress RESOURCE 'BB_INDEX' TRANSPARENT
   REDEFINE say oSay01 prompt "Generando índices de la aplicación" ID 99  OF oDlgProgress
   REDEFINE say oSay02 prompt Space( 30 ) ID 10  OF oDlgProgress
   oProgress := TProgress():Redefine( 101, oDlgProgress )

   oDlgProgress:bStart := {|| SysRefresh(), Ut_CrearCdx( oSay02, oProgress ), Ut_Integridad( oSay02, oProgress ), oDlgProgress:End() }

   ACTIVATE DIALOG oDlgProgress ;
      on init DlgCenter( oDlgProgress, oApp():oWndMain )

   MsgInfo( i18n( "La regeneración de índices se realizó correctamente." ) )

return nil

/*_____________________________________________________________________________*/

function Ut_CrearCdx( oSay, oMeter )

   local i      := 0
   local nIndex := "33"
   local nMeter := 0
   local cDir   := oApp():cDbfPath
   field MaTipo, MaMateria
   field UbTipo, UbUbicaci
   field NoTipo, NoCodigo, NoTitulo, NoFecha, NoAQuien
   field LiCodigo, LiTitulo, LiTitOrig, LiAUtor, LiMateria, LiPropiet, LiEditor, LiAnoEdic, LiColecc, LiFchAdq, LiFechaPr, LiPrestad, LiUbicaci
   field MuCodigo, MuTitulo, MuAutor, MuMateria, MuAutor2, MuDirector, MuPropiet, MuEditor, MuAnoEdic, MuColecc, MuFchAdq, MuFchPres, MuPrestad, MuUbicaci, MuSoporte
   field CaTitulo, CaInterp, CaAutor, CaMateria, CaDuracc
   field CdMuCodigo, CdOrden, CdCaTitulo, CdCaAutor
   field SoCodigo, SoTitulo, SoMateria, SoPropiet, SoEditor, SoFchComp, SoFecha, SoPrestad, SoGuardado
   field InCodigo, InNombre, InMateria, InDirecc, InDiseno, InConteni, InValorac, InFchVis, InServic
   field ViNumero, ViTItulo, ViOriginal, ViMateria, ViPropiet, ViDirector, ViActor, ViActriz, ViProduct, ViAnyo, ViColecc, ViFchAdq, ViFchPres, ViPrestad, ViUbicaci, ViFotogra
   field EdNombre, EdTipo
   field ClNombre, ClTipo
   field AuNombre, AuCategor, AuMateria
   field PeNombre, PePropiet, PeCompras
   field Categoria
   field Idioma
   field SmSoporte

   CursorWait()
   // MATERIAS
   dbCloseAll()
   if File( cDir + "materias.cdx" )
      FErase( cDir + "materias.cdx" )
   endif
   Db_OpenNoIndex( "Materias", )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Materias" ) )
   oMeter:SetRange( 0, RecCount() )
   index on Upper( Matipo ) + Upper( MaMateria );
      tag MATERIA;
      for ! Deleted();
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MaMateria );
      tag LMATERIA;
      for ( Matipo == "L" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MaMateria );
      tag MMATERIA;
      for ( Matipo == "M" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MaMateria );
      tag VMATERIA;
      for ( Matipo == "V" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MaMateria );
      tag SMATERIA;
      for ( Matipo == "S" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MaMateria );
      tag IMATERIA;
      for ( Matipo == "I" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   // UBICACIONES
   dbCloseAll()
   if File( cDir + "ubicaci.cdx" )
      FErase( cDir + "ubicaci.cdx" )
   endif
   Db_OpenNoIndex( "Ubicaci", )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Ubicaciones" ) )
   oMeter:SetRange( 0, RecCount() )
   index on Upper( UbTipo ) + Upper( UbUbicaci );
      tag UBICACION;
      for ! Deleted();
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( UbUbicaci );
      tag LUBICACION;
      for ( UbTipo == "L" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( UbUbicaci );
      tag MUBICACION;
      for ( UbTipo == "M" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( UbUbicaci );
      tag VUBICACION;
      for ( UbTipo == "V" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( UbUbicaci );
      tag SUBICACION;
      for ( UbTipo == "S" .AND. !Deleted() );
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   // NOTAS
   dbCloseAll()
   if File( cDir + "notas.cdx" )
      FErase( cDir + "notas.cdx" )
   endif
   Db_OpenNoIndex( "Notas", "NO" )
   Db_Pack()
   oSay:SetText( i18n( "Libreta de prestamos" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( Notipo, 1 ) + Upper( NoTitulo );
      tag TIPO;
      for ! Deleted();
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( Notipo, 1 ) + Upper( NoTitulo );
      tag LIBROS;
      for ! Deleted() .AND. Str( NoTipo, 1 ) == "1";
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( Notipo, 1 ) + Upper( NoTitulo );
      tag DISCOS;
      for ! Deleted() .AND. Str( NoTipo, 1 ) == "2";
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( Notipo, 1 ) + Upper( NoTitulo );
      tag VIDEOS;
      for ! Deleted() .AND. Str( NoTipo, 1 ) == "3";
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( Notipo, 1 ) + Upper( NoTitulo );
      tag SOFTWARE;
      for ! Deleted() .AND. Str( NoTipo, 1 ) == "4";
      Eval ( oMeter:SetPos( nMeter++ ), ;
      iif( nMeter < RecCount(), oMeter:StepIt(), ), ;
      SysRefresh() ) every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )

   // LIBROS
   dbCloseAll()
   if File( cDir + "libros.cdx" )
      FErase( cDir + "libros.cdx" )
   endif
   Db_OpenNoIndex( "Libros", "LI" )
   Db_Pack()
   oMeter:setRange( 0, RecCount() )
   oSay:SetText( i18n( "Fichero de Libros" ) )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiCodigo );
      tag CODIGO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiTitulo );
      tag TITULO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiTitOrig );
      tag TITULORIGINAL;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiAutor ) + Upper( LiTitulo );
      tag AUTOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiMateria ) + Upper( LiTitulo );
      tag MATERIA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiPropiet ) + Upper( LiTitulo );
      tag PROPIETARIO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiEditor ) + Upper( LiTitulo );
      tag EDITOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( LiAnoEdic, 4 ) + Upper( LiTitulo );
      tag ANOEDIC;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiColecc ) + Upper( LiTitulo );
      tag COLECCION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( LiFchAdq ) + Upper( LiTitulo );
      tag FCHCOMPRA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( LiFechaPr ) + Upper( LiTitulo );
      tag FCHPRESTAMO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( LiFechaPr ) + Upper( LiPrestad );
      tag PRESTADOS;
      for ( !Empty( LiFechaPr ) .AND. !Empty( LiPrestad ) .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( LiUbicaci ) + Upper( LiTitulo );
      tag UBICACION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // DISCOS
   dbCloseAll()
   if File( cDir + "musica.cdx" )
      FErase( cDir + "musica.cdx" )
   endif
   Db_OpenNoIndex( "Musica", "MU" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Discos" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuCodigo );
      tag CODIGO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuTitulo );
      tag TITULO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuAutor ) + Upper( MuTitulo );
      tag INTERPRETE;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuMateria ) + Upper( MuTitulo );
      tag MATERIA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuAutor2 ) + Upper( MuTitulo );
      tag COMPOSITOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuDirector ) + Upper( MuTitulo );
      tag DIRECTOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuPropiet ) + Upper( MuTitulo );
      tag PROPIETARIO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuEditor ) + Upper( MuTitulo );
      tag EDITOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( MuAnoEdic, 4 ) + Upper( MuTitulo );
      tag ANOEDIC;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuColecc ) + Upper( MuTitulo );
      tag COLECCION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( MuFchAdq ) + Upper( MuTitulo );
      tag FCHCOMPRA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( MuFchPres ) + Upper( MuTitulo );
      tag FCHPRESTAMO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( MuFchPres ) + Upper( MuPrestad );
      tag PRESTADOS;
      for ( !Empty( MuFchPres ) .AND. !Empty( MuPrestad ) .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( MuUbicaci ) + Upper( MuTitulo );
      tag UBICACION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on MuSoporte;
      tag SOPORTE;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // CANCIONES
   dbCloseAll()
   if File( cDir + "cancion.cdx" )
      FErase( cDir + "cancion.cdx" )
   endif
   Db_OpenNoIndex( "Cancion", "CN" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Canciones" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CaTitulo );
      tag TITULO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CaInterp ) + Upper( CaTitulo );
      tag INTERPRETE;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CaAutor ) + Upper( CaTitulo );
      tag COMPOSITOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CaMateria ) + Upper( CaTitulo );
      tag MATERIA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CaDuracc ) + Upper( CaTitulo );
      tag DURACION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // CANCIONES DE DISCOS
   dbCloseAll()
   if File( cDir + "candisc.cdx" )
      FErase( cDir + "candisc.cdx" )
   endif
   Db_OpenNoIndex( "Candisc", "CD" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Canciones" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CdMuCodigo ) + Upper( CdOrden );
      tag CDMUCODIGO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CdCaTitulo );
      tag CDCATITULO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CdCaTitulo ) + Upper( CdCaAutor );
      tag TITAUTOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CdCaAutor ) + Upper( CdCaTitulo );
      tag AUTORTIT;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // SOFTWARE
   dbCloseAll()
   if File( cDir + "software.cdx" )
      FErase( cDir + "software.cdx" )
   endif
   Db_OpenNoIndex( "Software", "SO" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Software" ) )
   replace all SO->soentorno with 3 for SO->soentorno == 0
   dbCommit()
   dbGoTop()
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( SoCodigo );
      tag CODIGO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( SoTitulo );
      tag TITULO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( SoMateria ) + Upper( SoTitulo );
      tag MATERIA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( SoPropiet ) + Upper( SoTitulo );
      tag PROPIETARIO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( SoEditor ) + Upper( SoTitulo );
      tag EDITOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( SoFchComp ) + Upper( SoTitulo );
      tag FCHCOMPRA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( SoFecha ) + Upper( SoTitulo );
      tag FCHPRESTAMO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( SoFecha ) + Upper( SoPrestad );
      tag PRESTADOS;
      for ( !Empty( SoFecha ) .AND. !Empty( SoPrestad ) .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( SoGuardado ) + Upper( SoTitulo );
      tag UBICACION ;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // INTERNET
   dbCloseAll()
   if File( cDir + "internet.cdx" )
      FErase( cDir + "internet.cdx" )
   endif
   Db_OpenNoIndex( "Internet", "IN" )
   Db_Pack()
   oSay:SetText( i18n( "Direcciones de Internet" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( InCodigo );
      tag CODIGO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( InNombre );
      tag TITULO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( InMateria ) + Upper( InNombre );
      tag MATERIA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( InDirecc ) + Upper( InNombre );
      tag DIRECCION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( InDiseno, 1 ) + Upper( InNombre );
      tag VDISENO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1;
      descend
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( InConteni, 1 ) + Upper( InNombre );
      tag VCONTENIDO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1;
      descend
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( InValorac, 1 ) + Upper( InNombre );
      tag VGLOBAL;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1;
      descend
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( InFchVis ) + Upper( InNombre );
      tag FCHVISITA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( InServic ) + Upper( InNombre );
      tag SERVICIO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // VÍDEOS
   dbCloseAll()
   if File( cDir + "videos.cdx" )
      FErase( cDir + "videos.cdx" )
   endif
   Db_OpenNoIndex( "Videos", "VI" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Videos" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViNumero );
      tag CODIGO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViTitulo );
      tag TITULO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViOriginal );
      tag ORIGINAL;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViMateria ) + Upper( ViTitulo );
      tag MATERIA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViPropiet ) + Upper( ViTitulo );
      tag PROPIETARIO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViDirector ) + Upper( ViTitulo );
      tag DIRECTOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViActor ) + Upper( ViTitulo );
      tag ACTOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViActriz ) + Upper( ViTitulo );
      tag ACTRIZ;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViProduct ) + Upper( ViTitulo );
      tag EDITOR;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Str( ViAnyo, 4 ) + Upper( ViTitulo );
      tag ANOEDIC;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViColecc ) + Upper( ViTitulo );
      tag COLECCION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( ViFchAdq ) + Upper( ViTitulo );
      tag FCHCOMPRA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( ViFchPres ) + Upper( ViTitulo );
      tag FCHPRESTAMO;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on DToS( ViFchPres ) + Upper( ViPrestad );
      tag PRESTADOS;
      for ( !Empty( ViFchPres ) .AND. !Empty( ViPrestad ) .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViUbicaci ) + Upper( ViTitulo );
      tag UBICACION;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( ViFotogra ) + Upper( ViTitulo );
      tag FOTOGRAFIA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   dbCloseAll()

   // EDITORES
   Db_OpenNoIndex( "Editores", "ED" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Editores" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( EDNOMBRE );
      tag EDLIBROS;
      for ( EdTipo == "L" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( EDNOMBRE );
      tag EDDISCOS;
      for ( EDTIPO == "D" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( EDNOMBRE );
      tag EDVIDEOS;
      for ( EDTIPO == "V" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( EDNOMBRE );
      tag EDSOFTWARE;
      for ( EDTIPO == "S" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   dbCloseAll()

   // COLECCIONES
   Db_OpenNoIndex( "Colibros", "CL" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Colecciones" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CLNOMBRE );
      tag COLIBROS;
      for ( CLTIPO == "L" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CLNOMBRE );
      tag CODISCOS;
      for ( CLTIPO == "D" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CLNOMBRE );
      tag COVIDEOS;
      for ( CLTIPO == "V" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   dbCloseAll()

   // AUTORES
   Db_OpenNoIndex( "Autores", "AU" )
   Db_Pack()
   oSay:SetText( i18n( "Fichero de Autores" ) )
   oMeter:setRange( 0, RecCount() )
   // ESCRITORES
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag ESCRITORES;
      for ( AUCATEGOR == "E" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on AuMateria + AuNombre;
      tag MESCRITORES;
      for ( AUCATEGOR == "E" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // INTÉRPRETES DE DISCOS
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag INTERPRETES;
      for ( AUCATEGOR == "I" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on AuMateria + AuNombre;
      tag MINTERPRETES;
      for ( AUCATEGOR == "I" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // COMPOSITORES DE DISCOS
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag COMPOSITORES;
      for ( AUCATEGOR == "C" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on AuMateria + AuNombre;
      tag MCOMPOSITORES;
      for ( AUCATEGOR == "C" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // DIRECTORES DE ORQUESTA
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag DIRMUSICA;
      for ( AUCATEGOR == "D" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on AuMateria + AuNombre;
      tag MDIRMUSICA;
      for ( AUCATEGOR == "D" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // DIRECTORES DE CINE
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag DIRCINE;
      for ( AUCATEGOR == "T" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on AuMateria + AuNombre;
      tag MDIRCINE;
      for ( AUCATEGOR == "T" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // ACTORES / ACTRICES
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag ACTORES;
      for ( AUCATEGOR == "R" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on AuMateria + AuNombre;
      tag MACTORES;
      for ( AUCATEGOR == "R" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // FOTOGRAFÍA
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag FOTOGRAFIA;
      for ( AUCATEGOR == "F" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on AuMateria + AuNombre;
      tag MFOTOGRAFIA;
      for ( AUCATEGOR == "F" .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // TODOS LOS DE LIBROS: AUTORES (no usado)
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag ALL_LIBROS;
      for ( ( AUCATEGOR == "E" ) .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // TODOS LOS MUSICALES: INTÉRPRETES + COMPOSITORES + DIRECTORES
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag ALL_DISCOS;
      for ( ( AUCATEGOR == "I" .OR. AUCATEGOR == "C" .OR. AUCATEGOR == "D" ) .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1

   // TODOS LOS DE VÍDEOS: DIRECTORES + ACTORES/ACTRICES + FOTOGRAFÍA
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( AUNOMBRE );
      tag ALL_VIDEOS;
      for ( ( AUCATEGOR == "T" .OR. AUCATEGOR == "R" .OR. AUCATEGOR == "F" ) .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   dbCloseAll()

   // AGENDA
   Db_OpenNoIndex( "Agenda", "AG" )
   Db_Pack()
   oSay:SetText( i18n( "Agenda de Direcciones" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( PENOMBRE );
      tag CONTACTOS;
      for ( PePropiet == .F. .AND. PeCompras == .F. .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( PENOMBRE );
      tag PROPIETARIOS;
      for ( PePropiet == .T.  .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( PENOMBRE );
      tag COMPRAS;
      for ( PeCompras == .T. .AND. !Deleted() );
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   dbCloseAll()

   // CATEGORÍAS DE LA AGENDA
   Db_OpenNoIndex( "Categori", "CA" )
   Db_Pack()
   oSay:SetText( i18n( "Categorias de Ocio" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( CATEGORIA );
      tag TODOS;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   dbCloseAll()

   // IDIOMAS
   Db_OpenNoIndex( "Idiomas", "ID" )
   Db_Pack()
   oSay:SetText( i18n( "Idiomas" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( IDIOMA );
      tag IDIOMA;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   dbCloseAll()

   // IDIOMAS
   Db_OpenNoIndex( "SOPORTE", "SM" )
   Db_Pack()
   oSay:SetText( i18n( "Soporte" ) )
   oMeter:setRange( 0, RecCount() )
   Ut_ReiniciarMeter( oMeter, @nMeter )
   index on Upper( SMSOPORTE );
      tag SOPORTE;
      for ! Deleted();
      eval Ut_AvanzaMeter( oMeter, @nMeter );
      every 1
   dbCloseAll()

return nil

// Comprobación de integridad ___________________________________________________________

function Ut_Integridad( oSay, oMeter )

   local nMeter := 0
   local aMuSoporte := { "CD", "Casette", "MiniDisc", "Vinilo", "Otro" }

   oSay:SetText( i18n( "Comprobando integridad" ) )
   oMeter:setRange( 0, 9 ) // 9 en lugar de 10 xq si no no se pinta tenero :S
   Ut_ReiniciarMeter( oMeter, @nMeter )

   if ! Db_OpenAll()
      return nil
   endif

   select MA // no funciona si no lo pongo
   MA->( ordSetFocus( 0 ) )
   MA->( dbGoTop() )
   replace MA->MaNumLibr with 0 while ! MA->( Eof() )
   select UB // no funciona si no lo pongo
   UB->( ordSetFocus( 0 ) )
   UB->( dbGoTop() )
   replace UB->UbItems   with 0 while ! UB->( Eof() )
   select AU // no funciona si no lo pongo
   AU->( ordSetFocus( 0 ) )
   AU->( dbGoTop() )
   replace AU->AuNumEjem with 0 while ! AU->( Eof() )
   select ED // no funciona si no lo pongo
   ED->( ordSetFocus( 0 ) )
   ED->( dbGoTop() )
   replace ED->EdNumEjem with 0 while ! ED->( Eof() )
   select CL // no funciona si no lo pongo
   CL->( ordSetFocus( 0 ) )
   CL->( dbGoTop() )
   replace CL->ClNumEjem with 0 while ! CL->( Eof() )
   select NO
   zap

   // *** LIBROS
   LI->( dbGoTop() )
   while ! LI->( Eof() )
      // autor
      AU->( ordSetFocus( "escritores" ) )
      AU->( dbGoTop() )
      if !Empty( LI->LiAutor )
         if ! AU->( dbSeek( Upper( LI->LiAutor ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "E"
            replace AU->AuNombre  with LI->LiAutor
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
         endif
      endif
      // materia
      MA->( ordSetFocus( "lmateria" ) )
      MA->( dbGoTop() )
      if !Empty( LI->LiMateria )
         if ! MA->( dbSeek( Upper( LI->LiMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with "L"
            replace MA->MaMateria with LI->LiMateria
            replace MA->MaNumLibr with 1
         else
            replace MA->MaNumLibr with MA->MaNumLibr + 1
         endif
      endif
      // idioma
      ID->( ordSetFocus( "idioma" ) )
      ID->( dbGoTop() )
      if !Empty( LI->LiIdioma )
         if ! ID->( dbSeek( Upper( LI->LiIdioma ) ) )
            ID->( dbAppend() )
            replace ID->Idioma with LI->LiIdioma
         endif
      endif
      // propietario
      AG->( ordSetFocus( "propietarios" ) )
      AG->( dbGoTop() )
      if !Empty( LI->LiPropiet )
         if ! AG->( dbSeek( Upper( LI->LiPropiet ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with LI->LiPropiet
            replace AG->PePropiet with .T.
         endif
      endif
      // ubicación
      UB->( ordSetFocus( "lubicacion" ) )
      UB->( dbGoTop() )
      if !Empty( LI->LiUbicaci )
         if ! UB->( dbSeek( Upper( LI->LiUbicaci ) ) )
            UB->( dbAppend() )
            replace UB->UbTipo    with "L"
            replace UB->UbUbicaci with LI->LiUbicaci
            replace UB->UbItems   with 1
         else
            replace UB->UbItems with UB->UbItems + 1
         endif
         // UB->( dbCommit() )
      endif
      // editorial
      ED->( ordSetFocus( "edlibros" ) )
      ED->( dbGoTop() )
      if !Empty( LI->LiEditor )
         if ! ED->( dbSeek( Upper( LI->LiEditor ) ) )
            ED->( dbAppend() )
            replace ED->EdTipo   with "L"
            replace ED->EdNombre with LI->LiEditor
            replace ED->EdNumEjem with 1
         else
            replace ED->EdNumEjem with ED->EdNumEjem + 1
         endif
      endif
      // colección
      CL->( ordSetFocus( "colibros" ) )
      CL->( dbGoTop() )
      if !Empty( LI->LiColecc )
         if ! CL->( dbSeek( Upper( LI->LiColecc ) ) )
            CL->( dbAppend() )
            replace CL->ClTipo   with "L"
            replace CL->ClNombre with LI->LiColecc
            replace CL->ClNumEjem with 1
         else
            replace CL->ClNumEjem with CL->ClNumEjem + 1
            // CL->( dbCommit() )
         endif
      endif
      // centro de compra
      AG->( ordSetFocus( "compras" ) )
      AG->( dbGoTop() )
      if !Empty( LI->LiProveed )
         if ! AG->( dbSeek( Upper( LI->LiProveed ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with LI->LiProveed
            replace AG->PeCompras with .T.
            // AG->( dbCommit() )
         endif
      endif
      // prestatario
      if IsPrestado( "LI" )
         NO->( dbAppend() )
         if Empty( LI->LiCodigo )
            Ut_PedirCodigo( "L" )
         endif
         replace NO->NoTipo    with 1
         replace NO->NoCodigo  with LI->LiCodigo
         replace NO->NoFecha   with LI->LiFechaPr
         replace NO->NoTitulo  with LI->LiTitulo
         replace NO->NoAQuien  with LI->LiPrestad
         // NO->( dbCommit() )
      endif
      LI->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // *** DISCOS
   MU->( dbGoTop() )
   while ! MU->( Eof() )
      // propietario
      AG->( ordSetFocus( "propietarios" ) )
      AG->( dbGoTop() )
      if !Empty( MU->MuPropiet )
         if ! AG->( dbSeek( Upper( MU->MuPropiet ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with MU->MuPropiet
            replace AG->PePropiet with .T.
            // AG->( dbCommit() )
         endif
      endif
      // compositor
      AU->( ordSetFocus( "compositores" ) )
      AU->( dbGoTop() )
      if !Empty( MU->MuAutor2 )
         if ! AU->( dbSeek( Upper( MU->MuAutor2 ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "C"
            replace AU->AuNombre  with MU->MuAutor2
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
         endif
      endif
      // intérprete
      AU->( ordSetFocus( "interpretes" ) )
      AU->( dbGoTop() )
      if !Empty( MU->MuAutor )
         if ! AU->( dbSeek( Upper( MU->MuAutor ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "I"
            replace AU->AuNombre  with MU->MuAutor
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
         endif
      endif
      // director
      AU->( ordSetFocus( "dirmusica" ) )
      AU->( dbGoTop() )
      if !Empty( MU->MuDirector )
         if ! AU->( dbSeek( Upper( MU->MuDirector ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "D"
            replace AU->AuNombre  with MU->MuDirector
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
         endif
      endif
      // género
      MA->( ordSetFocus( "mmateria" ) )
      MA->( dbGoTop() )
      if !Empty( MU->MuMateria )
         if ! MA->( dbSeek( Upper( MU->MuMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with "M"
            replace MA->MaMateria with MU->MuMateria
            replace MA->MaNumLibr with 1
         else
            replace MA->MaNumLibr with MA->MaNumLibr + 1
         endif
      endif
      // idioma
      ID->( ordSetFocus( "idioma" ) )
      ID->( dbGoTop() )
      if !Empty( MU->MuIdioma )
         if ! ID->( dbSeek( Upper( MU->MuIdioma ) ) )
            ID->( dbAppend() )
            replace ID->Idioma with MU->MuIdioma
            // ID->( dbCommit() )
         endif
      endif
      // productora
      ED->( ordSetFocus( "eddiscos" ) )
      ED->( dbGoTop() )
      if !Empty( MU->MuEditor )
         if ! ED->( dbSeek( Upper( MU->MuEditor ) ) )
            ED->( dbAppend() )
            replace ED->EdTipo   with "D"
            replace ED->EdNombre with MU->MuEditor
            replace ED->EdNumEjem with 1
         else
            replace ED->EdNumEjem with ED->EdNumEjem + 1
         endif
      endif
      // ubicación
      UB->( ordSetFocus( "mubicacion" ) )
      UB->( dbGoTop() )
      if !Empty( MU->MuUbicaci )
         if ! UB->( dbSeek( Upper( MU->MuUbicaci ) ) )
            UB->( dbAppend() )
            replace UB->UbTipo    with "M"
            replace UB->UbUbicaci with MU->MuUbicaci
            replace UB->UbItems   with 1
         else
            replace UB->UbItems with UB->UbItems + 1
         endif
      endif
      // prestatario
      if IsPrestado( "MU" )
         NO->( dbAppend() )
         if Empty( MU->MuCodigo )
            Ut_PedirCodigo( "M" )
         endif
         replace NO->NoTipo    with 2
         replace NO->NoCodigo  with MU->MuCodigo
         replace NO->NoFecha   with MU->MuFchPres
         replace NO->NoTitulo  with MU->MuTitulo
         replace NO->NoAQuien  with MU->MuPrestad
      endif
      // centro de compra
      AG->( ordSetFocus( "compras" ) )
      AG->( dbGoTop() )
      if !Empty( MU->MuProveed )
         if ! AG->( dbSeek( Upper( MU->MuProveed ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with MU->MuProveed
            replace AG->PeCompras with .T.
            // AG->( dbCommit() )
         endif
      endif
      // colección
      CL->( ordSetFocus( "codiscos" ) )
      CL->( dbGoTop() )
      if !Empty( MU->MuColecc )
         if ! CL->( dbSeek( Upper( MU->MuColecc ) ) )
            CL->( dbAppend() )
            replace CL->ClTipo   with "D"
            replace CL->ClNombre with MU->MuColecc
            replace CL->ClNumEjem with 1
         else
            replace CL->ClNumEjem with CL->ClNumEjem + 1
         endif
      endif
      // soporte
      SM->( ordSetFocus( "soporte" ) )
      SM->( dbGoTop() )
      if MU->MuSoporte != 0
         replace MU->MuSopTxt with aMuSoporte[ MU->MuSoporte ]
         replace MU->MuSoporte with 0
      endif
      if !Empty( MU->MuSopTxt )
         if ! SM->( dbSeek( Upper( MU->MuSopTxt ) ) )
            SM->( dbAppend() )
            replace SM->SmSoporte with MU->MuSopTxt
            // CL->( dbCommit() )
         endif
      endif
      MU->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // *** VÍDEOS
   while ! VI->( Eof() )
      // propietario
      AG->( ordSetFocus( "propietarios" ) )
      AG->( dbGoTop() )
      if !Empty( VI->ViPropiet )
         if ! AG->( dbSeek( Upper( VI->ViPropiet ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with VI->ViPropiet
            replace AG->PePropiet with .T.
            // AG->( dbCommit() )
         endif
      endif
      // materia
      MA->( ordSetFocus( "vmateria" ) )
      MA->( dbGoTop() )
      if !Empty( VI->ViMateria )
         if ! MA->( dbSeek( Upper( VI->ViMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with "V"
            replace MA->MaMateria with VI->ViMateria
            replace MA->MaNumLibr with 1
         else
            replace MA->MaNumLibr with MA->MaNumLibr + 1
         endif
         // MA->( dbCommit() )
      endif
      // idioma
      ID->( ordSetFocus( "idioma" ) )
      ID->( dbGoTop() )
      if !Empty( VI->ViIdioma )
         if ! ID->( dbSeek( Upper( VI->ViIdioma ) ) )
            ID->( dbAppend() )
            replace ID->Idioma with VI->ViIdioma
            // ID->( dbCommit() )
         endif
      endif
      // ubicación
      UB->( ordSetFocus( "vubicacion" ) )
      UB->( dbGoTop() )
      if !Empty( VI->ViUbicaci )
         if ! UB->( dbSeek( Upper( VI->ViUbicaci ) ) )
            UB->( dbAppend() )
            replace UB->UbTipo    with "V"
            replace UB->UbUbicaci with VI->ViUbicaci
            replace UB->UbItems   with 1
         else
            replace UB->UbItems with UB->UbItems + 1
         endif
         // UB->( dbCommit() )
      endif
      // director
      AU->( ordSetFocus( "dircine" ) )
      AU->( dbGoTop() )
      if !Empty( VI->ViDirector )
         if ! AU->( dbSeek( Upper( VI->ViDirector ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "T"
            replace AU->AuNombre  with VI->ViDirector
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
         endif
      endif
      // actor
      AU->( ordSetFocus( "actores" ) )
      AU->( dbGoTop() )
      if !Empty( VI->ViActor )
         if ! AU->( dbSeek( Upper( VI->ViActor ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "R"
            replace AU->AuNombre  with VI->ViActor
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
            // AU->( dbCommit() )
         endif
      endif
      // actriz
      AU->( ordSetFocus( "actores" ) )
      AU->( dbGoTop() )
      if !Empty( VI->ViActriz )
         if ! AU->( dbSeek( Upper( VI->ViActriz ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "R"
            replace AU->AuNombre  with VI->ViActriz
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
         endif
      endif
      // director de fotografía
      AU->( ordSetFocus( "fotografia" ) )
      AU->( dbGoTop() )
      if !Empty( VI->ViFotogra )
         if ! AU->( dbSeek( Upper( VI->ViFotogra ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "F"
            replace AU->AuNombre  with VI->ViFotogra
            replace AU->AuNumEjem with 1
         else
            replace AU->AuNumEjem with AU->AuNumEjem + 1
         endif
      endif
      // productora
      ED->( ordSetFocus( "edvideos" ) )
      ED->( dbGoTop() )
      if !Empty( VI->ViProduct )
         if ! ED->( dbSeek( Upper( VI->ViProduct ) ) )
            ED->( dbAppend() )
            replace ED->EdTipo   with "V"
            replace ED->EdNombre with VI->ViProduct
            replace ED->EdNumEjem with 1
         else
            replace ED->EdNumEjem with ED->EdNumEjem + 1
         endif
      endif
      // prestatario
      if IsPrestado( "VI" )
         NO->( dbAppend() )
         if Empty( VI->ViNumero )
            Ut_PedirCodigo( "V" )
         endif
         replace NO->NoTipo    with 3
         replace NO->NoCodigo  with VI->ViNumero
         replace NO->NoFecha   with VI->ViFchPres
         replace NO->NoTitulo  with VI->ViTitulo
         replace NO->NoAQuien  with VI->ViPrestad
         // NO->( dbCommit() )
      endif
      // centro de compra
      AG->( ordSetFocus( "compras" ) )
      AG->( dbGoTop() )
      if !Empty( VI->ViProveed )
         if ! AG->( dbSeek( Upper( VI->ViProveed ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with VI->ViProveed
            replace AG->PeCompras with .T.
            // AG->( dbCommit() )
         endif
      endif
      // intérprete bso
      AU->( ordSetFocus( "interpretes" ) )
      AU->( dbGoTop() )
      if !Empty( VI->ViBsoAut )
         if ! AU->( dbSeek( Upper( VI->ViBsoAut ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "I"
            replace AU->AuNombre  with VI->ViBsoAut
            // Aqui no incremento el número de ejemplares
         endif
      endif
      // productora bso
      ED->( ordSetFocus( "eddiscos" ) )
      ED->( dbGoTop() )
      if !Empty( VI->ViBsoEdi )
         if ! ED->( dbSeek( Upper( VI->ViBsoEdi ) ) )
            ED->( dbAppend() )
            replace ED->EdTipo   with "D"
            replace ED->EdNombre with VI->ViBsoEdi
            // Aqui no incremento el número de ejemplares
         endif
      endif
      // colección
      CL->( ordSetFocus( "covideos" ) )
      CL->( dbGoTop() )
      if !Empty( VI->ViColecc )
         if ! CL->( dbSeek( Upper( VI->ViColecc ) ) )
            CL->( dbAppend() )
            replace CL->ClTipo   with "V"
            replace CL->ClNombre with VI->ViColecc
            replace CL->ClNumEjem with 1
         else
            replace CL->ClNumEjem with CL->ClNumEjem + 1
         endif
      endif
      // calificación moral: compatibilidad con versiones anteriores a la 6.0
      do case
      case VI->ViCalific == i18n( "Todos los públicos" )
         replace VI->ViCalific with "TP"
      case VI->ViCalific == i18n( "Mayores de 7 años" )
         replace VI->ViCalific with "+7"
      case VI->ViCalific == i18n( "Mayores de 13 años" )
         replace VI->ViCalific with "+13"
      case VI->ViCalific == i18n( "Mayores de 18 años" )
         replace VI->ViCalific with "+18"
      end case
      // soporte
      if VI->ViSoporte == 0
         replace VI->ViSoporte with 1
      endif
      VI->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // *** SOFTWARE
   while ! SO->( Eof() )
      // propietario
      AG->( ordSetFocus( "propietarios" ) )
      AG->( dbGoTop() )
      if !Empty( SO->SoPropiet )
         if ! AG->( dbSeek( Upper( SO->SoPropiet ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with SO->SoPropiet
            replace AG->PePropiet with .T.
            // AG->( dbCommit() )
         endif
      endif
      // materia
      MA->( ordSetFocus( "smateria" ) )
      MA->( dbGoTop() )
      if !Empty( SO->SoMateria )
         if ! MA->( dbSeek( Upper( SO->SoMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with "S"
            replace MA->MaMateria with SO->SoMateria
            replace MA->MaNumLibr with 1
         else
            replace MA->MaNumLibr with MA->MaNumLibr + 1
         endif
         // MA->( dbCommit() )
      endif
      // idioma
      ID->( ordSetFocus( "idioma" ) )
      ID->( dbGoTop() )
      if !Empty( SO->SoIdioma )
         if ! ID->( dbSeek( Upper( SO->SoIdioma ) ) )
            ID->( dbAppend() )
            replace ID->Idioma with SO->SoIdioma
            // ID->( dbCommit() )
         endif
      endif
      // compañía
      ED->( ordSetFocus( "edsoftware" ) )
      ED->( dbGoTop() )
      if !Empty( SO->SoEditor )
         if ! ED->( dbSeek( Upper( SO->SoEditor ) ) )
            ED->( dbAppend() )
            replace ED->EdTipo   with "S"
            replace ED->EdNombre with SO->SoEditor
            replace ED->EdNumEjem with 1
         else
            replace ED->EdNumEjem with ED->EdNumEjem + 1
         endif
      endif
      // centro de compra
      AG->( ordSetFocus( "compras" ) )
      AG->( dbGoTop() )
      if !Empty( SO->SoProveed )
         if ! AG->( dbSeek( Upper( SO->SoProveed ) ) )
            AG->( dbAppend() )
            replace AG->PeNombre  with SO->SoProveed
            replace AG->PeCompras with .T.
            // AG->( dbCommit() )
         endif
      endif
      // ubicación
      UB->( ordSetFocus( "subicacion" ) )
      UB->( dbGoTop() )
      if !Empty( SO->SoGuardado )
         if ! UB->( dbSeek( Upper( SO->SoGuardado ) ) )
            UB->( dbAppend() )
            replace UB->UbTipo    with "S"
            replace UB->UbUbicaci with SO->SoGuardado
            replace UB->UbItems   with 1
         else
            replace UB->UbItems with UB->UbItems + 1
         endif
         // UB->( dbCommit() )
      endif
      // prestatario
      if IsPrestado( "SO" )
         NO->( dbAppend() )
         if Empty( SO->SoCodigo )
            Ut_PedirCodigo( "S" )
         endif
         replace NO->NoTipo    with 4
         replace NO->NoCodigo  with SO->SoCodigo
         replace NO->NoFecha   with SO->SoFecha
         replace NO->NoTitulo  with SO->SoTitulo
         replace NO->NoAQuien  with SO->SoPrestad
         // NO->( dbCommit() )
      endif
      // entorno: compatibilidad con versiones anteriores a la 6.0
      if SO->SoEntorno != 0 // no ha sido actualizado ya
         switch SO->SoEntorno
         case 1
            replace SO->SoEntorno6 with 1
            exit
         case 2
         case 3
         case 4
            replace SO->SoEntorno6 with 2
            exit
         case 5
            replace SO->SoEntorno6 with 3
            exit
         end
         replace SO->SoEntorno with 0  // registro actualizado
      endif
      SO->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // *** INTERNET
   while ! IN->( Eof() )
      // idioma
      ID->( ordSetFocus( "idioma" ) )
      ID->( dbGoTop() )
      // ¿compatibilidad con versiones anteriores a la 5.2? en principio no es necesario
      if IN->InIdioma < 0 .OR. IN->InIdioma > 3
         replace IN->InIdioma with 3
      endif
      // compatibilidad con versiones anteriores a la 6.0
      if IN->InIdioma != 0 // no ha sido actualizado ya
         switch IN->InIdioma
         case 1
            replace IN->InIdiomaC with i18n( "Español" )
            exit
         case 2
            replace IN->InIdiomaC with i18n( "Inglés" )
            exit
         case 3
            replace IN->InIdiomaC with IN->InOtroId
            exit
         end switch
         replace IN->InIdioma with 0  // registro actualizado
         replace IN->InOtroId with ""
      endif
      if !Empty( IN->InIdiomaC )
         if ! ID->( dbSeek( Upper( IN->InIdiomaC ) ) )
            ID->( dbAppend() )
            replace ID->Idioma with IN->InIdiomaC
            // ID->( dbCommit() )
         endif
      endif
      // materia
      MA->( ordSetFocus( "imateria" ) )
      MA->( dbGoTop() )
      if !Empty( IN->InMateria )
         if ! MA->( dbSeek( Upper( IN->InMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with "I"
            replace MA->MaMateria with IN->InMateria
            replace MA->MaNumLibr with 1
         else
            replace MA->MaNumLibr with MA->MaNumLibr + 1
         endif
         // MA->( dbCommit() )
      endif
      IN->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // *** CANCIONES
   while ! CN->( Eof() )
      // materia
      MA->( ordSetFocus( "mmateria" ) )
      MA->( dbGoTop() )
      if !Empty( CN->CaMateria )
         if ! MA->( dbSeek( Upper( CN->CaMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with "M"
            replace MA->MaMateria with CN->CaMateria
            replace MA->MaNumLibr with 0
         endif
         // MA->( dbCommit() )
      endif
      // compositor
      AU->( ordSetFocus( "compositores" ) )
      AU->( dbGoTop() )
      if !Empty( CN->CaAutor )
         if ! AU->( dbSeek( Upper( CN->CaAutor ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "C"
            replace AU->AuNombre  with CN->CaAutor
            // AU->( dbCommit() )
         endif
      endif
      // idioma
      ID->( ordSetFocus( "idioma" ) )
      ID->( dbGoTop() )
      if !Empty( CN->CaIdioma )
         if ! ID->( dbSeek( Upper( CN->CaIdioma ) ) )
            ID->( dbAppend() )
            replace ID->Idioma with CN->CaIdioma
            // ID->( dbCommit() )
         endif
      endif
      CN->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // ***AUTORES
   AU->( dbGoTop() )
   while ! AU->( Eof() )
      // materia
      switch AU->AuCategor
      case "E"
         MA->( ordSetFocus( "lmateria" ) )
         exit
      case "I"
      case "C"
      case "D"
         MA->( ordSetFocus( "mmateria" ) )
         exit
      case "T"
      case "R"
      case "F"
         MA->( ordSetFocus( "vmateria" ) )
         exit
      end switch
      MA->( dbGoTop() )
      if !Empty( AU->AuMateria )
         if ! MA->( dbSeek( Upper( AU->AuMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with AU->AuCategor
            replace MA->MaMateria with AU->AuMateria
            replace MA->MaNumLibr with 0
         endif
      endif
      AU->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // COLECCIONES
   CL->( dbGoTop() )
   while ! CL->( Eof() )
      // editorial/productora
      switch CL->ClTipo
      case "L"
         ED->( ordSetFocus( "edlibros" ) )
         exit
      case "D"
         ED->( ordSetFocus( "eddiscos" ) )
         exit
      case "V"
         ED->( ordSetFocus( "edvideos" ) )
         exit
      end switch
      ED->( dbGoTop() )
      if !Empty( CL->ClEditor )
         if ! ED->( dbSeek( Upper( CL->ClEditor ) ) )
            ED->( dbAppend() )
            replace ED->EdTipo    with CL->ClTipo
            replace ED->EdNombre  with CL->ClEditor
         endif
         // ED->( dbCommit() )
      endif
      // materia
      switch CL->ClTipo
      case "L"
         MA->( ordSetFocus( "lmateria" ) )
         exit
      case "D"
         MA->( ordSetFocus( "mmateria" ) )
         exit
      case "V"
         MA->( ordSetFocus( "vmateria" ) )
         exit
      end switch
      MA->( dbGoTop() )
      if !Empty( CL->ClMateria )
         if ! MA->( dbSeek( Upper( CL->ClMateria ) ) )
            MA->( dbAppend() )
            replace MA->MaTipo    with CL->ClTipo
            replace MA->MaMateria with CL->ClMateria
            replace MA->MaNumLibr with 0
         endif
         // MA->( dbCommit() )
      endif
      CL->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // *** AGENDA
   AG->( dbGoTop() )
   while ! AG->( Eof() )
      // categoría de ocio
      CA->( ordSetFocus( "todos" ) )
      CA->( dbGoTop() )
      if !Empty( AG->PeOCategor )
         if ! CA->( dbSeek( Upper( AG->PeOCategor ) ) )
            CA->( dbAppend() )
            replace CA->Tipo      with "O"
            replace CA->Categoria with AG->PeOCategor
            // CA->( dbCommit() )
         endif
      endif
      AG->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()

   // CANCIONES DE DISCOS
   CD->( dbGoTop() )
   while ! CD->( Eof() )
      // compositor de la canción
      AU->( ordSetFocus( "compositores" ) )
      AU->( dbGoTop() )
      if !Empty( CD->CdCaAutor )
         if ! AU->( dbSeek( Upper( CD->CdCaAutor ) ) )
            AU->( dbAppend() )
            replace AU->AuCategor with "C"
            replace AU->AuNombre  with CD->CdCaAutor
            // AU->( dbCommit() )
         endif
      endif
      // idioma de la canción
      ID->( ordSetFocus( "idioma" ) )
      ID->( dbGoTop() )
      if !Empty( CD->CdCaIdioma )
         if ! ID->( dbSeek( Upper( CD->CdCaIdioma ) ) )
            ID->( dbAppend() )
            replace ID->Idioma with CD->CdCaIdioma
            // ID->( dbCommit() )
         endif
      endif
      CD->( dbSkip() )
   end while
   dbCommitAll()
   oMeter:SetPos( nMeter++ )
   Sysrefresh()
   dbCloseAll()
   CursorArrow()

   //if lMsg
   //   msgInfo( i18n( "La regeneración de índices se realizó correctamente." ) )
   //endif

return nil
/*_____________________________________________________________________________*/

function Ut_ReiniciarMeter( oMeter, nMeter )

   nMeter := 0
   oMeter:SetPos( nMeter )
   oMeter:Refresh()

return nil
/*_____________________________________________________________________________*/

function Ut_PedirCodigo( cTipo )

   local oDlg
   local aSay    := Array( 02 )
   local aGet    := Array( 03 )
   local aBtn    := Array( 01 )

   local cMsg   := ""
   local cSayTit := ""
   local cBitmap := ""
   local cAlias  := ""
   local cFldTit := ""
   local cFldCod := ""
   local bClave  := {|| NIL }
   local lIdOk

   local cTitulo := ""
   local cCodigo := ""

   switch cTipo
   case "L"
      cMsg    := i18n( "El siguiente libro prestado no lo tiene, por lo que es necesario que le asigne uno." )
      cSayTit := i18n( "Título" )
      cBitmap := "BB_LIBROS1"
      cAlias  := "LI"
      cFldTit := "LiTitulo"
      cFldCod := "LiCodigo"
      bClave  := {|| LiClave( cCodigo, aGet[ 03 ], "add" ) }
      exit
   case "M"
      cMsg    := i18n( "El siguiente disco prestado no lo tiene, por lo que es necesario que le asigne uno." )
      cSayTit := i18n( "Título" )
      cBitmap := "BB_DISCOS1"
      cAlias  := "MU"
      cFldTit := "MuTitulo"
      cFldCod := "MuCodigo"
      bClave  := {|| MuClave( cCodigo, aGet[ 03 ], "add" ) }
      exit
   case "V"
      cMsg    := i18n( "El siguiente vídeo prestado no lo tiene, por lo que es necesario que le asigne uno." )
      cSayTit := i18n( "Título" )
      cBitmap := "BB_VIDEOS1"
      cAlias  := "VI"
      cFldTit := "ViTitulo"
      cFldCod := "ViNumero"
      bClave  := {|| ViClave( cCodigo, aGet[ 03 ], "add" ) }
      exit
   case "S"
      cMsg    := i18n( "El siguiente software prestado no lo tiene, por lo que es necesario que le asigne uno." )
      cSayTit := i18n( "Nombre" )
      cBitmap := "BB_SOFTWARE"
      cAlias  := "SO"
      cFldTit := "SoTitulo"
      cFldCod := "SoCodigo"
      bClave  := {|| SoClave( cCodigo, aGet[ 03 ], "add" ) }
      exit
   end switch

   cTitulo := ( cAlias )->&cFldTit
   cCodigo := ( cAlias )->&cFldCod

   DEFINE DIALOG oDlg OF oApp():oWndMain RESOURCE "UT_PEDIRCODIGO"
   oDlg:SetFont(oApp():oFont)

   REDEFINE say aSay[ 01 ] ;
      ID 200 ;
      OF oDlg ;
      prompt i18n( "Es obligatorio que todos los ejemplares tengan un código único." ) + cMsg;

      REDEFINE say aSay[ 02 ] ;
      ID 201 ;
      OF oDlg ;
      prompt cSayTit

   REDEFINE BITMAP aGet[ 01 ] ;
      ID 100 ;
      OF oDlg ;
      RESOURCE cBitmap ;
      TRANSPARENT

   REDEFINE get aGet[ 02 ] ;
      var cTitulo ;
      ID 101 ;
      OF oDlg ;
      when .F.

   REDEFINE get aGet[ 03 ] ;
      var cCodigo ;
      ID 102 ;
      OF oDlg ;
      VALID ( Eval( bClave ) )

   REDEFINE BUTTON aBtn[ 01 ];
      ID 103;
      OF oDlg;
      ACTION ( GetNewCod( .T., cAlias, cFldCod, @cCodigo ), aGet[ 03 ]:refresh(), aGet[ 03 ]:setFocus() )

   aBtn[ 01 ]:cToolTip := i18n( "generar código autonumérico" )

   REDEFINE BUTTON ;
      ID IDOK ;
      OF oDlg ;
      ACTION ( if( Eval( aGet[ 03 ]:bValid ), ( lIdOk := .T., oDlg:end() ), ) )

   ACTIVATE DIALOG oDlg ;
      on init oDlg:Center( oApp():oWndMain ) ;
      valid !Empty( cCodigo ) ;

      ( cAlias )->&cFldCod := cCodigo

return nil
/*_____________________________________________________________________________*/

function Ut_AvanzaMeter( oMeter, nMeter )

   oMeter:SetPos( nMeter++ )
   if nMeter < RecCount()
      oMeter:StepIt()
   endif
   SysRefresh()

return .T.
/*_____________________________________________________________________________*/

function Ut_AztActualizar( lMsg )

   local oDlgProgress, oSay01, oSay02, oBmp, oProgress
   local cDir := oApp():cAztPath

   if oApp():oDlg != nil
      if oApp():nEdit > 0
         msgStop( i18n( "No puede realizar esta operación hasta que no cierre las ventanas abiertas sobre el mantenimiento que está manejando." ) )
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   DEFINE DIALOG oDlgProgress RESOURCE 'UT_INDEXAR_' + oApp():cLanguage OF oApp():oWndMain
   oDlgProgress:SetFont(oApp():oFont)
   REDEFINE BITMAP oBmp ID 111 OF oDlgProgress RESOURCE 'BB_INDEX' TRANSPARENT
   REDEFINE say oSay01 prompt i18n( "Actualizando ficheros de datos" ) ID 99  OF oDlgProgress
   REDEFINE say oSay02 prompt Space( 30 ) ID 10  OF oDlgProgress

   oProgress := TProgress():Redefine( 101, oDlgProgress )

   oDlgProgress:bStart := {|| SysRefresh(), Ut_AztCrearDbf( oDlgProgress, cDir, oSay02, oProgress ), oDlgProgress:End() }
   ACTIVATE DIALOG oDlgProgress ;
      on init DlgCenter( oDlgProgress, oApp():oWndMain )

return nil

/*_____________________________________________________________________________*/

function Ut_AztCrearDbf( oDlgT, cDir, oSay, lMsg )

   CursorWait()

   oSay:SetText( 'Fichero de documentos' )
   dbCreate( cDir + 'na', { { "ARTITULO", "C", 150,   0 },;
      { "ARCODIGO", "C",  20,   0 },;
      { "ARAUTORES", "C", 240,   0 },;
      { "ARAUTOR", "C",  40,   0 },;
      { "ARMATERIA", "C",  40,   0 },;
      { "ARTAGS", "C", 240,   0 },;
      { "ARPUBLICAC", "C",  50,   0 },;
      { "ARNUMERO", "C",   6,   0 },;
      { "ARFECHAED", "D",   8,   0 },;
      { "ARDESCRIP", "M",  10,   0 },;
      { "ARSELECT", "C",   1,   0 },;
      { "ARPAPEL", "L",   1,   0 },;
      { "ARELECTRO", "L",   1,   0 },;
      { "ARUBICACI", "C",  60,   0 },;
      { "ARLOCALIZ", "C",  20,   0 },;
      { "ARPATH", "C", 200,   0 },;
      { "ARTIPO", "N",   2,   0 },;
      { "ARVOLUMEN", "C",  20,   0 },;
      { "ARFECHALEC", "D",   8,   0 },;
      { "ARPAGINI", "N",   4,   0 },;
      { "ARPAGFIN", "N",   4,   0 },;
      { "ARNUMPAG", "N",   4,   0 },;
      { "ARTIPODOC", "C",  30,   0 },;
      { "ARUNICO", "C",  15,   0 },;
      { "ARIDIOMA", "C",  15,   0 },;
      { "ARRESUMEN", "C",  80,   0 },;
      { "ARURL", "C", 200,   0 } } )
   close all
   dbUseArea(.T.,,cDir+'na')
   select na
   if File( cDir + 'ARTICULO.DBF' )
      FErase( cDir + 'articulo.cdx' )
      dbAppendFrom( cDir + 'articulo' )
      dbCommitAll()
      close all
      FErase( cDir + 'articulo.dbf' )
      FErase( cDir + 'articulo.fpt' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'articulo.dbf' )
   FRename( cDir + 'na.fpt', cDir + 'articulo.fpt' )
   Db_AztOpenNoIndex( 'ARTICULO', 'AR' )
   dbGoTop()
   do while ! Eof()
      if Empty( AR->ArUnico )
         replace AR->ArUnico with DToS( Date() ) + Str( Seconds() * 100, 7 )
         Inkey( 0.06 )
      endif
      dbSkip()
   enddo
   dbCloseAll()
   // autores
   oSay:SetText( 'Fichero de Autores' )
   dbCreate( cDir + 'na', { { "AUNOMBRE", "C",  50,   0 },;
      { "AUMATERIA", "C",  40,   0 },;
      { "AUEJEMPL", "N",   6,   0 },;
      { "AUNOTAS", "C", 255,   0 },;
      { "AUDIRECC", "C",  50,   0 },;
      { "AUTELEFONO", "C",  30,   0 },;
      { "AULOCALI", "C",  50,   0 },;
      { "AUPAIS", "C",  30,   0 },;
      { "AUEMAIL", "C",  50,   0 },;
      { "AUURL", "C",  50,   0 }  } )

   dbUseArea(.T.,, cDir + 'na')
   select na
   if File( cDir + 'AUTORES.DBF' )
      FErase( cDir + 'autores.cdx' )
      dbAppendFrom( cDir + 'autores' )
      dbCommitAll()
      close all
      FErase( cDir + 'autores.dbf' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'autores.dbf' )

   /* autores en articulos
   oSay:SetText( 'Fichero de Autores' )
   dbCreate( cDir + 'na', { { "AANOMBRE", "C",  50,   0 },;
      { "AAUNICO", "C",  15,   0 },;
      { "AAORDEN", "C",  02,   0 },;
      { "AATITULO", "C", 150,   0 },;
      { "AAMATERIA", "C",  40,   0 } } )

   dbUseArea(.T.,, cDir + 'na')
   select na
   if File( cDir + 'ARTAUTOR.DBF' )
      FErase( cDir + 'artautor.cdx' )
      dbAppendFrom( cDir + 'artautor' )
      dbCommitAll()
      close all
      FErase( cDir + 'artautor.dbf' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'artautor.dbf' )
 */
   // publicaciones
   oSay:SetText( 'Fichero de Publicaciones' )
   dbCreate( cDir + 'na', { { "PUNOMBRE", "C",  50,   0 },;
      { "PUMATERIA", "C",  40,   0 },;
      { "PUIDIOMA", "C",  15,   0 },;
      { "PUPERIODI", "C",  15,   0 },;
      { "PUPRECIO", "N",   8,   2 },;
      { "PUEDITOR", "C",  50,   0 },;
      { "PUDIRECC", "C",  50,   0 },;
      { "PULOCALI", "C",  50,   0 },;
      { "PUPAIS", "C",  50,   0 },;
      { "PUTELEFONO", "C",  30,   0 },;
      { "PUFAX", "C",  30,   0 },;
      { "PUEMAIL", "C",  50,   0 },;
      { "PUURL", "C",  50,   0 },;
      { "PUNOTAS", "C", 255,   0 },;
      { "PUSUSCRIP", "L",   1,   0 },;
      { "PUPRESUS", "N",   6,   0 },;
      { "PUEJEMPL", "N",   6,   0 },;
      { "PUFCHPAGO", "D",   8,   0 },;
      { "PUFCHCAD", "D",   8,   0 }  } )

   dbUseArea(.T.,, cDir + 'na' )
   select na
   if File( cDir + 'PUBLICA.DBF' )
      FErase( cDir + 'publica.cdx' )
      dbAppendFrom( cDir + 'publica' )
      dbCommitAll()
      close all
      FErase( cDir + 'publica.dbf' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'publica.dbf' )

   //materias
   oSay:SetText( 'Fichero de Materias' )
   dbCreate( cDir + 'na', { { "MAMATERIA", "C",  40,   0 },;
      { "MAPCLAVE", "C",  45,   0 },;
      { "MAEJEMPL", "N",   5,   0 }  } )
   close all
   dbUseArea(.T.,, cDir + 'na')
   select na
   if File( cDir + 'MATERIAS.DBF' )
      FErase( cdir + 'materias.cdx' )
      dbAppendFrom( cDir + 'materias' )
      dbCommitAll()
      close all
      FErase( cDir + 'materias.dbf' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'materias.dbf' )
   close all

   // idiomas
   oSay:SetText( i18n( "Fichero de Idiomas" ) )
   dbCreate( cDir + "na", { { "IDIDIOMA", "C", 15, 0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "IDIOMAS.DBF" )
      FErase( cDir + "idiomas.cdx" )
      dbAppendFrom( cDir + "idiomas" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "idiomas.dbf" )
   endif
   dbCloseAll()
   FRename( cDir + "na.dbf", cDir + "idiomas.dbf" )

   // periodicidad
   oSay:SetText( i18n( "Fichero de periodicidad" ) )
   dbCreate( cDir + "na", { { "PEPERIODI", "C", 15, 0 } } )
   dbCloseAll()
   dbUseArea(.T.,, cDir+"na")
   select na
   if File( cDir + "PERIODI.DBF" )
      FErase( cdir + "periodi.cdx" )
      dbAppendFrom ( cdir + "periodi" )
      dbCommitAll()
      dbCloseAll()
      FErase( cdir + "periodi.dbf" )
   endif
   dbCloseAll()
   FRename( cDir + "na.dbf", cDir + "periodi.dbf" )

   /* claves en articulos
   oSay:SetText( 'Fichero de Claves' )
   dbCreate( cDir + 'na', { { "ACCLAVE", "C",  40,   0 },;
      { "ACTITULO", "C", 150,   0 },;
      { "ACORDEN", "C",   2,   0 },;
      { "ACUNICO", "C",  15,   0 } } )

   dbUseArea(.T.,, cDir + 'na')
   select na
   if File( cDir + 'ARTCLAVE.DBF' )
      FErase( cDir + 'artclave.cdx' )
      dbAppendFrom( cDir + 'artclave' )
      dbCommitAll()
      close all
      FErase( cdir + 'artclave.dbf' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'artclave.dbf' )
 */

   //Ubicaciones
   oSay:SetText( 'Fichero de Ubicaciones' )
   dbCreate( cDir + 'na', { { "UBUBICACI", "C",  60,   0 },;
      { "UBEJEMPL", "N",   5,   0 }  } )
   close all
   dbUseArea(.T.,, cDir + 'na')
   select na
   if File( cDir + 'UBICACI.DBF' )
      FErase( cDir + 'ubicaci.cdx' )
      dbAppendFrom( cDir + 'ubicaci' )
      dbCommitAll()
      close all
      FErase( cDir + 'ubicaci.dbf' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'ubicaci.dbf' )
   close all

   //tipo doc
   oSay:SetText( 'Fichero de tipo de documento' )
   dbCreate( cDir + 'na', { { "TDTIPODOC", "C",  30,   0 },;
      { "TDEJEMPL", "N",   5,   0 }  } )
   close all
   dbUseArea(.T.,, cDir + 'na')
   select na
   if File( cDir + 'TIPODOC.DBF' )
      FErase( cDir + 'tipodoc.cdx' )
      dbAppendFrom( cDir + 'tipodoc' )
      dbCommitAll()
      close all
      FErase( cDir + 'tipodoc.dbf' )
   endif
   close all
   FRename( cDir + 'na.dbf', cDir + 'tipodoc.dbf' )
   close all

   //etiquetas clave para el tagever
   oSay:SetText( 'Fichero de etiquetas' )
   dbCreate( cDir + 'et', { { "ettag", "C",  40,   0 },;
      { "etejempl", "N",   5,   0 }  } )
   close all
   dbUseArea(.T.,, cDir + 'et')
   select et
   if File( cDir + 'ETIQUETAS.DBF' )
      FErase( cDir + 'etiquetas.cdx' )
      dbAppendFrom( cDir + 'etiquetas' )
      dbCommitAll()
      close all
      FErase( cDir + 'etiquetas.dbf' )
   endif
   close all
   FRename( cDir + 'et.dbf',cDir + 'etiquetas.dbf' )
   close all

   oDlgT:End()

   CursorArrow()

return nil

/*_____________________________________________________________________________*/

function Ut_AztIndexar( lMsg )

   local oDlgProgress, oSay01, oSay02, oBmp, oProgress
   local nVar   := 0

   if oApp():oDlg != nil
      if oApp():nEdit > 0
         return nil
      else
         oApp():oDlg:End()
         SysRefresh()
      endif
   endif

   DEFINE DIALOG oDlgProgress RESOURCE 'UT_INDEXAR_' + oApp():cLanguage OF oApp():oWndMain
   oDlgProgress:SetFont(oApp():oFont)

   REDEFINE BITMAP oBmp ID 111 OF oDlgProgress RESOURCE 'BB_INDEX' TRANSPARENT
   REDEFINE say oSay01 prompt "Generando índices de la aplicación" ID 99  OF oDlgProgress
   REDEFINE say oSay02 prompt Space( 30 ) ID 10  OF oDlgProgress
   oProgress := TProgress():Redefine( 101, oDlgProgress )

   oDlgProgress:bStart := {|| SysRefresh(), Ut_AztCrearCdx( oSay02, oProgress ), oDlgProgress:End() }

   ACTIVATE DIALOG oDlgProgress ;
      on init DlgCenter( oDlgProgress, oApp():oWndMain )

   MsgInfo( i18n( "La regeneración de índices se realizó correctamente." ) )

return nil

/*_____________________________________________________________________________*/

function Ut_AztCrearCDX( oSay, oMeter, lMsg )

   local nPaso  := 1
   local nMeter := 0
   local cDir   := oApp():cAztPath
   local cTipo
   local nAztTags := Val( GetPvProfString( "Config", "nAztTags","0", oApp():cIniFile ) )
   local cMaMateria
   local aTags, aAutores, i
   field MaMateria, MaPClave, IdIdioma, PePeriodi
   field UbUbicaci, UbEjempl, TdTipoDoc
   field ArPath, ArTipo, ArTitulo, ArCodigo, ArMateria, ArAutor, ArPublicac, ArTipoDoc, ArUbicaci, ArLocaliz, ArSelect, ArUnico
   field AuNombre, AuMateria, AuPais, AaUnico, AaOrden, AaNombre, PuNombre, PuIdioma, PuMateria, PuFchCad, EtTag

   CursorWait()

   // Depuración de campos MEMO
   //oSay:SetText("Depuración de documentos")
   //USE ( cDir + 'ARTICULO' ) NEW
   //COPY TO __temp__
   //DbCloseAll()
   //FERASE( 'ARTICULO.DBF' )
   //FERASE( 'ARTICULO.FPT' )
   //FRENAME( '__temp__.dbf', 'ARTICULO.DBF' )
   //FRENAME( '__temp__.fpt', 'ARTICULO.FPT' )

   // materias
   dbCloseAll()
   if File( cDir + 'MATERIAS.CDX' )
      FErase( cDir + 'materias.cdx' )
   endif

   Db_AztOpenNoIndex( 'Materias', )
   oSay:SetText( i18n( "Fichero de Materias" ) )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   pack
   index on Upper( MaMateria ) + Upper( MaPClave ) tag ma01 ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( MaMateria ) tag ma02 ;
      FOR ( ( ! Deleted() ) .AND. RTrim( MaPClave ) == "" ) Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )

   // idiomas
   dbCloseAll()
   if File( cDir + 'IDIOMAS.CDX' )
      FErase( cDir + 'idiomas.cdx' )
   endif
   Db_AztOpenNoIndex( 'Idiomas', )
   oSay:SetText( i18n( "Idiomas" ) )
   oMeter:setRange( 0, LastRec() / nPaso / nPaso )
   pack
   UtResetMeter( oMeter, @nMeter )
   index on Upper( IdIdioma ) tag idioma for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   dbCloseAll()

   // periodicidad
   dbCloseAll()
   if File( cDir + 'PERIODI.CDX' )
      FErase( cDir + 'periodi.cdx' )
   endif
   Db_AztOpenNoIndex( 'PERIODI', )
   oSay:SetText( i18n( "Periodicidad" ) )
   oMeter:setRange( 0, LastRec() / nPaso / nPaso )
   pack
   UtResetMeter( oMeter, @nMeter )
   index on Upper( PePeriodi ) tag periodi for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   dbCloseAll()

   /* claves en documentos
   dbCloseAll()
   if File( cDir + 'ARTCLAVE.CDX' )
      FErase( cDir + 'artclave.cdx' )
   endif
   Db_AztOpenNoIndex( 'ArtClave', )
   oSay:SetText( i18n( "Palabras clave en documentos" ) )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   sysrefresh()
   index on AcUnico + AcOrden tag Acunico   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( AcClave ) + AcTitulo tag acClave ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )*/

   // ----> ubicaciones
   dbCloseAll()
   if File( cDir + 'UBICACI.CDX' )
      FErase( cDir + 'ubicaci.cdx' )
   endif
   Db_AztOpenNoIndex( 'UBICACI', )
   oSay:SetText( i18n ( "Ubicaciones" ) )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   index on Upper( UbUbicaci )  tag UbUbicaci  ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on UbEjempl  tag UbEjempl  ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )

   // ----> tipo de documento
   dbCloseAll()
   if File( cDir + 'TIPODOC.CDX' )
      FErase( cDir + 'tipodoc.cdx' )
   endif
   Db_AztOpenNoIndex( 'TIPODOC', )
   oSay:SetText( "Tipos de documento" )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   index on Upper( TdTipoDoc )  tag TdTipoDoc     ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )

   // ----> articulos
   if File( cDir + 'ARTICULO.CDX' )
      FErase( cDir + 'articulo.cdx' )
   endif
   Db_AztOpenNoIndex( 'Articulo', )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   oSay:SetText( "Fichero de documentos" )
   do while ! Eof()
      cTipo := Lower( Right( RTrim(arpath ),4 ) )
      do case
      case cTipo == ''
         replace ArTipo with 0
      case cTipo == '.doc'
         replace ArTipo with 2
      case cTipo == '.htm' .OR. cTipo == 'html' .OR. cTipo == '.mht'
         replace ArTipo with 3
      case cTipo == '.lwp'
         replace ArTipo with 4
      case cTipo == '.mdb'
         replace ArTipo with 5
      case cTipo == '.pdf'
         replace ArTipo with 6
      case cTipo == '.ppt'
         replace ArTipo with 7
      case cTipo == '.txt'
         replace ArTipo with 8
      case cTipo == '.xls'
         replace ArTipo with 9
      case cTipo == '.sxw'
         replace ArTipo with 10
      case cTipo == '.sxc'
         replace ArTipo with 11
      otherwise
         replace ArTipo with 1
      endcase
      dbSkip()
      oMeter:SetPos( nMeter++ )
      SysRefresh()
   enddo
   UtResetMeter( oMeter, @nMeter )

   index on Upper( ArTitulo )                  tag titulo     ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArCodigo )                  tag codigo     ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArMateria ) + Upper( ArTitulo ) tag materia ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArAutor ) + Upper( ArTitulo )   tag autor      ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArPublicac ) + Upper( ArTitulo ) tag publica   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArTipoDoc ) + Upper( ArTitulo ) tag tipodoc ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArUbicaci ) + Upper( ArTitulo ) tag ubicaci ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArLocaliz )                 tag localizador   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( ArTitulo )  tag selecc for ArSelect == 'x' .AND. ! Deleted() ;
      Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on ArUnico                          tag unico   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   // ----> autores
   close all
   if File( cDir + 'AUTORES.CDX' )
      FErase( cDir + 'autores.cdx' )
   endif
   Db_AztOpenNoIndex( 'AUTORES', )
   oSay:SetText( "Fichero de autores" )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   index on Upper( AuNombre )  tag auautor     ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( AuMateria ) tag aumateria   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( AuPais )  tag aupais     ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )

   /* ----> autores en documentos
   dbCloseAll()
   if File( cDir + 'ARTAUTOR.CDX' )
      FErase( cDir + 'artautor.cdx' )
   endif
   Db_AztOpenNoIndex( 'ArtAutor', )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   index on AaUnico + AaOrden  tag raunico  ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( AaNombre )  tag ranombre ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
 */

   // ----> publicaciones
   dbCloseAll()
   if File( cDir + 'PUBLICA.CDX' )
      FErase( cDir + 'publica.cdx' )
   endif
   Db_AztOpenNoIndex( 'PUBLICA', )
   oSay:SetText( "Fichero de publicaciones" )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   index on Upper( PuNombre )   tag punombre   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( PuMateria )  tag pumateria  ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on Upper( PuIdioma )   tag puidioma   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )
   index on DToS( PuFchCad )    tag pufchcad   ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )

   // ----> palabras clave
   dbCloseAll()
   if File( cDir + 'etiquetas.cdx' )
      FErase( cDir + 'etiquetas.cdx' )
   endif
   Db_AztOpenNoIndex( 'etiquetas', )
   oSay:SetText( "Fichero de palabras clave" )
   oMeter:SetRange( 0, LastRec() / nPaso / nPaso )
   index on Upper( EtTag )   tag ettag    ;
      for ! Deleted() Eval ( oMeter:SetPos( nMeter++ ), Sysrefresh() ) EVERY nPaso
   UtResetMeter( oMeter, @nMeter )

   dbCloseAll()

   oSay:SetText( "Comprobando integridad" )
   // reviso el fichero de materias para eliminar duplicados y añado las etiquetas, pero sólo lo hago 1 vez
   if nAztTags == 0 .and. File(oApp():cAztPath+'artautor.dbf')
      oSay:SetText( "Comprobando materias" )
      Db_AztOpen( "ETIQUETAS", "ET" )
      Db_AztOpen( "MATERIAS", "MA" )
      select MA
      MA->( dbGoTop() )
      do while ! MA->( Eof() )
         if ! ET->( dbSeek( MA->MaPClave ) )
            ET->( dbAppend() )
            replace ET->EtTag with MA->MaPClave
         endif
         MA->( dbSkip() )
      enddo
      MA->( dbGoTop() )
      cMaMateria := MA->MaMateria
      MA->( dbSkip() )
      do while ! MA->( Eof() )
         if Upper(cMaMateria) == Upper(MA->MaMateria)
            MA->( dbDelete() )
         else
            cMaMateria := MA->MaMateria
         endif
         MA->( dbSkip() )
      enddo
      dbCloseAll()
      oSay:SetText( "Comprobando etiquetas" )
      Db_AztOpen( "ARTCLAVE", "AC" )
      Db_AztOpen( "ARTICULO", "AR" )
      select AR
      AR->( ordSetFocus(1) )
      select AC
      AC->(dbGoTop())
      do while ! AC->(Eof())
         AR->(dbGoTop())
         if AR->(dbSeek(Upper(AC->AcTitulo)))
            replace AR->ArTags with RTrim(AR->ArTags)+RTrim(AC->AcClave)+";"
         endif
         AC->( dbSkip() )
      enddo
      dbCloseAll()
      oSay:SetText( "Comprobando autores" )
      Db_AztOpen( "ARTAUTOR", "AA" )
      Db_AztOpen( "ARTICULO", "AR" )
      select AR
      AR->( ordSetFocus(1) )
      replace all AR->ArAutores with RTrim(AR->ArAutor)+";" for ! Empty(AR->ArAutor)
      select AA
      AA->(dbGoTop())
      do while ! AA->(Eof())
         AR->(dbGoTop())
         if AR->(dbSeek(Upper(AA->AaTitulo)))
            if At(RTrim(AA->AaNombre), AR->ArAutores) == 0
               replace AR->ArAutores with RTrim(AR->ArAutores)+RTrim(AA->AaNombre)+";"
            endif
         endif
         AA->( dbSkip() )
      enddo
      dbCloseAll()
      WritePProString( "Config", "nAztTags", "1", oApp():cIniFile )
      // borro los ficheros que ya no voy a usar
      FErase( oApp():cAztPath + 'artautor.dbf' )
      FErase( oApp():cAztPath + 'artautor.cdx' )
      FErase( oApp():cAztPath + 'artclave.dbf' )
      FErase( oApp():cAztPath + 'artclave.cdx' )
      FErase( oApp():cAztPath + 'palclave.dbf' )
      FErase( oApp():cAztPath + 'palclave.cdx' )
      FErase( oApp():cAztPath + 'xartaut.dbf' )
      FErase( oApp():cAztPath + 'xartaut.cdx' )
      FErase( oApp():cAztPath + 'xartcla.dbf' )
      FErase( oApp():cAztPath + 'xartcla.cdx' )
   endif

   Db_AztOpenAll()
   select ZMA
   replace ZMA->MaEjempl with 0 while ! ZMA->( Eof() )
   ZMA->( dbSetOrder( 1 ) )
   ZMA->( dbGoTop() )
   select ZPU
   replace ZPU->PuEjempl with 0 while ! ZPU->( Eof() )
   ZPU->( dbSetOrder( 1 ) )
   ZPU->( dbGoTop() )
   select ZAU
   replace ZAU->AuEjempl with 0 while ! ZAU->( Eof() )
   ZAU->( dbSetOrder( 1 ) )
   ZAU->( dbGoTop() )
   select ZUB
   replace ZUB->UbEjempl with 0 while ! ZUB->( Eof() )
   ZUB->( dbSetOrder( 1 ) )
   ZUB->( dbGoTop() )
   select ZTD
   replace ZTD->TdEjempl with 0 while ! ZTD->( Eof() )
   ZTD->( dbSetOrder( 1 ) )
   ZTD->( dbGoTop() )
   select ZET
   replace ZET->EtEjempl with 0 while ! ZET->( Eof() )
   ZET->( dbSetOrder( 1 ) )
   ZET->( dbGoTop() )

   oMeter:SetRange( 0, ZAR->( LastRec() / nPaso ) )
   ZAR->( dbSetOrder( 1 ) )
   ZAR->( dbGoTop() )
   do while ! ZAR->( Eof() )
      if ! Empty( ZAR->ArMateria )
         select ZMA
         if ZMA->( dbSeek( Upper(ZAR->ArMateria ) ) )
            replace ZMA->MaEjempl with ZMA->MaEjempl + 1
         else
            ZMA->( dbAppend() )
            replace ZMA->MaMateria with ZAR->ArMateria
            replace ZMA->MaEjempl  with 1
         endif
      endif
      if ! Empty( ZAR->ArPublicac )
         select ZPU
         if ZPU->( dbSeek( Upper(ZAR->ArPublicac ) ) )
            replace ZPU->PuEjempl with ZPU->PuEjempl + 1
         else
            ZPU->( dbAppend() )
            replace ZPU->PuNombre with ZAR->ArPublicac
            replace ZPU->PuEjempl  with 1
         endif
      endif
      if ! Empty( ZAR->ArUbicaci )
         select ZUB
         if ZUB->( dbSeek( Upper(ZAR->ArUbicaci ) ) )
            replace ZUB->UbEjempl with ZUB->UbEjempl + 1
         else
            ZUB->( dbAppend() )
            replace ZUB->UbUbicaci with ZAR->ArUbicaci
            replace ZUB->UbEjempl  with 1
         endif
      endif
      if ! Empty( ZAR->ArTipoDoc )
         select ZTD
         if ZTD->( dbSeek( Upper(ZAR->ArTipoDoc ) ) )
            replace ZTD->TdEjempl with ZTD->TdEjempl + 1
         else
            ZTD->( dbAppend() )
            replace ZTD->TdTipoDoc with ZAR->ArTipoDoc
            replace ZTD->TdEjempl  with 1
         endif
      endif
      aTags := iif(At(';',ZAR->ArTags)!=0, hb_ATokens( ZAR->ArTags, ";"), {})
      if Len(aTags) > 1
         ASize( aTags, Len(aTags)-1)
         for i:=1 to Len(aTags)
            if ZET->( dbSeek( Upper(aTags[i] ) ) )
               replace ZET->EtEjempl with ZET->EtEjempl + 1
            else
               ZET->( dbAppend() )
               replace ZET->EtTag with aTags[i]
               replace ZET->EtEjempl  with 1
            endif
         next
      endif
      aAutores := iif(At(';',ZAR->ArAutores)!=0, hb_ATokens( ZAR->ArAutores, ";"), {})
      if Len(aAutores) > 1
         ASize( aAutores, Len(aAutores)-1)
         for i:=1 to Len(aAutores)
            if ZAU->( dbSeek( Upper(aAutores[i] ) ) )
               replace ZAU->AuEjempl with ZAU->AuEjempl + 1
            else
               ZAU->( dbAppend() )
               replace ZAU->AuNombre with aAutores[i]
               replace ZAU->AuEjempl  with 1
            endif
         next
      endif
      select ZAR
      ZAR->( dbSkip() )
      oMeter:SetPos( nMeter++ )
   enddo

   Sysrefresh()
   dbCloseAll()

   CursorArrow()

return nil

/*_____________________________________________________________________________*/

function UtResetMeter( oMeter, nMeter )

   nMeter := 0
   oMeter:SetPos( nMeter )
   sysrefresh()

return nil

function dbAppendFrom(file)

   append from &file

return nil
