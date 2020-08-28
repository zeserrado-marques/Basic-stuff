import re
import PyPDF2
import requests
import ssl
import urllib.request, urllib.parse, urllib.error
from bs4 import BeautifulSoup

# Ignore SSL certificate errors
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE

# path to open the pdf file
path = 'Springer Ebooks.pdf'
pdfFileObj = open(path,'rb')

#create a parsable PDF object
pdfReader = PyPDF2.PdfFileReader(pdfFileObj)
num_pages = pdfReader.numPages
count = 0
text = "" # this will have all the text present in the pdf
#The while loop will read each page.
while count < num_pages:
    pageObj = pdfReader.getPage(count)
    count +=1
    text += pageObj.extractText()

# regex to extract links from the pdf
lst_urls = re.findall('(http://link.*)\s', text)

# regex to extract the titles
lst_titles = re.findall('\n([0-9]{1,3})\n(.*)\n', text)
names_pdf_lst = list()
for tuple in lst_titles:
    number, title = tuple
    title = title.replace(" ", "_")
    title = title.replace(":", "_")
    title = title.replace("/", "_")
    names_pdf_lst.append(number + "_" + title)

# time to open the links
full_url_lst = list()
#looper = 0
for url in lst_urls:
    html = urllib.request.urlopen(url, context=ctx).read()
    soup = BeautifulSoup(html, 'html.parser')

    # Retrieve all of the anchor tags
    tags = soup('a')
    for tag in tags:
        link = tag.get('href', None)
        #print('URL:', link)
        if link.startswith("/content") and link.endswith(".pdf"):
            link_pdf = link
            break
    #print(link_pdf)
    full_url = "https://link.springer.com" + link_pdf
    full_url_lst.append(full_url) # adds the link to the list
    #looper += 1
    #if looper == 4:
    #    break
    #print(full_url)
#print(full_url_lst) # list "full_url_lst" has all the links to the pdfs

# now that we have the urls, time to download them
sec_looper = 0
for pdf_url in full_url_lst:
    myfile = requests.get(pdf_url)
    print("downloading pdf:", names_pdf_lst[sec_looper], "link:", pdf_url)
    open(f'books_springer/{names_pdf_lst[sec_looper]}.pdf', 'wb').write(myfile.content)
    sec_looper += 1
    if sec_looper == len(full_url_lst):
        break
