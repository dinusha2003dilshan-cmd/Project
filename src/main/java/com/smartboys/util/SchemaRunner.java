package com.smartboys.util;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class SchemaRunner {

    public static void main(String[] args) {
        if (args.length < 3 || args.length > 4) {
            System.err.println("Usage: java com.smartboys.util.SchemaRunner <schema-file> <jdbc-url> <db-user> [db-password]");
            System.exit(1);
        }

        Path schemaFile = Path.of(args[0]);
        String jdbcUrl = args[1];
        String dbUser = args[2];
        String dbPassword = args.length == 4 ? args[3] : "";

        try {
            executeSchema(schemaFile, jdbcUrl, dbUser, dbPassword);
            System.out.println("Schema executed successfully.");
        } catch (Exception e) {
            System.err.println("Failed to execute schema: " + e.getMessage());
            e.printStackTrace(System.err);
            System.exit(2);
        }
    }

    private static void executeSchema(Path schemaFile, String jdbcUrl, String user, String password) throws IOException, SQLException {
        String sql = Files.readString(schemaFile);
        try (Connection connection = DriverManager.getConnection(jdbcUrl, user, password);
             Statement statement = connection.createStatement()) {
            for (String stmt : splitSqlStatements(sql)) {
                String trimmed = stmt.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("--") || trimmed.startsWith("#")) {
                    continue;
                }
                statement.execute(trimmed);
            }
        }
    }

    private static List<String> splitSqlStatements(String sql) {
        List<String> statements = new ArrayList<>();
        StringBuilder current = new StringBuilder();
        boolean inSingleQuote = false;
        boolean inDoubleQuote = false;

        for (int i = 0; i < sql.length(); i++) {
            char c = sql.charAt(i);
            if (c == '\'') {
                inSingleQuote = !inSingleQuote && !inDoubleQuote;
            } else if (c == '"') {
                inDoubleQuote = !inDoubleQuote && !inSingleQuote;
            }

            if (c == ';' && !inSingleQuote && !inDoubleQuote) {
                statements.add(current.toString());
                current.setLength(0);
            } else {
                current.append(c);
            }
        }

        if (current.length() > 0) {
            statements.add(current.toString());
        }

        return statements;
    }
}
