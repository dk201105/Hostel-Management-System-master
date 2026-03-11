﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="HostelManagmentSystem.Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<title>Admin Dashboard</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>

    <style>

    :root{
        --primary-color:#186420;
        --sidebar-bg:#0d4214;
        --bg-light:#f8fafc;
        --text-dark:#334155;
        --border-color:#e2e8f0;
    }

    html,body{
        height:100%;
        margin:0;
        font-family:'Segoe UI',sans-serif;
        background:var(--bg-light);
        display:flex;
    }

    /* SIDEBAR */

    .sidebar{
        width:350px;
        background:var(--primary-color);
        height:100vh;
        color:white;
        position:fixed;
        left:0;
        top:0;
        display:flex;
        flex-direction:column;
    }

    .sidebar-header{
        padding:30px 20px;
        font-weight:bold;
        display:flex;
        align-items:center;
    }

    .nav-menu{
        list-style:none;
        padding:0;
        margin:0;
    }

    .nav-item{
        padding:15px 25px;
        display:flex;
        align-items:center;
        cursor:pointer;
    }

    .nav-item:hover{
        background:rgba(255,255,255,0.1);
    }

    /* MAIN */

    .main-wrapper{
        margin-left:350px;
        width:100%;
        display:flex;
        flex-direction:column;
        flex-grow: 1; 
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
        max-width: none;
        flex: 1;
    }

    /* STATS */

    .stats-grid{
        display:grid;
        grid-template-columns:repeat(4,1fr);
        gap:20px;
        margin-bottom:30px;
    }

    .stat-card{
        background:white;
        padding:20px;
        border-radius:12px;
        border:1px solid var(--border-color);
    }

    .stat-info p{
        margin:0;
        color:#64748b;
        font-size:13px;
    }

    .stat-info h3{
        margin:5px 0;
        font-size:24px;
    }

    /* PANELS */

    .panel{
        background:white;
        border-radius:12px;
        border:1px solid var(--border-color);
        padding:20px;
        margin-bottom:25px;
    }

    .panel-title{
        font-weight:600;
        margin-bottom:15px;
    }

    /* TABLE */

    .custom-table{
        width:100%;
        border-collapse:collapse;
    }

    .custom-table th{
        text-align:left;
        padding:12px;
        border-bottom:1px solid var(--border-color);
        font-size:12px;
    }

    .custom-table td{
        padding:12px;
        border-bottom:1px solid #f1f5f9;
    }

    .status-badge{
        padding:4px 8px;
        border-radius:6px;
        font-size:11px;
        font-weight:700;
    }

    .status-good{
        background:#dcfce7;
        color:#15803d;
    }

    .status-low{
        background:#fef3c7;
        color:#92400e;
    }

    .status-critical{
        background:#fee2e2;
        color:#b91c1c;
    }

    /* BUTTONS */

    .task-btn{
        background:white;
        border:1px solid var(--primary-color);
        padding:10px 15px;
        border-radius:8px;
        cursor:pointer;
        margin-right:10px;
    }

    .task-btn:hover{
        background:var(--primary-color);
        color:white;
    }

    </style>
</head>

<body>

    <form id="form1" runat="server">

        <div class="sidebar">
            <div class="sidebar-header">
                <i class="fas fa-hotel"></i>&nbsp; WCC INVENTORY
            </div>
            <ul class="nav-menu">
                <li class="nav-item"><i class="fas fa-th-large"></i> Dashboard</li>
            </ul>
            <div style="margin-top:auto;padding:20px;font-size:10px;opacity:.5;">
                © 2026 Hostel Management
            </div>
        </div> 

        <div class="main-wrapper">
            <div class="top-nav">
                <div style="font-weight: 600; color: #64748b;">Admin Dashboard</div>
                <div style="display: flex; align-items: center; gap: 25px;">
                    <i class="far fa-bell" style="font-size: 20px; color: #64748b; cursor:pointer;"></i>
                    <div class="user-profile-wrap" onclick="toggleProfileMenu(event)">
                        <div style="text-align: right;">
                            <asp:Label ID="lblFullName" runat="server" Text="User Name" Font-Bold="true" ForeColor="#1e293b"></asp:Label><br />
                            <small style="color: #64748b;">ADMIN</small>
                        </div>
                        <div style="width:40px; height:40px; background:var(--primary-color); border-radius:50%; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold;">P</div>
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
                    <div class="stat-card">
                        <div class="stat-info"><p>Total Inventory</p><h3><asp:Label ID="lblTotal" runat="server" Text="0"></asp:Label></h3></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info"><p>Out of Stock</p><h3><asp:Label ID="lblRestock" runat="server" Text="0"></asp:Label></h3></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info"><p>Low Threshold</p><h3><asp:Label ID="lblRestockSoon" runat="server" Text="0"></asp:Label></h3></div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-info"><p>Optimal Stock</p><h3><asp:Label ID="lblSafe" runat="server" Text="0"></asp:Label></h3></div>
                    </div>
                </div>

                <div class="panel">
                    <div class="panel-title">Administrative Tasks</div>
                    <button type="button" class="task-btn" onclick="openModal('addModal')"><i class="fas fa-plus-circle"></i> ADD NEW ITEM</button>
                    <button type="button" class="task-btn" onclick="openModal('updateModal')"><i class="fas fa-truck-loading"></i> UPDATE STOCK</button>
                    <button type="button" class="task-btn" onclick="openModal('reportModal')"><i class="fas fa-file-invoice"></i> MONTHLY REPORT</button>
                </div>

                <div class="panel">
                    <div class="panel-title">Inventory Master List</div>
                    <table class="custom-table">
                        <thead>
                            <tr>
                                <th>Item Name</th>
                                <th>Current Qty</th>
                                <th>Threshold</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater ID="rptInventory" runat="server">
                                <ItemTemplate>
                                    <tr>
                                        <td><strong><%# Eval("ItemName") %></strong></td>
                                        <td><%# Eval("Quantity") %></td>
                                        <td><%# Eval("QuantityThreshold") %></td>
                                        <td><%# GetStatusBadge(Eval("Quantity"), Eval("QuantityThreshold")) %></td>
                                        <td>
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandArgument='<%# Eval("ItemID") %>' OnClick="btnDelete_Click" OnClientClick="return confirm('Delete this item?');">
                                                <i class="fas fa-trash" style="color:#ef4444;"></i>
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div id="modalOverlay" style="display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; background:rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); align-items:center; justify-content:center;">
            
            <div id="addModal" class="modal-content" style="display:none; background:white; width:450px; padding:30px; border-radius:12px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);">
                <div style="text-align:center; margin-bottom:20px;">
                    <i class="fas fa-plus-circle" style="font-size:24px; color:#186420;"></i>
                    <h3 style="margin:0; font-weight:600; color:#1e293b;">Add New Product</h3>
                </div>
                <div style="margin-bottom:15px;">
                    <label style="display:block; font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; margin-bottom:5px;">Item Name</label>
                    <asp:TextBox ID="txtNewItemName" runat="server" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; box-sizing:border-box;"></asp:TextBox>
                </div>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:15px; margin-bottom:15px;">
                    <div>
                        <label style="display:block; font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; margin-bottom:5px;">Initial Qty</label>
                        <asp:TextBox ID="txtNewQty" runat="server" TextMode="Number" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; box-sizing:border-box;"></asp:TextBox>
                    </div>
                    <div>
                        <label style="display:block; font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; margin-bottom:5px;">Alert Threshold</label>
                        <asp:TextBox ID="txtNewThreshold" runat="server" TextMode="Number" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; box-sizing:border-box;"></asp:TextBox>
                    </div>
                </div>
                <div style="margin-bottom:20px;">
                    <label style="display:block; font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; margin-bottom:5px;">Unit Price (₹)</label>
                    <asp:TextBox ID="txtNewPrice" runat="server" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; box-sizing:border-box;"></asp:TextBox>
                </div>
                <div style="text-align:right; gap:10px; display:flex; justify-content:flex-end;">
                    <button type="button" onclick="closeAllModals()" style="padding:10px 20px; border-radius:8px; border:1px solid #cbd5e1; background:white; cursor:pointer;">Cancel</button>
                    <asp:Button ID="btnSaveItem" runat="server" Text="Save Product" OnClick="btnSaveNewItem_Click" style="padding:10px 20px; border-radius:8px; border:none; background:#186420; color:white; cursor:pointer; font-weight:600;" />
                </div>
            </div>

            <div id="updateModal" class="modal-content" style="display:none; background:white; width:450px; padding:30px; border-radius:12px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);">
                <div style="text-align:center; margin-bottom:20px;">
                    <i class="fas fa-truck-loading" style="font-size:24px; color:#186420;"></i>
                    <h3 style="margin:0; font-weight:600; color:#1e293b;">Update Stock Level</h3>
                </div>
                <div style="margin-bottom:15px;">
                    <label style="display:block; font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; margin-bottom:5px;">Select Item</label>
                    <asp:DropDownList ID="ddlItems" runat="server" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; box-sizing:border-box;"></asp:DropDownList>
                </div>
                <div style="margin-bottom:20px;">
                    <label style="display:block; font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; margin-bottom:5px;">Quantity to Add (+)</label>
                    <asp:TextBox ID="txtAddQty" runat="server" TextMode="Number" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; box-sizing:border-box;"></asp:TextBox>
                </div>
                <div style="text-align:right; gap:10px; display:flex; justify-content:flex-end;">
                    <button type="button" onclick="closeAllModals()" style="padding:10px 20px; border-radius:8px; border:1px solid #cbd5e1; background:white; cursor:pointer;">Cancel</button>
                    <asp:Button ID="btnUpdateStock" runat="server" Text="Update Stock" OnClick="btnUpdateStock_Click" style="padding:10px 20px; border-radius:8px; border:none; background:#186420; color:white; cursor:pointer; font-weight:600;" />
                </div>
            </div>

            <div id="reportModal" class="modal-content" style="display:none; background:white; width:400px; padding:30px; border-radius:12px; box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1);">
                <h3 style="color:#186420; margin-top:0;"><i class="fas fa-file-invoice"></i> Generate Report</h3>
                <hr style="border:0; border-top:1px solid #e2e8f0; margin:15px 0;" />
                <label style="display:block; font-size:12px; font-weight:600; color:#64748b; text-transform:uppercase; margin-bottom:5px;">Select Month</label>
                <asp:TextBox ID="txtReportMonth" runat="server" TextMode="Month" style="width:100%; padding:10px; border:1px solid #cbd5e1; border-radius:6px; box-sizing:border-box;"></asp:TextBox>
                <div style="text-align:right; margin-top:20px;">
                    <button type="button" onclick="closeAllModals()" style="padding:10px 20px; border-radius:8px; border:1px solid #cbd5e1; background:white; cursor:pointer;">Cancel</button>
                    <asp:Button ID="btnDownloadReport" runat="server" Text="Generate PDF" style="padding:10px 20px; border-radius:8px; border:none; background:#186420; color:white; cursor:pointer;" />
                </div>
            </div>
        </div>
    </form>

    <script>
        function toggleProfileMenu(e) {
            e.stopPropagation();
            document.getElementById("dropdownMenu").classList.toggle("show");
        }

        function openModal(modalId) {
            document.getElementById("modalOverlay").style.display = "flex";
            const modals = document.querySelectorAll('.modal-content');
            modals.forEach(m => m.style.display = "none");
            document.getElementById(modalId).style.display = "block";
        }

        function closeAllModals() {
            document.getElementById("modalOverlay").style.display = "none";
        }

        window.onclick = function(event) {
            var dropdown = document.getElementById("dropdownMenu");
            if (dropdown && dropdown.classList.contains('show')) {
                dropdown.classList.remove('show');
            }
            if (event.target == document.getElementById("modalOverlay")) {
                closeAllModals();
            }
        }
    </script>
</body>
</html>