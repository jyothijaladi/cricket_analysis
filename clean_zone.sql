create or replace transient table cricket.clean.match_detail_clean_tabl as 
select 
    info:match_type_number::int as match_type_number,
    info:event.name::text as event_name,
    case
    when
        info:event.match_number::text is not null then info:event.match_number::text
    when
        info:event.stage::text is not null then info:event.stage::text
    else
        'NA'
    end as match_stage,
    info:dates[0]::date as event_date,
    date_part('year',info:dates[0]::date) as event_year,
    date_part('month',info:dates[0]::date) as event_month,
    date_part('day',info:dates[0]::date) as event_day,
    info:match_type::text as match_type,
    info:season::text as season,
    info:team_type::text as team_type,
    info:overs::text as overs,
    info:city::text as city,
    info:venue::text as venue,
    info:gender::text as gender,
    info:teams[0]::text as first_team,
    info:teams[1]::text as second_team,
    case
        when info:outcome.winner is not null then 'Result Declared'
        when info:outcome.result = 'tie' then 'Tie'
        when info:outcome.result = 'no result' then 'No result'
        else info:outcome.result
    end as match_result,
    case
        when info:outcome.winner is not null then info:outcome.winner
        else 'NA'
    end as winner,
    info:toss.winner::text as toss_winner,
    initcap(info:toss.decision::text) as toss_decision,
    stg_file_name,
    stg_file_row_number,
    stg_file_hashkey,
    stg_modified_ts
    from
    cricket.raw.match_raw_tbl;


create or replace table cricket.clean.player_clean_tbl as 
select 
    rcm.info:match_type_number::int as match_type_number, 
    p.path::text as country,
    team.value:: text as player_name,
    stg_file_name ,
    stg_file_row_number,
    stg_file_hashkey,
    stg_modified_ts
from cricket.raw.match_raw_tbl rcm,
lateral flatten (input => rcm.info:players) p,
lateral flatten (input => p.value) team;


create or replace table cricket.clean.delivery_clean_tbl as
select 
    m.info:match_type_number::int as match_type_number, 
    i.value:team::text as country,
    o.value:over::int as over,
    d.value:bowler::text as bowler,
    d.value:batter::text as batter,
    d.value:non_striker::text as non_striker,
    d.value:runs.batter::text as runs,
    d.value:runs.extras::text as extras,
    d.value:runs.total::text as total,
    w.value:player_out::text as player_out,
    w.value:kind::text as player_out_kind,
    w.value:fielders::variant as player_out_fielders,
    m.stg_file_name ,
    m.stg_file_row_number,
    m.stg_file_hashkey,
    m.stg_modified_ts
from cricket.raw.match_raw_tbl m,
lateral flatten (input => m.innings) i,
lateral flatten (input => i.value:overs) o,
lateral flatten (input => o.value:deliveries) d,
lateral flatten (input => d.value:wickets, outer => True) w;


alter table cricket.clean.delivery_clean_tbl
modify column match_type_number set not null;

alter table cricket.clean.delivery_clean_tbl
modify column country set not null;

alter table cricket.clean.delivery_clean_tbl
modify column over set not null;

alter table cricket.clean.delivery_clean_tbl
modify column bowler set not null;

alter table cricket.clean.delivery_clean_tbl
modify column batter set not null;

alter table cricket.clean.delivery_clean_tbl
modify column non_striker set not null;

alter table cricket.clean.match_detail_clean_tabl
add constraint uq_match_type_number unique (match_type_number);


-- fk relationship
alter table cricket.clean.delivery_clean_tbl
add constraint fk_delivery_match_id
foreign key (match_type_number)
references cricket.clean.match_detail_clean_tabl (match_type_number);
