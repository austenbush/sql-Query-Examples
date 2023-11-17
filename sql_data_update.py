# -*- coding: utf-8 -*-
"""
Created on Fri Oct 27 15:37:16 2023

@author: auste
"""

import pyodbc as pdb
import pandas as pd
#from fast_to_sql import fast_to_sql as fts


#below line can be used to see available drivers in the event of an update to SQL that requires the use of a different driver
#print(pdb.drivers())

#get data to import and put in dataframe
df = pd.read_csv('C:/Users/auste/Notebooks/Page_Visits_Funnel_Project/checkout.csv')


#create connection to SQL database
conn = pdb.connect('Driver={ODBC Driver 18 for SQL Server};' 
                    'Server=AustenPC;'
                    'Database=test_db;'
                    'Trusted_Connection=yes;'
                    'TrustServerCertificate=yes;')

cursor = conn.cursor()

#get column names for columns in table and rows to insert; if necessary, adjust column names first to match sql table
col_names = tuple([i for i in df.columns])
rows = df.apply(tuple, axis = 1)

#table to insert to. also identify the key column (currently using the first col in the dataframe as the key to match)
table_name = 'dbo.checkout'
key_col = col_names[0]

#create two lists. one as the lists of "source" columns with 'Source.' added as prefix to align with Source name of csv data being imported
#second list is simply a list of column names
source_cols = ['Source.' + i for i in df.columns]
tar_cols = [i for i in df.columns]


#create another list with matching for the source columns to target columns
col_match = [i + '=' + j for i, j in list(zip(tar_cols, source_cols))]

#create merge string to import data, matching on the first column as the key column
merge_str = '''MERGE INTO {table_name} as Target
                USING (SELECT * FROM
                (VALUES {vals}) 
                AS s ({tar_cols})
                ) AS Source 
                ON Target.{key}=Source.{key}
                WHEN NOT MATCHED THEN
                INSERT ({tar_cols}) VALUES ({source_cols})
                WHEN MATCHED THEN
                UPDATE SET {col_match};'''.format(table_name=table_name,
                        vals=','.join([str(i) for i in rows]),
                        key=key_col,
                        source_cols=', '.join([str(i) for i in source_cols]),
                        col_match=', '.join([str(i) for i in col_match]),
                        tar_cols=', '.join([str(i) for i in tar_cols]))
                
#execute the query
cursor.execute(merge_str)