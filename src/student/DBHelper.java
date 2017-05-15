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

    public long insert(String command) {
        Statement stmt = null;
        try {
            System.out.println("INFO: Executing insert: " + command);

            stmt = conn.createStatement();
            int affectedRows = stmt.executeUpdate(command, Statement.RETURN_GENERATED_KEYS);
            if (affectedRows == 0){
                System.out.println("ERROR: insert failed!");
                return -1;
            }

            SQLServerResultSet generatedKeys = (SQLServerResultSet)stmt.getGeneratedKeys();
            generatedKeys.next();
            return generatedKeys.getLong(1);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean delete(String command) {
        Statement stmt = null;

        try {
            System.out.println("INFO: Executing delete: " + command);

            stmt = conn.createStatement();
            return stmt.execute(command);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }


    public long insert(String tableName, String[] columnNames, String[] values) {

        StringBuilder command = new StringBuilder();

        command.append("INSERT INTO ");
        command.append("[" + tableName + "]");
        command.append("(");
        for (String column : columnNames) {
            command.append(column + ",");
        }
        command.setLength(command.length() - 1);
        command.append(")");
        command.append(" values (");
        for (String value : values) {
            command.append("'" + value + "',");
        }
        command.setLength(command.length() - 1);
        command.append(");");

        return insert(command.toString());
    }


    public boolean delete(String tableName, String[] columnNames, String[] values) {
        StringBuilder command = new StringBuilder();

        command.append("DELETE FROM ");
        command.append("[" + tableName + "]");
        command.append(" WHERE ");
        for (int i = 0 ; i < columnNames.length ; i ++) {
            if (i != 0) {
                command.append(" AND ");
            }
            command.append(columnNames[i]);
            command.append("=");
            command.append(values[i]);
        }
        command.append(";");

        return delete(command.toString());
    }

}
