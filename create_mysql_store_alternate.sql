-- --------------------------------------------------------------------------------
--  Program Name:   create_mysql_store_ri.sql
--  Creation Date:  March-2017
-- --------------------------------------------------------------------------------

-- Open log file.
TEE create_mysql_store.txt

-- This enables dropping tables with foreign key dependencies.
-- It is specific to the InnoDB Engine.
SET FOREIGN_KEY_CHECKS = 0; 

-- Conditionally drop objects.
SELECT 'SYSTEM_USER' AS "Drop Table";
DROP TABLE IF EXISTS system_user;

-- ------------------------------------------------------------------
-- Create SYSTEM_USER table.
-- ------------------------------------------------------------------
SELECT 'SYSTEM_USER' AS "Create Table";

CREATE TABLE system_user
( system_user_id              INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, system_user_name            CHAR(20)     NOT NULL
, system_user_type            INT UNSIGNED NOT NULL
, first_name                  CHAR(20)
, middle_name                 CHAR(20)
, last_name                   CHAR(20)
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY system_user_fk1 (system_user_type)
, CONSTRAINT system_user_fk1 FOREIGN KEY (system_user_type) REFERENCES system_user_type (system_user_type_id)
, KEY system_user_fk2 (created_by)
, CONSTRAINT system_user_fk2 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY system_user_fk3 (last_updated_by)
, CONSTRAINT system_user_fk3 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Conditionally drop objects.
SELECT 'SYSTEM_USER_TYPE' AS "Drop Table";
DROP TABLE IF EXISTS system_user_type;

CREATE TABLE system_user_type
( system_user_type_id			INT UNSIGNED 	PRIMARY KEY AUTO_INCREMENT
, system_user_type 				CHAR(30) 		NOT NULL
, created_by                  	INT UNSIGNED 	NOT NULL
, creation_date               	DATE         	NOT NULL
, last_updated_by             	INT UNSIGNED 	NOT NULL
, last_update_date            	DATE         	NOT NULL
, KEY system_user_type_fk1 (created_by)
, CONSTRAINT system_user_type_fk1 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY system_user_type_fk2 (last_updated_by)
, CONSTRAINT system_user_type_fk2 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- first insert into system_user_type, then insert into system_user

INSERT INTO system_user_type
( system_user_type 
, created_by
, creation_date
, last_updated_by
, last_update_date
VALUES
('database administrator', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO system_user_type
( system_user_type 
, created_by
, creation_date
, last_updated_by
, last_update_date
VALUES
('database developer', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO system_user
( system_user_name
, system_user_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
('kylebirc_admin'
, 1
, (SELECT system_user_type_id
   FROM system_user_type
   WHERE system_user_type = 'database administrator')
, UTC_DATE()
, 1
, UTC_DATE());

-- Conditionally drop objects.
SELECT 'account' AS "Drop Table";
DROP TABLE IF EXISTS account;

-- ------------------------------------------------------------------
-- Create ACCOUNT table.
-- ------------------------------------------------------------------
SELECT 'account' AS "Create Table";

CREATE TABLE account
( account_id                   	INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, account_type                 	INT UNSIGNED
, account_number              	CHAR(10)     NOT NULL
, password 						INT UNSIGNED NOT NULL
, created_by                  	INT UNSIGNED NOT NULL
, creation_date               	DATE         NOT NULL
, last_updated_by             	INT UNSIGNED NOT NULL
, last_update_date            	DATE         NOT NULL
, KEY account_fk1 (account_type)
, CONSTRAINT account_fk1 FOREIGN KEY (account_type) REFERENCES account_type (account_type_id)
, KEY account_fk2 (created_by)
, CONSTRAINT account_fk2 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY account_fk3 (last_updated_by)
, CONSTRAINT account_fk3 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Conditionally drop objects.
SELECT 'account_type' AS "Drop Table";
DROP TABLE IF EXISTS account_type;

SELECT 'account_type' AS 'create_table';

CREATE TABLE account_type
( account_type_id 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, account_type 					INT UNSIGNED
, created_by                  	INT UNSIGNED NOT NULL
, creation_date               	DATE         NOT NULL
, last_updated_by             	INT UNSIGNED NOT NULL
, last_update_date            	DATE         NOT NULL
, KEY account_fk1 (created_by)
, CONSTRAINT account_fk1 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY account_fk2 (last_updated_by)
, CONSTRAINT account_fk2 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create default account types
INSERT INTO account_type
( account_type 
, created_by
, creation_date
, last_updated_by
, last_update_date
VALUES
('administrator', 1, UTC_DATE(), 1, UTC_DATE());

INSERT INTO account_type
( account_type 
, created_by
, creation_date
, last_updated_by
, last_update_date
VALUES
('user', 1, UTC_DATE(), 1, UTC_DATE());

-- Conditionally drop objects.
SELECT 'CONTACT' AS "Drop Table";
DROP TABLE IF EXISTS contact;

-- ------------------------------------------------------------------
-- Create CONTACT table.
-- ------------------------------------------------------------------
SELECT 'CONTACT' AS "Create Table";

CREATE TABLE contact
( contact_id                  INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, account_id                   INT UNSIGNED NOT NULL
, contact_type                INT UNSIGNED 
, email 						CHAR(30)	NOT NULL
, first_name                  CHAR(30)     NOT NULL
, middle_name                 CHAR(30)
, last_name                   CHAR(30)     NOT NULL
, telephone_id 					CHAR(20) 	NOT NULL
, created_by                  INT UNSIGNED NOT NULL
, creation_date               DATE         NOT NULL
, last_updated_by             INT UNSIGNED NOT NULL
, last_update_date            DATE         NOT NULL
, KEY contact_fk1 (account_id)
, CONSTRAINT contact_fk1 FOREIGN KEY (account_id) REFERENCES account (account_id)
, KEY contact_fk2 (contact_type)
, CONSTRAINT contact_fk2 FOREIGN KEY (contact_type) REFERENCES contact_type (contact_type)
, KEY contact_fk3 (telephone_id)
, CONSTRAINT contact_fk3 FOREIGN KEY (contact_type) REFERENCES telephone (telephone_id)
, KEY contact_fk4 (created_by)
, CONSTRAINT contact_fk4 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY contact_fk5 (last_updated_by)
, CONSTRAINT contact_fk5 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Conditionally drop objects.
SELECT 'contact_type' AS "Drop Table";
DROP TABLE IF EXISTS contact_type;

SELECT 'contact_type' AS 'CREATE TABLE';

CREATE TABLE contact_type
( contact_type_id 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, contact_type 					INT UNSIGNED
, created_by                  	INT UNSIGNED NOT NULL
, creation_date               	DATE         NOT NULL
, last_updated_by             	INT UNSIGNED NOT NULL
, last_update_date            	DATE         NOT NULL
, KEY contact_type_fk1
, CONSTRAINT contact_type_fk1 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY contact_type_fk2 (last_updated_by)
, CONSTRAINT contact_type_fk2 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Conditionally drop objects.
SELECT 'telephone' AS "Drop Table";
DROP TABLE IF EXISTS telephone_type;

SELECT 'telephone' AS 'create table';

CREATE TABLE telephone
( telephone_id 					INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, area_code 					INT UNSIGNED	NOT NULL
, telephone_number 				INT UNSIGNED	NOT NULL
, telephone_type 				INT UNSIGNED	NOT NULL
, creation_date               	DATE         	NOT NULL
, last_updated_by             	INT UNSIGNED 	NOT NULL
, last_update_date            	DATE         	NOT NULL
, KEY telephone_fk1
, CONSTRAINT telephone_fk1 FOREIGN KEY (telephone_type) REFERENCES telephone_type (telephone_type_id)
, KEY telephone_fk2
, CONSTRAINT telephone_fk2 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY telephone_fk3 (last_updated_by)
, CONSTRAINT telephone_fk3 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Conditionally drop objects.
SELECT 'telephone_type' AS "Drop Table";
DROP TABLE IF EXISTS telephone_type;

SELECT 'telephone_type' AS 'create table';

CREATE TABLE telephone_type
( telephone_type_id 			INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, telephone_type 				INT UNSIGNED	NOT NULL
, created_by                  	INT UNSIGNED 	NOT NULL
, creation_date               	DATE         	NOT NULL
, last_updated_by             	INT UNSIGNED 	NOT NULL
, last_update_date            	DATE         	NOT NULL
, KEY telephone_type_fk1
, CONSTRAINT telephone_type_fk1 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY telephone_type_fk2 (last_updated_by)
, CONSTRAINT telephone_type_fk2 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;)

-- Conditionally drop objects.
SELECT 'credit_card' AS "Drop Table";
DROP TABLE IF EXISTS credit_card;

SELECT 'credit_card' AS 'create table';

CREATE TABLE credit_card
( credit_card_id 				INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, account_id 					INT UNSIGNED 	NOT NULL
, credit_card_number 			INT UNSIGNED 	NOT NULL
, credit_card_type 				INT UNSIGNED 	NOT NULL
, expiration_date 				DATE 		 	NOT NULL
, cvv 							INT UNSIGNED
, created_by                  	INT UNSIGNED 	NOT NULL
, creation_date               	DATE         	NOT NULL
, last_updated_by             	INT UNSIGNED 	NOT NULL
, last_update_date            	DATE         	NOT NULL
, KEY credit_card_fk1
, CONSTRAINT credit_card_fk1 FOREIGN KEY (account_id) REFERENCES account (account_id)
, KEY credit_card_fk2
, CONSTRAINT credit_card_fk2 FOREIGN KEY (credit_card_type) REFERENCES credit_card_type (credit_card_type_id)
, KEY credit_card_fk3
, CONSTRAINT credit_card_fk3 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY credit_card_fk4 (last_updated_by)
, CONSTRAINT credit_card_fk4 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Conditionally drop objects.
SELECT 'credit_card_type' AS "Drop Table";
DROP TABLE IF EXISTS credit_card_type;

SELECT 'credit_card_type' AS 'create table';

CREATE TABLE credit_card_type
( credit_card_type_id 			INT UNSIGNED PRIMARY KEY AUTO_INCREMENT
, credit_card_type 				INT UNSIGNED
, created_by                  	INT UNSIGNED 	NOT NULL
, creation_date               	DATE         	NOT NULL
, last_updated_by             	INT UNSIGNED 	NOT NULL
, last_update_date            	DATE         	NOT NULL
, KEY credit_card_type_fk1
, CONSTRAINT credit_card_type_fk1 FOREIGN KEY (created_by) REFERENCES system_user (system_user_id)
, KEY credit_card_type_fk2 (last_updated_by)
, CONSTRAINT credit_card_type_fk2 FOREIGN KEY (last_updated_by) REFERENCES system_user (system_user_id)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- create address table
-- create address_type table
-- create city table
-- create state table
-- create postal_code table
-- create item table
-- create item_category table
-- create item_subcategory table
-- Create transaction Table
-- create transaction_item table
-- create price table
-- create price_type table

-- Commit inserts.
COMMIT;

-- Display tables.
SHOW TABLES;

-- Close log file.
NOTEE