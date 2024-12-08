601,100
602,"Data - Load - Back Pay and Adj"
562,"CHARACTERDELIMITED"
586,"model_upload\MonthlyBackPay&TemporaryPayments-P01-2024.csv"
585,"model_upload\MonthlyBackPay&TemporaryPayments-P01-2024.csv"
564,
565,"fK0eOPa1NQ]7koBvl>yf?@L]PhIgHoo2p1`Lxi^[OL777:MMN;dNf;[kS^qrHnKMQ4TsstUYitOt?;C7;B`IvvV>:Bx=n<lD:FPgB38H17rQXYncw^U>Lb_tsxEdm^g;pn_FR;Qsp0vht^xEaIYTrVYOsz>T6O<g^g:pxWU2j<[C?JD0=4oygJDOsPju@kQT0JsXXxM:"
559,1
928,0
593,
594,
595,
597,
598,
596,
800,
801,
566,0
567,","
588,"."
589,","
568,""""
570,
571,
569,1
592,0
599,1000
560,4
pFileName
pVersion
pYear
pMonth
561,4
2
2
2
2
590,4
pFileName,"MonthlyBackPay&TemporaryPayments"
pVersion,"Actual"
pYear,"2024"
pMonth,"P01"
637,4
pFileName,"File Name"
pVersion,"Which version"
pYear,"What Year"
pMonth,"What Month"
577,6
vEmployee
vRole
vPosition
vElement
vCostCode
vValue
578,6
2
2
2
2
2
1
579,6
1
2
3
4
5
6
580,6
0
0
0
0
0
0
581,6
0
0
0
0
0
0
582,6
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=32ColType=827
VarType=33ColType=827
603,0
572,77
#****Begin: Generated Statements***
#****End: Generated Statements****

# ==================================================
# Process Variables / Constants
# ==================================================
sControlCube = 'Control - Model Parameters';
sPath = CellgetS(sControlCube, 'Source Files Path', 'StringValue');
sFileName = pFileName|'-'|pMonth|'-'| pYear|'.csv';
sFile = sPath|sFilename;

sInsertionPoint = '';
nWeight = 1;
sTypeS = 'S';
sTypeC = 'C';
sTypeN = 'N';
sTypeA ='A';
sType = 'n';

# Variables
# ===================================
sDim1 = 'Department';
sDim2 = 'Nominal';
sDim3 = 'Activity';
sDim4 = 'Role';
sDim5 = 'Employee';
sDim6 = 'Grade';
sDim7 = 'Period and Year';
sDim8 = 'Version';
sDim9 = 'm_mapping';
sDim10 = 'm_payrollByEmp';
sDim11 = 'm_payrollByNom';
sSub = 'TI_Process';
sCube = 'Costs by Employee';
sView = '}VZO PayrollByEmp';

# ==================================================
# Set Datasource
# ==================================================
DatasourceNameForServer         = sFile;
DatasourceNameForClient         = sFile;

# DataSourceType                  = 'CHARACTERDELIMITED';
# DatasourceASCIIHeaderRecords    = 1;
# DatasourceASCIIDelimiter        = ',';
# DatasourceASCIIQuoteCharacter   = '''';

# ==================================================
# Error Check
# ==================================================

# File
# ===================================
IF( FileExists( sFile ) = 0 );
  sError = 'The provided file does not exist in the path';
  ProcessBreak;
ENDIF;

# ==================================================
# View Zero Out - Cost by Employee Cube
# ==================================================
SubsetCreate( sDim7, sSub, 1 );
SubsetCreate( sDim8, sSub, 1 );
SubsetCreate( sDim10, sSub, 1 );

SubsetElementInsert(sDim7, sSub, pMonth|' '|pYear, 1);
SubsetElementInsert( sDim8, sSub, pVersion , 1 );
SubsetElementInsert(sDim10, sSub, 'Back Pay and Adj', 1);

ViewCreate( sCube , sView , 1 );

ViewSubsetAssign( sCube , sView , sDim7 , sSub );
ViewSubsetAssign( sCube , sView , sDim8 , sSub );
ViewSubsetAssign( sCube , sView , sDim10 , sSub );

    ViewZeroOut(sCube, sView);

573,52
#****Begin: Generated Statements***
#****End: Generated Statements****

# ==================================================
# Skip Blanks before anything
# ==================================================
IF ( vValue = 0 ) ;
  ItemSkip;
ENDIF;

# ===========================================================
# Add missing Department, Nominal and Activity elements under UNALLOCATED
# ===========================================================
vDeptCode = SUBST( vCostCode, 3,3);
vNominalCode = SUBST(vCostCode,6,4);
vActivityCode =SUBST(vCostCode,10,5);

# IF ( vNominalCode @<> '1101' % vNominalCode @<> '1102' % vNominalCode @<> '1105' % vNominalCode @<> '1106' % vNominalCode @<> '1110' % vNominalCode @<> '1114' % vNominalCode @<> '1116' ) ;
#   ItemSkip;
# ENDIF;

# IF ( vNominalCode @<> '1101');
#   ItemSkip;
# ENDIF;

IF( vEmployee @='' );
  vEmployee = '0000001';
ENDIF;

IF (DIMIX(sDim1, vDeptCode) = 0);
 DimensionElementComponentAdd( sDim1, 'UNALLOCATED', vDeptCode, nWeight );
 HierarchyElementComponentAdd( sDim1 , 'Department Level 4'  , 'UNALLOCATED', vDeptCode , nWeight );
 HierarchyElementComponentAdd( sDim1 , 'Department Level 0'  , 'UNALLOCATED', vDeptCode , nWeight );
ENDIF;

IF (DIMIX( sDim2, vNominalCode ) = 0);
   DimensionElementComponentAdd( sDim2, 'UNALLOCATED', vNominalCode , nWeight );
   HierarchyElementComponentAdd( sDim2 , 'Nominal Level 0'  , 'UNALLOCATED', vNominalcode , nWeight );
ENDIF;

IF (DIMIX( sDim3, vActivityCode ) = 0 );
   DimensionElementComponentAdd( sDim3, 'UNALLOCATED', vActivityCode , nWeight );
   HierarchyElementComponentAdd( sDim3 , 'Activity Level 0'  , 'UNALLOCATED', vActivityCode , nWeight );
ENDIF;

# ==========================================
# Add missing Employee element under CONSOLIDATION
# ==========================================
IF (DimensionElementExists( sDim5, vEmployee ) = 0 );
   DimensionElementComponentAdd( sDim5, 'TOTAL EMPLOYEES' , vEmployee , nWeight );
ENDIF;

574,75
#****Begin: Generated Statements***
#****End: Generated Statements****

# ==================================================
# Skip Blanks before anything
# ==================================================
IF ( vValue = 0 ) ;
  ItemSkip;
ENDIF;

# ===================================================
# Lookup Role and Grade values in Payroll Lookup (Actual version) cube
# ===================================================
vDeptCode = SUBST( vCostCode, 3,3);
vNominalCode = SUBST(vCostCode,6,4);
vActivityCode =SUBST(vCostCode,10,5);

# IF ( vNominalCode @<> '1101' % vNominalCode @<> '1102' % vNominalCode @<> '1105' % vNominalCode @<> '1106' % vNominalCode @<> '1110' % vNominalCode @<> '1114' % vNominalCode @<> '1116' ) ;
#   ItemSkip;
# ENDIF;

IF (vEmployee @='' );
  vEmployee = '0000001';
ENDIF;

vRoleTrimmed = SUBST( TRIM(vRole), 1 , 6 );
vEmployeeCode = vEmployee;
sPeriodYear = pMonth | ' ' | pYear ;

# Check if Role exist in current period if not take full year (High Level) value else POS001
IF(CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , vNominalCode , pVersion , vActivityCode , sPeriodYear , 'Role' ) @<> '');
    vRoleUnique = CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , vNominalCode , pVersion , vActivityCode , sPeriodYear , 'Role' );
    
    ELSEIF(CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , pYear , 'Role' ) @<> '');
        vRoleUnique = CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , pYear , 'Role' ) ;
    
    ELSEIF(CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , NumberToString(StringToNumber( pYear )- 1) , 'Role' ) @<> '');
        vRoleUnique = CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , NumberToString(StringToNumber( pYear )- 1) , 'Role' ) ;
        
    ELSEIF(vRoleTrimmed @<> '');
        vRoleUnique = vRoleTrimmed;
  ELSE;
    vRoleUnique = 'POS001';
ENDIF;

# Check if Grade exist in current period if not take full year (High Level) value else NA
IF (CellGetS( 'Payroll Lookup' , vEmployeeCode , vDeptCode , vNominalCode , pVersion , vActivityCode , sPeriodYear , 'Grade' ) @<> '');
    vGrade = CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , vNominalCode , pVersion , vActivityCode , sPeriodYear , 'Grade' );

    ELSEIF(CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , pYear , 'Grade' ) @<> '');
        vGrade = CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , pYear , 'Grade' ) ;
    
     ELSEIF(CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , NumberToString(StringToNumber( pYear )- 1) , 'Grade' ) @<> '');
        vGrade = CellGetS ( 'Payroll Lookup' , vEmployeeCode , vDeptCode , 'TOTAL NOMINALS' , pVersion , 'TOTAL ACTIVITY' , NumberToString(StringToNumber( pYear )- 1) , 'Grade' ) ;

  ELSE;
    vGrade = 'NA';
ENDIF;

# =======================================================
# Add missing Role and Grade elements under CONSOLIDATION
# =======================================================
IF( DIMIX( sDim4, vRoleUnique ) = 0 );
   DimensionElementComponentAddDirect( sDim4, 'TOTAL ROLES', vRoleUnique , nWeight );
ENDIF;

IF( DIMIX( sDim6, vGrade ) = 0 );
   DimensionElementComponentAddDirect( sDim6, 'TOTAL GRADES', vGrade , nWeight );
ENDIF;

# ===========================================
# Add Data values in Cost by Employee (Actual version) cube
# ===========================================  
CellIncrementN(vValue*1.10, sCube, sPeriodYear, pVersion, vEmployeeCode , vRoleUnique ,vNominalCode , vDeptCode , vActivityCode , vGrade, 'Back Pay and Adj');

575,11
#****Begin: Generated Statements***
#****End: Generated Statements****

# ==================================================
# Error Check
# ==================================================

IF ( sError @<>' ' );
  ItemReject( sError );
ENDIF;

576,CubeAction=1511DataAction=1503CubeLogChanges=0_ParameterConstraints=e30=
930,0
638,1
804,0
1217,0
900,
901,
902,
938,0
937,
936,
935,
934,
932,0
933,0
903,
906,
929,
907,
908,
904,0
905,0
909,0
911,
912,
913,
914,
915,
916,
917,0
918,1
919,0
920,50000
921,""
922,""
923,0
924,""
925,""
926,""
927,""
