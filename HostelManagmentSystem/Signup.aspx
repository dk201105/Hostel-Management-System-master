<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Signup.aspx.cs" Inherits="HostelManagmentSystem.Signup" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WCC Admin - Create Account</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            height: 100vh;
            display: flex;
        }
        .left-panel {
            flex: 1;
            background-color: #1a4332;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .left-panel img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 12px;
        }
        .right-panel {
            flex: 1;
            background-color: #186420;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .signup-box {
            background: #fff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 420px;
        }
        .signup-box h2 {
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
        .signup-btn {
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
        .signup-btn:hover {
            background-color: #008a44;
        }
        .login-link {
            text-align: center;
            margin-top: 1rem;
            font-size: 13px;
        }
        .login-link a {
            color: #0066cc;
            text-decoration: none;
            font-weight: 600;
        }
        .login-link a:hover {
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

        <!-- Right side with signup form -->
        <div class="right-panel">
            <div class="signup-box">
                <h2>Create Account</h2>
                <asp:Label ID="lblMessage" runat="server" CssClass="error-msg" Visible="false"></asp:Label>

                <div class="form-group">
                    <label for="txtFullName">Full Name</label>
                    <asp:TextBox ID="txtFullName" runat="server" CssClass="asp-input" placeholder="Enter your full name"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtEmail">College Email ID</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="asp-input" placeholder="example@wcc.edu.in"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="ddlRole">Designation / Role</label>
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="asp-input">
                        <asp:ListItem Value="inventory_manager">Select role</asp:ListItem>
                        <asp:ListItem Value="User">User</asp:ListItem>
                        <asp:ListItem Value="Admin">Admin</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="asp-input" placeholder="Create a password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="txtConfirmPassword">Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="asp-input" placeholder="Confirm your password"></asp:TextBox>
                </div>

                <asp:Button ID="btnSignup" runat="server" Text="Create Account" CssClass="signup-btn" OnClick="btnSignup_Click" />

                <div class="login-link">
                    Already have an account? <a href="Login.aspx">Log In</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>