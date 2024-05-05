       IDENTIFICATION DIVISION.
       PROGRAM-ID. readTranslation.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BIBLE-DATA-META ASSIGN TO WS-META-FILE
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BIBLE-DATA-META-KEY.
           SELECT BIBLE-DATA-FILE ASSIGN TO WS-DATA-FILE
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BIBLE-DATA-ID.
       DATA DIVISION.
       FILE SECTION.
           COPY 'cpy/file-section/bible-data-meta'.
           COPY 'cpy/file-section/bible-data-file'.
       WORKING-STORAGE SECTION.
       01 WS-META-FILE          PIC X(777).
       01 WS-DATA-FILE          PIC X(777).
       01 WS-TEST-FILE          PIC X(777).
       01 WS-BIBLE-SHORT        PIC X(32).
       01 WS-RETURN             PIC 99.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
           DISPLAY "bible short? " END-DISPLAY
           ACCEPT WS-BIBLE-SHORT

           MOVE FUNCTION concatenate(
               FUNCTION trim(WS-BIBLE-SHORT),
               ".bible.meta",
           ) TO WS-META-FILE

           MOVE WS-META-FILE TO WS-TEST-FILE
           PERFORM testfile

           MOVE FUNCTION concatenate(
               FUNCTION trim(WS-BIBLE-SHORT),
               ".bible.data",
           ) TO WS-DATA-FILE

           MOVE WS-DATA-FILE TO WS-TEST-FILE
           PERFORM testfile

           OPEN i-o BIBLE-DATA-META.

           MOVE "LANG" TO BIBLE-DATA-META-KEY
           READ BIBLE-DATA-META END-READ
           DISPLAY FUNCTION trim(BIBLE-DATA-META-VALUE)

           MOVE "TITLE" TO BIBLE-DATA-META-KEY
           READ BIBLE-DATA-META END-READ
           DISPLAY FUNCTION trim(BIBLE-DATA-META-VALUE)

           CLOSE BIBLE-DATA-META.

           EXIT PROGRAM.

       testfile.
           CALL 'SYSTEM'
               USING
               FUNCTION CONCATENATE(
                   "test -f ",
                   WS-TEST-FILE,
               )
               RETURNING WS-RETURN
           END-CALL
           
           IF WS-RETURN NOT = 0
               DISPLAY "File does not exist for this short."
               EXIT PROGRAM
           END-IF

           CONTINUE.
       testfile-exit.

           END PROGRAM readTranslation.

