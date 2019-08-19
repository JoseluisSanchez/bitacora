#FWH Borland make, (c) FiveTech Software 2005-2011

HBDIR=c:\fivetech\hb1206
BCDIR=c:\bcc582
FWDIR=c:\fivetech\fwh1204

#change these paths as needed
.path.OBJ = .\obj
.path.PRG = .\prg
.path.CH  = $(FWDIR)\include;$(HBDIR)\include
.path.C   = .\
.path.rc  = .\res

#important: Use Uppercase for filenames extensions!

PRG =           	\
   MAIN.PRG          \
   LIBROS.PRG        \
   DISCOS.PRG        \
   CANCIONES.PRG     \
   VIDEOS.PRG        \
   SOFTWARE.PRG      \
   INTERNET.PRG      \
   MATERIAS.PRG      \
   UBICACIONES.PRG   \
   AUTORES.PRG       \
   EDITORES.PRG      \
   COLECCIONES.PRG   \
   CATEGORIAS.PRG    \
   IDIOMAS.PRG       \
	SOPORTES.PRG      \
   NOTAS.PRG         \
   AGENDA.PRG        \
   COMPRAS.PRG       \
	ZARTICULO.PRG 		\
	ZAUTOR.PRG			\
	ZMATERIA.PRG		\
	ZETIQUETAS.PRG		\
	ZPERIODI.PRG		\
	ZPUBLICA.PRG		\
	ZTIPODOC.PRG		\
	ZUBICACI.PRG		\
   TIPS.PRG          \
   UTILIDADES.PRG    \
   UT_COMMON.PRG     \
   UT_INDEX.PRG      \
   UT_BRW.PRG        \
   UT_DBF.PRG        \
   UT_MSG.PRG        \
   UT_CALEND.PRG     \
   UT_XML.PRG        \
   ZIPBACKUP.PRG     \
   TFSDI.PRG         \
   MSGBAR.PRG        \
   TMSGITEM.PRG      \
   TABS.PRG          \
   REPORT.PRG        \
   RPREVIEW.PRG      \
   SAYREF.PRG        \
   TZOOMIMAGE.PRG    \
   IMAGE.PRG         \
   TAGET.PRG         \
	TAGEVER2.PRG		\
   IMAGE2PDF.PRG     \
   TINFORME.PRG		\
	VITEM.PRG			\
	C5CALEND.PRG

OBJ = $(PRG:.PRG=.OBJ)
OBJS = $(OBJ:.\=.\obj)
PROJECT    : BITACORA.EXE

BITACORA.EXE : $(PRG:.PRG=.OBJ) $(C:.C=.OBJ) BITACORA.RES

  $(BCDIR)\bin\ilink32 -Gn -aa -Tpe -s @btc1204.bc

.PRG.OBJ:
  $(HBDIR)\bin\harbour $< /N /W1 /ES2 /Oobj\ /I$(FWDIR)\include;$(HBDIR)\include;.\ch /d__REGISTRADA__
  $(BCDIR)\bin\bcc32 -c -tWM -I$(HBDIR)\include -oobj\$& obj\$&.c

.C.OBJ:
  echo -c -tWM -D__HARBOUR__ > tmp
  echo -I$(HBDIR)\include;$(FWDIR)\include >> tmp
  $(BCDIR)\bin\bcc32 -oobj\$& @tmp $&.c
  del tmp

# COLOSSUS.RES : COLOSSUS.RC
#    $(BCDIR)\bin\brc32.exe -r -I$(BCDIR)\include colossus.rc
