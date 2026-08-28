-- insrir
insert into funcionario values
('11122233344', 'Joao', 'Silva', 'joao@tads.ifrn', 'Natal-RN', 9990, '2000-01-01', 'M', null, null),
('22233344455', 'Joana', 'Sales', 'joana@tads.ifrn', 'Parnamirim-RN', 8990, '2000-11-01', 'F', null, null),
('33344455566', 'Jose', 'Sousa', 'jose@tads.ifrn', 'Teresina-PI', 7990, '2002-12-01', 'M', null, null);

insert into funcionario( cpf, pnome, unome, email, salario, data_nasc, sexo) values
('44455566677', 'Jobson', 'Soares', 'jobson@tads.ifrn', 6990, '2003-03-03', 'M');

-- Atualizar
-- update funcionario 
-- set sexo = 'M'
-- where cpf = '22233344455'
-- returning cpf, pnome, unome, sexo;

-- Remover
 delete from funcionario
 where cpf = '44455566677'
-- returning cpf, pnome, unome;
-- 1. sudo service postgresql start
-- 2. psql -h 127.0.0.1 -p 5432 -U admin -d pabd

insert into departamento values
(1, 'TI', '11122233344', current_date), -- current_date é o dia atualzi
(2, 'Financeiro', '2223334455', current_date - interval '3 days'), -- subtrair um intervalo de 3 dias
(3, 'RH', '33344455566', current_date - interval '5 days'); --subtrair intervalo de 5 dias
--interval: year, month, day. Possibilidade de uso: '1 year, 1 month, 12 days'

update funcionario
set cpf_supervisor = '11122233344' -- <> diferente simbolo
where cpf <>'11122233344';

update funcionario 
set numero_departamento = 1
where cpf in ('11122233344', '223344455');

update funcionario 
set numero_departamento = 2
where cpf = '33344455566';

update funcionario 
set numero_departamento = 3
where cpf = ('44455566677');
