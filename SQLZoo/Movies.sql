--http://sqlzoo.net/wiki/More_JOIN_operations

--Another fairly simple introduction to joins
--The database consists of three tables movie , actor and casting.

--1.List the films where the yr is 1962 [Show id, title] 
SELECT id, title
FROM movie
WHERE yr = 1962;

--2.Give year of 'Citizen Kane'. 
SELECT yr 
FROM movie
WHERE title = 'Citizen Kane'

--3.List all of the Star Trek movies, include the id, title and yr (all of 
--these movies include the words Star Trek in the title). Order results by 
--year. 
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%';

--4.What are the titles of the films with id 11768, 11955, 21191 
SELECT title
FROM movie
WHERE (id = 11768) or (id = 11955) or (id = 21191);

--5.What id number does the actress 'Glenn Close' have? 
SELECT id
FROM actor
WHERE name = 'Glenn Close';

--6.What is the id of the film 'Casablanca' 
SELECT id
FROM movie
WHERE title = 'Casablanca';

--7.Obtain the cast list for 'Casablanca'.The cast list is the names of the 
--actors who were in the movie. Use movieid=11768, this is the value that you 
--obtained in the previous question. 
SELECT name
FROM actor
JOIN casting
ON casting.actorid = actor.id
WHERE casting.movieid = 11768;

--8.Obtain the cast list for the film 'Alien' 
SELECT name
FROM actor
JOIN casting
ON casting.actorid = actor.id
JOIN movie 
ON movie.id = casting.movieid
WHERE movie.title = 'Alien';

--9.List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie
JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford';

--10.List the films where 'Harrison Ford' has appeared - but not in the 
--starring role. [Note: the ord field of casting gives the position of the 
--actor. If ord=1 then this actor is in the starring role]
SELECT title
FROM movie
JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON actor.id = casting.actorid
WHERE actor.name = 'Harrison Ford' and casting.ord <> 1;

--11.List the films together with the leading star for all 1962 films. 
SELECT movie.title, actor.name 
FROM movie
JOIN casting
ON movie.id = casting.movieid
JOIN actor
ON actor.id = casting.actorid
WHERE movie.yr = 1962 AND casting.ord = 1;


--HARDER QUESTIONS

--12.Which were the busiest years for 'John Travolta', show the year and the 
--number of movies he made each year for any year in which he made more than 2 
--movies. 

SELECT movie.yr, count(movie.id)
FROM movie
JOIN casting ON
casting.movieid = movie.id
JOIN actor ON
actor.id = casting.actorid
WHERE actor.name = 'John Travolta'
GROUP BY movie.yr
HAVING count(yr) > 2;



--13.List the film title and the leading actor for all of the films 'Julie 
--Andrews' played in. 

SELECT DISTINCT m.title, a.name
FROM (SELECT movie.*
      FROM movie
      JOIN casting
      ON casting.movieid = movie.id
      JOIN actor
      ON actor.id = casting.actorid
      WHERE actor.name = 'Julie Andrews') AS m
JOIN (SELECT actor.*, casting.movieid AS movieid
      FROM actor
      JOIN casting
      ON actor.id = casting.actorid
      WHERE casting.ord = 1) AS a
ON m.id = a.movieid
ORDER BY m.title

--14.Obtain a list, in alphabetical order, of actors who've had at least 30 
--starring roles'. 

SELECT actor.name
FROM actor
JOIN casting
ON casting.actorid = actor.id
WHERE casting.ord = 1
GROUP BY actor.name
HAVING count(actor.name) >= 30
ORDER BY actor.name

--15.List the films released in the year 1978 ordered by the number of actors 
--in the cast. 

SELECT movie.title, COUNT(*) as cast_size
FROM movie
JOIN casting ON movie.id = casting.movieid
WHERE movie.yr = 1978
GROUP BY movie.title
ORDER BY cast_size DESC


--16.List all the people who have worked with 'Art Garfunkel'. 

-- made a temp table called m, same structure as casting but only with Art 
-- films. Made another table, same structure as casting but without the same 
-- Art. Joined these two temp tables at movieid and printed out the names.

SELECT a.names
FROM (SELECT casting.*
      FROM casting
      JOIN actor
      ON casting.actorid = actor.id
      WHERE actor.name = 'Art Garfunkel') AS m
JOIN (SELECT casting.*, actor.name as names
      FROM casting
      JOIN actor
      ON actor.id = casting.actorid
      WHERE actor.name != 'Art Garfunkel') AS a 
ON m.movieid = a.movieid
