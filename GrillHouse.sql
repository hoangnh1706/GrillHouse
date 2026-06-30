

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'FoodStoreDB')
BEGIN
    CREATE DATABASE [FoodStoreDB]
END
GO
USE [FoodStoreDB]
GO

/****** Object:  Table [dbo].[Account]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[AccountID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](100) NOT NULL,
	[Email] [varchar](100) NOT NULL,
	[Phone] [varchar](15) NULL,
	[Password] [varchar](255) NOT NULL,
	[Address] [nvarchar](255) NULL,
	[Avatar] [varchar](255) NULL,
	[IsAdmin] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Category]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Category](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[ImageURL] [varchar](255) NULL,
	[IsActive] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[AccountID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[TotalAmount] [decimal](10, 2) NOT NULL,
	[DiscountAmount] [decimal](10, 2) NOT NULL,
	[FinalAmount]  AS ([TotalAmount]-[DiscountAmount]) PERSISTED,
	[ShipAddress] [nvarchar](255) NOT NULL,
	[Phone] [varchar](15) NOT NULL,
	[Note] [nvarchar](500) NULL,
	[Status] [tinyint] NOT NULL,
	[PaymentMethod] [nvarchar](50) NOT NULL,
	[IsPaid] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetail]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetail](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[Subtotal]  AS ([Quantity]*[UnitPrice]) PERSISTED,
PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[ProductName] [nvarchar](150) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[SalePrice] [decimal](10, 2) NULL,
	[ImageURL] [varchar](255) NULL,
	[Stock] [int] NOT NULL,
	[IsFeatured] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedAt] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Review]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Review](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[AccountID] [int] NOT NULL,
	[Rating] [tinyint] NOT NULL,
	[Comment] [nvarchar](500) NULL,
	[ReviewDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Account] ON 
GO
INSERT [dbo].[Account] ([AccountID], [FullName], [Email], [Phone], [Password], [Address], [Avatar], [IsAdmin], [IsActive], [CreatedAt]) VALUES (1, N'Admin Hệ Thống', N'admin@foodstore.vn', N'0901000001', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'123 Lê Lợi, Q1, TP.HCM', NULL, 1, 1, CAST(N'2026-06-02T18:13:03.340' AS DateTime))
GO
INSERT [dbo].[Account] ([AccountID], [FullName], [Email], [Phone], [Password], [Address], [Avatar], [IsAdmin], [IsActive], [CreatedAt]) VALUES (2, N'Nguyễn Văn Hưng', N'an.nv@gmail.com', N'0901000002', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'45 Nguyễn Trãi, Q5, TP.HCM', NULL, 0, 1, CAST(N'2026-06-02T18:13:03.340' AS DateTime))
GO
INSERT [dbo].[Account] ([AccountID], [FullName], [Email], [Phone], [Password], [Address], [Avatar], [IsAdmin], [IsActive], [CreatedAt]) VALUES (3, N'Trần Thị Bình', N'binh.tt@gmail.com', N'0901000003', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'78 Hoàng Diệu, Q4, TP.HCM', NULL, 0, 1, CAST(N'2026-06-02T18:13:03.340' AS DateTime))
GO
INSERT [dbo].[Account] ([AccountID], [FullName], [Email], [Phone], [Password], [Address], [Avatar], [IsAdmin], [IsActive], [CreatedAt]) VALUES (4, N'Lê Quang Cường', N'cuong.lq@gmail.com', N'0901000004', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'10 Đinh Tiên Hoàng, Q1, TP.HCM', NULL, 0, 1, CAST(N'2026-06-02T18:13:03.340' AS DateTime))
GO
INSERT [dbo].[Account] ([AccountID], [FullName], [Email], [Phone], [Password], [Address], [Avatar], [IsAdmin], [IsActive], [CreatedAt]) VALUES (5, N'Nguyễn Huy Hoàng', N'hoang17@gmail.com', N'0867463611', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'45 Nguyễn Trãi, Q5, TP.HCM', NULL, 0, 1, CAST(N'2026-06-05T00:11:58.493' AS DateTime))
GO
INSERT [dbo].[Account] ([AccountID], [FullName], [Email], [Phone], [Password], [Address], [Avatar], [IsAdmin], [IsActive], [CreatedAt]) VALUES (6, N'Le Duy Hung', N'hung@gmail.com', N'1234567890', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', N'45 Nguyễn Trãi, Q5, TP.HCM', NULL, 0, 1, CAST(N'2026-06-06T09:08:17.080' AS DateTime))
GO
INSERT [dbo].[Account] ([AccountID], [FullName], [Email], [Phone], [Password], [Address], [Avatar], [IsAdmin], [IsActive], [CreatedAt]) VALUES (7, N'Nguyen Van B', N'nguyenvanb@gmail.com', N'9012345678', N'8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', NULL, NULL, 0, 1, CAST(N'2026-06-19T00:36:16.890' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Account] OFF
GO
SET IDENTITY_INSERT [dbo].[Category] ON 
GO
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description], [ImageURL], [IsActive], [SortOrder]) VALUES (1, N'Vịt nướng', N'Các món vịt nướng đặc sản', NULL, 1, 1)
GO
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description], [ImageURL], [IsActive], [SortOrder]) VALUES (2, N'Thịt nướng', N'Bò, heo, gà nướng các loại', NULL, 1, 2)
GO
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description], [ImageURL], [IsActive], [SortOrder]) VALUES (3, N'Hải sản nướng', N'Tôm, mực, cá nướng tươi sống', NULL, 1, 3)
GO
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description], [ImageURL], [IsActive], [SortOrder]) VALUES (4, N'Combo', N'Combo tiết kiệm cho 2-4 người', NULL, 1, 4)
GO
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description], [ImageURL], [IsActive], [SortOrder]) VALUES (5, N'Nước uống', N'Nước giải khát, bia, nước ngọt', NULL, 1, 5)
GO
INSERT [dbo].[Category] ([CategoryID], [CategoryName], [Description], [ImageURL], [IsActive], [SortOrder]) VALUES (6, N'Khai vị', N'Món ăn khai vị, gỏi, salad', NULL, 1, 6)
GO
SET IDENTITY_INSERT [dbo].[Category] OFF
GO
SET IDENTITY_INSERT [dbo].[Order] ON 
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1, 2, CAST(N'2026-06-02T18:13:03.440' AS DateTime), CAST(490000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', NULL, 3, N'Tiền mặt', 1)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (2, 3, CAST(N'2026-06-02T18:13:03.440' AS DateTime), CAST(350000.00 AS Decimal(10, 2)), CAST(30000.00 AS Decimal(10, 2)), N'78 Hoàng Diệu, Q4, TP.HCM', N'0901000003', NULL, 2, N'VNPay', 1)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (3, 4, CAST(N'2026-06-02T18:13:03.440' AS DateTime), CAST(185000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'10 Đinh Tiên Hoàng, Q1, TP.HCM', N'0901000004', NULL, 0, N'Tiền mặt', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (4, 2, CAST(N'2026-06-02T18:13:03.440' AS DateTime), CAST(620000.00 AS Decimal(10, 2)), CAST(60000.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', NULL, 1, N'Momo', 1)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (5, 2, CAST(N'2026-06-04T23:12:26.887' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 4, N'Tiền mặt', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (6, 2, CAST(N'2026-06-04T23:12:54.050' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 1, N'Momo', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (7, 2, CAST(N'2026-06-04T23:25:56.390' AS DateTime), CAST(620000.00 AS Decimal(10, 2)), CAST(62000.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tiền mặt', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (8, 2, CAST(N'2026-06-04T23:26:12.923' AS DateTime), CAST(185000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 4, N'VNPay', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (9, 2, CAST(N'2026-06-04T23:45:00.853' AS DateTime), CAST(171000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tiền mặt', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (10, 2, CAST(N'2026-06-05T00:08:52.230' AS DateTime), CAST(185000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (11, 5, CAST(N'2026-06-05T14:18:41.680' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Momo', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (12, 5, CAST(N'2026-06-05T14:33:14.070' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (13, 5, CAST(N'2026-06-05T15:20:23.020' AS DateTime), CAST(15000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 3, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (14, 5, CAST(N'2026-06-05T15:21:33.583' AS DateTime), CAST(28000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (15, 1, CAST(N'2026-06-05T15:46:05.047' AS DateTime), CAST(320000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'123 Lê Lợi, Q1, TP.HCM', N'0901000001', N'', 3, N'VNPay', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (16, 1, CAST(N'2026-06-05T15:46:15.700' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'123 Lê Lợi, Q1, TP.HCM', N'0901000001', N'', 0, N'VNPay', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (17, 2, CAST(N'2026-06-05T16:14:23.380' AS DateTime), CAST(230000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (18, 2, CAST(N'2026-06-05T16:14:32.527' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'VNPay', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (19, 2, CAST(N'2026-06-05T16:19:15.940' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (20, 2, CAST(N'2026-06-05T16:19:15.973' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (21, 2, CAST(N'2026-06-05T16:36:03.457' AS DateTime), CAST(700000.00 AS Decimal(10, 2)), CAST(70000.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (22, 5, CAST(N'2026-06-05T17:40:23.790' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (23, 5, CAST(N'2026-06-05T17:43:36.637' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'Ha Noi', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (24, 5, CAST(N'2026-06-05T21:04:29.057' AS DateTime), CAST(165000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'Ha Noi', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (25, 2, CAST(N'2026-06-06T08:38:58.387' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (26, 6, CAST(N'2026-06-06T09:08:34.963' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'Hola', N'1234567890', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (27, 6, CAST(N'2026-06-06T11:06:29.640' AS DateTime), CAST(260000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'123 Lê Lợi, Q1, TP.HCM', N'1234567890', N'', 1, N'VNPay', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (28, 2, CAST(N'2026-06-06T15:17:39.853' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (29, 2, CAST(N'2026-06-07T08:33:56.113' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (30, 6, CAST(N'2026-06-10T10:51:16.110' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'1234567890', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1030, 6, CAST(N'2026-06-11T16:45:19.900' AS DateTime), CAST(180000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'1234567890', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1031, 5, CAST(N'2026-06-18T15:02:38.277' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1032, 5, CAST(N'2026-06-18T15:11:45.290' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1033, 2, CAST(N'2026-06-18T15:14:12.593' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1034, 5, CAST(N'2026-06-18T15:29:21.473' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1035, 5, CAST(N'2026-06-18T23:11:47.090' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 3, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1036, 5, CAST(N'2026-06-18T23:21:29.613' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1037, 5, CAST(N'2026-06-19T00:10:37.193' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 3, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1038, 5, CAST(N'2026-06-19T00:35:13.113' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0867463611', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1039, 2, CAST(N'2026-06-21T00:19:01.377' AS DateTime), CAST(145000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 3, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1040, 2, CAST(N'2026-06-21T08:00:46.510' AS DateTime), CAST(180000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 1, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1041, 2, CAST(N'2026-06-21T08:44:01.820' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'0901000002', N'', 3, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1042, 1, CAST(N'2026-06-23T14:05:53.040' AS DateTime), CAST(220000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'123 Lê Lợi, Q1, TP.HCM', N'0901000001', N'', 0, N'Tien mat', 0)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1043, 1, CAST(N'2026-06-23T14:33:39.237' AS DateTime), CAST(650000.00 AS Decimal(10, 2)), CAST(65000.00 AS Decimal(10, 2)), N'123 Lê Lợi, Q1, TP.HCM', N'098465321', N'ship hoa tốc nha', 0, N'VNPay', 1)
GO
INSERT [dbo].[Order] ([OrderID], [AccountID], [OrderDate], [TotalAmount], [DiscountAmount], [ShipAddress], [Phone], [Note], [Status], [PaymentMethod], [IsPaid]) VALUES (1044, 6, CAST(N'2026-06-23T14:50:30.103' AS DateTime), CAST(115000.00 AS Decimal(10, 2)), CAST(0.00 AS Decimal(10, 2)), N'45 Nguyễn Trãi, Q5, TP.HCM', N'1234567890', N'', 0, N'Tien mat', 0)
GO
SET IDENTITY_INSERT [dbo].[Order] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] ON 
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (5, 5, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (6, 6, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (7, 7, 13, 1, CAST(620000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (8, 8, 1, 1, CAST(185000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (9, 9, 15, 2, CAST(28000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (10, 9, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (11, 10, 1, 1, CAST(185000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (12, 11, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (13, 12, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (14, 13, 22, 1, CAST(15000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (15, 14, 15, 1, CAST(28000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (16, 15, 2, 1, CAST(320000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (17, 16, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (18, 17, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (19, 17, 8, 1, CAST(85000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (20, 18, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (21, 19, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (22, 20, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (23, 21, 1, 3, CAST(185000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (24, 21, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (25, 22, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (26, 23, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (27, 24, 11, 1, CAST(165000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (28, 25, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (29, 26, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (30, 27, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (31, 27, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (32, 28, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (33, 29, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (34, 30, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1034, 1030, 1, 1, CAST(180000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1035, 1031, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1036, 1032, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1037, 1033, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1038, 1034, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1039, 1035, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1040, 1036, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1041, 1037, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1042, 1038, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1043, 1039, 5, 1, CAST(145000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1044, 1040, 1, 1, CAST(180000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1045, 1041, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1046, 1042, 9, 1, CAST(220000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1047, 1043, 9, 2, CAST(220000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1048, 1043, 1, 1, CAST(180000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1049, 1043, 23, 1, CAST(30000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[OrderDetail] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [UnitPrice]) VALUES (1050, 1044, 7, 1, CAST(115000.00 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[OrderDetail] OFF
GO
SET IDENTITY_INSERT [dbo].[Product] ON 
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (1, 1, N'Vịt nướng (nửa con)', N'Vịt nướng vàng ươm, ướp mắm gừng đặc biệt, da giòn thịt mềm, ngọt lịm', CAST(185000.00 AS Decimal(10, 2)), CAST(180000.00 AS Decimal(10, 2)), N'/GrillHouse/images/vitnuong.jpg', 50, 1, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (2, 1, N'Vịt nướng  (nguyên con)', N'Vịt nướng nguyên con, phục vụ 3-4 người', CAST(350000.00 AS Decimal(10, 2)), CAST(320000.00 AS Decimal(10, 2)), N'/GrillHouse/images/vitnuong.jpg', 29, 1, 0, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (3, 1, N'Cánh vịt nướng sa tế', N'Cánh vịt nướng sa tế cay thơm, 4 cánh/phần', CAST(95000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/canhvitnuong.jpg', 80, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (4, 1, N'Đùi vịt nướng mật ong', N'Đùi vịt nướng mật ong thơm ngọt, 2 đùi/phần', CAST(120000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/dui-vit-sot-mat-ong-3.jpg', 60, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (5, 2, N'Sườn heo nướng BBQ', N'Sườn heo nguyên tảng nướng than hoa, sốt BBQ đậm đà', CAST(145000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/suonnuong.jpeg', 24, 1, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (6, 2, N'Bò nướng lá lốt', N'Thịt bò cuộn lá lốt nướng than, 8 cuộn/phần', CAST(110000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/bo_la_lot.jpg', 60, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (7, 2, N'Gà nướng muối ớt', N'Gà ta nướng muối ớt, nửa con', CAST(130000.00 AS Decimal(10, 2)), CAST(115000.00 AS Decimal(10, 2)), N'/GrillHouse/images/ga-nuong-muoi-ot.jpg', 20, 1, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (8, 2, N'Lòng heo nướng', N'Lòng heo tươi nướng than, kèm rau sống', CAST(85000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/long-heo-nuong.jpg', 49, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (9, 3, N'Tôm sú nướng muối ớt', N'Tôm sú size lớn nướng muối ớt, 500g/phần', CAST(220000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/tom-nuong-muoi-ot.jpg', 22, 1, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (10, 3, N'Mực nướng sa tế', N'Mực ống tươi nướng sa tế, 400g/phần', CAST(180000.00 AS Decimal(10, 2)), CAST(160000.00 AS Decimal(10, 2)), N'/GrillHouse/images/muc-nuong-sa-te.png', 30, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (11, 3, N'Cá lóc nướng trui', N'Cá lóc đồng nướng trui, kèm bánh tráng rau sống', CAST(165000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/ca-loc-nuong-trui.jpg', 19, 1, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (12, 4, N'Combo Đôi (2 người)', N'1 nửa vịt nướng + 1 sườn heo BBQ + 2 lon bia', CAST(380000.00 AS Decimal(10, 2)), CAST(350000.00 AS Decimal(10, 2)), N'/GrillHouse/images/combo2nguoi.png', 20, 1, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (13, 4, N'Combo Gia Đình (4 người)', N'1 nguyên vịt + 1 gà nướng + 4 lon bia + 1 rau sống', CAST(680000.00 AS Decimal(10, 2)), CAST(629000.00 AS Decimal(10, 2)), N'/GrillHouse/images/combo4nguoi.png', 14, 1, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (14, 5, N'Bia Tiger (lon)', N'Bia Tiger 330ml lon', CAST(22000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/bia_tiger.png', 200, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (15, 5, N'Bia Heineken (lon)', N'Bia Heineken 330ml lon', CAST(28000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/bia-heineken-.jpg', 147, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (16, 5, N'Nước ngọt Coca Cola', N'Coca Cola 330ml lon lạnh', CAST(15000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/coca.jpg', 300, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (17, 5, N'Trà đá tự pha', N'Trà đá miễn phí kèm đơn từ 200k', CAST(0.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/Tra-Da.jpg', 999, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (18, 6, N'Gỏi vịt bắp chuối', N'Gỏi vịt trộn bắp chuối, rau răm, đậu phộng', CAST(75000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/cach-lam-goi-vit-bap-chuoi-1.jpg', 40, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (19, 6, N'Đậu hũ chiên mắm', N'Đậu hũ chiên vàng, chấm mắm tỏi ớt', CAST(45000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/dauhuchien.jpg', 60, 0, 1, CAST(N'2026-06-02T18:13:03.400' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (20, 6, N'Khoai tây chiên', N'Khoai tây chiên giòn rụm, kèm tương ớt', CAST(35000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/khoai_tay_chien.jpg', 50, 0, 1, CAST(N'2026-06-04T22:25:13.350' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (21, 6, N'Salad hoàng đế', N'Rau trộn tươi sốt đặc biệt', CAST(55000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/salad.jpg', 30, 0, 1, CAST(N'2026-06-04T22:25:13.350' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (22, 6, N'Phồng tôm', N'Bánh phồng tôm giòn ăn kèm', CAST(15000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/phongtom.jpg', 99, 0, 1, CAST(N'2026-06-04T22:25:13.350' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (23, 5, N'Nước ép trái cây', N'Nước ép trái cây tươi nguyên chất theo mùa', CAST(30000.00 AS Decimal(10, 2)), NULL, N'/GrillHouse/images/tratraicay.jpeg', 39, 0, 1, CAST(N'2026-06-04T22:25:13.350' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (24, 3, N'Cá nướng', N'', CAST(20000000.00 AS Decimal(10, 2)), NULL, N'', 50, 0, 0, CAST(N'2026-06-05T21:06:03.537' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (25, 5, N'Pesi', N'Phù hợp cho những món cay va nóng', CAST(45000.00 AS Decimal(10, 2)), NULL, N'', 10, 1, 0, CAST(N'2026-06-11T16:47:40.330' AS DateTime))
GO
INSERT [dbo].[Product] ([ProductID], [CategoryID], [ProductName], [Description], [Price], [SalePrice], [ImageURL], [Stock], [IsFeatured], [IsActive], [CreatedAt]) VALUES (26, 1, N'Cánh vịt nướng sa tế', N'', CAST(56700000.00 AS Decimal(10, 2)), NULL, N'', 50, 0, 0, CAST(N'2026-06-19T09:08:12.203' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Product] OFF
GO
SET IDENTITY_INSERT [dbo].[Review] ON 
GO
INSERT [dbo].[Review] ([ReviewID], [ProductID], [AccountID], [Rating], [Comment], [ReviewDate]) VALUES (1, 1, 2, 5, N'Vịt nướng cực ngon, da giòn, thịt mềm, ướp đậm đà, sẽ quay lại!', CAST(N'2026-06-02T18:13:03.520' AS DateTime))
GO
INSERT [dbo].[Review] ([ReviewID], [ProductID], [AccountID], [Rating], [Comment], [ReviewDate]) VALUES (2, 1, 3, 4, N'Ngon nhưng hơi mặn, lần sau nhắn giảm muối. Giao hàng nhanh!', CAST(N'2026-06-02T18:13:03.520' AS DateTime))
GO
INSERT [dbo].[Review] ([ReviewID], [ProductID], [AccountID], [Rating], [Comment], [ReviewDate]) VALUES (3, 5, 2, 5, N'Đồ ăn ngon, giao hàng nhanh, cho 10 sao', CAST(N'2026-06-02T18:13:03.520' AS DateTime))
GO
INSERT [dbo].[Review] ([ReviewID], [ProductID], [AccountID], [Rating], [Comment], [ReviewDate]) VALUES (4, 9, 4, 4, N'Tôm tươi, size lớn như quảng cáo. Giá hơi cao nhưng chất lượng xứng đáng', CAST(N'2026-06-02T18:13:03.520' AS DateTime))
GO
INSERT [dbo].[Review] ([ReviewID], [ProductID], [AccountID], [Rating], [Comment], [ReviewDate]) VALUES (5, 5, 5, 3, N'hay', CAST(N'2026-06-19T08:53:06.310' AS DateTime))
GO
INSERT [dbo].[Review] ([ReviewID], [ProductID], [AccountID], [Rating], [Comment], [ReviewDate]) VALUES (6, 7, 2, 4, N'idesune', CAST(N'2026-06-19T08:53:47.577' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[Review] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Account__A9D10534AB4DF043]    Script Date: 6/25/2026 2:24:26 PM ******/
ALTER TABLE [dbo].[Account] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ_Review_Once]    Script Date: 6/25/2026 2:24:26 PM ******/
ALTER TABLE [dbo].[Review] ADD  CONSTRAINT [UQ_Review_Once] UNIQUE NONCLUSTERED 
(
	[ProductID] ASC,
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((0)) FOR [IsAdmin]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Category] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Category] ADD  DEFAULT ((0)) FOR [SortOrder]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT ((0)) FOR [TotalAmount]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT ((0)) FOR [DiscountAmount]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT ((0)) FOR [Status]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT (N'Tiền mặt') FOR [PaymentMethod]
GO
ALTER TABLE [dbo].[Order] ADD  DEFAULT ((0)) FOR [IsPaid]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT ((0)) FOR [IsFeatured]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Product] ADD  DEFAULT (getdate()) FOR [CreatedAt]
GO
ALTER TABLE [dbo].[Review] ADD  DEFAULT (getdate()) FOR [ReviewDate]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([AccountID])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Account]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OD_Order] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Order] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OD_Order]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD  CONSTRAINT [FK_OD_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[OrderDetail] CHECK CONSTRAINT [FK_OD_Product]
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD  CONSTRAINT [FK_Product_Category] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Category] ([CategoryID])
GO
ALTER TABLE [dbo].[Product] CHECK CONSTRAINT [FK_Product_Category]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_Review_Account] FOREIGN KEY([AccountID])
REFERENCES [dbo].[Account] ([AccountID])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Account]
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD  CONSTRAINT [FK_Review_Product] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[Review] CHECK CONSTRAINT [FK_Review_Product]
GO
ALTER TABLE [dbo].[OrderDetail]  WITH CHECK ADD CHECK  (([Quantity]>(0)))
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD CHECK  (([Price]>=(0)))
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD CHECK  (([SalePrice]>=(0)))
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD CHECK  (([Stock]>=(0)))
GO
ALTER TABLE [dbo].[Review]  WITH CHECK ADD CHECK  (([Rating]>=(1) AND [Rating]<=(5)))
GO
/****** Object:  StoredProcedure [dbo].[sp_CreateOrder]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP: Đặt hàng (Transaction an toàn)
CREATE PROCEDURE [dbo].[sp_CreateOrder]
    @AccountID     INT,
    @ShipAddress   NVARCHAR(255),
    @Phone         VARCHAR(15),
    @Note          NVARCHAR(500),
    @PaymentMethod NVARCHAR(50),
    @CartXML       XML              -- Truyền giỏ hàng dạng XML: <items><item pid="1" qty="2" price="185000"/></items>
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Tính tổng tiền từ XML giỏ hàng
        DECLARE @Total DECIMAL(10,2);
        SELECT @Total = SUM(
            item.value('@qty', 'INT') * item.value('@price', 'DECIMAL(10,2)')
        )
        FROM @CartXML.nodes('/items/item') AS T(item);

        -- Giảm giá 10% nếu đơn >= 500k
        DECLARE @Discount DECIMAL(10,2) = 0;
        IF @Total >= 500000 SET @Discount = @Total * 0.1;

        -- Tạo đơn hàng
        DECLARE @OrderID INT;
        INSERT INTO [Order] (AccountID, TotalAmount, DiscountAmount, ShipAddress, Phone, Note, PaymentMethod)
        VALUES (@AccountID, @Total, @Discount, @ShipAddress, @Phone, @Note, @PaymentMethod);
        SET @OrderID = SCOPE_IDENTITY();

        -- Tạo chi tiết đơn hàng & trừ kho
        INSERT INTO OrderDetail (OrderID, ProductID, Quantity, UnitPrice)
        SELECT @OrderID,
               item.value('@pid',   'INT'),
               item.value('@qty',   'INT'),
               item.value('@price', 'DECIMAL(10,2)')
        FROM @CartXML.nodes('/items/item') AS T(item);

        -- Trừ tồn kho
        UPDATE p SET p.Stock = p.Stock - od.Quantity
        FROM Product p
        JOIN OrderDetail od ON p.ProductID = od.ProductID
        WHERE od.OrderID = @OrderID;

        COMMIT TRANSACTION;
        SELECT @OrderID AS NewOrderID;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_SearchProducts]    Script Date: 6/25/2026 2:24:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- SP: Tìm kiếm món ăn theo tên
CREATE PROCEDURE [dbo].[sp_SearchProducts]
    @Keyword NVARCHAR(100)
AS
BEGIN
    SELECT p.ProductID, p.ProductName, p.Price, p.SalePrice, p.ImageURL,
           c.CategoryName
    FROM Product p
    JOIN Category c ON p.CategoryID = c.CategoryID
    WHERE p.IsActive = 1
      AND p.ProductName LIKE N'%' + @Keyword + N'%'
    ORDER BY p.IsFeatured DESC;
END;
GO
