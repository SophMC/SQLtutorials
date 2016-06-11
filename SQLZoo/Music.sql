--http://sqlzoo.net/wiki/Music_Tutorial
--The Music Database: Introducing the notion of a join.

--There are two tables in Music: album and track

--album(asin, title, artist, price, release, label, rank)
--track(album, dsk, posn, song)

--1.Find the title and artist who recorded the song 'Alison'
SELECT title, artist
FROM album JOIN track
ON (album.asin=track.album)
WHERE song = 'Alison'

--2.Which artist recorded the song 'Exodus'? 
SELECT artist
FROM album JOIN track
ON (album.asin = track.album)
WHERE song = 'Exodus'

--3.Show the song for each track on the album 'Blur'
SELECT song 
FROM track JOIN album
ON (track.album = album.asin)
WHERE title = 'Blur'

--4.We can use the aggregate functions and GROUP BY expressions on the joined table. 
SELECT title, COUNT(*)
FROM album JOIN track ON (asin=album)
GROUP BY title

--5.For each album show the title and the total number of tracks containing the word 'Heart' (albums with no such tracks need not be 
--shown). 
SELECT title, COUNT(*)
FROM album JOIN track ON (asin=album)
WHERE song LIKE '%Heart%'
GROUP BY title

--6.A "title track" is where the song is the same as the title. Find the title tracks. 
SELECT song
FROM track JOIN album ON (album=asin)
WHERE song = title

--7.An "eponymous" album is one where the title is the same as the artist (for example the album 'Blur' by the band 'Blur'). Show the 
--eponymous albums. 
SELECT title FROM album
WHERE title = artist

--8.Find the songs that appear on more than 2 albums. Include a count of the number of times each shows up. 
SELECT track.song, COUNT(DISTINCT album.title)
FROM album JOIN track
ON album.asin = track.album
GROUP BY track.song
HAVING COUNT(DISTINCT album.title) > 2

--9.A "good value" album is one where the price per track is less than 50 pence. Find the good value album - show the title, the price and 
--the number of tracks. 
SELECT title, price, count(track.song)
FROM album
JOIN track ON album.asin = track.album
GROUP BY album.title
HAVING (album.price/count(track.song)) < 0.5

--10.Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101 tracks.
--List albums so that the album with the most tracks is first. Show the title and the number of tracks

SELECT title, count(*) as trackcount
FROM album JOIN track
ON album.asin = track.album
GROUP BY album.asin
ORDER BY count(*) DESC;