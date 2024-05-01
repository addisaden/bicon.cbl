       IDENTIFICATION DIVISION.
         PROGRAM-ID. listTranslations.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MetaFile ASSIGN TO WS-META-FILE
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.
           SELECT MetaList ASSIGN TO "bibles.meta"
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD MetaFile.
       01 MetaFileRecord PIC X(777).
       01 META-DATA-EOF  PIC X VALUE 'N'.
       FD MetaList.
       01 MetaListRecord PIC X(777).
       01 LIST-DATA-EOF  PIC X VALUE 'N'.
       WORKING-STORAGE SECTION.
       01 WS-META-FILE    PIC X(100).
       LINKAGE SECTION.
       PROCEDURE DIVISION.
      *
      * Search for all files *.bible.meta
      * list the code, language and title
      *
           DISPLAY "Searching for bibles (Not implemented)"

           CALL "system"
               USING "ls *.bible.meta > bibles.meta"
           END-CALL

           OPEN INPUT MetaList
           PERFORM UNTIL LIST-DATA-EOF = 'Y'
               READ MetaList
                   AT END
                       MOVE 'Y' TO LIST-DATA-EOF
                   NOT AT END
                       DISPLAY FUNCTION trim(MetaListRecord)
               END-READ
           END-PERFORM           
           CLOSE MetaList

           EXIT PROGRAM.
