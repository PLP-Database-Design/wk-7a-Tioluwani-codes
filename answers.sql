-- Question One:
-- Creating a new table to store the normalized data
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Inserting normalized data into the new table
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 
    OrderID,
    CustomerName,
    TRIM(value)
FROM 
    ProductDetail,
    LATERAL SPLIT_TO_TABLE(ProductDetail.Products, ',');

-- Question Two:

-- Creating a new table for customers

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);


-- Creating a new table for orders

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    PRIMARY KEY (OrderID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);


-- Creating a new table for order details

CREATE TABLE OrderDetails (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert data into the new tables

-- Inserting customers
INSERT INTO Customers (CustomerID, CustomerName)
SELECT DISTINCT 
    OrderID, 
    CustomerName 
FROM 
    OriginalOrderDetails;

-- Inserting orders (assuming CustomerID is same as OrderID for simplicity, but ideally it should be different)
INSERT INTO Orders (OrderID, CustomerID)
SELECT DISTINCT 
    OrderID, 
    OrderID 
FROM 
    OriginalOrderDetails;

-- Inserting order details
INSERT INTO OrderDetails (OrderID, Product, Quantity)
SELECT 
    OrderID, 
    Product, 
    Quantity 
FROM 
    OriginalOrderDetails;
