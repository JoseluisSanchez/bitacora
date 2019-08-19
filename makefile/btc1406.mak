#FWH Borland make, (c) FiveTech Software 2005-2011

HBDIR=c:\fivetech\hb32
BCDIR=c:\bcc582
FWDIR=c:\fivetech\fwh1406

#change these paths as needed
.path.OBJ = .\obj
.path.PRG = .\prg
.path.CH  = $(FWDIR)\include;$(HBDIR)\include
.path.C   = .\
.path.rc  = .\res

#important: Use Uppercase for filenames extensions!

PRG =           	 \
   MAIN.PRG          \
   PAGENDA.PRG       \
   PAUTORES.PRG      \
   PCANCIONES.PRG    \
   PCATEGORIAS.PRG   \
   PCOLECCIONES.PRG  \
   PCOMPRAS.PRG      \
   PDISCOS.PRG       \
   PEDITORES.PRG     \
   PIDIOMAS.PRG      \
   PINTERNET.PRG     \
   PLIBROS.PRG       \
   PMATERIAS.PRG     \
   PNOTAS.PRG        \
   PSOFTWARE.PRG     \
   PSOPORTES.PRG     \
   PUBICACIONES.PRG  \
   PVIDEOS.PRG       \
   ZARTICULO.PRG 	 \
   ZAUTOR.PRG		 \
   ZETIQUETAS.PRG	 \
   ZMATERIA.PRG		 \
   ZPERIODI.PRG		 \
   ZPUBLICA.PRG		 \
   ZTIPODOC.PRG		 \
   ZUBICACI.PRG		 \
   C5BMP.PRG	  	 \
   C5IMGLIS.PRG   	 \
   C5TIP.PRG 	  	 \
   C5VITEM.PRG	  	 \
   C5VMENU.PRG	  	 \
   REPORT1406.PRG    \
   RPREVIEW1406.PRG  \
   TSAYREF.PRG       \
   TABS.PRG          \
   TAGET.PRG         \
   TAGEVER2.PRG		 \
	TAUTOGET.PRG		 \
   TFSDI.PRG         \
   TINFORME.PRG		 \
   TZOOMIMAGE.PRG    \
   UT_BRW.PRG        \
   UT_CALEND.PRG     \
   UT_COMMON.PRG     \
   UT_DBF.PRG        \
   UT_INDEX.PRG      \
   UT_MSG.PRG        \
   UT_TIPS.PRG       \
   UT_UTILIDADES.PRG \
   UT_XML.PRG        \
   ZIPBACKUP.PRG     


OBJ = $(PRG:.PRG=.OBJ)
OBJS = $(OBJ:.\=.\obj)
PROJECT    : BITACORA.EXE

BITACORA.EXE : $(PRG:.PRG=.OBJ) $(C:.C=.OBJ) BITACORA.RES

  $(BCDIR)\bin\ilink32 -Gn -aa -Tpe -s @btc1406.bc

.PRG.OBJ:
  $(HBDIR)\bin\harbour $< /N /W1 /ES2 /Oobj\ /I$(FWDIR)\include;$(HBDIR)\include;.\ch /d__REGISTRADA__
  $(BCDIR)\bin\bcc32 -c -tWM -I$(HBDIR)\include -oobj\$& obj\$&.c

.C.OBJ:
  echo -c -tWM -D__HARBOUR__ > tmp
  echo -I$(HBDIR)\include;$(FWDIR)\include >> tmp
  $(BCDIR)\bin\bcc32 -oobj\$& @tmp $&.c
  del tmp
