SHOW TABLES; -- 1

DESCRIBE sales; -- 2

SELECT * FROM sales; -- 3

SELECT 
  saledate, 
  amount, 
  customers 
  FROM sales; -- 4

SELECT 
  amount, 
  customers, 
  geoid 
  FROM sales; -- 5

SELECT 
  saledate,
  amount,
  boxes,
  amount / boxes
FROM sales; -- 6

SELECT 
  saledate,
  amount,
  boxes,
  amount / boxes AS 'amount_per_box'
FROM sales; -- 7

SELECT 
  saledate,
  amount,
  boxes,
  amount / boxes 'amount_per_box'
FROM sales; -- 8

SELECT * FROM sales
WHERE amount > 10000; -- 9

SELECT * FROM sales
WHERE amount > 10000
ORDER BY amount; -- 10

SELECT * FROM sales
WHERE amount > 10000
ORDER BY amount DESC; -- 11

SELECT * FROM sales
WHERE geoid = 'g1'
ORDER BY pid, amount DESC; -- 12

SELECT * FROM sales
WHERE amount > 10000
AND saledate >= '2022-01-01'; -- 13

SELECT saledate, amount 
FROM sales
WHERE amount > 10000
AND YEAR(saledate) = 2022
ORDER BY amount DESC; -- 14

SELECT * FROM sales
WHERE boxes > 0
AND boxes <= 50; -- 15

SELECT * FROM sales
WHERE boxes BETWEEN 0 AND 50; -- 16

SELECT 
  saledate,
  amount,
  boxes,
  WEEKDAY(saledate) AS day_of_week
FROM sales
WHERE WEEKDAY(saledate) = 4; -- 17

SELECT * FROM people
WHERE team = 'Delish'
OR team = 'Juices'; -- 18

SELECT * FROM people
WHERE team IN ('Delish', 'Juices'); -- 19

SELECT * FROM people
WHERE salesperson LIKE 'B%'; -- 20

SELECT * FROM people
WHERE salesperson LIKE '%B%'; -- 21

SELECT * FROM people
WHERE salesperson LIKE '%l'; -- 22

SELECT * FROM people
WHERE salesperson LIKE '_B%'; -- 23

select * from products
where Category != 'Bars'; -- 24
-- OR --
select * from products
where Category <> 'Bars'; -- 25
-- OR --
select * from products
where not (Category = 'Bars'); -- 26

select SaleDate,Amount ,case
  when Amount < 1000 then 'Under 1K'
  when Amount < 5000 then 'Under 2K'
  when Amount < 10000 then 'Under 10K' 
  else '10K or More' 
  end as amount_category from sales ; -- 27

SELECT 
  saledate,
  amount 
  ,CASE
    WHEN amount < 1000 THEN 'Under 1K'
    WHEN amount < 5000 THEN 'Under 5K'
    WHEN amount < 10000 THEN 'Under 10K'
    ELSE '10K or More'
  END AS amount_category
FROM sales; -- 28

SELECT * FROM sales; -- 29

select 
  s.SaleDate,
  s.Amount,
  p.Salesperson
from sales s
join people p on p.SPID = s.SPID; -- 30

select
  s.SaleDate,
  s.Amount,
  p.Salesperson,
  s.SPID,
  p.SPID
from sales s
  join people p on p.SPID = s.SPID
; -- 31

select 
  s.SaleDate,
  s.Amount,
  pr.Product
from sales s 
  left join products pr on pr.PID = s.PID
; -- 32

select 
  s.SaleDate,
  s.Amount,
  pr.Product
from sales s 
  right join products pr on pr.PID = s.PID
; -- 33

select
  s.SaleDate,
  s.Amount,
  p.Salesperson,
  p.Team
from sales s 
  join people p on p.SPID = s.SPID
  where s.Amount< 500
  and p.Team = 'Delish'
; -- 34

select
  s.SaleDate,
  s.Amount,
  p.Salesperson,
  p.Team
from sales s 
  join people p on p.SPID = s.SPID
  where s.Amount< 500
; -- 35

select
  s.SaleDate,
  s.Amount,
  p.Salesperson,
  p.Team
from sales s 
  join people p on p.SPID = s.SPID
  where s.Amount< 500
  and p.Team = ''
; -- 36

select
  sales.SaleDate,
  sales.Amount,
  people.Salesperson,
  products.Product,
  people.Team
from sales
join people on people.SPID = sales.SPID
join products on products.PID = sales.PID ; -- 37

select 
  s.SaleDate,
  s.Amount,
  p.Salesperson,
  p.Team
  from sales s
  left join people p
    on p.SPID = s.SPID
where s.Amount < 500
and p.team = ''
; -- 38

select 
  s.SaleDate,
  s.Amount,
  p.Salesperson,
  pr.Product,
  g.Geo
from sales s 
  join people p
  join products pr
  join geo g
where s.Amount < 500
  and p.Team = ''
  and g.Geo in ('New Zealand','India')
order by s.SaleDate
; -- 39

select 
  GeoID,
  sum(amount)
from sales
group by GeoID; -- 40

SELECT 
  GeoID,
  SUM(amount) AS total_amount,
  AVG(amount) AS average_amount,
  SUM(boxes) AS total_boxes
FROM sales
GROUP BY GeoID; -- 41

SELECT 
  g.Geo,
  SUM(s.Amount) AS total_amount,
  AVG(s.Amount) AS average_amount,
  SUM(s.Boxes) AS total_boxes
FROM sales s
  JOIN geo g ON g.GeoID = s.GeoID
GROUP BY g.geo; -- 42

select
  pr.Category,
  p.Team,
  sum(s.Boxes) as total_boxes,
  sum(s.Amount) as total_amount
from sales s
join people p on p.SPID = s.SPID
join products pr on pr.PID = s.PID
group by pr.Category, p.Team
order by pr.Category, p.Team; -- 43 


SELECT 
  pr.category,
  p.team,
  SUM(s.boxes) AS total_boxes,
  SUM(s.amount) AS total_amount
FROM sales s
JOIN people p ON p.SPID = s.SPID
JOIN products pr ON pr.pid = s.pid
WHERE p.team IS NOT NULL
GROUP BY pr.category, p.team
ORDER BY total_amount DESC; -- 44

SELECT 
  g.geo,
  SUM(s.amount) AS total_amount
FROM sales s
JOIN geo g ON g.GeoID = s.GeoID
GROUP BY g.geo
ORDER BY total_amount DESC; -- 45

SELECT 
  pr.product,
  SUM(s.amount) AS total_amount
FROM sales s
JOIN products pr ON pr.pid = s.pid
GROUP BY pr.product
ORDER BY total_amount DESC
LIMIT 10; -- 46

select * from sales s 
where s.`Amount` >2000 and s.`Boxes` <100; -- 47

select 
  p.`Salesperson`,
  count(*) as 'Shipment Count'
from sales s
join people p on s.`SPID`=p.`SPID`
  where s.`SaleDate` between '2022-01-01'and '2022-01-31'
  group by p.`Salesperson`
; -- 48

select 
  p.`Product`,
  sum(s.`Boxes`) as 'Total Boxes'
from sales s
join products p on s.`PID`=p.`PID`
  where p.`Product` in ('Milk Bars', 'Eclairs')
  group by p.`Product`
; -- 49

select 
  p.`Product`,
  sum(s.`Boxes`) as 'Total Boxes'
from sales s
join products p on s.`PID`=p.`PID`
  where p.`Product` in ('Milk Bars', 'Eclairs') and
  s.`SaleDate` between '2022-02-01' and '2022-02-07'
  group by p.`Product`
; -- 50

select *
from sales
where `Customers`<100 and `Boxes`<100; -- 51

select *,
  case 
    when weekday(s.`SaleDate`)=2 then 'Wednesday Shipment'
    else ''
  end as 'W Shipment'
from sales s
where s.`Customers`<100 and s.`Boxes`<100; -- 52

select
  distinct p.`Salesperson`
from sales s
join people p on s.`SPID`=p.`SPID`
where s.`SaleDate` between '2022-01-01' and '2022-1-07'; -- 53

select
  p.`Salesperson`
from people p
where p.`SPID` not in (select distinct s.`SPID` from sales s where s.`SaleDate` between '2022-01-01' and '2022-1-07')
  ; -- 54

select
  year(s.`SaleDate`) 'Year',
  month(s.`SaleDate`) 'Month',
  count(*) 'Times we shipped 1k boxes'
from sales s
where s.`Boxes`>1000
group by year(s.`SaleDate`), month(s.`SaleDate`)
order by year(s.`SaleDate`), month(s.`SaleDate`)
; -- 55

select 
  year(s.`SaleDate`) 'Year',
  month(s.`SaleDate`) 'Month',
  if(sum(s.`Boxes`)>1,'Yes','No') 'Status'
from sales s
join products pr on pr.`PID` = s.`PID`
join geo g on g.`GeoID` = s.`GeoID`
where pr.`Product` = 'After Nines' and g.`Geo` = 'New Zealand' 
group by year(s.`SaleDate`),month(s.`SaleDate`)
order by year(s.`SaleDate`),month(s.`SaleDate`)
; -- 56

SET @prod_name    = 'After Nines' COLLATE utf8mb4_0900_ai_ci; -- COLLATE utf8mb4_0900_ai_ci is fix related to some datatype issue
SET @country_name = 'New Zealand' COLLATE utf8mb4_0900_ai_ci;
select 
  year(s.`SaleDate`) 'Year',
  month(s.`SaleDate`) 'Month',
  if(sum(s.`Boxes`)>1,'Yes','No') 'Status'
from sales s
join products pr on pr.`PID` = s.`PID`
join geo g on g.`GeoID` = s.`GeoID`
where pr.`Product` = @prod_name and g.`Geo` = @country_name
group by year(s.`SaleDate`),month(s.`SaleDate`)
order by year(s.`SaleDate`),month(s.`SaleDate`)
; -- 57

select 
  year(s.`SaleDate`) 'Year',
  month(s.`SaleDate`) 'Month',
  sum(
    case when 
      g.`Geo`='India' = 1
      then boxes 
      else 0
    end
    ) 'India Boxes',
  sum(
      case when 
        g.`Geo`='Australia' = 1
        then boxes 
        else 0
      end
      ) 'Australia Boxes'
from sales s
join geo g on g.`GeoID` = s.`GeoID`
group by year(s.`SaleDate`), month(s.`SaleDate`)
order by year(s.`SaleDate`), month(s.`SaleDate`)
; -- 58