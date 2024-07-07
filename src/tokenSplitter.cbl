       IDENTIFICATION DIVISION.
       PROGRAM-ID. tokenSplitter.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      * wordlist.data random
           SELECT WORDLIST-FILE ASSIGN TO WS-WORDLIST-FILE
             ORGANIZATION IS INDEXED
             ACCESS MODE IS RANDOM
             RECORD KEY IS WORDLIST-WORD.
      * wordlist.meta random
           SELECT WORDLIST-META-FILE ASSIGN TO WS-WORDLIST-META
             ORGANIZATION IS INDEXED
             ACCESS MODE IS RANDOM
             RECORD KEY IS WORDLIST-META-KEY.
      * textsplit     random
       DATA DIVISION.
       FILE SECTION.
      * definition of files
       COPY 'cpy/file-section/wordlist-meta'.
       COPY 'cpy/file-section/wordlist-file'.
       WORKING-STORAGE SECTION.
      * internal variables
       01 WS-WORDLIST-META      PIC X(43).
       01 WS-WORDLIST-META-LAST-INDEX PIC X(250).
       01 WS-WORDLIST-META-WORDS PIC X(250).
       01 WS-WORDLIST-FILE      PIC X(43).
       01 WS-POSITION           PIC 9(12) VALUE 1.
       01 WS-WORD-START         PIC 9(12) VALUE 1.
       01 WS-WORD-END           PIC 9(12) VALUE 1.
       01 WS-WORDLIST-INDEX     PIC 9(7) VALUE 1.
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
         88 OM-ONLY-WORDLIST      VALUE "CWLO ".
         88 OM-WORDLIST-TEXTSPLIT VALUE "CWLTS".
         88 OM-ONLY-TEXTSPLIT     VALUE "CTSO ".
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
           PERFORM SUB-OPEN-WORDLIST.
           DISPLAY OPERATION-MODE.
           DISPLAY FUNCTION trim(WS-WORDLIST-META).
           DISPLAY FUNCTION trim(WS-WORDLIST-FILE).
           DISPLAY FUNCTION trim(TEXTSPLIT-NAME).
           DISPLAY TEXT-LENGTH.
           DISPLAY TEXT-OFFSET.
           DISPLAY FUNCTION trim(TEXT-CONTENT).
           PERFORM RUNWORDS.
           PERFORM SUB-CLOSE-WORDLIST.
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
      * WS-WORD-STATUS
      * W - Word
      * S - Space
      * X - End of text
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

           PERFORM PROCESS-WRITE-TO-WORDLIST

           MOVE WS-POSITION TO WS-WORD-START
           MOVE WS-POSITION TO WS-WORD-END

           EXIT PARAGRAPH.
       PROCESS-WORD-EXIT.

      * WRITE TO WORDLIST
      *********************************
      * OPERATINO-MODE's:             *
      *                               *
      * CWLO  - Create Wordlist only  *
      * CWLTS - Create Wordlist and   *
      *         Textsplit             *
      * CTSO  - Create Textsplit only *
      *********************************
       
       SUB-OPEN-WORDLIST.
           DISPLAY "START OPEN FILES"
           if not OM-ONLY-WORDLIST and not OM-WORDLIST-TEXTSPLIT
               EXIT PARAGRAPH
           end-if
           DISPLAY "OPEN FILES"
      * CRASHES HERE
      * MUST CREATE FILES FIRST IF THEY DO NOT EXISTS.
           OPEN i-o WORDLIST-FILE
           OPEN i-o WORDLIST-META-FILE
      * read the last index if it exists else set it to 1
           MOVE "LAST-INDEX" TO WORDLIST-META-KEY
           READ WORDLIST-META-FILE
             INVALID KEY
               MOVE 1 TO WS-WORDLIST-META-LAST-INDEX
             NOT INVALID KEY
               MOVE WORDLIST-META-VALUE TO WS-WORDLIST-META-LAST-INDEX
           END-READ
      * read WS-WORDLIST-META-WORDS from WORDLIST-META
           MOVE "WORDS" TO WORDLIST-META-KEY
           READ WORDLIST-META-FILE
             INVALID KEY
               MOVE 0 TO WS-WORDLIST-META-WORDS
             NOT INVALID KEY
               MOVE WORDLIST-META-VALUE TO WS-WORDLIST-META-WORDS
           END-READ
           EXIT PARAGRAPH.
       SUB-OPEN-WORDLIST-EXIT.

       SUB-CLOSE-WORDLIST.
           if not OM-ONLY-WORDLIST and not OM-WORDLIST-TEXTSPLIT
               EXIT PARAGRAPH
           end-if
      * write the last index to WORDLIST-META
           MOVE "LAST-INDEX" TO WORDLIST-META-KEY
           MOVE WS-WORDLIST-META-LAST-INDEX TO WORDLIST-META-VALUE
           WRITE WORDLIST-META-RECORD
      * write WS-WORDLIST-META-WORDS to WORDLIST-META
           MOVE "WORDS" TO WORDLIST-META-KEY
           MOVE WS-WORDLIST-META-WORDS TO WORDLIST-META-VALUE
           WRITE WORDLIST-META-RECORD

           CLOSE WORDLIST-FILE
           CLOSE WORDLIST-META-FILE
           EXIT PARAGRAPH.
       SUB-CLOSE-WORDLIST-EXIT.

       PROCESS-WRITE-TO-WORDLIST.
           DISPLAY "WRITE TO WORDLIST"
           if not OM-ONLY-WORDLIST and not OM-WORDLIST-TEXTSPLIT
               EXIT PARAGRAPH
           end-if
      * TODOS:
      * - define the wordlist format
      * - define the meta format
      * - write the wordlist
      * - write the meta
           EXIT PARAGRAPH.
       PROCESS-WRITE-TO-WORDLIST-EXIT.

           END PROGRAM tokenSplitter.
