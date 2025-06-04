create database if not exists cricket;

use database cricket;

create or replace schema land;
create or replace schema raw;
create or replace schema clean;
create or replace schema consumption;

use schema cricket.land;

--file format
create or replace file format json_file_format
  type = json
  null_if = ('\\n','null','')
    strip_outer_array = true
    comment = 'Json file format with outer strip array flag true';

--creating an internal stage
create or replace stage cricket_stg;

---check the list of files in the stage
--list @cricket_stg;

--list @cricket_stg/cricket/json;

--load the files from snowsql to snowflake internal stage
-- put file://C:\users\xxx\Downloads\2023-world-cup-json\*.json @cricket_stg/cricke/json/ parallel=50;

--quick check if data is completely correct or not
--select t.$1:meta::variant as meta,
       --t.$1:info::variant as info,
       --t.$1:innings::array as innings,
       --metadata$filename as filename,
       --metadata$file_row_number int,
       --metadata$file_content_key text,
       --metadata$file_last_modified stg_modified_ts
--from @cricket_stg/cricket/json/1384401.json.gz (file_format=>'json_file_format') t;




