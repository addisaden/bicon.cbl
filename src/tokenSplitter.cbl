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
           EXIT PROGRAM.
       
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
           CONTINUE.
       FILLFILENAMES-EXIT.

           END PROGRAM tokenSplitter.
