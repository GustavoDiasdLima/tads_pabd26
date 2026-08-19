select * from funcionario; -- realiza seleção em atributos que quer exibir
-- * seleciona todos 
   
select pnome, unome, numero_departamento from funcionario;             

select pnome || ' ' || unome,  numero_departamento from funcionario;

-- alias apelido
select pnome || ' ' || unome as "Nome Completo", numero_departamento as 'Dep' from funcionario;

select all numero_departamento from funcionario;
--exibir valores distintos que nao se repetem
select distinct numero_departamento from funcionario;
--round; especifica valores de casas decimais so aceita numeric
select pnome || ' ' || unome nome, salario, round(salario * 0.11, 2) inss from funcionario;


--Where: filtro
select cpf, pnome, unome from funcionario
where endereco = 'Natal-RN';

select cpf, pnome, unome from funcionario
where numero_departamento = 1 and salario > 9000;

select cpf, pnome, unome from funcionario
where salario>= 8000 and salario > 10000;
--between entre 
select cpf, pnome, unome from funcionario
where salario between 8000 and 10000;


--%: substitui qualquer cadeia textual
-- _: substitui qualquer caractere especifico 
select cpf, pnome, unome from funcionario
where endereco like '%PI';

select cpf, pnome, unome from funcionario
where pnome like '%ana%';
-- ilike comparação desconsiderando case sensitive 
select cpf, pnome, unome from funcionario
where endereco ilike '%pi';
--
select cpf, pnome, unome from funcionario
where endereco like '%R_';

--tabela t exemplo busca caracteres especiais
CREATE TABLE t(
    message text
);
INSERT INTO t(message)
VALUES ('The rents are now 10% higher than last month'),
    ('The new film will have _ in the title');
SELECT message FROM t;

select * from t
where message like '%10%%' escape '$';