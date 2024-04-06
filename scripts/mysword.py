from myswordapi import MySwordAPI
from argparse import ArgumentParser
from os.path import exists as file_exists

def get_mysword_bibles():
    tmp_list_file = ".mysword.tmp"

    html_data = None

    if file_exists(tmp_list_file):
        with open(tmp_list_file, "r") as f:
            html_data = f.read()

    bibles, html_data = MySwordAPI.get_mysword_bibles(html_data)

    if not file_exists(tmp_list_file):
        with open(tmp_list_file, "w") as f:
            f.write(html_data)
    
    return bibles

def main():
    parser = ArgumentParser(description="Download MySword Bibles")
    parser.add_argument("-l", "--list", help="List all available Bibles", action="store_true")
    parser.add_argument("-d", "--download", nargs=1, help="Download a specific Bible")
    parser.add_argument("-p", "--parse", nargs=1, help="Parse SQLite bible database to text file")
    args = parser.parse_args()

    tmp_list_file = ".mysword.tmp"
    
    if args.list:
        bibles = get_mysword_bibles()

        for bible in bibles:
            print(f"{bible['language']}###{bible['title']}###{bible['url']}###{bible['filename']}")

    elif args.download:
        selected_bible = args.download[0].lower()

        bibles = get_mysword_bibles()

        bible_meta = {}

        for bible in bibles:
            match_in_filename = bible["filename"].lower().find(selected_bible) >= 0
            match_in_url = bible["url"].lower().find(selected_bible) >= 0
            match_in_title = bible["title"].lower().find(selected_bible) >= 0
            if match_in_filename or match_in_url or match_in_title:
                tmp_path = MySwordAPI.download_mysword_bible(bible["url"], bible["filename"])
                result = []
                result.append(bible["language"])
                result.append(bible["title"])
                result.append(bible["url"])
                result.append(bible["filename"])
                result.append(tmp_path)
                print("###".join(result))
                break
    
    elif args.parse:
        file_to_parse = args.parse[0]

        bible_meta_object = {}

        bibles = get_mysword_bibles()
        for bible in bibles:
            if file_to_parse.lower().find(bible["filename"].lower()) >= 0:
                bible_meta_object = bible
                break
        
        for bible_meta, text in MySwordAPI.import_mysword_bible(bible_meta_object, file_to_parse):
            row = []
            row.append(bible_meta["language"])
            row.append(bible_meta["short"])
            row.append(text["book"])
            row.append(text["chapter"])
            row.append(text["verse"])
            row.append(text["text"])
            print("###".join(map(str, row)))

if __name__ == "__main__":
    main()