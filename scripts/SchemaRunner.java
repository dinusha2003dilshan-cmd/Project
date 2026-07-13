import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.stream.Collectors;

public class SchemaRunner {
    public static void main(String[] args) {
        if (args.length != 3) {
            System.err.println("Usage: java SchemaRunner <schema-file> <jdbc-url> <db-user>");
            System.err.println("Password is read from environment variable DB_PASSWORD");
            System.exit(1);
        }

        Path schemaPath = Path.of(args[0]);
        String jdbcUrl = args[1];
        String user = args[2];
        String password = System.getenv("DB_PASSWORD");
        if (password == null) {
            password = "";
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC driver not found: " + e.getMessage());
            System.exit(2);
        }

        try (Connection conn = DriverManager.getConnection(jdbcUrl, user, password);
             Statement stmt = conn.createStatement()) {
            String sql = Files.lines(schemaPath)
                    .collect(Collectors.joining("\n"));
            for (String statement : sql.split(";\\s*(?=\\n|$)")) {
                String trimmed = statement.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("--")) {
                    continue;
                }
                stmt.execute(trimmed);
            }
            System.out.println("Schema executed successfully.");
        } catch (SQLException | IOException e) {
            System.err.println("Error executing schema: " + e.getMessage());
            e.printStackTrace(System.err);
            System.exit(3);
        }
    }
}
