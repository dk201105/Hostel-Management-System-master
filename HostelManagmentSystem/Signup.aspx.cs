using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Drawing; // For changing label colors
using System.Web.UI;

namespace HostelManagmentSystem
{
    public partial class Signup : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["WCC_DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Clear message on load
            lblMessage.Text = "";
        }

        protected void btnSignup_Click(object sender, EventArgs e)
        {
            // 1. Get values from the HTML page
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();  
            string password = txtPassword.Text.Trim();
            string confirmPass = txtConfirmPassword.Text.Trim();
            string role = ddlRole.SelectedValue;

            // 2. Basic Validation
            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "All fields are required.";
                lblMessage.ForeColor = Color.Red;
                return;
            }

            if (password != confirmPass)
            {
                lblMessage.Text = "Passwords do not match.";
                lblMessage.ForeColor = Color.Red;
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    // 3. Check if Email already exists in the 'Users' table (stored in UserInfo)
                    string checkQuery = "SELECT COUNT(*) FROM Users WHERE UserInfo = @UserInfo";
                    SqlCommand checkCmd = new SqlCommand(checkQuery, conn);
                    checkCmd.Parameters.AddWithValue("@UserInfo", email);

                    int count = (int)checkCmd.ExecuteScalar();

                    if (count > 0)
                    {
                        lblMessage.Text = "This email is already registered.";
                        lblMessage.ForeColor = Color.Red;
                        return;
                    }

                    // 4. Insert new user into 'Users' table
                    string insertQuery = "INSERT INTO Users (FullName, PasswordHash, Role, UserInfo) VALUES (@FullName, @Password, @Role, @UserInfo)";

                    SqlCommand cmd = new SqlCommand(insertQuery, conn);
                    cmd.Parameters.AddWithValue("@FullName", fullName);
                    cmd.Parameters.AddWithValue("@Password", password); // ideally hash this
                    cmd.Parameters.AddWithValue("@Role", role);
                    cmd.Parameters.AddWithValue("@UserInfo", email);

                    cmd.ExecuteNonQuery();

                    // 5. Success
                    lblMessage.Text = "Account created successfully!";
                    lblMessage.ForeColor = Color.Green;

                    // Redirect to Login page so they can sign in
                    Response.Redirect("Login.aspx");
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error: " + ex.Message;
                lblMessage.ForeColor = Color.Red;
            }
        }
    }
}