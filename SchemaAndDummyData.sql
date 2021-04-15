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

-- Dummy Data:
-- insert dummy data for test:
-- Childcare
INSERT INTO Childcare
VALUES (0), (15), (30), (60);

-- Date
INSERT INTO Date
SELECT * FROM generate_series('2015-01-01'::date, '2021-03-20', interval '1' day) AS t(dt);

-- City
insert into City (state, city_name, city_population) values ('NY', 'Albany', 5936464);
insert into City (state, city_name, city_population) values ('NY', 'New York City', 4768503);
insert into City (state, city_name, city_population) values ('NY', 'Syracuse', 8884406);
insert into City (state, city_name, city_population) values ('GA', 'Atlanta', 3059488);
insert into City (state, city_name, city_population) values ('MI', 'Ann Arbor', 3635119);
insert into City (state, city_name, city_population) values ('GA', 'Duluth', 3291916);
insert into City (state, city_name, city_population) values ('MI', 'Grand Rapids', 8031583);
insert into City (state, city_name, city_population) values ('GA', 'Macon', 9411111);
insert into City (state, city_name, city_population) values ('GA', 'Lawrenceville', 5505344);
insert into City (state, city_name, city_population) values ('MA', 'Watertown', 2457074);
insert into City (state, city_name, city_population) values ('MA', 'Waltham', 10970015);
insert into City (state, city_name, city_population) values ('NY', 'Buffalo', 4407856);
insert into City (state, city_name, city_population) values ('NY', 'Jamaica', 5823348);
insert into City (state, city_name, city_population) values ('MA', 'Boston', 1482087);
insert into City (state, city_name, city_population) values ('NY', 'Rochester', 2838114);

-- Store
INSERT INTO Store
VALUES ('No.1', '6666666666', FALSE, FALSE, '666 Dummy Street', 'NY', 'Rochester', 0), 
('No.2', '6666666666', TRUE, TRUE, '666 Dummy Street', 'MA', 'Boston', 15),
('No.3', '6666666666', FALSE, FALSE, '666 Dummy Street', 'NY', 'Jamaica', 30),
('No.4', '6666666666', TRUE, TRUE, '666 Dummy Street', 'NY', 'Buffalo', 60),
('No.5', '6666666666', FALSE, FALSE, '666 Dummy Street', 'MA', 'Waltham', 30),
('No.6', '6666666666', FALSE, FALSE, '666 Dummy Street', 'MA', 'Watertown', 15),
('No.7', '6666666666', TRUE, TRUE, '666 Dummy Street', 'GA', 'Lawrenceville', 0),
('No.8', '6666666666', FALSE, FALSE, '666 Dummy Street', 'GA', 'Macon', 60),
('No.9', '6666666666', TRUE, TRUE, '666 Dummy Street', 'MI', 'Grand Rapids', 30),
('No.10', '6666666666', FALSE, FALSE, '666 Dummy Street', 'GA', 'Duluth', 15),
('No.11', '6666666666', FALSE, FALSE, '666 Dummy Street', 'MI', 'Ann Arbor', 0),
('No.12', '6666666666', FALSE, FALSE, '666 Dummy Street', 'GA', 'Atlanta', 30),
('No.13', '6666666666', FALSE, FALSE, '666 Dummy Street', 'NY', 'Syracuse', 60),
('No.14', '6666666666', FALSE, FALSE, '666 Dummy Street', 'NY', 'Albany', 0),
('No.15', '6666666666', FALSE, FALSE, '666 Dummy Street', 'NY', 'New York City', 15);

-- Campaign
insert into campaign (campaign_description, start_date, end_date) values ( 'Cencoroll', '3/14/2021', '3/17/2021');
insert into campaign (campaign_description, start_date, end_date) values ( 'Once Upon a Time in the Midlands', '1/27/2021', '1/29/2021');
insert into campaign (campaign_description, start_date, end_date) values ( 'Shanghaied', '1/3/2021', '1/5/2021');

-- Belongto
insert into belongto (date, campaign_description) values ('3/14/2021', 'Cencoroll');
insert into belongto (date, campaign_description) values ('3/15/2021', 'Cencoroll');
insert into belongto (date, campaign_description) values ('3/16/2021', 'Cencoroll');
insert into belongto (date, campaign_description) values ('3/17/2021', 'Cencoroll');
insert into belongto (date, campaign_description) values ('1/27/2021', 'Once Upon a Time in the Midlands');
insert into belongto (date, campaign_description) values ('1/28/2021', 'Once Upon a Time in the Midlands');
insert into belongto (date, campaign_description) values ('1/29/2021', 'Once Upon a Time in the Midlands');
insert into belongto (date, campaign_description) values ('1/3/2021', 'Shanghaied');
insert into belongto (date, campaign_description) values ('1/4/2021', 'Shanghaied');
insert into belongto (date, campaign_description) values ('1/5/2021', 'Shanghaied');

-- Product
INSERT INTO Product
VALUES ('ID.1', 10, 'A'), ('ID.2', 5, 'B'), ('ID.3', 12, 'C'), ('ID.4', 20, 'D'), ('ID.5', 3, 'E');

-- Category
INSERT INTO Category
VALUES ('Outdoor Furniture'), ('Couches'), ('Pots and Pans'), ('Toy'), ('Movies');



-- InCategory
insert into InCategory (productID, category_name) values ('ID.3', 'Outdoor Furniture');
insert into InCategory (productID, category_name) values ('ID.5', 'Outdoor Furniture');
insert into InCategory (productID, category_name) values ('ID.2', 'Couches');
insert into InCategory (productID, category_name) values ('ID.5', 'Couches');
insert into InCategory (productID, category_name) values ('ID.3', 'Pots and Pans');
insert into InCategory (productID, category_name) values ('ID.4', 'Outdoor Furniture');
insert into InCategory (productID, category_name) values ('ID.5', 'Movies');
insert into InCategory (productID, category_name) values ('ID.1', 'Outdoor Furniture');
insert into InCategory (productID, category_name) values ('ID.1', 'Movies');
insert into InCategory (productID, category_name) values ('ID.2', 'Outdoor Furniture');


-- Holiday
insert into Holiday (date, holiday_name) values ('1/9/2019', 'Dodge');
insert into Holiday (date, holiday_name) values ('6/21/2018', 'Volvo');
insert into Holiday (date, holiday_name) values ('4/14/2017', 'Chevrolet');
insert into Holiday (date, holiday_name) values ('9/29/2020', 'Pontiac');
insert into Holiday (date, holiday_name) values ('4/26/2018', 'Chevrolet');
insert into Holiday (date, holiday_name) values ('3/5/2019', 'Oldsmobile');
insert into Holiday (date, holiday_name) values ('8/4/2019', 'Lexus');
insert into Holiday (date, holiday_name) values ('11/4/2020', 'Bentley');
insert into Holiday (date, holiday_name) values ('10/29/2019', 'Oldsmobile');
insert into Holiday (date, holiday_name) values ('5/21/2020', 'Nissan');


-- Discount
insert into Discount (productID, date, discount_price) values ('ID.4', '2021-01-12', 15);
insert into Discount (productID, date, discount_price) values ('ID.5', '2020-01-18', 2);
insert into Discount (productID, date, discount_price) values ('ID.1', '2021-01-25', 8);
insert into Discount (productID, date, discount_price) values ('ID.4', '2020-07-01', 15);
insert into Discount (productID, date, discount_price) values ('ID.4', '2020-06-28', 14);
insert into Discount (productID, date, discount_price) values ('ID.3', '2020-10-31', 10);
insert into Discount (productID, date, discount_price) values ('ID.5', '2020-11-01', 2);
insert into Discount (productID, date, discount_price) values ('ID.5', '2021-01-09', 2);
insert into Discount (productID, date, discount_price) values ('ID.1', '2021-02-21', 8);
insert into Discount (productID, date, discount_price) values ('ID.4', '2020-02-14', 16);
insert into Discount (productID, date, discount_price) values ('ID.4', '2020-11-14', 16);
insert into Discount (productID, date, discount_price) values ('ID.5', '2020-02-20', 2);
insert into Discount (productID, date, discount_price) values ('ID.1', '2020-03-31', 8);
insert into Discount (productID, date, discount_price) values ('ID.1', '2020-03-21', 8);
insert into Discount (productID, date, discount_price) values ('ID.4', '2020-03-01', 15);
insert into Discount (productID, date, discount_price) values ('ID.4', '2020-09-06', 15);
insert into Discount (productID, date, discount_price) values ('ID.4', '2020-09-26', 15);
insert into Discount (productID, date, discount_price) values ('ID.3', '2020-02-07', 10);
insert into Discount (productID, date, discount_price) values ('ID.4', '2021-01-07', 15);
insert into Discount (productID, date, discount_price) values ('ID.2', '2020-10-22', 4);
insert into Discount (productID, date, discount_price) values ('ID.2', '2021-01-05', 4);
insert into Discount (productID, date, discount_price) values ('ID.3', '2020-10-10', 10);
insert into Discount (productID, date, discount_price) values ('ID.2', '2021-01-07', 4);
insert into Discount (productID, date, discount_price) values ('ID.3', '2020-08-14', 10);
insert into Discount (productID, date, discount_price) values ('ID.2', '2020-02-12', 4);
insert into Discount (productID, date, discount_price) values ('ID.5', '2020-12-13', 2);
insert into Discount (productID, date, discount_price) values ('ID.5', '2020-07-23', 4);
insert into Discount (productID, date, discount_price) values ('ID.2', '2021-01-30', 4);
insert into Discount (productID, date, discount_price) values ('ID.5', '2020-02-17', 2);
insert into Discount (productID, date, discount_price) values ('ID.3', '2020-09-12', 10);

-- Transaction
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2018-02-13', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2015-10-30', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2019-06-10', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2017-06-22', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2020-03-29', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2017-09-08', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2018-01-25', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2017-08-12', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2019-04-01', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2017-05-05', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2017-02-05', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2018-07-29', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2019-07-15', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.4', '2020-06-01', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2018-01-27', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2018-01-04', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2021-02-02', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2016-12-28', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2020-02-09', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2019-03-21', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2015-03-01', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2016-07-12', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2015-07-07', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2016-09-20', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2017-09-07', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2016-07-06', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2017-05-24', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2016-08-15', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2018-03-28', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.3', '2019-01-20', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2017-01-05', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2019-02-02', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2017-12-21', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2015-08-11', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2017-06-23', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2016-03-28', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2019-05-07', 9);

insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2015-08-10', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2018-05-24', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2018-04-11', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2017-08-24', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.4', '2015-11-30', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2018-10-04', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2020-04-04', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2016-06-29', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2018-08-12', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2016-05-18', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2015-10-02', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2016-05-20', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.5', '2017-06-22', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2017-07-28', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.3', '2016-09-01', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2020-02-18', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2020-12-18', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2019-02-26', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2017-12-08', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2015-03-25', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2018-12-05', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2018-10-17', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2018-12-18', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2019-12-26', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2018-02-02', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2020-11-03', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2020-07-31', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2021-02-25', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2018-06-11', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2016-11-07', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2017-03-05', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2015-03-02', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2018-12-17', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2018-03-18', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2016-07-21', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2016-01-20', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2016-03-06', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2021-02-20', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2018-11-22', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.1', '2017-04-17', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2020-12-18', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2020-09-05', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2015-09-21', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2017-10-21', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2016-09-11', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2016-06-14', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2015-03-08', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2020-06-14', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.3', '2019-11-25', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2016-02-02', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.5', '2018-03-28', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2020-03-09', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2019-06-08', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2017-09-04', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2016-12-29', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2016-10-06', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.4', '2019-08-13', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2019-02-14', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2015-05-31', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2019-08-17', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2017-01-09', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2019-05-16', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2019-03-08', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.5', '2019-08-11', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2019-04-02', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2017-03-01', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2020-05-19', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2015-11-02', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2021-02-05', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2016-03-13', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2018-01-13', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2018-01-21', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2017-01-09', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2019-08-28', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2017-12-16', 14);

insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.4', '2020-10-29', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2018-05-30', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2016-06-29', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2016-04-30', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2016-06-18', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2016-10-24', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2018-10-30', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2016-11-11', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2020-05-06', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2019-08-08', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2019-12-29', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2021-01-10', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2018-09-19', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2021-02-04', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2017-11-05', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2020-08-21', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2017-06-26', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2016-07-13', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2016-12-16', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2018-11-16', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2020-08-04', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2018-01-04', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2017-02-01', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2017-02-23', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2015-11-10', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2015-01-26', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2017-04-22', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2020-02-10', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2020-01-22', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2018-01-20', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2016-02-08', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2016-01-18', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2020-09-23', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2018-09-21', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2019-01-29', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2019-07-02', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2017-06-12', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2015-06-01', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2016-05-28', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2017-02-02', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2015-11-27', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2016-01-04', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.5', '2018-05-12', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2018-05-20', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2016-11-06', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2016-12-17', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2016-08-01', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2015-05-21', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2019-09-05', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2020-03-16', 2);

insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2017-01-14', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2016-10-27', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2019-05-31', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2020-10-27', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2020-04-15', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2018-11-09', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.5', '2019-12-07', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2019-05-22', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2021-01-25', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2018-04-05', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.5', '2019-04-18', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2018-03-09', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.5', '2015-03-08', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2015-06-14', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2020-06-29', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2015-08-12', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2017-03-24', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2017-06-27', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2017-07-18', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2020-05-16', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2019-02-02', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2019-09-23', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2020-02-10', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2020-08-28', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2015-04-05', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2020-11-16', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2017-06-23', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2016-12-30', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2016-06-28', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2017-03-17', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2018-07-23', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2019-12-31', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2021-02-24', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2020-01-02', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2016-05-11', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2019-06-05', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2020-11-22', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2017-07-13', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2015-05-11', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.1', '2019-01-22', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2018-03-18', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2020-07-21', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2020-07-18', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2019-06-23', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2019-06-05', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2017-12-23', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2020-03-13', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2019-01-31', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2018-01-31', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2018-08-21', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2020-10-14', 10);

insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2018-11-24', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2016-12-02', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2018-08-29', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2016-02-08', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2018-12-16', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2016-09-21', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2020-01-17', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2018-10-20', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2015-06-21', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2018-11-13', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2017-02-02', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2019-09-22', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2017-05-08', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2020-10-30', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2018-01-27', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2016-11-27', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2020-11-27', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2018-05-29', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2015-03-03', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2016-04-14', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2017-06-20', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2018-07-02', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2016-08-28', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2016-12-30', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2020-10-27', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2016-04-30', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2019-02-23', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2017-12-29', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2016-10-24', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2020-05-07', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2016-01-22', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2015-07-01', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2019-09-09', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.3', '2015-03-12', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2019-08-31', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2015-08-01', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2020-04-30', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2016-09-07', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2016-11-03', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2018-06-24', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2015-06-29', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2015-02-22', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2018-06-06', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2015-01-29', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2017-07-05', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2016-08-18', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2015-07-15', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2016-04-18', 15);

insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.4', '2015-07-01', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2019-12-23', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2019-08-23', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2020-10-12', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2017-07-27', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2015-09-12', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2017-10-12', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2015-11-29', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2017-12-05', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2016-09-11', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2016-06-12', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2018-07-09', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2017-11-13', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2017-05-17', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2018-12-11', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2020-08-30', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2018-09-03', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2020-06-18', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2015-01-07', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2020-05-04', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2018-08-18', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2018-02-02', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2017-08-18', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2018-06-23', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2020-06-17', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2020-04-11', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2019-07-25', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2017-08-12', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2018-03-10', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2018-07-04', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2019-10-15', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2017-03-13', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2016-08-14', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2015-10-03', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2016-06-28', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2018-07-14', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2019-07-07', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2017-06-25', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2018-09-17', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2020-11-13', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2015-06-17', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2016-03-08', 2);

insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2019-01-02', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2017-03-30', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2020-02-07', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2016-09-25', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2019-02-23', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2019-04-28', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2019-01-18', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2016-11-26', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2016-04-15', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2016-02-02', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2018-04-03', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2020-09-27', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2020-11-04', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2016-05-01', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.5', '2017-01-06', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2015-07-15', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2020-05-12', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2015-09-16', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2016-08-30', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2018-03-03', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2020-01-21', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2020-07-24', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2017-07-09', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2018-03-30', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2015-09-26', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2017-01-28', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2020-03-24', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2018-11-15', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2019-02-14', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2016-04-26', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2016-03-24', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2020-02-01', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2016-12-25', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2016-10-21', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2018-03-22', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2021-03-10', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2019-05-20', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2017-03-18', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2017-01-23', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2017-11-11', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.4', '2017-12-18', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2015-03-24', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2016-04-23', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2018-12-17', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2020-11-05', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2021-01-08', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2018-11-16', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2017-01-10', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2018-06-20', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2019-10-08', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2019-01-01', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2019-08-18', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2015-02-23', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2019-07-16', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2018-02-21', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2015-08-21', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2015-10-26', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2020-04-13', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2016-02-02', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2020-05-18', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.5', '2017-04-27', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2020-01-15', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.4', '2018-09-06', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2019-04-12', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2018-08-17', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2016-11-06', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2020-10-08', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.1', '2015-10-16', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.4', '2019-11-11', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2017-07-11', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2020-02-27', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2020-10-07', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2015-10-20', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2020-04-24', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2015-02-15', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2016-08-11', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2016-08-22', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2016-01-04', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2018-12-08', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2020-06-04', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2017-10-01', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2018-01-08', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.4', '2019-08-23', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2019-10-14', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2018-05-16', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2020-05-06', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2016-08-29', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2017-06-16', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2016-12-23', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2016-06-11', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2018-04-13', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2019-09-06', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2020-06-17', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2018-10-01', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2015-02-05', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2020-04-01', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2019-12-30', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2018-02-18', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2016-05-26', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2021-03-15', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2017-04-27', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2016-04-13', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2020-02-27', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2020-04-02', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2017-10-23', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2019-10-26', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2016-02-05', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2018-07-21', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2020-02-02', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2017-01-30', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2015-01-25', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2018-04-03', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2018-04-14', 10);

insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2015-03-30', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2020-09-30', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2018-05-03', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2015-02-06', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2018-03-07', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2020-11-14', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2019-06-27', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2016-11-26', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2017-07-08', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.5', '2019-03-19', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2016-04-12', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2019-03-19', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.5', '2016-05-29', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2020-08-08', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2016-06-12', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2016-01-07', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2017-12-10', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2016-02-02', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2016-09-27', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2017-03-04', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2018-08-20', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2019-05-12', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2017-05-29', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2018-04-04', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2016-07-07', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2018-07-28', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2017-04-29', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.4', '2018-06-10', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2020-08-28', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2016-09-29', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2017-06-23', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2020-04-25', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2019-01-10', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2018-12-05', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2015-02-02', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.1', '2018-04-01', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2019-10-22', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2019-02-04', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2015-08-26', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.4', '2020-04-10', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2015-01-09', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2020-01-04', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2017-06-22', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2016-04-05', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2019-01-28', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.5', '2020-04-26', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2020-08-07', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2015-10-15', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2016-02-13', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2015-03-11', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2017-12-09', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2018-07-17', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2017-03-12', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2015-05-21', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2017-11-09', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2016-11-04', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2018-06-16', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.3', '2018-12-10', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2017-04-10', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2019-03-21', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2018-12-14', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2016-02-22', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2016-03-17', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.3', '2015-10-26', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2016-12-07', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2020-03-30', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2017-09-15', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2018-04-10', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2020-04-29', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2017-02-21', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2018-12-20', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2020-12-16', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2018-09-16', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2015-12-08', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2018-06-20', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2019-06-23', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2017-10-19', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2016-05-09', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2016-05-13', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2017-04-08', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2018-09-12', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2015-01-23', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2018-08-04', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2018-06-22', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2020-01-28', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2019-05-26', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.4', '2018-02-23', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2016-07-22', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2018-11-11', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2016-11-21', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2020-09-03', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.5', '2017-12-20', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2020-02-02', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.3', '2019-08-27', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2018-06-23', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.4', '2018-08-10', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2017-08-27', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2016-03-13', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2018-05-16', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2018-04-24', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2017-01-09', 13);

insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2018-01-20', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2020-04-22', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2017-02-19', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2020-12-15', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2016-03-11', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2016-06-12', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2016-05-17', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2016-10-11', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2019-04-06', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2015-12-06', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2017-05-17', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2018-07-22', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2020-06-14', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2019-02-03', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2016-08-19', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2019-02-05', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2015-03-18', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2018-06-02', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2020-02-15', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2017-09-24', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2018-12-28', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.5', '2021-01-01', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2020-04-28', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2019-12-14', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2016-06-03', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2016-08-26', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2019-01-15', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2019-10-13', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2016-11-16', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2018-09-27', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2021-01-05', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2016-07-05', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2015-12-29', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2020-03-28', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2018-10-19', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2015-05-15', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2016-11-23', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2015-10-08', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2018-07-29', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2015-02-14', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2015-02-28', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2015-08-02', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2018-02-22', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2018-12-18', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.1', '2019-07-30', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2015-11-18', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2019-04-26', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2017-01-15', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2015-08-12', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2017-04-09', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2018-01-27', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2019-11-01', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2018-05-20', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2016-12-27', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2020-09-16', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2020-04-29', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2015-11-10', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2019-05-28', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2015-03-06', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.4', '2018-11-06', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.5', '2019-12-01', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2018-07-18', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2017-03-18', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2017-10-13', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2015-05-01', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2015-12-02', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2018-12-13', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2016-12-28', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2021-02-17', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2020-04-20', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2019-02-02', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2017-11-27', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2017-09-16', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2015-04-26', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2015-07-06', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2020-09-30', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2016-06-04', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2020-09-06', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2019-03-02', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2016-07-29', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2016-02-07', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2018-03-29', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2017-05-17', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2020-03-05', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.1', '2019-06-24', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2016-05-24', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2019-01-18', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2017-10-17', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2019-09-05', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2015-07-07', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2016-03-03', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2018-05-23', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2020-04-17', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2017-07-14', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2016-04-15', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.4', '2018-09-23', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2015-12-24', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2016-01-30', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2020-02-03', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.4', '2016-01-28', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2020-10-05', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2020-09-01', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2018-03-10', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2015-03-13', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2020-03-06', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2016-10-24', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2016-08-22', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2019-06-22', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2016-02-23', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2018-10-19', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2016-05-05', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2017-03-05', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2015-03-14', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2015-08-31', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2017-09-05', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2019-01-29', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2018-02-19', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.5', '2018-03-05', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2018-07-21', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2016-06-15', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.5', '2016-05-01', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.1', '2021-03-09', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2018-11-06', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2015-05-06', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2016-04-15', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2019-07-05', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2017-10-06', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2020-08-01', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2021-01-03', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2016-08-21', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.3', '2018-12-03', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2017-12-16', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2018-09-26', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2020-07-24', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2017-05-18', 11);

insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2018-01-22', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2015-02-02', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2016-07-18', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2019-10-09', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.2', '2017-03-17', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.2', '2016-07-08', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2021-01-12', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2017-10-26', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2015-05-30', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2017-01-08', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2017-03-21', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2019-01-04', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2020-03-08', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2017-04-22', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.1', '2018-01-30', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2019-09-06', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2019-01-18', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2018-12-02', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2017-02-02', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2018-07-10', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2017-01-19', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2020-03-08', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2019-03-17', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2018-09-10', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2017-01-23', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2020-04-29', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.2', '2016-11-12', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2015-08-01', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2016-07-18', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2016-03-23', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.5', '2017-11-10', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.3', '2015-02-05', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2019-07-23', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2019-11-28', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.1', '2019-12-11', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2020-09-10', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2015-01-08', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.4', '2017-07-18', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2015-12-21', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2015-01-24', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2020-08-20', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2019-01-06', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.5', '2017-05-23', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2017-11-02', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2018-01-24', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2020-08-04', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2017-08-07', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2018-08-24', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2016-10-08', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2018-02-02', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2018-08-08', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2018-12-30', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2018-08-23', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2020-02-29', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2015-06-05', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2017-01-04', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2016-12-01', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2018-02-22', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.3', '2021-01-30', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2020-08-21', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.3', '2017-11-10', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.5', '2020-09-14', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.5', '2018-09-06', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2019-08-01', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2020-06-07', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.5', '2020-10-06', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2017-01-07', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2019-05-02', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2015-03-13', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.3', '2016-12-08', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.4', '2019-03-18', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.5', '2015-09-04', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2020-09-11', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.1', '2019-10-17', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2020-09-29', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2019-09-13', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2018-09-02', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2021-02-07', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.2', '2017-04-02', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2016-12-10', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.5', '2018-02-02', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2016-09-07', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2020-11-27', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2017-01-06', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2016-01-01', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2016-09-22', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.2', '2015-03-14', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.1', '2016-05-04', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2018-03-03', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.2', '2017-03-30', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.3', '2019-08-31', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.3', '2020-05-12', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.1', '2019-09-15', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2020-11-08', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.3', '2018-07-30', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.3', '2017-05-29', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2017-06-11', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2018-07-15', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2016-08-13', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.4', '2019-01-27', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2020-12-23', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2020-07-28', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.3', '2015-12-05', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2016-02-02', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.5', '2019-07-31', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2017-03-01', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.3', '2019-05-30', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.2', '2017-07-21', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.2', '2017-02-18', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.4', '2020-01-30', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2021-01-29', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.5', '2016-02-29', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.5', '2017-02-02', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.9', 'ID.3', '2020-05-28', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.2', '2016-12-05', 8);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.1', '2020-11-30', 11);
insert into Transaction (store_number, productID, date, quantity) values ('No.7', 'ID.4', '2020-09-21', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.2', '2019-06-15', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.2', '2018-06-06', 19);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2018-11-30', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2015-09-27', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2016-07-15', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2016-04-18', 5);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.3', '2018-03-15', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.4', '2017-05-17', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.4', '2018-03-29', 16);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.3', '2020-05-04', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2015-03-18', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.1', '2019-10-03', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2020-01-22', 10);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2017-04-07', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.8', 'ID.5', '2020-07-25', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.3', '2020-06-16', 14);
insert into Transaction (store_number, productID, date, quantity) values ('No.3', 'ID.1', '2020-06-22', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.5', '2018-09-17', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.1', '2015-02-02', 18);
insert into Transaction (store_number, productID, date, quantity) values ('No.1', 'ID.5', '2018-07-06', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.3', '2019-02-08', 2);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2017-07-24', 6);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.2', '2016-07-15', 4);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.4', '2015-02-24', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.11', 'ID.2', '2019-07-02', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.1', '2018-05-29', 1);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.3', '2018-06-08', 17);
insert into Transaction (store_number, productID, date, quantity) values ('No.10', 'ID.4', '2017-09-06', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.4', 'ID.2', '2015-04-20', 3);
insert into Transaction (store_number, productID, date, quantity) values ('No.14', 'ID.1', '2017-11-16', 9);
insert into Transaction (store_number, productID, date, quantity) values ('No.2', 'ID.1', '2020-07-25', 15);
insert into Transaction (store_number, productID, date, quantity) values ('No.15', 'ID.4', '2021-01-12', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.6', 'ID.5', '2020-01-18', 7);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.1', '2021-01-25', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.4', '2020-07-01', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.4', '2020-06-28', 20);
insert into Transaction (store_number, productID, date, quantity) values ('No.13', 'ID.3', '2020-10-31', 12);
insert into Transaction (store_number, productID, date, quantity) values ('No.5', 'ID.5', '2020-11-01', 13);
insert into Transaction (store_number, productID, date, quantity) values ('No.12', 'ID.2', '2020-10-22', 20);