# Match Outcome Prediction Model

# Model to predict if home team will win, based on the results dataset:
import pandas as pd
from sqlalchemy import create_engine
from password import encoded_password
import joblib

from sklearn.svm import SVC
from sklearn.preprocessing import OneHotEncoder
from sklearn.linear_model import LogisticRegression

import warnings
warnings.filterwarnings('ignore')

def get_data():
    engine = create_engine(f'mysql+mysqlconnector://root:{encoded_password}@127.0.0.1:3307/data')
    query = 'SELECT * from match_data '
    df = pd.read_sql(query, engine)
    df.drop(columns=['id'], inplace=True)
    return df

def train_model():
    df = get_data()
    
    # Preprocess data
    X = df[['home_team', 'away_team', 'tournament', 'city', 'country']]
    y = df[['team_win']]

    # Encode categorical variables
    encoder = OneHotEncoder(sparse_output=False, handle_unknown='ignore')
    X_encoded = encoder.fit_transform(X)

    model = LogisticRegression(max_iter=1000)
    model.fit(X_encoded, y)


    joblib.dump(encoder, 'encoder.pkl')
    joblib.dump(model, 'model.pkl')


if __name__ == "__main__":
    train_model()