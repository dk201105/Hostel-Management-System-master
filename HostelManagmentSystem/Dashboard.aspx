<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="HostelManagmentSystem.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WCC Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" />
    <style>

        .user-profile-container {
            position: relative;
            cursor: pointer;
            display: inline-block;
        }
        .user-profile-container:hover .dropdown-menu {
            display: block;
        }
        .dropdown-menu {
            display: none; /* Hidden by default */
            position: absolute;
            right: 0;
            top: 100%;
            background-color: white;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            z-index: 1000;
            min-width: 160px;
            border-radius: 4px;
            overflow: hidden;
        }
        .dropdown-menu a, .logout-btn {
            color: #333;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: 14px;
            transition: 0.2s;
            border: none;
            background: none;
            width: 100%;
            text-align: left;
            cursor: pointer;
        }
        .dropdown-menu a:hover, .logout-btn:hover {
            background-color: #f1f1f1;
            color: var(--wcc-green);
        }
        .logout-btn {
            color: #d93025; /* Red color for logout */
        }
        hr {
            margin: 0;
            border: none;
            border-top: 1px solid #eee;
        }

        :root {
            --wcc-green: #004d26;       /* Header Green */
            --wcc-gold: #c5a059;        /* Text Gold */
            --btn-green: #007a3d;       /* Action Buttons */
            --bg-light: #f9f9f9;
            --text-dark: #333;
            --border-radius: 8px;
            /* Alert Colors */
            --danger-bg: #ffe6e6; --danger-text: #d93025;
            --warning-bg: #fff9e6; --warning-text: #b08d00;
            --success-bg: #e6fffa; --success-text: #007a3d;
            --info-bg: #ffffff;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--bg-light);
            margin: 0;
            padding: 0;
            color: var(--text-dark);
        }

        /* --- Header --- */
        .header {
            background-color: white;
            padding: 0;
            border-bottom: 4px solid var(--wcc-green);
        }
        .top-motto {
            background-color: var(--wcc-green);
            color: var(--wcc-gold);
            text-align: center;
            font-size: 14px;
            font-weight: bold;
            padding: 5px;
            text-transform: uppercase;
            letter-spacing: 2px;
        }
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 40px;
        }
        .logo-img {
            height: 60px; /* Adjust based on your actual logo size */
        }
        .user-profile {
            text-align: right;
        }
        .user-role {
            color: var(--btn-green);
            font-weight: bold;
            font-size: 18px;
            text-transform: uppercase;
        }

        /* --- Layout Containers --- */
        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        /* --- Stats Cards --- */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: var(--border-radius);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-left: 5px solid #ccc;
        }
        .stat-card h3 { margin: 0; font-size: 14px; color: #666; font-weight: normal; }
        .stat-card .value { font-size: 32px; font-weight: bold; margin-top: 5px; display: block; }
        
        /* Specific Card Styles */
        .card-low { border-left-color: #666; }
        .card-high { border-left-color: var(--danger-text); background-color: #fff5f5; }
        .card-high .value { color: var(--danger-text); }
        .card-medium { border-left-color: var(--warning-text); background-color: #fffbf0; }
        .card-medium .value { color: var(--warning-text); }
        .card-ok { border-left-color: var(--success-text); background-color: #f0fdf4; }
        .card-ok .value { color: var(--success-text); }

        /* --- Quick Tasks Buttons --- */
        .tasks-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .task-btn {
            background-color: var(--btn-green);
            color: white;
            border: none;
            padding: 25px;
            border-radius: var(--border-radius);
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-transform: uppercase;
        }
        .task-btn:hover { background-color: #005c2e; }
        .task-btn i { font-size: 20px; }

        /* --- Actionable Insights --- */
        .insights-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        .insight-panel {
            padding: 20px;
            border-radius: var(--border-radius);
            border: 1px solid transparent;
        }
        .panel-alert {
            background-color: #fff5f5;
            border-color: #ffcccc;
            color: var(--danger-text);
        }
        .panel-recommend {
            background-color: #f0fdf4;
            border-color: #bbf7d0;
            color: var(--success-text);
        }
        .panel-title { font-weight: bold; margin-bottom: 10px; display: block; }

        /* --- Activity Feed (Small Tables) --- */
        .feed-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        .feed-box {
            background: white;
            padding: 20px;
            border-radius: var(--border-radius);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .section-title { font-size: 18px; font-weight: bold; margin-bottom: 15px; }

        /* --- General Table Styles --- */
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { text-align: left; padding: 12px; border-bottom: 2px solid #eee; color: #666; font-size: 13px; }
        td { padding: 12px; border-bottom: 1px solid #eee; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }

        /* --- Main Inventory Table --- */
        .inventory-section {
            background: white;
            padding: 25px;
            border-radius: var(--border-radius);
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        /* Status Badges */
        .status-badge { padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; }
        .status-good { color: var(--success-text); background: var(--success-bg); }
        .status-low { color: #d97706; background: #fffbeb; } /* Orange */
        .status-critical { color: var(--danger-text); background: var(--danger-bg); }
        
        /* Action Buttons in Table */
        .action-btn {
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 5px;
            font-size: 14px;
        }
        .btn-edit { background: #f0f0f0; color: #333; }
        .btn-edit:hover { background: #e0e0e0; }
        .btn-delete { background: var(--danger-text); color: white; }
        .btn-delete:hover { background: #b02318; }

        /* --- Modals (Hidden by Default) --- */
        .modal-overlay {
            display: none; /* Hidden */
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
        }
        .modal-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 450px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
            position: relative;
        }
        .modal-header { font-size: 20px; font-weight: bold; margin-bottom: 20px; }
        .close-modal { position: absolute; top: 15px; right: 20px; cursor: pointer; font-size: 24px; color: #999; }
        
        .modal-form-group { margin-bottom: 15px; }
        .modal-form-group label { display: block; margin-bottom: 5px; font-weight: 600; font-size: 13px; }
        .modal-input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px; box-sizing: border-box; }
        
        .modal-actions { margin-top: 20px; text-align: right; }
        .btn-confirm { background: black; color: white; padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; }
        .btn-cancel { background: white; border: 1px solid #ddd; padding: 10px 20px; border-radius: 6px; cursor: pointer; margin-right: 10px; }
        .btn-confirm-delete { background: var(--danger-text); color: white; padding: 10px 20px; border: none; border-radius: 6px; cursor: pointer; }

    </style>
</head>
<body>
    <form id="form1" runat="server">

    <div class="header">
        <div class="top-motto">Lighted to Lighten</div>
        <div class="header-content">
            <img src="https://wcc.edu.in/wp-content/themes/wcc/assets/images/logo/WCCLogo.png" alt="WCC Logo" class="logo-img" />
        
            <div class="user-profile-container">
                <div class="user-profile">
                    <span style="display:block; font-size:12px; color:#666;">User Dashboard</span>
                    <span class="user-role">ADMIN <i class="fas fa-caret-down"></i></span>
                </div>

                <div class="dropdown-menu">
                    <a href="#"><i class="fas fa-user-circle"></i> Profile</a>
                    <a href="#"><i class="fas fa-cog"></i> Settings</a>
                    <hr />
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" CssClass="logout-btn">
                        <i class="fas fa-sign-out-alt"></i> Log Out
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

        <div class="container">
            
            <div class="stats-grid">
                <div class="stat-card card-low">
                    <h3>Total Items</h3>
                    <asp:Label ID="lblTotal" runat="server" CssClass="value" Text="0"></asp:Label>
                </div>
                <div class="stat-card card-high">
                    <h3>Critical (Out)</h3>
                    <asp:Label ID="lblRestock" runat="server" CssClass="value" Text="0"></asp:Label>
                </div>
                <div class="stat-card card-medium">
                    <h3>Low Stock</h3>
                    <asp:Label ID="lblRestockSoon" runat="server" CssClass="value" Text="0"></asp:Label>
                </div>
                <div class="stat-card card-ok">
                    <h3>Healthy</h3>
                    <asp:Label ID="lblSafe" runat="server" CssClass="value" Text="0"></asp:Label>
                </div>

                <asp:Repeater ID="rptItems" runat="server">
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("ItemName") %></td>
                            <td><%# Eval("Quantity") %></td>
                            <td><%# Eval("QuantityThreshold") %></td>
                            <td><%# GetStatusBadge(Eval("Quantity"), Eval("QuantityThreshold")) %></td>
                            <td>
                                <asp:LinkButton ID="btnSelect" runat="server" CommandName="Select" 
                                    CommandArgument='<%# Eval("ItemID") %>' CssClass="action-btn btn-edit">
                                    <i class="fas fa-pencil-alt"></i>
                                </asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>

                <asp:HiddenField ID="hfSelectedItemID" runat="server" />
                <asp:Label ID="lblSelectedItem" runat="server" Visible="false"></asp:Label>
            </div>

            <div class="section-title">Quick Tasks</div>
                <div class="tasks-grid">
                    <button type="button" class="task-btn" onclick="openModal('addModal')">
                        <i class="fas fa-plus"></i> New Item
                    </button>
                    <button type="button" class="task-btn">
                        <i class="fas fa-shopping-cart"></i> Log Purchase
                    </button>
                    <button type="button" class="task-btn">
                        <i class="fas fa-file-alt"></i> Generate Monthly Report
                    </button>
            </div>

            <div class="section-title">Recent Activity Feed</div>
            <div class="feed-grid">
                <div class="feed-box">
                    <div style="font-weight:bold; margin-bottom:10px;">Inflow (Deliveries)</div>
                    <table>
                        <thead><tr><th>Item</th><th>Vendor</th><th>Qty</th><th>Date</th></tr></thead>
                        <tbody>
                        </tbody>
                    </table>
                </div>
                <div class="feed-box">
                    <div style="font-weight:bold; margin-bottom:10px;">Outflow (Consumption)</div>
                    <table>
                        <thead><tr><th>Item</th><th>Qty Used</th><th>Date</th></tr></thead>
                        <tbody>
                            <tr><td>Milk</td><td>20 L</td><td>2024-05-21</td></tr>
                            <tr><td>Veg Oil</td><td>10 L</td><td>2024-05-21</td></tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="section-title">Inventory Management</div>
            <div class="inventory-section">
                <table>
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Quantity</th>
                            <th>Threshold</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater ID="rptInventory" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><%# Eval("ItemName") %></td>
                                    <td><%# Eval("Quantity") %></td>
                                    <td><%# Eval("QuantityThreshold") %></td>
                                    <td>
                                        <%# GetStatusBadge(Eval("Quantity"), Eval("QuantityThreshold")) %>
                                    </td>
                                    <td>
                                        <button type="button" class="action-btn btn-edit" onclick="openEditModal('<%# Eval("ItemID") %>', '<%# Eval("ItemName") %>')">
                                            <i class="fas fa-pencil-alt"></i>
                                        </button>
                                        <asp:LinkButton ID="btnDelete" runat="server" CssClass="action-btn btn-delete" 
                                            CommandArgument='<%# Eval("ItemID") %>' OnClick="btnDelete_Click" OnClientClick="return confirm('Delete this item?');">
                                            <i class="fas fa-trash"></i>
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>

        <div id="addModal" class="modal-overlay">
            <div class="modal-box">
                <span class="close-modal" onclick="closeModal('addModal')">&times;</span>
                <div class="modal-header">Add New Item</div>
        
                <div class="modal-form-group">
                    <label>Item Name</label>
                    <asp:TextBox ID="txtNewItemName" runat="server" CssClass="modal-input" placeholder="e.g. Rice"></asp:TextBox>
                </div>
                <div class="modal-form-group">
                    <label>Quantity</label>
                    <asp:TextBox ID="txtNewQty" runat="server" CssClass="modal-input" TextMode="Number" placeholder="0"></asp:TextBox>
                </div>
                <div class="modal-form-group">
                    <label>Threshold (Low Stock Alert)</label>
                    <asp:TextBox ID="txtNewThreshold" runat="server" CssClass="modal-input" TextMode="Number" placeholder="10"></asp:TextBox>
                </div>
                <div class="modal-form-group">
                    <label>Item Price</label>
                    <asp:TextBox ID="txtNewPrice" runat="server" CssClass="modal-input" placeholder="0.00"></asp:TextBox>
                </div>

        
                <div class="modal-actions">
                    <button type="button" class="btn-cancel" onclick="closeModal('addModal')">Cancel</button>
                    <asp:Button ID="btnSaveNewItem" runat="server" Text="Add Item" CssClass="btn-confirm" OnClick="btnSaveNewItem_Click" />
                </div>
            </div>
        </div>

        <div id="editModal" class="modal-overlay">
            <div class="modal-box">
                <span class="close-modal" onclick="closeModal('editModal')">&times;</span>
                <div class="modal-header">Edit Item</div>
                
                <div class="modal-form-group">
                    <label>Item Name</label>
                    <input type="text" class="modal-input" value="Rice" />
                </div>
                <div class="modal-form-group">
                    <label>Vendor</label>
                    <input type="text" class="modal-input" value="ABC Supplies" />
                </div>
                <div class="modal-form-group">
                    <label>Quantity</label>
                    <input type="number" class="modal-input" value="200" />
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn-confirm">Update Item</button>
                </div>
            </div>
        </div>

        <div id="deleteModal" class="modal-overlay">
            <div class="modal-box" style="text-align:center;">
                <span class="close-modal" onclick="closeModal('deleteModal')">&times;</span>
                <div class="modal-header" style="color:var(--danger-text);">Are you sure?</div>
                <p>This action cannot be undone. This will permanently delete this item from the inventory.</p>
                
                <div class="modal-actions" style="justify-content:center; display:flex;">
                    <button type="button" class="btn-cancel" onclick="closeModal('deleteModal')">Cancel</button>
                    <button type="button" class="btn-confirm-delete">Delete</button>
                </div>
            </div>
        </div>

    </form>

    <script>
        function openModal(modalId) {
            document.getElementById(modalId).style.display = 'flex';
        }
        function closeModal(modalId) {
            document.getElementById(modalId).style.display = 'none';
        }
        // Close modal if clicking outside the box
        window.onclick = function (event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.style.display = "none";
            }
        }
    </script>
</body>
</html>