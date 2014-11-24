
SELECT	
	@rownum := @rownum + 1 AS id        
	, song.id AS song_id        
	, song.file        
	, song.catalog        
	, song.album        
	, song.year        
	, song.artist        
	, song.title        
	, song.bitrate        
	, song.rate        
	, song.mode        
	, song.size        
	, song.time        
	, song.track        
	, song.played        
	, song.enabled        
	, song.update_time        
	, song.addition_time	
	, user1.username AS tag_user        
	, tag.id AS tag_id        
	, tag.name AS tag        
	, user2.username AS rating_user        
	, rating.rating AS rating  	
	, CASE	
		WHEN DATEDIFF(CURDATE(),
	 		CASE
				WHEN LOCATE("\"", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(" ", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(":", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) + LOCATE(",", MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)) <> 0 THEN NULL				
				ELSE MID(LANGUAGE, LOCATE("reldate", LANGUAGE)+10, 10)			
			END) < 31 THEN 1		
			ELSE 0 	END AS is_new
FROM
        song
        LEFT OUTER JOIN tag_map ON song.id = tag_map.object_id AND tag_map.object_type = "song"
        INNER JOIN tag ON tag.id = tag_map.tag_id        
        LEFT OUTER JOIN rating ON song.id = rating.object_id AND rating.object_type = "song"        
        INNER JOIN song_data ON song.id=song_data.song_id        
        LEFT OUTER JOIN `user` AS user1 ON user1.id = tag_map.user        
        LEFT OUTER JOIN `user` AS user2 ON user2.id = rating.user        
        CROSS JOIN (SELECT @rownum := 0) rs
        
        