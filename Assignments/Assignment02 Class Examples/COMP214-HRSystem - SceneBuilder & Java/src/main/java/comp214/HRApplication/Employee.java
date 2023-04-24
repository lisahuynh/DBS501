package comp214.HRApplication;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;

public class Employee {

    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private Date hireDate;
    private int salary;
    private String manager;
    private String jobTitle;
    private String departmentName;

    public Employee(String firstName, String lastName, String email, String phone, Date hireDate, int salary, String manager, String jobTitle, String departmentName) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.phone = phone;
        this.hireDate = hireDate;
        this.salary = salary;
        this.manager = manager;
        this.jobTitle = jobTitle;
        this.departmentName = departmentName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public int getSalary() {
        return salary;
    }

    public void setSalary(int salary) {
        this.salary = salary;
    }

    public String getManager() {
        return manager;
    }

    public void setManager(String manager) {
        this.manager = manager;
    }

    public String getJobTitle() {
        return jobTitle;
    }

    public void setJobTitle(String jobTitle) {
        this.jobTitle = jobTitle;
    }

    public String getDepartmentName() {
        return departmentName;
    }

    public void setDepartmentName(String departmentName) {
        this.departmentName = departmentName;
    }

    public static ArrayList<String> GetEmployeeList() {
        // This function returns an array list of names populated by the employees in HR_Employees

        ArrayList<String> employeeList = new ArrayList<>();
        String sqlQuery = "SELECT LAST_NAME || ', ' || FIRST_NAME FROM HR_EMPLOYEES ORDER BY EMPLOYEE_ID ASC";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            Statement st = connection.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                employeeList.add(rs.getString(1));
            }

            rs.close();
            st.close();
            connection.close();

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        return employeeList;
    }

    public int GetEmployeeID(String firstName, String lastName) {

        String sqlQuery = "{ ? = call GET_MANAGER_ID_FROM_NAME(" +
                "'" + firstName + "', " +
                "'" + lastName + "' ) } " ;

        int employeeID = 0;

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.registerOutParameter(1, Types.INTEGER);
            call.execute();

            employeeID = call.getInt(1);

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        return employeeID;
    }

}
