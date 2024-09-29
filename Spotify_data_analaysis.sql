select * from spotify
limit 100

----------- EDA -----------

-- 1. Find how many records in the table

select count(*) from spotify

--- 2. Find how many artists in the table

select count(distinct artist) from spotify

--- 3. Find the unique album type

select distinct album_type from spotify

--- 4. Find the song which has maximum duration

SELECT * 
FROM (
    SELECT *, 
           MAX(duration_min) OVER () AS max_duration
    FROM spotify
) AS subquery
WHERE duration_min = max_duration;

---- 5. Identify the incorrect data 

select * from spotify
where duration_min=0

--- 6. Removing the incorrect data

delete from spotify
where duration_min=0


-- find the number of unique channel

select count(distinct channel) from spotify 


------------------------------------------------------------------------
-------- Data Analysis Easy Level

--------------------------------------------

---- 1. Retrieve the names of all tracks that have more than 1 billion streams.

select 
	* 
from spotify
where stream > 1000000000

---- 2.List all albums along with their respective artists.

select 
	distinct album,
	artist 
from spotify
order by 1


---- 3. Get the total number of comments for tracks where licensed = TRUE.\

select 
	sum(comments) 
from spotify
where licensed='true'


---- 4. Find all tracks that belong to the album type single.

select 
	track 
from spotify
where album_type='single'

---- 5. Count the total number of tracks by each artist.

select 
	artist,
	count(track) as total_no_songs 
from spotify
group by artist
order by 2 desc


--------------------------------------------------------------------------------------
--- Data Analysis Medium Level
--------------------------------------------------------------------------------------

-------- 1. Calculate the average danceability of tracks in each album.

select 
	album, 
	avg(danceability) as avg_danceability 
from spotify
group by 1
order by 2 desc

-------- 2. Find the top 5 tracks with the highest energy values.

select 
	track, 
	max(energy) 
from spotify
group by 1
order by 2 desc
limit 5

-------- 3. List all tracks along with their views and likes where official_video = TRUE.

select 
	track,
	sum(views) as total_views,
	sum(likes) as total_likes 
from spotify
where official_video='true'
group by 1
order by 2 desc
limit 5

-------- 4. For each album, calculate the total views of all associated tracks.

select 
	album, 
	track, 
	sum(views) as total_views 
from spotify
group by 1,2
order by 3 desc

-------- 5. Retrieve the track names that have been streamed on Spotify more than YouTube.

select * from
(select
	track,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_youtube,
	coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1
) as t1
where streamed_on_spotify>streamed_on_youtube and streamed_on_youtube <> 0


--------------------------------------------------------------------------------------
--- Data Analysis Advanced Level
--------------------------------------------------------------------------------------

----- 11. Find the top 3 most-viewed tracks for each artist using window functions.

with artist_rank
as
(
select
	artist,
	track,
	sum(views) as total_views,
	dense_rank() over(partition by artist order by sum(views) desc ) as rank
from spotify
group by 1,2
order by 1,3 desc
)
select * from artist_rank
where rank<=3


----- 12. Write a query to find tracks where the liveness score is above the average.

select 
	track,
	artist,
	liveness
from spotify
where liveness > (select avg(liveness) from spotify)

-------- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album
with energy_difference
as
(
select 
	album,
	max(energy) as highest_energy,
	min(energy) as lowest_energy
from spotify
group by 1
)
select album, (highest_energy - lowest_energy) as enegery_difference 
from energy_difference
order by 2 desc

------- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

select 
	*
from spotify 
where energy/liveness > 1.2


-------------- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

select 
	track,
	sum(likes) over (order by views) AS cumulative_sum
FROM Spotify
	order by sum(likes) over (order by views) desc ;


