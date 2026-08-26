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

-- 1. sudo service postgresql start
-- 2. psql -h 127.0.0.1 -p 5432 -U admin -d pabd
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
left join funcionario s  -- pegar todos os valores disponiveis para a coluna da esquerda
    on f.cpf_supervisor = s.cpf
order by s.pnome nulls last, f.pnome, f.unome;

select
    f.pnome || ' ' || f.unome funcionario,
    coalesce(s.pnome || ' ' || s.unome, 'Sem supervisor') supervisor
from funcionario f
right join funcionario s  -- pegar todos os valores disponiveis para a coluna da direita
    on f.cpf_supervisor = s.cpf
order by s.pnome nulls last, f.pnome, f.unome;

-- mudanças para visualizar o full join
update funcionario
set numero_departamento = null
where cpf = '44455566677';

insert into departamento(numero, nome, cpf_gerente, data_ini)
values (4, 'Marketing', null, current_date)

select 
    coalesce(d.nome, 'Sem departamento') departamento,
    coalesce(f.pnome || ' ' || f.unome, 'Sem funcionário')  funcionario
from departamento d
full join funcionario f
    on d.numero = f.numero_departamento
order by departamento nulls last, funcionario nulls last;

--exists, not exists

--listar funcionarios que sao gerentes de algum departamento
select 
    f.pnome || ' ' || f.unome funcionario
from funcionario f
where exists (
    select * 
    from departamento d
    where d.cpf_gerente = f.cpf
)
order by funcionario;

--funcoes de agrupamento group by having

-- qual o salario médio dos funcionarios em cada departamento?
select
    numero_departamento,
    round(avg(salario), 2) Media_Salarial
from funcionario
group by numero_departamento
order by numero_departamento;

-- qual o salario médio dos funcionarios em cada departamento sem valores nulos WHERE

select
    numero_departamento,
    round(avg(salario), 2) Media_Salarial
from funcionario
where numero_departamento is not null
group by numero_departamento
order by numero_departamento;

-- qual o salario médio dos funcionarios em cada departamento sem valores nulos HAVING

select
    numero_departamento,
    round(avg(salario), 2) Media_Salarial
from funcionario
group by numero_departamento
having numero_departamento is not null
order by numero_departamento;


-- qual o numero de funcionarios que trabalham em cada departamento 
select 
    numero_departamento,
    count(*)
from funcionario f
group by numero_departamento
order by numero_departamento;

-- listar numero e nome do departamento, quantidade de funcionarios
-- e folha salarial

select 
    d.numero numero_departamento,
    d.nome nome_departamento,

    count(*) Quantidade_Funcionarios, -- quantidade funcionarios
    round(avg(f.salario), 2) Media_Salarial, -- media salarial
    sum(f.salario) Folha_Salarial -- folha salarial
    
from funcionario f
join  departamento d
    on f.numero_departamento = d.numero
group by d.numero
order by numero_departamento;
