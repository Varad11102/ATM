<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Withdraw Cash</title>
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
        @keyframes slide {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(0); }
        }

        .withdrawing {
            display: none; 
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: #fff;
            color: #fff;
            text-align: center;
            padding: 10px;
            animation: slide 2s ease-in-out infinite alternate;
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
    function validateWithdrawal() {
        var withdrawalAmount = document.getElementById("withdrawalAmount").value;
        if (withdrawalAmount < 10 || withdrawalAmount > 200) {
            alert("Withdrawal amount must be between 10 and 200.");
            return false;
        }
        
        document.querySelector('.withdrawing').style.display = 'block';
        return true;
    }

    
    function redirectAfterDelay() {
        setTimeout(function() {
            window.location.href = "home.html"; 
        }, 60000); 
    }
    function updateDateTime() {
        const now = new Date();
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric', hour: 'numeric', minute: 'numeric', second: 'numeric', hour12: true };
        document.getElementById('dateTime').textContent = now.toLocaleString('en-US', options);
    }

    updateDateTime(); 
    setInterval(updateDateTime, 1000);
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
                double withdrawalAmount = 0;
                if (action != null && action.equals("withdraw")) {
                    withdrawalAmount = Double.parseDouble(request.getParameter("withdrawalAmount"));
                }
    %>
                <form method="post" action="" onsubmit="return validateWithdrawal()">
                    <label for="withdrawalAmount">Withdrawal Amount:</label>
                    <input type="number" id="withdrawalAmount" name="withdrawalAmount" step="0.01" min="10" max="200" required><br>
                    <input type="hidden" name="action" value="withdraw">
                    <button type="submit">Withdraw</button>
                    <button onclick="window.location.href='home.html'" class="exit-button">Exit</button>
                </form>
                <div class="withdrawing">Withdrawing...</div>
                    
    <%
                if (action != null && action.equals("withdraw")) {
                    if (withdrawalAmount > 0) {
                        con.setAutoCommit(false);
                        String selectSQL = "SELECT BALANCE FROM ACCOUNT WHERE ACCOUNT_NUMBER=?";
                        ps = con.prepareStatement(selectSQL);
                        ps.setString(1, accountNumber);
                        rs = ps.executeQuery();
                        
                        double currentBalance = 0;
                        if (rs.next()) {
                            currentBalance = rs.getDouble("BALANCE");
                        }                        

                        if (currentBalance >= withdrawalAmount) {
                            double updatedBalance = currentBalance - withdrawalAmount;                                                    
                            String updateSQL = "UPDATE ACCOUNT SET BALANCE=? WHERE ACCOUNT_NUMBER=?";
                            ps = con.prepareStatement(updateSQL);
                            ps.setDouble(1, updatedBalance);
                            ps.setString(2, accountNumber);
                            ps.executeUpdate();                                                      
                            con.commit();
    %>
                            <p>Withdrawal successful. Updated balance = <%= updatedBalance %></p>
    <%
                        } else {
    %>
                            <p>Insufficient balance.</p>
    <%
                        }
                    } else {
    %>
                        <p>Invalid withdrawal amount.</p>
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
</body>
</html>
