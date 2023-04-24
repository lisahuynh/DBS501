package comp214.HRApplication;

import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.scene.control.ChoiceBox;
import javafx.scene.control.TextField;
import javafx.stage.Stage;

import java.io.IOException;
import java.lang.reflect.Type;
import java.net.URL;
import java.sql.*;
import java.util.ArrayList;
import java.util.ResourceBundle;

public class JobController implements Initializable {

    private Stage stage;
    private Scene scene;
    private Parent root;

    @FXML
    TextField lookupJobID, lookupJobTitle, modifyJobTitle, modifyJobMinSal, modifyJobMaxSal, createJobTitle, createJobID, createJobMinSal, createJobMaxSal;

    @FXML
    ChoiceBox<String> cb_ModifyJobID;
    @Override
    public void initialize(URL arg0, ResourceBundle arg1) {

        cb_ModifyJobID.getItems().addAll(GetJobIDList());


    }
    public ArrayList<String> GetJobIDList() {
        // This function returns an array list populated by the possible jobs IDs that an individual may hold
        // per the HR_JOBS table

        ArrayList<String> jobsList = new ArrayList<>();
        String sqlQuery = "SELECT JOB_ID FROM HR_JOBS";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            Statement st =connection.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                jobsList.add(rs.getString("JOB_ID"));
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

    @FXML
    public void LookupJobTitle(ActionEvent e) throws IOException {

        String sqlQuery = " { ? = call GET_JOB( '" + lookupJobID.getText() + "' ) }";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.registerOutParameter(1,Types.VARCHAR);
            call.execute();

            lookupJobTitle.setText(call.getString(1));

            call.close();
            connection.close();

        } catch (Exception err) {
            System.out.println("Exception Found!");
            err.printStackTrace();
        }
    }

    @FXML
    public void ModifyPopulateDetails(ActionEvent e) throws IOException {
        System.out.println("Executing modify populate");
        String sqlQuery = "SELECT * FROM HR_JOBS WHERE JOB_ID = '" + cb_ModifyJobID.getValue() + "'";

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            Statement st =connection.createStatement();
            ResultSet rs = st.executeQuery(sqlQuery);

            while (rs.next()) {
                String jobTitle = rs.getString("JOB_TITLE");
                String jobMinSal = rs.getString("MIN_SALARY");
                String jobMaxSal = rs.getString("MAX_SALARY");

                modifyJobTitle.setText(jobTitle);
                modifyJobMinSal.setText(jobMinSal);
                modifyJobMaxSal.setText(jobMaxSal);
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
    public void ModifySubmit(ActionEvent e) throws IOException {
        System.out.println("Executing modify submit");

        String jobTitle = modifyJobTitle.getText();
        String jobMinSal = modifyJobMinSal.getText();
        String jobMaxSal = modifyJobMaxSal.getText();

        String sqlQuery = "{CALL UPD_JOB (  " +
                "'" + cb_ModifyJobID.getValue() + "' ," +
                "'" + jobTitle + "' ," +
                " " + jobMinSal + " ," +
                " " + jobMaxSal + " )}" ;

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.execute();
            call.close();
            connection.close();

        } catch (Exception err) {
            System.out.println("Exception Found!");
            err.printStackTrace();
        }
    }

    @FXML
    public void CreateSubmit(ActionEvent e) throws IOException {
        System.out.println("Executing create submit");

        String jobID = createJobID.getText();
        String jobTitle = createJobTitle.getText();
        String jobMinSal = createJobMinSal.getText();
        String jobMaxSal = createJobMaxSal.getText();

        String sqlQuery = "{CALL ADD_JOB( " +
                "'" + jobID + "', " +
                "'" + jobTitle + "', " +
                " " + jobMinSal + ", " +
                " " + jobMaxSal + " ) }" ;

        try {

            Class.forName(JDBC.DRIVER);
            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL, JDBC.USERNAME, JDBC.PASSWORD);

            CallableStatement call = connection.prepareCall(sqlQuery);
            call.execute();
            call.close();

            connection.close();

        } catch (Exception err) {
            System.out.println("Exception Found!");
            err.printStackTrace();
        }

        cb_ModifyJobID.getItems().addAll(GetJobIDList());

    }
    @FXML
    public void mainMenu(ActionEvent e) throws IOException {
        root = FXMLLoader.load(getClass().getResource("mainMenu-view.fxml"));
        stage = (Stage) ((Node) e.getSource()).getScene().getWindow();
        scene = new Scene(root);
        stage.setScene(scene);
        stage.show();
    }
}