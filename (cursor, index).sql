/*1.Create an index on column (Hiredate) that allow u to cluster the data in the table Department. What will happen?  */
create clustered index ind1
on department(Manager_hiredate)



/*2.Create an index that allows you to enter unique ages in the student table. What will happen?  */
create unique index unqInd1
on student(St_Age)


/*3.create a non-clustered index on column(Dept_Manager) that allows you to enter a unique instructor id in the table Department.  */
create unique index ind2
on department(Dept_Manager)


/*In ITI database Count times that amr apper after ahmed in student table in st_Fname column (using the cursor)  A*/
declare c1 cursor 
for 
select Student.St_Fname
from Student

for read only

declare @name varchar(10), @counter int = 0, @container int = 0

open c1
fetch c1 into @name 

while @@FETCH_STATUS =0
begin
if @name = 'ahmed'
    set @container +=1
if @name = 'amr' and @container = 1
		begin 
			set @counter +=1
			set @container = 0
		end
fetch c1 into @name
end

select @counter

close c1
deallocate c1

select * from Student

---------------------------------or-------------------------

declare c1 cursor 
for 
select  Student.St_Fname, LEAD(St_Fname)over(order by St_id) as next_name
from Student
for read only

declare @stu_name varchar(10), @stu_next varchar(10), @count int = 0

open c1
fetch c1 into @stu_name , @stu_next

while @@FETCH_STATUS =0
begin
if @stu_name ='ahmed' and @stu_next = 'amr'
	set @count+=1

fetch c1 into @stu_name , @stu_next
end

select @count

close c1
deallocate c1



/*2.In Company_SD in employee table Check if Gender='M' add 'Mr Befor Employee name    
else if Gender='F' add Mrs Befor Employee name  then display all names  
use cursor for update*/
declare c1 cursor
for 
select gender
from Employee
for update

declare @name varchar(10), @gender char

open c1

fetch c1 into @gender

while @@FETCH_STATUS = 0
begin
    if @gender ='M'
    begin 
		update Employee
		set Fname = CONCAT('Mr' , ' ' , Fname)
		where current of c1
    end
	else
	begin 
		update Employee
		set Fname = CONCAT('Mrs' , ' ' , Fname)
		where current of c1
    end
fetch c1 into @gender
end

close c1
deallocate c1

select * from Employee

