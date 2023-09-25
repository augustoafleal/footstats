CREATE OR REPLACE PROCEDURE public.stp_summary_playerstats(
	)
LANGUAGE 'plpgsql'
AS $BODY$

BEGIN

WITH temp_history AS  (
SELECT
	NAME,
	NATIONALITY,
	"position",
	TEAM,
	AGE,
	GAMES,
	GAMES_STARTS,
	MINUTES,
	MINUTES_90S,
	GOALS,
	ASSISTS,
	GOALS_ASSISTS,
	GOALS_PENS,
	PENS_MADE,
	PENS_ATT,
	CARDS_YELLOW,
	CARDS_RED,
	XG,
	NPXG,
	XG_ASSIST,
	NPXG_XG_ASSIST,
	PROGRESSIVE_CARRIES,
	PROGRESSIVE_PASSES,
	PROGRESSIVE_PASSES_RECEIVED,
	GOALS_PER90,
	ASSISTS_PER90,
	GOALS_ASSISTS_PER90,
	GOALS_PENS_PER90,
	GOALS_ASSISTS_PENS_PER90,
	XG_PER90,
	XG_ASSIST_PER90,
	XG_XG_ASSIST_PER90,
	NPXG_PER90,
	NPXG_XG_ASSIST_PER90
FROM
	PUBLIC.HISTORY_PLAYERSTATS
WHERE
	TO_CHAR(CREATED_DATE, 'YYYY-MM-DD') = TO_CHAR(NOW() - INTERVAL '3 HOUR', 'YYYY-MM-DD')
)

INSERT INTO
	public.summary_playerstats (
		NAME,
		NATIONALITY,
		"position",
		TEAM,
		AGE,
		GAMES,
		GAMES_STARTS,
		MINUTES,
		MINUTES_90S,
		GOALS,
		ASSISTS,
		GOALS_ASSISTS,
		GOALS_PENS,
		PENS_MADE,
		PENS_ATT,
		CARDS_YELLOW,
		CARDS_RED,
		XG,
		NPXG,
		XG_ASSIST,
		NPXG_XG_ASSIST,
		PROGRESSIVE_CARRIES,
		PROGRESSIVE_PASSES,
		PROGRESSIVE_PASSES_RECEIVED,
		GOALS_PER90,
		ASSISTS_PER90,
		GOALS_ASSISTS_PER90,
		GOALS_PENS_PER90,
		GOALS_ASSISTS_PENS_PER90,
		XG_PER90,
		XG_ASSIST_PER90,
		XG_XG_ASSIST_PER90,
		NPXG_PER90,
		NPXG_XG_ASSIST_PER90,
		CREATED_DATE
	)
SELECT
	history.name,
	history.nationality,
	history."position",
	history.team,
	history.age,
	history.games,
	history.games_starts,
	history.minutes,
	history.minutes_90s,
	history.goals,
	history.assists,
	history.goals_assists,
	history.goals_pens,
	history.pens_made,
	history.pens_att,
	history.cards_yellow,
	history.cards_red,
	history.xg,
	history.npxg,
	history.xg_assist,
	history.npxg_xg_assist,
	history.progressive_carries,
	history.progressive_passes,
	history.progressive_passes_received,
	history.goals_per90,
	history.assists_per90,
	history.goals_assists_per90,
	history.goals_pens_per90,
	history.goals_assists_pens_per90,
	history.xg_per90,
	history.xg_assist_per90,
	history.xg_xg_assist_per90,
	history.npxg_per90,
	history.npxg_xg_assist_per90,
	TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'America/Sao_Paulo', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp(3) AS CREATED_DATE
FROM
	temp_history history 
ON CONFLICT (NAME) DO
UPDATE
SET
	NATIONALITY = excluded.nationality,
	"position" = excluded."position",
	TEAM = excluded.team,
	AGE = excluded.age,
	GAMES = excluded.games,
	GAMES_STARTS = excluded.games_starts,
	MINUTES = excluded.minutes,
	MINUTES_90S = excluded.minutes_90s,
	GOALS = excluded.goals,
	ASSISTS = excluded.assists,
	GOALS_ASSISTS = excluded.goals_assists,
	GOALS_PENS = excluded.goals_pens,
	PENS_MADE = excluded.pens_made,
	PENS_ATT = excluded.pens_att,
	CARDS_YELLOW = excluded.cards_yellow,
	CARDS_RED = excluded.cards_red,
	XG = excluded.xg,
	NPXG = excluded.npxg,
	XG_ASSIST = excluded.xg_assist,
	NPXG_XG_ASSIST = excluded.npxg_xg_assist,
	PROGRESSIVE_CARRIES = excluded.progressive_carries,
	PROGRESSIVE_PASSES = excluded.progressive_passes,
	PROGRESSIVE_PASSES_RECEIVED = excluded.progressive_passes_received,
	GOALS_PER90 = excluded.goals_per90,
	ASSISTS_PER90 = excluded.assists_per90,
	GOALS_ASSISTS_PER90 = excluded.goals_assists_per90,
	GOALS_PENS_PER90 = excluded.goals_pens_per90,
	GOALS_ASSISTS_PENS_PER90 = excluded.goals_assists_pens_per90,
	XG_PER90 = excluded.xg_per90,
	XG_ASSIST_PER90 = excluded.xg_assist_per90,
	XG_XG_ASSIST_PER90 = excluded.xg_xg_assist_per90,
	NPXG_PER90 = excluded.npxg_per90,
	NPXG_XG_ASSIST_PER90 = excluded.npxg_xg_assist_per90,
	MODIFIED_DATE = TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE 'America/Sao_Paulo', 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp(3)
WHERE
	summary_playerstats.name = excluded.name
	AND (
		summary_playerstats.NATIONALITY <> excluded.nationality
		OR summary_playerstats."position" <> excluded."position"
		OR summary_playerstats.TEAM <> excluded.team
		OR summary_playerstats.AGE <> excluded.age
		OR summary_playerstats.GAMES <> excluded.games
		OR summary_playerstats.GAMES_STARTS <> excluded.games_starts
		OR summary_playerstats.MINUTES <> excluded.minutes
		OR summary_playerstats.GOALS_ASSISTS <> excluded.goals_assists
		OR summary_playerstats.GOALS_PENS <> excluded.goals_pens
		OR summary_playerstats.PENS_MADE <> excluded.pens_made
		OR summary_playerstats.PENS_ATT <> excluded.pens_att
		OR summary_playerstats.CARDS_YELLOW <> excluded.cards_yellow
		OR summary_playerstats.CARDS_RED <> excluded.cards_red
		OR summary_playerstats.XG <> excluded.xg
		OR summary_playerstats.NPXG <> excluded.npxg
		OR summary_playerstats.XG_ASSIST <> excluded.xg_assist
		OR summary_playerstats.NPXG_XG_ASSIST <> excluded.npxg_xg_assist
		OR summary_playerstats.PROGRESSIVE_CARRIES <> excluded.progressive_carries
		OR summary_playerstats.PROGRESSIVE_PASSES <> excluded.progressive_passes
		OR summary_playerstats.PROGRESSIVE_PASSES_RECEIVED <> excluded.progressive_passes_received
		OR summary_playerstats.GOALS_PER90 <> excluded.goals_per90
		OR summary_playerstats.ASSISTS_PER90 <> excluded.assists_per90
		OR summary_playerstats.GOALS_ASSISTS_PER90 <> excluded.goals_assists_per90
		OR summary_playerstats.GOALS_PENS_PER90 <> excluded.goals_pens_per90
		OR summary_playerstats.GOALS_ASSISTS_PENS_PER90 <> excluded.goals_assists_pens_per90
		OR summary_playerstats.XG_ASSIST_PER90 <> excluded.xg_assist_per90
		OR summary_playerstats.XG_XG_ASSIST_PER90 <> excluded.xg_xg_assist_per90
		OR summary_playerstats.NPXG_PER90 <> excluded.npxg_per90
		OR summary_playerstats.NPXG_XG_ASSIST_PER90 <> excluded.npxg_xg_assist_per90
	);
END;

$BODY$;