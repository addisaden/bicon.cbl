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
       01 WS-TEXTSPLIT-NAME     PIC X(32).
       01 WS-WORDLIST-META      PIC X(42).
       01 WS-WORDLIST-FILE      PIC X(42).
       01 WS-WORDLIST-LASTINDEX PIC 9(7).
       01 WS-BIBLE-DATA-FILE    PIC X(42).
       01 WS-BIBLE-SHORT        PIC X(32).
       01 WS-RETURN             PIC 9(3).
       01 WS-TEXT               PIC X(1000000).
       PROCEDURE DIVISION.
           DISPLAY "Create a new wordlist."
      * Get Wordlist name
           PERFORM selectfile
      * choose tokensplitter
      * loop #bibleshort#
      * -- ask for bibleshort name
      * -- open file (read sequentialle)
      * -- split words with chosen tokensplitter
      * -- search them in the file
      * -- -- if exists: count +1
      * -- -- else: create new entry
           MOVE "TEST Textsplit" TO WS-TEXTSPLIT-NAME.
           MOVE "Hallo Welt" TO WS-TEXT.
           CALL "tokenSplitter" USING
             "CWLO ", WS-WORDLIST-NAME, WS-TEXTSPLIT-NAME,
             10, 0, WS-TEXT END-CALL
           EXIT PROGRAM.

       selectfile.
           DISPLAY "Name: " WITH NO ADVANCING.

           ACCEPT WS-WORDLIST-NAME.

           MOVE function concatenate(
           function trim(WS-WORDLIST-NAME),
           ".words.meta"
           ) TO WS-WORDLIST-META.
           DISPLAY "Meta: " WITH NO ADVANCING.
           DISPLAY WS-WORDLIST-META.

           MOVE function concatenate(
           function trim(WS-WORDLIST-NAME),
           ".words.data"
           ) TO WS-WORDLIST-FILE.
           DISPLAY "Data: " WITH NO ADVANCING.
           DISPLAY WS-WORDLIST-FILE.

      * check if wordlist exists and ask if it should be recreated
           CALL "SYSTEM"
           USING function concatenate("file -E ", WS-WORDLIST-FILE)
           GIVING WS-RETURN
           END-CALL
           IF WS-RETURN = 0
               DISPLAY SPACE
               DISPLAY "File EXISTS."
               DISPLAY "Overwrite?"
               DISPLAY "1: yes, 2: no. choose: " WITH NO ADVANCING
               ACCEPT WS-RETURN
               IF WS-RETURN not = 1
                   DISPLAY "Choose another name."
                   GO TO selectfile
               END-IF
           END-IF
           CONTINUE.
       selectfile-exit.
       END PROGRAM createWordlist.
