import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@SuppressWarnings("serial")
public class AccountName extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String s1 = request.getParameter("accountNumber");

        try {
            PrintWriter out = response.getWriter();
            response.setContentType("text/html");
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "password");
            out.print("working");
            String sql = "SELECT pin_number FROM account WHERE account_number=?";
            PreparedStatement pst = con.prepareStatement(sql);
            pst.setInt(1, Integer.parseInt(s1));
            ResultSet rs = pst.executeQuery();
            out.print("working1");

            if (rs.next()) {
                int pinNumber = rs.getInt("pin_number");
                out.println("Pin Number: " + pinNumber);
                Cookie myCookie = new Cookie("pin", Integer.toString(pinNumber));
                response.addCookie(myCookie);
                
                Cookie myCookie1 = new Cookie("ACNO",s1);
                response.addCookie(myCookie1); 
                response.sendRedirect("pin.html");
            } else {
                
                response.sendRedirect("home.html");
            }

            rs.close();
            pst.close();
            con.close();
        } catch (ClassNotFoundException | SQLException e) {
            response.sendRedirect("home.html");
            e.printStackTrace();
        }
    }
}