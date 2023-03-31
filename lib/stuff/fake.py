from faker import Faker
from gender_guesser.detector import Detector
from json import dump, loads
from time import sleep
# from googlesearch import get
from requests import get

images_urls_list: list = []


with open("./lib/stuff/images_url_file.txt","a") as images_url_file:
    for _ in range(600):
        if _ in [100,200,300,400,500]:
            sleep(180)
        else:
            print(_)
            image_url :str= loads(get(f"https://fakeface.rest/face/json?gender={'male' if _ % 2 else 'female'}").content.decode())["image_url"]
            images_urls_list.append(image_url)
            images_url_file.write(image_url+"\n")
        
#noUser = 'https://firebasestorage.googleapis.com/v0/b/smart-care-b4ab6.appspot.com/o/doctor-icon.png?alt=media&token=69e755f5-e674-4064-a97e-708f2ec8c25c'

"""genderDetector: Detector = Detector()

fake: Faker = Faker()

fake_patients_list: list = []
fake_doctors_list: list = []
fake_phone_numbers_list: list = []

for index in range(600):
    choice = fake.random.choice(["5", "2", "9"])
    phone_number = f"+216 {choice}{fake.random.choice(range(10))} {fake.random.choice(range(10))}{fake.random.choice(range(10))}{fake.random.choice(range(10))} {fake.random.choice(range(10))}{fake.random.choice(range(10))}{fake.random.choice(range(10))}"
    fake_phone_numbers_list.append(phone_number)

index: int = 0
while index < 300:
    fullname: str = fake.first_name() + " " + fake.last_name()
    if not fullname in [item["name"] for item in fake_patients_list]:
        gender: str = genderDetector.get_gender(fullname.split()[0])
        fake_patients_list.append({"name": fullname,
                                   "gender": gender.replace("mostly_", "")[0] if "mostly_" in gender else gender[0],
                                   "phone_number": fake_phone_numbers_list[index],
                                   "email": f"{fullname.replace(' ','').lower()}@{fake.email().split('@')[1]}",
                                   "password": fake.password(length=12, digits=True, upper_case=True),
                                   "id": '#' + fake.pystr(min_chars=8, max_chars=8),
                                   "role": "patient",
                                   "roles_list": ["patient"] + fake.random.choice([["doctor"], []]),
                                   "uid": "",
                                   "image_url": images_urls_list[index],
                                   "status": True,
                                   "years_of_experience": "20", "patients_checked_list": [],
                                   "location": "",
                                   'workLocation': "Faculté de Médecine de Monastir",
                                   "speciality": "Chiropractors and massage therapists",
                                   "rating": "0",
                                   "schedules_list": [],
                                   "available_time": ["--", "--"],
                                   "date_of_birth": str(fake.date_of_birth()),
                                   "gender": "m",
                                   "about": "",
                                   "geolocation": [0, 0],
                                   })
        index += 1

index: int = 0
while index < 300:
    fullname: str = fake.first_name() + " " + fake.last_name()
    if not fullname in [*[item["name"] for item in fake_patients_list], *[item["name"] for item in fake_doctors_list]]:
        gender: str = genderDetector.get_gender(fullname.split()[0])
        fake_doctors_list.append({"name": fullname,
                                  "gender": gender.replace("mostly_", "")[0] if "mostly_" in gender else gender[0],
                                  "phone_number": fake_phone_numbers_list[300 + index],
                                  "email": f"{fullname.replace(' ','').lower()}@{fake.email().split('@')[1]}",
                                  "password": fake.password(length=12,  digits=True, upper_case=True),
                                  "id": '#' + fake.pystr(min_chars=8, max_chars=8),
                                  "role": "doctor",
                                  "roles_list": ["doctor"] + fake.random.choice([["patient"], []]),
                                  "uid": "",
                                  "image_url": images_urls_list[300+index],
                                  "status": True,
                                  "years_of_experience": "20", "patients_checked_list": [],
                                  "location": "",
                                  'workLocation': "Faculté de Médecine de Monastir",
                                  "speciality": "Chiropractors and massage therapists",
                                  "rating": "0",
                                  "schedules_list": [],
                                  "available_time": ["--", "--"],
                                  "date_of_birth": str(fake.date_of_birth()),
                                  "gender": "m",
                                  "about": "",
                                  "geolocation": [0, 0],

                                  })
        index += 1

with open("./lib/stuff/doctors_file.json", "w") as doctors_file:
    dump(fake_doctors_list, doctors_file)

with open("./lib/stuff/patients_file.json", "w") as patients_file:
    dump(fake_patients_list, patients_file)"""
