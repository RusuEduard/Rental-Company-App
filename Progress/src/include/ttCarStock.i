
/*------------------------------------------------------------------------
    File        : ttCarStock.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : cristinahendre
    Created     : Mon Aug 02 16:09:09 EEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEFINE TEMP-TABLE ttCarStock NO-UNDO 
       BEFORE-TABLE bttCarStock
       FIELD CarStockId AS CHARACTER FORMAT "x(36)"
       FIELD CarId AS CHARACTER FORMAT "x(36)"
       FIELD CarAgencyId AS CHARACTER  FORMAT "x(36)"
       FIELD StockAmount AS INTEGER FORMAT "->,>>>,>>9"
       FIELD ValidFrom AS DATE 
       FIELD ValidTo AS DATE
       INDEX pkCarStock IS PRIMARY UNIQUE CarStockId.
