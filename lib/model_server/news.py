import csv
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# โหลดข้อมูลจากไฟล์ CSV เป็น DataFrame
def load_data(csv_file):
    df = pd.read_csv(csv_file, encoding='utf-8')
    return df

# คำนวณ TF-IDF ของข้อมูล
def calculate_tfidf(titles):
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(titles)
    return tfidf_matrix, vectorizer

# ค้นหา
def search_similar_documents(query, tfidf_matrix, vectorizer):
    query_vector = vectorizer.transform([query])
    cosine_similarities = cosine_similarity(query_vector, tfidf_matrix).flatten()
    
    # สร้างลิสต์ของค่าความคล้ายคลึงและดัชนี
    similarity_scores = [(i, score) for i, score in enumerate(cosine_similarities) if score > 0.0]
    
    # เรียงลำดับค่าความคล้ายคลึงจากมากไปน้อย
    similarity_scores.sort(key=lambda x: x[1], reverse=True)
    
    # เก็บเฉพาะ 10 อันดับแรก
    top_similar_documents = similarity_scores[:10]
    print(top_similar_documents)
    return top_similar_documents


# เรียกใช้งาน
def search(query):
    csv_file = './lib/weight/AFNC_Opendata_export_20240304145314.csv'  # ไฟล์ CSV ที่เก็บข้อมูล
    
    
    df = load_data(csv_file)
    titles = df['หัวข้อข่าว'].tolist()
    tfidf_matrix, vectorizer = calculate_tfidf(titles)
    similar_documents = search_similar_documents(query, tfidf_matrix, vectorizer)
    similar_indices = [index for index, _ in similar_documents]

    result_df = df.iloc[similar_indices][["ลิงค์ข่าว", "หัวข้อข่าว"]]
    result_json = result_df.to_json(orient='records', force_ascii=False)

    
    return result_json
    
#ตัวอย่างการค้นหา
query = "COVID-19: Infodemic spread shows low trust in ASEAN leaders"
result = search(query)
print(result)
