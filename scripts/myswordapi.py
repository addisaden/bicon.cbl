import requests
import bs4
import urllib3
import subprocess
import sqlite3
import os.path

class MySwordAPI:
    @staticmethod
    def get_mysword_bibles(html_data=None):
        if html_data is None:
            html_data = requests.get("https://www.mysword.info/download-mysword/bibles")
            if not html_data.ok:
                return [], "<html><body><h1>Download failed</h1></body></html>"
            html_data = html_data.text
        
        bibles = []

        content = bs4.BeautifulSoup(html_data, 'html.parser')
        try:
            table = content.css.select("table#download")[0]
        except IndexError:
            return bibles, html_data
        current_language = ""
        for row in table.children:
            if row.css.select("td.langhead>h3"):
                current_language = row.text.split(":")[1].strip()
            elif len(row.css.select("td")) == 5:
                row_data = row.css.select("td")
                row_index = row_data[0].text
                url = row_data[1].a.get("href")
                url_parsed = urllib3.util.parse_url(url)
                title = row_data[1].text
                data_size = row_data[2].text
                data_size_unzipped = row_data[3].text
                last_update = row_data[4].text
                obj = {
                    "language": current_language.split()[0],
                    "index": row_index,
                    "url": url,
                    "title": title,
                    "size": data_size,
                    "size_unzipped": data_size_unzipped,
                    "last_update": last_update,
                    "filename": url_parsed.query.split("=")[1],
                }
                bibles.append(obj)

        return bibles, html_data
    
    @staticmethod
    def download_mysword_bible(url, filename):
        if not (os.path.exists("/tmp/" + filename) or os.path.exists("/tmp/" + filename[:-3]) or os.path.exists("/tmp/" + filename[:-4])):
            with requests.get(url, stream=True) as r:
                r.raise_for_status()
                with open("/tmp/" + filename, "wb") as f:
                    for chunk in r.iter_content(chunk_size=8192):
                        f.write(chunk)
            if filename.find(".gz") != -1:
                unzip_feedback = subprocess.run(["gunzip", "/tmp/" + filename])
                if unzip_feedback.returncode != 0:
                    return "/tmp/" + filename
                else:
                    return "/tmp/" + filename[:-3]
            elif filename.find(".zip") != -1:
                filename_list = subprocess.run(["zip", "-sf", "/tmp/" + filename], capture_output=True, text=True)
                unzip_feedback = subprocess.run(["unzip", "-o", "/tmp/" + filename, "-d", "/tmp/"])
                if unzip_feedback.returncode != 0:
                    return "/tmp/" + filename
                else:
                    for line in filename_list.stdout.split("\n"):
                        if line.find("Archive") != -1:
                            continue
                        if line.find("Name") != -1:
                            continue
                        if line.find("----") != -1:
                            continue
                        if line.find(".bbl.mybible") != -1:
                            return "/tmp/" + line.strip()
                    return "/tmp/" + filename[:-4]
        return "/tmp/" + filename
    
    @staticmethod
    def import_mysword_bible(bible_obj, bible_path):
        md5_key = subprocess.run(["md5sum", bible_path], capture_output=True, text=True).stdout.split()[0]
        short_name_left = bible_obj["title"].find("[")
        short_name_right = bible_obj["title"].find("]")
        if short_name_left == -1 or short_name_right == -1:
            short_name = bible_obj["title"]
        else:
            short_name = bible_obj["title"][short_name_left+1:short_name_right]
        
        bible_meta = {
            "name": bible_obj["title"],
            "short": short_name,
            "language": bible_obj["language"],
            "filename": bible_obj["filename"],
            "url": bible_obj["url"],
            "md5key": md5_key,
        }

        # sqlite3
        # CREATE TABLE IF NOT EXISTS "Bible" ("Book" INT,"Chapter" INT,"Verse" INT,"Scripture" TEXT);
        con = sqlite3.connect(bible_path)
        cur = con.cursor()
        sel_str = "SELECT Book, Chapter, Verse, Scripture FROM Bible"
        for book, chapter, verse, scripture in cur.execute(sel_str):
            text = {
                "book": book,
                "chapter": chapter,
                "verse": verse,
                "text": scripture,
            }
            yield(bible_meta, text)
        con.close()