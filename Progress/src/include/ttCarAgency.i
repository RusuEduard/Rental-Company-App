DEFINE TEMP-TABLE ttCarAgency NO-UNDO 
    BEFORE-TABLE bttCarAgency
    FIELD CarAgencyId       AS CHARACTER FORMAT "x(36)"
    FIELD RentalCompanyId   AS CHARACTER FORMAT "x(36)"
    FIELD Address           AS CHARACTER FORMAT "x(60)"
    
    INDEX CarAgencyId IS PRIMARY UNIQUE CarAgencyId. 
