      * Search in a bible translation for specific words
       IDENTIFICATION DIVISION.
           PROGRAM-ID. SEARCHENGINE.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-USERNAME       PIC X(30) VALUE SPACE.
       01 WS-OUTPUT         PIC X(100) VALUE SPACE.
       PROCEDURE DIVISION.
       SEARCHENGINE.
           CALL "SYSTEM" USING "clear"
           DISPLAY "Wie ist dein Name? " WITH NO ADVANCING.
           ACCEPT WS-USERNAME
           STRING "Hallo, " DELIMITED BY SIZE
               WS-USERNAME DELIMITED BY SPACE
               "!" DELIMITED BY SIZE
               INTO WS-OUTPUT
           DISPLAY WS-OUTPUT
           CALL "SYSTEM" USING "echo 'Hallo'"
           CONTINUE.
       SEARCHENGINE-EXIT.
