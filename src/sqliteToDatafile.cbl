       IDENTIFICATION DIVISION.
           PROGRAM-ID. sqliteToDatafile.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BIBLE-TEXT-FILE ASSIGN TO WS-TRANSLATION-NAME-TXT
             ORGANIZATION IS LINE SEQUENTIAL
             ACCESS MODE IS SEQUENTIAL.
           SELECT BIBLE-DATA-META ASSIGN TO WS-TRANSLATION-NAME-META
             ORGANIZATION IS INDEXED
             ACCESS MODE IS RANDOM
             RECORD KEY IS BIBLE-DATA-META-KEY.
           SELECT BIBLE-DATA-FILE ASSIGN TO WS-TRANSLATION-NAME-DATA
             ORGANIZATION IS INDEXED
             ACCESS MODE IS RANDOM
             RECORD KEY IS BIBLE-DATA-ID.
       DATA DIVISION.
       FILE SECTION.
           COPY 'cpy/file-section/bible-text-file'.
           COPY 'cpy/file-section/bible-data-meta'.
           COPY 'cpy/file-section/bible-data-file'.
       WORKING-STORAGE SECTION.
       01 WS-BIBLE-META-WRITTEN     PIC X VALUE "N".
       01 WS-TRANSLATION-NAME       PIC X(250).
       01 WS-TRANSLATION-NAME-TXT   PIC X(250).
       01 WS-TRANSLATION-NAME-DATA  PIC X(250).
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
       01 SQLITE-DB-TITLE    PIC X(250).
       PROCEDURE DIVISION USING
         SQLITE-DB-FILENAME,
         SQLITE-DB-FILEPATH,
         SQLITE-DB-TITLE.
       SQLITETODATAFILE.
           UNSTRING SQLITE-DB-FILENAME
             DELIMITED BY "." INTO WS-TRANSLATION-NAME.

           MOVE FUNCTION concatenate(
             FUNCTION trim(WS-TRANSLATION-NAME),
             ".txt.tmp"
           ) TO WS-TRANSLATION-NAME-TXT

           MOVE FUNCTION concatenate(
             FUNCTION trim(WS-TRANSLATION-NAME),
             ".bible.meta"
           ) TO WS-TRANSLATION-NAME-META

           MOVE FUNCTION concatenate(
             FUNCTION trim(WS-TRANSLATION-NAME),
             ".bible.data"
           ) TO WS-TRANSLATION-NAME-DATA

      * TODO: Create an if clause to stop the python script if the file
      * exists. 
      *
      *    OPEN INPUT BIBLE-TEXT-FILE
      *    IF NOT BIBLE-TEXT-EOF
      *      DISPLAY "NO DOWNLOAD NEEDED"
      *      CLOSE BIBLE-TEXT-FILE
      *    ELSE
      *      CLOSE BIBLE-TEXT-FILE
      *      CALL "SYSTEM"
      *        USING FUNCTION concatenate(
      *            "python scripts/mysword.py -p ",
      *            SQLITE-DB-FILEPATH,
      *            " > ",
      *            WS-TRANSLATION-NAME-TXT
      *      )
      *    END-IF
           CALL "SYSTEM"
               USING FUNCTION concatenate(
                 "python scripts/mysword.py -p ",
                 SQLITE-DB-FILEPATH,
                 " > ",
                 WS-TRANSLATION-NAME-TXT
           )

           OPEN OUTPUT BIBLE-DATA-META
           OPEN OUTPUT BIBLE-DATA-FILE
           OPEN INPUT BIBLE-TEXT-FILE

           MOVE "TITLE" TO BIBLE-DATA-META-KEY
           MOVE SQLITE-DB-TITLE TO BIBLE-DATA-META-VALUE
           WRITE BIBLE-DATA-META-RECORD

           MOVE "SHORT" TO BIBLE-DATA-META-KEY
           MOVE WS-TRANSLATION-NAME TO BIBLE-DATA-META-VALUE
           WRITE BIBLE-DATA-META-RECORD
           
           MOVE "TXT-FILE" TO BIBLE-DATA-META-KEY
           MOVE WS-TRANSLATION-NAME-TXT TO BIBLE-DATA-META-VALUE
           WRITE BIBLE-DATA-META-RECORD
           
           MOVE "META-FILE" TO BIBLE-DATA-META-KEY
           MOVE WS-TRANSLATION-NAME-META TO BIBLE-DATA-META-VALUE
           WRITE BIBLE-DATA-META-RECORD
           
           MOVE "DATA-FILE" TO BIBLE-DATA-META-KEY
           MOVE WS-TRANSLATION-NAME-DATA TO BIBLE-DATA-META-VALUE
           WRITE BIBLE-DATA-META-RECORD

           PERFORM RUNBIBLETEXTFILE

           CLOSE BIBLE-TEXT-FILE
           CLOSE BIBLE-DATA-FILE
           CLOSE BIBLE-DATA-META
           EXIT PROGRAM.
       SQLITETODATAFILE-EXIT.

       RUNBIBLETEXTFILE.
           MOVE "N" TO WS-BIBLE-META-WRITTEN
           MOVE "N" TO WS-BIBLE-TEXT-EOF
           PERFORM UNTIL WS-BIBLE-TEXT-EOF = "Y"
               READ BIBLE-TEXT-FILE
                   AT END
                       MOVE "Y" TO WS-BIBLE-TEXT-EOF
                   NOT AT END
                       PERFORM ROWBIBLETEXTFILE
           END-PERFORM
           CONTINUE.
       RUNBIBLETEXTFILE-EXIT.

       ROWBIBLETEXTFILE.
           UNSTRING BIBLE-TEXT-RECORD
               DELIMITED BY "###" INTO
                 WS-BIBLE-TEXT-LANGUAGE,
                 WS-BIBLE-TEXT-TRANSLATION,
                 WS-BIBLE-TEXT-BOOK,
                 WS-BIBLE-TEXT-CHAPTER,
                 WS-BIBLE-TEXT-VERSE,
                 WS-BIBLE-TEXT-TEXT
           IF WS-BIBLE-META-WRITTEN = "N"
             MOVE "LANG" TO BIBLE-DATA-META-KEY
             MOVE WS-BIBLE-TEXT-LANGUAGE TO BIBLE-DATA-META-VALUE
             WRITE BIBLE-DATA-META-RECORD

             MOVE "TRANSLATION" TO BIBLE-DATA-META-KEY
             MOVE WS-BIBLE-TEXT-TRANSLATION TO BIBLE-DATA-META-VALUE
             WRITE BIBLE-DATA-META-RECORD
             
             MOVE "Y" TO WS-BIBLE-META-WRITTEN
           END-IF

           MOVE WS-BIBLE-TEXT-BOOK TO BIBLE-DATA-BOOK
           MOVE WS-BIBLE-TEXT-CHAPTER TO BIBLE-DATA-CHAPTER
           MOVE WS-BIBLE-TEXT-VERSE TO BIBLE-DATA-VERSE
           MOVE WS-BIBLE-TEXT-TEXT TO BIBLE-DATA-TEXT
           WRITE BIBLE-DATA-RECORD INVALID KEY
             DISPLAY FUNCTION concatenate(
             "DUPLICATE",
             FUNCTION trim(WS-BIBLE-TEXT-BOOK),
             FUNCTION trim(WS-BIBLE-TEXT-CHAPTER),
             FUNCTION trim(WS-BIBLE-TEXT-VERSE),
             FUNCTION trim(WS-BIBLE-TEXT-TEXT),
               ).

           CONTINUE.
       ROWBIBLETEXTFILE-EXIT.
           END PROGRAM sqliteToDatafile.
