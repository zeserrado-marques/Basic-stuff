import ssl
from bs4 import BeautifulSoup
import urllib.request, urllib.parse, urllib.error

# Ignore SSL certificate errors
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

url = "http://link.springer.com/openurl?genre=book&isbn=978-3-030-25943-3"
html = urllib.request.urlopen(url, context=ctx).read()
soup = BeautifulSoup(html, 'html.parser')

# Retrieve all of the anchor tags
tags = soup('a')
for tag in tags:
    #print('TAG:', tag)
    link = tag.get('href', None)
    #print('URL:', tag.get('href', None))
    if link.startswith("/content") and link.endswith(".pdf"):
        link_pdf = link
        break
    #print('Contents:', tag.contents[0])
    #print('Attrs:', tag.attrs)
print(link_pdf)
full_url = "https://link.springer.com" + link_pdf
print(full_url)
