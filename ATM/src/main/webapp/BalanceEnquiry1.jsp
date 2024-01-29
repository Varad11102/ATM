<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Balance Enquiry</title>
    <style>
   body {
    font-family: Arial, sans-serif;
    background-color: linear-gradient(to bottom, #fff, #9F9B90); 
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
}
   
    #content {
        text-align: center;
    }
    h2 {
        color: #333;
    }
    .success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
        padding: 10px;
        margin-bottom: 10px;
    }
    .error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
        padding: 10px;
        margin-bottom: 10px;
    }
    #exitButton {
        background-color: #dc3545;
        color: white;
        border: none;
        padding: 10px 20px;
        cursor: pointer;
        border-radius: 5px;
        margin-top: 20px;
    }
    #exitButton:hover {
        background-color: #c82333;
    }
</style>
</head>
<body>
    <div id="content">
        <h2>Balance Enquiry</h2>

        <%
            Cookie[] cookies = request.getCookies();
            String accountNumber = null;
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "password");

                if (cookies != null) {
                    for (Cookie cookie : cookies) {
                        if (cookie.getName().equals("accountNumber")) {
                            accountNumber = cookie.getValue();
                            break;
                        }
                    }
                }

                if (accountNumber != null) {
                    // Retrieve balance for the account number
                    ps = con.prepareStatement("SELECT BALANCE FROM ACCOUNT WHERE ACCOUNT_NUMBER=?");
                    ps.setString(1, accountNumber);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        double balance = rs.getDouble("BALANCE");
        %>
                        <div class="success">Balance for Account Number <%= accountNumber %>: <%= balance %></div>
        <%
                    } else {
        %>
                        <div class="error">Failed to retrieve balance.</div>
        <%
                    }
                } else {
        %>
                    <div class="error">Account number not found in cookies.</div>
        <%
                }
            } catch (ClassNotFoundException | SQLException e) {
        %>
                <div class="error">Database error occurred: <%= e.getMessage() %>. Please try again later.</div>
        <%
            } finally {
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
        <button id="exitButton">Exit</button>
    </div>

    <script>
        setTimeout(function() {
            window.location.href = "home.html";
        }, 10000);
        document.getElementById("exitButton").addEventListener("click", function() {
            window.location.href = "home.html";
        });
    </script>
</body>
</html>
