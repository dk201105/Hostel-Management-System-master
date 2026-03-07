<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="HostelManagmentSystem.UserDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>User Dashboard | InvyWeb Style</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>
        :root {
            --primary-color: #186420;
            --sidebar-bg: #0d4214;
            --bg-light: #f8fafc;
            --text-dark: #334155;
            --border-color: #e2e8f0;
        }

        /* RESET & FULL PAGE STYLES */
        html, body { height: 100%; margin: 0; padding: 0; overflow-x: hidden; }
        body { 
            font-family: 'Inter', 'Segoe UI', sans-serif; 
            background-color: var(--bg-light); 
            display: flex;
            color: var(--text-dark);
        }

        /* SIDEBAR (Sticky Full Height) */
        .sidebar {
            width: 400px; 
            background-color: var(--primary-color);
            height: 100vh;
            color: white;
            position: fixed;
            left: 0;
            top: 0;
            display: flex;
            flex-direction: column;
            z-index: 100;
        }

        .sidebar-header { padding: 30px 20px; font-weight: bold; font-size: 16px; letter-spacing: 1px; display: flex; align-items: center; }
        .nav-menu { list-style: none; padding: 0; margin: 0; }
        .nav-item { padding: 15px 25px; display: flex; align-items: center; cursor: pointer; transition: 0.3s; font-size: 14px; opacity: 0.8; }
        .nav-item i { margin-right: 15px; width: 20px; }
        .nav-item:hover, .nav-item.active { background: rgba(255,255,255,0.1); opacity: 1; border-left: 4px solid #fff; }

        /* MAIN CONTENT */
        .main-wrapper {
            margin-left: 400px; 
            width: calc(100% - 240px); 
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: var(--bg-light);
        }

        .top-nav {
            background: white;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            position: sticky;
            top: 0;
            z-index: 99;
        }

        /* PROFILE DROPDOWN (Click-based) */
        .user-profile-wrap { position: relative; display: flex; align-items: center; gap: 15px; cursor: pointer; padding: 5px 10px; border-radius: 8px; transition: 0.2s; }
        .user-profile-wrap:hover { background: #f1f5f9; }
        
        .profile-dropdown {
            position: absolute;
            top: 110%;
            right: 0;
            background: white;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
            width: 150px;
            display: none; 
            overflow: hidden;
        }
        
        .profile-dropdown.show { display: block; }

        .dropdown-item { padding: 12px 15px; font-size: 14px; color: #ef4444; display: flex; align-items: center; gap: 10px; text-decoration: none; transition: 0.2s; }
        .dropdown-item:hover { background: #fff1f2; }

        .dashboard-container {
            padding: 30px 40px; 
            width: 100%; 
            box-sizing: border-box; 
            flex: 1;
        }

        /* STATS CARDS */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: 12px; border: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: flex-start; }
        .stat-card.border-green { border-bottom: 4px solid #10b981; }
        .stat-card.border-red { border-bottom: 4px solid #ef4444; }
        .stat-card.border-blue { border-bottom: 4px solid #3b82f6; }
        .stat-card.border-grey { border-bottom: 4px solid #94a3b8; }
        .stat-info p { margin: 0; color: #64748b; font-size: 13px; font-weight: 500; }
        .stat-info h3 { margin: 5px 0; font-size: 24px; color: #1e293b; }
        .stat-icon { font-size: 20px; color: var(--primary-color); opacity: 0.5; }

        /* CONTENT GRID */
        .content-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 25px; }
        .panel { background: white; border-radius: 12px; border: 1px solid var(--border-color); padding: 20px; }
        .panel-title { font-size: 16px; font-weight: 600; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; }

        .custom-table { 
            width: 100%; 
            border-collapse: collapse; 
        }
        .custom-table th { text-align: left; padding: 12px 8px; color: #64748b; font-size: 11px; text-transform: uppercase; border-bottom: 1px solid var(--border-color); }
        .custom-table td { padding: 12px 8px; border-bottom: 1px solid #f1f5f9; font-size: 14px; }

        .badge-status { padding: 4px 8px; border-radius: 6px; font-size: 10px; font-weight: 700; }
        .status-safe { background: #dcfce7; color: #15803d; }
        .status-critical { background: #fee2e2; color: #b91c1c; }

        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; margin-bottom: 8px; color: #475569; }
        .form-control { width: 100%; padding: 10px 12px; border: 1px solid var(--border-color); border-radius: 8px; font-size: 14px; box-sizing: border-box; }
        
        .btn-primary { background: var(--primary-color); color: white; border: none; padding: 12px; border-radius: 8px; width: 100%; font-weight: 600; cursor: pointer; }
        .btn-outline { background: transparent; border: 1px solid var(--primary-color); color: var(--primary-color); padding: 5px 10px; border-radius: 6px; cursor: pointer; font-size: 12px; }

        .notif-box { background: #eff6ff; border-left: 4px solid #3b82f6; padding: 15px; margin-top: 20px; border-radius: 4px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-hotel"></i> &nbsp; WCC INVENTORY
            </div>
            <ul class="nav-menu">
                <li class="nav-item active"><i class="fas fa-th-large"></i> Dashboard</li>
            </ul>
            <div style="margin-top:auto; padding: 20px; font-size: 10px; opacity: 0.5;">
                &copy; 2026 Hostel Management
            </div>
        </div>

        <div class="main-wrapper">
            <div class="top-nav">
                <div style="font-weight: 600; color: #64748b;">User Dashboard</div>
                <div style="display: flex; align-items: center; gap: 25px;">
                    <i class="far fa-bell" style="font-size: 20px; color: #64748b; cursor:pointer;"></i>
                    <div class="user-profile-wrap" onclick="toggleProfileMenu(event)">
                        <div style="text-align: right;">
                            <asp:Label ID="lblFullName" runat="server" Text="User Name" Font-Bold="true" ForeColor="#1e293b"></asp:Label><br />
                            <small style="color: #64748b;">USER</small>
                        </div>
                        <div style="width:40px; height:40px; background:var(--primary-color); border-radius:50%; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold;">
                            Profile
                        </div>
                        <i class="fas fa-chevron-down" style="font-size: 12px; color: #94a3b8;"></i>
                        <div id="dropdownMenu" class="profile-dropdown">
                            <asp:LinkButton ID="lnkLogout" runat="server" CssClass="dropdown-item" OnClick="lnkLogout_Click">
                                <i class="fas fa-sign-out-alt"></i> Sign Out
                            </asp:LinkButton>
                        </div>
                    </div>
                </div>
            </div>

            <div class="dashboard-container">
                <div class="stats-grid">
                    <div class="stat-card border-grey">
                        <div class="stat-info"><p>Total Products</p><h3><asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label></h3></div>
                        <i class="fas fa-boxes stat-icon"></i>
                    </div>
                    <div class="stat-card border-green">
                        <div class="stat-info"><p>Safe Stock</p><h3><asp:Label ID="lblSafe" runat="server" Text="0"></asp:Label></h3></div>
                        <i class="fas fa-check-circle stat-icon" style="color:#10b981"></i>
                    </div>
                    <div class="stat-card border-blue">
                        <div class="stat-info"><p>Restock Soon</p><h3><asp:Label ID="lblRestockSoon" runat="server" Text="0"></asp:Label></h3></div>
                        <i class="fas fa-clock stat-icon" style="color:#3b82f6"></i>
                    </div>
                    <div class="stat-card border-red">
                        <div class="stat-info"><p>Critical Stock</p><h3><asp:Label ID="lblRestock" runat="server" Text="0"></asp:Label></h3></div>
                        <i class="fas fa-exclamation-triangle stat-icon" style="color:#ef4444"></i>
                    </div>
                </div>
                
                <div class="content-grid">
                    <div class="panel">
                        <div class="panel-title">
                            Item Inventory
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search..." style="width: 180px; padding: 6px 12px;" onkeyup="filterInventoryTable()"></asp:TextBox>
                        </div>
                        <table class="custom-table" id="inventoryTable">
                            <thead>
                                <tr>
                                    <th>Item Name</th>
                                    <th>Quantity</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:Repeater ID="rptItems" runat="server" OnItemCommand="rptItems_ItemCommand">
                                    <ItemTemplate>
                                        <tr>
                                            <td style="font-weight:600;"><%# Eval("ItemName") %></td>
                                            <td><%# Eval("Quantity") %> Units</td>
                                            <td>
                                                <span class='badge-status <%# Convert.ToDecimal(Eval("Quantity")) < 10 ? "status-critical" : "status-safe" %>'>
                                                    <%# Convert.ToDecimal(Eval("Quantity")) < 10 ? "LOW STOCK" : "IN STOCK" %>
                                                </span>
                                            </td>
                                            <td>
                                                <asp:Button ID="btnSelect" runat="server" Text="Update" CommandName="Select" CommandArgument='<%# Eval("ItemID") %>' CssClass="btn-outline" />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </tbody>
                        </table>
                    </div>

                    <div class="panel">
                        <div class="panel-title">Update Usage</div>
                        <asp:Label ID="lblSelectedItem" runat="server" Text="Select an Item" Font-Size="13px" ForeColor="#64748b"></asp:Label>
                        <asp:HiddenField ID="hfSelectedItemID" runat="server" />
                        <hr style="border: 0; border-top: 1px solid #f1f5f9; margin: 15px 0;" />

                        <div class="form-group">
                            <label>Amount Used</label>
                            <asp:TextBox ID="txtAmountUsed" runat="server" CssClass="form-control" placeholder="Enter quantity"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label>Usage Date</label>
                            <asp:TextBox ID="txtDateUsed" runat="server" TextMode="Date" CssClass="form-control"></asp:TextBox>
                        </div>

                        <asp:Button ID="btnUpdateRecord" runat="server" Text="Confirm Update" CssClass="btn-primary" OnClick="btnUpdateRecord_Click" />

                        <div class="notif-box">
                            <div style="font-weight: bold; font-size: 11px; color: #1e40af; text-transform:uppercase; margin-bottom:5px;">System Alerts</div>
                            <ul style="margin: 0; padding-left: 15px; font-size: 12px; color: #1e40af; line-height:1.6;">
                                <li>Low stock items are auto-flagged.</li>
                                <li>Audit logs updated on confirmation.</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script>
        function toggleProfileMenu(event) {
            event.stopPropagation();
            document.getElementById("dropdownMenu").classList.toggle("show");
        }
        window.onclick = function(event) {
            var dropdown = document.getElementById("dropdownMenu");
            if (dropdown && dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
        }

        // Search Filter Logic
        function filterInventoryTable() {
            var input = document.getElementById('<%= txtSearch.ClientID %>');
            var filter = input.value.toLowerCase();
            var table = document.getElementById("inventoryTable");
            var tr = table.getElementsByTagName("tr");

            // Loop through all table rows (excluding the header)
            for (var i = 1; i < tr.length; i++) {
                var tdName = tr[i].getElementsByTagName("td")[0]; // Item Name column
                if (tdName) {
                    var txtValue = tdName.textContent || tdName.innerText;
                    if (txtValue.toLowerCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
</body>
</html>