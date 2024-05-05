       IDENTIFICATION DIVISION.
         PROGRAM-ID. importTranslation.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BibleTranslations ASSIGN TO "translations.tmp"
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.
           SELECT MetaFile ASSIGN TO WS-META-FILE
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD BibleTranslations.
       01 BibleTranslationRecord PIC X(777).
       FD MetaFile.
       01 MetaFileRecord PIC X(777).
       WORKING-STORAGE SECTION.
       01 WS-STATE           PIC 99 VALUE 0.
         88 WS-STATE-LIST-LANGUAGES VALUE 1.
         88 WS-STATE-LIST-TRANSLATIONS VALUE 2.
         88 WS-STATE-SHOW-DETAILS VALUE 3.
       01 WS-USERNAME        PIC X(30) VALUE SPACE.
       01 WS-INPUT           PIC 99.
       01 WS-STRING-INPUT    PIC X(100) VALUE SPACES.
       01 WS-OUTPUT          PIC X(100) VALUE SPACES.
       01 WS-FILE-EOF        PIC X VALUE "N".
       01 WS-LAST-LANGUAGE   PIC X(50).
       01 WS-RECORD-LANGUAGE PIC X(50).
       01 WS-RECORD-TITLE    PIC X(250).
       01 WS-RECORD-URL      PIC X(250).
       01 WS-RECORD-FILENAME PIC X(100).
       01 WS-META-FILE       PIC X(100).
       01 WS-DATABASE-PATH   PIC X(250).
       LINKAGE SECTION.
       01 WS-SELECTED-LANGUAGE PIC X(50).
       01 WS-SELECTED-TITLE    PIC X(250).
       01 WS-SELECTED-URL      PIC X(250).
       01 WS-SELECTED-FILENAME PIC X(100).
         
       PROCEDURE DIVISION USING
         WS-SELECTED-LANGUAGE,
         WS-SELECTED-TITLE,
         WS-SELECTED-URL,
         WS-SELECTED-FILENAME.
       IMPORTTRANSLATIONS.
           MOVE "translation.meta.tmp" TO WS-META-FILE

           PERFORM LISTTRANSLATIONS
           EXIT PROGRAM.
       IMPORTTRANSLATIONS-EXIT.

       LISTTRANSLATIONS.
           CALL "SYSTEM"
             USING "python scripts/mysword.py -l > translations.tmp"

           SET WS-STATE-LIST-LANGUAGES TO TRUE
           PERFORM RUNLISTTRANSLATIONS

           DISPLAY SPACE
           DISPLAY "Waehle Sprache: " WITH NO ADVANCING
           ACCEPT WS-STRING-INPUT

           SET WS-STATE-LIST-TRANSLATIONS TO TRUE
           PERFORM RUNLISTTRANSLATIONS

           DISPLAY SPACE
           DISPLAY "Waehle Uebersetzung: " WITH NO ADVANCING
           ACCEPT WS-STRING-INPUT

           SET WS-STATE-SHOW-DETAILS TO TRUE
           PERFORM RUNLISTTRANSLATIONS

           DISPLAY WS-STRING-INPUT
           CALL "SYSTEM"
             USING FUNCTION concatenate(
               'python scripts/mysword.py -d ',
               WS-SELECTED-FILENAME,
               " > ",
               WS-META-FILE
             )
            
           DISPLAY "META-FILE: " WS-META-FILE
           PERFORM GETDATABASEPATH
           DISPLAY "DATABASE-PATH: " WS-DATABASE-PATH

           CALL "lib/sqliteToDatafile"
             USING WS-SELECTED-FILENAME, WS-DATABASE-PATH,
             WS-SELECTED-TITLE.

           CONTINUE.
       LISTTRANSLATINOS-EXIT.

       RUNLISTTRANSLATIONS.
           DISPLAY SPACE
           DISPLAY SPACE
           DISPLAY SPACE
           OPEN INPUT BIBLETRANSLATIONS
           MOVE "N" TO WS-FILE-EOF
           PERFORM UNTIL WS-FILE-EOF = "Y"
             READ BibleTranslations
               AT END MOVE "Y" TO WS-FILE-EOF
               NOT AT END
                 UNSTRING BIBLETRANSLATIONRECORD
                   DELIMITED BY "###" INTO
                       WS-RECORD-LANGUAGE
                       WS-RECORD-TITLE
                       WS-RECORD-URL
                       WS-RECORD-FILENAME
                   IF WS-STATE-LIST-LANGUAGES
                     IF WS-RECORD-LANGUAGE NOT = WS-LAST-LANGUAGE
                        DISPLAY WS-RECORD-LANGUAGE
                     END-IF
                     MOVE WS-RECORD-LANGUAGE TO WS-LAST-LANGUAGE
                   END-IF

                   IF WS-STATE-LIST-TRANSLATIONS
                     IF WS-RECORD-LANGUAGE = WS-STRING-INPUT
                       UNSTRING WS-RECORD-FILENAME
                         DELIMITED BY "." INTO
                           WS-OUTPUT
                       DISPLAY FUNCTION trim(WS-OUTPUT)
                       DISPLAY FUNCTION trim(WS-RECORD-TITLE)
                     END-IF
                   END-IF

                   IF WS-STATE-SHOW-DETAILS
                     UNSTRING WS-RECORD-FILENAME
                       DELIMITED BY "." INTO
                         WS-OUTPUT
                     IF WS-OUTPUT = WS-STRING-INPUT
                       MOVE FUNCTION trim(WS-RECORD-LANGUAGE)
                          TO WS-SELECTED-LANGUAGE
                       MOVE FUNCTION trim(WS-RECORD-TITLE)
                          TO WS-SELECTED-TITLE
                       MOVE FUNCTION trim(WS-RECORD-URL)
                          TO WS-SELECTED-URL
                       MOVE FUNCTION trim(WS-RECORD-FILENAME)
                          TO WS-SELECTED-FILENAME
                     END-IF
                   END-IF
           END-PERFORM
           CLOSE BIBLETRANSLATIONS
           CONTINUE.

       GETDATABASEPATH.
           OPEN INPUT MetaFile
           MOVE "N" TO WS-FILE-EOF
           PERFORM UNTIL WS-FILE-EOF = "Y"
               READ MetaFile
                   AT END MOVE "Y" TO WS-FILE-EOF
                   NOT AT END
                       UNSTRING MetaFileRecord
                           DELIMITED BY "###" INTO
                               WS-RECORD-LANGUAGE
                               WS-RECORD-TITLE
                               WS-RECORD-URL
                               WS-RECORD-FILENAME
                               WS-DATABASE-PATH
           END-PERFORM
           CLOSE MetaFile
           CONTINUE.
