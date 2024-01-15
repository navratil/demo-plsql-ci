whenever sqlerror exit failure rollback
whenever oserror exit failure rollback
set echo off
set feedback off
set heading off
set verify off

define usp_owner_schema        = &1
define usp_reporting_exp       = _rep
define usp_reporting_schema    = &&usp_owner_schema&&usp_reporting_exp
define usp_owner_password      = &2
define usp_reporting_password  = &3
define usp_tablespace          = &4

prompt Creating USP schema owner: &&usp_owner_schema

create user &usp_owner_schema identified by "&usp_owner_password" 
  default tablespace &usp_tablespace 
  quota unlimited on &usp_tablespace;

grant 
  create session, 
  create sequence, 
  create procedure, 
  create type, 
  create table, 
  create trigger, 
  create view, 
  create synonym 
  to &usp_owner_schema;

prompt Creating USP reporting user: &&usp_reporting_schema

create user &usp_reporting_schema identified by "&usp_reporting_password";

grant create session to &usp_reporting_schema;