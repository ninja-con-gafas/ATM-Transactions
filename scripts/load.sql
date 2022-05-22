CREATE SCHEMA atm;

CREATE TABLE atm.dim_card_type
(
  card_type_id INT NOT NULL,
  card_type VARCHAR(30),
  PRIMARY KEY (card_type_id)
);

CREATE TABLE atm.dim_date
(
  date_id INT NOT NULL,
  full_date_time TIMESTAMP,
  year INT,
  month VARCHAR(20),
  day INT,
  hour INT,
  weekday VARCHAR(20),
  PRIMARY KEY (date_id)
);

CREATE TABLE atm.dim_location
(
  location_id INT NOT NULL,
  location VARCHAR(50),
  streetname VARCHAR(255),
  street_number INT,
  zipcode INT,
  lat DECIMAL(10,3),
  lon DECIMAL(10,3),
  PRIMARY KEY (location_id)
);

CREATE TABLE atm.dim_atm
(
  atm_id INT NOT NULL,
  atm_location_id INT,
  atm_number VARCHAR(20),
  atm_manufacturer VARCHAR(50),
  PRIMARY KEY (atm_id)
);

CREATE TABLE atm.fact_atm_trans
(
  trans_id BIGINT NOT NULL,
  weather_loc_id INT,
  atm_id INT,
  date_id INT,
  card_type_id INT,
  atm_status VARCHAR(20),
  currency VARCHAR(10),
  service VARCHAR(20),
  transaction_amount INT,
  message_code VARCHAR(255),
  message_text VARCHAR(255),
  rain_3h DECIMAL(10,3),
  clouds_all DECIMAL(10,3),
  weather_id INT,
  weather_main VARCHAR(50),
  weather_description VARCHAR(255),
  PRIMARY KEY (trans_id),
  FOREIGN KEY (weather_loc_id) REFERENCES atm.dim_location (location_id),
  FOREIGN KEY (atm_id) REFERENCES atm.dim_atm (atm_id),
  FOREIGN KEY (date_id) REFERENCES atm.dim_date (date_id),
  FOREIGN KEY (card_type_id) REFERENCES atm.dim_card_type (card_type_id)
);

COPY atm.dim_card_type FROM 's3://atm-transaction-assets/dim_card_type/'
IAM_ROLE 'arn:aws:iam::389845201544:role/Amazon_Redshift_Amazon_S3'
DELIMITER ','
IGNOREHEADER 1
REGION 'us-east-1';

COPY atm.dim_date FROM 's3://atm-transaction-assets/dim_date/'
IAM_ROLE 'arn:aws:iam::389845201544:role/Amazon_Redshift_Amazon_S3'
DELIMITER ','
IGNOREHEADER 1
TIMEFORMAT 'YYYY-MM-DDTHH:MI:SS'
REGION 'us-east-1';

COPY atm.dim_location FROM 's3://atm-transaction-assets/dim_location/'
IAM_ROLE 'arn:aws:iam::389845201544:role/Amazon_Redshift_Amazon_S3'
DELIMITER ','
IGNOREHEADER 1
REGION 'us-east-1';

COPY atm.dim_atm FROM 's3://atm-transaction-assets/dim_atm/'
IAM_ROLE 'arn:aws:iam::389845201544:role/Amazon_Redshift_Amazon_S3'
DELIMITER ','
IGNOREHEADER 1
REGION 'us-east-1';

COPY atm.fact_atm_trans FROM 's3://atm-transaction-assets/fact_atm_trans/'
IAM_ROLE 'arn:aws:iam::389845201544:role/Amazon_Redshift_Amazon_S3'
DELIMITER ','
IGNOREHEADER 1
REGION 'us-east-1'
EMPTYASNULL
BLANKSASNULL
REMOVEQUOTES
ESCAPE;
