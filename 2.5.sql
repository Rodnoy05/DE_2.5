select ss.shop_name,
ss.product_name,
ss.sales_fact,
ss.sales_plan,
1.0*ss.sales_fact/ss.sales_plan as "sales_fact/sales_plan",
ss.sales_fact*ss.price as "income_fact",
ss.sales_plan*ss.price as "income_plan",
(ss.sales_fact*ss.price)/(ss.sales_plan*ss.price) as "income_fact/income_plan"
from (
SELECT DISTINCT 
plan.plan_date,
plan.shop_name,
products.product_name,
products.price, 
(select sum(s1.sales_cnt)
from public.shop_mvideo s1
where EXTRACT(MONTH FROM s1.date)=EXTRACT(MONTH FROM plan.plan_date)
and s1.product_id=products.product_id ) AS sales_fact,
plan.plan_cnt as sales_plan
FROM 
public.products products
join public.plan plan on plan.product_id=products.product_id
join (select * from public.shops s where s.shop_name='М Видео') shops on shops.shop_name=plan.shop_name
union
SELECT 
plan.plan_date,
plan.shop_name,
products.product_name, 
products.price,
(select sum(s2.sales_cnt)
from public.shop_dns s2
where EXTRACT(MONTH FROM s2.date)=EXTRACT(MONTH FROM plan.plan_date)
and s2.product_id=products.product_id ) AS sales_fact,
plan.plan_cnt as sales_plan
FROM 
public.products products
join public.plan plan on plan.product_id=products.product_id
join (select * from public.shops s where s.shop_name='ДНС') shops on shops.shop_name=plan.shop_name
union
SELECT 
plan.plan_date,
plan.shop_name,
products.product_name, 
products.price,
(select sum(s3.sales_cnt)
from public.shop_sitilink s3
where EXTRACT(MONTH FROM s3.date)=EXTRACT(MONTH FROM plan.plan_date)
and s3.product_id=products.product_id ) AS sales_fact,
plan.plan_cnt as sales_plan
FROM 
public.products products
join public.plan plan on plan.product_id=products.product_id
join (select * from public.shops s where s.shop_name='Ситилинк') shops on shops.shop_name=plan.shop_name
order by 1,2) ss