JOIN: https://stackoverflow.com/questions/38549/what-is-the-difference-between-inner-join-and-outer-join?page=1&tab=votes#tab-top

Query all columns for all American cities in CITY with populations larger than 100000.
```
select * from city where COUNTRYCODE = "USA" and POPULATION > 100000;
```

Query a list of CITY and STATE from the STATION table.
```
select CITY, STATE from STATION;
```

Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
```
select COUNT(CITY) - COUNT(DISTINCT CITY) from STATION; 
```

Query the total population, avg of all cities in CITY where District is California, avg of population rounded down.
```
select SUM(POPULATION) from CITY where district = "California";
select AVG(POPULATION) from CITY where district = "California";
select FLOOR( AVG(POPULATION) ) from CITY;
select MAX(population) - min(population) from CITY;
```

Query a list of CITY names from STATION with even ID numbers only. You may print the results in any order, but must exclude duplicates from your answer.
```
select DISTINCT CITY from STATION where ID % 2 = 0;
```

Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION.
```
select DISTINCT CITY from STATION where CITY REGEXP "^[AEIOU]";
```

Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION. Your result cannot contain duplicates.
```
select DISTINCT CITY from STATION where CITY REGEXP "[AEIOU]$";
```

Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters.
. = any character, * = any number of times.
```
select DISTINCT CITY from STATION where CITY REGEXP "^[AEIOU].*[AEIOU]$";
```

Query the list of CITY names from STATION that do not start with vowels.
```
select DISTINCT CITY from STATION where CITY REGEXP "^[^AEIOU]";
```

Query the list of CITY names from STATION that do not end with vowels.
```
select DISTINCT CITY from STATION where CITY REGEXP "[^AEIOU]$";
```

Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels.
```
select DISTINCT CITY from STATION where CITY REGEXP "^[^AEIOU]|[^AEIOU]$";
```

Query the list of CITY names from STATION that do not start with vowels and do not end with vowels.
```
select DISTINCT CITY from STATION where CITY REGEXP "^[^AEIOU].*[^AEIOU]$";
```

Query the Name of any student in STUDENTS who scored higher than  Marks. Order your output by the last three characters of each name. If two or more students both have names ending in the same last three characters, secondary sort them by ascending ID.
```
select Name from STUDENTS where Marks > 75 ORDER BY RIGHT(Name, 3), ID ASC;
```

Query identifying the type of each record in the TRIANGLES table using its three side lengths.
1 case for 1 column.
```
select
case
    when A + B <= C or B + C <= A or A + C <= B then "Not A Triangle"
	when A = B and B = C then "Equilateral"
	when A = B or B = C or A = C then "Isosceles"
	else "Scalene"
end as comment
from TRIANGLES;
```

Query Name(First_letter_of_occupation) and total number of each occupation.
```
select concat(Name, "(", LEFT(Occupation, 1), ")") as nameas from OCCUPATIONS order by nameas ASC;
select concat("There are a total of ", COUNT(Name), " ", lower(Occupation), "s.") as total from OCCUPATIONS group by Occupation order by total ASC;
```

Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, choose the one that comes first when ordered alphabetically.
```
select city, length(city) from station order by length(city) asc, city asc LIMIT 1;
select city, length(city) from station order by length(city) desc, city asc LIMIT 1;
```

https://www.hackerrank.com/challenges/occupations/problem
https://stackoverflow.com/questions/1241178/mysql-rows-to-columns/9668036#9668036
https://www.hackerrank.com/challenges/occupations/forum/comments/394277
```
MIN is used to select non-null value.
SET @r1= 0,@r2= 0,@r3= 0,@r4=0;
SELECT Min(Doctor), Min(Professor), Min(Singer), Min(Actor) 
FROM (
SELECT
CASE OCCUPATION
WHEN "Doctor" THEN (@r1 := @r1 + 1)
WHEN "Professor" THEN (@r2 := @r2 + 1)
WHEN "Singer" THEN (@r3 := @r3 + 1)
WHEN "Actor" THEN (@r4 := @r4 + 1)
END AS row_id,
CASE Occupation WHEN "Doctor" THEN Name end as Doctor,
CASE Occupation WHEN "Professor" THEN Name end as Professor,
CASE Occupation WHEN "Singer" THEN Name end as Singer,
CASE Occupation WHEN "Actor" THEN Name end as Actor
FROM OCCUPATIONS
ORDER BY Name ASC
) Temp
GROUP BY row_id
```

https://www.hackerrank.com/challenges/binary-search-tree-1/problem
to check NULL, you should write `P IS NULL`
```
select N,
case
when P IS NULL then "Root"
when (select count(N) from BST where P = B.N) = 0 then "Leaf"
else "Inner"
end as type
from BST
as B
order by N
```

https://www.hackerrank.com/challenges/the-company/problem
select inside select - to use the (single) result as one element of a row
```
select company_code, (select founder from company where company_code = E.company_code), count(distinct lead_manager_code), count(distinct senior_manager_code), count(distinct manager_code), count(distinct employee_code)
from Employee as E
group by company_code
```

https://www.hackerrank.com/challenges/earnings-of-employees/problem
it's not always optimal to use MAX if you are to find maximum.
```
SELECT months * salary as total_earnings, COUNT(*)
FROM Employee
GROUP BY 1
ORDER BY 1 DESC
LIMIT 1
```

Query the sum of Northern Latitudes (LAT_N) from STATION. Truncate your answer to 4 decimal places.
```
SELECT TRUNCATE( SUM(LAT_N), 4) FROM STATION WHERE LAT_N > 38.788 AND LAT_N < 137.2345
```

Query the Western Longitude (LONG_W)where the smallest Northern Latitude (LAT_N) in STATION is greater than 38.778. Round your answer to 4 decimal places.
select inside select.
```
SELECT ROUND(LONG_W, 4) FROM STATION WHERE LAT_N = (SELECT MIN(LAT_N) FROM STATION WHERE LAT_N > 38.778)
```

Euclidean Distance.
```
SELECT FORMAT( SQRT( POWER(MAX(LAT_N) - MIN(LAT_N), 2) + POWER(MAX(LONG_W) - MIN(LONG_W), 2) ), 4 ) FROM STATION
```

Query the median.
```
set @r1 = 0;
SELECT ROUND(LAT_N, 4) FROM (SELECT @r1 := @r1 + 1 as row_id, LAT_N FROM STATION ORDER BY LAT_N) Temp
WHERE row_id = ((SELECT COUNT(*) FROM STATION) + 1)/2;
```

Query miscaculated salary where every 0 is removed.
```
SELECT REPLACE(Salary, 0, '') FROM EMPLOYEES;
```

Given the CITY and COUNTRY tables, query the sum of the populations of all cities where the CONTINENT is 'Asia'.
```
select sum(city.population) from city, country where city.countrycode = country.code and country.continent = "ASIA"
```

Given the CITY and COUNTRY tables, query the names of all the continents (COUNTRY.Continent) and their respective average city populations (CITY.Population) rounded down to the nearest integer.
```
select country.continent, floor(avg((city.population))) from city, country where city.countrycode = country.code group by country.continent
```

https://www.hackerrank.com/challenges/the-report/problem
```
select IF(G.Grade < 8, 'NULL', S.Name), G.Grade, S.Marks
from Students S, Grades G
where S.Marks BETWEEN G.Min_Mark AND G.Max_Mark
order by G.Grade DESC, S.Name, S.Marks
```

https://www.hackerrank.com/challenges/full-score/problem
can't use WHERE with aggregate functions, have to use HAVING.
group by --> having --> order by
in join, you have to use all the columns in GROUP BY to SELECT them
```
select H.hacker_id, H.name
from submissions S, challenges C, difficulty D, hackers H
where S.challenge_id = C.challenge_id and C.difficulty_level = D.difficulty_level and S.hacker_id = H.hacker_id and S.score = D.score
group by H.hacker_id, H.name
having count(*) > 1
order by count(*) desc, H.hacker_id asc;
```

https://www.hackerrank.com/challenges/harry-potter-and-wands/problem
```
select W.id, WP.age, W.coins_needed, W.power
from
Wands W,
Wands_Property WP
where W.code = WP.code AND WP.is_evil = 0 AND W.coins_needed = (select MIN(WT.coins_needed) from Wands WT, Wands_Property WPT where WT.code = WPT.code AND WPT.age = WP.age AND WT.power = W.power)
order by W.power desc, WP.age desc
```

