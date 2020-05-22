import PyPDF2
import re
path = 'Springer Ebooks.pdf'
pdfFileObj = open(path,'rb')

pdfReader = PyPDF2.PdfFileReader(pdfFileObj)
num_pages = pdfReader.numPages
count = 0
text = ""
#The while loop will read each page.
while count < num_pages:
    pageObj = pdfReader.getPage(count)
    count +=1
    text += pageObj.extractText()

#print(text)
lst_urls = re.findall('(http://link.*)\s', text)
#for i in lst_urls:
#    print(i)

lst_titles = re.findall('\n([0-9]{1,3})\n(.*)\n', text)
names_pdf_lst = list()
for tuple in lst_titles:
    number, title = tuple
    title = title.replace(" ", "_")
    names_pdf_lst.append(title + "_" + number)
    print(number, title, title+"_"+number)
print(names_pdf_lst)
