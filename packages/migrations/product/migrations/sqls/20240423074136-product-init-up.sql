/* Replace with your SQL commands */

CREATE SCHEMA IF NOT EXISTS main;

SET search_path TO main,public;
GRANT ALL ON SCHEMA main TO public;

CREATE TABLE IF NOT EXISTS main.products (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	name            varchar(50)  NOT NULL ,
	description        varchar(50)  NOT NULL ,
	type         varchar(50)   ,
	CONSTRAINT pk_products_id PRIMARY KEY ( id )
 );