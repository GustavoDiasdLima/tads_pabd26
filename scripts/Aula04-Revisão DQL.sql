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

-- order by, limit
select pnome, unome from funcionario
order by pnome desc, unome desc; --asc ascendente / desc decrescente
-- Maior salário
select pnome, unome, salario from funcionario
order by salario desc
limit 1;

--funcoes de agregação count, sumn ,avg ,min ,max
select count(*) TotalFuncionarios from funcionario;

select count(distinct numero_departamento) from funcionario;

select sum(salario) as "FolhaSalarial" from funcionario;

select sum(salario) "FolhaSalarial Dep1" from funcionario
where numero_departamento = 1; -- where é filtragem para apenas departamento 1

select avg(salario) Media_Salarial from funcionario;
--arredondar 2 casas
select round(avg(salario), 2) Media_Salarial from funcionario;
-- menor e maior salario
select min(salario) menor_salario, max(salario) maior_salario from funcionario;

-- qual nome do funcionario com menor salario
select 
    pnome, unome 
from funcionario
where  salario = (
    select min(salario) from funcionario
);

-- quais funcionarios recebem salario acima da media

select 
    pnome, unome
from funcionario
where salario >= (
    select avg(salario) from funcionario
);

-- relatorio completo: total funcionarios, folha salarial,
-- media salarial, menor salário, maior salario.

select 
    count(*) Total_Funcionarios, -- total funcionario
    sum(salario) folha_salarial, -- folha salarial
    round(avg(salario), 2) Media_Salarial, -- media salarial
    min(salario) Menor_salario, -- menor salario
    max(salario) Maior_salario -- maior salario
from funcionario;

--junções inner join, left join, right join, full join

-- listar nome dos funcionarios e seus nomes de departamento
select
    f.pnome || ' ' || f.unome funcionario,
    d.nome departamento
from funcionario f
join departamento d
    on f.numero_departamento = d.numero 
order by d.nome, f.pnome;

-- listar todos os funcionarios e seus supervisores 
-- incluindo funcionarios sem supervisor (null)
select
    f.pnome || ' ' || f.unome funcionario,
    coalesce(s.pnome || ' ' || s.unome, 'Sem supervisor') supervisor
from funcionario f
left join funcionario s
    on f.cpf_supervisor = s.cpf
order by s.pnome nulls last, f.pnome, f.unome;


--exists, not exists


--funcoes de agrupamento group by having