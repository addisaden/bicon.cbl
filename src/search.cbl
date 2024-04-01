      * Search in a bible translation for specific words
       IDENTIFICATION DIVISION.
           PROGRAM-ID. SEARCHENGINE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-USERNAME       PIC X(30) VALUE SPACE.
       01 WS-INPUT          PIC 99.
       01 WS-OUTPUT         PIC X(100) VALUE SPACE.
       PROCEDURE DIVISION.
       SEARCHENGINE.
           CALL "SYSTEM" USING "clear"
           DISPLAY "Wie ist dein Name? " WITH NO ADVANCING.
           ACCEPT WS-USERNAME
           CALL "SYSTEM" USING "clear"
           STRING "Hallo, " DELIMITED BY SIZE
               WS-USERNAME DELIMITED BY SPACE
               "!" DELIMITED BY SIZE
               INTO WS-OUTPUT
           DISPLAY WS-OUTPUT
           PERFORM UNTIL WS-INPUT = 77
               DISPLAY SPACE
               DISPLAY " 1: Durchsuche die Bibel"
               DISPLAY " 2: Liste der verfügbaren Bibelübersetzungen"
               DISPLAY " 3: Importiere eine Bibelübersetzung"
               DISPLAY "77: Beenden"
               DISPLAY SPACE
               DISPLAY ": " WITH NO ADVANCING
               ACCEPT WS-INPUT
               EVALUATE TRUE
                   WHEN WS-INPUT = 01
                       DISPLAY "NOT IMPLEMENTED YET"
                   WHEN WS-INPUT = 02
                       CALL "SYSTEM"
                           USING "python scripts/mysword.py --list"
                   WHEN WS-INPUT = 03
                       DISPLAY "NOT IMPLEMENTED YET"
                   WHEN TRUE
                       DISPLAY "??"
                       DISPLAY WS-INPUT
               END-EVALUATE
           END-PERFORM
           CONTINUE.
       SEARCHENGINE-EXIT.
