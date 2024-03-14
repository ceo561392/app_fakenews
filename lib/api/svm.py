# Model
from sklearn.feature_extraction.text import TfidfVectorizer
from tensorflow import keras
from keras.layers import Dense
from keras.models import Sequential, load_model
import numpy as np
# tokenizer

import joblib


import pythainlp as pythai
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences

# โหลด model ด้วย joblib
model_svm = joblib.load('./lib/weight/svm_model.joblib')
# load tokenizer
vectorizer = joblib.load('./lib/weight/tfidf_vectorizer.joblib')



def predictsvm(text):
    
    text_to_predict_tfidf = vectorizer.transform([text])
    predicted_label = model_svm.predict(text_to_predict_tfidf)
    

    
    sentiment = 'ข่าวจริง' if predicted_label[0] == 1 else 'ข่าวปลอม'
    return sentiment
    
print(predictsvm('มะนาวโซดารักษาโรคมะเร็ง'))

 


