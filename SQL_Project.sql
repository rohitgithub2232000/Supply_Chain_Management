use mahendra;
select * from `=calendar`;
select * from f_sales;
select * from f_inventory_adjusted;
select* from customer;
select * from d_store;
select * from `pointsales`;
select * from d_geojson_us_counties;

alter table f_sales
change `Date` order_date date;


-- 1) Total Sales
select sum(`sales amount`) AS total_sales from `pointsales`;


-- 2) top product types wise sales
SELECT f.`product type`, SUM(p.`sales amount`) AS total_sales
FROM f_inventory_adjusted f
JOIN pointsales p ON f.`product key` = p.`product key`
GROUP BY f.`product type`;

-- 3) daily sales 
SELECT c.`date`, SUM(p.`sales amount`) AS total_daily_sales
FROM `=calendar` c
JOIN f_sales f ON c.`date` = f.`order_date`
JOIN pointsales p ON f.`order number` = p.`ï»¿Order Number`
GROUP BY c.`date`
ORDER BY c.`date`;


-- 4) Region wise sales
SELECT c.`Cust Region`, SUM(p.`sales amount`) AS total_sales
FROM pointsales p
JOIN f_sales f ON p.`ï»¿Order Number` = f.`Order Number`
JOIN customer c ON f.`Cust Key` = c.`Cust Key`
GROUP BY c.`Cust Region`;


-- 5) State wise Sales
SELECT c.`Cust State`, SUM(p.`sales amount`) AS total_sales
FROM pointsales p
JOIN f_sales f ON p.`ï»¿Order Number` = f.`Order Number`
JOIN customer c ON f.`Cust Key` = c.`Cust Key`
GROUP BY c.`Cust State`;


-- 6) Top 5 Store wise sales
SELECT d.`Store Name`, SUM(p.`sales amount`) AS total_sales
from pointsales p
JOIN f_sales f ON p.`ï»¿Order Number` = f.`Order Number`
JOIN d_store d ON f.`store key` = d.`store key`
GROUP BY d.`store Name`
ORDER BY total_sales desc
limit 5;

-- 7) Inventory Stock
SELECT COUNT(`quantity on hand`) as Total_Stock from f_inventory_adjusted;


-- 8) Inventory cost amount
SELECT SUM(`cost amount`) as `Inventory value` from f_inventory_adjusted;


-- 9) in-stock, out-of-stock, under-stock
SELECT `Product Name`, `quantity on hand`,
    CASE 
        WHEN `quantity on hand` > 1 THEN 'In-Stock'
        WHEN `quantity on hand` = 1 THEN 'under-stock'
        ELSE 'out-o-stock'
    END AS stock_status
FROM f_inventory_adjusted;


-- 10) Purchase method wise sales
SELECT f.`purchase method`, SUM(p.`sales amount`) AS total_sales
FROM f_sales f
JOIN pointsales p ON f.`order number` = p.`ï»¿Order Number`
GROUP BY f.`purchase method`;


 