/*3.Return the result of this XML data as table (XML shredding(From XML To Table)) :
<book genre="VB" publicationdate="2010">
   <title>Writing VB Code</title>
   <author>
      <firstname>ITI</firstname>
      <lastname>ITI</lastname>
   </author>
   <price>44.99</price>
</book>
a.Create a table according to the returned tabular data and insert the result on it 
(Search for: Create table as select statement).*/

-- 1-declare xml document
declare @doc xml = '<book genre="VB" publicationdate="2010">
   <title>Writing VB Code</title>
   <author>
      <firstname>ITI</firstname>
      <lastname>ITI</lastname>
   </author>
   <price>44.99</price>
</book>'

-- 2-declare documnent handeler
declare @hdocs int 

-- 3-create memory tree
Execute sp_xml_preparedocument @hdocs output,@doc


-- 4-read tree from memory
select * into booksss
from openxml (@hdocs, '//book') --- Xpath code>> path to reach data in xml
with(genre char '@genre' ,
	 publish date '@publicationdate',
	 title varchar(50) 'title',
	 author_fname char(20) 'author/firstname',
	 author_lname char(20) 'author/lastname',
	 price float 'price')



select * from booksss


---------------------------
/*4.Create a job that make all available  types of backup Daily */

CREATE SCHEMA [Dev_shrouk_scheme];

ALTER SCHEMA [Dev_shrouk_scheme] TRANSFER dbo.v_count

ALTER SCHEMA [Dev_shrouk_scheme] TRANSFER dbo.check_100

ALTER SCHEMA [Dev_shrouk_scheme] TRANSFER dbo.get_all_data


