WITH order_review as (
	SELECT 
		row_number() over(
			partition by review_id,order_id 
			order by ingestion_timestamp desc
			) as rn,
		review_id, 
		order_id,
		review_score,		
		nullif(trim(review_comment_title),'') as review_comment_title,
		review_comment_message,
		nullif(trim(review_comment_message),'') as review_comment_message_clean,
		to_timestamp(review_creation_date, 'YYYY-MM-DD HH24:MI:SS') as review_creation_date,
		to_timestamp(review_answer_timestamp, 'YYYY-MM-DD HH24:MI:SS') as review_answer_timestamp,
		ingestion_timestamp
	FROM 
		bronze.olist_order_reviews
	)
select 
	review_id, 
	order_id,
	review_score,
	case when review_comment_message_clean is null then 0 else 1 end as has_comment,
	coalesce(length(review_comment_message_clean),0) as comment_length, 		
	review_comment_title,
	review_comment_message,
	review_comment_message_clean,
	review_creation_date,
	review_answer_timestamp,
	ingestion_timestamp

from 
	order_review
where 
	rn = 1
