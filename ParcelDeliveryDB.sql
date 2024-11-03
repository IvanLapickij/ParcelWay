DROP DATABASE IF EXISTS ParcelDeliveryDB;
CREATE DATABASE IF NOT EXISTS ParcelDeliveryDB;
USE ParcelDeliveryDB;

DROP TABLE IF EXISTS Customers;
-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL
);
-- Insert data into Customers table
INSERT INTO Customers (FullName, Address, Email, Phone) VALUES
('John Doe', '123 Maple St', 'john.doe@example.com', '555-1234'),
('Jane Smith', '456 Oak Ave', 'jane.smith@example.com', '555-5678'),
('Bob Brown', '789 Pine Rd', 'bob.brown@example.com', '555-8765'),
('Alice Green', '101 Elm St', 'alice.green@example.com', '555-4321'),
('Tom White', '202 Cedar Ln', 'tom.white@example.com', '555-2345'),
('Sara Black', '303 Birch Blvd', 'sara.black@example.com', '555-3456'),
('Mike Gray', '404 Spruce Dr', 'mike.gray@example.com', '555-4567'),
('Emma Blue', '505 Ash Ct', 'emma.blue@example.com', '555-5678'),
('Lucas Red', '606 Willow Way', 'lucas.red@example.com', '555-6789'),
('Olivia Purple', '707 Fir Cir', 'olivia.purple@example.com', '555-7890');

-- Create Parcels table
CREATE TABLE Parcels (
    ParcelID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    Weight DECIMAL(5, 2) NOT NULL,
    Dimensions VARCHAR(20) NOT NULL,
    PickupDate DATE NOT NULL,
    DeliveryDate DATE,
    Status VARCHAR(20) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
-- Insert data into Parcels table
INSERT INTO Parcels (CustomerID, Weight, Dimensions, PickupDate, DeliveryDate, Status) VALUES
(1, 2.5, '10x15x5', '2024-01-01', '2024-01-02', 'Delivered'),
(1, 1.0, '5x10x5', '2024-01-02', '2024-01-03', 'In Transit'),
(3, 3.5, '15x20x10', '2024-01-03', '2024-01-04', 'In Transit'),
(4, 2.0, '10x10x10', '2024-01-04', '2024-01-05', 'Delivered'),
(1, 1.5, '8x8x8', '2024-01-05', '2024-01-06', 'Delivered'),
(6, 2.2, '10x15x10', '2024-01-06', '2024-01-07', 'Pending'),
(2, 0.5, '5x5x5', '2024-01-07', '2024-01-08', 'In Transit'),
(8, 3.0, '20x20x20', '2024-01-08', '2024-01-09', 'Delivered'),
(1, 1.8, '12x12x12', '2024-01-09', '2024-01-10', 'Pending'),
(10, 2.1, '15x15x5', '2024-01-10', '2024-01-11', 'Delivered'),
(1, 2.5, '10x15x5', '2024-01-01', '2024-01-02', 'Delivered'),
(2, 1.0, '5x10x5', '2024-01-02', '2024-01-03', 'In Transit'),
(1, 3.5, '15x20x10', '2024-01-03', '2024-01-04', 'In Transit'),
(1, 2.0, '10x10x10', '2024-01-04', '2024-01-05', 'Delivered'),
(1, 1.5, '8x8x8', '2024-01-05', '2024-01-06', 'Delivered'),
(6, 2.2, '10x15x10', '2024-01-06', '2024-01-07', 'Pending'),
(7, 0.5, '5x5x5', '2024-01-07', '2024-01-08', 'In Transit'),
(8, 3.0, '20x20x20', '2024-01-08', '2024-01-09', 'Delivered'),
(9, 1.8, '12x12x12', '2024-01-09', '2024-01-10', 'Pending'),
(10, 2.1, '15x15x5', '2024-01-10', '2024-01-11', 'Delivered');

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL
);
-- Insert data into Employees table
INSERT INTO Employees (EmployeeID, FullName, Position, Phone, Email) VALUES
(1, 'David Adams', 'Driver', '555-1111', 'david.adams@example.com'),
(2, 'Sophie Roberts', 'Driver', '555-2222', 'sophie.roberts@example.com'),
(3, 'Chris Turner', 'Driver', '555-3333', 'chris.turner@example.com'),
(4, 'Lisa Johnson', 'Driver', '555-4444', 'lisa.johnson@example.com'),
(5, 'Mark Lee', 'Driver', '555-5555', 'mark.lee@example.com'),
(6, 'Amy Scott', 'Driver', '555-6666', 'amy.scott@example.com'),
(7, 'James Brown', 'Manager', '555-7777', 'james.brown@example.com'),
(8, 'Emma Wilson', 'Dispatcher', '555-8888', 'emma.wilson@example.com'),
(9, 'Ben Thomas', 'Driver', '555-9999', 'ben.thomas@example.com'),
(10, 'Eve Davis', 'Customer Support', '555-0000', 'eve.davis@example.com');

-- Create Deliveries table
CREATE TABLE Deliveries (
    DeliveryID INT PRIMARY KEY,
    ParcelID INT,
    EmployeeID INT,
    Vehicle VARCHAR(20) NOT NULL,
    RouteDetails VARCHAR(100) NOT NULL,
    DeliveryTime DATETIME NOT NULL,
    FOREIGN KEY (ParcelID) REFERENCES Parcels(ParcelID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
-- Insert data into Deliveries table
INSERT INTO Deliveries (DeliveryID, ParcelID, EmployeeID, Vehicle, RouteDetails, DeliveryTime) VALUES
(1, 1, 1, 'Van 1', 'Route 1', '2024-01-02 10:30'),
(2, 2, 2, 'Truck 1', 'Route 2', '2024-01-03 12:00'),
(3, 3, 3, 'Van 2', 'Route 3', '2024-01-04 14:00'),
(4, 4, 4, 'Truck 2', 'Route 4', '2024-01-05 09:30'),
(5, 5, 5, 'Bike 1', 'Route 5', '2024-01-06 11:15'),
(6, 6, 6, 'Van 3', 'Route 6', '2024-01-07 13:45'),
(7, 7, 7, 'Truck 3', 'Route 7', '2024-01-08 10:00'),
(8, 8, 8, 'Van 4', 'Route 8', '2024-01-09 15:30'),
(9, 9, 9, 'Truck 4', 'Route 9', '2024-01-10 12:45'),
(10, 10, 10, 'Van 5', 'Route 10', '2024-01-11 14:20'),
(11, 1, 10, 'Van 1', 'Route 10', '2024-01-11 14:20'),
(12, 1, 10, 'Van 1', 'Route 10', '2024-01-11 14:20'),
(13, 2, 10, 'Van 1', 'Route 10', '2024-01-11 14:20');

select * from Customers;
select * from Parcels;
select * from Employees;
select * from Deliveries;

SELECT COUNT(ParcelID ) AS DeliveryCount
FROM Parcels
WHERE CustomerID = 1;

SELECT 
    d.Vehicle,
    ROUND(AVG(p.Weight), 2) as AverageWeight
FROM 
    Deliveries d
    JOIN Parcels p ON d.ParcelID = p.ParcelID
WHERE Vehicle = 'Van 1';