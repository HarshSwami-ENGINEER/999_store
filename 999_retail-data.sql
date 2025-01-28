-- 99 Online Retail Store Database Schema

-- Copyright (c) 2023, 99 Online Retail Store
-- Arjun Mehra(2020178) , Sarthak Kumar(2020241)
-- All rights reserved. 


SET NAMES utf8mb4;
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

DROP SCHEMA IF EXISTS retailstore;
CREATE SCHEMA retailstore;
USE retailstore;

DROP TABLE IF EXISTS Account;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Supplier;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS reslove;
DROP TABLE IF EXISTS has_rating;
DROP TABLE IF EXISTS chooses;
DROP TABLE IF EXISTS has_account;
DROP TABLE IF EXISTS has_product;
DROP TABLE IF EXISTS has;
DROP TABLE IF EXISTS has_order;

--
-- Table structure for table `Account`
--

create table Account (
	account_ID INT NOT NULL AUTO_INCREMENT,
	Username VARCHAR(50) NOT NULL UNIQUE,
	Password VARCHAR(50) NOT NULL,
	PRIMARY KEY (account_ID)
);

--
-- Table structure for table `Customer`
--
create table Customer (
	Customer_ID INT NOT NULL AUTO_INCREMENT,
	customer_name VARCHAR(50) NOT NULL,
	DOB DATE NOT NULL,
	Gender VARCHAR(50) NOT NULL,
	customer_address VARCHAR(100) NOT NULL,
	phone_no VARCHAR(50) NOT NULL,
	customer_email VARCHAR(100) NOT NULL,
    PRIMARY KEY (Customer_ID)
);


--
-- Table structure for table `Order`
--
create table Orders (
	O_id INT NOT NULL AUTO_INCREMENT,
	Order_Total FLOAT NOT NULL,
	Payment_Mode VARCHAR(50) NOT NULL,
	Shipping_Address VARCHAR(100) NOT NULL,
	Expected_Delivry VARCHAR(100) NOT NULL,
    PRIMARY KEY (O_id) 
);

--
-- Table structure for table `Supplier`
--
create table Supplier (
	S_id INT NOT NULL AUTO_INCREMENT,
	Sname VARCHAR(50) NOT NULL,
	Contact VARCHAR(50) NOT NULL,
	Address VARCHAR(100) NOT NULL,
	PRIMARY KEY (S_id)
);

--
-- Table structure for table `product`
--


CREATE TABLE product (
    P_id INT NOT NULL AUTO_INCREMENT,
    Pname VARCHAR(50) NOT NULL,
    Brand VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Stock VARCHAR(100) NOT NULL,
    Offer INT NOT NULL,
    PRIMARY KEY (P_id),
    CHECK (Price >= 0)
);

--
-- Table structure for table `Category`
--
create table Category (
	Cid INT NOT NULL AUTO_INCREMENT,
	Category_Name VARCHAR(11) NOT NULL,
	Category_info VARCHAR(100) NOT NULL,
	PRIMARY KEY (Cid)
);

--
--  Table structure for table `Employee`
--
create table Employee (
	Employee_ID INT NOT NULL AUTO_INCREMENT,
	Ename VARCHAR(50) NOT NULL,
	Designation VARCHAR(19) NOT NULL,
	Email VARCHAR(50) NOT NULL,
	Phone_no VARCHAR(50) NOT NULL,
    PRIMARY KEY (Employee_ID)
);


--  Table for Relational Database

create table resolve (
    Employee_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    forum VARCHAR(100) NOT NULL,
    f_status VARCHAR(50) NOT NULL,
    Foreign key(Employee_ID) references Employee(Employee_ID) on delete cascade,
    Foreign key(Customer_ID) references Customer(Customer_ID) on delete cascade,
    PRIMARY KEY (Customer_ID, Employee_ID)
);

create table has_rating (
    Customer_ID INT NOT NULL,
    forum VARCHAR(100) NOT NULL,
    rating INT NOT NULL,
    Foreign key(Customer_ID) references Customer(Customer_ID) on delete cascade,
    PRIMARY KEY (Customer_ID)
);

create table chooses(
    customer_id INT NOT NULL,
	product_id INT NOT NULL,
	category_id INT,
    quantity INT NOT NULL,
	Foreign key(product_id) references product(P_id) on delete cascade,
	Foreign key(category_id) references Category(Cid) on delete cascade,
    Foreign key(customer_id) references Customer(Customer_ID) on delete cascade,
	Primary key(product_id, customer_id),
    CHECK ( quantity> 0)
);

create table has (
    Customer_ID INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    Foreign key(Customer_ID) references Customer(Customer_ID) on delete cascade,
    Foreign key(product_id) references product(P_id) on delete cascade,
    PRIMARY KEY (Customer_ID, product_id)
);

create table has_order (
    Customer_ID INT NOT NULL,
    O_id INT NOT NULL,
    Foreign key(Customer_ID) references Customer(Customer_ID) on delete cascade,
    Foreign key(O_id) references Orders(O_id) on delete cascade,
    PRIMARY KEY (Customer_ID, O_id)
);

create table has_product (
    Supplier_ID INT NOT NULL,
    product_id INT NOT NULL,
    Foreign key(Supplier_ID) references Supplier(S_id) on delete cascade,
    Foreign key(product_id) references product(P_id) on delete cascade,
    PRIMARY KEY (Supplier_ID, product_id)
);

create table has_category (
    Supplier_ID INT NOT NULL,
    category_id INT NOT NULL,
    Foreign key(Supplier_ID) references Supplier(S_id) on delete cascade,
    Foreign key(category_id) references Category(Cid) on delete cascade,
    PRIMARY KEY (Supplier_ID, category_id)
);

create table has_account (
    Customer_ID INT NOT NULL,
    account_ID INT NOT NULL,
    Foreign key(Customer_ID) references Customer(Customer_ID) on delete cascade,
    Foreign key(account_ID) references Account(account_ID) on delete cascade,
    PRIMARY KEY (Customer_ID, account_ID)
);

--
--  Below Code to be Check
--
drop view if exists userproductView;
drop view if exists categoryUserView;
drop view if exists protectedUserView;

-- View products using user 
Create VIEW userproductView AS
SELECT Pname, Price, Brand
From product;

-- view categories from user privileges
create view categoryUserView as 
select category_name, category_info 
From category;

-- View users using admin privileges
Create VIEW protectedUserView AS
SELECT Customer_ID, customer_address, customer_name, customer_email, phone_no
From Customer;