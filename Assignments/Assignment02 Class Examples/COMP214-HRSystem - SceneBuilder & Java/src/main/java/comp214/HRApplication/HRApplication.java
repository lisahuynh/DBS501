package comp214.HRApplication;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;
import java.sql.*;

public class HRApplication extends Application {
    @Override
    public void start(Stage stage) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(HRApplication.class.getResource("mainMenu-view.fxml"));
        Scene scene = new Scene(fxmlLoader.load(), 320, 240);
        stage.setTitle("Hello!");
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {

        // Test Connection

        try{
            System.out.println(">> Starting Program!");

            Class.forName(JDBC.DRIVER);
            System.out.println(">> Driver Loaded Successfully!");

            Connection connection = DriverManager.getConnection(JDBC.DATABASE_URL,JDBC.USERNAME, JDBC.PASSWORD);
            System.out.println(">> Database Connected Successfully!");

            connection.close();


        }catch (Exception e){
            System.out.println("Exception Found!");
            e.printStackTrace();
        }

        launch(args);
    }
}