# Model
from tensorflow import keras
from keras.layers import Dense
from keras.models import Sequential, load_model
# model
from model import predict as model_predict
# Web Server
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
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


def predict(text, decode=False):
    text = pythai.word_tokenize(text, engine='deepcut')
    text = tokenizer.texts_to_sequences([text])
    text = pad_sequences(text, maxlen=60, padding='post', truncating='post')
    predict = model.predict(text)
    rounded = np.round(predict)
    if decode:
        return 'real' if rounded == 1 else 'fake'
    return rounded


# create app
app = FastAPI()
# alow cross origin all origin
app.add_middleware(
    CORSMiddleware,
    allow_origins=['*'],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# index route
@app.get('/')
def index():
    return {'message': 'This is model API.'}

# predict route
@app.get('/predict')
def predict(text: str):
    return {'text': text, 'sentiment': model_predict(text, decode=True)}


# start server
if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)