search: importTranslation
	cobc -x -o bin/search.bin src/search.cbl

importTranslation:
	cobc -m -o lib/importTranslation.dylib src/importTranslation.cbl