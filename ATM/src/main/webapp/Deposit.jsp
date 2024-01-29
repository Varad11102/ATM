<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Deposit Cash</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-image: url('background1.jpg');
            background-color: #f4f4f4;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
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
        h2 {
            text-align: center;
            margin-top: 30px;
            color: #333;
        }

        form {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin:150px 20px;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        label {
            font-size: 32px;
            margin-bottom: 10px;
            color: #333;
        }

        input[type="number"] {
            padding: 8px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
            width: 200px;
            margin-top:20px;
            margin-bottom: 20px;
        }

        button[type="submit"] {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff;
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #0056b3;
        }

        p {
            text-align: center;
            margin-top: 20px;
            font-size: 18px;
            color: #333;
        }
                   .exit-button {
            padding: 10px 40px;
            font-size: 16px;
            background-color: #dc3545; /* Red color */
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
    <script>
        function validateDeposit() {
            var depositAmount = document.getElementById("depositAmount").value;
            if (depositAmount < 10 || depositAmount > 100) {
                alert("Deposit amount must be between 10 and 100.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    
    <div class="header">
        <div class="logo">
            <img src="Component.png" alt="Sun Bank Logo">
            <div class="bank-name">Sun Bank</div>
        </div>
        <div class="dateTime" id="dateTime"></div>
    </div>
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
                String action = request.getParameter("action");
                double depositAmount = 0;
                if (action != null && action.equals("deposit")) {
                    depositAmount = Double.parseDouble(request.getParameter("depositAmount"));
                }
    %>
                <form method="post" action="" onsubmit="return validateDeposit()">
                    <label for="depositAmount">Deposit Amount:</label>
                    <input type="number" id="depositAmount" name="depositAmount" step="0.01" min="10" max="100" required><br>
                    <input type="hidden" name="action" value="deposit">
                    <button type="submit">Deposit</button>
                    <button onclick="window.location.href='home.html'" class="exit-button">Exit</button>
                </form>
    <%
                if (action != null && action.equals("deposit")) {
                    if (depositAmount > 0) {
                        con.setAutoCommit(false);
                        String selectSQL = "SELECT BALANCE FROM ACCOUNT WHERE ACCOUNT_NUMBER=?";
                        ps = con.prepareStatement(selectSQL);
                        ps.setString(1, accountNumber);
                        rs = ps.executeQuery();
                        
                        double currentBalance = 0;
                        if (rs.next()) {
                            currentBalance = rs.getDouble("BALANCE");
                        }                        

                        double updatedBalance = currentBalance + depositAmount;                                                    
                        String updateSQL = "UPDATE ACCOUNT SET BALANCE=? WHERE ACCOUNT_NUMBER=?";
                        ps = con.prepareStatement(updateSQL);
                        ps.setDouble(1, updatedBalance);
                        ps.setString(2, accountNumber);
                        ps.executeUpdate();                                                      
                        con.commit();
    %>
                            <p>Deposit successful. Updated balance = <%= updatedBalance %></p>
    <%
                    } else {
    %>
                        <p>Invalid deposit amount.</p>
    <%
                    }
                }
            } else {
    %>
                <p>Invalid account.</p>
    <%
            }
        } catch (Exception e) {
            e.printStackTrace();

            try {
                if (con != null) {
                    con.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
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
