package student;

import java.sql.*;
import com.microsoft.sqlserver.jdbc.*;

/**
 * Created by rols on 5/14/2017.
 */
public class DBHelper {

    static final String connectionString =
            "jdbc:sqlserver://localhost;" +
            "databaseName=sab;" +
            "integratedSecurity=true;";

    Connection conn;

    public DBHelper() {
        conn = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(connectionString);

        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    public void insert(String command) {
        Statement stmt = null;
        try {
            stmt = conn.createStatement();
            stmt.execute(command);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void insert(String tableName, String[] columnNames, String[] values) {

        insert("insert into dbo.tiprobe (naziv) values('nesto');");

//        StringBuilder command = new StringBuilder();
//
//        command.append("INSERT INTO ");
//        command.append("[" + tableName + "]");
//        command.append("(");
//        for (String column : columnNames) {
//            command.append(column + ",");
//        }
//        command.setLength(command.length() - 1);
//        command.append(")");
//        command.append(" values (");
//        for (String value : values) {
//            command.append("'" + value + "',");
//        }
//        command.setLength(command.length() - 1);
//        command.append(");");
//
//        insert(command.toString());
    }

}
