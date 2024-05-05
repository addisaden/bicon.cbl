       FD BIBLE-DATA-FILE.
       01 BIBLE-DATA-RECORD.
           05 BIBLE-DATA-ID.
               10 BIBLE-DATA-BOOK    PIC 9(3).
               10 BIBLE-DATA-CHAPTER PIC 9(3).
               10 BIBLE-DATA-VERSE   PIC 9(3).
           05 BIBLE-DATA-TEXT        PIC X(500).
           88 BIBLE-DATA-EOF         VALUE HIGH-VALUE.
