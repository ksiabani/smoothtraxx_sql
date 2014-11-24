-- Create library playlists:
-- id	name
-- 1	Soulful House (reviewed)
-- 2	Soulful House (latest releases)
-- 3	Soulful House (top tracks)
-- 4	Soulful House (unreviewed)
-- 5	Deep House (reviewed)
-- 6	Deep House (latest releases)
-- 7	Deep House (top tracks)
-- 8	Deep House (unreviewed)
-- 9	Afro House (reviewed)
-- 10	Afro House (latest releases)
-- 11	Afro House (top tracks)
-- 12	Afro House (unreviewed)
-- 13   House
-- 14   Broken Beat / Nu-Jazz
-- 15   Lounge / Chill Out (reviewed)
-- 16   Lounge / Chill Out (unreviewed)
-- 17   R&B / Hip Hop
-- 18   Soul / Funk / Disco

USE librarydb;

-- Delete and recreate all playlists from PLAYLIST. Why? Because it seems like Ampache deletes/cleans empty playlists at some point

DELETE FROM playlist;
INSERT INTO playlist (id, NAME, USER, TYPE, DATE) 
VALUES 
( 1, 'Soulful House (reviewed)', 2, 'public', '1412665119'),
( 2, 'Soulful House (latest releases)', 2, 'public', '1412665119'),
( 3, 'Soulful House (top tracks)', 2, 'public', '1412665119'),
( 4, 'Soulful House (unreviewed)', 2, 'public', '1412665119'),
( 5, 'Deep House (reviewed)', 2, 'public', '1412665119'),
( 6, 'Deep House (latest releases)', 2, 'public','1412665119'),
( 7, 'Deep House (top tracks)', 2, 'public', '1412665119'),
( 8, 'Deep House (unreviewed)', 2, 'public', '1412665119'),
( 9, 'Afro House (reviewed)', 2, 'public', '1412665119'),
( 10, 'Afro House (latest releases)', 2, 'public', '1412665119'),
( 11, 'Afro House (top tracks)', 2, 'public', '1412665119'),
( 12, 'Afro House (unreviewed)', 2, 'public', '1412665119'),
( 13, 'House', 2, 'public', '1412665119'),
( 14, 'Broken Beat / Nu-Jazz', 2, 'public', '1412665119'),
( 15, 'Lounge / Chill Out (reviewed)', 2, 'public', '1412665119'),
( 16, 'Lounge / Chill Out (unreviewed)', 2, 'public', '1412665119'),
( 17, 'R&B / Hip Hop', 2, 'public', '1412665119'),
( 18, 'Soul / Funk / Disco', 2, 'public', '1412665119');

-- Delete and recreate PLAYLIST_DATA

-- 1	Soulful House (reviewed)
-- All tracks that have been reviewed (=played), are enabled, are Soulful (tag=Soulful House) and their rating is not 1 (1=bad track)

DELETE FROM playlist_data WHERE playlist=1;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	1
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	LEFT OUTER JOIN rating ON song.id = rating.object_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Soulful House"
  	AND (rating.rating <> 1 OR rating.rating IS NULL)
	AND tag_map.object_type = "song"
	;


-- 2	Soulful House (latest releases)
-- All tracks that have been reviewed (=played), are enabled, are Soulful (tag=Soulful House) and their release date is smaller than 1 month old
-- Also exclude all tracks that their rating is 1 (1=bad)

DELETE FROM playlist_data WHERE playlist=2;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	2
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	LEFT OUTER JOIN rating ON song.id = rating.object_id AND rating.object_type = "song"
	INNER JOIN song_data ON song.id=song_data.song_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Soulful House"
	AND (rating.rating <> 1 OR rating.rating IS NULL)
	AND tag_map.object_type = "song"
	AND 	DATEDIFF(CURDATE(), 
	CASE
		WHEN LOCATE("\"", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(" ", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(":", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(",", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) <> 0 THEN NULL
		ELSE MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10) 
	END) < 31
	;


-- 3	Soulful House (top tracks)
-- All tracks that have been reviewed (=played), are enabled, are Soulful (tag=Soulful House) and their ratings is 2 (2=top)

DELETE FROM playlist_data WHERE playlist=3;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	3
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	INNER JOIN rating ON song.id = rating.object_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Soulful House"
	AND rating.rating = 5
	AND tag_map.object_type = "song"
	AND rating.object_type = "song"	
	;


-- 4	Soulful House (unreviewed)
-- Basically all soulful tracks that have not been reviewed (not played) but are enabled

DELETE FROM playlist_data WHERE playlist=4;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	4
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 0
	AND song.enabled = 1
	AND tag.name = "Soulful House"
	AND tag_map.object_type = "song"
	;


-- 5	Deep House (reviewed)

DELETE FROM playlist_data WHERE playlist=5;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	5
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	LEFT OUTER JOIN rating ON song.id = rating.object_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Deep House"
  	AND (rating.rating <> 1 OR rating.rating IS NULL)
	AND tag_map.object_type = "song"
	;


-- 6	Deep House (latest releases)

DELETE FROM playlist_data WHERE playlist=6;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	6
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	LEFT OUTER JOIN rating ON song.id = rating.object_id AND rating.object_type = "song"
	INNER JOIN song_data ON song.id=song_data.song_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Deep House"
	AND (rating.rating <> 1 OR rating.rating IS NULL)
	AND tag_map.object_type = "song"
	AND 	DATEDIFF(CURDATE(), 
	CASE
		WHEN LOCATE("\"", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(" ", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(":", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(",", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) <> 0 THEN NULL
		ELSE MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10) 
	END) < 31
	;


-- 7	Deep House (top tracks)

DELETE FROM playlist_data WHERE playlist=7;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	7
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	INNER JOIN rating ON song.id = rating.object_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Deep House"
	AND rating.rating = 5
	AND tag_map.object_type = "song"
	AND rating.object_type = "song"	
	;


-- 8	Deep House (unreviewed)

DELETE FROM playlist_data WHERE playlist=8;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	8
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 0
	AND song.enabled = 1
	AND tag.name = "Deep House"
	AND tag_map.object_type = "song"
	;


-- 9	Afro House (reviewed)

DELETE FROM playlist_data WHERE playlist=9;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	9
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	LEFT OUTER JOIN rating ON song.id = rating.object_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Afro House"
  	AND (rating.rating <> 1 OR rating.rating IS NULL)
	AND tag_map.object_type = "song"
	;


-- 10	Afro House (latest releases)

DELETE FROM playlist_data WHERE playlist=10;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	10
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	LEFT OUTER JOIN rating ON song.id = rating.object_id AND rating.object_type = "song"
	INNER JOIN song_data ON song.id=song_data.song_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Afro House"
	AND (rating.rating <> 1 OR rating.rating IS NULL)
	AND tag_map.object_type = "song"
	AND 	DATEDIFF(CURDATE(), 
	CASE
		WHEN LOCATE("\"", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(" ", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(":", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(",", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) <> 0 THEN NULL
		ELSE MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10) 
	END) < 31
	;


-- 11	Afro House (top tracks)

DELETE FROM playlist_data WHERE playlist=11;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	11
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	INNER JOIN rating ON song.id = rating.object_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Afro House"
	AND rating.rating = 5
	AND tag_map.object_type = "song"
	AND rating.object_type = "song"	
	;

-- 12	Afro House (unreviewed)

DELETE FROM playlist_data WHERE playlist=12;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	12
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 0
	AND song.enabled = 1
	AND tag.name = "Afro House"
	AND tag_map.object_type = "song"
	;


-- 13   House

DELETE FROM playlist_data WHERE playlist=13;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	13
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
WHERE
	song.enabled = 1
	AND tag.name = "House"
	AND tag_map.object_type = "song"
	;


-- 14   Broken Beat / Nu-Jazz

DELETE FROM playlist_data WHERE playlist=14;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	14
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
WHERE
	song.enabled = 1
	AND tag.name = "Broken Beat / Nu-Jazz"
	AND tag_map.object_type = "song"
	;

	
-- 15   Lounge / Chill Out (reviewed)

DELETE FROM playlist_data WHERE playlist=15;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	15
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	LEFT OUTER JOIN rating ON song.id = rating.object_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 1
	AND song.enabled = 1
	AND tag.name = "Lounge / Chill Out"
  	AND (rating.rating <> 1 OR rating.rating IS NULL)
	AND tag_map.object_type = "song"
	;


-- 16   Lounge / Chill Out (unreviewed)

DELETE FROM playlist_data WHERE playlist=16;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	16
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
	CROSS JOIN (SELECT @rownum := 0) rs	
WHERE
	song.played = 0
	AND song.enabled = 1
	AND tag.name = "Lounge / Chill Out"
	AND tag_map.object_type = "song"
	;
	

-- 17   R&B / Hip Hop

DELETE FROM playlist_data WHERE playlist=17;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	17
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
WHERE
	song.enabled = 1
	AND tag.name = "R&B / Hip Hop"
	AND tag_map.object_type = "song"
	;


-- 18   Soul / Funk / Disco

DELETE FROM playlist_data WHERE playlist=18;
INSERT INTO playlist_data (playlist, object_id, object_type, track) 
SELECT 
	18
	, song.id
	, "song"
	, @rownum := @rownum + 1
FROM 
	song 
	INNER JOIN tag_map ON song.id = tag_map.object_id
	INNER JOIN tag ON tag.id = tag_map.tag_id
WHERE
	song.enabled = 1
	AND tag.name = "Soul / Funk / Disco"
	AND tag_map.object_type = "song"
	;


-- Sources:
-- Counter addition from here: http://stackoverflow.com/questions/13566695/select-increment-counter-in-mysql
