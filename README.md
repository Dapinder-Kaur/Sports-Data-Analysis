# Sports Data Analysis

This project contains the code and analysis for sports data, that includes match data, team former names, goal scorers and shootouts. The aim of this project is to better understand the soccer matches played at different leagues.

The project uses streamlit that makes it easier to filter out and visualize the data for analysis.

## Table of Contents:

1. [Dataset](#Dataset)
2. [Data Preprocessing](#Data-Preprocessing)
3. [Data Analysis](#Data-Analysis)
4. [Model Training for Prediction](#Model-Training)
5. [Run Instructions](#Run-Instructions)
6. [Conclusion](#Conclusion)

## Dataset

The data is comprised of four datasets 

- `former_names` - Former and current names of the teams and time period they existed
- `goalscorers` - Players who scored goals and in which matches (with penalty or own goal)
- `results` - Results of the matches played between teams and winning team along with type of tournament (useful for anlysing how often the home teams win the matches palyed in their own countries)
- `shootouts` - Teams which won and the first shooter for penalties (useful for anlysing, how often the first shooter wins the game)

## Data-Preprocessing 

- Renamed columns to lower case, without any spaces and the names that make sense, most of the names were already good.
- Created new column where needed like team_win (bool) to predict if the home_team won provided that their scores were higher than the away team
- Checked for all the null type that existed in the dataset and combined them all to na_values
- Removed Null Values by dropping or filling them with appropriate values, and also checked for any outlier values
- Converted date to date dtype , and checked other dtypes

## Data Analysis

- Connected to the MySQL server using `sqlalchemy` library
- Created different tables for different datasets
- Queried the data in SQL server `sql-queries.sql` to answer common questions and understand it
- Built a stream lit visualization to analyse the results, former_names and match result prediction 

## Model Training

- Connected to mysql server, `model.py`
- Loaded the cleaned data
- Trained a LogisticRegression model to predict match outcomes based on the teams in which the match is played and where it is played,

## Run Instructions

1. Clone the github repository

```bash
git clone [https://github.com/Dapinder-Kaur/Sports-Data-Analysis]
cd Sports-Data-Analysis
```

2. Set up Virtual environment

I recommed using Anaconda.

3. Install required dependencies 

```bash
pip install -r requirements.txt
```

4. Run the streamlit app

```bash
streamlit run src/main.py
```

## Conclusion

This project analyses the Sports data to understand trends, and the advantages to the home_team, first_shooter and goalscorers patterns.

## General Information for SetUp

I recommend to use conda environment manager for data science projects. If your conda (base) envrionment automatically gets activated, you can remove that by  typing 

```bash
conda config --set auto_activate_base false
```

in your Windows Powershell.

Also, if you want to want to delete your virtual environment .venv, type ```deactivate``` in your terminal, and then delete the .venv folder your workspace, you might then restart the VSCode

