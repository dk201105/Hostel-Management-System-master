<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="HostelManagmentSystem.Login" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WCC - Login Portal</title>
    <style>
        :root {
            --wcc-dark-green: #1a4332;
            --wcc-gold: #c5a059;
            --wcc-action-green: #00a651;
            --bg-soft-gray: #f0f2f5;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-soft-gray);
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .login-card {
            background: #ffffff;
            width: 100%;
            max-width: 420px;
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
            overflow: hidden;
            border: 1px solid #e1e4e8;
        }
        .motto-bar {
            background-color: var(--wcc-dark-green);
            color: var(--wcc-gold);
            text-align: center;
            padding: 10px 0;
            font-size: 14px;
            font-weight: bold;
            letter-spacing: 2px;
            text-transform: uppercase;
        }
        .brand-header {
            padding: 30px 20px;
            text-align: center;
            background: #fff;
            border-bottom: 1px solid #f0f0f0;
        }
        .college-logo {
            max-width: 280px;
            height: auto;
            display: block;
            margin: 0 auto;
        }
        .form-container {
            padding: 30px 40px;
        }
        .login-title {
            font-size: 18px;
            color: #444;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            font-size: 11px;
            font-weight: 700;
            color: #666;
            margin-bottom: 8px;
            text-transform: uppercase;
        }
        /* ASP Controls Styling */
        .asp-input {
            width: 100%;
            padding: 12px 15px;
            border: 1.5px solid #dce1e7;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 14px;
            transition: all 0.3s ease;
            background-color: #fafafa;
        }
        .asp-input:focus {
            outline: none;
            border-color: var(--wcc-action-green);
            background-color: #fff;
            box-shadow: 0 0 0 4px rgba(0, 166, 81, 0.1);
        }
        .login-btn {
            width: 100%;
            padding: 14px;
            background-color: var(--wcc-action-green);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            text-transform: uppercase;
        }
        .login-btn:hover {
            background-color: #008a44;
            box-shadow: 0 4px 12px rgba(0, 166, 81, 0.2);
        }
        .footer-links {
            margin-top: 25px;
            text-align: center;
            font-size: 13px;
            color: #888;
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
            display: block;
            text-align: center;
            margin-bottom: 15px;
            font-size: 13px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-card">
            <div class="motto-bar">
                Lighted to Lighten
            </div>

            <div class="brand-header">
                <img src="banner-wcc.jpg"
                     alt="Women's Christian College"
                     class="college-logo">
            </div>

            <div class="form-container">
                <h2 class="login-title">Inventory Portal Login</h2>
                <asp:Label ID="lblMessage" runat="server" Visible="false" ForeColor="Red"></asp:Label>
    
            <div class="form-group">
                 <label for="txtFullName">Full Name</label>
                 <asp:TextBox ID="txtFullName" runat="server" placeholder="Full Name" CssClass="your-original-class"></asp:TextBox>
            </div>
            <div class="form-group">
                 <label for="txtPassword">Password</label>
                 <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Password" CssClass="your-original-class"></asp:TextBox>
            </div>

            <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" CssClass="your-original-class" />
    
                <div class="footer-links">
                    <p><a href="#">Forgot Password?</a></p>
                    <p>Need access? <a href="Signup.aspx">Create an Account</a></p>
                </div>
            </div>
        </div>
    </form>
</body>
</html>

