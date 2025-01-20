-- Geography_DB Part --
-- 0 --
create database geography_db ;
-- execute script from file 03-DB-Exercises-geography_db.sql

-- 01. River Info --
create view view_river_info as
    select concat('The river', ' ', river_name, ' ', 'flows into the', ' ', outflow, ' ', 'and is', ' ', "length", ' ', 'kilometers long.')
    as "River Information" from rivers
    order by river_name asc ;

-- 02. Concatenate Geography Data --
create view view_continents_countries_currencies_details as
    select concat(trim(cnt.continent_name), ': ', cnt.continent_code) as continent_details,
           concat(ctr.country_name, ' - ', ctr.capital, ' - ', ctr.area_in_sq_km, ' - km2') as country_information,
           concat(crc.description, ' (', crc.currency_code, ')') as currencies
    from continents cnt
        join countries ctr on cnt.continent_code = ctr.continent_code
        join currencies crc on ctr.currency_code = crc.currency_code
    order by country_information, currencies ;

-- 03. Capital Code --
alter table countries
add column capital_code varchar(2) ;

update countries
set capital_code = substring(capital from 1 for 2);

select * from countries ;

-- 04. Description --
select substring(description from 5 for length(description)) as substring from currencies;

-- 05. Substring River Length --
 select substring("River Information" from '([0-9]{1,4})') from view_river_info ;

-- 06. Replace A --
select replace(mountain_range, 'a', '@') as replace_a,
       replace(mountain_range, 'A', '$') as replace_A from mountains ;

-- 07. Translate --
select capital, translate(capital, 'áãåçéíñóú', 'aaaceinou') as translated_name from countries ;

-- 08. Leading --
select continent_name, trim(both ' ' from continent_name) as trim from continents ;

-- 09. Trailing --
select continent_name, trim(continent_name) as trim from continents ;

-- 10. LTRIM & RTRIM --
select trim(leading 'M' from peak_name) as left_trim, trim(trailing 'm' from peak_name) as right_trim from peaks ;

-- 11. Character Length and Bits --
select concat(mnt.mountain_range, ' ', pks.peak_name) as mountain_information,
       length(concat(mnt.mountain_range, ' ', pks.peak_name)) as characters_length,
       bit_length(concat(mnt.mountain_range, ' ', pks.peak_name)) as bits_of_a_tring
from mountains mnt
    inner join peaks pks on mnt.id = pks.mountain_id ;

-- 12. Length of a Number --
select population, length(cast(population as text)) as length from countries ;

-- 13. Positive and Negative LEFT --
select peak_name,
    left(peak_name, 4) as positive_left,
    substring(peak_name for greatest(0, length(peak_name) - 4)) as negative_left
from peaks;

-- 14. Positive and Negative RIGHT --
select peak_name,
    right(peak_name, 4) as positive_right,
    substring(peak_name from 5) as negative_right
from peaks;

-- 15. Update iso_code --
 select country_name, iso_code, upper(left(country_name, 3)) as big from countries
 where iso_code is null ;
-- 63 rows
update countries
set iso_code = upper(left(country_name, 3))
where iso_code is null ;

-- 16. REVERSE country_code --
update countries
set country_code = reverse(lower(country_code));

-- 17. Elevation --->> Peak Name --
select concat(elevation, ' --->> ', peak_name) as "Elevation-->>Peak Name" from peaks
where elevation >= 4884 ;

-- Booking_DB Part --
-- 0 --
create database booking_db ;
-- execute script from file 03-DB-Exercises-booking_db.sql

-- 18. Arithmetical Operators --
create table bookings_calculation as
    select booked_for from bookings
    where apartment_id = 93 ;

alter table bookings_calculation
add column multiplication numeric,
add column modulo numeric ;

update bookings_calculation
set multiplication = booked_for * 50,
    modulo = mod(booked_for, 50);

-- 19. ROUND vs TRUNC --
select latitude, round(latitude, 2) as round, trunc(latitude, 2) as trunc from apartments ;

-- 20. Absolute Value --
select longitude, abs(longitude) from apartments ;

-- 22. EXTRACT Booked At --
select extract(year from booked_at) as year,
       extract(month from booked_at) as month,
       extract(day from booked_at) as day,
       extract(hour from booked_at) as hour,
       extract(minute from booked_at) as minute,
       ceiling(extract(second from booked_at)) as second
from bookings ;

-- 24. Early Birds --
select user_id, concat(extract(month from age(starts_at, booked_at)), ' mons ',
                       extract(day from age(starts_at, booked_at)), ' days ',
                       extract(hour from age(starts_at, booked_at)), ':',
                       extract(minute from age(starts_at, booked_at)), ':',
                       round(extract(second from age(starts_at, booked_at)), 3)
                       )
from bookings
where extract(month from age(starts_at, booked_at)) >= 10 ;

-- 24. Match or Not --
select companion_full_name, email from users
where lower(companion_full_name) like '%and%'
and email not like '%@gmail' ;

-- 25. COUNT by Initial --
select substring(first_name from 1 for 2) as initials, count(id) as user_count from users
group by substring(first_name from 1 for 2)
order by user_count desc, initials ;

-- 26. SUM --
select sum(booked_for) from bookings
where apartment_id = 90 ;

-- 27. AVERAGE Value --
select avg(multiplication) from bookings_calculation ;