import requests
from json import loads, dump
from random import choice

api_endpoint = "https://newsapi.org/v2/everything"
api_key = "4ab974b0133747658c75513590257f4e"

articles = []


def get_logo_url(topic):
    response = requests.get(f"https://logo.clearbit.com/{topic}.com")
    if response.status_code == 200:
        return response.url
    return None


for _, topic in enumerate(zip(["Politics", "Sport", "Education", "Health", "World", "Gaming", "Astronomy"], [get_logo_url("politics"), get_logo_url("sport"), get_logo_url("education"), get_logo_url("health"),  get_logo_url("world"), get_logo_url("games"), get_logo_url("astronomy")])):
    while True:
        params = {"language": choice(["us","fr"]),"q": f"{topic[0]}", "sortBy": "publishedAt","pageSize": 8,"apiKey": api_key}
        response = requests.get(api_endpoint, params=params)
        data = loads(response.text)
        print(bool(data["articles"]))
        if(data["articles"]): break
        
    for article in data["articles"]:
        if article["urlToImage"] == None or article["description"] == None or article["urlToImage"] == None:
            continue
        articles.append(article | {'topic': topic[0], "sourceUrl": topic[1]})

seen_titles = set()
unique_articles = []
for article in articles:
    title = article["title"]
    if title not in seen_titles:
        unique_articles.append(article)
        seen_titles.add(title)

with open("./assets/articles_file.json", "w") as articles_file:
    dump(unique_articles, articles_file)
