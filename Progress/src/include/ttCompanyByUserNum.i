
/*------------------------------------------------------------------------
    File        : ttCompanyByUserNum.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : wayfaretraining
    Created     : Mon Aug 16 22:31:17 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttCompanyByUserNum NO-UNDO
    FIELD CompanyName AS CHARACTER FORMAT "x(60)"
    FIELD NumberOfUsers AS INTEGER
    FIELD NumberOfAgencies AS INTEGER
    
    INDEX idxNumUsers IS PRIMARY NumberOfUsers DESCENDING.