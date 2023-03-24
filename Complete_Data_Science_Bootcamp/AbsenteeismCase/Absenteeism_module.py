import numpy as np
import pandas as pd
import pickle
from sklearn.preprocessing import StandardScaler
from sklearn.base import BaseEstimator, TransformerMixin



class CustomScaler(BaseEstimator,TransformerMixin): 
    
    def __init__(self,columns,copy=True,with_mean=True,with_std=True):
        self.scaler = StandardScaler(copy,with_mean,with_std)
        self.columns = columns
        self.mean_ = None
        self.var_ = None

    def fit(self, X, y=None):
        self.scaler.fit(X[self.columns], y)
        self.mean_ = np.array(np.mean(X[self.columns]))
        self.var_ = np.array(np.var(X[self.columns]))
        return self

    def transform(self, X, y=None, copy=None):
        init_col_order = X.columns
        X_scaled = pd.DataFrame(self.scaler.transform(X[self.columns]), columns=self.columns)
        X_not_scaled = X.loc[:,~X.columns.isin(self.columns)]
        return pd.concat([X_not_scaled, X_scaled], axis=1)[init_col_order]
    
class absenteeism_model():
      
        def __init__(self, model_file, scaler_file):
            # read the 'model' and 'scaler' files which were saved
            with open('model','rb') as model_file, open('scaler', 'rb') as scaler_file:
                self.reg = pickle.load(model_file)
                self.scaler = pickle.load(scaler_file)
                self.data = None
        
        # take a data file (*.csv) and preprocess it
        def load_and_clean_data(self, data_file):
            
            # import the data
            df = pd.read_csv(data_file,delimiter=',')
            # store the data in a new variable for later use
            self.df_with_predictions = df.copy()

            # to preserve the code we'll add a column with 'NaN' strings
            df['AbsenteeismTimeHours'] = 'NaN'

            df.columns = ['ID', 'ReasonForAbsence', 'Date', 'TranspExpense',
            'DistanceToWork', 'Age', 'DailyWorkLoadAvg', 'BodyMassIndex',
            'Education', 'Children', 'Pets', 'AbsenteeismTimeHours']

            df = df.drop(['ID'], axis = 1)

            # creating a separate dataframe, containing dummy values grouping the Absence reasons
            reasonForAbsence = pd.get_dummies(df['ReasonForAbsence'], drop_first = True)
            
            # spliting reason_columns into 4 types
            reasonCategory_1 = reasonForAbsence.loc[:,1:14].max(axis=1)
            reasonCategory_2 = reasonForAbsence.loc[:,15:17].max(axis=1)
            reasonCategory_3 = reasonForAbsence.loc[:,18:21].max(axis=1)
            reasonCategory_4 = reasonForAbsence.loc[:,21:].max(axis=1)

            # to avoid multicollinearity, drop the original 'Reason for Absence' column
            df = df.drop(['ReasonForAbsence'], axis = 1)
            
            # concatenating df and the 4 types of reason for absence
            df = pd.concat([df, reasonCategory_1, reasonCategory_2, reasonCategory_3, reasonCategory_4], axis = 1)
            
            # Renaming
            df.columns=['Date', 'TranspExpense', 'DistanceToWork', 'Age','DailyWorkLoadAvg', 'BodyMassIndex', 'Education', 'Children', 'Pets', 'AbsenteeismTimeHours', 
            'reasonCategory_1', 'reasonCategory_2', 'reasonCategory_3', 'reasonCategory_4']

            # Reordering
            df = df[['reasonCategory_1', 'reasonCategory_2', 'reasonCategory_3', 'reasonCategory_4',
            'Date', 'TranspExpense', 'DistanceToWork', 'Age','DailyWorkLoadAvg', 'BodyMassIndex', 'Education', 'Children', 'Pets', 'AbsenteeismTimeHours']]

            # converting the 'Date' column into datetime
            df['Date'] = pd.to_datetime(df['Date'], format='%d/%m/%Y')

            # creating lists for months and weekdays 
            months = []
            for i in range(len(df)):
                months.append(df['Date'][i].month)

            weekdays = []

            for i in range (len(df)):
                weekdays.append(df['Date'][i].weekday())

            # inserting the new values
            df['Month'] = months

            df['Weekday'] = weekdays

            # drop the 'Date' column from df
            df = df.drop(['Date'], axis = 1)

            # re-order the columns in df
            df = df[['reasonCategory_1', 'reasonCategory_2', 'reasonCategory_3', 'reasonCategory_4',
            'Month', 'Weekday', 'TranspExpense', 'DistanceToWork', 'Age','DailyWorkLoadAvg', 'BodyMassIndex', 'Education', 'Children', 'Pets', 'AbsenteeismTimeHours']]
            
            # replacing the NaN values
            df = df.fillna(value=0)

            # drop the variables we decide we don't need
            df = df.drop(['AbsenteeismTimeHours','DistanceToWork','BodyMassIndex'],axis=1)
            
            # we have included this line of code if you want to call the 'preprocessed data'
            self.preprocessed_data = df.copy()
            
            # we need this line so we can use it in the next functions
            self.data = self.scaler.transform(df)
    
        # a function which outputs the probability of a data point to be 1
        def predicted_probability(self):
            if (self.data is not None):  
                pred = self.reg.predict_proba(self.data)[:,1]
                return pred
        
        # a function which outputs 0 or 1 based on our model
        def predicted_output_category(self):
            if (self.data is not None):
                pred_outputs = self.reg.predict(self.data)
                return pred_outputs
        
        # predict the outputs and the probabilities and 
        # add columns with these values at the end of the new data
        def predicted_outputs(self):
            if (self.data is not None):
                self.preprocessed_data['Probability'] = self.reg.predict_proba(self.data)[:,1]
                self.preprocessed_data ['Prediction'] = self.reg.predict(self.data)
                return self.preprocessed_data