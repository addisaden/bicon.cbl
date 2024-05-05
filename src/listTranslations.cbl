       IDENTIFICATION DIVISION.
         PROGRAM-ID. listTranslations.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BIBLE-DATA-META ASSIGN TO WS-META-FILE
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS BIBLE-DATA-META-KEY.
           SELECT MetaList ASSIGN TO "bibles.meta"
               ORGANIZATION IS LINE SEQUENTIAL
               ACCESS MODE IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD BIBLE-DATA-META.
       01 BIBLE-DATA-META-RECORD.
           05 BIBLE-DATA-META-KEY    PIC X(12).
           05 BIBLE-DATA-META-VALUE  PIC X(250).
       FD MetaList.
       01 MetaListRecord PIC X(777).
       WORKING-STORAGE SECTION.
       01 WS-META-FILE    PIC X(100).
       01 LIST-DATA-EOF  PIC X VALUE 'N'.
       01 META-RECORD-EOF PIC X VALUE 'N'.
       LINKAGE SECTION.
       PROCEDURE DIVISION.
      *
      * Search for all files *.bible.meta
      * list the code, language and title
      *
           CALL "system"
               USING "ls *.bible.meta > bibles.meta"
           END-CALL

           OPEN INPUT MetaList
           MOVE "N" TO LIST-DATA-EOF
           PERFORM UNTIL LIST-DATA-EOF = 'Y'
               READ MetaList
                   AT END
                       MOVE 'Y' TO LIST-DATA-EOF
                   NOT AT END
                      MOVE FUNCTION trim(MetaListRecord)
                          TO WS-META-FILE
                       PERFORM SHOW-META-RECORD
               END-READ
           END-PERFORM           
           CLOSE MetaList

           EXIT PROGRAM.

       SHOW-META-RECORD.
           DISPLAY " "
           OPEN INPUT BIBLE-DATA-META
      * EACH LINE
           MOVE "N" TO META-RECORD-EOF
           PERFORM UNTIL META-RECORD-EOF = 'Y'
               READ BIBLE-DATA-META
                  AT END
                       MOVE 'Y' TO META-RECORD-EOF
                  NOT AT END
                       DISPLAY FUNCTION concatenate(
                           FUNCTION trim(BIBLE-DATA-META-KEY),
                           ": ",
                           FUNCTION trim(BIBLE-DATA-META-VALUE)
                       )
               END-READ
           END-PERFORM
           CLOSE BIBLE-DATA-META
           DISPLAY " "

           CONTINUE.

