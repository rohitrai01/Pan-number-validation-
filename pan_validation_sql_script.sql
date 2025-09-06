-- Pan card validation 
select * from pan_data;

-- Identify missing values
select * from pan_data where Pan_numbers = '';

-- check for duplicate values
select Pan_numbers,count(1) from pan_data group by 1 having count(1)>1;

-- Handeling leading or trailing space
select Pan_numbers from pan_data where trim(Pan_numbers) != Pan_numbers;

-- incorrect  case values
SELECT * FROM pan_data 
WHERE BINARY Pan_numbers != BINARY UPPER(Pan_numbers);

-- clean pan number
select distinct upper(trim(Pan_numbers)) Pan_numbers from pan_data 
where trim(Pan_numbers)<>'';


-- function for check adjacent charater are same 

delimiter $$
create function check_ad_char (p_str varchar(255))
returns boolean
deterministic
  begin 
	declare i int default 1 ;
    declare str_len int ;
    declare current_char char(1);
    declare next_char char(1);
    
    set str_len = length(p_str);
    while i<str_len do
      set current_char = substring(p_str,i,1);
      set next_char = substring(p_str,i+1,1);
      
      if current_char = next_char then return True;
      end if;
      set i = i+1;
	end while;
    return False;
  end$$

delimiter ;
    
-- function to check character of string are in sequence

Delimiter $$
create function check_seq_char(p_str varchar(255))
returns boolean
deterministic

begin 
   declare i int default 1;
   declare str_len int;
   declare curr_char_val int;
   declare next_char_val int;
   
   set str_len = length(p_str);
   while i < str_len do
   set curr_char_val = ascii(substring(p_str,i,1));
   set next_char_val = ascii(substring(p_str,i+1,1));
   
   if curr_char_val != next_char_val-1 then return false;
   end if;
   set i = i+1;
   end while;
   return true;
end $$
delimiter ;

-- Giving status to the pan number is it valid or invalid

with cte_cleaned_pan as
   (select distinct upper(trim(Pan_numbers)) Pan_numbers from pan_data 
   where trim(Pan_numbers)<>''
   ),
cte_valid_pan as
   (select * from cte_cleaned_pan 
   where check_ad_char(Pan_numbers) = False 
   and check_seq_char(substring(Pan_numbers,1,5))= False
   and check_seq_char(substring(Pan_numbers,6,4)) = False
   and Pan_numbers regexp '^[A-Z]{5}[0-9]{4}[A-Z]$'
   )
select  ccp.Pan_numbers , case when cvp.Pan_numbers is not null 
								   then 'Valid pan'
                               else 'Invalid pan'
						 end as `status`
from cte_cleaned_pan ccp 
left join cte_valid_pan cvp on ccp.Pan_numbers = cvp.Pan_numbers ;

-- create view

create view view_of_status_of_pan as
with cte_cleaned_pan as
   (select distinct upper(trim(Pan_numbers)) Pan_numbers from pan_data 
   where trim(Pan_numbers)<>''
   ),
cte_valid_pan as
   (select * from cte_cleaned_pan 
   where check_ad_char(Pan_numbers) = False 
   and check_seq_char(substring(Pan_numbers,1,5))= False
   and check_seq_char(substring(Pan_numbers,6,4)) = False
   and Pan_numbers regexp '^[A-Z]{5}[0-9]{4}[A-Z]$'
   )
select  ccp.Pan_numbers , case when cvp.Pan_numbers is not null 
								   then 'Valid pan'
                               else 'Invalid pan'
						 end as `status`
from cte_cleaned_pan ccp 
left join cte_valid_pan cvp on ccp.Pan_numbers = cvp.Pan_numbers ;

select * from view_of_status_of_pan;

-- summary

with cte as
(select (select count(*) from pan_data) total,
sum(case when `status`='Valid pan' then 1 else 0 end) as valid_pan,
sum(case when `status`='Invalid pan' then 1 else 0 end) as invalid_pan
from view_of_status_of_pan)
select * ,(total - (valid_pan+invalid_pan)) as missing_pan from cte ;


