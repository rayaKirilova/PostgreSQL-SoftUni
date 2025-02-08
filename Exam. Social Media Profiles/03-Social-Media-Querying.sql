-- 01. Accounts --

select username, gender, age from accounts
where age >= 18
and length(username) > 9
order by age desc, username asc ;

