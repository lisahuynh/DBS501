package comp214.HRApplication;


import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.stage.Stage;

import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.ResourceBundle;

public class EmployeeController implements Initializable{

    private Stage stage;
    private Scene scene;
    private Parent root;

    @FXML
    TextField firstNameField, lastNameField, phoneField, emailField, hireDateField, salaryField;
    @FXML
    TextField firstNameUpdate,lastNameUpdate,emailUpdate,phoneUpdate,salaryUpdate,commUpdate,jobIdUpdate,managerIdUpdate,deptIdUpdate,hireDateUpdate;
    @FXML
    ChoiceBox<String>  cb_ModifyEmployee, cbNewManager, cbNewDepartment, cbNewJob;
    @FXML
    Label successMessage;

    public ArrayList<String> employeeList = Employee.GetEmployeeList();
    public ArrayList<String> jobList = GetJobList();
    public ArrayList<String> departmentList = GetDepartmentList();


    public void initialize(URL arg0, ResourceBundle arg1) {

        cb_ModifyEmployee.getItems().addAll(employeeList);

        cbNewJob.getItems().addAll(jobList);
        cbNewManager.getItems().addAll(employeeList);
        cbNewDepartment.getItems().addAll(departmentList);

        // setting the hire date as system's current date
        DateFormat df = new SimpleDateFormat("yyyy/MM/dd");
        Date currentDate = new Date();
        hireDateField.setText(df.format(currentDate));
    }

    public ArrayList<String> GetJobList() {
        // This function returns an array list populated by the possible jobs that an individual may hold
        // per the HR_JOBS table

        ArrayList<String> jobsList = new ArrayList<>();
        String sqlQuery = "SELECT JOB_TITLE FROM HR_JOBS";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            Statement st =connection.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                jobsList.add(rs.getString("JOB_TITLE"));
            }

            rs.close();
            st.close();
            connection.close();

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        return jobsList;

    }

    public ArrayList<String> GetDepartmentList() {
        // This function returns an array list populated by the possible departments
        // per the HR_DEPARTMENTS table

        ArrayList<String> departmentsList = new ArrayList<>();
        String sqlQuery = "SELECT DEPARTMENT_NAME FROM HR_DEPARTMENTS";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            Statement st =connection.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                departmentsList.add(rs.getString("DEPARTMENT_NAME"));
            }

            rs.close();
            st.close();
            connection.close();

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        return departmentsList;

    }

    public String getJobId(String jobTitle) {
        String sqlQuery = "{ ? = call GET_JOB_ID_FROM_NAME( '" + jobTitle + "') }";

        String rValue = null;

        try {
            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.registerOutParameter(1,Types.VARCHAR);
            call.execute();
            rValue = (call.getString(1));

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        return rValue;
    }

    public int getDepartmentId(String departmentName){
        String sqlQuery = "{ ? = call GET_DEPARTMENT_ID_FROM_NAME( '" + departmentName + "') }";

        int rValue = 0;

        try {
            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.registerOutParameter(1,Types.INTEGER);
            call.execute();
            rValue = (call.getInt(1));

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        return rValue;
    }

    public int getManagerId(String firstName, String lastName){
        String sqlQuery = "{ ? = call GET_MANAGER_ID_FROM_NAME(" +
                "'" + firstName + "','"
                + lastName + "') }";

        int rValue = 0;

        try {
            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.registerOutParameter(1,Types.INTEGER);
            call.execute();
            rValue = (call.getInt(1));

        } catch (Exception e) {
            System.out.println("Exception Found!");
            System.out.println(sqlQuery);
            e.printStackTrace();
        }

        return rValue;
    }

    @FXML
    public void hireEmployee(ActionEvent e) throws IOException {

        String firstName = firstNameField.getText();
        String lastName = lastNameField.getText();
        String email = emailField.getText();
        String phone = phoneField.getText();
        String salary = salaryField.getText();
        String job_name = cbNewJob.getValue();
        String department_name = cbNewDepartment.getValue();
        String hireDate = hireDateField.getText();


        try {
            String manager_name = cbNewManager.getValue();
            String manager_fname = manager_name.split(", ")[1];
            String manager_lname = manager_name.split(", ")[0];
            int departmentId = getDepartmentId(department_name);
            int managerId = getManagerId(manager_fname, manager_lname);
            String jobId = getJobId(job_name);

            String sqlQuery = "{CALL employee_hire_sp("
                    +"'"+firstName+"', "
                    +"'"+lastName+"', "
                    +"'"+email+"', "
                    +salary+", "
                    +"'"+hireDate+"', "
                    +"'"+phone+"', "
                    +"'"+jobId+"', "
                    +managerId+", "
                    +departmentId+ ") }";

            System.out.println(sqlQuery);

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call =connection.prepareCall(sqlQuery);

            call.execute();

            call.close();
            connection.close();

            setMessageUpdate(lastName + ", " + firstName, "SUCCESS");


        } catch (Exception err) {
            setMessageUpdate(lastName + ", " + firstName, "FAILURE");

            System.out.println("Exception Found!");
            //err.printStackTrace();


        }
        cb_ModifyEmployee.getItems().addAll(Employee.GetEmployeeList());
    }

    @FXML
    public void populateModifyDetails(ActionEvent e) throws IOException {
        System.out.println("Executing modify populate");
        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);
            CallableStatement call;

            String employeeName = cb_ModifyEmployee.getValue();
            String employeeFName = employeeName.split(", ")[1];
            String employeeLName = employeeName.split(", ")[0];

            int employeeID = getManagerId(employeeFName, employeeLName);

            String sqlQuery = "SELECT * FROM HR_EMPLOYEES WHERE EMPLOYEE_ID = " + employeeID;

            Statement st =connection.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                String firstName = rs.getString("FIRST_NAME");
                String lastName = rs.getString("LAST_NAME");
                String email = rs.getString("EMAIL");
                String phone = rs.getString("PHONE_NUMBER");
                Date hireDate = rs.getDate("HIRE_DATE");
                String jobId = rs.getString("JOB_ID");
                int salary = rs.getInt("SALARY");
                int commission = rs.getInt("COMMISSION_PCT");
                int managerId = rs.getInt("MANAGER_ID");
                int deptId = rs.getInt("DEPARTMENT_ID");
                String query = "";

                String managerName = "";
                String jobTitle = "";
                String departmentName = "";

                query = "{ ? = call GET_MANAGER_NAME_FROM_ID( " + managerId + ") }";
                try {
                    call = connection.prepareCall(query);
                    call.registerOutParameter(1,Types.VARCHAR);
                    call.execute();

                    managerName = call.getString(1);
                } catch (Exception manager) {
                    System.out.println("Manager error");
                }

                query = "{ ? = call GET_DEPARTMENT_NAME_FROM_ID( '" + deptId + "') }";
                try {
                    call = connection.prepareCall(query);
                    call.registerOutParameter(1,Types.VARCHAR);
                    call.execute();

                    departmentName = call.getString(1);

                } catch (Exception job) {
                    System.out.println("Department Error");
                    job.printStackTrace();
                    System.out.println(query);
                }

                query = "{ ? = call GET_JOB( '" + jobId + "') }";
                try {
                    call = connection.prepareCall(query);
                    call.registerOutParameter(1,Types.VARCHAR);
                    call.execute();

                    jobTitle = call.getString(1);

                } catch (Exception department) {
                    System.out.println("dept issue");
                    System.out.println(query);

                }

                firstNameUpdate.setText(firstName);
                lastNameUpdate.setText(lastName);
                emailUpdate.setText(email);
                phoneUpdate.setText(phone);
                hireDateUpdate.setText(String.valueOf(hireDate));
                salaryUpdate.setText(String.valueOf(salary));
                commUpdate.setText(String.valueOf(commission));

                jobIdUpdate.setText(jobTitle);
                managerIdUpdate.setText(managerName);
                deptIdUpdate.setText(departmentName);

            }

            rs.close();
            st.close();
            connection.close();

        } catch (Exception err) {
            System.out.println("Exception Found!");
            err.printStackTrace();
        }
    }

    @FXML
    public void updateEmployee(ActionEvent e) throws IOException {

        String phone = phoneUpdate.getText();
        int salary = Integer.parseInt(salaryUpdate.getText());
        String email = emailUpdate.getText();

        String employeeName = cb_ModifyEmployee.getValue();
        String employeeFName = employeeName.split(", ")[1];
        String employeeLName = employeeName.split(", ")[0];

        int employeeID = getManagerId(employeeFName, employeeLName);


        String sqlQuery = "{CALL EMPLOYEE_UPDATE(" +
                        "'" + employeeID + "', " +
                        "'" + email + "', " +
                        "" + salary + ", " +
                        "'" + phone + "')}";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.execute();

            connection.close();

            setMessageUpdate(employeeName, "SUCCESS");

        } catch (Exception err) {
            System.out.println("Exception Found!");
            setMessageUpdate(employeeName, "FAILURE");
            System.out.println(sqlQuery);
            err.printStackTrace();
        }
    }
    @FXML
    public void mainMenu(ActionEvent e) throws IOException {
        root = FXMLLoader.load(getClass().getResource("mainMenu-view.fxml"));
        stage = (Stage) ((Node) e.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    public void setMessageUpdate(String employeeName, String message) {
        successMessage.setVisible(true);
        successMessage.setText("Update employee: " + employeeName + " ~~~ Status: " + message);

    }
}
