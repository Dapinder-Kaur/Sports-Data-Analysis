# streamlit app main file
import streamlit as st
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
import plotly.express as px
import joblib

st.title("Soccer Data App")

conn = st.connection('mysql', type='sql')

# df = conn.query('SELECT * from match_data '\
#                 'LIMIT 10;')

# st.dataframe(df)

# for row in df.itertuples():
#     st.write(f"Match ID: {row.id}, Home Team: {row.home_team},\
#               Away Team: {row.away_team}")

values = ['Charts','Results', 'Former Names', 'Predictive Analysis']

st.sidebar.title("Analysis Options")
st.sidebar.write("Select an analysis to explore:")
chosen_option = st.sidebar.selectbox("Choose an option", values)

if chosen_option == values[0]:
    @st.cache_data
    def load_shootouts_data():
        return conn.query('SELECT * from shootouts ')

    df = load_shootouts_data()
    st.header("Shootouts Data Visualization")

    df['first_shooter_won'] = (df['first_shooter'] == df['winner'])

    win_counts = df['first_shooter_won'].value_counts().reset_index()
    # reset index to convert this to a dataframe

    win_counts.columns = ['Outcome of the match (won/lost)', 'Count']
    win_counts['Outcome of the match (won/lost)'] = ['Lost', 'Won']

    # fig_plotly = px.scatter(df, x='home_team', y='away_team', color='winner')
    st.write("In soccer the team that shoots first in a shootout has a higher chance of winning.\
             This chart shows the number of times the first shooter won vs lost.")

    fig_plotly = px.bar(win_counts, x='Outcome of the match (won/lost)', y='Count',\
                         title='How many times first shooter won', color_discrete_sequence=['lightgreen'])
    st.plotly_chart(fig_plotly, use_container_width=True)



    st.header("Goalscorers Data Visualization")

    st.write("Comparing the number of own goals vs penalties scored in matches. Most of the \
             soccer matches become draw at the end of regular time, so penalties are used to decide the winner.")

    @st.cache_data
    def load_scorers_data():
        return conn.query('SELECT * from goalscorers ')
    
    df_scorers = load_scorers_data()

    own_goal = df_scorers['own_goal'].sum()
    penalty = df_scorers['penalty'].sum()

    data = {"Goal data": ['own_goal', 'penalty'], "counts": [own_goal, penalty]}  
    df_goalscorers_plot = pd.DataFrame(data)

    fig_plotly_goalscorers = px.bar(df_goalscorers_plot, x='Goal data', y='counts',\
                                     title =f'Own Goals vs Penalties in total goal scored = {len(df_scorers)}', \
                                        color_discrete_sequence=['lightblue'])
    st.plotly_chart(fig_plotly_goalscorers, use_container_width=True)

if chosen_option == values[1]:
    st.header("Match Results Analysis")
    st.write("The match data contains results of soccer matches played in various leagues. \
             \n Also, where the matches were played and if home team won or not, if yes by what score,  \
             You can select various parameters to filter the data and analyze the results accordingly.  \
             \n Also you can choose to predict the outcomes for future matches based on historical data.  ")
    
    st.write('\n'
    '\n')


    @st.cache_data
    def load_match_data():
        return conn.query('SELECT * from match_data ')
    df_matches = load_match_data()

    leagues = df_matches['tournament'].unique()
    selected_league = st.selectbox("Select a league to filter the data:\
                                ", leagues)
    
    st.write('\n'
    '\n')

    home_team = df_matches[df_matches['tournament'] == selected_league]
    home_team = home_team['home_team'].unique()
    selected_home_team = st.selectbox("Select a home team to filter the data:\
                                    ", home_team)
    
    st.write('\n'
    '\n')
    selected_choice = st.selectbox("Do you want to see only matches where home team is playing in their country?\
                ", ['Yes', 'No'])
    

    if selected_league and selected_home_team:
        if selected_choice == 'No':
            filtered_data = df_matches[(df_matches['tournament'] == selected_league) & (df_matches['home_team'] == selected_home_team)]
        else:
            filtered_data = df_matches[(df_matches['tournament'] == selected_league) & (df_matches['home_team'] == selected_home_team) & (df_matches['home_team'] == df_matches['country'])]

        if not filtered_data.empty:

            st.write(f"Displaying match results for league: {selected_league} and team: {selected_home_team}")
            filtered_data.drop(columns=['id'], inplace=True)
            st.dataframe(filtered_data)

            st.markdown(f"<p style='color: green; font-weight: bold;'>Team {selected_home_team} won {filtered_data['team_win'].sum()}\
                         out of {len(filtered_data)} matches played in {selected_league} league.</p>", unsafe_allow_html=True)
            
            fig = px.pie(filtered_data.replace({'team_win': {1: 'Home Team Win', 0: 'Away Team Win'}}),\
                        names='team_win', title=f'Match Outcomes for {selected_home_team} in {selected_league} League', \
                        color_discrete_sequence=px.colors.sequential.RdBu)
            
            st.plotly_chart(fig, use_container_width=True)
            
        else:
            st.write("No data found for the selected filters.")
        



if chosen_option == values[2]:
    st.header("Former Team Names Analysis")
    st.write("Soccer teams changed their names over time, you can use this visualization \
             to see current names by selecting the former names of players or vice versa.")
    
    @st.cache_data
    def load_former_names_data():
        return conn.query('SELECT * from former_names ')
    df_former = load_former_names_data()

    # Searching names
    former_names_list = df_former['former'].unique()

    former_current = st.selectbox("Do you want to select by former name or current name?\
                                 ", ['Select by former name', 'Select by current name'])
    
    if former_current == 'Select by former name':
        selected_former = st.selectbox("Select a former name of a player:\
                                    ", former_names_list)
        if selected_former:
            output = df_former[df_former['former'] == selected_former]

            if not output.empty:
                current_name = output['current_name'].iloc[0]
                start_date = output['start_date'].iloc[0]
                end_date = output['end_date'].iloc[0]
                
                st.markdown(f"<p style='color: blue; font-weight: bold;'>Current Name: {current_name}</p>", unsafe_allow_html=True)

                st.write(f"Name Change Duration: {start_date.date()} to {end_date.date()}")

                fig = px.timeline(output, x_start="start_date", x_end="end_date", y="former", \
                                title=f"Time during which the team still had used the name {selected_former}"\
                                    , color_discrete_sequence=['purple'], height=300)
                fig.update_yaxes(autorange="reversed") 
                # Reverse the y-axis to have the earliest date at the top for better view

                st.plotly_chart(fig, use_container_width=True)

        else:
            st.write("No data found")

    else:
        
        selected_current = st.selectbox("Select current team name:\
                                    ", df_former['current_name'].unique())
        
        if selected_current:
            output = df_former[df_former['current_name'] == selected_current]

            if not output.empty:
                former_name = output['former'].iloc[0]
                start_date = output['start_date'].iloc[0]
                end_date = output['end_date'].iloc[0]
                
                st.markdown(f"<p style='color: blue; font-weight: bold;'>Former Name: {former_name}</p>", unsafe_allow_html=True)
                st.write(f"Name Change Duration: {start_date.date()} to {end_date.date()}")

                fig = px.timeline(output, x_start="start_date", x_end="end_date", y="current_name", \
                                title=f"Time during which the team still had used the name {former_name}"\
                                    , color_discrete_sequence=['purple'], height=300)
                fig.update_yaxes(autorange="reversed") 
                # Reverse the y-axis to have the earliest date at the top for better view

                st.plotly_chart(fig, use_container_width=True)

            else:
                st.write("No data found")



if chosen_option == values[3]:
    st.header("Match Outcome Prediction Model")

    st.write('\n'
    '\n')


    st.write("Predict if the home team will win based on historical match data.\
             \n Select the parameters below to make a prediction.")
    
    st.write('\n'
    '\n')

    @st.cache_data 
    def load_assets():
        encoder = joblib.load('encoder.pkl')
        model = joblib.load('model.pkl')
        return encoder, model
    
    encoder, model = load_assets()

    col1, col2 = st.columns(2)

    with col1:
        home_team = st.selectbox("Home Team", encoder.categories_[0])
        country = st.selectbox("Country", encoder.categories_[4])


    with col2:
        away_team = st.selectbox("Away Team", encoder.categories_[1])
        tournament = st.selectbox("Tournament", encoder.categories_[2])

    input_df = pd.DataFrame([[home_team, away_team, tournament, '', country]], 
                            columns=['home_team', 'away_team', 'tournament', 'city', 'country'])

    # Transform and Predict
    input_encoded = encoder.transform(input_df)
    prediction = model.predict_proba(input_encoded)

    st.markdown(f'<p style="color: brown; font-weight: bold;">{prediction[0][1]*100:.2f}% chance that Home Team wins.</p>', unsafe_allow_html=True)