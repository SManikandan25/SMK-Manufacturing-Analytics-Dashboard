USE DATABASE SMK_MANUFACTURING_DB;



INSERT INTO FACT_PRODUCTION (
    PRODUCTION_ID,
    DATE_KEY,
    PLANT_ID,
    LINE_ID,
    MACHINE_ID,
    PRODUCT_ID,
    SHIFT_ID,
    PLANNED_QTY,
    PRODUCED_QTY,
    GOOD_QTY,
    REJECTED_QTY,
    PRODUCTION_HOURS,
    PRODUCTION_COST
)

WITH BASE_DATA AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY RANDOM()) AS PRODUCTION_ID,

        TO_NUMBER(
            TO_CHAR(
                DATEADD(
                    DAY,
                    UNIFORM(0, 729, RANDOM()),
                    '2025-01-01'::DATE
                ),
                'YYYYMMDD'
            )
        ) AS DATE_KEY,

        L.PLANT_ID,
        L.LINE_ID,
        M.MACHINE_ID,
        PR.PRODUCT_ID,
        S.SHIFT_ID,
        L.DAILY_CAPACITY,
        PR.UNIT_COST

    FROM DIM_LINE L

    JOIN DIM_MACHINE M
        ON L.LINE_ID = M.LINE_ID

    JOIN DIM_PLANT P
        ON L.PLANT_ID = P.PLANT_ID

    CROSS JOIN DIM_PRODUCT PR
    CROSS JOIN DIM_SHIFT S

    LIMIT 50000
),

CALCULATED AS (
    SELECT
        *,
        ROUND(
            DAILY_CAPACITY *
            (0.75 + UNIFORM(0, 20, RANDOM()) / 100.0)
        ) AS PLANNED_QTY
    FROM BASE_DATA
),

PRODUCTION AS (
    SELECT
        *,
        GREATEST(
            PLANNED_QTY - UNIFORM(0, 80, RANDOM()),
            1
        ) AS PRODUCED_QTY
    FROM CALCULATED
),

FINAL AS (
    SELECT
        *,
        LEAST(
            UNIFORM(5, 35, RANDOM()),
            PRODUCED_QTY - 1
        ) AS REJECTED_QTY
    FROM PRODUCTION
)

SELECT
    PRODUCTION_ID,
    DATE_KEY,
    PLANT_ID,
    LINE_ID,
    MACHINE_ID,
    PRODUCT_ID,
    SHIFT_ID,

    PLANNED_QTY,
    PRODUCED_QTY,

    PRODUCED_QTY - REJECTED_QTY AS GOOD_QTY,

    REJECTED_QTY,

    ROUND(
        6 + UNIFORM(0, 200, RANDOM()) / 100.0,
        2
    ) AS PRODUCTION_HOURS,

    ROUND(
        PRODUCED_QTY * UNIT_COST * 0.65,
        2
    ) AS PRODUCTION_COST

FROM FINAL;

TRUNCATE TABLE FACT_PRODUCTION;

INSERT INTO FACT_PRODUCTION_TARGET (
    TARGET_ID,
    DATE_KEY,
    PLANT_ID,
    LINE_ID,
    PRODUCT_ID,
    TARGET_QTY,
    TARGET_COST
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY D.DATE_KEY, L.LINE_ID, P.PRODUCT_ID
    ) AS TARGET_ID,

    D.DATE_KEY,
    L.PLANT_ID,
    L.LINE_ID,
    P.PRODUCT_ID,

    ROUND(
        L.DAILY_CAPACITY *
        (0.75 + UNIFORM(0, 20, RANDOM()) / 100.0)
    ) AS TARGET_QTY,

    ROUND(
        L.DAILY_CAPACITY *
        (0.75 + UNIFORM(0, 20, RANDOM()) / 100.0)
        * P.UNIT_COST
        * 0.65,
        2
    ) AS TARGET_COST

FROM DIM_DATE D

CROSS JOIN DIM_LINE L

CROSS JOIN DIM_PRODUCT P;

INSERT INTO FACT_QUALITY (
    QUALITY_ID,
    DATE_KEY,
    PLANT_ID,
    LINE_ID,
    MACHINE_ID,
    PRODUCT_ID,
    INSPECTION_COUNT,
    PASSED_COUNT,
    FAILED_COUNT,
    DEFECT_QTY,
    DEFECT_TYPE,
    DEFECT_COST
)

WITH BASE_DATA AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY F.PRODUCTION_ID
        ) AS QUALITY_ID,

        F.DATE_KEY,
        F.PLANT_ID,
        F.LINE_ID,
        F.MACHINE_ID,
        F.PRODUCT_ID,
        F.PRODUCED_QTY,
        P.UNIT_COST

    FROM FACT_PRODUCTION F

    JOIN DIM_PRODUCT P
        ON F.PRODUCT_ID = P.PRODUCT_ID
),

QUALITY_CALC AS (
    SELECT
        *,
        LEAST(
            UNIFORM(5, 35, RANDOM()),
            GREATEST(PRODUCED_QTY - 1, 1)
        ) AS DEFECT_QTY,

        UNIFORM(1, 5, RANDOM()) AS DEFECT_CODE

    FROM BASE_DATA
)

SELECT
    QUALITY_ID,
    DATE_KEY,
    PLANT_ID,
    LINE_ID,
    MACHINE_ID,
    PRODUCT_ID,

    PRODUCED_QTY AS INSPECTION_COUNT,

    PRODUCED_QTY - DEFECT_QTY AS PASSED_COUNT,

    DEFECT_QTY AS FAILED_COUNT,

    DEFECT_QTY,

    CASE DEFECT_CODE
        WHEN 1 THEN 'Surface Defect'
        WHEN 2 THEN 'Dimension Error'
        WHEN 3 THEN 'Crack'
        WHEN 4 THEN 'Assembly Error'
        ELSE 'Material Defect'
    END AS DEFECT_TYPE,

    ROUND(
        DEFECT_QTY * UNIT_COST * 0.80,
        2
    ) AS DEFECT_COST

FROM QUALITY_CALC;


INSERT INTO FACT_DOWNTIME (
    DOWNTIME_ID,
    DATE_KEY,
    PLANT_ID,
    LINE_ID,
    MACHINE_ID,
    DOWNTIME_START,
    DOWNTIME_END,
    DOWNTIME_MINUTES,
    DOWNTIME_REASON,
    DOWNTIME_CATEGORY
)

WITH BASE_DATA AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY F.PRODUCTION_ID
        ) AS DOWNTIME_ID,

        F.DATE_KEY,
        F.PLANT_ID,
        F.LINE_ID,
        F.MACHINE_ID,

        CASE
            WHEN UNIFORM(1, 6, RANDOM()) = 1 THEN 'CNC spindle failure'
            WHEN UNIFORM(1, 6, RANDOM()) = 2 THEN 'Power fluctuation'
            WHEN UNIFORM(1, 6, RANDOM()) = 3 THEN 'Raw material unavailable'
            WHEN UNIFORM(1, 6, RANDOM()) = 4 THEN 'Preventive maintenance'
            WHEN UNIFORM(1, 6, RANDOM()) = 5 THEN 'Operator unavailable'
            ELSE 'Tool replacement'
        END AS DOWNTIME_REASON,

        UNIFORM(30, 121, RANDOM()) AS DOWNTIME_MINUTES

    FROM FACT_PRODUCTION F

    LIMIT 10000
)

SELECT
    DOWNTIME_ID,
    DATE_KEY,
    PLANT_ID,
    LINE_ID,
    MACHINE_ID,

    '2025-01-01 08:00:00'::TIMESTAMP
        AS DOWNTIME_START,

    DATEADD(
        MINUTE,
        DOWNTIME_MINUTES,
        '2025-01-01 08:00:00'::TIMESTAMP
    ) AS DOWNTIME_END,

    DOWNTIME_MINUTES,

    DOWNTIME_REASON,

    CASE
        WHEN DOWNTIME_REASON = 'CNC spindle failure'
            THEN 'Mechanical'

        WHEN DOWNTIME_REASON = 'Power fluctuation'
            THEN 'Electrical'

        WHEN DOWNTIME_REASON = 'Raw material unavailable'
            THEN 'Material Shortage'

        WHEN DOWNTIME_REASON = 'Preventive maintenance'
            THEN 'Maintenance'

        WHEN DOWNTIME_REASON = 'Operator unavailable'
            THEN 'Operator Issue'

        ELSE 'Mechanical'
    END AS DOWNTIME_CATEGORY

FROM BASE_DATA;

INSERT INTO FACT_MAINTENANCE (
    MAINTENANCE_ID,
    DATE_KEY,
    PLANT_ID,
    MACHINE_ID,
    MAINTENANCE_TYPE,
    MAINTENANCE_START,
    MAINTENANCE_END,
    MAINTENANCE_HOURS,
    MAINTENANCE_COST,
    PARTS_COST,
    TECHNICIAN_ID
)

WITH BASE_DATA AS (
    SELECT
        ROW_NUMBER() OVER (
            ORDER BY F.PRODUCTION_ID
        ) AS MAINTENANCE_ID,

        F.DATE_KEY,
        F.PLANT_ID,
        F.MACHINE_ID,

        CASE
            WHEN UNIFORM(1, 3, RANDOM()) = 1
                THEN 'Preventive'
            WHEN UNIFORM(1, 3, RANDOM()) = 2
                THEN 'Corrective'
            ELSE 'Emergency'
        END AS MAINTENANCE_TYPE,

        ROUND(
            1 + UNIFORM(0, 300, RANDOM()) / 100.0,
            2
        ) AS MAINTENANCE_HOURS,

        ROUND(
            UNIFORM(3000, 10001, RANDOM()),
            2
        ) AS MAINTENANCE_COST,

        ROUND(
            UNIFORM(500, 6001, RANDOM()),
            2
        ) AS PARTS_COST,

        UNIFORM(5001, 5011, RANDOM()) AS TECHNICIAN_ID

    FROM FACT_PRODUCTION F

    LIMIT 5000
)

SELECT
    MAINTENANCE_ID,
    DATE_KEY,
    PLANT_ID,
    MACHINE_ID,
    MAINTENANCE_TYPE,

    '2025-01-01 08:00:00'::TIMESTAMP
        AS MAINTENANCE_START,

    DATEADD(
        MINUTE,
        MAINTENANCE_HOURS * 60,
        '2025-01-01 08:00:00'::TIMESTAMP
    ) AS MAINTENANCE_END,

    MAINTENANCE_HOURS,
    MAINTENANCE_COST,
    PARTS_COST,
    TECHNICIAN_ID

FROM BASE_DATA;