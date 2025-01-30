-- 01. User-defined Function Full Name --

CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR, last_name VARCHAR)
RETURNS VARCHAR
AS
$$
BEGIN
    IF first_name IS NULL AND last_name IS NULL THEN
        RETURN NULL;
    END IF;

    IF first_name IS NULL THEN
        RETURN INITCAP(last_name);
    ELSIF last_name IS NULL THEN
        RETURN INITCAP(first_name);
    END IF;
    RETURN INITCAP(first_name) || ' ' || INITCAP(last_name);
END;
$$
LANGUAGE plpgsql ;


-- 02. User-defined Function Future Value --

CREATE OR REPLACE FUNCTION fn_calculate_future_value(initial_sum NUMERIC, yearly_interest_rate NUMERIC, number_of_years INT)
RETURNS NUMERIC
AS
$$
    BEGIN
        RETURN TRUNC(initial_sum * POWER((1 + yearly_interest_rate), number_of_years), 4);
    END;
$$
LANGUAGE plpgsql ;

select fn_calculate_future_value (1000, 0.1, 5) ;
select fn_calculate_future_value(2500, 0.30, 2) ;
select fn_calculate_future_value(500, 0.25, 10) ;

select round(500 * POWER((1 + 0.25), 10), 4);
select trunc(500 * POWER((1 + 0.25), 10), 4);


-- 03.	User-defined Function Is Word Comprised --

CREATE OR REPLACE FUNCTION fn_is_word_comprised(set_of_letters VARCHAR(50), word VARCHAR(50))
RETURNS BOOLEAN
AS
$$
    DECLARE
    letter CHAR;
    i INT := 1;
    temp_letters TEXT;
    position INT;

    BEGIN
    temp_letters := LOWER(set_of_letters);
    word := LOWER(word);

    word := REGEXP_REPLACE(word, '[^a-z]', '', 'g');

    WHILE i <= LENGTH(word) LOOP
        letter := SUBSTRING(word FROM i FOR 1); -- Get the i-th letter
        position := POSITION(letter IN temp_letters);

        IF position = 0 THEN
            RETURN FALSE;
        END IF;

        temp_letters := OVERLAY(temp_letters PLACING '' FROM position FOR 1);

        i := i + 1;
    END LOOP;

    RETURN TRUE;
    END ;
$$
LANGUAGE plpgsql ;

select fn_is_word_comprised('bobr', 'Rob') ;


-- 04. Game Over --
-- CREATE DATABASE diablo_db ;

CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOLEAN)
RETURNS TABLE (
    name VARCHAR(50),
    game_type_id INT,
    is_finished BOOLEAN
)
AS $$
BEGIN
    RETURN QUERY
    SELECT g.name, g.game_type_id, g.is_finished
    FROM games g
    WHERE g.is_finished = is_game_over;
END;
$$ LANGUAGE plpgsql;


-- 05. Difficulty Level --

CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT)
AS
$$
    DECLARE level_difficulty VARCHAR ;
        BEGIN
            IF level <= 40 THEN
                level_difficulty := 'Normal Difficulty';
            ELSIF level between 41 and 60 THEN
                level_difficulty := 'Nightmare Difficulty';
            ELSIF level > 60 THEN
                level_difficulty := 'Hell Difficulty' ;
            END IF;

            RETURN level_difficulty ;
        END;
$$
LANGUAGE plpgsql ;

select user_id, level, cash, fn_difficulty_level(level) from users_games
order by user_id asc ;


-- 06. Cash in User Games Odd Rows --

CREATE OR REPLACE FUNCTION fn_cash_in_users_games(game_name VARCHAR(50))
RETURNS TABLE (total_cash NUMERIC)
AS $$
BEGIN
    RETURN QUERY
    SELECT ROUND(SUM(cash), 2) AS total_cash
    FROM (
        SELECT cash, ROW_NUMBER() OVER (ORDER BY cash DESC) AS row_num
        FROM users_games ug
        INNER JOIN games g ON ug.game_id = g.id
        WHERE g.name = game_name
    ) sub
    WHERE row_num % 2 = 1;  -- Select only odd-numbered rows
END;
$$ LANGUAGE plpgsql;

select fn_cash_in_users_games('Love in a mist') ;

select g.name, sum(ug.cash),
       ROW_NUMBER() OVER(PARTITION BY g.name ORDER BY ug.cash DESC) % 2 <> 0 AS row_num from users_games ug
    inner join games g on ug.game_id = g.id
group by g.name, ug.cash
order by sum(ug.cash) desc


-- Create new database bank_db --
-- CREATE DATABASE bank_db ;


-- 07. Retrieving Account Holders --

CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(searched_balance NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    holder_record RECORD;
    total_balance NUMERIC;
BEGIN
    FOR holder_record IN
        SELECT ah.id, ah.first_name, ah.last_name
        FROM account_holders ah
        ORDER BY ah.first_name, ah.last_name
    LOOP
        SELECT COALESCE(SUM(a.balance), 0) INTO total_balance
        FROM accounts a
        WHERE a.account_holder_id = holder_record.id;

        IF total_balance > searched_balance THEN
            RAISE NOTICE '% % - %', holder_record.first_name, holder_record.last_name, total_balance;
        END IF;
    END LOOP;
END;
$$;

CALL sp_retrieving_holders_with_balance_higher_than(50000);

select a.account_holder_id, ah.first_name, sum(balance) as sum from account_holders ah
    join accounts a on ah.id = a.account_holder_id
group by a.account_holder_id, ah.first_name ;


-- 08. Deposit Money --

CREATE OR REPLACE PROCEDURE sp_deposit_money(account_id INT, money_amount NUMERIC(10,4))
LANGUAGE plpgsql
AS
$$
    BEGIN
        UPDATE accounts
        SET balance = balance + money_amount
        WHERE id = account_id;
        COMMIT ;
    END;
$$ ;

CALL sp_deposit_money(10, 500) ;
CALL sp_deposit_money(1, 200) ;

select * from accounts
where id in (1, 10) ;


-- 09. Withdraw Money --

CREATE OR REPLACE PROCEDURE sp_withdraw_money(account_id INT, money_amount NUMERIC(10,4))
LANGUAGE plpgsql
AS
$$
    BEGIN
        IF (SELECT balance FROM accounts WHERE id = account_id) < money_amount THEN
            RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
            ROLLBACK ;
        ELSE
            UPDATE accounts
            SET balance = balance - money_amount
            WHERE id = account_id;
        END IF ;
        COMMIT ;
    END;
$$ ;

call sp_withdraw_money(1, 500) ;
call sp_withdraw_money(15, 100) ;
call sp_withdraw_money(16, 5000) ;

select * from accounts
where id in (1, 15, 16) ;


-- 10. Money Transfer --

CREATE OR REPLACE PROCEDURE sp_withdraw_money_tr(account_id INT, amount NUMERIC(18,4))
LANGUAGE plpgsql
AS $$
DECLARE
    current_balance NUMERIC(18,4);
BEGIN
    SELECT balance INTO current_balance
    FROM accounts
    WHERE id = account_id;

    IF current_balance < amount THEN
        RAISE EXCEPTION 'Insufficient funds';
    END IF;

    UPDATE accounts
    SET balance = balance - amount
    WHERE id = account_id;
    -- NO COMMIT here! Transaction handled in sp_transfer_money
END;
$$;

CREATE OR REPLACE PROCEDURE sp_deposit_money_tr(account_id INT, amount NUMERIC(18,4))
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE accounts
    SET balance = balance + amount
    WHERE id = account_id;
    -- NO COMMIT here! Transaction handled in sp_transfer_money
END;
$$;


CREATE OR REPLACE PROCEDURE sp_transfer_money(sender_id INT, receiver_id INT, amount NUMERIC(10,4))
LANGUAGE plpgsql
AS $$
BEGIN
    BEGIN
        -- Attempt to withdraw money from sender's account
        CALL sp_withdraw_money_tr(sender_id, amount);

        -- Attempt to deposit money into receiver's account
        CALL sp_deposit_money_tr(receiver_id, amount);

        -- Notify successful transfer
        RAISE NOTICE 'Transfer of % from account % to account % completed successfully.', amount, sender_id, receiver_id;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE NOTICE 'Transaction failed: %', SQLERRM;
            RAISE;
    END;
END;
$$;

CALL sp_transfer_money(7, 11, 1000) ;

select * from accounts
where id in (7, 11) ;


-- 11. Delete Procedure --
drop procedure  sp_retrieving_holders_with_balance_higher_than ;


-- 12. Log Accounts Trigger --

CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    account_id INT,
    old_sum NUMERIC(18, 4),
    new_sum NUMERIC(18, 4)
);

CREATE FUNCTION trigger_fn_insert_new_entry_into_logs()
   RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
    BEGIN
     INSERT INTO logs (account_id, old_sum, new_sum)
     VALUES(OLD.id,OLD.balance, NEW.balance);
        RETURN NULL;
    END;
$$ ;

CREATE TRIGGER tr_account_balance_change
AFTER UPDATE
ON accounts
FOR EACH ROW
EXECUTE FUNCTION trigger_fn_insert_new_entry_into_logs() ;


CALL sp_transfer_money(6, 14, 200) ;
CALL sp_deposit_money(5, 1000);
CALL sp_withdraw_money(3, 10000);
CALL sp_transfer_money(7, 15, 1200) ;

select * from logs ;


-- 13. Notification Email on Balance Change --

CREATE TABLE notification_emails (
    id SERIAL PRIMARY KEY,
    recipient_id INT NOT NULL,
    subject VARCHAR(30) NOT NULL,
    body TEXT NOT NULL
);

CREATE OR REPLACE FUNCTION trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.old_sum IS DISTINCT FROM NEW.new_sum THEN
        INSERT INTO notification_emails (recipient_id, subject, body)
        VALUES (
            NEW.id,  -- Recipient of the notification
            'Balance change for account: ' || NEW.account_id,  -- Subject
            'On ' || NOW()::date || ' your balance was changed from ' || OLD.old_sum || ' to ' || NEW.new_sum || '.'
        );
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER tr_send_email_on_balance_change
AFTER UPDATE ON logs
FOR EACH ROW
EXECUTE FUNCTION trigger_fn_send_email_on_balance_change();
