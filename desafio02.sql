begin;

insert into customer (cpf, customer_id, customer_name)
values (1533333333333, 13, 2026);

select cpf, custumer_id, customer_name, from customer;

rollback;
--commit ?
----------------------------------------
begin;

insert into inventory (inventory_id, mv_name, mv_cast, mv_date);
values (1, "Ainda estou Aqui", "Fernanda MonteNegro", "2025")
select inventory_id, mv_name, mv_cast, mv_date from inventory;

savepoint estoque_atualizado;

insert into inventory (inventory_id, mv_name, mv_cast, mv_date);
values(2, "Adele: Weekends With Adele", "Adele", "2027") -- 2022
select inventory_id, mv_name, mv_cast, mv_date from inventory;

rollback to estoque_atualizado;

insert into inventory (inventory_id, mv_name, mv_cast, mv_date)
values (3, "Adele: One Night Only", "Adele", "2021");
select inventory_id, mv_name, mv_cast, mv_date from inventory;

commit;
----------------------------------------

