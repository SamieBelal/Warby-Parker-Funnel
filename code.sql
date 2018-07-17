 select * 
 from survey 
 limit 10;
 -- Part 1 tells me that their are 3 columns. question, user_id, and response
 select  question,
 count (distinct user_id) as num_responses 
        from survey 
        group by 1;
select question, response, count(*) as num_responses 
from survey
group by 1,2
order by 1,3 desc;
-- Answer to the part 2 question is Q1=500, Q2=475, Q3=380, Q4=361, Q5=270

with question_responses as(
 select question, 
   count(distinct user_id) as num_responses
 from survey
 group by 1), 
total_responses as(
 select max(num_responses) as total
 FROM question_responses), 
combined as(
 select *
 from question_responses
 cross join total_responses)
select question, 
	(1.0 * num_responses / total) * 100 as percent_answered
from combined;

-- Asnwer to Part 3 is  Q1 100%, Q2 95%, Q3 76%, Q4 72.2%, Q5 54%

select * 
from quiz 
limit 5;

-- Quiz table consists of the  user_id, style, fit, shape, and color columns 

select * 
from home_try_on 
limit 5;

-- Home_try_on table consists of the user_id, address, and number_of_pairs columns

select * 
from purchase 
limit 5;

-- Purchase table consists of the user_id, product_id, style, model_name, color, and price columns 

select distinct q.user_id, 
	h.user_id is not null as is_home_try_on,
  h.number_of_pairs, 
  p.user_id is not null as is_purchased
from quiz q
left join  home_try_on h
	on q.user_id = h.user_id
left join purchase p
	on p.user_id = q.user_id
limit 10;
       
-- Conversion rates are overall 49.5%, quiz to home 75%, and home to purchase is 66%

with funnel as ( 
  select distinct q.user_id, 
	h.user_id is not null as is_home_try_on,
  h.number_of_pairs, 
  p.user_id is not null as is_purchased
from quiz q
left join home_try_on h
	on q.user_id = h.user_id
left join purchase p
	on p.user_id = q.user_id)
select 1.0 * SUM(is_purchased)/ count(user_id) * 100 as total_conversion, 
	1.0 * sum(is_home_try_on) / count(user_id) * 100 as quiz_to_home,
	1.0 * sum(is_purchased) / sum(is_home_try_on) * 100 as home_to_purchase
from funnel;

-- Conversion rates in respect to the amount of pairs provided 3 pairs 53%, 5 pairs 79%

with funnel as ( 
  select distinct q.user_id, 
		h.user_id is not null as is_home_try_on,
  	h.number_of_pairs, 
  	p.user_id is not null as is_purchased
	from quiz q
	left join home_try_on h
		on q.user_id = h.user_id
	left join purchase p
		on p.user_id = q.user_id), 
three_pairs AS (
	select *
	from funnel
	where number_of_pairs = '3 pairs'), 
five_pairs AS (
	select *
	from funnel
	where number_of_pairs = '5 pairs'),
five_conversion as (
	select number_of_pairs, 
  	1.0 * sum(is_purchased) /sum(is_home_try_on) * 100 as home_to_purchase
	from five_pairs), 
three_conversion as (
	select number_of_pairs, 
  	1.0 * sum(is_purchased) /sum(is_home_try_on) * 100 as home_to_purchase
	from three_pairs), 
three_five_conversion as (
	select *
	from five_conversion
	union
	select *
	from three_conversion)
select number_of_pairs,
	round(home_to_purchase,2) as home_to_purchase
from three_five_conversion;

-- Results of the style quiz

select style, 
count(style) as num_response
from quiz
group by 1
order by 2 desc;

select fit, 
count(fit) as num_response
from quiz
group by 1
order by 2 desc;

select shape, 
count(shape) as num_response
from quiz
group by 1
order by 2 desc;

select color, 
count(color) as num_response
from quiz
group by 1
order by 2 desc;

-- Types of purchases 

select style, model_name, color, 
count(*) as num_purchases, price
from purchase
group by 1,2,3
order by 4 desc;

select style,
count(*) as num_purchases
from purchase
group by 1
order by 2 desc;

select model_name, 
count (*) as num_purchases
from purchase
group by 1
order by 2 desc;

select color, 
count(*) as num_purchases
from purchase
group by 1
order by 2 desc;
