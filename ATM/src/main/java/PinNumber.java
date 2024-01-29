import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@SuppressWarnings("serial")
@WebServlet("/PinVerify")
public class PinNumber extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        String storedPin = null;
        String storedAccountNumber = null;
        int enteredPin;

        PrintWriter out = response.getWriter();

        // Retrieve stored pin and account number from cookies
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("pin")) {
                    storedPin = cookie.getValue();
                } else if (cookie.getName().equals("ACNO")) {
                    storedAccountNumber = cookie.getValue();
                }

                // Break if both cookies are found
                if (storedPin != null && storedAccountNumber != null) {
                    break;
                }
            }
        }

        // Check if stored pin and account number are not null
        if (storedPin != null && storedAccountNumber != null) {
            int storedPinInt = Integer.parseInt(storedPin);
            int storedAccountNumberInt = Integer.parseInt(storedAccountNumber);

            
            try {
                enteredPin = Integer.parseInt(request.getParameter("pinNumber"));
            } catch (NumberFormatException e) {
                // Handle the case where the entered pin is not a valid integer
                out.println("<h2>Invalid pin format</h2>");
                return;
            }

            // Compare stored pin with entered pin
            if (storedPinInt == enteredPin) {
                out.println("<h1>Correct</h1>");
                Cookie accountCookie = new Cookie("accountNumber", String.valueOf(storedAccountNumberInt));
                response.addCookie(accountCookie);
                response.setHeader("Refresh", "1; URL=select.html");

                // Now you can use storedAccountNumberInt as needed
            } else {
                out.println("<h2>Wrong</h2>");
                // Redirect to index.html after 1 second
                response.setHeader("Refresh", "1; URL=index.html");
            }
        } else {
            out.println("<h2>Stored pin or account number not available</h2>");
        }
    }
}
