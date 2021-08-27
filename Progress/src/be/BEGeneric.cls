 
 /*------------------------------------------------------------------------
    File        : BEGeneric
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : cristinahendre
    Created     : Mon Jul 26 15:42:57 EEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

USING Progress.Json.ObjectModel.*.
 
/*                                                                        */
/*USING Progress.Json.ObjectModel.ObjectModelParser FROM PROPATH.         */
/*USING OpenEdge.Web.DataObject.Writer.JsonObjectValueWriter FROM PROPATH.*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS src.BE.BEGeneric: 
    METHOD PUBLIC VOID ExtractABLFilter(INPUT filter AS CHARACTER, OUTPUT cWhere AS CHARACTER, OUTPUT iMaxRows AS INTEGER, OUTPUT iSkipRows AS INTEGER):
        
        DEFINE VARIABLE jsonParser AS ObjectModelParser NO-UNDO.
        DEFINE VARIABLE jsonObject AS Progress.Json.ObjectModel.JsonObject        NO-UNDO.
        DEFINE VARIABLE ablFilter  AS CHARACTER         NO-UNDO.
        DEFINE VARIABLE cOrderBy   AS CHARACTER         NO-UNDO INITIAL "".
        
        MESSAGE "DEBUG BusinessEntity: Filter: " filter.

        IF filter BEGINS "WHERE " THEN
            cWhere = filter.
        ELSE
        IF filter BEGINS "~{" THEN
        DO:
            jsonParser = NEW ObjectModelParser().
            jsonObject = CAST(jsonParser:Parse(filter), jsonObject).
            iMaxRows   = jsonObject:GetInteger("top") NO-ERROR.
            iSkipRows  = jsonObject:GetInteger("skip") NO-ERROR.
            ablFilter  = jsonObject:GetCharacter("ablFilter") NO-ERROR.
            cOrderBy   = jsonObject:GetCharacter("orderBy") NO-ERROR.

            MESSAGE ablFilter.

            IF ablFilter <> "" AND ablFilter <> ? THEN
                cWhere = "WHERE " + ablFilter.

            IF cOrderBy > "" THEN
            DO:
                cOrderBy = REPLACE(cOrderBy, ",", " by ").
                cOrderBy = "by " + cOrderBy + " ".
            END.
        END.
        ELSE
        IF filter NE "" THEN
        DO:
            /* Use filter as WHERE clause */
            cWhere = "WHERE " + filter.
        END.

        IF cOrderBy = ? THEN cOrderBy = "".

        cWhere = IF cWhere > "" THEN (cWhere + " " + cOrderBy) ELSE (cOrderBy).

        MESSAGE "DEBUG BusinessEntity: cWhere: " cWhere.
        MESSAGE "DEBUG BusinessEntity: cOrderBy: " cOrderBy.
        MESSAGE "DEBUG BusinessEntity: iMaxRows: " iMaxRows.
        MESSAGE "DEBUG BusinessEntity: iSkipRows: " iSkipRows.

       // LOG-MANAGER:WRITE-MESSAGE(SUBSTITUTE("cWhere &1", cWhere)).
        
   END METHOD. 
    CONSTRUCTOR PUBLIC BEGeneric (  ):
    END CONSTRUCTOR.
    
    DESTRUCTOR PUBLIC BEGeneric ( ):
    END DESTRUCTOR.

END CLASS.