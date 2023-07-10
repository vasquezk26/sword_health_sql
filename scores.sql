with satisfaction as (
	select 
		patient_id,
		 count(patient_id) 							  as num_patients
		, sum(cast(scores ->> 'satisfaction' as integer)) as rating
		, to_char(date, 'Month') 						  as month_name
		, date_part('year', date::date)					  as "year"
	from sword_scores
	where cast(scores ->> 'satisfaction' as integer) >= 8
	group by 1, 4, 5 
),
dissatisfaction as (
	select 
		patient_id,
		 count(patient_id) 							  as num_patients
		, sum(cast(scores ->> 'satisfaction' as integer)) as rating
		, to_char(date, 'Month') 						  as month_name
		, date_part('year', date::date)					  as "year"
	from sword_scores
	where cast(scores ->> 'satisfaction' as integer) <= 7
	group by 1, 4, 5 
)
select 
	round(sum(sat.rating -diss.rating)/count(sat.patient_id) + count(diss.patient_id)) as NPS
	, sat.month_name
	from satisfaction as sat 
		join dissatisfaction as diss
		on sat.month_name = diss.month_name
		and sat.year = diss.year
	group by sat.month_name
