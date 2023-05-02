/*1.For each project, list the project name and the total hours per week (for all employees) spent on that project.*/
select Project.Pname, SUM(Works_for.Hourss)
from Project join Works_for
on Works_for.Pno = Project.Pnumber
group by Project.Pname



/*2.Display the data of the department which has the smallest employee ID over all employees' ID.*/
select Departments.*
from Departments join Employee
on Departments.Dnum = Employee.Dno
where Employee.SSN = (select MIN(ssn) from Employee)


/*3.For each department, retrieve the department name and the maximum, minimum and average salary of its employees.*/
select Departments.Dnum, MAX(salary) as max_salary, MIN(salary) as min_salary, AVG(salary) as avg_salary
from Departments join Employee
on Departments.Dnum = Employee.Dno
group by Departments.Dnum


/*4.For each department-- 
if its average salary is less than the average salary of all employees-- 
display its number, name and number of its employees.*/
select Dnum, Dname, COUNT(ssn)
from Departments join Employee
on Departments.Dnum = Employee.Dno
group by Dnum,Dname
having AVG(salary) < (select AVG(salary) from Employee)


/*5.Try to get the max 2 salaries */
select top(2) salary
from Employee
order by salary desc

--or 
select *
from (select ROW_NUMBER() OVER(order by salary desc) as RN, salary
from employee) as new_table
where RN =1 or RN =2


/*6.Find Highest two projects in working hours For each department*/
select *
from 
(
select ROW_NUMBER() over(partition by Dnum order by sum(hourss) desc) as RN, Dnum,sum(hourss) as total_hours
from Project join Works_for
on Works_for.Pno = Project.Pnumber
group by  Project.Pname, Dnum
) as new_table
where RN = 1 or RN=2





/*1.Find Second highest total grade student  for each department  */
select *
from(
select ROW_NUMBER() OVER(order by sum(grade) desc) as RN, Department.Dept_Id,sum(grade) as total_grade
from Department join Student
on Student.Dept_Id = Department.Dept_Id
join Stud_Course
on Student.St_Id = Stud_Course.St_Id
group by Department.Dept_Id) as new_table
where RN = 2


/*2.Find Second Highest Instructor Salary for each Instructor Degree*/
select *
from
(
select ROW_NUMBER() OVER(partition by Ins_Degree order by salary desc) as RN ,Ins_Degree, Instructor.Salary 
from Instructor
where Ins_Degree is not null
) as new_table
where RN = 2