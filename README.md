# FOOTSTATS

## Description

This is a project for web scraping with Python (using Beautiful Soup) to collect statistical data on football players, with data persistence in a PostgreSQL database (using psycopg2). Additionally, it includes data summarization within the database with scheduling via pg_cron.

## Process Steps

1. Initially, the data is collected using a [Python scraping algorithm](https://github.com/augustoafleal/footstats/blob/main/footstats.py) utilizing the Beautiful Soup library.
2. These data are then [persisted](https://github.com/augustoafleal/footstats/blob/707d6f09332ffadfbd55e0713389327437b84172/footstats.py#L76) in a PostgreSQL database table using the psycopg2 library.
3. The database in [PostgreSQL](https://github.com/augustoafleal/footstats/blob/main/database_models/database/DB_footStats.sql) is divided into two tables:

   3.1 Historical Table: [history_playerstats](https://github.com/augustoafleal/footstats/blob/main/database_models/tables/history_playerstats.sql)

   3.2 Table with summarized and consolidated data: [summary_playerstats](https://github.com/augustoafleal/footstats/blob/main/database_models/tables/summary_playerstats.sql)

5. The table with summarized data is loaded through the execution of the [stp_summary_playerstats](https://github.com/augustoafleal/footstats/blob/main/database_models/procedures/stp_summary_playerstats.sql) procedure, which inserts new data based on the player's name if it doesn't exist or updates the record if there is any different data compared to the last load.
6. The procedure is executed daily using [pg_cron](https://github.com/augustoafleal/footstats/blob/main/database_models/cron_job/cron_job.sql).
