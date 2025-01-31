-- 01. Stadium Teams Information --

CREATE OR REPLACE FUNCTION fn_stadium_team_name(stadium_name VARCHAR(30))
RETURNS TABLE (team_name VARCHAR(50))
AS
$$
BEGIN
    RETURN QUERY
        select t.name
        from stadiums s
                 inner join teams t on s.id = t.stadium_id
        where stadium_name = s.name
        order by s.id, t.name asc;
END;
$$
    LANGUAGE plpgsql;

select fn_stadium_team_name('Quaxo') ;
select fn_stadium_team_name('BlogXS') ;


-- 02. Player Team Finder --

CREATE OR REPLACE PROCEDURE sp_players_team_name(
    IN player_name varchar(50),
    OUT team_name varchar(45)
)
AS
$$
    BEGIN
      select t.name INTO team_name
      from players p
        left join teams t on p.team_id = t.id
      where player_name = concat(p.first_name, ' ', p.last_name) ;

        IF team_name is null THEN
            team_name := 'The player currently has no team' ;
        END IF;
    END;
$$
LANGUAGE plpgsql ;

CALL sp_players_team_name('Thor Serrels', null ) ;
CALL sp_players_team_name('Walther Olenchenko', '') ;
CALL sp_players_team_name('Isaak Duncombe', '') ;




