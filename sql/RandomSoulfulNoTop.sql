-- RandomSoulfulNoTop
-- All tracks that have been reviewed (=played), are enabled, are Soulful (tag=Soulful House) and they are not top tracks (rating <> 2)
-- Also exclude all tracks that their rating is 1 (1=bad)
USE librarydb;
SELECT
        CONCAT("https://s3-eu-west-1.amazonaws.com/",MID(song.file, 19)) filename
FROM
        song
        INNER JOIN tag_map ON song.id = tag_map.object_id
        INNER JOIN tag ON tag.id = tag_map.tag_id
        LEFT OUTER JOIN rating ON song.id = rating.object_id
WHERE
        song.played = 1
        AND song.enabled = 1
        AND tag.name = "Soulful House"
--        AND ((rating.rating <> 1 AND rating.rating <> 2) OR rating.rating IS NULL)
    	AND (rating.rating IS NULL OR rating.rating=0) -- the above line was unnecessary, also added 0 (Dsub updates 0 and not null when removing rating)
        AND tag_map.object_type = "song"
	AND song.title NOT LIKE '%pella%' AND song.title NOT LIKE '%beats%' AND song.title NOT LIKE '%reprise%' AND song.title NOT LIKE '%tool%'
        ;

