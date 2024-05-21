CREATE SCHEMA IF NOT EXISTS main;

SET search_path TO main,public;
GRANT ALL ON SCHEMA main TO public;

CREATE TABLE IF NOT EXISTS main.auth_clients (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	client_id            varchar(50)  NOT NULL ,
	client_secret        varchar(50)  NOT NULL ,
	redirect_url         varchar(200)   ,
	access_token_expiration integer DEFAULT 900 NOT NULL ,
	refresh_token_expiration integer DEFAULT 86400 NOT NULL ,
	auth_code_expiration integer DEFAULT 180 NOT NULL ,
	secret               varchar(50)  NOT NULL ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	deleted              bool DEFAULT false NOT NULL ,
	deleted_on           timestamptz   ,
	deleted_by           uuid   ,
	CONSTRAINT pk_auth_clients_id PRIMARY KEY ( id )
 );

 CREATE TABLE IF NOT EXISTS main.roles (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	created_by           uuid   ,
	modified_by          uuid   ,
	deleted              bool DEFAULT false NOT NULL ,
	permissions          _text   ,
	role_type            integer DEFAULT 0 NOT NULL ,
	deleted_by           uuid   ,
	deleted_on           timestamptz   ,
	CONSTRAINT pk_roles_id PRIMARY KEY ( id )
 );
 
 CREATE TABLE IF NOT EXISTS main.tenants (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	status               integer DEFAULT 0 NOT NULL ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	created_by           uuid   ,
	modified_by          uuid   ,
	deleted              bool DEFAULT false NOT NULL ,
	"key"                varchar(20)  NOT NULL ,
	address              varchar(500)   ,
	city                 varchar(100)   ,
	"state"              varchar(100)   ,
	zip                  varchar(25)   ,
	country              varchar(25)   ,
	deleted_on           timestamptz   ,
	deleted_by           uuid   ,
	CONSTRAINT pk_tenants_id PRIMARY KEY ( id ),
	CONSTRAINT idx_tenants UNIQUE ( "key" )
 );

 CREATE TABLE IF NOT EXISTS main.tenant_configs (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	config_key           varchar(100)  NOT NULL ,
	config_value         jsonb  NOT NULL ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	created_by           integer   ,
	modified_by          integer   ,
	deleted              bool DEFAULT false NOT NULL ,
	tenant_id            uuid  NOT NULL ,
	deleted_by           uuid   ,
	deleted_on           timestamptz   ,
	CONSTRAINT pk_tenant_configs_id PRIMARY KEY ( id ),
    CONSTRAINT fk_tenant_configs_tenants FOREIGN KEY ( tenant_id ) REFERENCES main.tenants( id )   

 );


CREATE TABLE IF NOT EXISTS main.users (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	first_name           varchar(50)  NOT NULL ,
	middle_name          varchar(50)   ,
	last_name            varchar(50)   ,
	username             varchar(150)  NOT NULL ,
	email                varchar(150)   ,
	phone                varchar(15)   ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	created_by           uuid   ,
	modified_by          uuid   ,
	deleted              bool DEFAULT false NOT NULL ,
	last_login           timestamptz   ,
	auth_client_ids      integer[]   ,
	gender               char(1)   ,
	dob                  date   ,
	default_tenant_id    uuid   ,
	deleted_by           uuid   ,
	deleted_on           timestamptz   ,
	CONSTRAINT pk_users_id PRIMARY KEY ( id )
 );

CREATE TABLE IF NOT EXISTS main.user_credentials (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	user_id              uuid  NOT NULL ,
	auth_provider        varchar(50) DEFAULT 'internal'::character varying NOT NULL ,
	auth_id              varchar(100)   ,
	auth_token           varchar(100)   ,
	"password"           varchar(60)   ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	deleted              bool DEFAULT false NOT NULL ,
	deleted_on           timestamptz   ,
	deleted_by           uuid   ,
	CONSTRAINT pk_user_credentials_id PRIMARY KEY ( id ),
	CONSTRAINT idx_user_credentials_user_id UNIQUE ( user_id ),
	CONSTRAINT idx_user_credentials_uniq UNIQUE ( auth_provider, auth_id, auth_token, "password" ),
	CONSTRAINT fk_user_credentials_users FOREIGN KEY ( user_id ) REFERENCES main.users( id )
 );
 
 CREATE TABLE IF NOT EXISTS main.user_tenants (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	user_id              uuid  NOT NULL ,
	tenant_id            uuid  NOT NULL ,
	role_id              uuid  NOT NULL ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	deleted              bool DEFAULT false NOT NULL ,
	status               integer DEFAULT 0 NOT NULL ,
	locale               varchar(5)   ,
	deleted_by           uuid   ,
	deleted_on           timestamptz   ,
	CONSTRAINT pk_user_tenants_id PRIMARY KEY ( id ),
	CONSTRAINT fk_user_tenants_users FOREIGN KEY ( user_id ) REFERENCES main.users( id )   ,
	CONSTRAINT fk_user_tenants_tenants FOREIGN KEY ( tenant_id ) REFERENCES main.tenants( id )   ,
	CONSTRAINT fk_user_tenants_roles FOREIGN KEY ( role_id ) REFERENCES main.roles( id )   
 );

 CREATE TABLE IF NOT EXISTS main.user_permissions (
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	user_tenant_id       uuid  NOT NULL ,
	permission           varchar(50)  NOT NULL ,
	allowed              bool  NOT NULL ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	created_by           uuid   ,
	modified_by          uuid   ,
	deleted              bool DEFAULT false NOT NULL ,
	deleted_on           timestamptz   ,
	deleted_by           uuid   ,
	CONSTRAINT pk_user_permissions_id PRIMARY KEY ( id ),
	CONSTRAINT fk_user_permissions FOREIGN KEY ( user_tenant_id ) REFERENCES main.user_tenants( id )   

 );

CREATE TABLE IF NOT EXISTS main.user_resources ( 
	deleted              bool DEFAULT false NOT NULL ,
	deleted_on           timestamptz   ,
	deleted_by           uuid   ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	created_by           uuid   ,
	modified_by          uuid   ,
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	user_tenant_id       uuid ,
	resource_name        varchar(50)   ,
	resource_value       varchar(100)   ,
	allowed              bool DEFAULT true NOT NULL ,
	CONSTRAINT user_resources_pkey PRIMARY KEY ( id ),
	CONSTRAINT fk_user_resources FOREIGN KEY ( user_tenant_id ) REFERENCES main.user_tenants( id )

 );


CREATE OR REPLACE FUNCTION main.moddatetime()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    NEW.modified_on = now();
    RETURN NEW;
END;
$function$
;

CREATE OR REPLACE TRIGGER mdt_auth_clients BEFORE UPDATE ON main.auth_clients FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_roles BEFORE UPDATE ON main.roles FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_tenant_configs BEFORE UPDATE ON main.tenant_configs FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_tenants BEFORE UPDATE ON main.tenants FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_user_credentials BEFORE UPDATE ON main.user_credentials FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_user_permissions BEFORE UPDATE ON main.user_permissions FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_user_tenants BEFORE UPDATE ON main.user_tenants FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_users BEFORE UPDATE ON main.users FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');