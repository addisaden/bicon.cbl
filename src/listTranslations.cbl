       IDENTIFICATION DIVISION.
         PROGRAM-ID. listTranslations.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MetaFile ASSIGN TO WS-META-FILE
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD MetaFile.
       01 MetaFileRecord PIC X(777).
       WORKING-STORAGE SECTION.
       01 WS-META-FILE PIC X(100).
       LINKAGE SECTION.
       PROCEDURE DIVISION.
       SEARCH-META-FILES.
      * https://stackoverflow.com/questions/35879865/how-to-get-all-files-in-directory-in-cobol
      *
      * Search for all files *.bible.meta
      * list the code, language and title
      *
           DISPLAY "Searching for bibles (Not implemented)"
           EXIT PROGRAM.
       SEARCH-META-FILES-EXIT.
