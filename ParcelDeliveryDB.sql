DROP DATABASE IF EXISTS ParcelDeliveryDB;
CREATE DATABASE IF NOT EXISTS ParcelDeliveryDB;
USE ParcelDeliveryDB;

DROP TABLE IF EXISTS Customers;
#Create Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Address VARCHAR(255) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    ShippingCostPP INT NOT NULL
);
#Insert data into Customers table
INSERT INTO Customers (FullName, Address, Email, Phone, ShippingCostPP) VALUES
('John Doe', '123 Maple St', 'john.doe@example.com', '555-1234',14),
('Jane Smith', '456 Oak Ave', 'jane.smith@example.com', '555-5678',12),
('Bob Brown', '789 Pine Rd', 'bob.brown@example.com', '555-8765',11),
('Alice Green', '101 Elm St', 'alice.green@example.com', '555-4321',16),
('Tom White', '202 Cedar Ln', 'tom.white@example.com', '555-2345',8),
('Sara Black', '303 Birch Blvd', 'sara.black@example.com', '555-3456',9),
('Mike Gray', '404 Spruce Dr', 'mike.gray@example.com', '555-4567',12),
('Emma Blue', '505 Ash Ct', 'emma.blue@example.com', '555-5678',11),
('Lucas Red', '606 Willow Way', 'lucas.red@example.com', '555-6789',6),
('Olivia Purple', '707 Fir Cir', 'olivia.purple@example.com', '555-7890',7.5);

#Create Parcels table
DROP TABLE IF EXISTS Parcels;
CREATE TABLE Parcels (
    ParcelID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    Weight DECIMAL(5, 2) NOT NULL,
    Dimensions VARCHAR(20) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
#Insert data into Parcels table
INSERT INTO Parcels (CustomerID, Weight, Dimensions, Status) VALUES
(1, 2.5, '12x8x6','Delivered'),
(2, 1.8, '10x10x5', 'In Transit'),
(3, 3.0, '15x12x8', 'Failed'),
(2, 2.2, '10x15x10', 'Delivered'),
(5, 1.2, '6x6x6', 'Delivered'),
(6, 2.8, '18x12x10', 'Failed'),
(2, 0.7, '5x5x5', 'In Transit'),
(8, 3.5, '20x20x15', 'Delivered'),
(2, 2.0, '15x10x8', 'Failed'),
(4, 0.2, '5x5x5', 'In Transit'),
(4, 6.5, '20x20x15', 'Delivered'),
(4, 0.5, '10x10x15', 'Delivered'),
(4, 2.3, '10x10x8', 'Failed'),
(10, 1.5, '12x8x5', 'Delivered');

#Create Employees table
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Phone VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL
);
#Insert data into Employees table
INSERT INTO Employees (FullName, Position, Phone, Email) VALUES
('David Adams', 'Driver', '555-1111', 'david.adams@example.com'),
('Sophie Roberts', 'Driver', '555-2222', 'sophie.roberts@example.com'),
('Chris Turner', 'Driver', '555-3333', 'chris.turner@example.com'),
('Lisa Johnson', 'Driver', '555-4444', 'lisa.johnson@example.com'),
('Mark Lee', 'Driver', '555-5555', 'mark.lee@example.com'),
('Amy Scott', 'Driver', '555-6666', 'amy.scott@example.com'),
('James Brown', 'Manager', '555-7777', 'james.brown@example.com'),
('Emma Wilson', 'Dispatcher', '555-8888', 'emma.wilson@example.com'),
('Ben Thomas', 'Driver', '555-9999', 'ben.thomas@example.com'),
('Eve Davis', 'Customer Support', '555-0000', 'eve.davis@example.com');

#Create Deliveries table
DROP TABLE IF EXISTS Deliveries;
CREATE TABLE Deliveries (
    DeliveryID INT AUTO_INCREMENT PRIMARY KEY,
    ParcelID INT,
    EmployeeID INT,
    Vehicle VARCHAR(20) NOT NULL,
    RouteDetails VARCHAR(100) NOT NULL,
    DeliveryTime DATETIME NOT NULL,
    FOREIGN KEY (ParcelID) REFERENCES Parcels(ParcelID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);
#Insert data into Deliveries table
INSERT INTO Deliveries (ParcelID, EmployeeID, Vehicle, RouteDetails, DeliveryTime) VALUES
(1, 1, 'Truck 1', 'Route A', '2024-01-02 10:30'),
(2, 2, 'Van 1', 'Route B', '2024-01-03 11:45'),
(3, 3, 'Bike 1', 'Route C', '2024-01-04 09:00'),
(4, 4, 'Truck 2', 'Route D', '2024-01-05 14:15'),
(5, 5, 'Van 2', 'Route E', '2024-01-06 13:30'),
(6, 6, 'Van 3', 'Route F', '2024-01-07 15:45'),
(7, 7, 'Truck 3', 'Route G', '2024-01-08 16:00'),
(8, 8, 'Van 4', 'Route H', '2024-01-09 14:30'),
(9, 9, 'Bike 2', 'Route I', '2024-01-10 12:15'),
(10, 10, 'Truck 4', 'Route J', '2024-01-11 11:00');

select * from Customers;
select * from Parcels;
select * from Employees;
select * from Deliveries;

#Create view
DROP VIEW IF EXISTS parcels_view;
CREATE VIEW  parcels_view
		AS
		SELECT ParcelID, CustomerID, Weight, Dimensions, Status
		FROM Parcels
        WHERE CustomerID !=4
        WITH CHECK OPTION;
        
SELECT * FROM parcels_view;

#Stored Function
DROP FUNCTION IF EXISTS fnCalculateShippingCostTotal;

DELIMITER //
CREATE FUNCTION fnCalculateShippingCostTotal
(
    CustomerID INT
)
RETURNS DECIMAL(9,2)
BEGIN
    DECLARE shippingCostTotal DECIMAL(9,2);

    #Calculate the total shipping cost based on the number of parcels and the customer's per-parcel cost
    SELECT COUNT(p.ParcelID) * c.ShippingCostPP INTO shippingCostTotal
    FROM Parcels p
    JOIN Customers c ON p.CustomerID = c.CustomerID
    WHERE c.CustomerID = CustomerID;

    RETURN shippingCostTotal;
END//
DELIMITER ;



#SELECT fnCalculateShippingCostTotal(1) AS ShippingCostTotal;

#Parcels Audit Table
DROP TABLE IF EXISTS Parcels_audit;
CREATE TABLE IF NOT EXISTS Parcels_audit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    ParcelID INT,
    Action VARCHAR(10),
    ActionDate DATETIME
);

#Trigger
DELIMITER //
CREATE TRIGGER trParcelsAfterDelete
    AFTER DELETE ON Parcels
    FOR EACH ROW
BEGIN
    INSERT INTO Parcels_audit (ParcelID, Action, ActionDate)
    VALUES (OLD.ParcelID, 'DELETED', NOW());
END//
DELIMITER ;

#SELECT * FROM Parcels_audit;




