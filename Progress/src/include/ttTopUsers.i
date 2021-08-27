

DEFINE TEMP-TABLE ttTopUsers NO-UNDO
       FIELD NumberOfRents AS INTEGER  
       FIELD Username  AS CHARACTER 
       FIELD NAME AS CHARACTER 
       FIELD ListOfCompanies AS CHARACTER FORMAT "x(70)"
       INDEX idx NumberOfRents  DESCENDING.
