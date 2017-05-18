package student;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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


    public List<List<String>> select(String command, int numColumns) {
        Statement stmt = null;

        try {
            System.out.println("INFO: Executing select: " + command);

            stmt = conn.createStatement();

            ResultSet rs = stmt.executeQuery(command);

            List<List<String>> arrayList = new ArrayList<>();

            while(rs.next()) {

                List<String> arrayString = new ArrayList<>();

                for(int i = 0 ; i < numColumns; i++) {
                    arrayString.add(rs.getString(i));
                }

                arrayList.add(arrayString);
            }

            return arrayList;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public long update(String command) {
        Statement stmt = null;
        try {
            System.out.println("INFO: Executing update: " + command);

            stmt = conn.createStatement();
            int affectedRows = stmt.executeUpdate(command, Statement.RETURN_GENERATED_KEYS);
            if (affectedRows == 0){
                System.out.println("ERROR: update failed!");
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

    public int insert(String tableName, String[] columnNames, String[] values) {

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

        return (int)insert(command.toString());
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

    public int update(String tableName, String[] columnNames, String[] values, String[] projection, String[] projectionvalues) {

        StringBuilder command = new StringBuilder();

        command.append("UPDATE ");
        command.append("[" + tableName + "]");
        command.append(" SET ");
        for (int i = 0; i < columnNames.length; i ++) {
            command.append(columnNames[i] + " = " + values[i] + ",");
        }
        command.setLength(command.length() - 1);
        if (projection.length > 0) {
            command.append(" WHERE ");
            for (int i = 0 ; i < projection.length; i ++) {
                if (i != 0) {
                    command.append(" AND ");
                }
                command.append(projection[i] + " = " + projectionvalues[i] );
            }
        }
        command.append(");");

        return (int)update(command.toString());
    }

    public List<List<String>> select(String tableName, String[] columnNames, String[] projection, String[] values) {
        StringBuilder command = new StringBuilder();

        command.append("SELECT FROM ");
        command.append("[" + tableName + "]");

        command.append(" (");
        for (String column : columnNames) {
            command.append(column + ",");
        }
        command.setLength(command.length() - 1);
        command.append(") ");

        if (projection.length > 0) {
            command.append(" WHERE ");
            for (int i = 0 ; i < projection.length; i ++) {
                if (i != 0) {
                    command.append(" AND ");
                }
                command.append(projection[i] + " = " + values[i] );
            }
        }

        return select(command.toString(), columnNames.length);

    }

    public boolean call(String functionName, String[] parameters){

        try {
            StringBuilder command = new StringBuilder();
            command.append("{call " + functionName + "(");
            for(int i = 0 ; i < parameters.length; i++) {
                command.append("?,");
            }
            command.setLength(command.length() - 1);
            command.append(")");

            CallableStatement stmt = conn.prepareCall(command.toString());

            for(int i = 0 ; i < parameters.length; i ++) {
                stmt.setString(i+1, parameters[i]);
            }

            stmt.execute();

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
