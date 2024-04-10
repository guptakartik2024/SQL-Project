

-- SQl project by kartik Gupta


-- DAY 3---------------------------------------------------------------------------


select customerNumber,customerName,state,creditLimit
from customers
where state is not null and creditLimit between 50000 and 100000
order by creditLimit desc;
 
 -- 2
 
select distinct productLine
FROM products
WHERE productLine LIKE "%CARS";


-- DAY4---------------------------------------------------------------------------

-- 1

select orderNumber,status,ifnull(comments,"-") as comments   
FROM orders
WHERE status="Shipped";

-- 2

select employeeNumber,firstName,jobTitle,
case
when jobTitle="president" then "p"
when jobTitle like"%manager%" then "SM"
when jobTitle="Sales Rep" then "SR"
when jobTitle like "VP%" then "VP"
end as "job title abbrevation"
from employees;


-- DAY 5----------------------------------------------------------------------


-- 1
use classicmodels;
select min(amount) AS "Min Amount",year(paymentdate) as year 
from payments
group by year
order by year;

-- 2

select count(distinct customerNumber) as unique_customers, concat("q",quarter(orderDate)) as quarter, year(orderDate) as year, count(distinct ordernumber) as total_orders
from orders inner join orderdetails
using(orderNumber)
group by year, quarter;

-- 3


select left(monthname(paymentDate),3) as month , concat(format(sum(amount)/1000,0),"k") as total
FROM payments
group by month
having sum(amount) between 500000 and 10000000
order by total desc;



-- Day 6------------------------------------------------------------------------


-- 1
use classicmodels;
create table journey
(bus_id int not null,
bus_name varchar(30) not null,
source_station varchar(20) not null,
destination varchar(20) not null,
email varchar(30) unique);

insert into journey
values
(1,"volvo","kota","jaiupur","kk@gmail.com"),
(2,"volvo","kota","delhi","gg@gmail.com");

-- 2

use classicmodels;
create table vendor
(vendorid int primary key,
name varchar(20) not null,
email varchar(30) unique,
country varchar(20) default "N/A");

insert into vendor
values 
(1,"kk","kk@gmail.com","india");

insert into vendor
values 
(2,"gk","gg@gmail.com","india");

insert into vendor
values
(5,"pk","pkk@gmail.com","paik");

-- 3

use classicmodels;
create table movies
(movieid int primary key,
name varchar(20) not null,
release_year varchar(20) default "_" ,
cast varchar(30) not null,
gender varchar(10) check(gender= "male" or gender = "female"),
no_of_shows int check(no_of_shows >0));


insert into movies
values
(1, 'pulp', 19 , 'sil', 'male', 3),
(2, 'fict', 19 , 'jk', 'female', 10);

-- 4 

create table supplier
(supplier_id int auto_increment primary key,
supplier_name varchar(20),
location varchar(30));


insert into supplier
values
(1,"kk", "kota"),
(2, "gg","udaipur"),
(3,"mm", "delhi");


create table stock
(id int auto_increment primary key,
product_id int,
foreign key(product_id) references product_ass(product_id),
balance_stock varchar(20));

insert into stock
values(1,3,101),
(2,2,102),
(3,1,103);


create table product_ass
(product_id int auto_increment key,
product_name varchar(20) not null unique,
description varchar(100),
Supplier_id int,
foreign key(supplier_id) references supplier(supplier_id));

insert into product_ass
values 
(1,"tv","good",1),
(2,"ac","good",2),
(3,"car","great","3");


-- DAY 7-----------------------------------------------------------------------------


-- 1
select distinct employeeNumber,concat(firstname," ",lastname) as sales_person, count(customernumber) as unique_customer
from employees inner join customers
on employees.employeeNumber= customers.salesRepEmployeeNumber
group by employeenumber
order by unique_customer desc;

-- 2
select customernumber,customername,productcode,productname,quantityordered,quantityinstock as total_inventory, quantityinstock-quantityordered as leftquantity
from customers left join orders
using(customerNumber) inner join orderdetails
using(orderNumber) right join products
using(productcode)
where customernumber is not null
order by customernumber,productcode;

-- 3

create table laptop
(laptop_name varchar(20));

insert into laptop
values ("dell"),("hp"),("apple");

create table colours
(colour_name varchar(20));

insert into colours
values ("red"),
("white"),
("black"),
("silver");

select *
from laptop cross join colours;

-- 4

use classicmodels;
create table project
(employeeid int ,
fullname varchar(20),
gender varchar(20),
managerid int );       

insert into project 
values (1, 'Pranaya', 'Male', 3),
(2, 'Priyanka', 'Female', 1),
(3, 'Preety', 'Female', NULL),
(4, 'Anurag', 'Male', 1),
(5, 'Sambit', 'Male', 1),
(6, 'Rajesh', 'Male', 3),
(7, 'Hina', 'Female', 3);

select p1.fullname as employeename , p2.fullname as managername
from project as p1 join project as p2
on p1.managerid= p2.employeeid;                                                                                                                                                   table 


-- DAY 8---------------------------------------------------------------------------------------------------------------------------------------


use classicmodels;
create table facility
(facility_id int primary key auto_increment,
name varchar(100),
state varchar(100),
country varchar(200 ));

alter table facility add city varchar(30) not null;

explain facility;


-- DAY 9-----------------------------------------------------------------------------------------------------------------------------

create table university
(id int ,
name varchar(100));

insert into university
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
			
set sql_safe_updates =0;

update university
set name = "pune university"
where id =1;

update university
set name = "mumbai university"
where id =2;

update university
set name = "madrads university"
where id =4;

update university
set name = "nagpur university"
where id =5;

update university
set name = "delhi university"
where id = 3;


select id , name
from university
limit 5;


-- day 10---------------------------------------------------------------------------------------------------------------------------------------



create view status_product as
select year(orderDate), count(productCode) as value, concat(round((count(productCode)/(select count(productcode)from orderdetails))*100),"%") as percentage_change
from orderdetails inner join orders
using(orderNumber)
group by year(orderDate)
order by count(quantityOrdered) desc;

select*
from status_product;





-- DAY 11---------------------------------------------------------------------------------------------------------------------------


-- 1

delimiter //
create procedure get_csutomer_level(in customer_number int, out status varchar(20))
begin
    select customerNumber, 
    case
    when creditLimit>100000 then "platinium"
	when creditLimit between 25000 and 100000 then "gold"
	when creditLimit<25000 then "silver"
    end into status
	from customers
    where customerNumber= customer_number;
end //
delimiter ;

call get_csutomer_level(113, @status);
select @status;
 
 
 -- 2
 
delimiter //
create procedure get_country_payment(in inputyear int, in inputcountry varchar(30))
begin
select year(paymentDate) as year,  country,  concat(round(sum(amount)/1000,0),"k") as total
from payments inner join customers
using(customerNumber)
where country= inputcountry and year(paymentDate) = inputyear
group by year(paymentDate), country
order by year;
end //

delimiter ;

call get_country_payment(2003,"germany");

call get_country_payment(2003,"france");



-- DAY 12------------------------------------------------------------------------------------------------------------------------------

-- 1----


SELECT
    year,
    months,
    number,
    CONCAT(FORMAT(((number - LAG(number) OVER (PARTITION BY year ORDER BY months)) / LAG(number) OVER (PARTITION BY year ORDER BY months)) * 100, 0), '%') AS yoy_change
FROM (
    SELECT
        YEAR(orderDate) AS year,
        MONTHNAME(orderDate) AS months,
        COUNT(orderNumber) AS number
    FROM
        orders
    GROUP BY
        year, months
) AS monthly_counts;




-- 2-----

create table emp_udf
(emp_id int primary key auto_increment,
name varchar(20),
DOB date );

insert into emp_udf(name,Dob)
values ("Piyush", "1990-03-30"), 
("Aman", "1992-08-15"),
 ("Meena", "1998-07-28"), 
("Ketan", "2000-11-21"), 
("Sanjay", "1995-05-21");


delimiter //
create function calculate_age(DOB date)
returns varchar(20)
deterministic
begin 
declare year_ int;
declare month_ int;
declare result varchar(20);
set year_ = timestampdiff(year, DOB, curdate());
set month_ = timestampdiff(month , DOB , curdate()) % 12;
set result = concat(year_,"years", month_,"months");

return result;
end //
delimiter ;

select name, DOB, calculate_age(DOB) as age
from emp_udf;



-- day 13--------------------------------------------------------------------------------------------------------------------------------


-- 1 --

select customerNumber,customerName
from customers
where customerNumber not in (select customerNumber
from orders);


-- 2--


select customerNumber,customerName, count(orderNumber)
from customers left join orders
using(customerNumber)
group by customerNumber;


-- 3---

select distinct orderNumber, 2nd_highest
from
(select distinct orderNumber, nth_value(quantityOrdered,2) over(partition by orderNumber order by quantityOrdered desc) as 2nd_highest
from orderdetails) as derived_table
 where 2nd_highest is not null;


-- 4--

select orderNumber, count(distinct productCode), min(quantityOrdered), max(quantityOrdered)
from orderdetails
group by orderNumber;


-- 5--


select productLine, count(productLine) as total
from products
where buyPrice > (select avg(buyPrice)
from products)
group by productLine;



-- day 14 -----------------------------------------------------------------------------------------------------------------------------------------------


create table Emp_EH
(EmpID int primary key,
EmpName varchar(30),
EmailAddress varchar(30));


delimiter //
create procedure emp_eh(in empid int, in empname varchar(20) , in emailid varchar(20) )
begin 

declare exit handler for 1062
select " error occured " as message;

insert into Emp_EH(EmpID,EmpName,EmailAddress)
values(empid, empname, emailid);

SELECT*
FROM emp_eh;

END //
delimiter ;

call emp_eh(1,"kk", "kk@gmail.com");



-- day 15-------------------------------------------------------------------------------------------------------------------------------------


create table EMP_BIT
(name varchar(20),
occupation varchar(20),
working_date date,
working_hours int);


delimiter //
create trigger emptrigger
before insert on EMP_BIT
for each row

begin

if
new.working_hours <0 then set new.working_hours = 0;

end if;

 end //
 delimiter ;


insert into EMP_BIT
values("kk", "it", "2023-12-01",5),
("kg", "sap", "2023-10-20", -8);



-- Assignemnt End !!-- thank you !!----------------------------------------------------------------------------------------------------------------------------