# Model
from sklearn.feature_extraction.text import TfidfVectorizer
from tensorflow import keras
from keras.layers import Dense
from keras.models import Sequential, load_model

import numpy as np
import joblib

import time
import pythainlp as pythai
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences


model_gbc = joblib.load('./lib/weight/title&body_gbc_model.pkl')

vectorizer = joblib.load('./lib/weight/title&body_gbc_tfidf_vectorizer.pkl')



def predict_tb_gbc(text, body):
    
    text_to_predict_tfidf = vectorizer.transform([text + ' ' + body])  
    
    start_time = time.time()
    predicted_label = model_gbc.predict(text_to_predict_tfidf)
    end_time = time.time() 
    prediction_time = end_time - start_time
    print("เวลาที่ใช้ในการทำนาย: {:.2f} วินาที".format(prediction_time))
    
    sentiment = 'ข่าวจริง' if predicted_label[0] > 4 else 'ข่าวปลอม'
    return sentiment

#print(predict_tb_gbc("ใช้นิ้วนวดรอบดวงตา ทำให้สายตาดีขึ้นภายใน 2 เดือน ", "จากกรณีที่มีผู้ให้คำแนะนำว่า วิธีการทำให้สายตาดีขึ้นในระยะเวลา 2 เดือน ด้วยการใช้นิ้วกดจุด และนวดบริเวณคิ้ว รอบดวงตา สันจมูก ขมับ ใบหู ติ่งหูนั้น ทางกรมการแพทย์ กระทรวงสาธารณสุข ได้ตรวจสอบข้อมูลและชี้แจงว่า 6 วิธีการที่แชร์กันนั้น ยังไม่มีรายงานทางวิชาการที่สามารถวัดผลได้จริง หรือช่วยให้การรักษาดีขึ้น และหากนวดบริเวณรอบดวงตาไม่ถูกวิธี อาจมีผลทำให้เส้นเลือดฝอยใต้เยื่อบุตาแตกได้ หรืออาจมีผลร้ายแรงถึงขั้นตาบอด จากที่เส้นเลือดที่จอประสาทตาอุดตันหรือแตกได้ โดยภาวะสายตายาวเป็นความบกพร่องของสายตา ที่ไม่สามารถแพ่งหรือมองวัตถุได้ชัดเจนในระยะใกล้ ๆ ซึ่งตามปกติแล้วสายตายาวเกิดขึ้นตามอายุ โดยเฉพาะในกลุ่มที่มีอายุ 40 ปีขึ้นไป และการรักษา คือ การสวมแว่นตามที่แพทย์สั่ง โดยการตรวจวัดค่าสายตาจากแพทย์"))

    


 


