use role accountadmin;
use warehouse compute_wh;
use schema cricket.raw;

--create a table in raw layer
create or replace transient table cricket.raw.match_raw_tbl(
    meta object not null,
    info variant not null,
    innings array not null,
    stg_file_name text not null,
    stg_file_row_number int not null,
    stg_file_hashkey text not null,
    stg_modified_ts timestamp not null
)
comment = "this is raw table to store all the json data file with root elements extracted";

--load data into raw table
copy into cricket.raw.match_raw_tbl from(
    select t.$1:meta::object as meta,
           t.$1:info::variant as info,
           t.$1:innings::array as innings,
           metadata$filename,
           metadata$file_row_number,
           metadata$file_content_key,
           metadata$file_last_modified
    from @cricket.land.cricket_stg/cricket/json (file_format=>'cricket.land.json_file_format') t
)
on_error = continue;