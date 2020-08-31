# from google.cloud import storage
# from firebase import firebase
# import firebase_admin
# import google.cloud
# from firebase_admin import credentials, firestore
# import os
# os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="C:/Users/KIIT/Flutter/kudosware/pdf_website/python/serviceAccountKey.json"
# cred = credentials.Certificate("C:/Users/KIIT/Flutter/kudosware/pdf_website/python/serviceAccountKey.json")

# db = firestore.client()
# client = storage.Client()
# bucket = client.get_bucket('websitepdf.appspot.com')
# for i in range(1,11):
#     imageBlob = bucket.blob("/")
#     imagePath = f"C:/Users/KIIT/Flutter/kudosware/pdf_website/assets/Data/{i}.pdf"
#     imageBlob = bucket.blob(f"{i}")
#     imageBlob.upload_from_filename(imagePath)
#     data = {
#     u'text': u'',
#     u'name': i,
#     u'url': imageBlob.public_url}
#     db.collection(u'pdfs').document(f"{i}").set(data)

import pdfminer
import io
from pdfminer.converter import TextConverter
from pdfminer.pdfinterp import PDFPageInterpreter
from pdfminer.pdfinterp import PDFResourceManager
from pdfminer.pdfpage import PDFPage


def extract_text_from_pdf(pdf_path):
    resource_manager = PDFResourceManager()
    fake_file_handle = io.StringIO()
    converter = TextConverter(resource_manager, fake_file_handle)
    page_interpreter = PDFPageInterpreter(resource_manager, converter)

    with open(pdf_path, 'rb') as fh:
        for page in PDFPage.get_pages(fh,
                                      caching=True,
                                      check_extractable=True):
            page_interpreter.process_page(page)

        text = fake_file_handle.getvalue()

    # close open handles
    converter.close()
    fake_file_handle.close()

    if text:
        return text


if __name__ == '__main__':
    print(extract_text_from_pdf("C:/Users/KIIT/Flutter/kudosware/pdf_website/assets/Data/1.pdf"))
