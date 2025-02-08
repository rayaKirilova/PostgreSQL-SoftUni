-- 01. INSERT -- 

select * from reviews
order by item_id asc
limit 10 ;

insert into items(name, quantity, price, description, brand_id, classification_id)
select concat('Item', created_at) as name,
       customer_id as quantity,
       rating * 5 as price,
       null as description,
       item_id as brand_id,
       (select min(item_id) from reviews) as classification_id
from reviews
order by item_id asc
limit 10 ;


-- 02. UPDATE --

update reviews
set rating =
    case
        when item_id = customer_id then 10.0
        when customer_id > item_id then 5.5
        else rating
    end;

-- 03. DELETE -- 

delete
from customers
where id in (select c.id from orders o
                full outer join customers c on o.customer_id = c.id
                where o.customer_id is null ) ;




