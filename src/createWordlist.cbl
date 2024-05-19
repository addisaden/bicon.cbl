       IDENTIFICATION DIVISION.
       PROGRAM-ID. createWordlist.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BIBLE-DATA-FILE ASSIGN TO WS-BIBLE-DATA-FILE
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BIBLE-DATA-ID.

       DATA DIVISION.
       FILE SECTION.
           COPY 'cpy/file-section/bible-data-file'.
       WORKING-STORAGE SECTION.
       01 WS-WORDLIST-NAME      PIC X(32).
       01 WS-WORDLIST-META      PIC X(42).
       01 WS-WORDLIST-FILE      PIC X(42).
       01 WS-WORDLIST-LASTINDEX PIC 9(7).
       01 WS-BIBLE-DATA-FILE    PIC X(42).
       01 WS-BIBLE-SHORT        PIC X(32).
       PROCEDURE DIVISION.
       EXIT PROGRAM.
           DISPLAY "Create a new wordlist."
      * Get Wordlist name
      * check if wordlist exists and ask if it should be recreated
      * choose tokensplitter
      * loop #bibleshort#
      * -- ask for bibleshort name
      * -- open file (read sequentialle)
      * -- split words with chosen tokensplitter
      * -- search them in the file
      * -- -- if exists: count +1
      * -- -- else: create new entry
       END PROGRAM createWordlist.
