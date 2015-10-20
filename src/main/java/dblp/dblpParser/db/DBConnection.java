package dblp.dblpParser.db;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

	// Change the parameters accordingly.
	private static String dbUrl = "jdbc:mysql://phoenix15:3306/dataset?useUnicode=true&characterEncoding=utf-8";
	private static String user = "root";
	private static String password = "passwd";

	public static Connection getConn() {
		try {
			Class.forName("org.gjt.mm.mysql.Driver");
			return DriverManager.getConnection(dbUrl, user, password);
		} catch (Exception e) {
			System.out
					.println("Error while opening a conneciton to database server: "
							+ e.getMessage());
			return null;
		}
	}

}
