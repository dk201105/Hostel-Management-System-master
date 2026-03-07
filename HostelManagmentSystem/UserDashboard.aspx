
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="HostelManagmentSystem.UserDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        body { font-family: 'Segoe UI', sans-serif; background-color: #f4f7f6; margin: 0; padding: 0; }
        
        /* HEADER */
        .header { background: white; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #ddd; }
        .header img { height: 50px; }
        .user-info { text-align: right; }
        .user-info h4 { margin: 0; color: #009933; }
        .btn-alerts { background: #007bff; color: white; border: none; padding: 8px 15px; border-radius: 20px; cursor: pointer; }

        /* STATS CARDS */
        .stats-container { display: flex; gap: 20px; padding: 20px 40px; }
        .card { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; }
        .dot { height: 12px; width: 12px; border-radius: 50%; display: inline-block; margin-right: 10px; }
        .grey { background: #aaa; } .green { background: #28a745; } .yellow { background: #ffc107; } .red { background: #dc3545; }
        .card h3 { margin: 0; font-size: 24px; color: #333; }
        .card p { margin: 0; color: #666; font-size: 12px; text-transform: uppercase; font-weight: bold; }

        /* MAIN CONTENT GRID */
        .main-container { display: flex; gap: 20px; padding: 0 40px 40px 40px; }
        
        /* LEFT COLUMN: ITEM LIST */
        .item-list-section { flex: 2; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .search-bar { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 5px; margin-bottom: 20px; box-sizing: border-box; }
        .item-row { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #eee; }
        .item-name { font-weight: bold; width: 30%; }
        .badge { padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
        .bg-pink { background: #ffe6e6; color: #333; }
        .bg-yellow { background: #fff3cd; color: #333; }
        .btn-update-list { background: #009933; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; font-weight: bold; }

        /* RIGHT COLUMN: UPDATE FORM */
        .update-section { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); height: fit-content; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
        .btn-submit { width: 100%; background: #009933; color: white; padding: 12px; border: none; border-radius: 5px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        
        /* NOTIFICATIONS BOX */
        .notif-box { background: #e3f2fd; padding: 15px; border-radius: 5px; margin-top: 20px; font-size: 13px; color: #0d47a1; }
        .notif-box ul { padding-left: 20px; margin: 0; }
        .notif-box li { margin-bottom: 5px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="header">
            <button class="btn-alerts"><i class="fas fa-bell"></i> Alerts</button>
            <div style="text-align:center;">
                <img src="https://upload.wikimedia.org/wikipedia/en/thumb/8/87/Women%27s_Christian_College%2C_Chennai_Logo.png/220px-Women%27s_Christian_College%2C_Chennai_Logo.png" alt="WCC Logo" />
            </div>
            <div class="user-info">
                <p style="margin:0; font-size:12px; color:#666;">User Dashboard</p>
                <asp:Label ID="lblFullName" runat="server" Text="XXXXXXX" Font-Bold="true" ForeColor="#009933" Font-Size="Large"></asp:Label>
            </div>
        </div>

        <div class="stats-container">
            <div class="card"><span class="dot grey"></span><div><p>Total Products</p><asp:Label ID="lblTotal" runat="server" Text="0" Font-Size="24px"></asp:Label></div></div>
            <div class="card"><span class="dot green"></span><div><p>Safe</p><asp:Label ID="lblSafe" runat="server" Text="0" Font-Size="24px"></asp:Label></div></div>
            <div class="card"><span class="dot yellow"></span><div><p>Restock Soon</p><asp:Label ID="lblRestockSoon" runat="server" Text="0" Font-Size="24px"></asp:Label></div></div>
            <div class="card"><span class="dot red"></span><div><p>Restock</p><asp:Label ID="lblRestock" runat="server" Text="0" Font-Size="24px"></asp:Label></div></div>
        </div>

        <div class="main-container">
            
            <div class="item-list-section">
                <h3>Item List</h3>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="search-bar" placeholder="Search items..."></asp:TextBox>
                
                <div style="display:flex; justify-content:space-between; font-weight:bold; color:#888; border-bottom:1px solid #ddd; padding-bottom:10px; margin-bottom:10px;">
                    <span style="width:30%">Item Name</span>
                    <span style="width:20%">Amt Remaining</span>
                    <span style="width:15%">Action</span>
                </div>

                <asp:Repeater ID="rptItems" runat="server" OnItemCommand="rptItems_ItemCommand">
                    <ItemTemplate>
                        <div class="item-row">
                            <div class="item-name"><span class="badge bg-pink"><%# Eval("ItemName") %></span></div>
                            <div style="width:20%"><%# Eval("Quantity") %>></div>
                            <div style="width:15%">
                                <asp:Button ID="btnSelect" runat="server" Text="UPDATE" CommandName="Select" CommandArgument='<%# Eval("ItemID") %>' CssClass="btn-update-list" />
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="update-section">
                <h3 style="margin-top:0;"><asp:Label ID="lblSelectedItem" runat="server" Text="Select an Item"></asp:Label></h3>
                <asp:HiddenField ID="hfSelectedItemID" runat="server" />
                
                <p style="font-size:12px; color:#666; font-weight:bold;">UPDATE INFORMATION</p>

                <div class="form-group">
                    <label>Amount Used:</label>
                    <asp:TextBox ID="txtAmountUsed" runat="server" CssClass="form-control" placeholder="Enter amount (e.g. 50)"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Date Used:</label>
                    <asp:TextBox ID="txtDateUsed" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                </div>

                <asp:Button ID="btnUpdateRecord" runat="server" Text="UPDATE RECORD" CssClass="btn-submit" OnClick="btnUpdateRecord_Click" />

                <div class="notif-box">
                    <strong>NOTIFICATIONS</strong>
                    <ul>
                        <li>Product needs restocking</li>
                        <li>Product close to expiry</li>
                    </ul>
                </div>
            </div>
        </div>
    </form>
</body>
</html>