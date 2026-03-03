using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI;

namespace HostelManagmentSystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["FullName"] != null)
            {
                // If they are already logged in, check role and redirect
                if (Session["UserRole"].ToString() == "Admin")
                    Response.Redirect("Dashboard.aspx");
                else
                    Response.Redirect("UserDashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string FullName = txtFullName.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connString = ConfigurationManager.ConnectionStrings["WCC_DB"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // UPDATED QUERY: We select the 'Role' instead of just counting rows
                string query = "SELECT Role FROM Users WHERE FullName=@FullName AND PasswordHash=@Password";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@FullName", FullName);
                    cmd.Parameters.AddWithValue("@Password", password);

                    // ExecuteScalar returns the Role (e.g., "Admin" or "User") if found, or null if failed
                    object result = cmd.ExecuteScalar();

                    if (result != null)
                    {
                        string role = result.ToString();

                        // Save both FullName and Role in Session
                        Session["FullName"] = FullName;
                        Session["UserRole"] = role;

                        // REDIRECT BASED ON ROLE
                        if (role == "Admin")
                        {
                            Response.Redirect("Dashboard.aspx"); // Admin Dashboard
                        }
                        else
                        {
                            Response.Redirect("UserDashboard.aspx"); // User Dashboard
                        }
                    }
                    else
                    {
                        lblMessage.Text = "Invalid credentials. Please try again.";
                        lblMessage.Visible = true;
                    }
                }
            }
        }
    }
}