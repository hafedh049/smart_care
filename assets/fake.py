# from googlesearch import get
# from time import sleep
from datetime import date
from faker import Faker, Factory
from gender_guesser.detector import Detector
from json import dump, loads
from requests import get
from arabic_reshaper import reshape
from bidi.algorithm import get_display
import locale
import re
import random
import string

char_list = string.ascii_letters + string.digits
regex = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$"


fake_domains: list = [
    "hotmail.com",
    "yahoo.com",
    "yahoo.fr",
    "gmail.com",
    "accent.tn",
]

"""locale.setlocale(locale.LC_ALL, 'en_US.UTF-8')
print(locale.getlocale())
exit(0)"""
# noUser = 'https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/doctor-icon.png?alt=media&token=69e755f5-e674-4064-a97e-708f2ec8c25c'

genderDetector: Detector = Detector()

# Faker.DEFAULT_LOCALE = 'ar_JO'

fake = Faker = Faker()  # 'locale='ar_JO''

real_images_urls_list: list = []
fake_users_list: list = []
fake_phone_numbers_list: list = []

api_url = 'https://genderapi.io/api/'
api_key = '6426981861875d0d3009f193'

start_date = date(1965, 1, 1)
end_date = date(1988, 12, 31)

first_names_list:list = []
last_names_list:list = []

with open("./assets/first_names.txt") as first_names_file:
    first_names_list = first_names_file.read().split('\n')

with open("./assets/last_names.txt") as last_names_file:
    last_names_list = last_names_file.read().split('\n')

with open("./assets/images_url_file.txt") as images_url_file:
    # 600
    for _ in range(65):
        ...
        # if _ in [100,200,300,400,500]:
        # sleep(180)
        # else:
        # print(_)
        # images_url_file.write(loads(get(f"https://fakeface.rest/face/json?gender={'male' if _ % 2 else 'female'}").content.decode())["image_url"]+"\n")
    real_images_urls_list = [image.replace(
        "\n", "") for image in images_url_file.readlines()]


for index in range(600):
    choice = fake.random.choice(["5", "2", "9"])
    phone_number = f"+216 {choice}{fake.random.choice(range(10))} {fake.random.choice(range(10))}{fake.random.choice(range(10))}{fake.random.choice(range(10))} {fake.random.choice(range(10))}{fake.random.choice(range(10))}{fake.random.choice(range(10))}"
    fake_phone_numbers_list.append(phone_number)

index: int = 0

while index < 600:

    #latin_name = fake.name()

    """reshaped_name = reshape(name)

    display_name = get_display(reshaped_name)

    latin_name = display_name \
                    .replace('ا', 'a') \
                    .replace('أ', 'a') \
                    .replace('إ', 'i') \
                    .replace('آ', 'a') \
                    .replace('ب', 'b') \
                    .replace('ت', 't') \
                    .replace('ث', 'th') \
                    .replace('ج', 'j') \
                    .replace('ح', 'h') \
                    .replace('خ', 'kh') \
                    .replace('د', 'd') \
                    .replace('ذ', 'dh') \
                    .replace('ر', 'r') \
                    .replace('ز', 'z') \
                    .replace('س', 's') \
                    .replace('ش', 'sh') \
                    .replace('ص', 's') \
                    .replace('ض', 'd') \
                    .replace('ط', 't') \
                    .replace('ظ', 'z') \
                    .replace('ع', 'a') \
                    .replace('غ', 'gh') \
                    .replace('ف', 'f') \
                    .replace('ق', 'q') \
                    .replace('ك', 'k') \
                    .replace('ل', 'l') \
                    .replace('م', 'm') \
                    .replace('ن', 'n') \
                    .replace('ه', 'h') \
                    .replace('و', 'w') \
                    .replace('ي', 'y') \
                    .replace('ئ', 'i') \
                    .replace('ء', '') \
                    .replace('ة', 'a')"""
    
    latin_name = random.choice(first_names_list).strip() + " " + random.choice(last_names_list).strip()

    if not latin_name in [item["name"] for item in fake_users_list]:

        # if index >= 172 else get(api_url, params={'name': name, 'key': api_key}).json()["gender"]
        gender = genderDetector.get_gender(latin_name.replace(
            'Mr. ', '').replace('Miss ', '').split()[0])

        gender = random.choice(["m","f"]) #"m" if gender in ["unknown", "male", "mostly_male"] else "f"

        role = fake.random.choice(["patient", "doctor"])

        password = ""

        while True:
            password = "".join(random.choices(
                char_list, k=random.choice(range(8, 13))))
            if re.match(regex, password):
                break

        fake_users_list.append({"name": latin_name.strip(),
                                "gender": gender,
                                "phone_number": fake_phone_numbers_list[index],
                                "email": f"{latin_name.lower().replace(' ','')}@{random.choice(fake_domains)}",
                                # fake.password(length=12, digits=True, upper_case=True),
                                "password": password,
                                "id": '#' + fake.pystr(min_chars=8, max_chars=8),
                                "role": role,
                                "roles_list": list(set([role, fake.random.choice(["doctor", "patient"])])),
                                "uid": "",
                                "image_url": real_images_urls_list[index],
                                "status": False,
                                "years_of_experience": "20",
                                "patients_checked_list": [],
                                "location": "",
                                'work_location': "Faculté de Médecine de Monastir",
                                "speciality": "Chiropractors and massage therapists",
                                "rating": "0",
                                "schedules_list": [],
                                "available_time": ["--", "--"],
                                "date_of_birth": fake.date_between(start_date=start_date, end_date=end_date).strftime('%Y-%m-%d'),
                                "about": "",
                                "geolocation": [0, 0],
                                })
        index += 1

with open("./assets/users_file.json", "w") as users_file:
    dump(fake_users_list, users_file)