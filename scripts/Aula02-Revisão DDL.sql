drop table if exists funcionario cascade; -- se a tabela existir, vai dropar, apagar e criar denovo
drop table if exists departamento cascade; 

Create table funcionario(
    cpf char(11) primary key,  -- char temq preencher obrigatoriamente todos os caracteres
    pnome varchar(50) not null, -- varchar a capacidade máxima que pode escrever.
    unome varchar(50) not null,
    email varchar(50) unique, --unique permite valor nulo
    endereco varchar(100),
    salario numeric(7,2), -- valor max 99999,99
    data_nasc date,
    sexo char(1), -- M F
    cpf_supervisor char(11),
    numero_departamento smallint,

    constraint funcionario_salario_check
    check (salario > 2000 and salario <=15000)
);

create table departamento(
    numero smallint primary key, --vai de -32,768 ate 32,767
    nome varchar(50) unique,
    cpf_gerente char(11)

);

-- \i ./scripts/Aula02-Revisão DDL.sql
-- ver todas as tabelas \dt

-- Adicionar um novo atributo
alter table departamento
add column data_ini date; -- ADICIONAR é ADD

-- Alterar um atributo para NOT NULL
alter table departamento -- ALTERAR é alter
alter column data_ini set not null;

-- Excluir um atributo
alter table departamento
drop column data_ini;

-- Adicionar restrição padrão
alter table funcionario
alter column endereco set default 'Macau-RN';

-- Excluir um valor padrão DEFAULT
alter table funcionario
alter column endereco drop default;
--Se aparecer (END) no terminal apertar Q

-- Adicionar restrição (constraint) CHECK
alter table funcionario
add constraint funcionario_sexo_check --CHECK = Verificar/checar
check (lower(sexo) in ('M', 'F', 'O'));

--Excluir restrição
alter table funcionario
drop constraint if exists funcionario_sexo_check;

--Adicionar restrição FOREIGN KEY CHAVE ESTRANGEIRA
alter table funcionario
add constraint funcionario_num_dep_fk
foreign key (numero_departamento)
references departamento(numero)
-- no action, set null, restrict, cascade, set default
on delete no action
on update cascade;

-- ADICIONAR MAIS 2 RESTRIÇÔES CPF supervisor e CPF GERENTE