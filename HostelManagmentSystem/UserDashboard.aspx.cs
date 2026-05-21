using System;
using System.Data;
using System.Net;
using System.Data.SqlClient;
using System.Web;
using System.Configuration;
using System.Web.UI.WebControls;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;



namespace HostelManagmentSystem
{
    public partial class UserDashboard : System.Web.UI.Page
    {
        // Ensure "WCC_DB" in web.config points to WCC_Inventory database
        string connString = ConfigurationManager.ConnectionStrings["WCC_DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["FullName"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                string fullName = Session["FullName"].ToString();
                lblFullName.Text = fullName;

                // NEW LOGIC: Extract the first letter and make it Uppercase
                if (!string.IsNullOrEmpty(fullName))
                {
                    litUserInitial.Text = fullName.Substring(0, 1).ToUpper();
                }

                LoadStats();
                LoadInventory();
            }
        }

        private void SendAutomatedWhatsApp(string itemName, decimal remainingQty)
        {
            // 1. Your Twilio Credentials
            string accountSid = "AC90099bd76e3803b95a5d734aa5eba423".Trim();
            string authToken = "e083cd8305008111f584603b31614de1".Trim();

            TwilioClient.Init(accountSid, authToken);

            try
            {
                var message = MessageResource.Create(
                    // This is the Twilio Sandbox Number
                    from: new PhoneNumber("whatsapp:+14155238886"),

                    // Your Admin Mobile Number
                    to: new PhoneNumber("whatsapp:+918300013213"),

                    body: $"🚨 *INVENTORY ALERT*\n\nItem: {itemName}\nStatus: LOW STOCK\nRemaining: {remainingQty}\n\n_Update sent from WCC Mess Inventory System_"
                );

                System.Diagnostics.Debug.WriteLine("Twilio SID: " + message.Sid);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("=== TWILIO ERROR ===");
                System.Diagnostics.Debug.WriteLine(ex.Message);
                System.Diagnostics.Debug.WriteLine(ex.StackTrace);
            }

        }

        protected string GetBadgeClass(object qty, object threshold)
        {
            if (qty == DBNull.Value || threshold == DBNull.Value) return "badge-grey";

            decimal q = Convert.ToDecimal(qty);
            decimal t = Convert.ToDecimal(threshold);

            if (q <= 0) return "badge-red";
            if (q <= t) return "badge-yellow";
            return "badge-green";
        }

        protected void btnUpdateRecord_Click(object sender, EventArgs e)
        {
            lblError.Text = "";

            if (string.IsNullOrEmpty(hfSelectedItemID.Value) || string.IsNullOrEmpty(txtAmountUsed.Text))
            {
                lblError.Text = "Please select an item first.";
                return;
            }

            if (string.IsNullOrEmpty(txtDateUsed.Text))
            {
                lblError.Text = "Please select a date.";
                return;
            }

            DateTime dateUsed = DateTime.Parse(txtDateUsed.Text);
            string itemId = hfSelectedItemID.Value;
            string itemName = lblSelectedItem.Text;
            decimal amountUsed = decimal.Parse(txtAmountUsed.Text);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // 1. Check current quantity
                string checkQuery = "SELECT Quantity FROM Items WHERE ItemID = @ID";
                SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                checkCmd.Parameters.AddWithValue("@ID", itemId);
                decimal currentQty = Convert.ToDecimal(checkCmd.ExecuteScalar() ?? 0);

                if (amountUsed > currentQty)
                {
                    lblError.Text = $"Error: Only {currentQty} units available!";
                    SendAutomatedWhatsApp(itemName + " (OUT OF STOCK)", 0);
                    return;
                }

                // 2. Update quantity and get new values
                string query = @"UPDATE Items SET Quantity = Quantity - @Used 
                         OUTPUT INSERTED.Quantity, INSERTED.QuantityThreshold
                         WHERE ItemID = @ID";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Used", amountUsed);
                cmd.Parameters.AddWithValue("@ID", itemId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        decimal newQty = Convert.ToDecimal(reader["Quantity"]);
                        decimal threshold = Convert.ToDecimal(reader["QuantityThreshold"]);

                        if (newQty <= threshold && newQty > 0)
                        {
                            SendAutomatedWhatsApp(itemName + " (Low Stock)", newQty);
                        }
                        else if (newQty <= 0)
                        {
                            SendAutomatedWhatsApp(itemName + " (OUT OF STOCK)", 0);
                        }
                    }
                } // closes SqlDataReader

                // 3. Log the transaction
                string logQuery = @"INSERT INTO InventoryTransactions 
                            (ItemID, ItemName, ChangeAmount, TransactionDate, TransactionType) 
                            VALUES (@ID, @Name, @Amount, @Date, 'Usage')";

                SqlCommand logCmd = new SqlCommand(logQuery, conn);
                logCmd.Parameters.AddWithValue("@ID", itemId);
                logCmd.Parameters.AddWithValue("@Name", itemName);
                logCmd.Parameters.AddWithValue("@Amount", -amountUsed);
                logCmd.Parameters.AddWithValue("@Date", dateUsed);
                logCmd.ExecuteNonQuery();

            } // closes SqlConnection

            Response.Redirect("UserDashboard.aspx");

        } // closes btnUpdateRecord_Click

        protected void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Revised query to calculate status on the fly based on Quantity vs QuantityThreshold
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
                    lblSafe.Text = reader["Safe"] == DBNull.Value ? "0" : reader["Safe"].ToString();
                    lblRestockSoon.Text = reader["Soon"] == DBNull.Value ? "0" : reader["Soon"].ToString();
                    lblRestock.Text = reader["Restock"] == DBNull.Value ? "0" : reader["Restock"].ToString();
                }
            }
        }

      
        protected void LoadInventory()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Updated table name to 'Items' as per your schema
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Items", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                rptItems.DataSource = dt;
                rptItems.DataBind();
            }
        }

        protected void rptItems_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                int itemId = Convert.ToInt32(e.CommandArgument);
                hfSelectedItemID.Value = itemId.ToString();

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    // Updated table name to 'Items'
                    SqlCommand cmd = new SqlCommand("SELECT ItemName FROM Items WHERE ItemID=@ID", conn);
                    cmd.Parameters.AddWithValue("@ID", itemId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        lblSelectedItem.Text = result.ToString();
                    }
                }
            }
        }


        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            // 1. Clear all session variables
            Session.Clear();

            // 2. Abandon the current session to destroy it on the server
            Session.Abandon();

            // 3. Force the browser to expire the session cookie
            Response.Cookies.Add(new System.Web.HttpCookie("ASP.NET_SessionId", ""));

            // 4. Send the user back to the login page
            Response.Redirect("Login.aspx");
        }
    }
}