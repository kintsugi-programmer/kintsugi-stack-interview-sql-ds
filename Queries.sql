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