--Query 1
SELECT 	employees.emp_no as Employee_Number, employees.last_name as Last_Name, employees.first_name as First_Name, employees.gender as Gender, salaries.salary as Salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;

-- Query 2
SELECT emp_no as Employee_Number, last_name as Last_Name, first_name as First_Name, hire_date
FROM employees
WHERE hire_date::text LIKE '%1986%';

-- Query 3
SELECT dept_manager.dept_no as Department_Number, departments.dept_name as Department_Name, dept_manager.emp_no as Employee_Number, employees.last_name as Last_Name, employees.first_name as First_Name, dept_manager.from_date as Start_Date, dept_manager.to_date as End_Date
FROM dept_manager
JOIN departments
ON dept_manager.dept_no = departments.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;

-- Query 4
SELECT employees.emp_no as Employee_Number, employees.last_name as Last_Name, employees.first_name as First_Name, departments.dept_name as Department_Name
From employees
JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no;

-- Query 5
SELECT emp_no as Employee_Number, last_name as Last_Name, first_name as First_Name
FROM employees
WHERE (first_name = 'Hercules' and last_name LIKE 'B%');

-- Query 6
SELECT employees.emp_no as Employee_Number, employees.last_name as Last_Name, employees.first_name as First_Name, departments.dept_name as Department_Name
FROM employees
JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

--Query 7
SELECT employees.emp_no as Employee_Number, employees.last_name as Last_Name, employees.first_name as First_Name, departments.dept_name as Department_Name
FROM employees
JOIN dept_emp
ON employees.emp_no = dept_emp.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE (departments.dept_name = 'Sales' OR departments.dept_name = 'Development');

--Query 8
SELECT last_name, count(last_name)as Last_Name_Freq
FROM employees
GROUP BY last_name
ORDER BY Last_Name_Freq DESC;


