/*1. Create a scalar function that takes a date and returns the Month name of that date. test (‘1/12/2009’)*/

create function get_month (@date date)
returns varchar(10)
as
begin
/* RETURN DATENAME(MONTH, @date)*/
return format(@date, 'MMMM')
 end

select dbo.get_month('1/12/2009')


/*2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.*/
create function get_numbers (@num1 int, @num2 int)
returns @t Table (numbers int)
as
begin


while @num1 < @num2

begin
  set @num1 +=1

  insert into @t
  values(@num1)

  if (@num1 = @num2-1)
  break
end

return
end

drop function get_numbers

select * 
from dbo.get_numbers(2,5)


/*3. Create a tabled valued function that takes Student No and returns Department Name with Student full name.*/
create  function get_depName_stuFullname (@St_Id int)
returns Table
as 
return
(
select Department.Dept_Name, Student.St_Fname + ' ' + Student.St_Lname as full_nme
from Department join Student
on Student.Dept_Id = Department.Dept_Id
)

select * from get_depName_stuFullname(5)


/*4.Create a scalar function that takes Student ID and returns a message to the user (use Case statement)
a.If the first name and Last name are null then display 'First name & last name are null'
b.If the First name is null then display 'first name is null'
c.If the Last name is null then display 'last name is null'
d.Else display 'First name & last name are not null'*/

create function message(@St_Id int)
returns varchar(100)
as
begin 
declare @first_name char(10)
declare @last_name char(10)

select @first_name = Student.St_Fname , @last_name= Student.St_Lname
from Student
where Student.St_Id = @St_Id


return
case
when @first_name is null and @last_name is null
then 'First name & last name are null'
when @first_name is null
then 'First name are null'
when @last_name is null
then 'Last name are null'
else 'First name & last name are not null' end

end

select dbo.message(5)


/*5.Create a function that takes an integer that represents the format of the Manager hiring date 
and displays department name, Manager Name, and hiring date with this format.   */

create function get_depName_mgrName_hiringDate (@dateStyle int)
returns table
as
return 
(
select Departments.Dname, Employee.Fname + ' ' + Employee.Lname as MGR_name, CONVERT(varchar(50), Departments.[MGRStart Date], @dateStyle) as hiring_date
from Departments join Employee
on Departments.MGRSSN = Employee.SSN
)

select * from dbo.get_depName_mgrName_hiringDate(101)



/*6.Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use the “ISNULL” function*/

create function name_func (@name varchar(50))
returns @t table(name varchar(10))
as
begin
set @name = LOWER(@name)
  if @name = 'first'
    begin
	    insert into @t
	    select ISNULL(Student.St_Fname, '')
		from Student
	end
if @name = 'last'
    begin
	    insert into @t
	    select ISNULL(Student.St_Lname,'')
		from Student
	end
if @name = 'full'
    begin
	    insert into @t
	    select ISNULL(Student.St_Fname, '') + ' ' + ISNULL(Student.St_Lname,'')
		from Student
	end
return
end

drop function 

select *
from name_func('LAST')





/*7.Write a query that returns the Student No and Student first name without the last char*/

select Student.St_Id, LEFT(Student.St_Fname, len(Student.St_Fname)-1) as first_name
from Student


/*1.Create a function that takes project number and display all employees in this project*/
create function all_emp_in_dept (@project_num int)
returns  table
as
return
(
select Employee.Fname
from Employee join Departments
on Employee.Dno = Departments.Dnum
join Project 
on Departments.Dnum = Project.Dnum
where Project.Pnumber = @project_num
)


select * from all_emp_in_dept(100)


/*Bonus >> 2.write a Query that computes the increment in salary that arises if 
the salary of employees increased by any value.*/

alter trigger t 
on Employee
after update 
as
if update (salary)
    select cast((i.salary - d.salary) *100/i.salary as varchar) + '%' as riase
	from deleted d join inserted i
	on d.SSN = i.SSN	

update Employee
set Salary+=500
where ssn = 112233

/*or*/
alter table Employee disable trigger t 

declare @tt table(rasie varchar(12))
update Employee
set Salary+=500
output cast((inserted.salary - deleted.salary) *100/inserted.salary as varchar) + '%' as riase
where ssn = 112233




