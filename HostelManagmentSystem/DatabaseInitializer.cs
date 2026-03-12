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

                // --- 5. ITEMS TABLE (Updated to match Dashboard.aspx.cs) ---
                ExecuteQuery(conn, @"
                    IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Items]') AND type in (N'U'))
                    BEGIN
                        CREATE TABLE Items (
                            ItemID INT IDENTITY(1,1) PRIMARY KEY,
                            CompanyID INT NULL, -- Made NULL because Dashboard doesn't provide it yet
                            ItemName NVARCHAR(100) NOT NULL,
                            ItemPrice DECIMAL(18, 2),
                            Quantity DECIMAL(18, 2),
                            Unit NVARCHAR(20),
                            QuantityThreshold DECIMAL(18, 2),
                            Category NVARCHAR(100), -- Added this to match your Dashboard.aspx.cs
                        );
                    END");
               
                // --- 6. SEED INVENTORY ITEMS (Add this after table creation) ---
                ExecuteQuery(conn, @"
                    IF (SELECT COUNT(*) FROM Items) = 0
                    BEGIN
                        INSERT INTO Items (ItemName, QuantityThreshold, Unit, Category, Quantity) VALUES
                        -- GRAINS & DALS
                        ('Toor Dal', 20, 'kg', 'Grains/Dals', 0), ('Urad Dal', 30, 'kg', 'Grains/Dals', 0),
                        ('Moong Dal', 10, 'kg', 'Grains/Dals', 0), ('Bengal Gram', 10, 'kg', 'Grains/Dals', 0),
                        ('Black Channa', 5, 'kg', 'Grains/Dals', 0), ('Ground Nut', 10, 'kg', 'Grains/Dals', 0),
                        ('Green Gram', 5, 'kg', 'Grains/Dals', 0), ('Green Peas', 5, 'kg', 'Grains/Dals', 0),
                        ('Rava', 10, 'kg', 'Grains/Dals', 0), ('Boiled Rice', 30, 'kg', 'Grains/Dals', 0), 
                        ('Idly Rice', 30, 'kg', 'Grains/Dals', 0), ('Raw Rice', 30, 'kg', 'Grains/Dals', 0),
                        
                        -- FLOURS
                        ('Wheat Flour', 50, 'kg', 'Flour', 0), ('Maida', 10, 'kg', 'Flour', 0),
                        ('Corn Flour', 5, 'kg', 'Flour', 0), ('Bengal Gram Flour', 5, 'kg', 'Flour', 0),
                        ('Rice Flour', 5, 'kg', 'Flour', 0),
                        
                        -- MASALA POWDERS
                        ('Chilli Powder', 2, 'kg', 'Masala', 0), ('Coriander Powder', 1, 'kg', 'Masala', 0),
                        ('Turmeric', 2, 'kg', 'Masala', 0), ('Chicken Masala', 1, 'kg', 'Masala', 0),
                        ('Kuzhambu Masala', 1, 'kg', 'Masala', 0), ('Biriyani Masala', 1, 'kg', 'Masala', 0),
                        ('Sambar Powder', 2, 'kg', 'Masala', 0), ('Fried Gram', 2, 'kg', 'Masala', 0), 
                        ('Dhania', 2, 'kg', 'Masala', 0), 

                        
                        -- SPICES & SEEDS
                        ('Mustard', 5, 'kg', 'Spices', 0), ('Fenugreek', 2, 'kg', 'Spices', 0),
                        ('Fennel', 2, 'kg', 'Spices', 0), ('Cumin', 1, 'kg', 'Spices', 0),
                        ('Pepper', 2, 'kg', 'Spices', 0), ('Cloves', 0.5, 'kg', 'Spices', 0),
                        ('Dry Chilli', 5, 'kg', 'Spices', 0), ('Pattai', 0.5, 'kg', 'Spices', 0),
                        ('Annachi Poo', 0.2, 'kg', 'Spices', 0), ('Elachi (Cardamom)', 0.2, 'kg', 'Spices', 0),
                        ('Jadhi Pathri', 2, 'kg', 'Spices', 0), ('LG Powder', 10, 'units', 'Spices', 0),
                        ('LG Rock', 10, 'boxes', 'Spices', 0), ('Marathi Mooku', 10, 'boxes', 'Spices', 0),
                        
                        -- DRY FRUIT
                        ('Cashew Powder', 2, 'kg', 'Dry Fruits', 0), ('Dry Grapes', 0.5, 'kg', 'Dry Fruits', 0),
                        ('Cashew Nut', 0.5, 'kg', 'Dry Fruits', 0),
                        
                        -- SAUCES & LIQUIDS
                        ('Tomato Sauce', 10, 'bottles', 'Sauces', 0), ('Soya Sauce', 5, 'bottles', 'Sauces', 0),
                        ('Vinegar', 5, 'bottles', 'Sauces', 0), ('Chilli Sauce', 5, 'bottles', 'Sauces', 0),
                        
                        -- CLEANING
                        ('Vim Bar', 50, 'units', 'Detergent', 0), ('Tide', 50, 'units', 'Detergent', 0), ('EXO Scrub', 50, 'units', 'Detergent', 0),
                        
                        -- ESSENTIALS
                        ('Tamarind', 10, 'kg', 'Essentials', 0), ('Appalam', 5, 'kg/pcs', 'Essentials', 0),
                        ('Coffee Powder', 5, 'kg', 'Beverages', 0), ('Tea Powder', 10, 'kg', 'Beverages', 0),
                        ('Garlic', 10, 'kg', 'Veggies', 0), ('Table Salt', 50, 'kg', 'Essentials', 0), 
                        ('Sugar', 50, 'kg', 'Essentials', 0), ('Rock Salt', 30, 'kg', 'Essentials', 0), ('Coconut Oil', 50, 'L', 'Essentials', 0), 
                        ('Oil', 50, 'L', 'Essentials', 0), ('Gingelly Oil', 30, 'L', 'Essentials', 0), ('Ghee', 30, 'L', 'Essentials', 0);
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