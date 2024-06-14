#1. Find all clients whose name is less than 6 characters
select *
from users
where length(name) < 6;
# 2. Choose Lviv bank branches.
select *
from department
where DepartmentCity = 'LVIV';
#3. Select clients with higher education and sort them by last name.
select *
from client
where Education = 'high'
order by LastName;
# 4. Sort in reverse order over the Application table and display the last 5 records.
select *
from application a
order by idApplication desc
limit 5;
#5. List all clients whose last name ends with OV or OVA.
select *
from client
where LastName like '%OV'
   or LastName like '%OVA';
#6. Output bank clients who are served by Kyiv branches.
select *
from client c
         join department on c.Department_idDepartment = department.idDepartment
where DepartmentCity = 'Kyiv';
#7. Find all customer names without repetitions.
select distinct FirstName
from client;
# 8. Display data about clients who have loans of more than 5000 hryvnia.
select FirstName, Sum
from client c
         join application a on c.idClient = a.Client_idClient;
# 9. Count the quantity of clients of all branches and only Lviv branches.
select count(distinct FirstName, LastName, Age)
from client;
select count(distinct FirstName, LastName, Age) as onlyLvivDepartment
from client c
         join department d on c
                                  .Department_idDepartment = d
                                  .idDepartment
where DepartmentCity = 'Lviv';
# 9.2 (my task) Count the quantity of clients of every branches, and show every branches in one table with their
# quantity
select count(distinct FirstName, LastName, Age) as quantityOfDepartment,
       DepartmentCity
from client c
         join department d on c.Department_idDepartment
    = d.idDepartment
group by idDepartment;
#10. Find loans that have the highest sum for each client separately.
select FirstName, LastName, Age, max(Sum) as MaxSum
from client c
         join application a on c.idClient = a.Client_idClient
group by FirstName, LastName, Age;
# 11. Count the number of loan applications for each client.
select FirstName, LastName, Age, count(Sum) as NumberOfApplications
from client c
         join application a on c.idClient = Client_idClient
group by FirstName, LastName, Age;
#12. Find the largest and smallest loans.
select max(Sum) MaxCredit
from client c
         join application a on c.idClient = a.Client_idClient;

select min(Sum)
from client c
         join application a on c.idClient = a.Client_idClient;
#13. Calculate the number of loans for clients who have a higher education.
select distinct FirstName, LastName, Age, count(Sum) NumberLoans
from client c
         join application a on c.idClient = Client_idClient
where Education = 'high'
group by FirstName, LastName, Age;
# 14. Display data about the client who has the highest average loan amount.
select FirstName, LastName, Age, avg(Sum) ClientWithHighestAverageLoan
from client c
         join application a on c.idClient = a.Client_idClient
group by FirstName, LastName, Age
order by ClientWithHighestAverageLoan desc
limit 1;
# 15. Output the branch that gave the most money on credit.
select count(Sum) BranchGaveMostMoneyOnCredit, DepartmentCity
from application a
         join client c on a.Client_idClient = c.idClient
         join department d on c.Department_idDepartment = d.idDepartment
group by idDepartment
order by BranchGaveMostMoneyOnCredit desc
limit 1;
#16. Output the branch that issued the largest loan.
select max(Sum) BranchGavelargestCredit, DepartmentCity
from application a
         join client c on a.Client_idClient = c.idClient
         join department d on c.Department_idDepartment = d.idDepartment
group by DepartmentCity
order by BranchGavelargestCredit desc
limit 1;
# 17. For all clients who have a higher education, set all their credits to 6000 UAH.
update application a
    join client c on a.Client_idClient = c.idClient
set Sum = 6000
where Education = 'high';
# 18. Transfer all clients of Kyiv branches to Kyiv.
update department d
    join client c on d.idDepartment = c.Department_idDepartment
set City = 'Kyiv'
where DepartmentCity = 'Kyiv';
#19. Delete all returned credits.
delete
from application
where CreditState = 'Returned';
#20. Remove credits from clients whose second letter of their last name is a vowel.
delete a
from client c
         join application a on c.idClient = a.Client_idClient
where LastName like '_a%'
   or LastName like '_e%'
   or LastName like '_i%'
   or LastName
    like '_o%'
   or LastName like '_u%';

# 21. Find Lviv branches that issued loans totaling more than 5000
select sum(Sum) AllSum, DepartmentCity from department d
    join client c on c.Department_idDepartment = d.idDepartment
    join application a on c.idClient = a.Client_idClient
where DepartmentCity = 'Lviv' group by idDepartment having AllSum > 5000;

#22. Find clients who have repaid loans worth more than 5000
select FirstName, LastName, Sum, CreditState from client
                                                      join application on client.idClient = application.Client_idClient
where CreditState = 'Returned' and Sum >5000;

#23. Find the largest not returned loan.
select FirstName, LastName, max(Sum) LargestOutstanding, CreditState from client c
                                                                              join application a on c.idClient = a.Client_idClient
where CreditState ='Not returned' group by FirstName, LastName, CreditState order by LargestOutstanding desc limit 1;

#24. Find the client with the lowest loan amount
select FirstName, LastName, sum(Sum) lowestLoan from client c
                                                         join application a on c.idClient = a.Client_idClient
group by FirstName, LastName order by lowestLoan limit 1;

#25. Find loans whose sum is greater than the arithmetic average of all loans.
select idApplication,Sum from application
where Sum > (select avg(Sum) from application);

#26. Find clients from the same city as the client who took the largest number of loans.
select * from client c
                  join application a on c.idClient = a.Client_idClient
where City = (select City from client c
                                   join application a on c.idClient = a.Client_idClient
              order by Sum desc limit 1);

#27. Find the client’s city with the most quantity of credits.
select City, count(Sum) quantityOfCredits from client c
                                                   join application a on c.idClient = a.Client_idClient
group by City order by quantityOfCredits desc;