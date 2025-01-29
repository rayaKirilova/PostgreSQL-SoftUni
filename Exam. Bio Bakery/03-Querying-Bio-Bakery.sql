-- 01. Products --

select name, recipe, price from products
where price between 10 and 20
order by price desc ;

-- 02. Negative Feedback --

select f.product_id, f.rate, f.description, f.customer_id, c.age, c.gender from feedbacks f
    join customers c on c.id = f.customer_id
where f.rate < 5.00
and c.age > 30
and c.gender = 'F'
order by f.product_id desc ;

-- 03. High Average Price and Multiple Feedbacks --

select p.name as product_name, round(avg(p.price), 2) as average_price, count(f.product_id) as total_feedbacks from products p
    inner join feedbacks f on p.id = f.product_id
where p.price > 15
group by product_name
having count(f.product_id) > 1
order by total_feedbacks asc, average_price desc ;

-- 04. Specific Ingredients --

select i.name as ingredient_name, p.name as product_name, d.name as distributor_name from ingredients i
    join distributors d on i.distributor_id = d.id
    join products_ingredients pi on i.id = pi.ingredient_id
    join products p on p.id = pi.product_id
where lower(i.name) like '%mustard%'
and d.country_id = 16
order by product_name asc ;

-- 04. Middle Range Distributors --

select d.name as distributor_name, i.name as ingredient_name, p.name as product_name,
       avg(f.rate) as average_rate
from ingredients i
    join distributors d on i.distributor_id = d.id
    join products_ingredients pi on i.id = pi.ingredient_id
    join products p on p.id = pi.product_id
    join feedbacks f on f.product_id = p.id
group by d.name, i.name, p.name
having avg(f.rate) between 5 and 8
order by distributor_name asc, ingredient_name asc, product_name asc ;

