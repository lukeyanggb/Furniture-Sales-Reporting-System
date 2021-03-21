-- 
DROP TABLE IF EXISTS Store, Childcare, Contains, Discount, InCategory, Date, City, Transaction, Product, Category, Holiday, Campaign, BelongTo CASCADE;

-- Tables
CREATE TABLE Store(
store_number varchar(50) NOT NULL,
phone_number varchar(50) NOT NULL,
restaurant bool NOT NULL,
snack_bar bool NOT NULL,
address varchar(50) NOT NULL,
state varchar(50) NOT NULL,
city_name varchar(50) NOT NULL,
maximum_time int NOT NULL,
PRIMARY KEY (store_number));

CREATE TABLE Childcare(
maximum_time int NOT NULL,
PRIMARY KEY (maximum_time));

CREATE TABLE Contains(
store_number varchar(50) NOT NULL,
productID varchar(50) NOT NULL,
PRIMARY KEY(store_number, productID));

CREATE TABLE Discount(
productID varchar(50) NOT NULL,
date date NOT NULL,
discount_price float8 NULL,
PRIMARY KEY(productID,date));

CREATE TABLE InCategory(
category_name varchar(50) NOT NULL,
productID varchar(50) NOT NULL,
PRIMARY KEY (category_name, productID));

CREATE TABLE Date(
date date NOT NULL,
PRIMARY KEY(date));

CREATE TABLE City(
state varchar(50) NOT NULL,
city_name varchar(50) NOT NULL,
city_population int NOT NULL,
PRIMARY KEY (state, city_name));

CREATE TABLE Transaction(
store_number varchar(50) NOT NULL,
productID varchar(50) NOT NULL,
date date NOT NULL,
quantity int NOT NULL,
PRIMARY KEY(store_number, date, productID));

CREATE TABLE Product(
productID varchar(50) NOT NULL,
regular_price float8 NOT NULL,
product_name varchar(50) NOT NULL,
PRIMARY KEY(productID));

CREATE TABLE Category(
category_name varchar(50) NOT NULL,
PRIMARY KEY(category_name));

CREATE TABLE Holiday(
date date NOT NULL,
holiday_name varchar(50) NOT NULL,
PRIMARY KEY(date));

CREATE TABLE Campaign(
campaign_description varchar(150) NOT NULL,
start_date date NOT NULL,
end_date date NOT NULL,
PRIMARY KEY(campaign_description));

CREATE TABLE BelongTo(
date date NOT NULL,
campaign_description varchar(150) NOT NULL,
PRIMARY KEY(date, campaign_description));

-- Constraints Foreign Keys: FK_ChildTable_childColumn_ParentTable_parentColumn
ALTER TABLE Store
ADD CONSTRAINT fk_Store_state_cityname_City_state_cityname FOREIGN KEY (state, city_name) REFERENCES City(state, city_name),
ADD CONSTRAINT fk_Store_maximumtime_Childcare_maximumtime FOREIGN KEY (maximum_time) REFERENCES Childcare(maximum_time);


ALTER TABLE BelongTo
ADD CONSTRAINT fk_BelongTo_date_Date_date FOREIGN KEY (date) REFERENCES Date(date),
ADD CONSTRAINT fk_BelongTo_campaign_description_Campaign_campaign_description FOREIGN KEY (campaign_description) REFERENCES Campaign(campaign_description);

ALTER TABLE InCategory
ADD CONSTRAINT fk_InCategory_productID_Product_productID FOREIGN KEY (productID) REFERENCES Product(productID),
ADD CONSTRAINT fk_InCategory_categoryname_Category_categoryname FOREIGN KEY (category_name) REFERENCES Category(category_name);

ALTER TABLE Transaction
ADD CONSTRAINT fk_Transaction_storenumber_Store_storenumber FOREIGN KEY (store_number) REFERENCES Store(store_number),
ADD CONSTRAINT fk_Transaction_productID_Product_productID FOREIGN KEY(productID) REFERENCES Product(productID),
ADD CONSTRAINT fk_Transaction_date_Date_date FOREIGN KEY (date) REFERENCES Date(date);

ALTER TABLE Contains
ADD CONSTRAINT fk_Contains_storenumber_Store_storenumber FOREIGN KEY (store_number) REFERENCES Store(store_number),
ADD CONSTRAINT fk_Contains_productID_Product_productID FOREIGN KEY (productID) REFERENCES Product(productID);

ALTER TABLE Discount
ADD CONSTRAINT fk_Discount_productID_Product_productID FOREIGN KEY (productID) REFERENCES Product(productID),
ADD CONSTRAINT fk_Contains_date_Date_date FOREIGN KEY (date) REFERENCES Date(date);


-- Install the additional module tablefunc, which provides the function crosstab(). 
-- We will need crosstab to create pivot table for some reports.
CREATE EXTENSION IF NOT EXISTS tablefunc;