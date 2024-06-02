       IDENTIFICATION DIVISION.
       PROGRAM-ID. tokenSplitter.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      * wordlist.data random
      * wordlist.meta random
      * textsplit     random
       DATA DIVISION.
       FILE SECTION.
      * definition of files
       WORKING-STORAGE SECTION.
      * internal variables
       01 WS-WORDLIST-META      PIC X(43).
       01 WS-WORDLIST-FILE      PIC X(43).
       01 WS-POSITION           PIC 9(12) VALUE 1.
       01 WS-WORD-START         PIC 9(12) VALUE 1.
       01 WS-WORD-END           PIC 9(12) VALUE 1.
       01 WS-CHAR               PIC X.
       01 WS-WORD-STATUS        PIC 9.
       01 WS-CALC               PIC 9(12).
       LINKAGE SECTION.
      * external variables
      *
      *********************************
      * OPERATINO-MODES:              *
      *                               *
      * CWLO  - Create Wordlist only  *
      * CWLTS - Create Wordlist and   *
      *         Textsplit             *
      * CTSO  - Create Textsplit only *
      *********************************
       01 OPERATION-MODE          PIC X(5).
       01 WORDLIST-NAME           PIC X(32).
       01 TEXTSPLIT-NAME          PIC X(32).
       01 TEXT-LENGTH             PIC 9(12).
       01 TEXT-OFFSET             PIC 9(12).
       01 TEXT-CONTENT            PIC X(MAX-TEXT-CONTENT).
       PROCEDURE DIVISION USING
           OPERATION-MODE,
           WORDLIST-NAME,
           TEXTSPLIT-NAME,
           TEXT-LENGTH,
           TEXT-OFFSET,
           TEXT-CONTENT.
           PERFORM FILLFILENAMES.
           DISPLAY OPERATION-MODE.
           DISPLAY FUNCTION trim(WS-WORDLIST-META).
           DISPLAY FUNCTION trim(WS-WORDLIST-FILE).
           DISPLAY FUNCTION trim(TEXTSPLIT-NAME).
           DISPLAY TEXT-LENGTH.
           DISPLAY TEXT-OFFSET.
           DISPLAY FUNCTION trim(TEXT-CONTENT).
           PERFORM RUNWORDS.
           EXIT PROGRAM.
       
       RUNWORDS.
           IF WS-POSITION > TEXT-LENGTH
               EXIT PARAGRAPH
           END-IF
           PERFORM FIND-WORD.
           PERFORM PROCESS-WORD.
           IF WS-WORD-STATUS = "X"
               EXIT PARAGRAPH
           END-IF
           GO TO RUNWORDS.
       RUNWORDS-EXIT.
       
       FILLFILENAMES.
           MOVE
               function concatenate(
                   function trim(WORDLIST-NAME),
                   ".words.meta"
               )
               TO WS-WORDLIST-META

           MOVE
               function concatenate(
                   function trim(WORDLIST-NAME),
                   ".words.data"
               )
               TO WS-WORDLIST-FILE
           EXIT PARAGRAPH.
       FILLFILENAMES-EXIT.

       FIND-WORD.
           IF WS-POSITION = 0
               MOVE "W" TO WS-WORD-STATUS
           END-IF
           MOVE TEXT-CONTENT(WS-POSITION:1) TO WS-CHAR

      * just inspect the character
      *    DISPLAY "> " WITH NO ADVANCING
      *    DISPLAY WS-CHAR

           IF WS-CHAR = SPACE
               MOVE "S" TO WS-WORD-STATUS
           ELSE
               MOVE "W" TO WS-WORD-STATUS
               MOVE WS-POSITION TO WS-WORD-END
           END-IF

           ADD 1 TO WS-POSITION.
           IF WS-POSITION > TEXT-LENGTH
               MOVE "X" TO WS-WORD-STATUS
               EXIT PARAGRAPH
           ELSE
               IF WS-WORD-STATUS = "W"
      *           GO TO instead of PERFORM to avoid stack overflow
                  GO TO FIND-WORD
               END-IF
               IF WS-WORD-STATUS = "S"
                  EXIT PARAGRAPH
               END-IF
           END-IF
           EXIT PARAGRAPH.
       FIND-WORD-EXIT.

       PROCESS-WORD.
           SUBTRACT WS-WORD-START FROM WS-WORD-END GIVING WS-CALC
           IF WS-CALC = 0
               EXIT PARAGRAPH
           END-IF

           ADD 1 TO WS-CALC

           DISPLAY WS-WORD-START
           DISPLAY WS-WORD-END
           DISPLAY TEXT-CONTENT(WS-WORD-START:WS-CALC)

           MOVE WS-POSITION TO WS-WORD-START
           MOVE WS-POSITION TO WS-WORD-END

           EXIT PARAGRAPH.
       PROCESS-WORD-EXIT.

           END PROGRAM tokenSplitter.
