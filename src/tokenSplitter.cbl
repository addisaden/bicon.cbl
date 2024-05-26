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
       01 OPERATION-MODE          PIC XXXXX.
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
           DISPLAY OPERATION-MODE.
           DISPLAY WORDLIST-NAME.
           DISPLAY TEXTSPLIT-NAME.
           EXIT PROGRAM.
           END PROGRAM tokenSplitter.
