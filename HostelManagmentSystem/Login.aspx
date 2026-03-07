<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HostelManagmentSystem.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WCC - Login Portal</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            height: 100vh;
            display: flex;
        }
        .left-panel {
            flex: 1;
            /*background-color: #1a4332;*/
            display: flex;
            justify-content: center;
            align-items: center;
        }
       
        .left-panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            /*border-radius: 12px;*/
        }
        .right-panel {
            flex: 1;
            background-color: #186420;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-box {
            background: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 380px;
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 1.5rem;
            color: #1a4332;
            text-transform: uppercase;
        }
        .form-group {
            margin-bottom: 1rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            font-size: 13px;
            color: #333;
        }
        .asp-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }
        .asp-input:focus {
            border-color: #00a651;
            outline: none;
            box-shadow: 0 0 0 3px rgba(0,166,81,0.2);
        }
        .login-btn {
            width: 100%;
            padding: 12px;
            background-color: #00a651;
            color: #fff;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 10px;
        }
        .login-btn:hover {
            background-color: #008a44;
        }
        .footer-links {
            text-align: center;
            margin-top: 1rem;
            font-size: 13px;
        }
        .footer-links a {
            color: #0066cc;
            text-decoration: none;
            font-weight: 600;
        }
        .footer-links a:hover {
            text-decoration: underline;
        }
        .error-msg {
            text-align: center;
            margin-bottom: 10px;
            color: red;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" style="display:flex; width:100%;">
        <!-- Left side with WCC image -->
        <div class="left-panel">
            <img src="logo.jpg" alt="Women's Christian College" />
        </div>

        <!-- Right side with login form -->
        <div class="right-panel">
            <div class="login-box">
                <h2>Inventory Portal Login</h2>
                <asp:Label ID="lblMessage" runat="server" CssClass="error-msg" Visible="false"></asp:Label>

                <div class="form-group">
                    <label for="txtFullName">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="asp-input" placeholder="Full Name"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="asp-input" placeholder="Password"></asp:TextBox>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="login-btn" />

                <div class="footer-links">
                    <%--<p><a href="#">Forgot Password?</a></p>--%>
                    <p>Need access? <a href="Signup.aspx">Create an Account</a></p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>