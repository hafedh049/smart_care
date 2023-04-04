"""
from json import dump, load
from translate import Translator
from time import sleep

filepath = './lib/l10n/app_en.arb'
target_lang = [ 'zh', 'de', 'es', 'hi', 'ru'] #'fr', 'ar',

with open(filepath, 'r') as f:
    data = load(f)

for lang in target_lang:

    lang_counter = 0
    translated_data: dict = {}

    translator = Translator(to_lang=lang)

    for key, value in data.items():

        if '@' not in key:

            translation = translator.translate(value)
            translated_data[key] = translation
            lang_counter += 1
            print(lang_counter,lang,translation)

    with open(f"./lib/l10n/app_{lang}.arb","w") as lang_file:
        dump(translated_data, lang_file)
        sleep(60)
    
    print(lang,"file translation terminated")

print("task completed")"""


import requests
from json import dump, load
from time import sleep

filepath = './lib/l10n/app_en.arb'
target_lang = [  'de', 'es', 'hi', 'ru'] #'fr','ar','zh',

with open(filepath, 'r') as f:
    data = load(f)

for lang in target_lang:

    lang_counter = 0
    translated_data: dict = {}

    for key, value in data.items():
        if '@' not in key and key not in translated_data:
            url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl={lang}&dt=t&q={value}"
            response = requests.get(url)
            translation = response.json()[0][0][0]
            translated_data[key] = translation
            lang_counter += 1
            print(lang_counter,lang,translation)

    with open(f"./lib/l10n/app_{lang}.arb","w") as lang_file:
        dump(translated_data, lang_file)
        sleep(60)
    
    print(lang,"file translation terminated")

print("task completed")

