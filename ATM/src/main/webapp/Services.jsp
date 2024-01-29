<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ATM Services</title>
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
    .container {
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    }
    h1 {
        color: #333;
        text-align: center;
    }
    form {
        text-align: center;
        margin-bottom: 20px; /* Added margin between forms */
    }
    input[type="submit"] {
        padding: 10px 20px;
        font-size: 16px;
        border: none;
        background-color: #4CAF50;
        color: #fff;
        cursor: pointer;
        border-radius: 5px;
        transition: background-color 0.3s;
    }
    input[type="submit"]:hover {
        background-color: #45a049;
    }
    p {
        color: #333;
        text-align: center;
        margin-top: 20px;
        font-size: 18px;
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
        <h1>Welcome to the ATM Services Tab</h1>
        <form action="atm_services.jsp" method="post">
            <input type="hidden" name="action" value="deposit">
            <input type="submit" value="Deposit">
        </form>
        <form action="atm_services.jsp" method="post">
            <input type="hidden" name="action" value="transfer">
            <input type="submit" value="Transfer">
        </form>
        <form action="atm_services.jsp" method="post">
            <input type="hidden" name="action" value="bill_payment">
            <input type="submit" value="Bill Payment">
        </form>
        <form action="atm_services.jsp" method="post">
            <input type="hidden" name="action" value="account_management">
            <input type="submit" value="Account Management">
        </form>
        <form action="atm_services.jsp" method="post">
            <input type="hidden" name="action" value="prepaid_card_reload">
            <input type="submit" value="Prepaid Card Reload">
        </form>
        <form action="atm_services.jsp" method="post">
            <input type="hidden" name="action" value="charity_donation">
            <input type="submit" value="Charity Donation">
        </form>
         <button onclick="window.location.href='home.html'" class="exit-button">Exit</button>

        <%-- Java code to handle form submission and display service message --%>
        <% 
            String action = request.getParameter("action");
            if(action != null) {
                String message = "";
                switch(action) {
                    case "deposit":
                        message = "Deposit service selected.";
                        break;
                    case "transfer":
                        message = "Transfer service selected.";
                        break;
                    case "bill_payment":
                        message = "Bill Payment service selected.";
                        break;
                    case "account_management":
                        message = "Account Management service selected.";
                        break;
                    case "prepaid_card_reload":
                        message = "Prepaid Card Reload service selected.";
                        break;
                    case "charity_donation":
                        message = "Charity Donation service selected.";
                        break;
                    default:
                        message = "Invalid service.";
                }
                out.println("<p>" + message + "</p>");
            }
        %>
    </div>
<script>
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
