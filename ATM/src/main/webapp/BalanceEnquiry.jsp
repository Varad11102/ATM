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
            background: linear-gradient(to bottom, #333, #000); /* Dark gradient */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        

        form {
            background-color: #625834;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            width: 300px;
            margin-top: 0px;
        }

        label {
            display: block;
            margin-bottom: 10px;
            color: #fff;
        }

        input[type="password"] {
            width: calc(100% - 22px);
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-bottom: 20px;
            transition: border-color 0.3s ease;
        }

        input[type="password"]:focus {
            border-color: #007bff;
        }

        button[type="submit"] {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }

        .error {
            color: #dc3545;
            margin-bottom: 10px;
            text-align: center;
        }

        .header {
        background-color:#30362F;
            display: block;
            position:absolute;
            top:0px;
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
           
        }

        .logo img {
            width: 110px;
            height: 61px;
            display: block;
        }
		h2{
			color:#fff;
			margin-bottom:0px;
		}
        .bank-name {
            font-size: 24px;
            color: #333;
            margin-left: 10px;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            padding: 10px;
            box-sizing: border-box;
            background-color: rgba(255, 255, 255, 0.9);
        }

        .logo img {
            width: 110px;
            height: 61px;
            display: block;
        }

        .bank-name {
            font-size: 24px;
            color: #333;
            margin-left: 10px;
        }

        .dateTime {
            font-size: 18px;
            color: #333;
        }
        .hi{
        display:flex;
        flex-direction:column;
        }
                   .exit-button {
            padding: 10px 40px;
            font-size: 16px;
            background-color: #dc3545; 
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 20px;
        }      
        button.exit-button:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo">
            <img src="Component.png" alt="Sun Bank Logo">
            <div class="bank-name" style="color:#FFFBDB;">Sun Bank</div>
        </div>
        <div class="dateTime" id="dateTime"></div>
    </div>
<div class="hi">
    <h2>Balance Enquiry:</h2>

    <form method="post" action="">
        <label for="pin">PIN:</label>
        <input type="password" id="pin" name="pin" required>
        <button type="submit">Check Balance</button>
<button onclick="window.location.href='home.html'" class="exit-button">Exit</button>
    </form>
</div>
    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String pin = request.getParameter("pin");
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
                    ps = con.prepareStatement("SELECT PIN_NUMBER FROM ACCOUNT WHERE ACCOUNT_NUMBER=?");
                    ps.setString(1, accountNumber);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String storedPIN = rs.getString("PIN_NUMBER");
                        if (pin.equals(storedPIN)) {
                          
                            response.sendRedirect("BalanceEnquiry1.jsp");
                            return; 
                        } else {
    %>
                            <div class="error">Incorrect PIN.</div>
    <%
                        }
                    } else {
    %>
                        <div class="error">Account not found.</div>
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
        }
    %>
    <script>
        setTimeout(function() {
            window.location.href = "home.html";
        }, 60000); 
        function add()
        {
        	window.location.href="home.html";
        }
        function updateDateTime() {
            const now = new Date();
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: true };
            document.getElementById('dateTime').textContent = now.toLocaleString('en-US', options);
        }

        updateDateTime(); 
        setInterval(updateDateTime, 1000);
    </script>
</body>
</html>
