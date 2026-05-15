-- PHẦN 1: DDL - THIẾT KẾ CSDL
-- Tạo database
CREATE DATABASE EMPLOYEES_SYSTEM;
USE EMPLOYEES_SYSTEM;

-- Tạo bảng Employees
CREATE TABLE Employees(
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(30) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(10) UNIQUE NOT NULL,
    hire_date DATE DEFAULT (CURRENT_DATE()),
    salary INT NOT NULL CHECK (salary > 0)
);

-- Tạo bảng Employee_Details
CREATE TABLE Employee_Details(
    detail_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT UNIQUE,
    citizen_id VARCHAR(9) UNIQUE NOT NULL,
    address VARCHAR(100) NOT NULL,
    working_status VARCHAR(10) NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- Tạo bảng Departments
CREATE TABLE Departments(
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(30) NOT NULL,
    description VARCHAR(100)
);

-- Tạo bảng Projects
CREATE TABLE Projects(
    project_id INT AUTO_INCREMENT PRIMARY KEY,
    project_name VARCHAR(30) NOT NULL,
    department_id INT NOT NULL,
    budget INT NOT NULL CHECK (budget > 0),
    project_status VARCHAR(10) NOT NULL,
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- Tạo bảng Work_Assignments
CREATE TABLE Work_Assignments(
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT AUTO_INCREMENT NOT NULL,
    project_id INT AUTO_INCREMENT NOT NULL,
    start_date DATE NOT NULL,
    deadline DATE NOT NULL,
    completed_date DATE CHECK (deadline > start_date),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- PHẦN 2: DML – INSERT, UPDATE, DELETE
-- INSERT dữ liệu bảng Employees

INSERT INTO Employees
VALUES
(1, 'Nguyen Van A', 'anv@gmail.com', '0901234567', '2022-01-15', 12000000),
(2, 'Tran Thi B', 'btt@gmail.com', '0912345678', '2021-05-20', 18000000),
(3, 'Le Van C', 'cle@yahoo.com', '0922334455', '2023-02-10', 9500000),
(4, 'Pham Minh D', 'dpham@hotmail.com', '0933445566', '2020-11-05', 22000000),
(5, 'Hoang Anh E', 'ehoang@gmail.com', '0944556677', '2023-01-12', 15000000);

-- INSERT dữ liệu bảng Employee_Details
INSERT INTO Employee_Details
VALUES
(1, 1, '123456789', 'Ha Noi', 'Active'),
(2, 2, '234567890', 'Hai Phong', 'Active'),
(3, 3, '345678901', 'Da Nang', 'Inactive'),
(4, 4, '456789012', 'Ho Chi Minh', 'Active'),
(5, 5, '567890123', 'Can Tho', 'Active');

-- INSERT dữ liệu bảng Departments
INSERT INTO Departments
VALUES
(1, 'IT', 'Phong cong nghe thong tin'),
(2, 'HR', 'Phong nhan su'),
(3, 'Marketing', 'Phong marketing'),
(4, 'Finance', 'Phong tai chinh'),
(5, 'Sales', 'Phong kinh doanh');

-- INSERT dữ liệu bảng Projects
INSERT INTO Projects
VALUES
(1, 'Website Company', 1, 50000000, 'Doing'),
(2, 'Recruitment 2025', 2, 20000000, 'Pending'),
(3, 'Ads Campaign', 3, 30000000, 'Doing'),
(4, 'Accounting System', 4, 45000000, 'Done'),
(5, 'Customer Expansion', 5, 25000000, 'Pending');

-- INSERT dữ liệu bảng Work_Assignments
INSERT INTO Work_Assignments
VALUES
(101, 1, 1, '2024-01-10', '2024-02-10', NULL),
(102, 2, 2, '2024-02-01', '2024-03-01', '2024-02-25'),
(103, 3, 3, '2024-03-05', '2024-04-05', NULL),
(104, 4, 4, '2023-10-10', '2023-12-10', '2023-12-05'),
(105, 5, 5, '2024-04-01', '2024-05-01', NULL);

-- Câu 2: UPDATE & DELETE
-- Tăng thêm 5.000.000 cho các dự án thuộc phòng IT
UPDATE Projects p
JOIN Departments d
ON p.department_id = d.department_id
SET p.budget = p.budget + 5000000
WHERE d.department_name = 'IT';

-- Xóa các công việc đã hoàn thành và bắt đầu trước năm 2024
DELETE FROM Work_Assignments
WHERE completed_date IS NOT NULL AND start_date < '2024-01-01';



-- PHẦN 3: TRUY VẤN CƠ BẢN
-- Câu 1: Liệt kê các thông tin dự án gồm project_id, project_name, budget của những dự án thuộc phòng ban 'IT' và có ngân sách lớn hơn 30.000.000.
SELECT p.project_id, p.project_name, p.budget
FROM Projects p
JOIN Departments d ON p.department_id = d.department_id
WHERE d.department_name = 'IT'
AND p.budget > 30000000;

-- Câu 2: Liệt kê các thông tin nhân viên gồm employee_id, full_name, email của những nhân viên có ngày vào làm trong năm 2022 và email thuộc tên miền '@gmail.com'.
SELECT employee_id, full_name, email
FROM Employees
WHERE hire_date BETWEEN '2022-01-01' AND '2022-12-31'
AND email LIKE '%@gmail.com';

-- Câu 3: Liệt kê nhân viên gồm employee_id, full_name, salary, được sắp xếp theo lương giảm dần và hiển thị 3 nhân viên bắt đầu từ người thứ 2 (bỏ qua người lương cao nhất).
SELECT employee_id, full_name, salary
FROM Employees
ORDER BY salary DESC
LIMIT 3 OFFSET 1;


-- PHẦN 4: TRUY VẤN NÂNG CAO
-- Câu 1: Liệt kê các thông tin phân công gồm mã phân công, tên nhân viên, tên dự án, ngày bắt đầu, hạn hoàn thành, với dữ liệu được lấy từ các bảng liên quan và chỉ hiển thị các công việc chưa hoàn thành (completed_date IS NULL).
SELECT w.assignment_id, e.full_name, p.project_name, w.start_date, w.deadline
FROM Work_Assignments w
JOIN Employees e ON w.employee_id = e.employee_id
JOIN Projects p ON w.project_id = p.project_id
WHERE w.completed_date IS NULL;

-- Câu 2: Liệt kê tổng ngân sách dự án theo từng phòng ban gồm department_name và total_budget, chỉ hiển thị những phòng ban có tổng ngân sách lớn hơn 40.000.000.
SELECT d.department_name, SUM(p.budget) AS total_budget
FROM Departments d
JOIN Projects p ON d.department_id = p.department_id
GROUP BY d.department_name
HAVING SUM(p.budget) > 40000000;

-- Câu 3: Liệt kê các thông tin nhân viên gồm employee_id, full_name, working_status của những nhân viên có trạng thái làm việc là 'Active' nhưng chưa từng tham gia dự án nào có ngân sách lớn hơn 40.000.000.
SELECT e.employee_id, e.full_name, ed.working_status
FROM Employees e
JOIN Employee_Details ed ON e.employee_id = ed.employee_id
WHERE ed.working_status = 'Active'
AND e.employee_id NOT IN (
    SELECT DISTINCT w.employee_id
    FROM Work_Assignments w
    JOIN Projects p ON w.project_id = p.project_id
    WHERE p.budget > 40000000
);


-- PHẦN 5: INDEX & VIEW
-- Câu 1: Tạo một chỉ mục (index) tên idx_assignment_dates trên bảng Work_Assignments dựa trên hai cột start_date và completed_date 
CREATE INDEX idx_assignment_dates
ON Work_Assignments(start_date, completed_date);

-- Câu 2: Tạo View tên vw_overdue_assignments hiển thị mã phân công, tên nhân viên, tên dự án, ngày bắt đầu và hạn hoàn thành, chỉ chứa các công việc chưa hoàn thành và đã quá hạn so với ngày hiện tại.
CREATE VIEW vw_overdue_assignments AS
SELECT w.assignment_id, e.full_name, p.project_name, w.start_date, w.deadline
FROM Work_Assignments w
JOIN Employees e ON w.employee_id = e.employee_id
JOIN Projects p ON w.project_id = p.project_id
WHERE w.completed_date IS NULL AND w.deadline < CURDATE();


-- PHẦN 6: TRIGGER
-- Câu 1: Viết trigger tên trg_after_assignment_insert sao cho khi thêm mới một phân công vào bảng Work_Assignments, hệ thống tự động cập nhật trạng thái thành 'Doing'.
DELIMITER //
CREATE TRIGGER trg_after_assignment_insert
AFTER INSERT ON Work_Assignments
FOR EACH ROW
BEGIN
    UPDATE Projects
    SET project_status = 'Doing'
    WHERE project_id = NEW.project_id;
END //
DELIMITER ;

-- Câu 2: Viết trigger tên trg_prevent_delete_employee ngăn xóa nhân viên
DELIMITER //
CREATE TRIGGER trg_prevent_delete_employee
BEFORE DELETE ON Employees
FOR EACH ROW
BEGIN
    DECLARE unfinished_tasks INT;
    SELECT COUNT(*) INTO unfinished_tasks
    FROM Work_Assignments
    WHERE employee_id = OLD.employee_id AND completed_date IS NULL;
    IF unfinished_tasks > 0 THEN SIGNAL SQLSTATE '45000'
	SET MESSAGE_TEXT = 'Khong the xoa nhan vien vi van con cong viec chua hoan thanh';
    END IF;
END //
DELIMITER ;



-- PHẦN 7: STORED PROCEDURE
-- Câu 1: Viết một stored procedure tên sp_check_project_budget nhận vào p_project_id và trả về p_message, trong đó:
-- Nếu ngân sách < 20.000.000 → 'Ngân sách thấp'
-- Nếu ngân sách từ 20.000.000 – 40.000.000 → 'Ngân sách trung bình'
-- Nếu ngân sách > 40.000.000 → 'Ngân sách cao'

DELIMITER //
CREATE PROCEDURE sp_check_project_budget(
    IN p_project_id INT,
    OUT p_message VARCHAR(50)
)
BEGIN
    DECLARE v_budget INT;
    SELECT budget INTO v_budget
    FROM Projects
    WHERE project_id = p_project_id;
    IF v_budget < 20000000 THEN
        SET p_message = 'Ngan sach thap';
    ELSEIF v_budget BETWEEN 20000000 AND 40000000 THEN
        SET p_message = 'Ngan sach trung binh';
    ELSE
        SET p_message = 'Ngan sach cao';
    END IF;
END //
DELIMITER ;

-- Test Procedure
CALL sp_check_project_budget(1, @msg);
SELECT @msg;

-- Câu 2:Viết một stored procedure tên sp_complete_assignment_transaction để xử lý hoàn thành công việc bằng Transaction, nhận vào p_assignment_id, gồm các bước:
-- Bước 1: Bắt đầu giao dịch (START TRANSACTION)
-- Bước 2: Kiểm tra công việc đã hoàn thành chưa — nếu completed_date IS NOT NULL → ROLLBACK + báo lỗi 'Công việc đã hoàn thành rồi'
-- Bước 3: Cập nhật completed_date = CURDATE()
-- Bước 4: Nếu tất cả công việc của dự án đã hoàn thành → cập nhật project_status = 'Done'
-- Bước 5: COMMIT nếu thành công, ROLLBACK nếu có lỗi


DELIMITER //
CREATE PROCEDURE sp_complete_assignment_transaction(
    IN p_assignment_id INT
)
BEGIN
    DECLARE v_completed_date DATE;
    DECLARE v_project_id INT;
    DECLARE v_unfinished_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;
    SELECT completed_date, project_id
    INTO v_completed_date, v_project_id
    FROM Work_Assignments
    WHERE assignment_id = p_assignment_id;

    IF v_completed_date IS NOT NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cong viec da hoan thanh roi';

    ELSE
        UPDATE Work_Assignments
        SET completed_date = CURDATE()
        WHERE assignment_id = p_assignment_id;
        SELECT COUNT(*) INTO v_unfinished_count
        FROM Work_Assignments
        WHERE project_id = v_project_id AND completed_date IS NULL;
        
        IF v_unfinished_count = 0 THEN
            UPDATE Projects
            SET project_status = 'Done'
            WHERE project_id = v_project_id;
        END IF;
        COMMIT;
    END IF;
END //
DELIMITER ;

-- Test Procedure
CALL sp_complete_assignment_transaction(101);
