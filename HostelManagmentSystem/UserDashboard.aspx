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
        .item-row { 
                display: flex; 
                justify-content: space-between; 
                align-items: center; 
                padding: 15px 0; 
                border-bottom: 1px solid #eee; 
                width: 100%; /* Ensure it takes full container width */
        }
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
        

        /* PROFILE DROPDOWN STYLES */
        .user-profile-wrap { 
            position: relative; 
            display: flex; 
            align-items: center; 
            gap: 15px; 
            cursor: pointer; 
            padding: 5px 10px; 
            border-radius: 8px; 
            transition: 0.2s; 
        }
        .user-profile-wrap:hover { background: #f1f5f9; }

        .profile-dropdown {
            position: absolute;
            top: 110%;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
            width: 150px;
            display: none; 
            overflow: hidden;
            z-index: 1000;
        }
        .profile-dropdown.show { display: block; }

        .dropdown-item { 
            padding: 12px 15px; 
            font-size: 14px; 
            color: #ef4444; 
            display: flex; 
            align-items: center; 
            gap: 10px; 
            text-decoration: none; 
            transition: 0.2s; 
            width: 100%;
            border: none;
            background: none;
            cursor: pointer;
        }
        .dropdown-item:hover { background: #fff1f2; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="header">
            <button class="btn-alerts" type="button"><i class="fas fa-bell"></i> Alerts</button>
    
            <div style="text-align:center;">
                <img src="wcc_icon.png" alt="WCC Logo" />
            </div>

            <div class="user-profile-wrap" onclick="toggleProfileMenu(event)">
                <div class="user-info">
                    <p style="margin:0; font-size:12px; color:#666; text-transform: uppercase;">User Dashboard</p>
                    <asp:Label ID="lblFullName" runat="server" Text="priyan" Font-Bold="true" ForeColor="#009933" Font-Size="Medium"></asp:Label>
                </div>

                <div style="width:40px; height:40px; background:#009933; border-radius:50%; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold; font-size: 18px;">
                    P
                </div>

                <i class="fas fa-chevron-down" style="font-size: 12px; color: #94a3b8;"></i>

                <div id="dropdownMenu" class="profile-dropdown">
                    <asp:LinkButton ID="lnkLogout" runat="server" CssClass="dropdown-item" OnClick="lnkLogout_Click">
                        <i class="fas fa-sign-out-alt"></i> Sign Out
                    </asp:LinkButton>
                </div>
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
                    <span style="width:40%">Item Name</span>
                    <span style="width:40%; text-align: right; padding-right: 20px;">Amt Remaining</span>
                    <span style="width:20%; text-align: right;">Action</span>
                </div>

                <asp:Repeater ID="rptItems" runat="server" OnItemCommand="rptItems_ItemCommand">
                    <ItemTemplate>
                        <div class="item-row" style="display: flex; justify-content: space-between; align-items: center;">
                            <div class="item-name" style="width:40%">
                                <span class="badge bg-pink"><%# Eval("ItemName") %></span>
                            </div>
            
                            <div style="width:40%; text-align: right; padding-right: 20px; font-weight: bold; color: #334155;">
                                <%# Eval("Quantity") %>
                            </div>
            
                            <div style="width:20%; text-align: right;">
                                <asp:Button ID="btnSelect" runat="server" Text="UPDATE" 
                                    CommandName="Select" 
                                    CommandArgument='<%# Eval("ItemID") %>' 
                                    CssClass="btn-update-list" />
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

                <div style="margin-bottom: 10px; text-align: center;">
                    <asp:Label ID="lblError" runat="server" ForeColor="#ef4444" Font-Size="13px" Font-Bold="true" Text=""></asp:Label>
                </div>

                <asp:Button ID="btnUpdateRecord" runat="server" Text="UPDATE RECORD" CssClass="btn-submit" OnClick="btnUpdateRecord_Click" />
            </div>
        </div>
    </form>

    <script>
        function toggleProfileMenu(e) {
            // Stop the click from immediately closing the menu
            e.stopPropagation();
            document.getElementById("dropdownMenu").classList.toggle("show");
        }

        // Close dropdown if user clicks anywhere else
        window.onclick = function(event) {
            var dropdown = document.getElementById("dropdownMenu");
            if (dropdown && dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        }
    </script>
</body>
</html>