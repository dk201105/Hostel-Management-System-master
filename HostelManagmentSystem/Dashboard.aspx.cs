using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.Layout.Properties;
using iText.Kernel.Geom;

namespace HostelManagmentSystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["WCC_DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if the Admin is logged in
                if (Session["FullName"] != null)
                {
                    string fullName = Session["FullName"].ToString();

                    // 1. Set the Full Name Label
                    lblAdminName.Text = fullName;

                    // 2. Extract the first letter for the Initial Circle
                    if (!string.IsNullOrEmpty(fullName))
                    {
                        litAdminInitial.Text = fullName.Substring(0, 1).ToUpper();
                    }
                }
                else
                {
                    // If no session, send back to login
                    Response.Redirect("Login.aspx");
                }

                BindDropdown();
                LoadStats();
                LoadInventory();
            }
        }

        protected string GetStatusBadge(object qty, object threshold)
        {
            if (qty == DBNull.Value || threshold == DBNull.Value)
                return "<span class='status-badge'>Unknown</span>";

            decimal q = Convert.ToDecimal(qty);
            decimal t = Convert.ToDecimal(threshold);

            if (q <= 0)
                return "<span class='status-badge status-critical'>Out of Stock</span>";
            if (q <= t)
                return "<span class='status-badge status-low'>Low Stock</span>";

            return "<span class='status-badge status-good'>Safe</span>";
        }

        protected void btnDownloadReport_Click(object sender, EventArgs e)
        {
            string selectedMonth = txtReportMonth.Text;
            if (string.IsNullOrEmpty(selectedMonth)) return;

            Response.Clear();
            Response.ContentType = "application/pdf";
            Response.AddHeader("content-disposition", $"attachment;filename=WCC_Report_{selectedMonth}.pdf");

            using (iText.Kernel.Pdf.PdfWriter writer = new iText.Kernel.Pdf.PdfWriter(Response.OutputStream))
            {
                using (iText.Kernel.Pdf.PdfDocument pdf = new iText.Kernel.Pdf.PdfDocument(writer))
                {
                    iText.Layout.Document document = new iText.Layout.Document(pdf, iText.Kernel.Geom.PageSize.A4);

                    // Header - Using a bold font explicitly to bypass SetBold errors
                    iText.Kernel.Font.PdfFont boldFont = iText.Kernel.Font.PdfFontFactory.CreateFont(iText.IO.Font.Constants.StandardFonts.HELVETICA_BOLD);

                    document.Add(new iText.Layout.Element.Paragraph("WOMEN'S CHRISTIAN COLLEGE")
                        .SetFont(boldFont)
                        .SetFontSize(18)
                        .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER));

                    document.Add(new iText.Layout.Element.Paragraph("Hostel Mess Monthly Inventory Report")
                        .SetFontSize(14)
                        .SetTextAlignment(iText.Layout.Properties.TextAlignment.CENTER));

                    // Table setup
                    iText.Layout.Element.Table table = new iText.Layout.Element.Table(iText.Layout.Properties.UnitValue.CreatePercentArray(new float[] { 4, 2, 2, 2 })).UseAllAvailableWidth();

                    // Header Cells
                    table.AddHeaderCell(new Cell().Add(new Paragraph("Item Name").SetFont(boldFont)));
                    table.AddHeaderCell(new Cell().Add(new Paragraph("Qty Used").SetFont(boldFont)));
                    table.AddHeaderCell(new Cell().Add(new Paragraph("Unit Price (₹)").SetFont(boldFont)));
                    table.AddHeaderCell(new Cell().Add(new Paragraph("Date").SetFont(boldFont)));

                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        string query = @"SELECT t.ItemName, ABS(t.ChangeAmount) as Quantity, 
                                   t.TransactionType, t.TransactionDate,
                                   ISNULL(i.ItemPrice, 0) as ItemPrice
                            FROM InventoryTransactions t
                            LEFT JOIN Items i ON t.ItemID = i.ItemID
                            WHERE FORMAT(t.TransactionDate, 'yyyy-MM') = @Month";

                        SqlCommand cmd = new SqlCommand(query, conn);  
                        cmd.Parameters.AddWithValue("@Month", selectedMonth);  
                        conn.Open();  
                        SqlDataReader reader = cmd.ExecuteReader();  

                        while (reader.Read())
                        {
                            table.AddCell(new Paragraph(reader["ItemName"].ToString()));
                            table.AddCell(new Paragraph(reader["Quantity"].ToString()));
                            table.AddCell(new Paragraph(reader["ItemPrice"] != DBNull.Value
                                ? "₹" + Convert.ToDecimal(reader["ItemPrice"]).ToString("0.00")
                                : "N/A"));
                            table.AddCell(new Paragraph(Convert.ToDateTime(reader["TransactionDate"]).ToString("dd/MM/yyyy")));
                        }

                    }

                    document.Add(table);
                    document.Close();
                }
            }
            Response.End();
        }

        protected void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"
                    SELECT 
                        COUNT(*) as Total,
                        SUM(CASE WHEN Quantity > QuantityThreshold THEN 1 ELSE 0 END) as Safe,
                        SUM(CASE WHEN Quantity <= QuantityThreshold AND Quantity > 0 THEN 1 ELSE 0 END) as Soon,
                        SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) as Restock
                    FROM Items";

                SqlCommand cmd = new SqlCommand(query, conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblTotal.Text = reader["Total"].ToString();
                    lblSafe.Text = reader["Safe"]?.ToString() ?? "0";
                    lblRestockSoon.Text = reader["Soon"]?.ToString() ?? "0";
                    lblRestock.Text = reader["Restock"]?.ToString() ?? "0";
                }
            }
        }

        // Consolidated Update Stock Method
        protected void btnUpdateStock_Click(object sender, EventArgs e)
        {
            if (ddlItems.SelectedValue == "0" || string.IsNullOrEmpty(txtAddQty.Text)) return;

            int itemId = int.Parse(ddlItems.SelectedValue);

            if (!decimal.TryParse(txtAddQty.Text, out decimal addedQty) || addedQty < 0.01m)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert",
                    "alert('Please enter a valid quantity (minimum 0.01).');", true);
                return;
            }

            string itemName = ddlItems.SelectedItem.Text;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // 1. Update master quantity
                    string updateQuery = "UPDATE Items SET Quantity = ISNULL(Quantity, 0) + @AddedQty WHERE ItemID = @ID";
                    SqlCommand cmd1 = new SqlCommand(updateQuery, conn, trans);
                    cmd1.Parameters.AddWithValue("@AddedQty", addedQty);
                    cmd1.Parameters.AddWithValue("@ID", itemId);
                    cmd1.ExecuteNonQuery();

                    // 2. Record the transaction with the DATE
                    string logQuery = @"INSERT INTO InventoryTransactions (ItemID, ItemName, ChangeAmount, TransactionType) 
                                VALUES (@ID, @Name, @Amount, 'Stock Add')";
                    SqlCommand cmd2 = new SqlCommand(logQuery, conn, trans);
                    cmd2.Parameters.AddWithValue("@ID", itemId);
                    cmd2.Parameters.AddWithValue("@Name", itemName);
                    cmd2.Parameters.AddWithValue("@Amount", addedQty);
                    cmd2.ExecuteNonQuery();

                    trans.Commit();
                }
                catch { trans.Rollback(); }
            }
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int itemId = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "DELETE FROM Items WHERE ItemID = @ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", itemId);

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("Dashboard.aspx");
        }

        // Consolidated Save New Item Method

        protected void btnSaveNewItem_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNewItemName.Text)) return;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO Items (ItemName, Quantity, QuantityThreshold, ItemPrice, Category) 
                         VALUES (@Name, @Qty, @Threshold, @Price, @Category)";

                SqlCommand cmd = new SqlCommand(query, conn);

                // 1. Get the Threshold
                decimal threshold = decimal.TryParse(txtNewThreshold.Text, out decimal t) ? t : 0;

                // 2. Get the Qty, but DEFAULT to threshold if Qty is 0 or empty
                decimal initialQty = decimal.TryParse(txtNewQty.Text, out decimal q) ? q : 0;
                if (initialQty == 0)
                {
                    initialQty = threshold;
                }

                cmd.Parameters.AddWithValue("@Name", txtNewItemName.Text.Trim());
                cmd.Parameters.AddWithValue("@Qty", initialQty);
                cmd.Parameters.AddWithValue("@Threshold", threshold);
                cmd.Parameters.AddWithValue("@Price", decimal.TryParse(txtNewPrice.Text, out decimal p) ? p : 0);
                cmd.Parameters.AddWithValue("@Category", DateTime.Now.ToString("yyyy-MM-dd"));

                conn.Open();
                cmd.ExecuteNonQuery();
            }
            Response.Redirect("Dashboard.aspx");
        }

        protected void LoadInventory()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Items", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (rptInventory != null)
                {
                    rptInventory.DataSource = dt;
                    rptInventory.DataBind();
                }
            }
        }

        private void BindDropdown()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT ItemID, ItemName FROM Items ORDER BY ItemName ASC";
                SqlCommand cmd = new SqlCommand(query, conn);

                conn.Open();
                ddlItems.DataSource = cmd.ExecuteReader();
                ddlItems.DataTextField = "ItemName";
                ddlItems.DataValueField = "ItemID";
                ddlItems.DataBind();

                ddlItems.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select Item --", "0"));
            }
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}