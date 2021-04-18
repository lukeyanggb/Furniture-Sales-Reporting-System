-- 
DROP TABLE IF EXISTS Store, Childcare, Discount, InCategory, Date, City, Transaction, Product, Category, Holiday, Campaign CASCADE;

-- Tables
CREATE TABLE Store(
store_number varchar(50) NOT NULL,
phone_number varchar(50) NULL,
address varchar(50) NOT NULL,
city_name varchar(50) NOT NULL,
state varchar(50) NOT NULL,
restaurant int NOT NULL,
snack_bar int NOT NULL,
maximum_time int NULL,
PRIMARY KEY (store_number));

CREATE TABLE Childcare(
maximum_time int NOT NULL,
PRIMARY KEY (maximum_time));

CREATE TABLE Discount(
productID varchar(50) NOT NULL,
date date NOT NULL,
discount_price float8 NULL,
PRIMARY KEY(productID,date));

CREATE TABLE InCategory(
productID varchar(50) NOT NULL,
category_name varchar(50) NOT NULL,
PRIMARY KEY (category_name, productID));

CREATE TABLE Date(
date date NOT NULL,
PRIMARY KEY(date));

CREATE TABLE City(
city_name varchar(50) NOT NULL,
state varchar(50) NOT NULL,
city_population int NOT NULL,
PRIMARY KEY (state, city_name));

CREATE TABLE Transaction(
productID varchar(50) NOT NULL,
store_number varchar(50) NOT NULL,
date date NOT NULL,
quantity int NOT NULL,
PRIMARY KEY(store_number, date, productID));

CREATE TABLE Product(
productID varchar(50) NOT NULL,
product_name varchar(50) NOT NULL,
regular_price float8 NOT NULL,
PRIMARY KEY(productID));

CREATE TABLE Category(
category_name varchar(50) NOT NULL,
PRIMARY KEY(category_name));

CREATE TABLE Holiday(
date date NOT NULL,
holiday_name varchar(50) NOT NULL,
PRIMARY KEY(date));

CREATE TABLE Campaign(
date date NOT NULL,
campaign_description varchar(150) NOT NULL,
PRIMARY KEY(date, campaign_description));

-- Constraints Foreign Keys: FK_ChildTable_childColumn_ParentTable_parentColumn
ALTER TABLE Store
ADD CONSTRAINT fk_Store_state_cityname_City_state_cityname FOREIGN KEY (state, city_name) REFERENCES City(state, city_name),
ADD CONSTRAINT fk_Store_maximumtime_Childcare_maximumtime FOREIGN KEY (maximum_time) REFERENCES Childcare(maximum_time);


ALTER TABLE Campaign
ADD CONSTRAINT fk_Campaign_date_Date_date FOREIGN KEY (date) REFERENCES Date(date);

ALTER TABLE InCategory
ADD CONSTRAINT fk_InCategory_productID_Product_productID FOREIGN KEY (productID) REFERENCES Product(productID),
ADD CONSTRAINT fk_InCategory_categoryname_Category_categoryname FOREIGN KEY (category_name) REFERENCES Category(category_name);

ALTER TABLE Transaction
ADD CONSTRAINT fk_Transaction_storenumber_Store_storenumber FOREIGN KEY (store_number) REFERENCES Store(store_number),
ADD CONSTRAINT fk_Transaction_productID_Product_productID FOREIGN KEY(productID) REFERENCES Product(productID),
ADD CONSTRAINT fk_Transaction_date_Date_date FOREIGN KEY (date) REFERENCES Date(date);

ALTER TABLE Discount
ADD CONSTRAINT fk_Discount_productID_Product_productID FOREIGN KEY (productID) REFERENCES Product(productID),
ADD CONSTRAINT fk_Discount_date_Date_date FOREIGN KEY (date) REFERENCES Date(date);


-- Install the additional module tablefunc, which provides the function crosstab(). 
-- We will need crosstab to create pivot table for some reports.
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- Demo Data:
-- Childcare
INSERT INTO Childcare
VALUES (0), (30), (45), (60);

-- Date
INSERT INTO Date
SELECT * FROM generate_series('2000-01-01'::date, '2012-07-01', interval '1' day) AS t(dt);

-- City
COPY City FROM '/data/City.tsv' WITH DELIMITER AS '	';

-- Store
COPY Store FROM '/data/Store.tsv' WITH DELIMITER AS '	';

-- Campaign
COPY Campaign FROM '/data/Campaign.tsv' WITH DELIMITER AS '	';

-- Product
COPY Product FROM '/data/Product.tsv' WITH DELIMITER AS '	';

-- Category
COPY Category FROM '/data/Category.tsv' WITH DELIMITER AS '	';

-- InCategory
COPY InCategory FROM '/data/InCategory.tsv' WITH DELIMITER AS '	';

-- Holiday
COPY Holiday FROM '/data/Holiday.tsv' WITH DELIMITER AS '	';

-- Discount
COPY Discount FROM '/data/Discount.tsv' WITH DELIMITER AS '	';

-- Transaction
COPY Transaction FROM '/data/Transaction.tsv' WITH DELIMITER AS '	';
