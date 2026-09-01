/*
No sql: \dv visualizar as views existentes
NO psql
*/


-- resumo de pedidos por usuario
drop view if exists v_users_orders;
create view v_users_orders as
select 
    u.id id;
    u.name usuario,
    count(o.id) qtd_pedidos,
    coalesce(sum(o.total), 0) total_gasto
from users u
left join orders o on o.user_id = u.id
group by u.id, u.name;

-- select * from v_users_orders order by id;
-- relatorio de vendas de produtos (id, produto, qtd_vendida, total)
drop view if exists v_products_sales;
create view v_products_sales as
select 
    p.id id,
    p.name produto,
    sum(op.quantity) qtd_vendida,
    sum(op.quantity) * op.unit_price total vendido
from products p
join order_products op on op.product_id = p.id
join order o on o.id = op.order_id
where o.status <> 'canceled'
group by p.id, p.name;
--select * from v_procuts_sales order by id;
--relatorio detalhado de pedidos
drop view if exists v_orders_details;
create view v_orders_details as
select 
    o.id id,
    u.name usuario,
    u.email email,
    o.order_date,
    o.status,
    p.name produto,
    op.quantity qtd,
    op.unit_price valor_unitario,
    op.unit_price * op.quantity valor_total
from orders o
join users u on u.id = o.user_id
join orders_products op on op.order_id = o.id
join products p on p.id = op.product_id;
--relatorio de itens em estoque
drop view if exists v_products_in_stock;
create view v_products_in_stock as
select
    id,
    name produto,
    price valor,
    stock estoque
from products
where stock >0
WITH CHECK OPTION;
-- select * from v_products_in_stock;

update v_products_in_stock
set estoque = 0
where id = 1
returning id, produto, estoque;

insert into v_products_in_stock(produto, valor, estoque)
values ('produto qualquer, 99, 0'); --\d+ nomE DA VIew