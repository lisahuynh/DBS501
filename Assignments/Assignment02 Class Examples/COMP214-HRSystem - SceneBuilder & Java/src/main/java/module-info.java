module com.example.comp214hrapp {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;


    opens comp214.HRApplication to javafx.fxml;
    exports comp214.HRApplication;
}