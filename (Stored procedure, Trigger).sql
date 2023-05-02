/*1.Create a stored procedure to show the number of students per department.[use ITI DB]*/
alter proc stud_count_per_dept 
as
select count(Student.St_Id), Department.Dept_Id
from Student join Department
on Student.Dept_Id = Department.Dept_Id
group by Department.Dept_Id

stud_count_per_dept 


/*2.Create a stored procedure that will check for the number of employees in the project 100 
if they are more than 3 print a message to the user “'The number of employees in the project 100 is 3 or more'”
if they are less display a message to the user “'The following employees work for the project p1'” 
in addition to the first name and last name of each one. [Company DB]*/

alter proc  check_100
as
declare @emp_count int
select @emp_count = COUNT(Employee.SSN)
from Employee join Departments
on Employee.Dno = Departments.Dnum
join Project
on Departments.Dnum = Project.[Dnum]
where Project.Pnumber = 100


declare @t table(full_name varchar(50))
insert into @t
select Employee.Fname +' '+ Employee.Lname as full_name
from Employee join Departments
on Employee.Dno = Departments.Dnum
join Project
on Departments.Dnum = Project.[Dnum]
where Project.Pnumber = 100


if @emp_count >= 3
    select * from @t
	union
    select 'The number of employees in the project 100 is 3 or more'
	
else
   select * from @t
   union
   select 'The following employees work for the project p1' 
	

check_100



/*3. Create a stored procedure that will be used in case there is an old employee has left the project
and a new one become instead of him. The procedure should take 3 parameters 
(old Emp. number, new Emp. number and the project number) and it will be used to update works_for table. [Company DB]*/

alter proc new_emp @old_id int, @new_id int
as
if not exists (select * from Employee where SSN = @new_id)
    select 'employee isnt included in the company'
else 
    update Works_for
    set Works_for.ESSn = @new_id
    where Works_for.ESSn = @old_id

new_emp 112233,968574

select * from Employee



/* Create an Audit table with the following structure

ProjectNo	UserName	ModifiedDate	Hours_Old	Hours_New
   p2	      Dbo	     2008-01-31	       10	       20
 
This table will be used to audit the update trials on the Hours column (works_for table, Company DB)
Example:
If a user updated the Hours column then the project number, the user name that made that update,
the date of the modification and the value of the old and the new Hours will be inserted into the Audit table
Note: This process will take place only if the user updated the Hours column*/

create table Auditing
(ProjectNo int,
UserName varchar(max),
ModifiedDate date,
Hours_Old int,
Hours_New int)

alter trigger t1
on Works_for
after update
as
if UPDATE (Hourss)
    begin 
	    declare @old_hours int, @new_hours int, @project_number int

	    select @old_hours = Hourss from Deleted

		select @new_hours = Hourss from Inserted

		select @project_number = pno from Works_for
		insert into auditing
        values(@project_number,SUSER_NAME(),GETDATE(),@old_hours, @new_hours)
		end



update Works_for
set Hourss = 100
where pno = 100

select * from Auditing


/*5.Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
Print a message for the user to tell him that he ‘can’t insert a new record in that table’*/

alter trigger t2
on departments
instead of insert
as
rollback
select 'can’t insert a new record in that table'


insert into Departments(Dnum, Dname)
values(166,'new_dept')


/*Create a trigger that prevents users from altering any table in Company DB.*/
create trigger t3
on database
for alter_table
as
rollback
select 'cant alter any table in this database'

alter table Departments 
add ay_kalam int


/*Create a trigger on student table after insert to add Row in a Student Audit table
(Server User Name, Date, Note) where the note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
Server User Name	date	Note*/

create table student_audit
(
serverUserName varchar(max),
insert_date date,
note varchar(max)
)

alter trigger t5
on student
after insert 
as
declare @inserted_key int
select @inserted_key= St_Id from inserted
declare @insert_note varchar(max)
set @insert_note =  SUSER_NAME()+ ' Insert New Row with Key '+ CAST(@inserted_key AS NVARCHAR(10)) + ' in table "Student" '  
insert into student_audit
values(SUSER_NAME(), GETDATE(), @insert_note)

insert into Student(St_Id)
values(66)

select * from student_audit


/*Bonus*/
/*1. Create a scalar function that takes a date and returns the Month name of that date. test (‘1/12/2009’)*/
create proc get_month (@date date)
as
select format(@date, 'MMMM')


get_month '1/12/2009'


/*2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.*/
alter proc get_numbers (@num1 int, @num2 int)
as
declare @t table(num_range int)

while @num1 < @num2

begin
  set @num1 +=1

  insert into @t
  values(@num1)

  if (@num1 = @num2-1)
  break
end
select * from @t

get_numbers 2,5


/*3. Create a tabled valued function that takes Student No and returns Department Name with Student full name.*/
create  proc get_depName_stuFullname @St_Id int
as 
select Department.Dept_Name, Student.St_Fname + ' ' + Student.St_Lname as full_nme
from Department join Student
on Student.Dept_Id = Department.Dept_Id

declare  @t table(dept_name varchar(50),fullname varchar(50))
insert into @t
execute get_depName_stuFullname 5
select * from @t



/*4.Create a scalar function that takes Student ID and returns a message to the user (use Case statement)
a.If the first name and Last name are null then display 'First name & last name are null'
b.If the First name is null then display 'first name is null'
c.If the Last name is null then display 'last name is null'
d.Else display 'First name & last name are not null'*/

create proc  name_message(@St_Id int)
as
declare @first_name char(10)
declare @last_name char(10)

select @first_name = Student.St_Fname , @last_name= Student.St_Lname
from Student
where Student.St_Id = @St_Id

select case
when @first_name is null and @last_name is null
then 'First name & last name are null'
when @first_name is null
then 'First name are null'
when @last_name is null
then 'Last name are null'
else 'First name & last name are not null' end

name_message 5 



































