from myswordapi import MySwordAPI
from argparse import ArgumentParser
from os.path import exists as file_exists

def main():
    parser = ArgumentParser(description="Download MySword Bibles")
    parser.add_argument("-l", "--list", help="List all available Bibles", action="store_true")
    parser.add_argument("-d", "--download", nargs=1, help="Download a specific Bible")
    args = parser.parse_args()

    tmp_list_file = ".mysword.tmp"
    
    if args.download:
        print("Downloading Bible...")
    elif args.list:
        html_data = None
        if file_exists(tmp_list_file):
            with open(tmp_list_file, "r") as f:
                html_data = f.read()
        bibles, html_data = MySwordAPI.get_mysword_bibles(html_data)
        if not file_exists(tmp_list_file):
            with open(tmp_list_file, "w") as f:
                f.write(html_data)
        for bible in bibles:
            print(f"{bible['language']}###{bible['title']}")


if __name__ == "__main__":
    main()