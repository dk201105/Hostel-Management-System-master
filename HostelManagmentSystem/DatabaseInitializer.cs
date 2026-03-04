using System;
using System.Data.SqlClient;
using System.Configuration;

namespace HostelManagmentSystem
{
    public static class DatabaseInitializer
    {
        public static void Initialize()
        {
            string connString = ConfigurationManager.ConnectionStrings["WCC_DB"].ConnectionString;
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder(connString);

            // 1. Create Database if it doesn't exist
            string targetDbName = builder.InitialCatalog;
            builder.InitialCatalog = "master";

            using (SqlConnection conn = new SqlConnection(builder.ConnectionString))
            {
                conn.Open();
                string checkDbQuery = $"SELECT database_id FROM sys.databases WHERE Name = '{targetDbName}'";
                using (SqlCommand cmd = new SqlCommand(checkDbQuery, conn))
                {
                    if (cmd.ExecuteScalar() == null)
                    {
                        using (SqlCommand createCmd = new SqlCommand($"CREATE DATABASE {targetDbName}", conn))
                        {
                            createCmd.ExecuteNonQuery();
                        }
                    }
                }
            }

            // 2. Create All Tables
            CreateAllTables(connString);
        }

        private static void CreateAllTables(string connString)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();

                // --- 1. USERS TABLE ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE Users (
                            UserID INT IDENTITY(1,1) PRIMARY KEY,
                            FullName NVARCHAR(100) NOT NULL,
                            PasswordHash NVARCHAR(255) NOT NULL,
                            Role NVARCHAR(50) NOT NULL,
                            UserInfo NVARCHAR(MAX) NULL, -- Extra details
                            CreatedAt DATETIME DEFAULT GETDATE()
                        );

                        -- Insert Default Admin
                        INSERT INTO Users (FullName, Role, PasswordHash)
                        VALUES ('admin@wcc.edu.in', 'Administrator', 'admin123');
                    END");

                // --- 2. STUDENTS TABLE ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Students]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE Students (
                            StudentID INT IDENTITY(1,1) PRIMARY KEY,
                            StudentName NVARCHAR(100) NOT NULL,
                            Department NVARCHAR(100),
                            PhoneNumber NVARCHAR(20)
                        );
                    END");

                // --- 3. SUPPLIERS TABLE ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Suppliers]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE Suppliers (
                            CompanyID INT IDENTITY(1,1) PRIMARY KEY,
                            CompanyName NVARCHAR(100) NOT NULL,
                            CompanyContact NVARCHAR(50),
                            Address NVARCHAR(255),
                            GST NVARCHAR(50),
                            Email NVARCHAR(100)
                        );
                    END");

                // --- 4. ATTENDANCE TABLE (Links to Students) ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Attendance]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE Attendance (
                            AttendanceID INT IDENTITY(1,1) PRIMARY KEY,
                            StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
                            AttendanceDate DATE NOT NULL,
                            Status NVARCHAR(20) -- e.g., Present, Absent
                        );
                    END");

                // --- 5. ITEMS TABLE (Updated Category and removed Perishable/Expiry for your needs) ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Items]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE Items (
                            ItemID INT IDENTITY(1,1) PRIMARY KEY,
                            CompanyID INT FOREIGN KEY REFERENCES Suppliers(CompanyID),
                            ItemName NVARCHAR(100) NOT NULL,
                            ItemPrice DECIMAL(18, 2),
                            Quantity DECIMAL(18, 2),
                            QuantityThreshold DECIMAL(18, 2),
                            Category NVARCHAR(50) -- Changed from DATE to NVARCHAR
                        );
                    END
                    ELSE
                    BEGIN
                        -- If table exists, ensure Category is NVARCHAR (Fixes the previous schema error)
                        IF EXISTS (SELECT * FROM sys.columns WHERE name = 'Category' 
                                   AND object_id = OBJECT_ID('Items') 
                                   AND system_type_id = (SELECT system_type_id FROM sys.types WHERE name = 'date'))
                        BEGIN
                            ALTER TABLE Items ALTER COLUMN Category NVARCHAR(50);
                        END
                    END");

                        // --- 6. SEED INVENTORY ITEMS (Add this after table creation) ---
                        ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT 1 FROM Items WHERE ItemName = 'Toor Dal')
                    BEGIN
                        INSERT INTO Items (ItemName, Quantity, QuantityThreshold, Category) VALUES
                        ('Toor Dal', 0, 20, 'Grains'), ('Urad Dal', 0, 30, 'Grains'),
                        ('Moong Dal', 0, 10, 'Grains'), ('Bengal Gram', 0, 10, 'Grains'),
                        ('Black Channa', 0, 5, 'Grains'), ('Ground Nut', 0, 10, 'Grains'),
                        ('Green Gram', 0, 5, 'Grains'), ('Green Peas', 0, 5, 'Grains'),
                        ('Rava', 0, 10, 'Grains'), ('Wheat Flour', 0, 50, 'Flours'),
                        ('Maida', 0, 10, 'Flours'), ('Corn Flour', 0, 5, 'Flours'),
                        ('Chilli Powder', 0, 2, 'Masala Powders'), ('Coriander Powder', 0, 1, 'Masala Powders'),
                        ('Turmeric', 0, 2, 'Masala Powders'), ('Mustard', 0, 5, 'Spices'),
                        ('Fenugreek', 0, 2, 'Spices'), ('Fennel', 0, 2, 'Spices'),
                        ('Cumin', 0, 1, 'Spices'), ('Pepper', 0, 2, 'Spices'),
                        ('Cloves', 0, 0.5, 'Spices'), ('Dry Chilli', 0, 5, 'Spices'),
                        ('Pattai', 0, 0.5, 'Spices'), ('Annachi Poo', 0, 0.2, 'Spices'),
                        ('Elachi (Cardamom)', 0, 0.2, 'Spices'), ('Tomato Sauce', 0, 10, 'Sauces'),
                        ('Soya Sauce', 0, 5, 'Sauces'), ('Vim Bar', 0, 50, 'Detergents'),
                        ('Tide', 0, 50, 'Detergents'), ('Tamarind', 0, 10, 'Essentials'),
                        ('Coffee Powder', 0, 5, 'Essentials'), ('Tea Powder', 0, 10, 'Essentials'),
                        ('Garlic', 0, 10, 'Essentials'), ('Salt (table)', 0, 50, 'Essentials'),
                        ('Rock Salt', 0, 30, 'Essentials');
                    END");

                // --- 6. ORDERS TABLE (Links to Users) ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Orders]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE Orders (
                            OrderID INT IDENTITY(1,1) PRIMARY KEY,
                            UserID INT FOREIGN KEY REFERENCES Users(UserID),
                            OrderDate DATETIME DEFAULT GETDATE(),
                            DeliveryStatus NVARCHAR(50) -- e.g., Pending, Delivered
                        );
                    END");

                // --- 7. ORDER DETAILS TABLE (Links to Orders AND Items) ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderDetails]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE OrderDetails (
                            OrderDetailsID INT IDENTITY(1,1) PRIMARY KEY,
                            OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
                            ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
                            QuantityBought DECIMAL(18, 2)
                        );
                    END");
            }
        }

        // Helper method to keep code clean
        private static void ExecuteQuery(SqlConnection conn, string query)
        {
            using (SqlCommand cmd = new SqlCommand(query, conn))
            {
                cmd.ExecuteNonQuery();
            }
        }
    }
}