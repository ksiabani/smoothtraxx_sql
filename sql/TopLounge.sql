-- TopDeepAfro:
-- All tracks that have been reviewed (=played), are enabled, are Deep House or Afro House and their ratings is 2 (2=top)

USE librarydb;
SELECT
        CONCAT("https://s3-eu-west-1.amazonaws.com/",MID(song.file, 19)) filename
FROM
        song
        INNER JOIN tag_map ON song.id = tag_map.object_id
        INNER JOIN tag ON tag.id = tag_map.tag_id
        INNER JOIN rating ON song.id = rating.object_id
        INNER JOIN song_data ON song.id=song_data.song_id
WHERE
        song.played = 1
        AND song.enabled = 1
        AND (tag.name = "Lounge / Chill Out" OR tag.name = "Broken Beat / Nu-Jazz" OR tag.name = "Afro / Latin / Brazilian")
        AND rating.rating = 5
	    AND tag_map.object_type = "song"
        AND rating.object_type = "song"
        -- must be less than 3 months old
        AND     DATEDIFF(CURDATE(),
            CASE
                WHEN LOCATE("\"", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(" ", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(":", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(",", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) <> 0 THEN NULL
                ELSE MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)
            END) < 90
        ;