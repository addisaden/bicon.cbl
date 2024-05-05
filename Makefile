default: search
# default: sqliteToDatafile importTranslation listTranslations search

search:
	cobc -x -o bin/search.bin src/search.cbl

# importTranslation: sqliteToDatafile
# 	cobc -m -o lib/importTranslation.dylib src/importTranslation.cbl
# 
# listTranslations:
# 	cobc -m -o lib/listTranslations.dylib src/listTranslations.cbl
# 
# sqliteToDatafile:
# 	cobc -m -o lib/sqliteToDatafile.dylib src/sqliteToDatafile.cbl
