CREATE ROLE C##LOGMNR_ROLE;
GRANT CREATE SESSION TO C##LOGMNR_ROLE;
GRANT EXECUTE_CATALOG_ROLE, 
      SELECT ANY TRANSACTION,
      SELECT ANY DICTIONARY,
      LOGMINING
      TO C##LOGMNR_ROLE;

CREATE USER C##KCLUSER IDENTIFIED BY KCLPASS;
GRANT C##LOGMNR_ROLE TO C##KCLUSER;
ALTER USER C##KCLUSER QUOTA UNLIMITED ON USERS SET CONTAINER_DATA = ALL CONTAINER = CURRENT;