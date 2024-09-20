# Model
from tensorflow import keras
from keras.layers import Dense
from keras.models import Sequential, load_model
import numpy as np
# tokenizer
import pickle

import pythainlp as pythai
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences

# load model
model = load_model('./lib/weight/THAI_LSTM_model.h5')
# load tokenizer
with open('./lib/weight/tokenizer.pkl', 'rb') as handle:
    tokenizer = pickle.load(handle)


def predict(text):
    text = pythai.word_tokenize(text, engine='deepcut')
    text = tokenizer.texts_to_sequences([text])
    text = pad_sequences(text, maxlen=59, padding='post', truncating='post')
    predict = model.predict(text)

    rounded = np.round(predict)
    print(rounded)
    print(predict)
    sentiment = 'ข่าวจริง' if rounded[0][0] == 1 else 'ข่าวปลอม'
    return sentiment
    

#print(predict('การอาบน้ำอุ่นตอนท้องปลอดภัยหรือไม่? ข่าวจริงที่หญิงตั้งครรภ์ต้องหลีกเลี่ยง'))
 


