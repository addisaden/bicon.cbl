       IDENTIFICATION DIVISION.
           PROGRAM-ID. sqliteToDatafile.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01 WS-TRANSLATION-NAME PIC X(250).
       01 WS-COMMAND          PIC X(250).
       LINKAGE SECTION.
       01 SQLITE-DB-FILENAME PIC X(250).
       01 SQLITE-DB-FILEPATH PIC X(250).
       PROCEDURE DIVISION USING
         SQLITE-DB-FILENAME,
         SQLITE-DB-FILEPATH.
       SQLITETODATAFILE.
           UNSTRING SQLITE-DB-FILENAME
             DELIMITED BY "." INTO WS-TRANSLATION-NAME.
           MOVE FUNCTION concatenate(
             FUNCTION trim(WS-TRANSLATION-NAME),
             ".txt.tmp"
           ) TO WS-TRANSLATION-NAME
           CALL "SYSTEM"
             USING FUNCTION concatenate(
                "python scripts/mysword.py -p ",
                SQLITE-DB-FILEPATH,
                " > ",
                WS-TRANSLATION-NAME
           )
           EXIT PROGRAM.
       SQLITETODATAFILE-EXIT.
