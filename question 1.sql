select user_id,name from users
where
 user_id  not in (select user_id from orders )
;

