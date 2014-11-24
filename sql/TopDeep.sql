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
WHERE
        song.played = 1
        AND song.enabled = 1
        AND tag.name = "Deep House"
        AND rating.rating = 5
	AND tag_map.object_type = "song"
        AND rating.object_type = "song"
        ;

