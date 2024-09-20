# Model
from sklearn.feature_extraction.text import TfidfVectorizer
from tensorflow import keras
from keras.layers import Dense
from keras.models import Sequential, load_model
import numpy as np
# tokenizer
import time
import joblib

import pickle
import pythainlp as pythai
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences

# โหลด model ด้วย joblib
model_gbc = joblib.load('./lib/weight/gbc_model.joblib')
# load tokenizer
vectorizer = joblib.load('./lib/weight/gbc_vectorizer.joblib')



def predictgbc(text):
    
    text_to_predict_tfidf = vectorizer.transform([text])

    
    start_time = time.time()
    predicted_label = model_gbc.predict(text_to_predict_tfidf)
    end_time = time.time()
    prediction_time = end_time - start_time
    print("เวลาที่ใช้ในการทำนาย: {:.2f} วินาที".format(prediction_time))

    
    sentiment = 'ข่าวจริง' if predicted_label[0] == 1 else 'ข่าวปลอม'
    return sentiment
    

#print(predictgbc('แอปฯ กรมที่ดินปลอม ติดตั้งปุ๊บ เงินหายปั๊บ'))
 


