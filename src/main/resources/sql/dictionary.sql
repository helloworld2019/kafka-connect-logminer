/**
 * Copyright 2018 David Arnold
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

WITH DCC AS (
    SELECT
        DCC.OWNER,
        DCC.TABLE_NAME,
        DCC2.COLUMN_NAME,
        1 PK_COLUMN
    FROM
        DBA_CONSTRAINTS DCC,
        DBA_CONS_COLUMNS DCC2
    WHERE
        DCC.OWNER = DCC2.OWNER
        AND DCC.TABLE_NAME = DCC2.TABLE_NAME
        AND DCC.CONSTRAINT_NAME = DCC2.CONSTRAINT_NAME
        AND DCC.CONSTRAINT_TYPE = 'P'
), DUQ AS (
    SELECT
        DI2.TABLE_OWNER,
        DI2.TABLE_NAME,
        DI2.COLUMN_NAME,
        1 UQ_COLUMN
    FROM
        DBA_IND_COLUMNS DI2
        JOIN DBA_INDEXES DI ON DI.TABLE_OWNER = DI2.TABLE_OWNER
                               AND DI.TABLE_NAME = DI2.TABLE_NAME
                               AND DI.UNIQUENESS = 'UNIQUE'
                               AND DI.OWNER = DI2.INDEX_OWNER
                               AND DI.INDEX_NAME = DI2.INDEX_NAME
    GROUP BY
        DI2.TABLE_OWNER,
        DI2.TABLE_NAME,
        DI2.COLUMN_NAME
)
SELECT
    DC.OWNER,
    DC.TABLE_NAME,
    DC.COLUMN_NAME,
    DC.NULLABLE,
    DC.DATA_TYPE,
    NVL(DC.DATA_PRECISION, DC.DATA_LENGTH) DATA_LENGTH,
    NVL(DC.DATA_SCALE, 0) DATA_SCALE,
    NVL(DC.DATA_PRECISION, 0) DATA_PRECISION,
    NVL(X.PK_COLUMN, 0) PK_COLUMN,
    NVL(Y.UQ_COLUMN, 0) UQ_COLUMN
FROM
    DBA_TAB_COLS DC
    LEFT OUTER JOIN DCC X ON X.OWNER = DC.OWNER
                             AND X.TABLE_NAME = DC.TABLE_NAME
                             AND DC.COLUMN_NAME = X.COLUMN_NAME
    LEFT OUTER JOIN DUQ Y ON Y.TABLE_OWNER = DC.OWNER
                             AND Y.TABLE_NAME = DC.TABLE_NAME
                             AND Y.COLUMN_NAME = DC.COLUMN_NAME
WHERE
    DC.OWNER = :OWNER
    AND DC.TABLE_NAME = :TABLENAME
    AND DC.HIDDEN_COLUMN = 'NO'
    AND DC.VIRTUAL_COLUMN = 'NO'
ORDER BY
    DC.TABLE_NAME,
    DC.COLUMN_ID