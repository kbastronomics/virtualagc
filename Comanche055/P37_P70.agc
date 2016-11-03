### FILE="Main.annotation"
## Copyright:	Public domain.
## Filename:	P37_P70.agc
## Purpose:	Part of the source code for Colossus 2A, AKA Comanche 055.
##		It is part of the source code for the Command Module's (CM)
##		Apollo Guidance Computer (AGC), for Apollo 11.
## Assembler:	yaYUL
## Contact:	Jim Lawton <jim.lawton@gmail.com>.
## Website:	www.ibiblio.org/apollo.
## Pages:	890-933
## Mod history:	2009-05-11 JVL	Adapted from the Colossus249/ file
##				of the same name, using Comanche055 page
##				images.
##		2009-05-20 RSB	Added missing label V2T179.  Fixed POODOO -> P00DOO.
##		2009-05-23 RSB	In RTD18, corrected a STOVL DELVLVC to 
##				STODL DELVLVC and a STODL 02D to STORE 02D.
##		2010-08-28 JL	Added missing comment characters.
##
## This source code has been transcribed or otherwise adapted from digitized
## images of a hardcopy from the MIT Museum.  The digitization was performed
## by Paul Fjeld, and arranged for by Deborah Douglas of the Museum.  Many
## thanks to both.  The images (with suitable reduction in storage size and
## consequent reduction in image quality as well) are available online at
## www.ibiblio.org/apollo.  If for some reason you find that the images are
## illegible, contact me at info@sandroid.org about getting access to the
## (much) higher-quality images which Paul actually created.
##
## Notations on the hardcopy document read, in part:
##
##    Assemble revision 055 of AGC program Comanche by NASA
##    2021113-051.  10:28 APR. 1, 1969 
##
##    This AGC program shall also be referred to as
##            Colossus 2A

## Page 890
		BANK	31
		SETLOC	RTE1
		BANK
		
		EBANK=	RTEDVD
		COUNT	31/P37
		
# PROGRAM DESCRIPTION:  P37, RETURN TO EARTH
#
# DESCRIPTION
#	A RETURN TO EARTH TRAJECTORY IS COMPUTED PROVIDED THE CSM IS OUTSIDE THE LUNAR SPHERE OF INFLUENCE AT THE
#	TIME OF IGNITION.  INITIALLY A CONIC TRAJECTORY IS DETERMINED AND RESULTING IGNITION AND REENTRY PARAMETERS ARE
# 	DISPLAYED TO THE ASTRONAUT.  THEN IF THE ASTRONAUT SO DESIRES, A PRECISION TRAJECTORY IS DETERMINED WTIH THE
# 	RESULTING IGNITION AND REENTRY PARAMETERS DISPLAYED.  UPON FINAL ACCEPTANCE BY THE ASTRONAUT, THE PROGRAM
# 	COMPUTES AND STORES THE TARGET PARAMETERS FOR RETURN TO EARTH FOR USE BY SPS PROGRAM (P40) OR RCS PROGRAM (P41).
#
# CALLING SEQUENCE
#	L	TC	P37
#
# SUBROUTINES CALLED
#	PREC100
#		V2T100
#		RTENCK2
#		RTENCK3
#		TIMERAD
#		PARAM
#	V2T100
#		GAMDV10
#		XT1LIM
#		DVCALC
#	RTENCK1
#		INTSTALL
#		INTEGRVS
#	RTEVN
#		RETDISP
#		TMRAD100
#		AUGEKUGL
#		LAT-LONG
#	TMRAD100
#		TIMERAD
#	INVC100
#		CSMPREC
#	GETERAD
#	TIMETHET
#	P370ALRM
#	VN1645
#	POLY
#
# ERASABLE INITIALIZATION REQUIRED
#	CSM STATE VECTOR
## Page 891
#	NJETSFLG	NUMBER OF JETS IF THE RCS PROPULSION SYSTEM SELECTED	STATE FLAG	0=4 JETS  1=2 JETS
#
# ASTRONAUT INPUT
#	SPRTETIG	TIME OF IGNITION (OVERLAYS TIG)				DP	B28	CS
#	VPRED		DESIRED CHANGE IN VELOCITY AT TIG(PROGRM COMPUTED IF 0)	DP	B7	METERS/CS
#	GAMMAEI		DESIRED FLIGHT PATH ANGLE AT REENTRY (COMPUTED IF 0)	DP	B0	REVS + ABOVE HORIZ.
#	OPTION2		PROPULSION SYSTEM OPTION				SP	B14	1=SPS, 2=RCS
#
# OUTPUT
#    CONIC OR PRECISION TRAJECTORY DISPLAY
#	VPRED	 	VELOCITY MAGNITUDE AT 400,000 FT. ENTRY ALTITUDE	DP	B7	METERS/CS
#	T3TOT4		TRANSIT TIME TO 400,000 FT. ENTRY ALTITUDE		DP	B28	CS
#	GAMMAEI		FLIGHT PATH ANGLE AT 400,00 FT. ENTRY ALTITUDE		DP	B0	REVS + ABOVE HORIZON
#	DELVLVC		INITIAL VELOCITY CHANGE VECTOR IN LOCAL VERTICAL COORD.	VECTOR	B7	METERS/CS
#	LAT(SPL)	LATITUDE OF THE LANDING SITE				DP	B0	REVS
#	LNG(SPL)	LONGITUDE OF THE LANDING SITE				DP	B0	REVS
#    TARGETING COMPUTATION DISPLAY
#	TIG		RECOMPUTED TIG BASED ON THRUST OPTION			DP	B28	CS
#	TTOGO		TIME FROM TIG						DP	B28	CS
#	+MGA		POSITIVE MIDDLE GIMBAL ANGLE				DP	B0	REVS -.02 IF REFSMFLG=0
#    THRUST PROGRAM COMMUNICATION
#	XDELVFLG	EXTERNAL DELTA V FLAG					STATE	FLAG	SET 0 FOR LAMBERT AIMPT
#	NORMSW		LAMBERT AIMPT ROTATION SWITCH				STATE	FLAG	SET 0 FOR NO ROTATION
#	ECSTEER		CROSS PRODUCT STEERING CONSTANT				SP	B2	SET 1
#	RTARG		CONICALLY INTEGRATED REENTRY POSITION VECTOR		VECTOR	B29	METERS
#	TPASS4		REENTRY TIME						DP	B28	CS

P37		TC	PHASCHNG	# P37 IS NOT RESTARTABLE
		OCT	4

		TC	INTPRET
		AXT,1	SXA,1
		OCT	04000
			ECSTEER
		DLOAD
			ZEROVECS
		STORE	VPRED
		STORE	GAMMAEI
		EXIT
		CAF	V6N33RTE	# INPUT TIG	STORED IN SPRTETIG
		TCR	P370GOF		#		OVERLAYED WITH TIG
		TCF	-2		# DISPLAY NEW DATA
		CAF	V6N60RTE	# INPUT REENTRY ANGLE IN GAMMAEI
		TCR	P37GFRB1	#	AND DESIRED DELTA V IN RETDVD
		TCF	-2		# DISPLAY NEW DATA
RTE299		TC	INTPRET
		SSP	DLOAD
			OVFIND
			0
			VPRED
## Page 892
		STODL	RTEDVD
			GAMMAEI
		STODL	RTEGAM2D
			1RTEB13
		STODL	CONICX1
			C4RTE
		STCALL	MAMAX1
			INVC100		# GET R(T1)/,V(T1)/,UR1/,UH/
		CLEAR	DLOAD
			SLOWFLG
			RTEDVD
		BPL	ABS
			RTE317
		STORE	RTEDVD
		DLOAD	DSU
			R(T1)
			K1RTE
		BMN	SET
			RTE317
			SLOWFLG
RTE317		DLOAD	EXIT
			R(T1)
		TC	POLY
		DEC	2
		2DEC	181000434. B-31
		2DEC	1.50785145 B-2
		2DEC*	-6.49993057 E-9 B27*
		2DEC*	9.76938926 E-18 B56*
		TC	INTPRET
		SL1
		STODL	MAMAX2		# C0+C1*R+C2*R**2+C3*R**3=MAMAX2 B30
			M9RTEB28
		STODL	NN1A
			K2RTE
RTE320		STODL	RCON		# RCON=K2
			RTEGAM2D
		BZE	BDSU
			RTE340		# GOTORTE340 IF REENTRY ANGLE NOT INPUT
			1RTEB2
		PUSH	COS		#					PL02D
		PDDL	SIN
		BDDV	STADR		#					PL00D
		STCALL	X(T2)		# X(T2)=COT(GAM2D)			B0
			RTE360
RTE340		DLOAD	DSU
			R(T1)
## Page 893
			K1RTE
		BMN	DLOAD
			RTE350
			K4RTE
		STCALL	X(T2)		# X(T2)=K4
			RTE360
RTE350		DLOAD
			K3RTE
		STORE	X(T2)		# X(T2)=K3
RTE360		CALL
			V2T100
		BZE	GOTO
			RTE367
			RTEALRM
RTE367		VLOAD
			R(T1)/
		STODL	RVEC
			RCON
		STOVL	RDESIRED
			V2(T1)/
		STCALL	VVEC
			TMRAD100
		DAD
			T1
		STODL	T2
			RTEGAM2D
		BZE	GOTO
			RTE369
			RTE372
RTE369		VLOAD	ABVAL
			V(T2)/
		EXIT
		TC	POLY
		DEC	2
		2DEC	0
		2DEC	-4.8760771 E-2 B4
		2DEC	4.5419476 E-4 B11
		2DEC	-1.4317675 E-6 B18
		
		TC	INTPRET
		DAD
			RTED1
		SL3	GOTO		# X(T2),=D1+D2V2+D3V2**2+D4V2**3
			RTE373
RTE372		DLOAD			# X(T2),=X(T2)
			X(T2)
RTE373		DSU	PUSH		# X(T2)ERR				B0 PL02D
## Page 894
			X(T2)
		VLOAD	UNIT
			R(T2)/		#					B58
		STCALL	ALPHAV
			GETERAD
		DAD
			E3RTE
		PUSH	DSU		# RCON,=(E1/1+E2BETA11)**.5)+E3 	B29 PL04D
			RCON
		ABS	DSU
			EPC2RTE
		BMN	GOTO
			RTE374
			RTE375
RTE374		DLOAD	ABS
			00D
		DSU	BMN
			EPC3RTE
			P37E
RTE375		DLOAD	DAD
			NN1A
			1RTEB28
		BMN	SLOAD
			RTE380
			OCT605
		GOTO
			RTEALRM		# TOO MANY ITERATIONS
RTE380		STORE	NN1A
		DSU	BZE
			M8RTEB28
			RTE385
		DLOAD	DSU
			00D
			DRCON
		NORM	PDDL		# X(T2)ERR-X(T2)ERR,=Z1			PL06D
			X1
			RPRE'
		DSU	DDV		# X(T2)PRI-X(T2)=Z2			PL04D
			X(T2)
		DMP	SL*		# DX(T2)=X(T2)ERR(Z2/Z1)
			00D
			0,1
		GOTO
			RTE390
RTE385		DLOAD			# DX(T2)=X(T2)ERR
			00D
RTE390		STODL	16D		# DX(T2)				PL02D
		STADR
		STODL	RCON		# RCON=RCON,
		BOV
## Page 895
			RTE360
		STODL	DRCON		# X(T2)ERR,=X(T2)ERR
			X(T2)
		STODL	RPRE'		# X(T2)PRI=X(T2)
			16D
		DAD
			X(T2)
		STCALL	X(T2)		# X(T2)=X(T2)+DX(T2)
			RTE360		# REITERATE
P37E		CALL			# DISPLAY CONIC SOLUTION
			RTEVN
RTE505		DLOAD	DMP
			PCON
			BETA1
		BDSU	BZE
			RCON
			RTE510
		BMN	DLOAD
			RTE510
			1RTEB2
		GOTO			# ENTRY NEAR APOGEE
			RTE515
RTE510		DLOAD	DCOMP		# ENTRY NEAR PERIGEE
			1RTEB2
RTE515		STCALL	PHI2
			PREC100		# PRECISION TRAJECTORY COMPUTATION
RTE625		BZE
			P37G
RTEALRM		CALL
			P370ALRM
		EXIT
		TCF	P37		# RECYCLE AFTER ALARM DISPLAY
		
# RETURN TO EARTH DISPLAY SUBROUTINE

RTEVN		STQ	CALL
			VNSTORE
			RTEDISP		# DISPLAY PREPARATION
		EXIT
		CAF	V6N61RTE	# LATITUDE,LONGITUDE,BLANK
		TCR	P370GOFR	#   IN LAT(SPL),LNG(SPL),-
		CAF	FOUR
		TCR	37BLANK +1
		TCF	+5
		TCF	P37		# RECYCLE
		CAF	V6N39RTE	# T21 HRS,MIN,SEC IN T3TOT4
		TCR	P370GOF
		TCF	P37		# RECYCLE
		CAF	V6N60RTE	# DISPLAY BLANK,V(T2),FPA2
		TCR	P37GFRB1	#   IN -,VPRED,GAMMAEI
## Page 896
		TCF	P37		# RECYCLE
		CAF	V6N81RTE	# DISPLAY DELTA V (LV) IN DELVLVC
		TCR	P370GOF
		TCF	P37		# RECYCLE
		TCR	INTPRET
		GOTO
			VNSTORE
			
# PRECISION DISPLAY, TARGETING COMPUTATION AND RTE END PROCESSING

P37G		CALL
			RTEVN
		EXIT
P37N		CAF	SEVEN
		TS	OPTION1
		CAF	ONE
		TS	OPTION2
		CAF	V4N06RTE	# DISPLAY RCS OR SPS OPTION  SPS ASSUMED
		TCR	P370GOF
		TCF	-2		# RECYCLE
		TC	INTPRET		# PROCEED
		SETPD	SLOAD
			00D
			OPTION2
		DSU	BZE
			1RTEB13
			P37Q
		SLOAD	NORM		# SPS
			EMDOT
			X1
		PDDL	GOTO
			VCSPS
			P37T
P37Q		DLOAD	BON		# RCS
			MDOTRCS
			NJETSFLG
			P37R
		SL1
P37R		SL1
		NORM	PDDL
			X1
			VCRCS
P37T		PDDL	DDV		# DV/VC			B7 -B5 = B2 	PL02D
			DV
		EXIT
		TC	POLY
		DEC	1
		2DEC	5.66240507 E-4 B-3
		2DEC	9.79487897 E-1 B-1
## Page 897
		2DEC	-.388281955 B1
		TC	INTPRET
		PUSH	SLOAD		# (1-E)**(-DV/VC)=A		B3 	PL04D
			WEIGHT/G
		DMP	DDV		# DTB=(M0/MDOT)A	B16+B3-B3=B16 	PL00D
		SL*	DMP
			0 -12D,1
			CSUBT
		BDSU
			T1
		STORE	TIG		# TIG=T1-CT*DTB			B28
		EXIT
		CAF	V6N33RTE	# DISPLAY BIASED TIG
		TCR	P370GOF
		TCF	-2
		CAF	ZERO
		TS	VHFCNT
		TS	TRKMKCNT
		TC	INTPRET
		CALL			# CONICALLY INTEGRATE FROM R1,V1 OVER T12
			RTENCK1
		VLOAD	UNIT		#					PL00D
			R(T2)/
		PDVL	VXSC		# UR2				B1 	PL06D
			UR1/
			MCOS7.5
		PDVL	VXSC		# -UR1(COS7.5)			B1 	PL12D
			UH/
			MSIN7.5
		VAD	DOT		# K/=-UR1(COS7.5)-UH(SIN7.5)	B2 	PL00D
		DAD	BMN
			MCOS22.5
			P37W
		VLOAD	DOT		# K/ . UR2 GR COS22.5
			UH/
			R(T2)/
		BMN	DLOAD
			P37U
			THETA165
		PUSH	GOTO
			P37V
P37U		DLOAD	PUSH
			THETA210
P37V		SIN
		STODL	SNTH
		COS	CLEAR
			RVSW
		STOVL	CSTH
			R(T1)/
## Page 898
		STOVL	RVEC
			V2(T1)/
		STCALL	VVEC
			TIMETHET
P37W		CLEAR	CLEAR
			XDELVFLG
			NORMSW
		SET	VLOAD
			FINALFLG
		STADR
		STODL	RTARG
			T
		DAD
			T1
		STOVL	TPASS4
			V2(T1)/
		VSU
			V(T1)/
		STCALL	DELVSIN
			VN1645
		GOTO
			P37W
			
# SUBROUTINE TO GO TO GOFLASHR AND BLANK R1

P37GFRB1	EXTEND
		QXCH	SPRTEX
		TCR	P370GOFR
37BLANK		CAF	ONE
		TCR	BLANKET
		TCF	ENDOFJOB
		TC	SPRTEX		# RECYCLE
		TCF	P37PROC		# PROCEED
		
# SUBROUTINE TO GO TO GOFLASHR

P370GOFR	EXTEND
		QXCH	RTENCKEX
		TCR	BANKCALL
		CADR	GOFLASHR
		TCF	GOTOP00H	# TERMINATE
		TCF	+3
		TCF	+4
		TC	RTENCKEX	# IMMEDIATE RETURN
		INDEX	RTENCKEX	# PROCEED
		TCF	0 +4
		INDEX	RTENCKEX	# RECYCLE
		TCF	0 +3
		
# SUBROUTINE TO GO TO GOFLASH

## Page 899
P370GOF		EXTEND
		QXCH	SPRTEX
		TCR	BANKCALL
		CADR	GOFLASH
		TCF	GOTOP00H
		TCF	+2
		TC	SPRTEX
P37PROC		INDEX	SPRTEX
		TCF	0 +1
V6N33RTE	VN	0633
V4N06RTE	VN	0406
V6N61RTE	VN	0661
V6N39RTE	VN	0639
V6N60RTE	VN	0660
V6N81RTE	VN	0681
		BANK	32
		SETLOC	RTE
		BANK
		COUNT	32/RTE
		
## Page 900
# ALARM DISPLAY SUBROUTINE

P370ALRM	STQ	EXIT
			SPRTEX
		CA	MPAC
		TC	VARALARM
		CAF	V5N09RTE
		TC	BANKCALL
		CADR	GOFLASH
		TCF	GOTOP00H
		TCF	-4
		TC	INTPRET
		GOTO
			SPRTEX
V5N09RTE	VN	0509

## Page 901
# TIME RADIUS CALLING SUBROUTINE
#
# INPUT
#	RVEC		INITIAL POSITION VECTOR					VECTOR	B29	METERS
#	VVEC		INITIAL VELOCITY VECTOR					VECTOR	B7	METERS/CS
#	RDESIRED	FINAL RADIUS FOR WHICH TRANSFER TIME IS TO BE COMPUTED	DP	B29	METERS
#	CONICX1		X1 SETTING FOR CONIC SUBROUTINES  -2=EARTH		SP	B14
#
# OUTPUT
#	R(T2)/		FINAL POSITION VECTOR					VECTOR	B29 	METERS
#	V(T2)/		FINAL VELOCITY VECTOR					VECTOR	B7	METERS/CS
#	T12		TRANSFER TIME TO FINAL RADIUS				DP	B28	CS

TMRAD100	STQ	CLEAR
			RTENCKEX
			RVSW
		AXC,2	SXA,2
		OCT	20000
			SGNRDOT
		LXC,1	CALL
			CONICX1
			TIMERAD
		STOVL	V(T2)/		#					PL00D
		STADR
		STODL	R(T2)/
			T
		STCALL	T12
			RTENCKEX

## Page 902
# DISPLAY CALCULATION SUBROUTINE
#
# DESCRIPTION
#	OUTPUT FOR DISPLAY IS CONVERTED TO PROPER UNITS AND PLACED IN OUTPUT STORAGE REGISTERS.  LANDING SITE
#	COMPUTATION FOR DETERMINING LANDING SITE LATITUDE AND LONGITUDE IS INCLUDED IN THE ROUTINE.
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		RTEDISP
#
# SUBROUTINES CALLED
#	TMRAD100
#	AUGEKUGL
#	LAT-LONG
#
# ERASABLE INITIALIZATION REQUIRED
#    PUSHLIST
#	NONE
#    MPAC
#	NONE
#    OTHER
#	R(T2)/		FINAL POSITION VECTOR					VECTOR	B29	METERS
#	V(T2)/		FINAL VELOCITY VECTOR					VECTOR	B7	METERS/CS
#	T2		FINAL TIME						DP	B28	CS
#	V2(T1)/		POST IMPULSE INITIAL VELOCITY VECTOR			VECTOR	B7	METERS/CS
#	V(T1)/		INITIAL VELOCITY VECTOR					VECTOR	B7
#	UR1/		UNIT INITIAL VECTOR					VECTOR	B1
#	UH/		UNIT HORIZONTAL VECTOR					VECTOR	B1
#
# OUTPUT
#	VPRED		VELOCITY MAGNITUDE AT 400,000 FT. ENTRY ALTITUDE	DP	B7	METERS/CS
#	T3TOT4		TRANSIT TIME TO 400,000 FT. ENTRY ALTITUDE		DP	B28	CS
#	GAMMAEI		FLIGHT PATH ANGLE AT 400,000 FT. ENTRY ALTITUDE		DP	B0	REVS + ABOVE HORIZ
#	DELVLVC		INITIAL VELOCITY CHANGE VECTOR IN LOCAL VERTICAL COORD.	VECTOR	B7	METERS/CS
#	LAT(SPL)	LATITUDE OF THE LANDING SITE				DP	B0	REVS
#	LNG(SPL)	LONGITUDE OF THE LANDING SITE				DP	B0	REVS

RTEDISP		STQ	VLOAD		# DISPLAY
			SPRTEX
			V(T2)/
		UNIT	PDDL
			36D
		STODL	VPRED		# V(T2)
			T2
		DSU	
			SPRTETIG
		STOVL	T3TOT4		# T21
			R(T2)/
		UNIT	DOT
		SL1

## Page 903
		ARCCOS	BDSU
			1RTEB2
		STOVL	GAMMAEI		# FLIGHT PATH ANGLE T2
			V2(T1)/
		VSU	PUSH
			V(T1)/
		DOT	DCOMP
			UR1/
		PDVL	PUSH
		DLOAD	PDVL
			ZERORTE
		DOT	VDEF
			UH/
		VSL1
		STODL	DELVLVC
			DELVLVC
		BOFF	DCOMP
			RETROFLG
			RTD18
		STORE	DELVLVC		# NEGATE X COMPONENT, RETROGRADE
RTD18		VLOAD	ABVAL
			DELVLVC
		STOVL	VGDISP
			R(T2)/
		STORE	RVEC		# ***** LANDING SITE COMPUTATION *****
		ABVAL	DSU
			30480RTE
		STOVL	RDESIRED
			V(T2)/
		STCALL	VVEC
			TMRAD100	# R3,V3,T23 FROM TIMERAD
		VLOAD	UNIT
			R(T2)/
		PDVL	UNIT		# UR3					PL06D
			V(T2)/
		DOT	SL1		# GAMMAE=ARCSIN(UR3 . UV3)		PL00D
		ARCSIN	PDDL		# V(T3)					PL02D
			36D
		PDDL	ABS
		PUSH	CALL		# /GAMMAE/				PL04D
			AUGEKUGL	# PHIE					PL06D
		DAD	DAD
			T12		# T23
			T2
		STORE	02D		# T(LS)=T2&T23&TE
		SLOAD	BZE
			P37RANGE
			RTD22
		STORE	04D		# OVERRIDE RANGE (PCR 261)
RTD22		DLOAD	SIN

## Page 904
			04D
		STODL	LNG(SPL)	# LNG(SPL)=SIN(PHIE)			PL04D
		COS
		STORE	LAT(SPL)	# LAT(SPL)=COS(PHIE)
		VLOAD	UNIT
			R(T2)/
		PUSH	PUSH
		PDVL	UNIT		#					PL22D
			V(T2)/
		PDVL	VXV
		VXV	UNIT		# UH3=UNIT(UR3 X UV3 X UR3)		PL10D
		VXSC	PDVL
			LNG(SPL)
		VXSC	VAD		#					PL04D
			LAT(SPL)
		CLEAR	CLEAR		# T(LS) IN MPAC
			ERADFLAG
			LUNAFLAG
		STODL	ALPHAV		# ALPHAV=UR3(COSPHIE)+UH3(SINPHIE) 	PL02D
		CALL
			LAT-LONG
		DLOAD
			LAT
		STODL	LAT(SPL)	# LATITUDE LANDING SITE  *****
			LONG
		STCALL	LNG(SPL)	# LONGITUDE LANDING SITE *****
			SPRTEX
		COUNT*	$$/RTE

## Page 905
# INITIAL VECTOR SUBROUTINE
#
# DESCRIPTION
#	A PRECISION INTEGRATION OF THE STATE VECTOR TO THE TIME OF IGNITION IS PERFORMED. PRECOMPUTATIONS OCCUR.
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		INVC100
#
# NORMAL EXIT MODE
#	AT L+2 OF CALLING SEQUENCE WITH MPAC = 0
#
# ALARM EXIT MODE
#	AT L+2 OF CALLING SEQUENCE WITH MPAC = OCTAL 612 FOR STATE VECTOR IN MOONS SPHERE OF INFLUENCE
#
# SUBROUTINES CALLED
#	CSMPREC
#
# ERASABLE INITIALIZATION REQUIRED
#    PUSHLIST
#	NONE
#    MPAC
#	NONE
#    OTHER
#	SPRTETIG	TIME OF IGNITION					DP	B28	CS
#	CSM STATE VECTOR
#
# OUTPUT
#	R(T1)/		INITIAL POSITION VECTOR AT TIG				VECTOR	B29	METERS
#	V(T1)/		INITIAL VELOCITY VECTOR AT TIG				VECTOR	B7	METERS/CS
#	T1		INITIAL VECTOR TIME (TIG)				DP	B28	CS
#	UR1/		UNIT INITIAL VECTOR					VECTOR	B1
#	UH/		UNIT HORIZONTAL VECTOR					VECTOR	B1
#	CFPA		COSINE OF INITIAL FLIGHT PATH ANGLE			DP	B1

INVC100		STQ	DLOAD
			SPRTEX
			SPRTETIG
		STCALL	TDEC1
			CSMPREC		# PRECISION INTEGRATION  R0,V0 TO R1,V1
		VLOAD	SXA,2
			RATT
			P(T1)
		STOVL	R(T1)/
			VATT
		STODL	V(T1)/
			TAT
		STORE	T1
		SLOAD	BZE
			P(T1)
## Page 906
			INVC109
INVC107		SLOAD	GOTO
			OCT612
			RTEALRM		# R1,V1 NOT IN PROPER SPHERE OF INFLUENCE
INVC109		VLOAD	UNIT
			R(T1)/
		STODL	UR1/		# UR1/					B1
			36D
		STOVL	R(T1)		# R(T1)					B29
			V(T1)/
		UNIT
		STORE	UV1/
		DOT	SL1
			UR1/
		STORE	CFPA		# CFPA					B1
		ABS	DSU
			EPC1RTE
		BMN	DLOAD
			INVC115		# NOT NEAR RECTILINEAR
			1RTEB2
		PDDL	PUSH
			ZERORTE
		VDEF	PUSH		# N/ = (0,0,1)
		GOTO
			INVC120
INVC115		VLOAD	VXV
			UR1/
			UV1/
		PUSH			# N/ = UR X UV				B2
INVC120		CLEAR	DLOAD
			RETROFLG
		PUSH	BPL
			INVC125
		VLOAD	VCOMP		# RETROGRADE ORBIT
		PUSH	SET
			RETROFLG
INVC125		VLOAD
		VXV	UNIT
			UR1/
		STORE	UH/		# UH/					B1
		GOTO
			SPRTEX

## Page 907
# PRECISION TRAJECTORY COMPUTATION SUBROUTINE
#
# DESCRIPTION
#	A NUMERICALLY INTEGRATED TRAJECTORY IS GENERATED WHICH FOR THE RETURN TO EARTH PROBLEM SATISFIES THE REENTRY
#	CONSTRAINTS (RCON AND X(T2)) ACHIEVED BY THE INITIAL CONIC TRAJECTORY AND MEETS THE DVD REQUIREMENT AS CLOSELY
#	AS POSSIBLE.
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		PREC100
#
# NORMAL EXIT MODE
#	AT L+2 OF CALLING SEQUENCE WITH MPAC = 0
#
# ALARM EXIT MODE
#	AT L+2 OF CALLING SEQUENCE WITH MPAC =
#		OCTAL 605	FOR EXCESS ITERATIONS
#		OCTAL 613	FOR REENTRY ANGLE OUT OF LIMITS
#
# SUBROUTINES CALLED
#	INTSTALL
#	RTENCK2
#	RTENCK3
#	TIMERAD
#	PARAM
#	V2T100
#
# ERASABLE INITIALIZATION REQUIRED
#    PUSHLIST
#	NONE
#    MPAC
#	NONE
#    OTHER
#	R(T1)/		INITIAL POSITION VECTOR					VECTOR	B29/B27	METERS
#	V2(T1)/		POST IMPULSE INITIAL VELOCITY VECTOR			VECTOR	B7/B5	METERS/CS
#	V(T1)/		INITIAL VELOCITY VECTOR					VECTOR	B7/B5	METERS/CS
#	T1		INITIAL VECTOR TIME					DP	B28	CS
#	T12		INITIAL TO FINAL POSITION TIME				DP	B28 	CS
#	RCON		CONIC FINAL RADIUS					DP	B29/B27	METERS
#	R(T1)		MAGNITUDE OF INITIAL POSITION VECTOR			DP	B29/B27	METERS
#	X(T2)		COTANGENT OF FINAL FLIGHT PATH ANGLE			DP	B0
#	X(T1)		COTANGENT OF INITIAL FLIGHT PATH ANGLE			DP	B5
#	RTEDVD		DELTA VELOCITY DESIRED					DP	B7/B5	METERS/CS
#	MAMAX1		MAJOR AXIS LIMIT FOR LOWER BOUND ON GAMDV ITERATOR	DP	B30/B28	METERS
#	MAMAX2		MAJOR AXIS LIMIT FOR UPPER BOUND ON GAMDV ITERATOR	DP	B30/B28	METERS
#	UR1/		UNIT INITIAL VECTOR					VECTOR	B1
#	UH/		UNIT HORIZONTAL VECTOR					VECTOR	B1
#	BETA1		1+X(T2)**2						DP	B1
#	PHI2		PERIGEE OR APOGEE INDICATOR				DP	B2	-1 PERIGEE, +1 APOGEE
#
## Page 908
#
# OUTPUT
#    	V2(T1)/		POST IMPULSE INITIAL VELOCITY VECTOR			VECTOR	B7	METERS/CS
#	R(T2)/		FINAL POSITION VECTOR					VECTOR	B29	METERS
#	V(T2)/		FINAL VELOCITY VECTOR					VECTOR	B7	METERS/CS
#	T2		FINAL TIME						DP	B28	CENTISECONDS
#
# DEBRIS
#	RD		FINAL R DESIRED						DP	B29/B27	METERS
#	R/APRE		R/A							DP	B6
#	P/RPRE		P/R							DP	B4
#	RPRE		MAGNITUDE OF R(T2)/					DP	B29/B27	METERS
#	X(T2)PRE	COTANGENT OF GAMMA2					DP	B0
#	DT12		CORRECTION TO FINAL TIME T2				DP	B28	CENTISECONDS
#	RCON		FINAL RADIUS						DP	B29/B27	METERS
#	DRCON		DELTA RCON						DP	B29/B27	METERS

PREC100		STQ	DLOAD
			SPRTEX
			10RTE
		STODL	NN1A
			RCON
		STORE	RD
PREC120		DLOAD
			2RTEB1
		STODL	DT21PR		# DT21PR = POSMAX
			M15RTE
		STCALL	NN2
			RTENCK3
PREC125		CALL
			PARAM
		DLOAD
			P
		STODL	P/RPRE
			R1A
		STODL	R/APRE
			R1
		STODL	RPRE
			COGA
		SL
			5
		STORE	X(T2)PRE
		DCOMP	DAD
			X(T2)
		ABS	DSU
			EPC4RTE
		BOV	BMN	
			PREC130
			PREC175
			
# DESIRED REENTRY ANGLE NOT ACHIEVED

## Page 909
PREC130		DLOAD	BMN
			NN2
			PREC140
PREC132		SLOAD	GOTO		# TOO MANY ITERATIONS
			OCT605		#	EXIT WITH ALARM
			PRECX
			
# DETERMINE RADIUS AT WHICH THE DESIRED REENTRY ANGLE WILL BE ACHIEVED

PREC140		DLOAD	BZE
			NN1A
			PREC162
PREC150		DLOAD	SL2		#				B2
			P/RPRE
		DMP	SL1		# BETA2=BETA1*P/R		B2	PL02
			BETA1
		PUSH	DLOAD
			R/APRE
		SL4	DMP
			00D
		BDSU	BMN		# BETA3=1-BETA2*R/A
			1RTEB4
			PREC160
PREC155		SL2	SQRT
		DMP	BDSU
			PHI2
			1RTEB3
		NORM	PDDL
			X1
		SR1	DDV		# BETA4=BETA2/(1-PHI2*SQRT(BETA3))
		SL*	GOTO		#				B1
			0	-1,1
			PREC165
PREC160		DLOAD	NORM
			R/APRE
			X1
		BDDV	SL*		#				B1
			1RTEB1
			0	-6,1
		GOTO
			PREC165
PREC162		DLOAD	NORM
			RPRE
			X1
		BDDV	SL*		# BETA4=RD/RPRE			B1
			RD
			0 -1,1
PREC165		SETPD	PUSH
			0
		DSU	DCOMP
## Page 910
			1RTEB1
		STORE	BETA12
		BMN	DLOAD
			PREC168
			X(T2)PRE
		BMN	DLOAD
			PREC167
			BETA12
		DCOMP
		STORE	BETA12
PREC167		DLOAD
			BETA12
PREC168		ABS	DSU
			EPC6RTE
		BMN	DLOAD
			PREC175
		DMP	SL1
			RPRE
		PUSH			# RF = NEW RADIUS
PREC170		DLOAD	DAD
			NN2
			1RTEB28
		STORE	NN2
		VLOAD	SET
			R(T2)/
			RVSW
		STOVL	RVEC
			V(T2)/
		SIGN
			BETA12
		STODL	VVEC
			1RTEB1
		SIGN	DCOMP
			BETA12
		LXA,2	DLOAD
			MPAC
		LXC,1	SXA,2
			CONICX1
			SGNRDOT
		STCALL	RDESIRED	# COMPUTED DT12 (CORRECTION TO TIME OF
			TIMERAD		#	NEW RADIUS)
		DLOAD	SIGN
			T
			BETA12
		PDDL	NORM		# DT21=(PHI4)DT21			PL02D
			DT21PR
			X1
		BDDV	SL*
			00D
			0 -3,1
## Page 911
		PUSH	BMN		# BETA13=(DT21)/(DT21PR)	R3 	PL04D
			PREC172		
		DLOAD	PDDL		# BETA14=1			B0 	PL04D
			2RTEB1
		GOTO
			PREC173
PREC172		DLOAD	PDDL		# BETA14=.6			B0 	PL04D
			M.6RTE
PREC173		DDV	DSU
			02D
			1RTEB3
		BMN	DLOAD
			PREC174
		DMP	
			DT21PR
		STORE	00D		# DT21=(BETA14)DT21PR		B28
PREC174		DLOAD	PUSH
			00D
		STCALL	DT21PR
			RTENCK2
		GOTO
			PREC125
PREC175		DLOAD	DSU
			RPRE
			RD
		PUSH	ABS		# RPRE-RD = RERR
		DSU	BMN
			EPC7RTE
			PREC220
			
# DESIRED RADIUS HAS NOT BEEN ACHIEVED

		DLOAD	BZE
			NN1A
			PREC132		# TOO MANY ITERATIONS
		DSU	BZE
			10RTE
			PREC207
PREC205		DLOAD	DSU		# NOT FIRST PASS OF ITERATION
			RPRE'
			RPRE		# RPRE'-RPRE			B29/B27
		NORM	BDDV
			X2
			DRCON
		SL*	PUSH		# DRCON/(RPRE'-RPRE)=S		B2
			0 -2,2
		DAD	BOV		# S GR +4 OR LS -4
			1RTEB1
			PREC205M
		ABS	DSU
## Page 912
			1RTEB1
		BMN
			PREC206
PREC205M	DLOAD	DCOMP		# S GR 0 OR LS -4
			2RTEB1
		PDDL			# S=-4				B2
PREC206		DLOAD	DMP
		SL2
		STORE	DRCON		# DRCON=S(RERR)			B29
		DAD
			RCON
		STORE	RCON		# RCON+DRCON=RCON
		GOTO
			PREC210
PREC207		DLOAD	DSQ		# FIRST PASS OF ITERATION
			RD
		NORM	SR1
			X1
		PDDL	NORM
			RPRE
			X2
		XSU,1	BDDV
			X2
		SR*
			0 -1,1
		STORE	RCON		# RD**2/RPRE=RCON
		DSU
			RD
		STORE	DRCON		# RCON-RD=DRCON
PREC210		DLOAD			# PREPARE FOR NEXT ITERATION
			RPRE
		STODL	RPRE'
			NN1A
		DSU
			1RTEB28
		STCALL	NN1A
			V2T100
		BHIZ	GOTO
			PREC120
			PRECX
			
# DESIRED RADIUS ACHIEVED

		SETLOC	RTE2
		BANK
PREC220		DLOAD	DSU
			X(T2)
			X(T2)PRE
		ABS	DSU
			EPC8RTE
## Page 913
		BMN	SLOAD
			PREC225
			OCT613
		GOTO
			PRECX		# IF REENTRY ANGLE OUT OF LIMITS

EPC8RTE		2DEC	.002

OCT613		OCT	613

# DESIRED FINAL ANGLE HAS BEEN REACHED.

		SETLOC	RTE
		BANK
PREC225		DLOAD
			ZERORTE
PRECX		GOTO
			SPRTEX
			
## Page 914
# INTEGRATION CALLING SUBROUTINE
#
# DESCRIPTION
#	PERFORMS CONIC AND PRECISION INTEGRATIONS USING SUBROUTINE INTEGRVS.  THERE ARE THREE ENTRANCES (RTENCK1,
#	RTENCK2, AND RTENCK3) FOR DIFFERENT SOURCES OF INPUT AND DIFFERENT OPTIONS.  THERE IS A COMMON SET OF OUTPUT
# 	WHICH INCLUDES SET UP OF INPUT FOR THE PARAM SUBROUTINE.
#
# RTENCK1 (CONIC INTEGRATION)
#
#    CALLING SEQUENCE
#	L	CALL
#	L+1		RTENCK1
#
#    ERASABLE INITIALIZATION REQUIRED
#	SAME AS FOR THE RTENCK3 ENTRANCE
#
# RTENCK2 (PRECISION INTEGRATION)
#
#    CALLING SEQUENCE
#	L	CALL
#	L+1		RTENCK2
#
#    ERASABLE INITIALIZATION REQUIRED
#	PUSHLIST
#	    PUSHLOC-2	INTEGRATION TIME DT12 (CORRECTION TO T2)		DP	B28	CS
#	OTHER
#	    R(T2)/	FINAL POSITION VECTOR					VECTOR	B29	METERS
#	    V(T2)/	FINAL VELOCITY VECTOR					VECTOR	B7	METERS/CS
#	    T2		FINAL TIME						DP	B28	CS
#
# RTENCK3 (PRECISION INTEGRATION)
#
#    CALLING SEQUENCE
#	L	CALL
#	L+1		RTENCK3
#
#    ERASABLE INITIALIZATION REQUIRED
#	R(T1)/		INITIAL POSITION VECTOR					VECTOR	B29	METERS
#	V2(T1)/		POST IMPULSE INITIAL VELOCITY VECTOR			VECTOR	B7	M/CS
#	T1		INITIAL VECTOR TIME					DP	B28	CS
#	T2		FINAL TIME						DP	B28	CS
#
# EXIT MODE
#	AT L+2 OF CALLING SEQUENCE
#
# SUBROUTINES CALLED
#	INTSTALL
#	INTEGRVS
#
# OUTPUT
#    PUSHLIST
## Page 915
#	PUSHLOC-6	FINAL POSITION VECTOR R(T2)/				VECTOR	B29	METERS
#	X1		CONICS MUTABLE ENTRY FOR EARTH (-2)			SP	B14
#    MPAC
#			FINAL VELOCITY VECTOR V(T2)/				VECTOR	B7	M/CS
#    OTHER
#	R(T2)/		AS IN PUSHLIST
#	V(T2)/		AS IN MPAC
#	T2		FINAL TIME						DP	B28	CS

		SETLOC	RTE3
		BANK
RTENCK1		STQ	CALL
			RTENCKEX
			INTSTALL
		VLOAD	SET
			R(T1)/
			INTYPFLG
		GOTO
			RTENCK3B
			
RTENCK2		STQ	CALL
			RTENCKEX
			INTSTALL
		CLEAR	VLOAD
			INTYPFLG
			R(T2)/
		STOVL	RCV
			V(T2)/
		STODL	VCV
			T2
		STORE	TET
		DAD
		GOTO
			RTENCK3D
			
RTENCK3		STQ	CALL
			RTENCKEX
			INTSTALL
RTENCK3A	VLOAD	CLEAR
			R(T1)/
			INTYPFLG
RTENCK3B	STOVL	RCV
			V2(T1)/
		STODL	VCV
			T1
		STODL	TET
			T2
## Page 916
RTENCK3D	STORE	TDEC1
		CLEAR	CALL
			MOONFLAG
			INTEGRVS
		VLOAD
			RATT
		STORE	R(T2)/
		PDDL	LXC,1
			TAT
			CONICX1
		STOVL	T2
			VATT
		STORE	V(T2)/
		GOTO
			RTENCKEX
		SETLOC	RTE
		BANK

## Page 917
# V2(T1) COMPUTATION SUBROUTINE
#
# DESCRIPTION
#	A POST IMPULSE VELOCITY VECTOR (V2(T1)) IS COMPUTED WHICH EITHER
#	(1)	MEETS THE INPUT VELOCITY CHANGE DESIRED (RTEDVD) IN A MINIMUM TIME	OR
#	(2)	IF A VELOCITY CHANGE ISN'T SPECIFIED (RTEDVD = 0), A V2(T1) IS COMPUTED WHICH MINIMIZES THE IMPULSE (DV)
#		AND CONSEQUENTLY FUEL.
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		V2T100
#
# NORMAL EXIT MODE
#	AT L+2 OF CALLING SEQUENCE WITH MPAC = 0
#
# ALARM EXIT MODE
#	AT L+2 OF CALLING SEQUENCE WITH MPAC = OCTAL 605 FOR EXCESS ITERATIONS.
#
# SUBROUTINES CALLED
#	GAMDV10
#	XT1LIM
#	DVCALC
#
# ERASABLE INITIALIZATION REQUIRED
#    PUSHLIST
#	NONE
#    MPAC
#	NONE
#    OTHER
#	R(T1)		MAGNITUDE OF INITIAL POSITION VECTOR			DP	B29/B27	METERS
#	RCON		MAGNITUDE OF FINAL POSITION VECTOR			DP	B29/B27	METERS
#	V(T1)/		INITIAL VELOCITY VECTOR					VECTOR	B7/B5	METERS/CS
#	RTEDVD		DELTA VELOCITY DESIRED					DP	B7/B5	METERS/CS
#	UR1/		UNIT INITIAL VECTOR					VECTOR	B1
#	UH/		UNIT HORIZONTAL VECTOR					VECTOR	B1
#	X(T2)		COTANGENT OF FINAL FLIGHT PATH ANGLE			DP	B0
#	X(T1)		COTANGENT OF INITIAL FLIGHT PATH ANGLE (INPUT FOR PREC)	DP	B5
#	CFPA		COSINE OF INITIAL FLIGHT PATH ANGLE			DP	B1
#	MAMAX1		MAJOR AXIS LIMIT FOR LOWER BOUND ON GAMDV ITERATOR	DP	B30/B28	METERS
#	MAMAX2		MAJOR AXIS LIMIT FOR UPPER BOUND ON GAMDV ITERATOR	DP	B30/B28	METERS
#	PHI2		REENTRY NEAR PERIGEE OR APOGEE INDICATE (RTE ONLY)	DP	B2	-1 PERIGEE, +1 APOGEE
#	N1		CONIC OR PRECISION ITERATION OPERATOR			DP	B28	NEGATIVE CONIC, PLUS PREC
#
# OUTPUT
#	V2(T1)/		POST IMPULSE INITIAL VELOCITY VECTOR			VECTOR	B7/B5	METERS/CS
#	DV		INITIAL VELOCITY CHANGE					DP	B7/B5	METERS/CS
#	X(T1)		COTANGENT OF INITIAL FLIGHT PATH ANGLE (POST IMPULSE)	DP	B5
#	PCON		SEMI-LATUS RECTUM					DP	B28/B26	METERS
#	BETA1		1+X(T2)**2						DP	B1
#
## Page 918
#
# DEBRIS
#    PUSHLIST
#	00D		X(T1),,=PREVIOUS PRECISION X(T1)			DP	B5
#	02D		THETA1=BETA5*LAMBDA-1					TP	B17
#	05D		THETA2=2*R(T1)*(LAMBDA-1)				TP	B38/B36
#	08D		THETA3=MU**.5/R(T1)					DP	B-4/B-5
#	10D		X(T1)MIN=LOWER BOUND ON X(T1) IN GAMDV ITERATOR		DP	B5
#	12D		DX(T1)MAX=MAXIMUM DELTA X(T1)				DP	B5
#	14D		X(T1)MAX=UPPER BOUND ON X(T1) IN GAMDV ITERATOR		DP	B5
#	16D		DX(T1)=ITERATOR INCREMENT				DP	B5
#	31D		GAMDV10 SUBROUTINE RETURN ADDRESS
#	32D		DVCALC SUBROUTINE RETURN ADDRESS
#	33D		V2T100 SUBROUTINE RETURN ADDRESS

V2T100		STQ	DLOAD
			33D
			RCON
		BMN	DSU		# ABORT IF RCON NEGATIVE
			V2TERROR
			R(T1)
		BMN
			V2T101
V2TERROR	EXIT			#	OR IF LAMBDA LESS THAN ONE
		TC	P00DOO		# NO SOLUTION IF LAMBDA LESS THAN 1
		OCT	00610
V2T101		SETPD	CLEAR
			0		#					PL00D
			F2RTE
		DLOAD	NORM
			RCON
			X1
		PDDL	NORM
			R(T1)
			S1
		STORE	10D
		SR1	DDV		# R1/RCON = LAMBDA		B1
		XSU,1	PDDL		#					PL02D
			S1
			X(T2)
		DSQ
		SR1	DAD
			1RTEB1
		STORE	BETA1		# 1+X(T2)**2 = BETA1		B1
		DMP
			00D
		STORE	28D		# BETAI*LAMBDA = BETA5
		DMP	SL*
			00D
			0 -7,1
		SL*	DSU
## Page 919
			0 -7,1
			1RTEB17
		RTB	PDDL		# BETA5*LAMBDA-1 = THETA1	B17	PL05D
			TPMODE
			1RTEB1
		SR*	DCOMP
			0,1
		DAD	DMP
			00D
			R(T1)
		SL*	RTB
			0 -7D,1
			TPMODE
		PDDL			# 2*R(T1)*(LAMBDA-1)=THETA2	B38/B36 PL08D
			RTMURTE
		NORM	SR1
			X2
		XSU,2	DDV
			S1
			10D
		SR*	PDDL		# MU**.5/R(T1)=THETA3		B-4/B-5 PL10D
			6,2
			MAMAX1
		PUSH	PUSH		# MAMAX1=MA
		CALL
			XT1LIM
		DCOMP	PUSH		# X(T1)MIN			B5 	PL12D
		DCOMP	SR4
		PDDL	PUSH		# DX(T1)MAX			B5 	PL14D
			MAMAX2
		PUSH	CALL
			XT1LIM
		PDDL	BMN		# X(T1)MAX			B5 	PL16D
			NN1A
			V2T102
		GOTO
			V2T110
			
# PROCEED HERE IF NOT PRECISION COMPUTATION

V2T102		DLOAD
			RTEDVD
		BZE	GOTO
			V2T105
			V2T140
V2T105		DLOAD	BMN
			CFPA
			V2T140
		GOTO
			V2T145
## Page 920
# DURING A PRECISION TRAJECTORY ITERATION CONSTRAIN THE INDEPENDENT
# VARIABLE TO INSURE THAT ALL CONICS PASS THROUGH RCON ON THE SAME PASS
# THROUGH X(T2)

V2T110		DLOAD	RTB
			1RTEB17
			TPMODE
		DCOMP	PDDL		# -1				B17 	PL19D
			2RTEB1
		SR*	DSU
			0,1
			00D
		DMP	SL*
			28D
			0 -7,1
		SL*	TAD
			0 -7,1
		RTB	PDDL		# BETA5(2-LAMBDA)-1=BETA6	B17 	PL19D
			TPMODE
			X(T1)
		STORE	00D		# X(T1),,			B5
		TLOAD			#					PL16D
		BMN	BZE
			V2T115
			V2T115
		SL	GOTO
			7
			V2T120
V2T115		DLOAD	BMN
			PHI2
			V2T125
		DCOMP
		STODL	PHI2
			10RTE
		STORE	NN1A
		GOTO
			V2T125
V2T120		SQRT	RTB
			DPMODE
		PDDL	BMN		# BETA6**.5=X(T1)LIM		B5 	PL18D
			PHI2
			V2T130
		DLOAD	STADR
		STORE	14D		# X(T1)LIM = X(T1)MAX
		DCOMP
		STORE	10D		# -X(T1)LIM = X(T1)MIN
V2T125		DLOAD	BZE
			X(T1)
			V2T140
		BMN	GOTO
## Page 921
			V2T140
			V2T145
V2T130		DLOAD	BZE
			X(T1)
			V2T135
		BMN	DLOAD		#					PL16D
			V2T135
		STADR
		STORE	10D		# X(T1)LIM = X(T1)MIN
		GOTO
			V2T145
V2T135		DLOAD	DCOMP		#					PL16D
		STADR
		STORE	14D		# -X(T1)LIM = X(T1)MAX
V2T140		DLOAD
			10D
		STODL	X(T1)		# X(T1)MIN = X(T1)
			12D
		PUSH	GOTO		# DX(T1)MAX = DX(T1)			PL18D
			V2T150
V2T145		DLOAD
			14D
		STODL	X(T1)		# X(T1)MAX = X(T1)
			12D
		DCOMP	PUSH		# -DX(T1)MAX = DX(T1)			PL18D
V2T150		CALL			# GOTO X(T1)-DV ITERATOR
			GAMDV10
		DLOAD	BZE		# EXIT IF MINIMUM FUEL MODE
			RTEDVD
			V2T1X
			
# CONTINUE IF TIME CRITICAL MODE

		DSU	BMN
			DV
			V2T155
		GOTO
			V2T175
V2T155		DLOAD	BMN
			NN1A
			V2T160
		GOTO
			V2T185
			
# CONIC TRAJECTORY COMPUTATION

V2T160		DLOAD	BZE
			X(T1)
			V2T165
		BMN	GOTO
## Page 922
			V2T165
			V2T300
V2T165		DLOAD	BZE
			CFPA
			V2T300
		BMN	DLOAD
			V2T300
			14D
		STODL	X(T1)		# X(T1)MAX=X(T1)
			12D
		DCOMP
		STCALL	16D		# -DX(T1)MAX=DX(T1)
			GAMDV10
		DLOAD	DSU
			RTEDVD
			DV
		BMN
			V2T300
V2T175		SET	DLOAD
			F2RTE
			X(T1)
		BOFF
			SLOWFLG
			V2T177
		STODL	10D		# X(T1)MIN
			12D		# DX(T1)MAX
		GOTO
			V2T179
V2T177		STODL	14D
			12D
		DCOMP
V2T179		STCALL	16D		# DX(T1)
			GAMDV10
		DLOAD	BMN
			NN1A
			V2T300
			
# PREVENT A LARGE CHANGE IN INDEPENDENT VARIABLE DURING AN ITERATION FOR A
# PRECISION TRAJECTORY

V2T185		DLOAD	DSU
			X(T1)
			00D
		ABS	PDDL		# /X(T1)-X(T1),,/ = BETA7
			12D
		SL1	BDSU
		BMN	DLOAD
			V2T300
			00D		# CONTINUE IF BETA7 LARGER THAN 2DX(T1)MAX
		STORE	X(T1)		# X(T1),, = X(T1)
## Page 923
		DSU	BMN
			14D
			V2T195
		DLOAD
			14D
		STORE	X(T1)		# X(T1)MAX = X(T1)
		GOTO
			V2T205
V2T195		DLOAD	DSU
			X(T1)
			10D
		BMN	GOTO
			V2T200
			V2T205
V2T200		DLOAD
			10D
		STORE	X(T1)		# X(T1)MIN = X(T1)
V2T205		CALL
			DVCALC
V2T300		DLOAD
			ZERORTE
V2T1X		GOTO
			33D
			
## Page 924
# X(T1)-DV ITERATOR SUBROUTINE
#
# DESCRIPTION
#	COMPUTES A POST IMPULSE VELOCITY VECTOR (V2(T1)) WHICH REQUIRES A MINIMUM DV.
#
# CALLING SEQUENCE
#	L	CALL
#	L+1		GAMDV10
#
# NORMAL EXIT MODE
#	AT L+2 OF CALLING SEQUENCE
#
# ALARM EXIT MODE
#	AT V2T1X WITH MPAC = OCTAL 605 FOR EXCESS ITERATIONS
#
# SUBROUTINES CALLED
#	DVCALC
#
# ERASABLE INITIALIZATION REQUIRED
#    PUSHLIST
#	02D		THETA1=BETA5*LAMBDA-1					TP	B17
#	05D		THETA2=2*R(T1)*(LAMBDA-1)				TP	B38/B36
#	08D		THETA3=MU**.5/R(T1)					DP	B-4/B-5
#	10D		X(T1)MIN=LOWER BOUND ON INDEPENDENT VARIABLE X(T1)	DP	B5
#	12D		DX(T1)MAX=MAXIMUM DX(T1)				DP	B5
#	14D		X(T1)MAX=UPPER BOUND ON INDEPENDENT VARIABLE X(T1)	DP	B5
#	16D		DX(T1)=ITERATOR INCREMENT				DP	B5
#    MPAC
#	NONE
#    OTHER
#	V(T1)/		INITIAL VELOCITY VECTOR					VECTOR	B7/B5	METERS/CS
#	RTEDVD		DELTA VELOCITY DESIRED					DP	B7/B5	METERS/CS
#	UR1/		UNIT INITIAL VECTOR					VECTOR	B1
#	UH/		UNIT HORIZONTAL VECTOR					VECTOR	B1
#	X(T1)		COTANGENT OF INITIAL FLIGHT PATH ANGLE (FROM VERTICAL)	DP	B5
#	F2RTE		TIME CRITICAL OR MINIMUM FUEL MODE INDICATOR		STATE AREA	0 MIN. FUEL, 1 MIN. TIME
#
# OUTPUT
#	V2(T1)/		POST IMPULSE INITIAL VELOCITY VECTOR			VECTOR	B7/B5	METERS/CS
#	DV		INITIAL VELOCITY CHANGE					DP	B7/B5	METERS/CS
#	X(T1)		COTANGENT OF INITIAL FPA MEASURED FROM VERTICAL		DP	B5
#	PCON		SEMI-LATUS RECTUM					DP	B28/B26	METERS
#
# DEBRIS
#    PUSHLIST
#	00D		X(T1),,
#	02D		THETA1
#	05D		THETA2
#	08D		THETA3
#	10D		X(T1)MIN
#	12D		DX(T1)MAX
## Page 925
#	14D		X(T1)MAX
#	16D		DX(T1)
#	22D		DV,=PREVIOUS DV						DP	B7/B5
#	24D		BETA9=X(T1)+1.1DX(T1)					DP	B5
#	31D		GAMDV10 SUBROUTINE RETURN ADDRESS
#	32D		DVCALC SUBROUTINE RETURN ADDRESS
#	33D		V2T100 SUBROUTINE RETURN ADDRESS

GAMDV10		STQ
			31D
		SETPD	CALL
			18D		#					PL18D
			DVCALC
		DLOAD	DSU
			14D
			10D
		BOV
			GAMDV20
		PUSH	DSU		# X(T1)MAX-X(T1)MIN=BETA8	B5 	PL20D
			EPC9RTE
		BMN	DLOAD
			GAMDVX		# BOUNDS CLOSE TOGETHER
			18D
		DSU	BMN		# BETA8-DX(T1)MAX
			12D
			GAMDV15
		SETPD	GOTO		#					PL18D
			18D
			GAMDV20
GAMDV15		DLOAD			#					PL18D
		SIGN	SR1
			16D
		STORE	16D		# BETA8(SIGNDX(T1))/2=DX(T1)
GAMDV20		DLOAD
			M144RTE
		STORE	NN2
GAMDV25		DLOAD	DAD
			NN2
			1RTEB28
		BMN	SLOAD
			GAMDV30
			OCT605
		GOTO
			V2T1X
GAMDV30		STORE	NN2		# NN2=NN2+1
		DLOAD	PDDL		# X(T1)=X(T1),			B5 	PL20D
			X(T1)
			DV
		PDDL	DAD		# DV=DV,			B7/B5 	PL22D
			X(T1)
			16D
## Page 926
		STCALL	X(T1)		# X(T1)+DX(T1)=X(T1)		B5
			DVCALC
		BON	DLOAD
			F2RTE
			GAMDV35
			DV
		DSU	BMN		# CONTINUE IF FUEL CRITICAL MODE
			20D
			GAMDV33
GAMDV32		DLOAD	DCOMP
			16D
		SR1
		STORE	16D
GAMDV33		SETPD	GOTO
			18D		#					PL18D
			GAMDV50
			
# TIME CRITICAL MODE

GAMDV35		DLOAD	DSU
			RTEDVD
			DV
		PDDL	PUSH		# DVD-DV=DVERR			B7/B5 	PL22D
GAMDV40		DLOAD	ABS		# DV,					PL24D
			20D
		DSU	BMN
			EPC10RTE
			GAMDVX
GAMDV45		BOVB	DLOAD
			TCDANZIG	# ASSURE OVFIND IS 0
		BDSU	NORM
			DV
			X2
		PDDL			# DV-DV,			B7/B5-N2 PL22D
		NORM	SR1		# DVERR				B8/B6-N1
			X1
		DDV	PDDL		# DVERR/ DV - DV
		BDSU	DMP		#					PL18D
			X(T1)
		XSU,1
			X2
		STORE	16D		# PRESERVE SIGN IF OVERFLOW
		SR*	BOV
			0 -1,1
			GAMDV47
		STORE	16D		# (X(T1)-X(T1),)DVERR/(DV-DV,)=DX(T1)
		ABS	DSU
			12D
		BMN
			GAMDV50
## Page 927
GAMDV47		DLOAD	SIGN
			12D
			16D
		STORE	16D		# DX(T1)MAX(SIGNDX(T1))=DX(T1)
		
# CHECK TO KEEP INDEPENDENT VARIABLE IN BOUNDS

GAMDV50		DLOAD	DMP
			16D
			1.1RTEB1
		SL1	DAD
			X(T1)
		STORE	24D		# X(T1)+1.1DX(T1)=BETA9		B5
		DSU	BMN
			14D
			GAMDV55
		DLOAD	DSU
			14D
			X(T1)
		SR1
		STCALL	16D		# (X(T1)MAX-X(T1))/2=DX(T1)	B5
			GAMDV65
GAMDV55		DLOAD	DSU
			24D
			10D
		BMN	GOTO
			GAMDV60
			GAMDV65
GAMDV60		DLOAD	DSU
			10D
			X(T1)
		SR1
		STORE	16D		# (X(T1)MIN-X(T1))/2=DX(T1)	B5
GAMDV65		DLOAD	ABS
			16D
		DSU	BMN
			EPC9RTE
			GAMDVX
		GOTO
			GAMDV25
GAMDVX		GOTO
			31D
			
## Page 928
# DV CALCULATION SUBROUTINE
#
# INPUT
#    PUSHLIST
#	02D		THETA1=BETA5*LAMBDA-1					TP	B17
#	05D		THETA2=2*R(T1)*(LAMBDA-1)				TP	B38/B36
#	08D		THETA3=MU**.5/R(T1)					DP	B-4/B-5
#    OTHER
#	X(T1)		COTANGENT OF POST IMPULSE INITIAL FLIGHT PATH ANGLE	DP	B5
#	V(T1)/		INITIAL VELOCITY VECTOR (PRE IMPULSE)			VECTOR	B7/B5	METERS/CS
#	UR1/		UNIT INITIAL VECTOR					VECTOR	B1
#	UH/		UNIT HORIZONTAL VECTOR					VECTOR	B1
#
# OUTPUT
#	V2(T1)/		POST IMPULSE INITIAL VELOCITY VECTOR			VECTOR	B7/B5	METERS/CS
#	DV		INITIAL VELOCITY CHANGE					DP	B7/B5	METERS/CS
#	PCON		SEMI-LATUS RECTUM					DP	B28/B26	METERS
#
# DEBRIS
#	28D		THETA3*PCON**.5						DP	B10/B8-N1
#	C(PUSHLOC)	THETA3(PCON**.5)*X(T1)*UR1/				VECTOR	B7/B5
#	32D		DVCALC SUBROUTINE RETURN ADDRESS
#	X1		NORMALIZATION FACTOR FOR VALUE IN 28D
#
# PUSHLOC IS RESTORED TO ITS ENTRANCE VALUE UPON EXITING DVCALC

DVCALC		STQ	DLOAD
			32D
			X(T1)
		DSQ	SR
			7
		DCOMP	TAD
			02D
		NORM	PUSH
			X1
		TLOAD	NORM
			05D
			X2
		RTB	SR1
			DPMODE
		XSU,2	DDV
			X1
		SR*
			6,2
		STORE	PCON		# THETA2/(THETA1-X(T1)**2)=PCON	B28/26
		SQRT	DMP
			08D
		NORM
			X1
		STODL	28D		# THETA3*PCON**.5		B10/B8 -N1
## Page 929
			X(T1)
		NORM	VXSC
			X2
			UR1/		# X(T1)*UR1/			B5+B1 -N2
		XAD,2	VXSC
			X1
			28D
		VSR*	PDVL		# THETA3(PCON**.5)X(T1)*UR1/	B7/B5
			0 -9D,2		#		+
			UH/
		VXSC	VSR*		# THETA3(PCON**.5)UH/		B7/B5
			28D
			0 -4,1		#		=
		VAD	STADR
		STORE	V2(T1)/		# V2(T1)/			B7/B5
		VSU	ABVAL
			V(T1)/
		STORE	DV		# ABVAL(V2(T1)/-V1(T)/)=DV	B7/B5
		GOTO
			32D

## Page 930
# SUBROUTINE TO COMPUTE BOUNDS ON INDEPENDENT VARIABLE X(T1)
#
# INPUT
#    PUSHLIST
#	PUSHLOC -4	MAJOR AXIS (MA)						DP	B30/B28
#	PUSHLOC -2	MAJOR AXIS (MA) AGAIN					DP	B30/B28
#	28D		BETA5=LAMBDA*BETA1					DP	B9
#    OTHER
#	RCON									DP	B29/B27
#	R(T1)									DP	B29/B27
#
# OUTPUT
#    MPAC
#	X(T1)LIM	LIMIT ON INDEPENDENT VARIABLE X(T1)			DP	B5
#
# DEBRIS
#    PUSHLIST
#	C(PUSHLOC)	MA-RCON							DP	(B30/28)-N1
#	C(PUSHLOC) +2	MA							DP	B30/B28
#	X1		NORMALIZATION FACTOR FOR MA-RCON
#	20D		XT1LIM SUBROUTINE RETURN ADDRESS
#
# PUSHLOC IS RESTORED TO ITS ENTRANCE VALUE UPON EXITING XT1LIM

XT1LIM		STQ	DLOAD
			20D
			RCON
		SR1	BDSU
		NORM	PDDL		# MA-RCON			B30-N1
			X2
		PDDL	SR1
			R(T1)
		BDSU	DDV
		SL*	DMP
			0	-3,2
			28D
		SL*	DSU		# BETA10=BETA5(MA-RT)/(MA-RC)-1	B11
			0	-6,1
			1RTEB25 +1	# 1.0				B-11
		SL1	BOV
			XT1LIM2
		BMN	GOTO
			XT1LIM5
			XT1LIM3
XT1LIM2		DLOAD			# BETA10=POSMAX IF OVERFLOW
			2RTEB1
XT1LIM3		SQRT	GOTO		# X(T1)=SQRT(BETA10)
			XT1LIMX
XT1LIM5		DLOAD	
			ZERORTE
XT1LIMX		GOTO
			20D
			
## Page 931
# CONSTANTS FOR THE P37 AND P70 PROGRAMS AND SUBROUTINES

		BANK	36
		SETLOC	RTECON1
		BANK
		
1RTEB1		2DEC	1. B-1
1RTEB2		2DEC	1. B-2
1RTEB3		2DEC	1. B-3
1RTEB4		2DEC	1. B-4
1RTEB10		2DEC	1. B-10
1RTEB12		2DEC	1. B-12
1RTEB13		2DEC	1. B-13
1RTEB17		2DEC	1. B-17
1RTEB25		2DEC	1. B-25
#					* * B25 AND B28 MUST BE CONSECUTIVE * * 
1RTEB28		2DEC	1. B-28
ZERORTE		2DEC	0
M144RTE		2DEC	-144. B-28
M15RTE		2DEC	-15
10RTE		2DEC	10
M.6RTE		2DEC	-.6
1.1RTEB1	2DEC	1.1 B-1
M6RTEB28	2DEC	-6
2RTEB1		2OCT	3777737777
M9RTEB28	2DEC	-9
M8RTEB28	2DEC	-8
30480RTE	2DEC	30480. B-29
VCSPS		2DEC	31.510396 B-5	# (SEE 2VEXHUST)
## Page 932
VCRCS		2DEC	27.0664 B-5
MDOTRCS		2DEC	.0016375 B-3
CSUBT		2DEC	.5
OCT605		OCT	00605
OCT612		OCT	00612
MCOS7.5		2DEC	-.99144486
MSIN7.5		2DEC	-.13052619
MCOS22.5	2DEC	-.92387953 B-2
THETA165	2DEC	.4583333333
THETA210	2DEC	.5833333333
EPC1RTE		2DEC	.99966 B-1
EPC2RTE		2DEC	100. B-29
EPC3RTE		2DEC	.001
EPC4RTE		2DEC	.00001
EPC5RTE		2DEC	.01 B-6
EPC6RTE		2DEC	.000007 B-1
EPC7RTE		2DEC	1000. B-29
EPC9RTE		2DEC	1. B-25
EPC10RTE	2DEC	.0001 B-7

		BANK	35
		SETLOC	RTECON1
		BANK
		
C4RTE		2DEC	-6.986643 E7 B-30
K1RTE		2DEC	7. E6 B-29
K2RTE		2DEC	6495000. B-29
K3RTE		2DEC	-.06105
K4RTE		2DEC	-.10453
RTMURTE		2DEC	199650.501 B-18
## Page 933
E3RTE		2DEC	121920. B-29

