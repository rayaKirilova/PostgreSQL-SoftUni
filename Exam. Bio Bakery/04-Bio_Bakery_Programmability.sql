-- 01. Customer Feedback --

CREATE OR REPLACE FUNCTION fn_feedbacks_for_product(product_name VARCHAR(25))
RETURNS TABLE (customer_id INT,
               customer_name VARCHAR(75),
               feedback_description VARCHAR(255),
               feedback_rate NUMERIC(4, 2)
              )
AS
$$
BEGIN
      RETURN QUERY
        select c.id as customer_id, c.first_name as customer_name,
               f.description as feedback_description, f.rate as feedback_rate
        from customers c
            inner join feedbacks f on c.id = f.customer_id
        inner join products p on f.product_id = p.id
        where p.name = product_name
        order by c.id asc;
END;
$$
    LANGUAGE plpgsql;

SELECT * FROM fn_feedbacks_for_product('Banitsa');
SELECT * FROM fn_feedbacks_for_product('ALCOHOL');
SELECT * FROM fn_feedbacks_for_product('Bread');


-- 02. Customer’s Country --

CREATE OR REPLACE PROCEDURE sp_customer_country_name(
    IN customer_full_name varchar(50),
    OUT country_name varchar(50)
)
AS
$$
    BEGIN
      select cnt.name INTO country_name
      from customers cst
        left join countries cnt on cst.country_id = cnt.id
      where customer_full_name = concat(cst.first_name, ' ', cst.last_name) ;

    END;
$$
LANGUAGE plpgsql ;

CALL sp_customer_country_name('Betty Wallace', '') ;
















