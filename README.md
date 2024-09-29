# Spotify Advanced SQL Project and 
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 2. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 5. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.

```sql
select 
	* 
from spotify
where stream > 1000000000

```
2. List all albums along with their respective artists.

```sql

select 
	distinct album,
	artist 
from spotify
order by 1

```
3. Get the total number of comments for tracks where `licensed = TRUE`.

```sql
select 
	sum(comments) 
from spotify
where licensed='true'

```

4. Find all tracks that belong to the album type `single`.

```sql
select 
	track 
from spotify
where album_type='single'

```
5. Count the total number of tracks by each artist.

```sql
select 
	artist,
	count(track) as total_no_songs 
from spotify
group by artist
order by 2 desc

```

### Medium Level
1. Calculate the average danceability of tracks in each album.

```sql
select 
	album, 
	avg(danceability) as avg_danceability 
from spotify
group by 1
order by 2 desc

```
2. Find the top 5 tracks with the highest energy values.

```sql
select 
	track, 
	max(energy) 
from spotify
group by 1
order by 2 desc
limit 5

```

3. List all tracks along with their views and likes where `official_video = TRUE`.

```sql
select 
	track,
	sum(views) as total_views,
	sum(likes) as total_likes 
from spotify
where official_video='true'
group by 1
order by 2 desc
limit 5

```
4. For each album, calculate the total views of all associated tracks.

```sql
select 
	album, 
	track, 
	sum(views) as total_views 
from spotify
group by 1,2
order by 3 desc

```
5. Retrieve the track names that have been streamed on Spotify more than YouTube.

```sql
select * from
(select
	track,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_youtube,
	coalesce(sum(case when most_played_on = 'Spotify' then stream end),0) as streamed_on_spotify
from spotify
group by 1
) as t1
where streamed_on_spotify>streamed_on_youtube and streamed_on_youtube <> 0

```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.

```sql
with artist_rank
as
(select
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

```
2. Write a query to find tracks where the liveness score is above the average.

```sql
select 
	track,
	artist,
	liveness
from spotify
where liveness > (select avg(liveness) from spotify)

```
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
```
   
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.

```sql
select 
	*
from spotify 
where energy/liveness > 1.2

```
5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

```sql
select 
	track,
	sum(likes) over (order by views) AS cumulative_sum
FROM Spotify
	order by sum(likes) over (order by views) desc ;

```
---


## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.


