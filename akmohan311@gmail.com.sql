--SQL Advance Case Study


--Q1--BEGIN 
	select [State] from DIM_LOCATION l left join FACT_TRANSACTIONS ft on l.IDLocation=ft.IDLocation
	where Year([Date]) between 2005 and getdate()
	group by [State]

	

--Q1--END

--Q2--BEGIN
	select top 1 [state], sum (quantity)[Quantity] from FACT_TRANSACTIONS ft inner join  DIM_MODEL dml on ft.IDModel=dml.IDModel  inner join DIM_MANUFACTURER dm on dml.IDManufacturer= dm.IDManufacturer inner join DIM_LOCATION l on ft.IDLocation= l.IDLocation
	where country ='us' and Manufacturer_Name='samsung'
	group by [state]





--Q2--END

--Q3--BEGIN      
	select idmodel,zipcode,[state], COUNT(idcustomer)[No.of.transaction] from FACT_TRANSACTIONS ft inner join DIM_LOCATION l on ft.IDLocation=l.IDLocation
	group by IDModel,Zipcode,[state]






--Q3--END

--Q4--BEGIN
	select top 1 manufacturer_name,Model_Name, unit_price from DIM_MODEL dml inner join DIM_MANUFACTURER dm on dml.IDManufacturer=dm.IDManufacturer
	order by Unit_price





--Q4--END

--Q5--BEGIN

	
	select avg(totalprice)[Average Price],ft.IDModel from FACT_TRANSACTIONS ft inner join  DIM_MODEL dml on ft.IDModel=dml.IDModel  inner join DIM_MANUFACTURER dm on dml.IDManufacturer= dm.IDManufacturer 
	where manufacturer_name in (select  top 5 manufacturer_name from FACT_TRANSACTIONS ft inner join  DIM_MODEL dml on ft.IDModel=dml.IDModel  inner join DIM_MANUFACTURER dm on dml.IDManufacturer= dm.IDManufacturer 
	group by manufacturer_name
	order by sum(quantity) desc)
	group by ft.IDModel
	order by [Average Price] desc







--Q5--END

--Q6--BEGIN


select Customer_Name,[average price] from DIM_CUSTOMER dc inner join (select ft.idcustomer,avg (totalprice)[average price] from FACT_TRANSACTIONS ft inner join DIM_CUSTOMER dc on ft.IDCustomer=dc.IDCustomer
	where year(date)=2009
	group by ft.IDCustomer
	having avg (totalprice) >500) nt on dc.IDCustomer=nt.IDCustomer













--Q6--END
	
--Q7--BEGIN  
	
SELECT IdModel,
RANK() OVER (PARTITION BY YEAR(Date) ORDER BY SUM(Quantity) DESC)[rank] into #tempq7
FROM FACT_TRANSACTIONS
WHERE YEAR(Date) IN (2008, 2009, 2010)
GROUP BY YEAR(Date), IdModel
SELECT IdModel 
FROM  #tempq7
WHERE [rank] <= 5
GROUP BY IdModel
HAVING COUNT(*) = 3












--Q7--END	
--Q8--BEGIN
select * from
(SELECT  top 1 * 
 from (select top 2 Manufacturer_Name[2009-Manufacturer_Name], sum(totalprice)[total price] from FACT_TRANSACTIONS ft inner join  DIM_MODEL dml on ft.IDModel=dml.IDModel  inner join DIM_MANUFACTURER dm on dml.IDManufacturer= dm.IDManufacturer 
 where year([Date])=2009
 group by Manufacturer_Name
 order by [total price] desc) as a
 order by [total price])as c,

(SELECT  top 1 * from
 (select top 2 Manufacturer_Name[2010-Manufacturer_Name], sum(totalprice)[total price] from FACT_TRANSACTIONS ft inner join  DIM_MODEL dml on ft.IDModel=dml.IDModel  inner join DIM_MANUFACTURER dm on dml.IDManufacturer= dm.IDManufacturer 
 where year([Date])=2010
 group by Manufacturer_Name
 order by [total price] desc) as b
 order by [total price])as d









--Q8--END
--Q9--BEGIN
	
select Manufacturer_Name from FACT_TRANSACTIONS ft inner join  DIM_MODEL dml on ft.IDModel=dml.IDModel  inner join DIM_MANUFACTURER dm on dml.IDManufacturer= dm.IDManufacturer 
where year([Date])=2010
group by Manufacturer_Name
except
select Manufacturer_Name from FACT_TRANSACTIONS ft inner join  DIM_MODEL dml on ft.IDModel=dml.IDModel  inner join DIM_MANUFACTURER dm on dml.IDManufacturer= dm.IDManufacturer 
where year([Date])=2009
group by Manufacturer_Name















--Q9--END

--Q10--BEGIN

--top 100 customer based on their average spend

select *, 100 *( b.[Average spend] / a.[Average spend] - 1.0) as [Percent Change] from
(select top 100 Customer_Name,avg(totalprice)[Average spend],avg(quantity)[Average buy],YEAR(Date)  [YEAR] from FACT_TRANSACTIONS ft inner join DIM_CUSTOMER dc on ft.IDCustomer=dc.IDCustomer
group by Customer_Name,YEAR(Date)
order by [Average spend]desc)as a
left join 
(select top 100 Customer_Name,avg(totalprice)[Average spend],avg(quantity)[Average buy],YEAR(Date)  [YEAR] from FACT_TRANSACTIONS ft inner join DIM_CUSTOMER dc on ft.IDCustomer=dc.IDCustomer
group by Customer_Name,YEAR(Date)
order by [Average spend]desc)as b on a.Customer_Name=b.Customer_Name and  a.[YEAR]+1 =b.[YEAR] 






--Q10--END
