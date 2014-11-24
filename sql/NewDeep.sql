-- NewDeep:
-- All tracks that have been reviewed (=played), are enabled, are Deep House and their release date is smaller than 1 month old
-- Also exclude all tracks that their rating is 1 (1=bad)

USE librarydb;
SELECT
        CONCAT("https://s3-eu-west-1.amazonaws.com/",MID(song.file, 19)) filename
FROM
        song
        INNER JOIN tag_map ON song.id = tag_map.object_id
        INNER JOIN tag ON tag.id = tag_map.tag_id
        LEFT OUTER JOIN rating ON song.id = rating.object_id AND rating.object_type = "song"
        INNER JOIN song_data ON song.id=song_data.song_id
WHERE
        song.played = 1
        AND song.enabled = 1
        AND tag.name = "Deep House"
        AND (rating.rating <> 1 OR rating.rating IS NULL)
        AND tag_map.object_type = "song"
        AND     DATEDIFF(CURDATE(),
        CASE
                WHEN LOCATE("\"", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(" ", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(":", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(",", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) <> 0 THEN NULL
                ELSE MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)
        END) < 31
	AND song.title NOT LIKE '%pella%' AND song.title NOT LIKE '%beats%' AND song.title NOT LIKE '%reprise%' AND song.title NOT LIKE '%tool%'
        ;

