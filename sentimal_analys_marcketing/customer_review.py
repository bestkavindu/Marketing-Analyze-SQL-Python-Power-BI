import pandas as pd
import pyodbc 
import nltk 
from nltk.sentiment.vader import SentimentIntensityAnalyzer

nltk.download('vader_lexicon')


def fetch_data_from_sql():
    conn_str = (
        "Driver={SQL Server};"
        "Server=DESKTOP-H5Q7JSB\SQLEXPRESS;"
        "Database=MarketingAnalytics;"
        "Trusted_Connection=yes;"
    )

    conn = pyodbc.connect(conn_str)

    query = "SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText FROM dbo.customer_reviews_updated"

    df = pd.read_sql(query, conn)

    conn.close()

    return df

customer_review_df = fetch_data_from_sql()

# print(customer_review_df)

sia = SentimentIntensityAnalyzer()

def calculate_sentiment(review):
    sentiment = sia.polarity_scores(review)
    return sentiment['compound']

def categorize_sentiment(score, rating):
    if score > 0.05:
        if rating >= 4:
            return 'Positive'
        elif rating == 3:
            return 'Mixed Positive'
        else:
            return 'Mixed negative'
    elif score < -0.05:
        if rating <= 2:
            return 'Negative'
        elif rating == 3:
            return 'Mixed negative'
        else:
            return 'Mixed Positive'
    else:
        if rating >= 4:
            return 'Positive'
        elif rating <= 2:
            return 'Negative'
        else:
            return 'Naturel'
        
def sentiment_bucket(score):
    if score >= 0.5:
        return '0.5 to 1.0'
    elif 0.0 <= score <0.5:
        return '0.0 to 0.49'
    elif -0.5 <= score < 0.0:
        return '-0.5 to 0.0'
    else:
        return '-1.0 to -0.5'
    
customer_review_df['SentimentScore'] = customer_review_df['ReviewText'].apply(calculate_sentiment)

customer_review_df['SentimentCategory'] = customer_review_df.apply(
    lambda row: categorize_sentiment(row['SentimentScore'], row['Rating']), axis=1
)
    
# print(customer_review_df)

customer_review_df['SentimentBucket'] = customer_review_df['SentimentScore'].apply(sentiment_bucket)

customer_review_df.to_csv('customer_review_with_sentiment.csv', index=False)