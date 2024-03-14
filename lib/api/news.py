import pandas as pd


df = pd.read_csv('./lib/weight/AFNC_Opendata_export_20240304145314.csv')
from pythainlp.tokenize import word_tokenize
from pythainlp.util import normalize


df['processed_text'] = df['หัวข้อข่าว'].apply(lambda x: ' '.join(word_tokenize(normalize(x))))

from sklearn.feature_extraction.text import TfidfVectorizer


vectorizer = TfidfVectorizer()
tfidf_matrix = vectorizer.fit_transform(df['processed_text'])

from sklearn.metrics.pairwise import linear_kernel

# cosine similarity
cosine_similarities = linear_kernel(tfidf_matrix, tfidf_matrix)


def search(query):
    query_vector = vectorizer.transform([query])
    cosine_similarities_query = linear_kernel(query_vector, tfidf_matrix).flatten()
    
    related_docs_indices = cosine_similarities_query.argsort()[::-1]
    
    result = df.iloc[related_docs_indices][["ลิงค์ข่าว", "หัวข้อข่าว"]].head(5).to_json(orient='records', force_ascii=False)
    
    
    return result


 #ตัวอย่างการค้นหา
#query = ("นำปัสสาวะใส่ฝา ตั้งไว้ตรงที่มีมดขึ้นบ่อย ๆ ถ้ามดขึ้นต้องรีบไปตรวจเบาหวาน")
#result = search(query)
#print(result)