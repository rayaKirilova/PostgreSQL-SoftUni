-- 01. Function --

CREATE OR REPLACE FUNCTION udf_classification_items_count(classification_name VARCHAR(30))
RETURNS VARCHAR
AS
$$
    DECLARE items_count INT;
BEGIN
        items_count :=
            (select count(*) from items i
                join classifications cl on i.classification_id = cl.id
            where cl.name = classification_name) ;

            if items_count > 0 then
                return concat('Found ', items_count, ' items.') ;
            else
                return 'No items found.' ;
            end if;
END;
$$
    LANGUAGE plpgsql;

SELECT udf_classification_items_count('Nonexistent') AS message_text;
SELECT udf_classification_items_count('Laptops') AS message_text;

select count(*) from items i
    full outer join classifications cl on i.classification_id = cl.id
where cl.name = 'Laptops' ;


-- 02. Procedure --

CREATE OR REPLACE PROCEDURE udp_update_loyalty_status(min_orders INT)
AS
$$
    BEGIN
         UPDATE customers
         SET loyalty_card = TRUE
         WHERE id IN (SELECT customer_id FROM orders
                      GROUP BY customer_id
                      HAVING COUNT(*) >= min_orders) ;
    END;
$$
LANGUAGE plpgsql ;

CALL udp_update_loyalty_status(4);

select min(o.id) from customers c
    inner join orders o on c.id = o.customer_id
group by c.id, c.first_name
order by count(o.id) asc
limit 1 ;

