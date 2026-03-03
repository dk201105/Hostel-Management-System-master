<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="HostelManagmentSystem.Signup" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WCC Admin - Create Account</title>
    <style>
        :root {
            --primary-green: #004d26;
            --accent-gold: #c5a059;
            --bg-light: #f8f9fa;
            --text-dark: #333;
            --border-color: #e0e0e0;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .signup-container {
            background: #fff;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 450px;
            border-top: 8px solid var(--primary-green);
        }
        .header-logo {
            text-align: center;
            margin-bottom: 1.5rem;
        }
        .header-logo h2 {
            color: var(--primary-green);
            margin: 0;
            font-size: 22px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .header-logo p {
            color: var(--accent-gold);
            font-style: italic;
            margin: 5px 0 0;
            font-size: 14px;
        }
        .form-group {
            margin-bottom: 1.2rem;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
            color: var(--text-dark);
        }
        input[type="text"], input[type="password"], input[type="email"], select, .asp-control {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }
        input:focus, select:focus {
            outline: none;
            border-color: var(--primary-green);
        }
        .signup-btn {
            width: 100%;
            padding: 14px;
            background-color: var(--primary-green);
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
            margin-top: 10px;
        }
        .signup-btn:hover {
            background-color: #00331a;
        }
        .login-link {
            text-align: center;
            margin-top: 1.5rem;
            font-size: 14px;
        }
        .login-link a {
            color: var(--primary-green);
            text-decoration: none;
            font-weight: bold;
        }
        .message-lbl {
            text-align: center;
            display: block;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="signup-container">
            <div class="header-logo">
                <h2>Women's Christian College</h2>
                <p>"Lighted to Lighten"</p>
            </div>

            <asp:Label ID="lblMessage" runat="server" CssClass="message-lbl" ForeColor="Red"></asp:Label>

            <div class="form-group">
                <label for="txtFullName">Full Name</label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="asp-control" placeholder="Enter your full name"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtEmail">College Email ID</label>
                <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="asp-control" placeholder="example@wcc.edu.in"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="ddlRole">Designation / Role</label>
                <asp:DropDownList ID="ddlRole" runat="server" CssClass="asp-control">
                    <asp:ListItem Value="User">Staff / User</asp:ListItem>
                    <asp:ListItem Value="Admin">Admin</asp:ListItem>                    
                    <asp:ListItem Value="inventory_manager">Inventory Manager</asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label for="txtPassword">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="asp-control" placeholder="Create a password"></asp:TextBox>
            </div>

            <div class="form-group">
                <label for="txtConfirmPassword">Confirm Password</label>
                <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="asp-control" placeholder="Confirm your password"></asp:TextBox>
            </div>

            <asp:Button ID="btnSignup" runat="server" Text="Create Admin Account" CssClass="signup-btn" OnClick="btnSignup_Click" />

            <div class="login-link">
                Already have an account? <a href="Login.aspx">Log In</a>
            </div>
        </div>
    </form>
</body>
</html>