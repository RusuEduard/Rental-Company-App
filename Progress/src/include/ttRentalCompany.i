DEFINE TEMP-TABLE ttRentalCompany NO-UNDO 
    BEFORE-TABLE bttRentalCompany
    FIELD RentalCompanyId   AS CHARACTER FORMAT "x(36)"
    FIELD Description       AS CHARACTER FORMAT "x(36)"
    
    INDEX RentalCompanyId IS PRIMARY UNIQUE RentalCompanyId. 