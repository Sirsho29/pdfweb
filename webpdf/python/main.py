from google.cloud import storage
from firebase import firebase
import firebase_admin
import google.cloud
from firebase_admin import credentials, firestore
import os
os.environ["GOOGLE_APPLICATION_CREDENTIALS"]="C:/Users/KIIT/Flutter/kudosware/pdf_website/python/serviceAccountKey.json"
cred = credentials.Certificate("C:/Users/KIIT/Flutter/kudosware/pdf_website/python/serviceAccountKey.json")

db = firestore.client()
client = storage.Client()
bucket = client.get_bucket('websitepdf.appspot.com')
for i in range(1,11):
    imageBlob = bucket.blob("/")
    imagePath = f"C:/Users/KIIT/Flutter/kudosware/pdf_website/assets/Data/{i}.pdf"
    imageBlob = bucket.blob(f"{i}")
    imageBlob.upload_from_filename(imagePath)
    data = {
    u'text': u'',
    u'name': i,
    u'url': imageBlob.public_url}
    db.collection(u'pdfs').document(f"{i}").set(data)