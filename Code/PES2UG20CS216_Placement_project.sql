-- Author: SRN: PES2UG20CS216
--         Name: Naren Chandrashekahar
--         Section: D

-- Project Topic: Placement Management System
--
-- Database name: `placement`
--

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

create table student(SRN int NOT NULL PRIMARY KEY, Name VARCHAR(100), Phone_no int, Degree VARCHAR(20), Branch VARCHAR(30), 10th int,12th int, DOB date, Email VARCHAR(50), Address VARCHAR(100), CGPA int, Govt_ID VARCHAR(100));

--
-- Inserting data for table `student`
--

insert into student values('PES001', 'Axe','1111','B-Tech','Computer Science', '90','92','2000-01-01','axe@gmail.com','Mumbai','9','GI005'),('PES002', 'Ave','1112','B-Tech','Computer Science', '95','91','2000-02-03','ave@gmail.com','Mumbai','8','GI015'),('PES003', 'Apple','1131','B-Tech','Computer Science', '80','82','2001-01-01','apple@gmail.com','Bangalore','10','GI025');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

create table user(User_ID int NOT NULL PRIMARY KEY, Phone_No int, Email VARCHAR(50), Address VARCHAR(100), Name VARCHAR(100), User_Role VARCHAR(30));
--
-- Inserting data for table `user`
--

insert into user values('001','8888','admin@gmail.com','PESU EC','Admin','Administrator'),('002','8881','hod@gmail.com','PESU EC','HOD','HOD');

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

create table company(Company_ID int NOT NULL PRIMARY KEY, Name VARCHAR(50), Phone_No int, Website VARCHAR(50), Company_Type VARCHAR(30), Address VARCHAR(100) NOT NULL);

--
-- Inserting data for table `company`
--

insert into company values ('01','Amazon','9999','amazon.in','Product','Bangalore'),('02','Intel','9998','intel.com','Product','Bangalore'), ('03','Infosys','9988','infosys.com','Services','Bangalore'), ('04','Facebook','9991','facebook.com','Product','Hyderabad');

-- --------------------------------------------------------

--
-- Table structure for table `job`
--

create table job(Job_ID int NOT NULL PRIMARY KEY, Job_Description VARCHAR(100), Salary_or_Stipend int, Full_time_or_Internship VARCHAR(30), Job_Title VARCHAR(40), Company_ID int, FOREIGN KEY (Company_ID) REFERENCES company(Company_ID));

--
-- Inserting data for table `job`
--

insert into job values('1000', 'Front End','200000','Full time','Software Engineer','01'),('2000', 'UI/UX','150000','Full time','Software Engineer','03'),('101', 'Data Analyst','110000','Full time','Software Engineer','04');
-- --------------------------------------------------------

--
-- Table structure for table `job_application`
--

create table job_application(SRN int, FOREIGN KEY(SRN) REFERENCES student(SRN), Job_ID int, FOREIGN KEY(Job_ID) REFERENCES job(Job_ID));
--
-- Inserting data for table `job`
--

insert into job_application values('PES001','1000'),('PES002','2000');
-- --------------------------------------------------------

--
-- Table structure for table `placed_details`
--

create table placed_details(SRN int, FOREIGN KEY(SRN) REFERENCES student(SRN), Company_ID int, FOREIGN KEY(Company_ID) REFERENCES company(Company_ID), Job_ID int, FOREIGN KEY(Job_ID) REFERENCES job(Job_ID), Start_Date date);
--
-- Inserting data for table `placed_details`
--

insert into placed_details values('PES001','01','1000','2022-12-01'),('PES002','02','2000','2022-09-08');
-- --------------------------------------------------------

-- JOIN OPERATIONS

--Retrieve Name and SRN of all students who have been placed in a company with id = 1.
SELECT Name,student.SRN FROM `student`
join placed_details ON student.SRN = placed_details.SRN
WHERE placed_details.Company_ID = '1';


--Retrieve the names of all company who have posted and not posted a job
SELECT Name,company.Company_ID FROM `company`
left outer join job ON company.Company_ID = job.Company_ID;

--Retrieve the total number of students who got placed in Intel
SELECT count(student.SRN) FROM `student`
join placed_details ON student.SRN = placed_details.SRN
WHERE placed_details.Company_ID = '2';

--Retrieve all data about a placed student
SELECT * from placed_details join job on placed_details.Job_ID = job.Job_ID;


------------------------------------------------
--Functions
Create Function eligibility1(SRN varchar(20)) Returns varchar(100) Deterministic Begin Declare per10 int; Declare per12 int; Declare msg varchar(100); Set per10 = (select 10th from student where student.SRN=SRN); Set per12 = (select 12th from student where student.SRN=SRN); If per10 > 65 and per12>65 Then Set msg = Concat('You are eligible for placements'); Else SET msg = Concat('You are not eligible for placements'); End if; Return msg; End;

select SRN,Name,eligibility1(SRN) from student;

--Procedure
DELIMITER $$
CREATE procedure company_typ(IN Company_ID int(11) ,OUT msg varchar(100))
BEGIN
DECLARE cnt varchar(100);
set cnt= (select  Company_Type from company where Company_ID=company.Company_ID);

IF cnt = 'Product'  THEN
   set msg= 'This company is a product comapny, hence the compensations given are higher';
ELSE
    set msg='This is not a product company';   
END IF;
END;$$
DELIMITER ;
call company_typ(1,@x);
select @x;


------------------------------------------------------------------------------
--Triggers
--The problem statement is: Validating the SRN of a student in the student table. 
--The format should be PES___. In the below example, we have given xXX instead of PES, and hence the message given back is illegal srn.


DELIMITER $$
create Trigger srn_check
before insert
on student
for each row
Begin
declare erroe_msg varchar(225);
set error_msg = 'illegal srn';
if(new.SRN != 'PES%') then signal sqlstate '45000' set message_text = error_msg;
end if;
end $$
DELIMITER;