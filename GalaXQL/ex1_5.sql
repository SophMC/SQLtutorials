--2. As your very first task, use SQL to calculate the number of seconds in one 
--day (where day is 24 hours, hour is 60 minutes and a minute is 60 seconds).
SELECT (60*60)*24

--3.Let's see if you can build a query now. Get x, y and z information from all 
--the rows from the table 'stars'.
SELECT x,y,z FROM stars

--4. Make a query which returns starid, x, y and z for all stars where x is 
--greater than zero and starid is less than one hundred. Sort the results by 
--the y-coordinate so that the smallest values come first.
SELECT starid, x, y, z FROM stars 
WHERE x > 0 AND starid < 100
ORDER BY y ASC

--5.Build a query where you calculate the sum of all y values divided by all x 
--values.
SELECT sum(y/x) FROM stars

--6. Hilight five stars which have star id between 5000 and 15000, and have 
--class. (Hint: don't try to do this with a single query at this point).

INSERT INTO hilight VALUES (5007);
INSERT INTO hilight VALUES (5048);
INSERT INTO hilight VALUES (5050);
INSERT INTO hilight VALUES (5068);
INSERT INTO hilight VALUES (5075);

--7. Hilight all the stars with starid between 10000 and 11000. (I know, this 
--is not too difficult, but it looks neat)

INSERT INTO hilight 
SELECT starid FROM stars
WHERE starid > 10000 AND
starid < 11000;

--8.Kill off all stars with starid lower than 10000. Do this inside a 
--transaction, so that when I run the ROLLBACK command, we're back with the 
--original galaxy.

BEGIN;
DELETE FROM stars WHERE starid < 10000;

--9.Starting from the normal galaxy, update it so that you swap the x and z 
--coordinates for stars which have star id between 10000 and 15000.

BEGIN;
UPDATE stars SET x = z, z = x
WHERE starid > 10000 AND starid < 15000;

--10. Hilight all stars with starid of at least 20000, which have planets with 
--moons that have an orbit distance of at least 3000. Remember to remove any 
--old hilights before starting.

INSERT INTO hilight 
SELECT DISTINCT stars.starid 
FROM stars, planets, moons 
WHERE stars.starid > 20000
AND stars.starid=planets.starid 
AND planets.planetid = moons.planetid 
AND moons.orbitdistance > 3000

--11. Hilight the star (or stars) which has the planet with the highest orbit 
--distance in the galaxy. Remember to clear the old hilights before beginning. 

INSERT INTO hilight
SELECT planets.starid
FROM planets, (SELECT MAX(orbitdistance) AS mo FROM planets)
WHERE planets.orbitdistance = mo;

--12. Generate a list of stars with star ids between 500 and 600 (but not 
--including 500 and 600) with columns "starname", "startemp", "planetname", and 
--"planettemp". The list should have all stars, with the unknown data filled 
--out with NULL. These values are, as usual, fictional. Calculate the 
--temperature for a star with ((class+7)*intensity)*1000000, and a planet's 
--temperature is calculated from the star's temperature minus 50 times orbit 
--distance. 

SELECT stars.name AS starname, ((stars.class+7)*stars.intensity)*1000000 AS 
startemp, planets.name AS planetname, 
(((stars.class+7)*stars.intensity)*1000000)-(50*planets.orbitdistance) AS 
planettemp FROM stars
LEFT JOIN planets 
ON planets.starid = stars.starid
WHERE stars.starid > 500 
AND stars.starid < 600

--13. Create a VIEW called "numbers" with the columns "three", "intensity" and 
--"x", where "x" and "intensity" come from the stars table, "three" contains 
--the number 3 on all rows. For additional fun, sort the whole thing by "x"

CREATE VIEW numbers
AS SELECT 3 AS three, stars.intensity AS intensity, stars.x AS x FROM stars
ORDER BY x;

--14. Create a table named 'colors' with the columns 'color' and 'description'. 
--Color is integer, description is text. Populate the table with color values 
--from -3 to 10; each star class has its own color; fill the description with 
--something (I won't care exactly what). Basic idea is that it will be possible 
--to make a join between stars and colors where stars' class is compared to 
--colors' color number

CREATE TABLE colors (color INTEGER, description TEXT);
INSERT INTO colors(color,description) VALUES 
(-3,"red"),(-2,"green"),(-1,"blue"),(0,"navy"),(1,"grey"),(2,"pink"),(3,"yellow"
),(4,"orange"),(5,"white"),(6,"black"),(7,"purple"),(8,"cyan"),(9,"maroon"),(10,
"lilac");

--15. Create a table called "quotes" with two columns: "id", which is primary 
--key, and takes integers, and "quote" which contains non-null text strings, 
--such as quote of the day (http://www.qotd.org/). Fill in a couple of rows so 
--that I have something to query for. 

CREATE TABLE quotes (id INTEGER PRIMARY KEY, quote TEXT NOT NULL)
INSERT INTO quotes (id, quote) VALUES (1, "quote1"), (2,"quote2"), (3,"quote3");

--16. First, create and populate a table using this command. Rename the table to 
--'my_table', and add a column called 'moredata'. Add one whole new row and 
--change the 'moredata' value of at least one existing row. (Yes, I'm aware you 
--could do all that by changing the creation commands, but that is not the 
--point of this exercise).

ALTER TABLE alter_test RENAME TO my_table;
ALTER TABLE  my_table ADD COLUMN moredata INTEGER;
INSERT INTO my_table(moredata) VALUES (1), (2);

--17. Hilight the star with the most orbitals (combined planets and moons). If 
--multiple stars have the highest number of orbitals, highlight the one with 
--the lowest star id. 

SELECT stars.starid AS starid
FROM stars 
LEFT OUTER JOIN planets ON stars.starid == planets.starid
LEFT OUTER JOIN moons ON planets.planetid == moons.planetid
GROUP BY stars.starid ORDER BY (COUNT(planets.planetid) + COUNT(moons.moonid)) 
DESC
LIMIT 1;

--18. Build a query which returns starids from planets.
--The starids should be selected so that for each starid (x) in the list:
--- there should exist a planet with a starid that's three times x but there 
--should not exist a planet with starid two times x.
--Only use starids from the planets table.

SELECT starid FROM planets
INTERSECT 
SELECT starid*3 FROM planets
EXCEPT
SELECT starid*2 FROM planets;

--19. Create a trigger which, when a new star is created, clears the hilight 
--table and inserts the new star id to the hilight table. 

CREATE TRIGGER highlight_insert
AFTER INSERT On stars
BEGIN
INSERT INTO hilight VALUES (NEW.starid);
END

-- This should work but doesn't, galaXQL author states there might be a bug.

--20. Use ALTER TABLE to rename the 'gateway' table to 'gateways'. (ALTER TABLE 
--was covered in chapter 16)









