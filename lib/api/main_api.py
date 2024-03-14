# model
from model import predict as model_predict
from svm import predictsvm as model_predictsvm
from knn import predictknn as model_predictknn
from gbc import predictgbc as model_predictgbc
from news import search as search_news 

# Web Server
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

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
    return {'text': text, 'sentiment': model_predict(text)}

@app.get('/predictsvm')
def predict(text: str):
    return {'text': text, 'sentiment': model_predictsvm(text)}

@app.get('/predictknn')
def predict(text: str):
    return {'text': text, 'sentiment': model_predictknn(text)}

@app.get('/predictgbc')
def predict(text: str):
    return {'text': text, 'sentiment': model_predictgbc(text)}

@app.get('/search_news')
def predict(text: str):
    return {'text': text, 'news': search_news(text)}

# start server
if __name__ == '__main__':
    uvicorn.run(app, host='127.0.0.1', port=8000)