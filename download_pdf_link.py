import requests
url = 'https://link.springer.com/content/pdf/10.1007%2F978-3-030-25943-3.pdf'
myfile = requests.get(url)
open('books_springer/test.pdf', 'wb').write(myfile.content)
