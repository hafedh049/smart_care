import json
from translate import Translator

# Define the file path and the target language
filepath = './lib/l10n/app_en.arb'
target_lang = 'fr'

# Load the input file as a JSON-like object
with open(filepath, 'r') as f:
    data = json.load(f)

# Create a dictionary to store the translated values
translated_data = {}

# Initialize the translator
translator = Translator(to_lang="hi")

# Loop over the keys and values in the input data
for key, value in data.items():
    if '@' not in key:
        # Translate the value to the target language
        translation = translator.translate(value)
        # Store the translated value in the output dictionary
        translated_data[key] = translation

# Print the translated data
print(translated_data)
