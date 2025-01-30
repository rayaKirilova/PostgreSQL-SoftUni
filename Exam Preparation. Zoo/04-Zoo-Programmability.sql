-- 01. All Volunteers in a Department --

CREATE OR REPLACE FUNCTION fn_get_volunteers_count_from_department(searched_volunteers_department VARCHAR(30))
RETURNS INT
AS
$$
    DECLARE count INT ;
    BEGIN
        select count(v.id) INTO count
        from volunteers v
            inner join volunteers_departments vd on v.department_id = vd.id
        where searched_volunteers_department = vd.department_name ;
        RETURN count ;
    END;
$$
LANGUAGE plpgsql ;

select count(v.id) from volunteers v
    inner join volunteers_departments vd on v.department_id = vd.id
group by v.department_id ;

select fn_get_volunteers_count_from_department('Zoo events') ;


-- 02. Animals with Owner or Not --

CREATE PROCEDURE sp_animals_with_owners_or_not(
    IN animal_name varchar(30),
    OUT owner_name varchar(30)
)
AS
$$
    BEGIN
        select o.name INTO owner_name
        from animals a
            left join owners o on a.owner_id = o.id
        where animal_name = a.name ;

        IF owner_name IS NULL THEN
            owner_name := 'For adoption' ;
        END IF ;
    END;
$$
LANGUAGE plpgsql ;

CALL sp_animals_with_owners_or_not('Chimpanzee', null) ;