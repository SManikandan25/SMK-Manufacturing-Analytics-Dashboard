USE DATABASE SMK_MANUFACTURING_DB;

CREATE TABLE DIM_PLANT (
    PLANT_ID INTEGER PRIMARY KEY,
    PLANT_NAME VARCHAR(100),
    CITY VARCHAR(100),
    STATE VARCHAR(100),
    REGION VARCHAR(50),
    PLANT_MANAGER VARCHAR(100),
    PLANT_STATUS VARCHAR(30)
);


INSERT INTO DIM_PLANT (
    PLANT_ID,
    PLANT_NAME,
    CITY,
    STATE,
    REGION,
    PLANT_MANAGER,
    PLANT_STATUS
)
VALUES
(101, 'Chennai Plant', 'Chennai', 'Tamil Nadu', 'South', 'Arun Kumar', 'Active'),
(102, 'Bangalore Plant', 'Bangalore', 'Karnataka', 'South', 'Rahul Sharma', 'Active'),
(103, 'Pune Plant', 'Pune', 'Maharashtra', 'West', 'Vikram Patel', 'Active'),
(104, 'Ahmedabad Plant', 'Ahmedabad', 'Gujarat', 'West', 'Amit Shah', 'Active'),
(105, 'Noida Plant', 'Noida', 'Uttar Pradesh', 'North', 'Rohit Verma', 'Active'),
(106, 'Jaipur Plant', 'Jaipur', 'Rajasthan', 'North', 'Manish Singh', 'Active');




CREATE TABLE DIM_DATE (
    DATE_KEY INTEGER PRIMARY KEY,
    FULL_DATE DATE,
    DAY INTEGER,
    DAY_NAME VARCHAR(20),
    MONTH INTEGER,
    MONTH_NAME VARCHAR(20),
    QUARTER VARCHAR(10),
    YEAR INTEGER,
    YEAR_MONTH VARCHAR(10),
    WEEK_NUMBER INTEGER,
    IS_WEEKEND BOOLEAN
);


INSERT INTO DIM_DATE
SELECT
    TO_NUMBER(TO_CHAR(DATE_VALUE, 'YYYYMMDD')) AS DATE_KEY,
    DATE_VALUE AS FULL_DATE,
    DAY(DATE_VALUE) AS DAY,
    DAYNAME(DATE_VALUE) AS DAY_NAME,
    MONTH(DATE_VALUE) AS MONTH,
    MONTHNAME(DATE_VALUE) AS MONTH_NAME,
    'Q' || QUARTER(DATE_VALUE) AS QUARTER,
    YEAR(DATE_VALUE) AS YEAR,
    TO_CHAR(DATE_VALUE, 'YYYY-MM') AS YEAR_MONTH,
    WEEKOFYEAR(DATE_VALUE) AS WEEK_NUMBER,
    CASE
    WHEN DAYNAME(DATE_VALUE) IN ('Sat','Sun')
    THEN TRUE
    ELSE FALSE
END AS IS_WEEKEND
FROM (
    SELECT DATEADD(
        DAY,
        SEQ4(),
        '2025-01-01'::DATE
    ) AS DATE_VALUE
    FROM TABLE(GENERATOR(ROWCOUNT => 730))
);




CREATE TABLE DIM_PRODUCT (
    PRODUCT_ID INTEGER PRIMARY KEY,
    PRODUCT_CODE VARCHAR(30),
    PRODUCT_NAME VARCHAR(100),
    PRODUCT_CATEGORY VARCHAR(50),
    PRODUCT_FAMILY VARCHAR(50),
    UNIT_COST DECIMAL(12,2),
    STANDARD_PRICE DECIMAL(12,2),
    PRODUCT_STATUS VARCHAR(30)
);

INSERT INTO DIM_PRODUCT (
    PRODUCT_ID,
    PRODUCT_CODE,
    PRODUCT_NAME,
    PRODUCT_CATEGORY,
    PRODUCT_FAMILY,
    UNIT_COST,
    STANDARD_PRICE,
    PRODUCT_STATUS
)
VALUES
(1001, 'BRK-001', 'Brake Disc', 'Brake Components', 'Braking System', 850.00, 1250.00, 'Active'),
(1002, 'BRK-002', 'Brake Pad', 'Brake Components', 'Braking System', 420.00, 650.00, 'Active'),
(1003, 'BRK-003', 'Brake Caliper', 'Brake Components', 'Braking System', 1450.00, 2100.00, 'Active'),
(1004, 'ENG-001', 'Engine Mount', 'Engine Components', 'Engine System', 1100.00, 1650.00, 'Active'),
(1005, 'ENG-002', 'Cylinder Head', 'Engine Components', 'Engine System', 5200.00, 7500.00, 'Active'),
(1006, 'ENG-003', 'Oil Pump', 'Engine Components', 'Engine System', 1350.00, 1950.00, 'Active'),
(1007, 'TRN-001', 'Clutch Plate', 'Transmission Components', 'Transmission System', 950.00, 1450.00, 'Active'),
(1008, 'TRN-002', 'Gear Shaft', 'Transmission Components', 'Transmission System', 1800.00, 2700.00, 'Active'),
(1009, 'TRN-003', 'Synchronizer Ring', 'Transmission Components', 'Transmission System', 620.00, 950.00, 'Active'),
(1010, 'STR-001', 'Steering Knuckle', 'Steering Components', 'Steering System', 2200.00, 3300.00, 'Active'),
(1011, 'STR-002', 'Tie Rod End', 'Steering Components', 'Steering System', 480.00, 750.00, 'Active'),
(1012, 'STR-003', 'Steering Rack', 'Steering Components', 'Steering System', 2800.00, 4200.00, 'Active'),
(1013, 'SUS-001', 'Control Arm', 'Suspension Components', 'Suspension System', 1250.00, 1900.00, 'Active'),
(1014, 'SUS-002', 'Coil Spring', 'Suspension Components', 'Suspension System', 650.00, 1000.00, 'Active'),
(1015, 'SUS-003', 'Shock Absorber', 'Suspension Components', 'Suspension System', 1450.00, 2200.00, 'Active'),
(1016, 'BRK-004', 'Brake Drum', 'Brake Components', 'Braking System', 720.00, 1100.00, 'Active'),
(1017, 'ENG-004', 'Water Pump', 'Engine Components', 'Engine System', 780.00, 1200.00, 'Active'),
(1018, 'TRN-004', 'Flywheel', 'Transmission Components', 'Transmission System', 1600.00, 2400.00, 'Active'),
(1019, 'STR-004', 'Steering Column', 'Steering Components', 'Steering System', 1900.00, 2900.00, 'Active'),
(1020, 'SUS-004', 'Stabilizer Link', 'Suspension Components', 'Suspension System', 380.00, 600.00, 'Active');

CREATE TABLE DIM_LINE (
    LINE_ID INTEGER PRIMARY KEY,
    LINE_NAME VARCHAR(100),
    PLANT_ID INTEGER,
    LINE_TYPE VARCHAR(50),
    DAILY_CAPACITY INTEGER,
    LINE_STATUS VARCHAR(30)
);

INSERT INTO DIM_LINE (
    LINE_ID,
    LINE_NAME,
    PLANT_ID,
    LINE_TYPE,
    DAILY_CAPACITY,
    LINE_STATUS
)
VALUES
-- Chennai
(1001, 'Chennai Line 01', 101, 'Brake Components', 1200, 'Active'),
(1002, 'Chennai Line 02', 101, 'Engine Components', 900, 'Active'),
(1003, 'Chennai Line 03', 101, 'Suspension Components', 1100, 'Active'),

-- Bangalore
(1004, 'Bangalore Line 01', 102, 'Brake Components', 1300, 'Active'),
(1005, 'Bangalore Line 02', 102, 'Transmission Components', 950, 'Active'),
(1006, 'Bangalore Line 03', 102, 'Steering Components', 1000, 'Active'),

-- Pune
(1007, 'Pune Line 01', 103, 'Engine Components', 850, 'Active'),
(1008, 'Pune Line 02', 103, 'Transmission Components', 1000, 'Active'),
(1009, 'Pune Line 03', 103, 'Brake Components', 1250, 'Active'),

-- Ahmedabad
(1010, 'Ahmedabad Line 01', 104, 'Steering Components', 1050, 'Active'),
(1011, 'Ahmedabad Line 02', 104, 'Suspension Components', 1150, 'Active'),
(1012, 'Ahmedabad Line 03', 104, 'Engine Components', 900, 'Active'),

-- Noida
(1013, 'Noida Line 01', 105, 'Transmission Components', 950, 'Active'),
(1014, 'Noida Line 02', 105, 'Brake Components', 1200, 'Active'),
(1015, 'Noida Line 03', 105, 'Steering Components', 1000, 'Active'),

-- Jaipur
(1016, 'Jaipur Line 01', 106, 'Suspension Components', 1100, 'Active'),
(1017, 'Jaipur Line 02', 106, 'Engine Components', 850, 'Active'),
(1018, 'Jaipur Line 03', 106, 'Transmission Components', 900, 'Active');

CREATE TABLE DIM_MACHINE (
    MACHINE_ID INTEGER PRIMARY KEY,
    MACHINE_NAME VARCHAR(100),
    LINE_ID INTEGER,
    PLANT_ID INTEGER,
    MACHINE_TYPE VARCHAR(50),
    INSTALLATION_DATE DATE,
    MACHINE_STATUS VARCHAR(30)
);

INSERT INTO DIM_MACHINE (
    MACHINE_ID,
    MACHINE_NAME,
    LINE_ID,
    PLANT_ID,
    MACHINE_TYPE,
    INSTALLATION_DATE,
    MACHINE_STATUS
)
VALUES
-- Chennai Line 01
(2001, 'CHN-L01-M01', 1001, 101, 'CNC Machine', '2022-03-15', 'Active'),
(2002, 'CHN-L01-M02', 1001, 101, 'Press Machine', '2022-04-10', 'Active'),
(2003, 'CHN-L01-M03', 1001, 101, 'Grinding Machine', '2022-05-20', 'Active'),

-- Chennai Line 02
(2004, 'CHN-L02-M01', 1002, 101, 'CNC Machine', '2022-06-12', 'Active'),
(2005, 'CHN-L02-M02', 1002, 101, 'Lathe Machine', '2022-07-18', 'Active'),
(2006, 'CHN-L02-M03', 1002, 101, 'Assembly Machine', '2022-08-05', 'Active'),

-- Chennai Line 03
(2007, 'CHN-L03-M01', 1003, 101, 'Press Machine', '2023-01-15', 'Active'),
(2008, 'CHN-L03-M02', 1003, 101, 'Grinding Machine', '2023-02-20', 'Active'),
(2009, 'CHN-L03-M03', 1003, 101, 'Assembly Machine', '2023-03-10', 'Active'),

-- Bangalore Line 01
(2010, 'BLR-L01-M01', 1004, 102, 'CNC Machine', '2022-02-10', 'Active'),
(2011, 'BLR-L01-M02', 1004, 102, 'Press Machine', '2022-03-25', 'Active'),
(2012, 'BLR-L01-M03', 1004, 102, 'Grinding Machine', '2022-04-15', 'Active'),

-- Bangalore Line 02
(2013, 'BLR-L02-M01', 1005, 102, 'Lathe Machine', '2022-05-12', 'Active'),
(2014, 'BLR-L02-M02', 1005, 102, 'CNC Machine', '2022-06-18', 'Active'),
(2015, 'BLR-L02-M03', 1005, 102, 'Assembly Machine', '2022-07-22', 'Active'),

-- Bangalore Line 03
(2016, 'BLR-L03-M01', 1006, 102, 'Press Machine', '2023-01-10', 'Active'),
(2017, 'BLR-L03-M02', 1006, 102, 'Grinding Machine', '2023-02-15', 'Active'),
(2018, 'BLR-L03-M03', 1006, 102, 'CNC Machine', '2023-03-20', 'Active'),

-- Pune Line 01
(2019, 'PUN-L01-M01', 1007, 103, 'CNC Machine', '2022-01-20', 'Active'),
(2020, 'PUN-L01-M02', 1007, 103, 'Press Machine', '2022-02-25', 'Active'),
(2021, 'PUN-L01-M03', 1007, 103, 'Lathe Machine', '2022-03-30', 'Active'),

-- Pune Line 02
(2022, 'PUN-L02-M01', 1008, 103, 'Grinding Machine', '2022-04-15', 'Active'),
(2023, 'PUN-L02-M02', 1008, 103, 'CNC Machine', '2022-05-20', 'Active'),
(2024, 'PUN-L02-M03', 1008, 103, 'Assembly Machine', '2022-06-25', 'Active'),

-- Pune Line 03
(2025, 'PUN-L03-M01', 1009, 103, 'Press Machine', '2023-01-12', 'Active'),
(2026, 'PUN-L03-M02', 1009, 103, 'CNC Machine', '2023-02-18', 'Active'),
(2027, 'PUN-L03-M03', 1009, 103, 'Grinding Machine', '2023-03-25', 'Active'),

-- Ahmedabad Line 01
(2028, 'AMD-L01-M01', 1010, 104, 'CNC Machine', '2022-04-10', 'Active'),
(2029, 'AMD-L01-M02', 1010, 104, 'Lathe Machine', '2022-05-15', 'Active'),
(2030, 'AMD-L01-M03', 1010, 104, 'Press Machine', '2022-06-20', 'Active'),

-- Ahmedabad Line 02
(2031, 'AMD-L02-M01', 1011, 104, 'Grinding Machine', '2022-07-12', 'Active'),
(2032, 'AMD-L02-M02', 1011, 104, 'CNC Machine', '2022-08-18', 'Active'),
(2033, 'AMD-L02-M03', 1011, 104, 'Assembly Machine', '2022-09-22', 'Active'),

-- Ahmedabad Line 03
(2034, 'AMD-L03-M01', 1012, 104, 'Press Machine', '2023-01-15', 'Active'),
(2035, 'AMD-L03-M02', 1012, 104, 'Lathe Machine', '2023-02-20', 'Active'),
(2036, 'AMD-L03-M03', 1012, 104, 'CNC Machine', '2023-03-25', 'Active'),

-- Noida Line 01
(2037, 'NOI-L01-M01', 1013, 105, 'CNC Machine', '2022-03-10', 'Active'),
(2038, 'NOI-L01-M02', 1013, 105, 'Press Machine', '2022-04-15', 'Active'),
(2039, 'NOI-L01-M03', 1013, 105, 'Grinding Machine', '2022-05-20', 'Active'),

-- Noida Line 02
(2040, 'NOI-L02-M01', 1014, 105, 'Lathe Machine', '2022-06-12', 'Active'),
(2041, 'NOI-L02-M02', 1014, 105, 'CNC Machine', '2022-07-18', 'Active'),
(2042, 'NOI-L02-M03', 1014, 105, 'Assembly Machine', '2022-08-22', 'Active'),

-- Noida Line 03
(2043, 'NOI-L03-M01', 1015, 105, 'Press Machine', '2023-01-10', 'Active'),
(2044, 'NOI-L03-M02', 1015, 105, 'Grinding Machine', '2023-02-15', 'Active'),
(2045, 'NOI-L03-M03', 1015, 105, 'CNC Machine', '2023-03-20', 'Active'),

-- Jaipur Line 01
(2046, 'JAI-L01-M01', 1016, 106, 'CNC Machine', '2022-05-10', 'Active'),
(2047, 'JAI-L01-M02', 1016, 106, 'Press Machine', '2022-06-15', 'Active'),
(2048, 'JAI-L01-M03', 1016, 106, 'Lathe Machine', '2022-07-20', 'Active'),

-- Jaipur Line 02
(2049, 'JAI-L02-M01', 1017, 106, 'Grinding Machine', '2022-08-12', 'Active'),
(2050, 'JAI-L02-M02', 1017, 106, 'CNC Machine', '2022-09-18', 'Active'),
(2051, 'JAI-L02-M03', 1017, 106, 'Assembly Machine', '2022-10-22', 'Active'),

-- Jaipur Line 03
(2052, 'JAI-L03-M01', 1018, 106, 'Press Machine', '2023-01-15', 'Active'),
(2053, 'JAI-L03-M02', 1018, 106, 'Lathe Machine', '2023-02-20', 'Active'),
(2054, 'JAI-L03-M03', 1018, 106, 'CNC Machine', '2023-03-25', 'Active');


CREATE TABLE DIM_SHIFT (
    SHIFT_ID INTEGER PRIMARY KEY,
    SHIFT_NAME VARCHAR(30),
    START_TIME TIME,
    END_TIME TIME
);

INSERT INTO DIM_SHIFT (
    SHIFT_ID,
    SHIFT_NAME,
    START_TIME,
    END_TIME
)
VALUES
(1, 'Morning', '06:00:00', '14:00:00'),
(2, 'Evening', '14:00:00', '22:00:00'),
(3, 'Night', '22:00:00', '06:00:00');

CREATE TABLE DIM_USER_ACCESS (
    USER_EMAIL VARCHAR(150) PRIMARY KEY,
    USER_NAME VARCHAR(100),
    ROLE_NAME VARCHAR(50),
    REGION VARCHAR(50),
    PLANT_ID INTEGER,
    LINE_ID INTEGER,
    IS_ACTIVE BOOLEAN
);

INSERT INTO DIM_USER_ACCESS (
    USER_EMAIL,
    USER_NAME,
    ROLE_NAME,
    REGION,
    PLANT_ID,
    LINE_ID,
    IS_ACTIVE
)
VALUES

-- CEO
('ceo@smk.com', 'SMK CEO', 'CEO', 'ALL', NULL, NULL, TRUE),

-- Regional Managers
('south.manager@smk.com', 'South Regional Manager', 'Regional Manager', 'South', NULL, NULL, TRUE),
('west.manager@smk.com', 'West Regional Manager', 'Regional Manager', 'West', NULL, NULL, TRUE),
('north.manager@smk.com', 'North Regional Manager', 'Regional Manager', 'North', NULL, NULL, TRUE),

-- Plant Managers
('chennai.manager@smk.com', 'Chennai Plant Manager', 'Plant Manager', 'South', 101, NULL, TRUE),
('bangalore.manager@smk.com', 'Bangalore Plant Manager', 'Plant Manager', 'South', 102, NULL, TRUE),
('pune.manager@smk.com', 'Pune Plant Manager', 'Plant Manager', 'West', 103, NULL, TRUE),
('ahmedabad.manager@smk.com', 'Ahmedabad Plant Manager', 'Plant Manager', 'West', 104, NULL, TRUE),
('noida.manager@smk.com', 'Noida Plant Manager', 'Plant Manager', 'North', 105, NULL, TRUE),
('jaipur.manager@smk.com', 'Jaipur Plant Manager', 'Plant Manager', 'North', 106, NULL, TRUE),

-- Production Managers
('chennai.line01@smk.com', 'Chennai Line 01 Manager', 'Production Manager', 'South', 101, 1001, TRUE),
('chennai.line02@smk.com', 'Chennai Line 02 Manager', 'Production Manager', 'South', 101, 1002, TRUE),
('bangalore.line01@smk.com', 'Bangalore Line 01 Manager', 'Production Manager', 'South', 102, 1004, TRUE),
('pune.line01@smk.com', 'Pune Line 01 Manager', 'Production Manager', 'West', 103, 1007, TRUE),
('ahmedabad.line01@smk.com', 'Ahmedabad Line 01 Manager', 'Production Manager', 'West', 104, 1010, TRUE),
('noida.line01@smk.com', 'Noida Line 01 Manager', 'Production Manager', 'North', 105, 1013, TRUE),
('jaipur.line01@smk.com', 'Jaipur Line 01 Manager', 'Production Manager', 'North', 106, 1016, TRUE);

