-- 01 --

select id, last_name, loyalty_card from customers
where loyalty_card is true
and upper(last_name) like '%M%'
order by last_name desc ;


-- 02 --

select id, to_char(created_at, 'DD-MM-YYYY') as created_at, customer_id from orders
where created_at::DATE > '2025-01-01'
and customer_id between 15 and 30
order by created_at asc, customer_id desc, id asc
limit 5 ;


-- 03 --

select i.name as name,
       concat(upper(b.name), '/', lower(cl.name)) as promotion,
       concat('On sale: ', i.description) as description,
       i.quantity from items i
    full outer join orders_items oi on i.id = oi.item_id
    inner join brands b on i.brand_id = b.id
    inner join classifications cl on i.classification_id = cl.id
where oi.order_id is null
order by i.quantity desc, i.name asc ;


-- 04 --

select c.id as customer_id,
       concat(c.first_name, ' ', c.last_name) as full_name,
       count(o.id) as total_orders,
       case
           when c.loyalty_card is true then 'Loyal Customer'
           when c.loyalty_card is false then 'Regular Customer'
       end as loyalty_status
       from customers c
    join orders o on c.id = o.customer_id
    full outer join reviews r on r.customer_id = c.id
where r.customer_id is null
group by c.id, full_name
order by total_orders desc, customer_id asc;


-- 05 --

select i.name as item_name,
       round(avg(r.rating), 2)as average_rating,
       count(*) as total_reviews,
       b.name as brand_name,
       cl.name as classification_name
    from items i
    inner join reviews r on i.id = r.item_id
    inner join brands b on i.brand_id = b.id
    inner join classifications cl on cl.id = i.classification_id
group by item_name, brand_name, classification_name
having count(*) >= 3
order by average_rating desc, item_name asc
limit 3 ;







