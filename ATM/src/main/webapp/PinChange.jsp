<%@ page import="java.io.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Change PIN</title>
<style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #333; 
            color: #fff; 
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
        }

        h2 {
            text-align: center;
            margin-top: 0px;
        }

form {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: 20px;
    background-color: #f0f0f0; 
    padding:50px;
    border-radius:4em;
    
 
}


        label {
            font-size: 18px;
            margin-bottom: 10px;
        }

        input[type="password"] {
            padding: 8px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 200px;
            margin-bottom: 20px;
        }

        button[type="submit"], .exit {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-bottom: 10px;
        }

        button[type="submit"]:hover, button.exit:hover {
            background-color: #0056b3;
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 10px;
        }

        .success {
            color: green;
            text-align: center;
            margin-top: 10px;
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
                   .exit-button {
            padding: 10px 50px;
            font-size: 16px;
            background-color: #dc3545; /* Red color */
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 3px;
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
            <div class="bank-name">Sun Bank</div>
        </div>
        <div class="dateTime" id="dateTime"></div>
    </div>
    
    <form method="post" action="">
    	<h2>Change PIN</h2>
        <label for="currentPIN">Current PIN:</label>
        <input type="password" id="currentPIN" name="currentPIN" required><br>
        <label for="newPIN">New PIN (4 digits):</label>
        <input type="password" id="newPIN" name="newPIN" pattern="\d{4}" title="Please enter a 4-digit PIN." required><br>
        <label for="confirmPIN">Confirm New PIN:</label>
        <input type="password" id="confirmPIN" name="confirmPIN" pattern="\d{4}" title="Please enter a 4-digit PIN." required><br>
        <button type="submit">Change PIN</button>
         <button onclick="window.location.href='home.html'" class="exit-button">Exit</button>
    </form>
    <% 
        if (request.getMethod().equals("POST")) {
            Cookie[] cookies = request.getCookies();
            String accountNumber = null;

            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("accountNumber")) {
                        accountNumber = cookie.getValue();
                        break;
                    }
                }
            }

            if (accountNumber != null) {
                String currentPIN = request.getParameter("currentPIN");
                String newPIN = request.getParameter("newPIN");
                String confirmPIN = request.getParameter("confirmPIN");
                if (!newPIN.equals(confirmPIN)) {
    %>
                    <div class="error">New PIN and confirm PIN do not match.</div>
    <%
                } else {
                    try {
                        Connection con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "system", "password");
                        PreparedStatement ps = con.prepareStatement("SELECT PIN_NUMBER FROM ACCOUNT WHERE ACCOUNT_NUMBER=?");
                        ps.setString(1, accountNumber);
                        ResultSet rs = ps.executeQuery();
                        
                        if (rs.next()) {
                            String dbPIN = rs.getString("PIN_NUMBER");
                            if (dbPIN.equals(currentPIN)) {
                                PreparedStatement updatePs = con.prepareStatement("UPDATE ACCOUNT SET PIN_NUMBER=? WHERE ACCOUNT_NUMBER=?");
                                updatePs.setString(1, newPIN);
                                updatePs.setString(2, accountNumber);
                                updatePs.executeUpdate();                               
    %>
                                <div class="success">PIN changed successfully.</div>
    <%
                            } else {
    %>
                                <div class="error">Incorrect current PIN.</div>
    <%
                            }
                        } else {
    %>
                            <div class="error">User not found.</div>
    <%
                        }

                        rs.close();
                        ps.close();
                        con.close();
                    } catch (SQLException e) {
    %>
                        <div class="error">An error occurred. Please try again later.</div>
    <%
                    }
                }
            } else {                
    %>
                <div class="error">Invalid account.</div>
    <%
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
