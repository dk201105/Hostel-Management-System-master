using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

namespace HostelManagmentSystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["WCC_DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
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
                    lblSafe.Text = reader["Safe"].ToString() ?? "0";
                    lblRestockSoon.Text = reader["Soon"].ToString() ?? "0";
                    lblRestock.Text = reader["Restock"].ToString() ?? "0";
                }
            }
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            // Get the ItemID from the CommandArgument of the clicked button
            LinkButton btn = (LinkButton)sender;
            int itemId = Convert.ToInt32(btn.CommandArgument);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // SQL query to remove the item from the Items table
                string query = "DELETE FROM Items WHERE ItemID = @ID";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@ID", itemId);

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // Refresh the page to show the updated list
            Response.Redirect("Dashboard.aspx");
        }

        protected void btnSaveNewItem_Click(object sender, EventArgs e)
        {
            // Validate inputs
            if (string.IsNullOrWhiteSpace(txtNewItemName.Text)) return;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // SQL Insert statement matching your schema
                string query = @"INSERT INTO Items (ItemName, Quantity, QuantityThreshold, ItemPrice, Category) 
                         VALUES (@Name, @Qty, @Threshold, @Price, @Date)";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Name", txtNewItemName.Text.Trim());
                cmd.Parameters.AddWithValue("@Qty", decimal.Parse(txtNewQty.Text));
                cmd.Parameters.AddWithValue("@Threshold", decimal.Parse(txtNewThreshold.Text));
                cmd.Parameters.AddWithValue("@Price", decimal.Parse(txtNewPrice.Text));
                cmd.Parameters.AddWithValue("@Date", DateTime.Now); // Setting current date for Category column

                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }

            // Refresh the page to show the new item in the list and update stats
            Response.Redirect("Dashboard.aspx");
        }

        protected void LoadInventory()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Items", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptItems.DataSource = dt;
                rptItems.DataBind();
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}