default: sqliteToDatafile importTranslation search

search: importTranslation sqliteToDatafile
	cobc -x -o bin/search.bin src/search.cbl

importTranslation: sqliteToDatafile
	cobc -m -o lib/importTranslation.dylib src/importTranslation.cbl

sqliteToDatafile:
	cobc -m -o lib/sqliteToDatafile.dylib src/sqliteToDatafile.cbl