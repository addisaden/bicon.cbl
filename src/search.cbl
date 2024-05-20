      * Search in a bible translation for specific words
       IDENTIFICATION DIVISION.
           PROGRAM-ID. SEARCHENGINE.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
       01 WS-INPUT           PIC 99.
       01 WS-STRING-INPUT    PIC X(100) VALUE SPACES.
       01 WS-OUTPUT          PIC X(100) VALUE SPACES.
       01 WS-SELECTED-LANGUAGE PIC X(50).
       01 WS-SELECTED-TITLE    PIC X(250).
       01 WS-SELECTED-URL      PIC X(250).
       01 WS-SELECTED-FILENAME PIC X(100).
       PROCEDURE DIVISION.
      *SEARCHENGINE.
           CALL "SYSTEM" USING "clear"
           PERFORM UNTIL WS-INPUT = 77
               DISPLAY SPACE
               DISPLAY " 1: Durchsuche die Bibel"
               DISPLAY " 2: Liste der verfügbaren Bibelübersetzungen"
               DISPLAY " 3: Importiere eine Bibelübersetzung"
               DISPLAY SPACE
               DISPLAY " 4: Erstelle Wortliste (Tokenizer)"
               DISPLAY SPACE
               DISPLAY "77: Beenden"
               DISPLAY SPACE
               DISPLAY ": " WITH NO ADVANCING
               ACCEPT WS-INPUT
               EVALUATE TRUE
                   WHEN WS-INPUT = 01
                       CALL 'readTranslation'
                   WHEN WS-INPUT = 02
                       CALL "listTranslations"
                   WHEN WS-INPUT = 03
                       CALL "importTranslation" USING
                         WS-SELECTED-LANGUAGE,
                         WS-SELECTED-TITLE,
                         WS-SELECTED-URL,
                         WS-SELECTED-FILENAME
                   WHEN WS-INPUT = 04
                       CALL "createWordlist"
                   WHEN TRUE
                       DISPLAY "??"
                       DISPLAY WS-INPUT
               END-EVALUATE
           END-PERFORM
           CONTINUE.
      *SEARCHENGINE-EXIT.
           STOP RUN.

           END PROGRAM SEARCHENGINE.

           COPY 'src/readTranslation'.
           COPY 'src/listTranslations'.
           COPY 'src/importTranslation'.
           COPY 'src/sqliteToDatafile'.

           COPY 'src/createWordlist.cbl'.
