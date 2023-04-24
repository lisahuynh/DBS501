package comp214.HRApplication;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.net.URL;
import java.sql.*;
import java.util.ArrayList;
import java.util.ResourceBundle;

public class DepartmentController implements Initializable {

    private Stage stage;
    private Scene scene;
    private Parent root;

    @FXML
    ChoiceBox<String> departmentModifyCB, departmentModifyManagerCB, departmentModifyLocationCB, departmentCreateManagerCB, departmentCreateLocationCB;

    @Override
    public void initialize(URL url, ResourceBundle resourceBundle) {

        ArrayList<String> managerList = GetManagerList();
        ArrayList<String> locationList = GetLocationList();

        departmentModifyCB.getItems().addAll(GetDepartmentList());
        departmentModifyManagerCB.getItems().addAll(managerList);
        departmentCreateManagerCB.getItems().addAll(managerList);
        departmentModifyLocationCB.getItems().addAll(locationList);
        departmentCreateLocationCB.getItems().addAll(locationList);


    }

    @FXML
    TextField modifyDeptName, createDeptName;

    @FXML
    Label statusField;


    @FXML
    public void mainMenu(ActionEvent e) throws IOException {
        root = FXMLLoader.load(getClass().getResource("mainMenu-view.fxml"));
        stage = (Stage) ((Node) e.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }

    @FXML
    protected void populateDepartmentDetails() {

        String detailQuery = "{ ? = call DEPARTMENT_DETAILS( '" + departmentModifyCB.getValue() + "') }";

        String managerID = " ";
        String locationID = " ";
        String rValue = " ";

        try {
            CallableStatement call;
            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            try {

            call = connection.prepareCall(detailQuery);
            call.registerOutParameter(1,Types.VARCHAR);
            call.execute();
            rValue = (call.getString(1));
            managerID = rValue.split("-")[0];
            locationID = rValue.split("-")[1];

            System.out.println("first call"); }
            catch (Exception lookup) {
                System.out.println("lookup exception");
            }

            String managerQuery = "{ ? = call GET_MANAGER_NAME_FROM_ID( '" + managerID + "') }";
            String locationQuery = "{ ? = call GET_LOCATION_NAME_FROM_ID( '" + locationID + "') }";


            try {
                System.out.println("second call");
                call = connection.prepareCall(managerQuery);
                call.registerOutParameter(1, Types.VARCHAR);
                call.execute();
                rValue = call.getString(1);
                departmentModifyManagerCB.setValue(rValue);
            } catch (Exception man){
                System.out.println("man error");
                departmentModifyManagerCB.setValue(null);

            }

            try {
                System.out.println("third call");

                call = connection.prepareCall(locationQuery);
                call.registerOutParameter(1, Types.VARCHAR);
                call.execute();
                rValue = call.getString(1);
                departmentModifyLocationCB.setValue(rValue);
            } catch (Exception loc) {
                System.out.println("loc error");
                departmentModifyLocationCB.setValue(null);
            }

            modifyDeptName.setText(departmentModifyCB.getValue());

            connection.close();

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

    }

    @FXML
    protected void submitModifyDepartment() {
        System.out.println("Process modify department");

        String newDeptName = modifyDeptName.getText();
        String newManager = departmentModifyManagerCB.getValue();
        String newManagerLname = newManager.split(", ")[0];
        String newManagerFname = newManager.split(", ")[1];
        String newLocation = departmentModifyLocationCB.getValue();
        String newLocationStreet = newLocation.split("; ")[0];
        String newLocationCity = newLocation.split("; ")[1];

        String sqlQuery = "{CALL MODIFY_DEPARTMENT(" +
                "'" + newDeptName + "', " +
                "'" + newManagerFname + "', " +
                "'" + newManagerLname + "', " +
                "'" + newLocationStreet + "', " +
                "'" + newLocationCity + "')}";

        System.out.println(sqlQuery);
        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);

            call.execute();

            connection.close();

            statusMessage("Modify department: SUCCESS");

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
            statusMessage("Modify department: FAILURE");

        }

    }

    @FXML
    protected void submitCreateDepartment() {

        System.out.println("Process create department");
        String newDeptName = createDeptName.getText();

        try {
            String newManager = departmentCreateManagerCB.getValue();
            String newManagerLname = newManager.split(", ")[0];
            String newManagerFname = newManager.split(", ")[1];
            String newLocation = departmentCreateLocationCB.getValue();
            String newLocationStreet = newLocation.split("; ")[0];
            String newLocationCity = newLocation.split("; ")[1];

            String sqlQuery = "{CALL ADD_NEW_DEPT(" +
                    "'" + newDeptName + "', " +
                    "'" + newManagerFname + "', " +
                    "'" + newManagerLname + "', " +
                    "'" + newLocationStreet + "', " +
                    "'" + newLocationCity + "')}";

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);

            call.execute();

            connection.close();
            statusMessage("Create department: SUCCESS");


        } catch (Exception e) {
            //System.out.println("Exception Found!");
            e.printStackTrace();
            statusMessage("Create department: FAILURE");

        }

    }

    @FXML
    protected void statusMessage(String message) {
        statusField.setVisible(true);

        statusField.setText(message);

    }

    public ArrayList<String> GetDepartmentList() {
        // This function returns an array list populated by the possible departments that an individual may join
        // per the HR_DEPARTMENTS table

        ArrayList<String> departmentsList = new ArrayList<>();
        String sqlQuery = "SELECT DEPARTMENT_NAME FROM HR_DEPARTMENTS ORDER BY DEPARTMENT_ID ASC";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            Statement st = connection.createStatement();
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

    public ArrayList<String> GetManagerList() {
        // This function returns an array list populated by the possible employees that can manage a department
        // per the HR_EMPLOYEES table

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

    public ArrayList<String> GetLocationList() {
        // This function returns an array list populated by the possible department locations
        // per the HR_LOCATIONS table

        ArrayList<String> locationList = new ArrayList<>();
        String sqlQuery = "SELECT STREET_ADDRESS || '; ' || CITY FROM HR_LOCATIONS ORDER BY LOCATION_ID ASC";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            Statement st = connection.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                locationList.add(rs.getString(1));
            }

            rs.close();
            st.close();
            connection.close();

        } catch (Exception e) {
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        return locationList;
    }



}