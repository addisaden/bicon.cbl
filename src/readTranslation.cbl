       IDENTIFICATION DIVISION.
       PROGRAM-ID. readTranslation.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BIBLE-DATA-META ASSIGN TO WS-META-FILE
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BIBLE-DATA-META-KEY.
           SELECT BIBLE-DATA-FILE ASSIGN TO WS-DATA-FILE
               ORGANIZATION IS INDEXED
               ACCESS MODE IS RANDOM
               RECORD KEY IS BIBLE-DATA-ID.
       DATA DIVISION.
       FILE SECTION.
           COPY 'cpy/file-section/bible-data-meta'.
           COPY 'cpy/file-section/bible-data-file'.
       WORKING-STORAGE SECTION.
       01 WS-META-FILE          PIC X(777).
       01 WS-DATA-FILE          PIC X(777).
       01 WS-TEST-FILE          PIC X(777).
       01 WS-BIBLE-SHORT        PIC X(32).
       01 WS-RETURN             PIC 99.
      *LINKAGE SECTION.
       PROCEDURE DIVISION.
           DISPLAY "bible short? " END-DISPLAY
           ACCEPT WS-BIBLE-SHORT

           MOVE FUNCTION concatenate(
               FUNCTION trim(WS-BIBLE-SHORT),
               ".bible.meta",
           ) TO WS-META-FILE

           MOVE WS-META-FILE TO WS-TEST-FILE
           PERFORM testfile

           MOVE FUNCTION concatenate(
               FUNCTION trim(WS-BIBLE-SHORT),
               ".bible.data",
           ) TO WS-DATA-FILE

           MOVE WS-DATA-FILE TO WS-TEST-FILE
           PERFORM testfile

           OPEN i-o BIBLE-DATA-META.

           MOVE "LANG" TO BIBLE-DATA-META-KEY
           READ BIBLE-DATA-META END-READ
           DISPLAY FUNCTION trim(BIBLE-DATA-META-VALUE)

           MOVE "TITLE" TO BIBLE-DATA-META-KEY
           READ BIBLE-DATA-META END-READ
           DISPLAY FUNCTION trim(BIBLE-DATA-META-VALUE)

           CLOSE BIBLE-DATA-META.

           OPEN i-o BIBLE-DATA-FILE.

           PERFORM choose-book-and-chapter

           MOVE 1 TO BIBLE-DATA-VERSE
           MOVE 0 TO WS-RETURN
           PERFORM UNTIL WS-RETURN = 1
               READ BIBLE-DATA-FILE
                   INVALID KEY
                       MOVE 1 TO WS-RETURN
                   NOT INVALID KEY
                       DISPLAY FUNCTION concatenate(
                           BIBLE-DATA-VERSE, ": ",
                           FUNCTION trim(BIBLE-DATA-TEXT),
                       )
                       ADD 1 TO BIBLE-DATA-VERSE
               END-READ
           END-PERFORM

           CLOSE BIBLE-DATA-FILE.

           EXIT PROGRAM.

       testfile.
           CALL 'SYSTEM'
               USING
               FUNCTION CONCATENATE(
                   "test -f ",
                   WS-TEST-FILE,
               )
               RETURNING WS-RETURN
           END-CALL
           
           IF WS-RETURN NOT = 0
               DISPLAY "File does not exist for this short."
               EXIT PROGRAM
           END-IF

           CONTINUE.
       testfile-exit.

       choose-book-and-chapter.
           DISPLAY "OT"
           DISPLAY " 1 genesis        2 exodus          3 leviticus"
           DISPLAY " 4 numbers        5 deuteronomy     6 joshua"
           DISPLAY " 7 judges         8 ruth            9 i_samuel"
           DISPLAY "10 ii_samuel     11 i_kings        12 ii_kings"
           DISPLAY "13 i_chronicles  14 ii_chronicles  15 ezra"
           DISPLAY "16 nehemiah      17 esther         18 job"
           DISPLAY "19 psalms        20 proverbs       21 ecclesiastes"
           DISPLAY "22 song solomon  23 isaiah         24 jeremiah"
           DISPLAY "25 lamentations  26 ezekiel        27 daniel"
           DISPLAY "28 hosea         29 joel           30 amos"
           DISPLAY "31 obadiah       32 jonah          33 micah"
           DISPLAY "34 nahum         35 habakkuk       36 zephaniah"
           DISPLAY "37 haggai        38 zechariah      39 malachi"
           DISPLAY "NT"
           DISPLAY "40 matthew       41 mark           42 luke"
           DISPLAY "43 john          44 acts           45 romans"
           DISPLAY "46 i_corinthians 47 ii_corinthians 48 galatians"
           DISPLAY "49 ephesians     50 philippians    51 colossians"
           DISPLAY "52 i_thess       53 ii_thess       54 i_timothy"
           DISPLAY "55 ii_timothy    56 titus          57 philemon"
           DISPLAY "58 hebrews       59 james          60 i_peter"
           DISPLAY "61 ii_peter      62 i_john         63 ii_john"
           DISPLAY "64 iii_john      65 jude           66 revelation"

           DISPLAY "book"
           ACCEPT BIBLE-DATA-BOOK

           DISPLAY "chapter"
           ACCEPT BIBLE-DATA-CHAPTER

           CONTINUE.
       choose-book-and-chapter-exit.

           END PROGRAM readTranslation.

