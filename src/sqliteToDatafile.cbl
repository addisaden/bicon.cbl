       IDENTIFICATION DIVISION.
           PROGRAM-ID. sqliteToDatafile.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BIBLE-TEXT-FILE ASSIGN TO WS-TRANSLATION-NAME
             ORGANIZATION IS LINE SEQUENTIAL
             ACCESS MODE IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD BIBLE-TEXT-FILE.
       01 BIBLE-TEXT-RECORD         PIC X(777).
       WORKING-STORAGE SECTION.
       01 WS-TRANSLATION-NAME       PIC X(250).
       01 WS-COMMAND                PIC X(250).
       01 WS-BIBLE-TEXT-EOF         PIC X VALUE "N".
       01 WS-BIBLE-TEXT-LANGUAGE    PIC X(50).
       01 WS-BIBLE-TEXT-TRANSLATION PIC X(10).
       01 WS-BIBLE-TEXT-BOOK        PIC 9(3).
       01 WS-BIBLE-TEXT-CHAPTER     PIC 9(3).
       01 WS-BIBLE-TEXT-VERSE       PIC 9(3).
       01 WS-BIBLE-TEXT-TEXT        PIC X(500).
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
           PERFORM RUNBIBLETEXTFILE
           EXIT PROGRAM.
       SQLITETODATAFILE-EXIT.

       RUNBIBLETEXTFILE.
           MOVE "N" TO WS-BIBLE-TEXT-EOF
           OPEN INPUT BIBLE-TEXT-FILE
           PERFORM UNTIL WS-BIBLE-TEXT-EOF = "Y"
               READ BIBLE-TEXT-FILE
                   AT END
                       MOVE "Y" TO WS-BIBLE-TEXT-EOF
                   NOT AT END
                       UNSTRING BIBLE-TEXT-RECORD
                           DELIMITED BY "###" INTO
                             WS-BIBLE-TEXT-LANGUAGE,
                             WS-BIBLE-TEXT-TRANSLATION,
                             WS-BIBLE-TEXT-BOOK,
                             WS-BIBLE-TEXT-CHAPTER,
                             WS-BIBLE-TEXT-VERSE,
                             WS-BIBLE-TEXT-TEXT
                       DISPLAY WS-BIBLE-TEXT-BOOK
                       DISPLAY WS-BIBLE-TEXT-CHAPTER
                       DISPLAY WS-BIBLE-TEXT-VERSE
           END-PERFORM
           CLOSE BIBLE-TEXT-FILE
           CONTINUE.
       RUNBIBLETEXTFILE-EXIT.
