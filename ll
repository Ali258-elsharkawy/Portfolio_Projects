#importing pandas libarary 
import pandas as pd

#setting the settings of maximun rows to show to 1000000000000000000000
pd.set_option('display.max.rows', 1000000000000000000000)

#reading the dataset from csv file 
# big_dataset =pd.read_csv('I:\SQL Data\Iowa_Liquor_Sales.csv', low_memory= 'false')

#exploring the dataset
# big_dataset


#reading the data from its location
df=pd.read_csv(r'I:\data analysis\python\countries of the world.csv')
df

#filtering the data according to these two countries
targeted_countries= ['qatar','vietnam']
df[df['Country'].isin(targeted_countries)]

#reading the second dataset
df_pop=pd.read_csv(r'I:\data analysis\python\world_population.csv')
df_pop

#filtering rows where their rank is below 10
df_pop[df_pop['Rank'] < 10]


#filtering the data to get the rows there country column have letters 'pal'
df_pop[df_pop['Country'].str.contains('Pal')]

#setting the country column to index column and save this change to new data frame
df_pop2 = df_pop .set_index('Country')

#filtering columns with names of 'country' and 'CCA3'
df_pop2.filter(items=['Country', 'CCA3'])


df_pop2.filter(items=['Palestine'], axis= 0)


df_pop2

#reading the data file
df_IC =pd.read_csv('I:\data analysis\python\Flavors.csv')
df_IC

#selecting only data with numeric type 
numeric_columns = df_IC.select_dtypes(include='number').columns

# aggigating by the column of base flavor 
aggrigated = df_IC.groupby('Base Flavor')[numeric_columns]

#calculating the mean 
aggrigated.mean()

df_IC.groupby('Base Flavor').count()

df_IC.groupby('Base Flavor').min()

df_IC.groupby('Base Flavor').max()

aggrigated.sum()

df_IC.groupby(['Base Flavor', 'Liked']).agg({'Flavor Rating':['mean', 'max', 'min'], 'Texture Rating':['mean', 'max', 'min']})

df_IC.groupby(['Base Flavor', 'Liked']).describe()


#######################################################################################################################################################################################

LOTR =pd.read_csv('I:\data analysis\python\LOTR.csv')
LOTR2 = pd.read_csv('I:\data analysis\python\LOTR 2.csv')

merge_example = LOTR.merge(LOTR2, how='outer', on= ['FellowshipID', 'FirstName'], sort= ['false','true'])

merge_example

cross_example = LOTR.merge(LOTR2, how= 'cross')

cross_example

join_example = LOTR.set_index('FellowshipID').join(LOTR2.set_index('FellowshipID'), lsuffix= '_left', rsuffix='_right')

join_example

concat_example = pd.concat([LOTR, LOTR2], join= 'inner', axis= 1)

concat_example
