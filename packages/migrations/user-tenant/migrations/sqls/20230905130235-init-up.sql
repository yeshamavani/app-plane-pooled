CREATE SCHEMA IF NOT EXISTS main;

CREATE SCHEMA IF NOT EXISTS logs;

CREATE SEQUENCE IF NOT EXISTS main.auth_clients_id_seq;

CREATE TABLE IF NOT EXISTS main.auth_clients ( 
	id                   uuid DEFAULT md5(random()::text || clock_timestamp()::text)::uuid NOT NULL ,
	client_id            varchar(50)  NOT NULL  ,
	client_secret        varchar(50)  NOT NULL  ,
	redirect_url         varchar(200)    ,
	access_token_expiration integer DEFAULT 900 NOT NULL  ,
	refresh_token_expiration integer DEFAULT 86400 NOT NULL  ,
	auth_code_expiration integer DEFAULT 180 NOT NULL  ,
	secret               varchar(50)  NOT NULL  ,
	created_by			 varchar(100),
	modified_by			 varchar(100),
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	deleted              boolean DEFAULT false NOT NULL  ,
	client_type			 varchar(100) DEFAULT 'public',
	deleted_on           timestamptz    ,
	deleted_by           uuid    ,
	CONSTRAINT pk_auth_clients_id PRIMARY KEY ( id )
 );

CREATE TABLE IF NOT EXISTS main.groups ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	name                 varchar(200)  NOT NULL  ,
	description          varchar(500)    ,
	photo_url            varchar(500)    ,
	tenant_id            uuid  NOT NULL  ,
	created_by           uuid    ,
	modified_by          uuid    ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP   ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP   ,
	deleted              boolean DEFAULT false   ,
	deleted_on           timestamptz    ,
	deleted_by           uuid    ,
	CONSTRAINT pk_groups_id PRIMARY KEY ( id )
 );


CREATE TABLE IF NOT EXISTS main.roles ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	name                 varchar(100)  NOT NULL  ,
	tenant_id            uuid  NOT NULL  ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	created_by           uuid    ,
	modified_by          uuid    ,
	deleted              boolean DEFAULT false NOT NULL  ,
	permissions          text[]    ,
	allowed_clients      text[]    ,
	role_type            integer DEFAULT 0  ,
	description			 varchar(500),
	deleted_by           uuid    ,
	deleted_on           timestamptz    ,
	CONSTRAINT pk_roles_id PRIMARY KEY ( id )
 );


CREATE TABLE IF NOT EXISTS main.tenants ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	name                 varchar(100)  NOT NULL  ,
	status               integer DEFAULT 0 NOT NULL  ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	created_by           uuid    ,
	modified_by          uuid    ,
	deleted              boolean DEFAULT false NOT NULL  ,
	"key"                varchar(20)  NOT NULL  ,
	address              varchar(500)    ,
	city                 varchar(100)    ,
	"state"              varchar(100)    ,
	zip                  varchar(25)    ,
	country              varchar(25)    ,
	deleted_on           timestamptz    ,
	deleted_by           uuid    ,
	website              varchar(100)    ,
	CONSTRAINT pk_tenants_id PRIMARY KEY ( id ),
	CONSTRAINT idx_tenants UNIQUE ( "key" ) 
 );

CREATE TABLE IF NOT EXISTS main.users ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	first_name           varchar(50)  NOT NULL  ,
	middle_name          varchar(50)    ,
	last_name            varchar(50)    ,
	username             varchar(150)  NOT NULL  ,
	email                varchar(150)    ,
	phone                varchar(15)    ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	created_by           uuid    ,
	modified_by          uuid    ,
	deleted              boolean DEFAULT false NOT NULL  ,
	last_login           timestamptz    ,
	photo_url            varchar(250)    ,
	auth_client_ids      integer[]    ,
	gender               char(1)    ,
	dob                  date    ,
	designation          varchar(50)    ,
	default_tenant_id    uuid    ,
	deleted_by           uuid    ,
	deleted_on           timestamptz    ,
	CONSTRAINT pk_users_id PRIMARY KEY ( id )
 );

CREATE TABLE IF NOT EXISTS main.tenant_configs ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	config_key           varchar(100)  NOT NULL  ,
	config_value         jsonb  NOT NULL  ,
	created_on           timestamptz(35) DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz(35) DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	created_by           integer    ,
	modified_by          integer    ,
	deleted              boolean DEFAULT false NOT NULL  ,
	tenant_id            uuid  NOT NULL  ,
	deleted_by           uuid    ,
	deleted_on           timestamptz    ,
	CONSTRAINT pk_tenant_configs_id PRIMARY KEY ( id ),
	CONSTRAINT fk_tenant_configs_tenants FOREIGN KEY ( tenant_id ) REFERENCES main.tenants( id )   
 );

CREATE TABLE IF NOT EXISTS main.user_credentials ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	user_id              uuid  NOT NULL  ,
	auth_provider        varchar(50) DEFAULT 'internal'::character varying NOT NULL  ,
	auth_id              varchar(100)    ,
	secret_key 			 varchar(100),
	auth_token           varchar(100)    ,
	"password"           varchar(60)    ,
	created_by			 varchar(100),
	modified_by			 varchar(100),
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	deleted              boolean DEFAULT false NOT NULL  ,
	deleted_on           timestamptz    ,
	deleted_by           uuid    ,
	CONSTRAINT pk_user_credentials_id PRIMARY KEY ( id ),
	CONSTRAINT idx_user_credentials_user_id UNIQUE ( user_id ) ,
	CONSTRAINT idx_user_credentials_uniq UNIQUE ( auth_provider, auth_id, auth_token, "password" ) ,
	CONSTRAINT fk_user_credentials_users FOREIGN KEY ( user_id ) REFERENCES main.users( id )   
 );

CREATE TABLE IF NOT EXISTS main.user_tenants ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	user_id              uuid  NOT NULL  ,
	tenant_id            uuid  NOT NULL  ,
	role_id              uuid  NOT NULL  ,
	created_by			 varchar(100),
	modified_by			 varchar(100),
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	deleted              boolean DEFAULT false NOT NULL  ,
	status               integer DEFAULT 0 NOT NULL  ,
	locale               varchar(5)    ,
	deleted_by           uuid    ,
	deleted_on           timestamptz    ,
	CONSTRAINT pk_user_tenants_id PRIMARY KEY ( id ),
	CONSTRAINT fk_user_tenants_users FOREIGN KEY ( user_id ) REFERENCES main.users( id )   ,
	CONSTRAINT fk_user_tenants_tenants FOREIGN KEY ( tenant_id ) REFERENCES main.tenants( id )   ,
	CONSTRAINT fk_user_tenants_roles FOREIGN KEY ( role_id ) REFERENCES main.roles( id )   
 );

CREATE TABLE IF NOT EXISTS main.user_groups ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	user_tenant_id       uuid  NOT NULL  ,
	group_id             uuid  NOT NULL  ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP   ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP   ,
	deleted              boolean DEFAULT false   ,
	created_by           uuid    ,
	modified_by          uuid    ,
	deleted_on           timestamptz    ,
	deleted_by           uuid    ,
	CONSTRAINT pk_user_groups_id PRIMARY KEY ( id ),
	CONSTRAINT fk_user_tenant FOREIGN KEY ( user_tenant_id ) REFERENCES main.user_tenants( id )   ,
	CONSTRAINT fk_groups FOREIGN KEY ( group_id ) REFERENCES main.groups( id )   
 );

CREATE TABLE IF NOT EXISTS main.user_invitations ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	created_by           uuid    ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	deleted              boolean DEFAULT false NOT NULL  ,
	deleted_by           uuid    ,
	deleted_on           timestamptz    ,
	expires_on           timestamptz  NOT NULL  ,
	modified_by          uuid    ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	token                varchar(300)  NOT NULL  ,
	user_tenant_id       uuid  NOT NULL  ,
	CONSTRAINT pk_user_invitations_id PRIMARY KEY ( id ),
	CONSTRAINT fk_user_invitations_user_tenants FOREIGN KEY ( user_tenant_id ) REFERENCES main.user_tenants( id )   
 );

CREATE TABLE IF NOT EXISTS main.user_permissions ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	user_tenant_id       uuid  NOT NULL  ,
	permission           varchar(50)  NOT NULL  ,
	allowed              boolean  NOT NULL  ,
	created_on           timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	created_by           uuid    ,
	modified_by          uuid    ,
	deleted              boolean DEFAULT false NOT NULL  ,
	deleted_on           timestamptz    ,
	deleted_by           uuid    ,
	CONSTRAINT pk_user_permissions_id PRIMARY KEY ( id ),
	CONSTRAINT fk_user_permissions FOREIGN KEY ( user_tenant_id ) REFERENCES main.user_tenants( id )   
 );

CREATE TABLE IF NOT EXISTS main.user_tenant_prefs ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	config_key           varchar(100)  NOT NULL  ,
	config_value         jsonb  NOT NULL  ,
	created_on           timestamptz(35) DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	modified_on          timestamptz(35) DEFAULT CURRENT_TIMESTAMP NOT NULL  ,
	created_by           uuid    ,
	modified_by          uuid    ,
	deleted              boolean DEFAULT false NOT NULL  ,
	user_tenant_id       uuid  NOT NULL  ,
	deleted_by           uuid    ,
	deleted_on           timestamptz(35)    ,
	CONSTRAINT pk_user_tenant_prefs_id PRIMARY KEY ( id ),
	CONSTRAINT fk_user_tenant_prefs FOREIGN KEY ( user_tenant_id ) REFERENCES main.user_tenants( id )   
 );

CREATE  TABLE logs.audit_logs ( 
	id                   uuid DEFAULT (md5(((random())::text || (clock_timestamp())::text)))::uuid NOT NULL  ,
	operation_name       varchar(10)  NOT NULL  ,
	operation_time       timestamptz(35) DEFAULT now() NOT NULL  ,
	"table_name"         varchar(60)  NOT NULL  ,
	log_type             varchar(100) DEFAULT 'APPLICATION_LOGS'::character varying   ,
	entity_id            varchar    ,
	user_id              varchar    ,
	"before"             jsonb    ,
	"after"              jsonb    ,
	CONSTRAINT pk_audit_logs_id PRIMARY KEY ( id )
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

CREATE OR REPLACE FUNCTION logs.audit_trigger()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
  DECLARE
    USER_ID VARCHAR;
    ENTITY_ID VARCHAR;
BEGIN
IF TG_OP = 'INSERT'
THEN
USER_ID := to_json(NEW)->'created_by';
ENTITY_ID := to_json(NEW)->'id';
INSERT INTO logs.audit_logs (
  operation_name,
  table_name,
  log_type,
  entity_id,
  user_id,
  after
  )
VALUES (
  TG_OP,
  TG_TABLE_NAME,
  TG_ARGV[0],
  ENTITY_ID,
  USER_ID,
  to_jsonb(NEW)
  );
RETURN NEW;
ELSIF TG_OP = 'UPDATE'
THEN
USER_ID := to_json(NEW)->'modified_by';
ENTITY_ID := to_json(NEW)->'id';
-- IF NEW != OLD THEN
 INSERT INTO logs.audit_logs (
   operation_name,
   table_name,
   log_type,
   entity_id,
   user_id,
   before,
   after
   )
VALUES (
  TG_OP,
  TG_TABLE_NAME,
  TG_ARGV[0],
  ENTITY_ID,
  USER_ID,
  to_jsonb(OLD),
  to_jsonb(NEW)
  );
-- END IF;
 RETURN NEW;
ELSIF TG_OP = 'DELETE'
THEN
USER_ID := to_json(OLD)->'modified_by';
ENTITY_ID := to_json(OLD)->'id';
INSERT INTO logs.audit_logs (
  operation_name,
  table_name,
  log_type,
  entity_id,
  user_id,
  before)
VALUES (
  TG_OP,
  TG_TABLE_NAME,
  TG_ARGV[0],
  ENTITY_ID,
  USER_ID,
  to_jsonb(OLD)
);
RETURN OLD;
END IF;
END;
$function$
;

CREATE VIEW main.v_users AS SELECT u.id,
    u.first_name,
    u.middle_name,
    u.last_name,
    u.username,
    u.email,
    u.phone,
    ut.created_on,
    ut.modified_on,
    u.created_by,
    u.modified_by,
    ut.deleted,
    ut.deleted_by,
    ut.deleted_on,
    u.last_login,
    u.photo_url,
    u.auth_client_ids,
    u.gender,
    u.dob,
    u.designation,
    u.default_tenant_id,
    ut.tenant_id,
    ut.id AS user_tenant_id,
    ut.role_id,
    ut.status,
    t.name,
    t.key,
    r.name AS rolename
   FROM (((main.users u
     JOIN main.user_tenants ut ON ((u.id = ut.user_id)))
     JOIN main.tenants t ON ((t.id = ut.tenant_id)))
     JOIN main.roles r ON ((r.id = ut.role_id)));;

CREATE OR REPLACE TRIGGER mdt_auth_clients BEFORE UPDATE ON main.auth_clients FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_roles BEFORE UPDATE ON main.roles FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_tenant_configs BEFORE UPDATE ON main.tenant_configs FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_tenants BEFORE UPDATE ON main.tenants FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_user_credentials BEFORE UPDATE ON main.user_credentials FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_user_permissions BEFORE UPDATE ON main.user_permissions FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_user_tenants BEFORE UPDATE ON main.user_tenants FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER mdt_users BEFORE UPDATE ON main.users FOR EACH ROW EXECUTE PROCEDURE main.moddatetime('modified_on');

CREATE OR REPLACE TRIGGER roles_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON main.roles FOR EACH ROW EXECUTE PROCEDURE logs.audit_trigger('ROLE_LOGS');

CREATE OR REPLACE TRIGGER tenant_configs_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON main.tenant_configs FOR EACH ROW EXECUTE PROCEDURE logs.audit_trigger('TENANT_CONFIG_LOGS');

CREATE OR REPLACE TRIGGER tenants_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON main.tenants FOR EACH ROW EXECUTE PROCEDURE logs.audit_trigger('TENANT_LOGS');

CREATE OR REPLACE TRIGGER user_permissions_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON main.user_permissions FOR EACH ROW EXECUTE PROCEDURE logs.audit_trigger('USER_PERMISSION_LOGS');

CREATE OR REPLACE TRIGGER users_audit_trigger AFTER INSERT OR DELETE OR UPDATE ON main.users FOR EACH ROW EXECUTE PROCEDURE logs.audit_trigger('USER_LOGS');

COMMENT ON TABLE main.user_invitations IS 'user link expire';
