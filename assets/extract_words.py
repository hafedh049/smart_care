import os
import re
from json import dump

dir_path = './lib/'
keyword = '(text|labelText|description|speciality|name|return):? [\'"]'
pattern = re.compile(f'{keyword}(.*?)[\'"]')

translations :dict = {}
counted_false:int = 0

for root, dirs, files in os.walk(dir_path):
    for filename in files:
        if filename.endswith('.dart'):
            file_path = os.path.join(root, filename)
            with open(file_path, 'r') as f:
                for line in f:
                    match = re.search(pattern, line)
                    if match:
                        extracted_text = match.group(2)
                        key = extracted_text
                        while True:
                            key = re.sub(r"[^a-zA-Z]","",key)
                            if not bool(re.findall(r"\.\$\(\) \{\}\:",key)): break
                        if key and all([True if not item in extracted_text else False for item in "$(){}:"]):
                            key = key[0].lower() + key[1:]
                            translations.update({key:extracted_text})
                            translations.update({"@"+key:{"description":extracted_text}})
                        else:
                            counted_false += 1
                            print(False,extracted_text)

print(counted_false)

with open("./assets/translations.json","w") as traslations_file:
    dump(translations,traslations_file)
