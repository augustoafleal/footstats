import requests
from bs4 import BeautifulSoup
import psycopg2
from datetime import datetime
from pytz import timezone
import dbconfigs 

page = requests.get("https://fbref.com/en/squads/d5ae3703/Gremio-Stats")
soup = BeautifulSoup(page.text, "html.parser")

#Remove thead and tfoot
tags = ["thead", "tfoot"]
for i in tags:
    for tag in soup.find_all(i):
        tag.decompose() 

# Insert table
tableStats = soup.find(class_="table_container tabbed current")
tableStatsColumns = tableStats.findAll('tr')

results = []

for th in tableStatsColumns:
    key = th.find('th').text
    data = th.find_all(['td', 'span', 'a'])
    if len(data) > 0:
        name = data[0].string
        nationality = data[4].string
        position = data[5].string
        age = data[6].string
        games = data[7].string
        games_starts = data[8].string
        minutes = data[9].string.replace(",", "")
        minutes_90s = data[10].string
        goals = data[11].string
        assists = data[12].string
        goals_assists = data[13].string
        goals_pens = data[14].string
        pens_made = data[15].string
        pens_att = data[16].string
        cards_yellow = data[17].string
        cards_red = data[18].string
        xg = data[19].string
        npxg = data[20].string
        xg_assist = data[21].string
        npxg_xg_assist = data[22].string
        progressive_carries = data[23].string
        progressive_passes = data[24].string
        progressive_passes_received = data[25].string
        goals_per90 = data[26].string
        assists_per90 = data[27].string
        goals_assists_per90 = data[28].string
        goals_pens_per90 = data[29].string
        goals_assists_pens_per90 = data[30].string
        xg_per90 = data[31].string
        xg_assist_per90 = data[32].string
        xg_xg_assist_per90 = data[33].string
        npxg_per90 = data[34].string
        npxg_xg_assist_per90 = data[35].string

        # adiciona dados no array
        results.append([
            name, nationality, position, age, games, games_starts, minutes,
            minutes_90s, goals, assists, goals_assists, goals_pens, pens_made,
            pens_att, cards_yellow, cards_red, xg, npxg, xg_assist,
            npxg_xg_assist, progressive_carries, progressive_passes,
            progressive_passes_received, goals_per90, assists_per90,
            goals_assists_per90, goals_pens_per90, goals_assists_pens_per90,
            xg_per90, xg_assist_per90, xg_xg_assist_per90, npxg_per90,
            npxg_xg_assist_per90
        ])

#  Create DB connection
conn = psycopg2.connect(
    database="DB_footStats",
    user=dbconfigs.username,
    password=dbconfigs.password,
    host='localhost',
    port='5432'
)

cursor = conn.cursor()

# Set actual time
date = datetime.now()
tz = timezone('America/Sao_Paulo')
date_br = date.astimezone(tz).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]

# Persist values in table 
for index in range(0, len(results)):
    name = results[index][0]
    nationality = results[index][1]
    position = results[index][2]
    age = results[index][3].split("-")[0]
    games = results[index][4]
    games_starts = results[index][5]
    minutes = results[index][6]
    minutes_90s = results[index][7]
    goals = results[index][8]
    assists = results[index][9]
    goals_assists = results[index][10]
    goals_pens = results[index][11]
    pens_made = results[index][12]
    pens_att = results[index][13]
    cards_yellow = results[index][14]
    cards_red = results[index][15]
    xg = results[index][16]
    npxg = results[index][17]
    xg_assist = results[index][18]
    npxg_xg_assist = results[index][19]
    progressive_carries = results[index][20]
    progressive_passes = results[index][21]
    progressive_passes_received = results[index][22]
    goals_per90 = results[index][23]
    assists_per90 = results[index][24]
    goals_assists_per90 = results[index][25]
    goals_pens_per90 = results[index][26]
    goals_assists_pens_per90 = results[index][27]
    xg_per90 = results[index][28]
    xg_assist_per90 = results[index][29]
    xg_xg_assist_per90 = results[index][30]
    npxg_per90 = results[index][31]
    npxg_xg_assist_per90 = results[index][32]
    team = "Gremio"
    created_date = date_br

    cursor.execute("""INSERT INTO history_playerstats 
                 (name, nationality, position, team, age, games, games_starts, minutes, minutes_90s, goals, assists, goals_assists, goals_pens, pens_made, pens_att, cards_yellow, cards_red, xg, npxg, xg_assist, npxg_xg_assist, progressive_carries, progressive_passes, progressive_passes_received, goals_per90, assists_per90, goals_assists_per90, goals_pens_per90, goals_assists_pens_per90, xg_per90, xg_assist_per90, xg_xg_assist_per90, npxg_per90, npxg_xg_assist_per90, created_date)
                 VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);""", (name, nationality, position, team, age, games, games_starts, minutes, minutes_90s, goals, assists, goals_assists, goals_pens, pens_made, pens_att, cards_yellow, cards_red, xg, npxg, xg_assist, npxg_xg_assist, progressive_carries, progressive_passes, progressive_passes_received, goals_per90, assists_per90, goals_assists_per90, goals_pens_per90, goals_assists_pens_per90, xg_per90, xg_assist_per90, xg_xg_assist_per90, npxg_per90, npxg_xg_assist_per90, created_date,))

conn.commit()

conn.close()
