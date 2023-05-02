/*1.  Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “. */
create view v1
as 
select i.Ins_Name , d.Dept_Name
from Instructor i join Department d
on i.Dept_Id = d.Dept_Id
where d.Dept_Name in  ('SD','Java')

select * from v1


/*2.Create a view “V1” that displays student data for the student who lives in Alex or Cairo. Note: Prevent the users to run the following query Update V1 set st_address=’tanta’  Where st_address=’alex’;*/
create view v2 
as 
select *  from Student
where Student.St_Address in ('Alex','Cairo')
with check option

Update v2 set st_address='tanta'  Where st_address='Alex'


/*3. Create a view that displays the student’s full name, course name if the student has a grade of more than 50.*/
create view v3 
as 
select Student.St_Fname+' ' + Student.St_Lname as full_name, Course.Crs_Name
from Student join Stud_Course
on Student.St_Id = Stud_Course.St_Id
join Course
on Stud_Course.Crs_Id = Course.Crs_Id
where Grade>50

select * from v3

/*4. Create an Encrypted view that displays manager names and the topics they teach. 
(Hint :To Find Instructor who work as manger using Manage Relation Ship 
between instructor and department PK =[dbo].[Instructor]. [Ins_Id]
FK =[dbo].[Department]. [Dept_Manager]  )*/

create view v4 
with encryption
as 
select Instructor.Ins_Name, Topic.Top_Name
from Instructor join Department
on Instructor.Ins_Id = Department.Dept_Manager
join Student
on Student.Dept_Id = Department.Dept_Id
join Stud_Course
on Student.St_Id = Stud_Course.St_Id
join Course
on Stud_Course.Crs_Id = Course.Crs_Id
join Topic 
on Topic.Top_Id = Course.Top_Id


select * from v4



/*1) Create a view that will display the project name and the number of employees works on it.*/
create view v5
as
select Project.Pname, count(e.SSN) as emp_count
from Project join Departments
on Project.Dnum = Departments.Dnum
join Employee e
on e.Dno = Departments.Dnum
group by Project.Pname



/*2)Create a view named   “v_D30” that will display employee number, project number, hours of the projects in department 30.*/
create view v_D30
as
select Employee.SSN, Project.Pnumber, Works_for.Hours
from Project join Departments
on Project.Dnum = Departments.Dnum
join Employee 
on Employee.Dno = Departments.Dnum
join Works_for
on Works_for.Pno = Project.Pnumber
where Departments.Dnum = 30

/*3)Create a view named  “v_count “ that will display the project name and the number of hours for each one. */
create view v_count
as 
select Project.Pname, Works_for.Hours
from Project join Works_for
on Project.Pnumber = Works_for.Pno


/*4)Create a view named ” v_project_500” that will display the emp no. for the project 500, use the previously created view  “v_D30”*/
create view v_project_500
as 
select v_D30.SSN
from v_D30
where v_D30.Pnumber = 500


/*5)Delete the views  “v_D30” and “v_count”*/
drop view v_D30
drop view v_count



/*1.Make a rule that makes sure the value is less than 1000 then bind it on the Salary in Employee table.*/
create rule r1 as @y>1000

sp_bindrule r1, 'Employee.Salary'


/*2.Create a new user data type named loc with the following Criteria:
•	nchar(2)
•	default: NY 
•	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the location column*/
create type loc from nchar (2)

create default def1 as 'NY'

create rule r2 as @y in ('NY','DS','KW')

sp_bindrule r2,loc




/*3.Create a New table Named newStudent, and use the new user define data type on it you just have made and .*/
create table newStudent (
newStuId char(10) primary key,
location loc
)



