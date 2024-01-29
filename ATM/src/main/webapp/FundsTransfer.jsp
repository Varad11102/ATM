<%@ page import="java.io.*,java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Funds Transfer</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            color: #333;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"],
        input[type="password"],
        button {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 3px;
            box-sizing: border-box;
        }
        button {
            background-color: #007bff;
            color: #fff;
            border: none;
            cursor: pointer;
        }
        button:hover {
            background-color: #0056b3;
        }
        .message {
            margin-top: 15px;
        }
        .lol{
        	tex-decoration:none;
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
            padding: 10px 40px;
            font-size: 16px;
            background-color: #dc3545; /* Red color */
            color: #fff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-top: 0px;
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
    <div class="container">
        <h2>Funds Transfer</h2>
        <form method="post" action="">
            <label for="receiverAccount">Receiver's Account Holder Name:</label>
            <input type="text" id="receiverAccount" name="receiverAccount" required>
            <label for="amount">Amount:</label>
            <input type="text" id="amount" name="amount" required>
            <label for="pin">PIN:</label>
            <input type="password" id="pin" name="Senderpin" required>
            <button type="submit" style="font-size: 16px;">Transfer Funds</button>
            <button onclick="window.location.href='home.html'" class="exit-button">Exit</button>
        </form>
        <div class="message">
        </div>
    </div>
<%
String senderAccount = null;
String senderName = null;
Cookie[] cookies = request.getCookies();
if (cookies != null) {
    for (Cookie cookie : cookies) {
        if (cookie.getName().equals("accountNumber")) {
            senderAccount = cookie.getValue();
            break;
        }
    }
}

if (senderAccount != null) {
    if (request.getMethod().equals("POST")) {
        String receiverAccount = request.getParameter("receiverAccount");
        double amount = Double.parseDouble(request.getParameter("amount"));
        String pin = request.getParameter("Senderpin");
        String url = "jdbc:oracle:thin:@localhost:1521:orcl";
        String username = "system";
        String password = "password";

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, username, password);
            PreparedStatement pinStatement = conn.prepareStatement("SELECT * FROM account WHERE ACCOUNT_NUMBER=? AND PIN_NUMBER=?");
            pinStatement.setString(1, senderAccount);
            pinStatement.setString(2, pin);
            ResultSet pinResult = pinStatement.executeQuery();

            if (pinResult.next()) {
                senderName = pinResult.getString("ACCOUNT_HOLDER_NAME");
                PreparedStatement deductStatement = conn.prepareStatement("UPDATE account SET BALANCE=BALANCE-? WHERE ACCOUNT_NUMBER=?");
                deductStatement.setDouble(1, amount);
                deductStatement.setString(2, senderAccount);
                deductStatement.executeUpdate();
                PreparedStatement addStatement = conn.prepareStatement("UPDATE account SET BALANCE=BALANCE+? WHERE ACCOUNT_NUMBER=?");
                addStatement.setDouble(1, amount);
                addStatement.setString(2, receiverAccount);
                addStatement.executeUpdate();

                // Fetch receiver's name
                PreparedStatement receiverNameStatement = conn.prepareStatement("SELECT ACCOUNT_HOLDER_NAME FROM account WHERE ACCOUNT_NUMBER=?");
                receiverNameStatement.setString(1, receiverAccount);
                ResultSet receiverNameResult = receiverNameStatement.executeQuery();
                String receiverName = "";
                if (receiverNameResult.next()) {
                    receiverName = receiverNameResult.getString("ACCOUNT_HOLDER_NAME");
                }

                out.println("<div class='message'><p>Transfer successful! $" + amount + " transferred from Account " + senderName + " to " + receiverName + "</p></div>");
                receiverNameResult.close();
                receiverNameStatement.close();
            } else {
                out.println("<div class='message'><p>Invalid PIN. Please try again.</p></div>");
            }
            pinResult.close();
            pinStatement.close();
            conn.close();
        } catch (ClassNotFoundException | SQLException e) {
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
