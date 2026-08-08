select 
	review_id,
	order_id,
	review_score,
	has_comment,
	comment_length,
	review_comment_title,
	review_comment_message,
	review_comment_message_clean,
	GREATEST(
		0,
		EXTRACT(
			DAY
			FROM
				(
					review_answer_timestamp - review_creation_date
				)
		)
	) AS dias_respostas
from silver.stg_orders_review