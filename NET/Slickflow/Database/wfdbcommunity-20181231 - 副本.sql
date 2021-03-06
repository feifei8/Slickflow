USE [WfDBCommunity]
GO
/****** Object:  StoredProcedure [dbo].[pr_com_QuerySQLPaged]    Script Date: 01/01/2019 20:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Stored Procedure

create PROCEDURE  [dbo].[pr_com_QuerySQLPaged]      
     @Query nvarchar(MAX), --SQL语句    
     @PageSize int, --每页大小   
     @CurrentPage  int ,  --当前页码   
     @Field nvarchar(40)='', --排序字段   
     @Order nvarchar(10) = 'asc ' --排序顺序   
AS    
    declare @PageCount int,
	        @TempSize int,    
			@TempNum int,  
			@strSQL varchar(max),
			@strField varchar(40),   
			@strFielddesc varchar(40),
			@Tempindex int 

    --0,1都做第一页处理
	if (@currentPage = 0)
		set @currentPage = 1

    set @TempNum = @CurrentPage * @PageSize    
	set @strField = ''
	set @strFielddesc = ''

	--计算总页数
	declare @strCountSQL nvarchar(MAX)
	set @strCountSQL = 'SELECT @total=COUNT(1) FROM (' + @Query + ')T'

	--总记录数
	DECLARE @rowsCount int
	DECLARE @params nvarchar(500)
	SET @params = '@total int OUTPUT'
	EXEC sp_executesql @strCountSQL, @params, @total=@rowsCount OUTPUT

	--根据总记录数，计算页数
	SET @PageCount = ceiling(convert(float, @rowsCount) / convert(float, @PageSize))

	--超过最后一页，显示尾页
    if(@CurrentPage>=@PageCount)    
        set @TempSize=@rowsCount-(@PageCount-1)*@PageSize    
    else  
        set @TempSize=@PageSize  

	SET @Tempindex=Charindex('projcode',@Query,0)
    if( @Tempindex>0 and @Tempindex<Charindex('from',@Query,0))
	begin
		if(@Field<>'' and @Field<>'projcode')
		begin
			set @strField = ',projcode ';
			set	@strFielddesc =',projcode desc ';
		end 
	end 

	--分页SQL
    if(@Order='desc')    
    begin    
      set @strSQL = '
            select *   
            from (   
                    select top '+CONVERT(varchar(10),@TempSize)+' *   
                    from (  
                            select top '+CONVERT(varchar(10),@TempNum)+' *   
                            from ('+@Query+') as t0   
                            order by '+@Field+' desc '+@strField+'  
                    ) as t1   
                    order by '+@Field+@strFielddesc+' 
            ) as t2   
            order by '+@Field+' desc' +@strField   
    end    
    else    
    begin    
      set @strSQL = '
            select *   
            from (  
                    select top '+CONVERT(varchar(10),@TempSize)+' *   
                    from (  
                            select top '+ CONVERT(varchar(10), @TempNum ) + ' *   
                            from ('+@Query+') as t0  
                            order by '+@Field+' asc '+@strField +'
                    ) as t1   
                    order by '+@Field+' desc  '+@strFielddesc+' 
            ) as t2   
            order by '+@Field +@strField  
    end  
    exec(@strSQL)
GO
/****** Object:  Table [dbo].[ManProductOrder]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ManProductOrder](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[OrderCode] [varchar](30) NULL,
	[Status] [smallint] NULL,
	[ProductName] [nvarchar](100) NULL,
	[Quantity] [int] NULL,
	[UnitPrice] [decimal](18, 2) NULL,
	[TotalPrice] [decimal](18, 2) NULL,
	[CreatedTime] [datetime] NULL,
	[CustomerName] [nvarchar](50) NULL,
	[Address] [nvarchar](100) NULL,
	[Mobile] [varchar](30) NULL,
	[Remark] [nvarchar](1000) NULL,
	[LastUpdatedTime] [datetime] NULL,
 CONSTRAINT [PK_MADPRODUCTORDER] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[ManProductOrder] ON
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (675, N'TB324384', 8, N'遥控灯D型', 5, CAST(1000.00 AS Decimal(18, 2)), CAST(5000.00 AS Decimal(18, 2)), CAST(0x0000A72900F8491F AS DateTime), N'BBC', N'英国伦敦', N'739538', N'C店', CAST(0x0000A72901008DCD AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (676, N'TB726224', 8, N'遥控灯D型', 6, CAST(1000.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), CAST(0x0000A73C01596C4E AS DateTime), N'汇丰银行', N'上海人民广场', N'693433', N'B店', CAST(0x0000A73C0159E025 AS DateTime))
INSERT [dbo].[ManProductOrder] ([ID], [OrderCode], [Status], [ProductName], [Quantity], [UnitPrice], [TotalPrice], [CreatedTime], [CustomerName], [Address], [Mobile], [Remark], [LastUpdatedTime]) VALUES (677, N'TB359770', 3, N'海盗船F型', 6, CAST(1000.00 AS Decimal(18, 2)), CAST(6000.00 AS Decimal(18, 2)), CAST(0x0000A845015C7030 AS DateTime), N'花旗银行', N'上海浦东新区', N'419544', N'C店', CAST(0x0000A845015D0899 AS DateTime))
SET IDENTITY_INSERT [dbo].[ManProductOrder] OFF
/****** Object:  Table [dbo].[HrsLeaveOpinion]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[HrsLeaveOpinion](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ActivityID] [varchar](50) NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[ChangedTime] [datetime] NOT NULL,
	[ChangedUserID] [int] NOT NULL,
	[ChangedUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_HRSLEAVEOPINION] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[HrsLeave]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HrsLeave](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[LeaveType] [smallint] NOT NULL,
	[Days] [decimal](18, 1) NOT NULL,
	[FromDate] [date] NOT NULL,
	[ToDate] [date] NOT NULL,
	[CurrentActivityText] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[CreatedUserID] [int] NOT NULL,
	[CreatedUserName] [nvarchar](50) NOT NULL,
	[CreatedDate] [date] NOT NULL,
	[DepManagerRemark] [nvarchar](50) NULL,
	[DirectorRemark] [nvarchar](50) NULL,
	[DeputyGeneralRemark] [nvarchar](50) NULL,
	[GeneralManagerRemark] [nvarchar](50) NULL,
 CONSTRAINT [PK_HRLEAVE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假天数' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'Days'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假开始时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'FromDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假结束时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'ToDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'正在办理的节点' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CurrentActivityText'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N' /// <summary>
           /// 未启动，流程记录为空
           /// </summary>
           NotStart = 0,
   
           /// <summary>
           /// 准备状态
           /// </summary>
           Ready = 1,
   
           /// <summary>
           /// 运行状态
           /// </summary>
           Running = 2,
   
           /// <summary>
           /// 完成
           /// </summary>
           Completed = 4,
   
           /// <summary>
           /// 挂起
           /// </summary>
           Suspended = 5,
   
           /// <summary>
           /// 取消
           /// </summary>
           Canceled = 6,
   
           /// <summary>
           /// 终止
           /// </summary>
           Discarded = 7' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedUserID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'请假人名称' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedUserName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'申请日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'HrsLeave', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
SET IDENTITY_INSERT [dbo].[HrsLeave] ON
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (12, 2, CAST(1.0 AS Decimal(18, 1)), CAST(0x843C0B00 AS Date), CAST(0x853C0B00 AS Date), N'人事经理审批', 0, 6, N'路天明', CAST(0x843C0B00 AS Date), N'同意', N'', N'', N'')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (13, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x913C0B00 AS Date), CAST(0x933C0B00 AS Date), N'人事经理审批', 0, 6, N'路天明', CAST(0x913C0B00 AS Date), N'AGREE', N'', N'', N'')
INSERT [dbo].[HrsLeave] ([ID], [LeaveType], [Days], [FromDate], [ToDate], [CurrentActivityText], [Status], [CreatedUserID], [CreatedUserName], [CreatedDate], [DepManagerRemark], [DirectorRemark], [DeputyGeneralRemark], [GeneralManagerRemark]) VALUES (14, 2, CAST(2.0 AS Decimal(18, 1)), CAST(0x973C0B00 AS Date), CAST(0x993C0B00 AS Date), N'人事经理审批', 0, 6, N'路天明', CAST(0x973C0B00 AS Date), N'tongyi', N'', N'', N'')
SET IDENTITY_INSERT [dbo].[HrsLeave] OFF
/****** Object:  UserDefinedFunction [dbo].[fn_com_SplitString]    Script Date: 01/01/2019 20:39:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fn_com_SplitString] ( @stringToSplit nvarchar(4000) )
RETURNS
 @returnList TABLE ([ID] int)
AS
BEGIN

 DECLARE @name NVARCHAR(255)
 DECLARE @pos INT

 WHILE CHARINDEX(',', @stringToSplit) > 0
 BEGIN
  SELECT @pos  = CHARINDEX(',', @stringToSplit)  
  SELECT @name = SUBSTRING(@stringToSplit, 1, @pos-1)
  

  INSERT INTO @returnList 
  SELECT CONVERT(INT,  @name)

  SELECT @stringToSplit = SUBSTRING(@stringToSplit, @pos+1, LEN(@stringToSplit)-@pos)
 END

 INSERT INTO @returnList
 SELECT @stringToSplit

 RETURN
END
GO
/****** Object:  Table [dbo].[BizAppFlow]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BizAppFlow](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[AppInstanceCode] [varchar](50) NULL,
	[Status] [varchar](10) NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[Remark] [nvarchar](1000) NULL,
	[ChangedTime] [datetime] NOT NULL,
	[ChangedUserID] [varchar](50) NOT NULL,
	[ChangedUserName] [nvarchar](50) NULL,
 CONSTRAINT [PK_SALWALLWAORDERFLOW] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[BizAppFlow] ON
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (113, N'流程发起', N'3', NULL, NULL, N'流程发起', N'mssqlserver申请人:6-普通员工-小明', CAST(0x0000A4F500DC22C7 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (114, N'生产订单', N'624', N'TB300427', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010C6DBA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (115, N'生产订单', N'625', N'TB906432', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010C92A0 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (116, N'生产订单', N'626', N'TB338322', NULL, N'派单', N'完成派单', CAST(0x0000A4F5010CA251 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (117, N'生产订单', N'627', N'TB612344', NULL, N'派单', N'完成派单', CAST(0x0000A4F5014DA236 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (118, N'生产订单', N'628', N'TB683061', NULL, N'派单', N'完成派单', CAST(0x0000A4F5014DAB96 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (119, N'生产订单', N'628', N'TB683061', NULL, N'打样', N'完成打样', CAST(0x0000A4F5014DC627 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (120, N'生产订单', N'627', N'TB612344', NULL, N'打样', N'完成打样', CAST(0x0000A4F5014DCFC6 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (121, N'生产订单', N'627', N'TB612344', NULL, N'生产', N'完成生产', CAST(0x0000A4F700D56961 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (122, N'生产订单', N'631', N'TB490683', NULL, N'派单', N'完成派单', CAST(0x0000A4F900FBE434 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (123, N'生产订单', N'630', N'TB351094', NULL, N'派单', N'完成派单', CAST(0x0000A4FC016B0F5F AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (124, N'生产订单', N'632', N'TB366615', NULL, N'派单', N'完成派单', CAST(0x0000A4FF00F6BDB6 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (125, N'生产订单', N'634', N'TB969829', NULL, N'派单', N'完成派单', CAST(0x0000A4FF00F6C6CD AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (126, N'生产订单', N'633', N'TB751853', NULL, N'派单', N'完成派单', CAST(0x0000A4FF0181C823 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (127, N'生产订单', N'639', N'TB792242', NULL, N'派单', N'完成派单', CAST(0x0000A5000117A5C8 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (128, N'生产订单', N'639', N'TB792242', NULL, N'打样', N'完成打样', CAST(0x0000A501008BED22 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (129, N'生产订单', N'640', N'TB429545', NULL, N'派单', N'完成派单', CAST(0x0000A50A010D8B79 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (130, N'生产订单', N'641', N'TB817384', NULL, N'派单', N'完成派单', CAST(0x0000A50B00B381FA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (131, N'生产订单', N'644', N'TB348804', NULL, N'派单', N'完成派单', CAST(0x0000A50B00DCCBEB AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (132, N'生产订单', N'643', N'TB351670', NULL, N'派单', N'完成派单', CAST(0x0000A50B00DCD1CD AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (133, N'生产订单', N'646', N'TB992099', NULL, N'派单', N'完成派单', CAST(0x0000A50B00E44F16 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (134, N'生产订单', N'648', N'TB588606', NULL, N'派单', N'完成派单', CAST(0x0000A50B00EAF847 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (135, N'生产订单', N'642', N'TB434232', NULL, N'派单', N'完成派单', CAST(0x0000A50C0120B5EA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (136, N'生产订单', N'647', N'TB285386', NULL, N'派单', N'完成派单', CAST(0x0000A50F00A2DEAE AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (137, N'生产订单', N'652', N'TB991726', NULL, N'派单', N'完成派单', CAST(0x0000A51001628464 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (138, N'生产订单', N'652', N'TB991726', NULL, N'打样', N'完成打样', CAST(0x0000A5100162D19D AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (139, N'生产订单', N'652', N'TB991726', NULL, N'生产', N'完成生产', CAST(0x0000A510016319E3 AS DateTime), N'10', N'跟单员-李杰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (140, N'生产订单', N'651', N'TB728743', NULL, N'派单', N'完成派单', CAST(0x0000A513010AF607 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (141, N'生产订单', N'650', N'TB328175', NULL, N'派单', N'完成派单', CAST(0x0000A513010AFA75 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (142, N'流程发起', N'4', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52B012C1E90 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (143, N'流程发起', N'5', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52C0091FF62 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (144, N'流程发起', N'6', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A52C010A2086 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (145, N'请假流程', N'6', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A52C01153273 AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (146, N'生产订单', N'659', N'TB710707', NULL, N'派单', N'完成派单', CAST(0x0000A578013DAC71 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (147, N'生产订单', N'658', N'TB575859', NULL, N'派单', N'完成派单', CAST(0x0000A57801501892 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (148, N'生产订单', N'659', N'TB710707', NULL, N'打样', N'完成打样', CAST(0x0000A57801503093 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (149, N'生产订单', N'657', N'TB358232', NULL, N'派单', N'完成派单', CAST(0x0000A5780167A1AD AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (150, N'生产订单', N'656', N'TB779780', NULL, N'派单', N'完成派单', CAST(0x0000A57A01211907 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (151, N'生产订单', N'655', N'TB322602', NULL, N'派单', N'完成派单', CAST(0x0000A57C014BF2A2 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (152, N'生产订单', N'654', N'TB271916', NULL, N'派单', N'完成派单', CAST(0x0000A57C014D273A AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (153, N'生产订单', N'654', N'TB271916', NULL, N'打样', N'完成打样', CAST(0x0000A57C014D8A62 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (154, N'生产订单', N'653', N'TB559248', NULL, N'派单', N'完成派单', CAST(0x0000A57D012BCA76 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (155, N'生产订单', N'649', N'TB771229', NULL, N'派单', N'完成派单', CAST(0x0000A57D014D0D3C AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (158, N'生产订单', N'645', N'TB642095', NULL, N'派单', N'完成派单', CAST(0x0000A57D016233C7 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (159, N'生产订单', N'660', N'TB967961', NULL, N'派单', N'完成派单', CAST(0x0000A57D0162ECB4 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (160, N'生产订单', N'661', N'TB751700', NULL, N'派单', N'完成派单', CAST(0x0000A57D01648298 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (161, N'生产订单', N'661', N'TB751700', NULL, N'打样', N'完成打样', CAST(0x0000A57D01649AEE AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (162, N'生产订单', N'661', N'TB751700', NULL, N'生产', N'完成生产', CAST(0x0000A57D0164B2E1 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (163, N'生产订单', N'661', N'TB751700', NULL, N'质检', N'完成质检', CAST(0x0000A57D0164C7F0 AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (164, N'生产订单', N'661', N'TB751700', NULL, N'称重', N'完成称重', CAST(0x0000A57D01657E79 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (165, N'生产订单', N'661', N'TB751700', NULL, N'发货', N'完成发货', CAST(0x0000A57D016593FC AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (166, N'生产订单', N'652', N'TB991726', NULL, N'派单', N'完成派单', CAST(0x0000A57E014A4DF8 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (167, N'生产订单', N'662', N'TB647767', NULL, N'派单', N'完成派单', CAST(0x0000A57E0169A99B AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (168, N'生产订单', N'638', N'TB561443', NULL, N'派单', N'完成派单', CAST(0x0000A57F013BE354 AS DateTime), N'8', N'业务员-小宋')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (169, N'生产订单', N'663', N'TB809544', NULL, N'派单', N'完成派单', CAST(0x0000A57F013C7377 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (170, N'生产订单', N'664', N'TB914891', NULL, N'派单', N'完成派单', CAST(0x0000A57F013CE48D AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (171, N'生产订单', N'665', N'TB929075', NULL, N'派单', N'完成派单', CAST(0x0000A57F014515AA AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (172, N'生产订单', N'666', N'TB225725', NULL, N'派单', N'完成派单', CAST(0x0000A57F0146F53B AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (173, N'生产订单', N'667', N'TB164370', NULL, N'派单', N'完成派单', CAST(0x0000A57F014779F2 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (174, N'生产订单', N'667', N'TB164370', NULL, N'打样', N'完成打样', CAST(0x0000A57F0147D7EC AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (175, N'生产订单', N'667', N'TB164370', NULL, N'生产', N'完成生产', CAST(0x0000A57F0147EF54 AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (176, N'生产订单', N'667', N'TB164370', NULL, N'质检', N'完成质检', CAST(0x0000A57F0148008F AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (177, N'生产订单', N'667', N'TB164370', NULL, N'称重', N'完成称重', CAST(0x0000A57F01481487 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (178, N'生产订单', N'667', N'TB164370', NULL, N'发货', N'完成发货', CAST(0x0000A57F01483D30 AS DateTime), N'16', N'包装员-小威')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (179, N'流程发起', N'7', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5B700B21B49 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (180, N'请假流程', N'7', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A5B700B252AE AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (181, N'请假流程', N'7', NULL, NULL, N'总经理审批', N'总经理-陈(ID:1) 同意', CAST(0x0000A5B700B27226 AS DateTime), N'1', N'总经理-陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (182, N'请假流程', N'7', NULL, NULL, N'人事经理审批', N'人事经理-李小姐(ID:4) ', CAST(0x0000A5B700B28A14 AS DateTime), N'4', N'人事经理-李小姐')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (183, N'流程发起', N'8', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5B700B38A15 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (184, N'请假流程', N'8', NULL, NULL, N'部门经理审批', N'部门经理-张(ID:5) 同意', CAST(0x0000A5B700B3AAF1 AS DateTime), N'5', N'部门经理-张')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (185, N'生产订单', N'669', N'TB747473', NULL, N'派单', N'完成派单', CAST(0x0000A5B700B3E831 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (186, N'生产订单', N'669', N'TB747473', NULL, N'打样', N'完成打样', CAST(0x0000A5B700B3FCE9 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (187, N'生产订单', N'670', N'TB630627', NULL, N'派单', N'完成派单', CAST(0x0000A5B700B44E62 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (188, N'生产订单', N'670', N'TB630627', NULL, N'打样', N'完成打样', CAST(0x0000A5B700B46695 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (189, N'生产订单', N'670', N'TB630627', NULL, N'生产', N'完成生产', CAST(0x0000A5B700B47ECE AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (190, N'生产订单', N'670', N'TB630627', NULL, N'质检', N'完成质检', CAST(0x0000A5B700B493A5 AS DateTime), N'13', N'质检员-杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (191, N'生产订单', N'670', N'TB630627', NULL, N'称重', N'完成称重', CAST(0x0000A5B700B4A808 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (192, N'生产订单', N'670', N'TB630627', NULL, N'发货', N'完成发货', CAST(0x0000A5B700B4C4D8 AS DateTime), N'15', N'包装员-大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (193, N'生产订单', N'671', N'TB165916', NULL, N'派单', N'完成派单', CAST(0x0000A5C5009C0E1E AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (194, N'流程发起', N'9', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500A0D72F AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (195, N'流程发起', N'10', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500B43CBB AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (196, N'流程发起', N'11', NULL, NULL, N'流程发起', N'申请人:6-普通员工-小明', CAST(0x0000A5C500FE9389 AS DateTime), N'6', N'普通员工-小明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (197, N'生产订单', N'673', N'TB508950', NULL, N'派单', N'完成派单', CAST(0x0000A61300EE9CA7 AS DateTime), N'7', N' 业务员-小陈')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (198, N'生产订单', N'673', N'TB508950', NULL, N'打样', N'完成打样', CAST(0x0000A61300EEB976 AS DateTime), N'11', N'打样员-飞雨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (199, N'生产订单', N'673', N'TB508950', NULL, N'生产', N'完成生产', CAST(0x0000A61300EED70C AS DateTime), N'9', N'跟单员-张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (200, N'生产订单', N'674', N'TB760538', NULL, N'派单', N'完成派单', CAST(0x0000A6320100EBD7 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (201, N'生产订单', N'674', N'TB760538', NULL, N'生产', N'完成生产', CAST(0x0000A6320112805C AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (202, N'生产订单', N'672', N'TB247595', NULL, N'派单', N'完成派单', CAST(0x0000A67D015B8A25 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (203, N'生产订单', N'668', N'TB885696', NULL, N'派单', N'完成派单', CAST(0x0000A72900F7E12C AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (204, N'生产订单', N'675', N'TB324384', NULL, N'派单', N'完成派单', CAST(0x0000A72900F8541C AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (205, N'生产订单', N'675', N'TB324384', NULL, N'打样', N'完成打样', CAST(0x0000A72900FEA7FD AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (206, N'生产订单', N'675', N'TB324384', NULL, N'生产', N'完成生产', CAST(0x0000A729010052AD AS DateTime), N'9', N'张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (207, N'生产订单', N'675', N'TB324384', NULL, N'质检', N'完成质检', CAST(0x0000A72901006C05 AS DateTime), N'13', N'杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (208, N'生产订单', N'675', N'TB324384', NULL, N'称重', N'完成称重', CAST(0x0000A72901007EE5 AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (209, N'生产订单', N'675', N'TB324384', NULL, N'发货', N'完成发货', CAST(0x0000A72901008DCD AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (210, N'流程发起', N'12', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A7290103EC77 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (211, N'请假流程', N'12', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) 同意', CAST(0x0000A72901040C66 AS DateTime), N'5', N'张恒丰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (212, N'请假流程', N'12', NULL, NULL, N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A72901043923 AS DateTime), N'4', N'李颖')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (213, N'流程发起', N'13', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A73600E34BD1 AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (214, N'请假流程', N'13', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) AGREE', CAST(0x0000A73600E3664D AS DateTime), N'5', N'张恒丰')
GO
print 'Processed 100 total records'
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (215, N'请假流程', N'13', NULL, NULL, N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A73600E378AA AS DateTime), N'4', N'李颖')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (216, N'流程发起', N'14', NULL, NULL, N'流程发起', N'申请人:6-路天明', CAST(0x0000A73C015910FA AS DateTime), N'6', N'路天明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (217, N'请假流程', N'14', NULL, NULL, N'部门经理审批', N'张恒丰(ID:5) tongyi', CAST(0x0000A73C015936AB AS DateTime), N'5', N'张恒丰')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (218, N'请假流程', N'14', NULL, NULL, N'人事经理审批', N'李颖(ID:4) ', CAST(0x0000A73C01594D9B AS DateTime), N'4', N'李颖')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (219, N'生产订单', N'676', N'TB726224', NULL, N'派单', N'完成派单', CAST(0x0000A73C015989E9 AS DateTime), N'7', N'陈盖茨')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (220, N'生产订单', N'676', N'TB726224', NULL, N'打样', N'完成打样', CAST(0x0000A73C01599B57 AS DateTime), N'11', N'飞羽')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (221, N'生产订单', N'676', N'TB726224', NULL, N'生产', N'完成生产', CAST(0x0000A73C0159AC0D AS DateTime), N'9', N'张明')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (222, N'生产订单', N'676', N'TB726224', NULL, N'质检', N'完成质检', CAST(0x0000A73C0159BD9F AS DateTime), N'13', N'杰米')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (223, N'生产订单', N'676', N'TB726224', NULL, N'称重', N'完成称重', CAST(0x0000A73C0159D00F AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (224, N'生产订单', N'676', N'TB726224', NULL, N'发货', N'完成发货', CAST(0x0000A73C0159E025 AS DateTime), N'15', N'大汉')
INSERT [dbo].[BizAppFlow] ([ID], [AppName], [AppInstanceID], [AppInstanceCode], [Status], [ActivityName], [Remark], [ChangedTime], [ChangedUserID], [ChangedUserName]) VALUES (225, N'生产订单', N'677', N'TB359770', NULL, N'派单', N'完成派单', CAST(0x0000A845015D0897 AS DateTime), N'7', N'陈盖茨')
SET IDENTITY_INSERT [dbo].[BizAppFlow] OFF
/****** Object:  Table [dbo].[WfTransitionInstance]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfTransitionInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TransitionGUID] [varchar](100) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[TransitionType] [tinyint] NOT NULL,
	[FlyingType] [tinyint] NOT NULL,
	[FromActivityInstanceID] [int] NOT NULL,
	[FromActivityGUID] [varchar](100) NOT NULL,
	[FromActivityType] [smallint] NOT NULL,
	[FromActivityName] [nvarchar](50) NOT NULL,
	[ToActivityInstanceID] [int] NOT NULL,
	[ToActivityGUID] [varchar](100) NOT NULL,
	[ToActivityType] [smallint] NOT NULL,
	[ToActivityName] [nvarchar](50) NOT NULL,
	[ConditionParseResult] [tinyint] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfTransitionInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfTransitionInstance] ON
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1425, N'9cf01621-2dd5-474a-8889-cdbe53a0b72e', N'SamplePrice', N'SEQ-P-1099', 994, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2526, N'9b78486d-5b8f-4be4-948e-522356e84e79', 1, N'开始', 2527, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 1, N'10', N'Long', CAST(0x0000A9C8015375DD AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1426, N'5432de95-cbcd-4349-9cf0-7e67904c52aa', N'SamplePrice', N'SEQ-P-1099', 994, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2527, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 2528, N'eb833577-abb5-4239-875a-5f2e2fcb6d57', 4, N'板房签字', 1, N'10', N'Long', CAST(0x0000A9C8015375E9 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1427, N'ac609b39-b6eb-4506-c36f-670c5ed53f5c', N'SamplePrice', N'SEQ-P-1099', 994, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2528, N'eb833577-abb5-4239-875a-5f2e2fcb6d57', 4, N'板房签字', 2529, N'cab57060-f433-422a-a66f-4a5ecfafd54e', 4, N'业务员确认', 1, N'10', N'Long', CAST(0x0000A9C8015375ED AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1428, N'2d5c0e7b-1303-48cb-c22b-3cd2b45701e3', N'SamplePrice', N'SEQ-P-1099', 994, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2529, N'cab57060-f433-422a-a66f-4a5ecfafd54e', 4, N'业务员确认', 2530, N'b53eb9ab-3af6-41ad-d722-bed946d19792', 2, N'结束', 1, N'10', N'Long', CAST(0x0000A9C8015375F2 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1429, N'9cf01621-2dd5-474a-8889-cdbe53a0b72e', N'SamplePrice', N'SEQ-P-1099', 995, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2531, N'9b78486d-5b8f-4be4-948e-522356e84e79', 1, N'开始', 2532, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 1, N'10', N'Long', CAST(0x0000A9C8015375F7 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1430, N'5432de95-cbcd-4349-9cf0-7e67904c52aa', N'SamplePrice', N'SEQ-P-1099', 995, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2532, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 2533, N'eb833577-abb5-4239-875a-5f2e2fcb6d57', 4, N'板房签字', 1, N'10', N'Long', CAST(0x0000A9C8015375FA AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1431, N'ac609b39-b6eb-4506-c36f-670c5ed53f5c', N'SamplePrice', N'SEQ-P-1099', 995, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2533, N'eb833577-abb5-4239-875a-5f2e2fcb6d57', 4, N'板房签字', 2534, N'cab57060-f433-422a-a66f-4a5ecfafd54e', 4, N'业务员确认', 1, N'10', N'Long', CAST(0x0000A9C8015375FE AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1432, N'2d5c0e7b-1303-48cb-c22b-3cd2b45701e3', N'SamplePrice', N'SEQ-P-1099', 995, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2534, N'cab57060-f433-422a-a66f-4a5ecfafd54e', 4, N'业务员确认', 2535, N'b53eb9ab-3af6-41ad-d722-bed946d19792', 2, N'结束', 1, N'10', N'Long', CAST(0x0000A9C801537601 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1433, N'81fdf756-ecd5-43c0-e2b3-25770aab5dee', N'OfficeIn', N'10998', 996, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', 1, 0, 2536, N'e52d0836-9f98-4b70-d485-6b01b8cc277e', 1, N'开始', 2537, N'4db4a153-c8fc-45df-b067-9d188ae19a41', 4, N'仓库签字', 1, N'10', N'Long', CAST(0x0000A9C801537605 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1434, N'69c1ba54-acb0-4b4e-ff03-3f6cf572e98a', N'OfficeIn', N'10998', 996, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', 1, 0, 2537, N'4db4a153-c8fc-45df-b067-9d188ae19a41', 4, N'仓库签字', 2538, N'eb492ba8-075a-46e4-b95f-ac071dd3a43d', 8, N'Gateway', 1, N'10', N'Long', CAST(0x0000A9C801537610 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1435, N'8d776249-f3c6-4397-817f-44880b34a451', N'OfficeIn', N'10998', 996, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', 1, 0, 2538, N'eb492ba8-075a-46e4-b95f-ac071dd3a43d', 8, N'Gateway', 2539, N'c3cbb3cc-fa60-42ad-9a10-4ec2638aff49', 4, N'行政部签字', 1, N'10', N'Long', CAST(0x0000A9C801537611 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1436, N'952b3594-fe40-427f-a27a-f2650226aeca', N'OfficeIn', N'10998', 996, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', 1, 0, 2539, N'c3cbb3cc-fa60-42ad-9a10-4ec2638aff49', 4, N'行政部签字', 2540, N'932f7fa0-2d4c-4257-c158-b8b181af2d0a', 4, N'财务主管', 1, N'10', N'Long', CAST(0x0000A9C801537615 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1437, N'4b8a68d6-ef32-420a-93e7-33c7e4b80360', N'OfficeIn', N'10998', 996, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', 1, 0, 2540, N'932f7fa0-2d4c-4257-c158-b8b181af2d0a', 4, N'财务主管', 2541, N'30929bbb-c76e-4604-c956-f26feb4aa22e', 2, N'结束', 1, N'10', N'Long', CAST(0x0000A9C801537619 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1438, N'50f7acb2-99d0-4877-e116-5bf19433bb89', N'SignTogeterPrice', N'MI-TOGETHER-1099', 997, N'9fb4bca4-5674-4181-a010-f0e730e166dd', 1, 0, 2542, N'1f303f19-71aa-4879-c501-f4d0f448f0a2', 1, N'开始', 2543, N'791d9d3a-882d-4796-cffc-84d9fca76afd', 4, N'业务员提交', 1, N'10', N'Long', CAST(0x0000A9C80153761C AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1439, N'50f7acb2-99d0-4877-e116-5bf19433bb89', N'SignForwardPrice', N'MI-FORWARD-1099', 998, N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', 1, 0, 2544, N'1f303f19-71aa-4879-c501-f4d0f448f0a2', 1, N'开始', 2545, N'791d9d3a-882d-4796-cffc-84d9fca76afd', 4, N'业务员提交', 1, N'10', N'Long', CAST(0x0000A9C801537646 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1440, N'dc8f24ea-c33c-4bce-c8eb-d2f66edfa64d', N'ExpenseAccount', N'SUB-P-1099', 999, N'805a2af4-5196-4461-8b94-ec57714dfd9d', 1, 0, 2546, N'39778075-73b1-43ed-d49f-da9c2e26d58c', 1, N'开始', 2547, N'1122ea0a-6c06-42f7-9b2f-72c1ddea38a5', 4, N'申请', 1, N'30', N'Jack', CAST(0x0000A9C80153764D AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1441, N'cee2428c-7fd1-4864-db3d-585df2bb39a4', N'ExpenseAccount', N'SUB-P-1099', 999, N'805a2af4-5196-4461-8b94-ec57714dfd9d', 1, 0, 2547, N'1122ea0a-6c06-42f7-9b2f-72c1ddea38a5', 4, N'申请', 2548, N'1689ba04-cebc-4ae3-d7af-2075b81f99c4', 5, N'财务内部审批子流程', 1, N'30', N'Jack', CAST(0x0000A9C801537653 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1442, N'7729a977-a90c-4609-f2f3-0671dfcb4e7d', N'ExpenseAccount', N'SUB-P-1099', 1000, N'f0782fc8-43f1-4520-bed9-f37fcbdede99', 1, 0, 2549, N'5df97972-5296-4192-b1a8-4d16c946590f', 1, N'开始', 2550, N'dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1', 4, N'提交申请', 1, N'30', N'Jack', CAST(0x0000A9C801537655 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1443, N'1196dad5-2635-48e7-e972-58ab81661c21', N'ExpenseAccount', N'SUB-P-1099', 1000, N'f0782fc8-43f1-4520-bed9-f37fcbdede99', 1, 0, 2550, N'dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1', 4, N'提交申请', 2551, N'498222f9-5b4c-46d3-b6df-878db77d4f77', 4, N'审批', 1, N'50', N'Hansam', CAST(0x0000A9C80153765F AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1444, N'ac9f6a7b-fd1d-4653-918d-d4a3659113fb', N'ExpenseAccount', N'SUB-P-1099', 1000, N'f0782fc8-43f1-4520-bed9-f37fcbdede99', 1, 0, 2551, N'498222f9-5b4c-46d3-b6df-878db77d4f77', 4, N'审批', 2552, N'3d5cc2f8-2528-419b-a1ee-00d45ff2101a', 2, N'结束', 1, N'30', N'Jack', CAST(0x0000A9C801537664 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1445, N'9cf01621-2dd5-474a-8889-cdbe53a0b72e', N'SamplePrice', N'SEQ-P-1099', 1001, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2553, N'9b78486d-5b8f-4be4-948e-522356e84e79', 1, N'开始', 2554, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 1, N'10', N'Long', CAST(0x0000A9C801537673 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1446, N'5432de95-cbcd-4349-9cf0-7e67904c52aa', N'SamplePrice', N'SEQ-P-1099', 1001, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2554, N'3c438212-4863-4ff8-efc9-a9096c4a8230', 4, N'业务员提交', 2555, N'eb833577-abb5-4239-875a-5f2e2fcb6d57', 4, N'板房签字', 1, N'10', N'Long', CAST(0x0000A9C801537677 AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1447, N'ac609b39-b6eb-4506-c36f-670c5ed53f5c', N'SamplePrice', N'SEQ-P-1099', 1001, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2555, N'eb833577-abb5-4239-875a-5f2e2fcb6d57', 4, N'板房签字', 2556, N'cab57060-f433-422a-a66f-4a5ecfafd54e', 4, N'业务员确认', 1, N'10', N'Long', CAST(0x0000A9C80153767A AS DateTime), 0)
INSERT [dbo].[WfTransitionInstance] ([ID], [TransitionGUID], [AppName], [AppInstanceID], [ProcessInstanceID], [ProcessGUID], [TransitionType], [FlyingType], [FromActivityInstanceID], [FromActivityGUID], [FromActivityType], [FromActivityName], [ToActivityInstanceID], [ToActivityGUID], [ToActivityType], [ToActivityName], [ConditionParseResult], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [RecordStatusInvalid]) VALUES (1448, N'2d5c0e7b-1303-48cb-c22b-3cd2b45701e3', N'SamplePrice', N'SEQ-P-1099', 1001, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', 1, 0, 2556, N'cab57060-f433-422a-a66f-4a5ecfafd54e', 4, N'业务员确认', 2557, N'b53eb9ab-3af6-41ad-d722-bed946d19792', 2, N'结束', 1, N'10', N'Long', CAST(0x0000A9C80153767E AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[WfTransitionInstance] OFF
/****** Object:  Table [dbo].[WfProcessInstance]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfProcessInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ProcessName] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](20) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceCode] [nvarchar](50) NULL,
	[ProcessState] [smallint] NOT NULL,
	[ParentProcessInstanceID] [int] NULL,
	[ParentProcessGUID] [varchar](100) NULL,
	[InvokedActivityInstanceID] [int] NULL,
	[InvokedActivityGUID] [varchar](100) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[OverdueDateTime] [datetime] NULL,
	[OverdueTreatedDateTime] [datetime] NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[EndedDateTime] [datetime] NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfProcessInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfProcessInstance] ON
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (994, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'报价流程(SequenceTest)', N'1', N'SEQ-P-1099', N'SamplePrice', NULL, 4, NULL, NULL, 0, NULL, CAST(0x0000A9C8015375DB AS DateTime), N'10', N'Long', NULL, NULL, CAST(0x0000A9C8015375DB AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375F2 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (995, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'报价流程(SequenceTest)', N'1', N'SEQ-P-1099', N'SamplePrice', NULL, 4, NULL, NULL, 0, NULL, CAST(0x0000A9C8015375F4 AS DateTime), N'10', N'Long', NULL, NULL, CAST(0x0000A9C8015375F4 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537602 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (996, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'办公用品(SplitJoinTest)', N'1', N'10998', N'OfficeIn', NULL, 4, NULL, NULL, 0, NULL, CAST(0x0000A9C801537604 AS DateTime), N'10', N'Long', NULL, NULL, CAST(0x0000A9C801537604 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537619 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (997, N'9fb4bca4-5674-4181-a010-f0e730e166dd', N'报价会签(SignTogetherTest)', N'1', N'MI-TOGETHER-1099', N'SignTogeterPrice', NULL, 2, NULL, NULL, 0, NULL, CAST(0x0000A9C80153761B AS DateTime), N'10', N'Long', NULL, NULL, CAST(0x0000A9C80153761B AS DateTime), N'10', N'Long', NULL, NULL, NULL, 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (998, N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', N'报价加签(SignForwareTest)', N'1', N'MI-FORWARD-1099', N'SignForwardPrice', NULL, 2, NULL, NULL, 0, NULL, CAST(0x0000A9C801537644 AS DateTime), N'10', N'Long', NULL, NULL, CAST(0x0000A9C801537644 AS DateTime), N'10', N'Long', NULL, NULL, NULL, 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (999, N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'子流程Main(SubProcessMain)', N'1', N'SUB-P-1099', N'ExpenseAccount', NULL, 2, NULL, NULL, 0, NULL, CAST(0x0000A9C80153764C AS DateTime), N'30', N'Jack', NULL, NULL, CAST(0x0000A9C80153764C AS DateTime), N'30', N'Jack', NULL, NULL, NULL, 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (1000, N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'子流程Inter(SbuProcess)', N'1', N'SUB-P-1099', N'ExpenseAccount', NULL, 4, 999, N'805a2af4-5196-4461-8b94-ec57714dfd9d', 2547, N'1122ea0a-6c06-42f7-9b2f-72c1ddea38a5', CAST(0x0000A9C801537654 AS DateTime), N'30', N'Jack', NULL, NULL, CAST(0x0000A9C801537654 AS DateTime), N'30', N'Jack', CAST(0x0000A9C801537664 AS DateTime), N'30', N'Jack', 0)
INSERT [dbo].[WfProcessInstance] ([ID], [ProcessGUID], [ProcessName], [Version], [AppInstanceID], [AppName], [AppInstanceCode], [ProcessState], [ParentProcessInstanceID], [ParentProcessGUID], [InvokedActivityInstanceID], [InvokedActivityGUID], [CreatedDateTime], [CreatedByUserID], [CreatedByUserName], [OverdueDateTime], [OverdueTreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (1001, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'报价流程(SequenceTest)', N'1', N'SEQ-P-1099', N'SamplePrice', NULL, 4, NULL, NULL, 0, NULL, CAST(0x0000A9C801537671 AS DateTime), N'10', N'Long', NULL, NULL, CAST(0x0000A9C801537671 AS DateTime), N'10', N'Long', CAST(0x0000A9C80153767F AS DateTime), N'10', N'Long', 0)
SET IDENTITY_INSERT [dbo].[WfProcessInstance] OFF
/****** Object:  Table [dbo].[WfProcess]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfProcess](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ProcessName] [nvarchar](50) NOT NULL,
	[Version] [nvarchar](20) NOT NULL,
	[IsUsing] [tinyint] NOT NULL,
	[AppType] [varchar](20) NULL,
	[PageUrl] [nvarchar](100) NULL,
	[XmlFileName] [nvarchar](50) NULL,
	[XmlFilePath] [nvarchar](50) NULL,
	[XmlContent] [nvarchar](max) NULL,
	[Description] [nvarchar](1000) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfProcess] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfProcess] ON
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (3, N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'报价流程(SequenceTest)', N'1', 1, NULL, NULL, NULL, N'price\price.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="60c8a694-632a-4ded-9155-f666e461b078" name="业务员(Sales)" code="salesmate" outerId="9"/>
		<Participant type="Role" id="7f9be0fb-7ffa-4b57-8c88-26734fbe3cf6" name="打样员(Tech)" code="techmate" outerId="10"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="报价流程(SequenceTest)" id="072af8c3-482a-4b1c-890b-685ce2fcc75d">
			<Description>null</Description>
			<Activities>
				<Activity id="9b78486d-5b8f-4be4-948e-522356e84e79" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="36" top="118" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="b53eb9ab-3af6-41ad-d722-bed946d19792" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="825" top="118" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="3c438212-4863-4ff8-efc9-a9096c4a8230" name="业务员提交" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="60c8a694-632a-4ded-9155-f666e461b078"/>
					</Performers>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="undefined">
						<Widget left="202" top="118" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="eb833577-abb5-4239-875a-5f2e2fcb6d57" name="板房签字" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="7f9be0fb-7ffa-4b57-8c88-26734fbe3cf6"/>
					</Performers>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="undefined">
						<Widget left="430" top="118" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="cab57060-f433-422a-a66f-4a5ecfafd54e" name="业务员确认" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="60c8a694-632a-4ded-9155-f666e461b078"/>
					</Performers>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="undefined">
						<Widget left="618" top="118" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="5432de95-cbcd-4349-9cf0-7e67904c52aa" from="3c438212-4863-4ff8-efc9-a9096c4a8230" to="eb833577-abb5-4239-875a-5f2e2fcb6d57">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="undefined"/>
				</Transition>
				<Transition id="ac609b39-b6eb-4506-c36f-670c5ed53f5c" from="eb833577-abb5-4239-875a-5f2e2fcb6d57" to="cab57060-f433-422a-a66f-4a5ecfafd54e">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="undefined"/>
				</Transition>
				<Transition id="2d5c0e7b-1303-48cb-c22b-3cd2b45701e3" from="cab57060-f433-422a-a66f-4a5ecfafd54e" to="b53eb9ab-3af6-41ad-d722-bed946d19792">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="undefined"/>
				</Transition>
				<Transition id="9cf01621-2dd5-474a-8889-cdbe53a0b72e" from="9b78486d-5b8f-4be4-948e-522356e84e79" to="3c438212-4863-4ff8-efc9-a9096c4a8230">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="f1ca2202-b6bc-43ae-c588-84efff580f4c" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A3F900E418AE AS DateTime), CAST(0x0000A7E000ED1011 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (24, N'2acffb20-6bd1-4891-98c9-c76d022d1445', N'请假流程(WebDemo)', N'1', 1, NULL, NULL, NULL, N'QINGJIA\HrsLeave1.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="6200799d-ffd2-4ae6-d28f-294a0cd3435a" name="总经理" code="generalmanager" outerId="8"/>
		<Participant type="Role" id="a0c8c361-87e1-4106-a7c9-c0b589123c9c" name="人事经理" code="hrmanager" outerId="3"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="请假流程(WebDemo)" id="2acffb20-6bd1-4891-98c9-c76d022d1445">
			<Description>null</Description>
			<Activities>
				<Activity id="bb6c9787-0e1c-4de1-ddbc-593992724ca5" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="48" top="182" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="5eb84b81-0f04-476d-cc82-b42a65464880" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="956" top="173" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="3242c597-e889-4768-f6db-cafc3d675370" name="员工提交" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="3c7aeaed-8b58-46a6-be39-7b850e6ed8e0"/>
					</Performers>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined">
						<Widget left="180" top="180" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="c437c27a-8351-4805-fd4f-4e270084320a" name="部门经理审批" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c9e054eb-7e4f-47c3-a2b9-61e0ff8748d4"/>
					</Performers>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined">
						<Widget left="360" top="180" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="c05bc40f-579b-49cb-cd12-30c2cba4db1e" name="Gateway" code="">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="510" top="186" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="a6a8e554-d73e-4a77-8d16-08edf5905e1f" name="总经理审批" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6200799d-ffd2-4ae6-d28f-294a0cd3435a"/>
					</Performers>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined">
						<Widget left="600" top="108" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="da9f744b-3f97-40c9-c4f8-67d5a60a2485" name="人事经理审批" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="a0c8c361-87e1-4106-a7c9-c0b589123c9c"/>
					</Performers>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined">
						<Widget left="793" top="171" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="7af6085c-d40e-4687-ec75-748b7ef18e3d" from="bb6c9787-0e1c-4de1-ddbc-593992724ca5" to="3242c597-e889-4768-f6db-cafc3d675370">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined"/>
				</Transition>
				<Transition id="92f5a2a2-e89e-4b3e-8ff9-6a72d3a2d946" from="3242c597-e889-4768-f6db-cafc3d675370" to="c437c27a-8351-4805-fd4f-4e270084320a">
					<Description></Description>
					<Receiver type="Superior"/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined"/>
				</Transition>
				<Transition id="8c1922c3-6d16-452e-a9a0-0b7ba0453347" from="c437c27a-8351-4805-fd4f-4e270084320a" to="c05bc40f-579b-49cb-cd12-30c2cba4db1e">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined"/>
				</Transition>
				<Transition id="a158f3af-61b2-4169-f131-d0876c20063b" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="a6a8e554-d73e-4a77-8d16-08edf5905e1f">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days>3]]>
						</ConditionText>
					</Condition>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined"/>
				</Transition>
				<Transition id="2333ad8b-f958-4ca3-9e72-678d809de2ca" from="da9f744b-3f97-40c9-c4f8-67d5a60a2485" to="5eb84b81-0f04-476d-cc82-b42a65464880">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined"/>
				</Transition>
				<Transition id="efc696f7-83c4-4741-a6f5-e00f9631dda4" from="a6a8e554-d73e-4a77-8d16-08edf5905e1f" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined"/>
				</Transition>
				<Transition id="89c490d0-7a4f-4465-fb4f-0e6914ad703c" from="c05bc40f-579b-49cb-cd12-30c2cba4db1e" to="da9f744b-3f97-40c9-c4f8-67d5a60a2485">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days<=3]]>
						</ConditionText>
					</Condition>
					<Geography parent="09f386b3-3299-475b-d706-77ce4fe31108" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A4210179DC78 AS DateTime), CAST(0x0000A7E000ED3CEC AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (33, N'5c5041fc-ab7f-46c0-85a5-6250c3aea375', N'订单流程(MvcDemo)', N'1', 1, NULL, NULL, NULL, N'price\order.jump.tmp.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="6398503c-25da-4c49-9530-41d3573c860c" name="业务员" code="salesmate" outerId="9"/>
		<Participant type="Role" id="cfb8d004-b27e-40a1-9bc7-55323de0b59b" name="打样员" code="techmate" outerId="10"/>
		<Participant type="Role" id="3c80b85c-73a9-4f52-a21f-1df2a9f37cf7" name="跟单员" code="merchandiser" outerId="11"/>
		<Participant type="Role" id="eae5fb4f-62d8-4024-81db-4ad8b48e611e" name="质检员" code="qcmate" outerId="12"/>
		<Participant type="Role" id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b" name="包装员" code="expressmate" outerId="13"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="订单流程(MvcDemo)" id="5c5041fc-ab7f-46c0-85a5-6250c3aea375">
			<Description>null</Description>
			<Activities>
				<Activity id="e357fe9e-dc33-4075-bd34-6f7425bb7671" name="开始" code="undefined">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="30" top="92" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="aad747dd-2b75-449c-a8a6-391b8a426e83" name="派单" code="Dispatching">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6398503c-25da-4c49-9530-41d3573c860c"/>
					</Performers>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined">
						<Widget left="146" top="92" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="890d4971-3d5d-4800-bdf3-a355fd4a6317" name="Or分支节点" code="undefined">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="317" top="93" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="fc8c71c5-8786-450e-af27-9f6a9de8560f" name="打样" code="Sampling">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="cfb8d004-b27e-40a1-9bc7-55323de0b59b"/>
					</Performers>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined">
						<Widget left="261" top="269" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803" name="生产" code="Manufacturing">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="3c80b85c-73a9-4f52-a21f-1df2a9f37cf7"/>
						<Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b"/>
					</Performers>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined">
						<Widget left="413" top="269" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="39c71004-d822-4c15-9ff2-94ca1068d745" name="质检" code="QCChecking">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="eae5fb4f-62d8-4024-81db-4ad8b48e611e"/>
					</Performers>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined">
						<Widget left="547" top="268" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="422e5354-14f7-4a0a-ae69-c169fee96e50" name="称重" code="Weighting">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b"/>
					</Performers>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined">
						<Widget left="667" top="179" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d" name="打印发货单" code="Delivering">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="1c4682c2-5f81-4a9c-8ddd-c89e26aa1c3b"/>
					</Performers>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined">
						<Widget left="708" top="66" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="b70e717a-08da-419f-b2eb-7a3d71f054de" name="结束" code="undefined">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="867" top="107" width="38" height="38"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e8851141-e3f5-46d7-a317-b7860e32592e" from="e357fe9e-dc33-4075-bd34-6f7425bb7671" to="aad747dd-2b75-449c-a8a6-391b8a426e83">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="e4d3c553-ba29-4965-dd3e-d098895a10e7" from="aad747dd-2b75-449c-a8a6-391b8a426e83" to="890d4971-3d5d-4800-bdf3-a355fd4a6317">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="dabaa65d-905b-42c4-f5f7-e599334c03c9" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="fc8c71c5-8786-450e-af27-9f6a9de8560f">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[CanUseStock == "false" && IsHavingWeight == "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="8eb5ee28-4d72-4361-fc4a-44ea46cbd639" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[CanUseStock == "true" && IsHavingWeight == "true"]]>
						</ConditionText>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="bea1aa54-2167-4438-a9bf-1a2cbc5f43c9" from="fc8c71c5-8786-450e-af27-9f6a9de8560f" to="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="7a1dac3c-4f8c-46b2-bcb9-2ea36df29e27" from="bf5d8fbe-43bb-4e63-bdac-3c0ee1266803" to="39c71004-d822-4c15-9ff2-94ca1068d745">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="9da96321-6bad-4673-829a-0bda31c3e3e1" from="39c71004-d822-4c15-9ff2-94ca1068d745" to="422e5354-14f7-4a0a-ae69-c169fee96e50">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="67a3fe0e-06d3-4a01-e0c1-1a731166c905" from="422e5354-14f7-4a0a-ae69-c169fee96e50" to="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="75f0eb1d-1933-4a0a-a953-76a755744336" from="7c1aa9f9-7f0f-46bf-a219-0b80fdfbbe3d" to="b70e717a-08da-419f-b2eb-7a3d71f054de">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
				<Transition id="95098c43-7acc-48f9-fd5f-6b27b445137b" from="890d4971-3d5d-4800-bdf3-a355fd4a6317" to="422e5354-14f7-4a0a-ae69-c169fee96e50">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[CanUseStock == "true" && IsHavingWeight == "false"]]>
						</ConditionText>
					</Condition>
					<Geography parent="71de7bc9-fabe-4588-9286-c60428485ec6" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A4D2011D084F AS DateTime), CAST(0x0000A7E000ECDA9D AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (51, N'ec794d6d-4543-4938-b5f5-cdd97cf939d6', N'财务报销', N'1', 1, N'baoxiao', NULL, N'baoxiao.xml', N'baoxiao\baoxiao.xml', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="6e3e7793-638f-4a48-d787-2a1016711602" name="普通员工" code="employees" outerId="1"/>
		<Participant type="Role" id="8ad2131e-a98e-4523-acba-88e4404ce0a9" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="77858784-3ec7-4849-c9c2-15e5e6dead0d" name="财务经理" code="finacemanager" outerId="14"/>
		<Participant type="Role" id="0501e326-8541-4d13-8159-d510d57ce1f5" name="总经理" code="generalmanager" outerId="8"/>
		<Participant type="Role" id="23d1c029-ec6e-4212-c9a5-1b82472d4747" name="主管总监" code="director" outerId="4"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="财务报销" id="ec794d6d-4543-4938-b5f5-cdd97cf939d6">
			<Description>null</Description>
			<Activities>
				<Activity id="fe775212-6351-4c9b-ea02-f54a8b95d63b" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="59" top="160" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="77124224-0de9-4407-9d61-4405c8131c48" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="925" top="219" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="7230bb34-3c35-4f44-8f2e-0933cb85aa35" name="填写报销单据" code="appform">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="6e3e7793-638f-4a48-d787-2a1016711602"/>
					</Performers>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined">
						<Widget left="198" top="159" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="889aa813-3eab-4515-89af-cbd133cf030b" name="财务审批" code="accountaduit">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="77858784-3ec7-4849-c9c2-15e5e6dead0d"/>
					</Performers>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined">
						<Widget left="354" top="153" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="548e2052-1eab-43b0-a55c-020582b0b1c8" name="Gateway" code="">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="532" top="167" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd" name="总经理审批" code="ceoaudit">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="0501e326-8541-4d13-8159-d510d57ce1f5"/>
					</Performers>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined">
						<Widget left="629" top="116" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="77129a09-6b2c-43aa-af77-ba5ced57a174" name="主管总监查阅" code="cooaudit">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="23d1c029-ec6e-4212-c9a5-1b82472d4747"/>
					</Performers>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined">
						<Widget left="618" top="246" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="db2df810-7edd-4242-bc64-bac796d78844" name="Gateway" code="">
					<Description>总经理审批路由</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="816" top="190" width="38" height="38"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="1ef510bb-e317-4df1-9f32-0b17601bb275" from="fe775212-6351-4c9b-ea02-f54a8b95d63b" to="7230bb34-3c35-4f44-8f2e-0933cb85aa35">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
				<Transition id="61b60f12-9193-4134-af1f-8d974d354dfa" from="7230bb34-3c35-4f44-8f2e-0933cb85aa35" to="889aa813-3eab-4515-89af-cbd133cf030b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
				<Transition id="5c8d1beb-5aef-4cc3-9e08-6fa6e153925d" from="889aa813-3eab-4515-89af-cbd133cf030b" to="548e2052-1eab-43b0-a55c-020582b0b1c8">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
				<Transition id="96d291c4-3d7e-43e6-f820-dd695daa1fcc" from="548e2052-1eab-43b0-a55c-020582b0b1c8" to="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
				<Transition id="1a1560ce-1258-46f1-f56e-9d1fb2e6142c" from="548e2052-1eab-43b0-a55c-020582b0b1c8" to="77129a09-6b2c-43aa-af77-ba5ced57a174">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
				<Transition id="c405e021-cacf-412e-ce37-82817953c7ec" from="77129a09-6b2c-43aa-af77-ba5ced57a174" to="db2df810-7edd-4242-bc64-bac796d78844">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
				<Transition id="60d69b10-ba70-46a4-948c-09d5be318397" from="c36fa3c0-3b68-4bf6-dc31-1ea939815cfd" to="db2df810-7edd-4242-bc64-bac796d78844">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
				<Transition id="32c2860a-3b66-4b77-a8f8-0f9578440d6d" from="db2df810-7edd-4242-bc64-bac796d78844" to="77124224-0de9-4407-9d61-4405c8131c48">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="9088d0a8-0505-4f30-b16d-1fd8b6200deb" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A55A0132BC96 AS DateTime), CAST(0x0000A7E000ED6F33 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (71, N'9fb4bca4-5674-4181-a010-f0e730e166dd', N'报价会签(SignTogetherTest)', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="28e71769-f197-4fe0-fd9f-63474956dc60" name="业务员(Sales)" code="salesmate" outerId="9"/>
		<Participant type="Role" id="24b1a282-d4d4-4461-febb-2f28eb31f48f" name="打样员(Tech)" code="techmate" outerId="10"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="报价会签(SignTogetherTest)" id="9fb4bca4-5674-4181-a010-f0e730e166dd">
			<Description>null</Description>
			<Activities>
				<Activity id="1f303f19-71aa-4879-c501-f4d0f448f0a2" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="165" top="120" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="7462aae9-da1c-43f0-d741-a4586879de77" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="768" top="124" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="791d9d3a-882d-4796-cffc-84d9fca76afd" name="业务员提交" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="28e71769-f197-4fe0-fd9f-63474956dc60"/>
					</Performers>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="undefined">
						<Widget left="303" top="121" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="23017d0c-08ca-4a59-9649-c6912b819001" name="业务员确认" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="28e71769-f197-4fe0-fd9f-63474956dc60"/>
					</Performers>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="undefined">
						<Widget left="621" top="123" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="36cf2479-e8ec-4936-8bcd-b38101e4664a" name="板房会签" code="">
					<Description>undefined</Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignTogether" mergeType="Sequence" compareType="Count" completeOrder="3"/>
					<Performers>
						<Performer id="24b1a282-d4d4-4461-febb-2f28eb31f48f"/>
					</Performers>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/samll_multiple_instance_task.png">
						<Widget left="472" top="119" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="50f7acb2-99d0-4877-e116-5bf19433bb89" from="1f303f19-71aa-4879-c501-f4d0f448f0a2" to="791d9d3a-882d-4796-cffc-84d9fca76afd">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="undefined"/>
				</Transition>
				<Transition id="87651a0d-81e5-4d6f-9ef3-ed0be0011c8f" from="791d9d3a-882d-4796-cffc-84d9fca76afd" to="36cf2479-e8ec-4936-8bcd-b38101e4664a">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="undefined"/>
				</Transition>
				<Transition id="63031ecf-2116-47a3-a0d8-f920dc5bee11" from="36cf2479-e8ec-4936-8bcd-b38101e4664a" to="23017d0c-08ca-4a59-9649-c6912b819001">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="undefined"/>
				</Transition>
				<Transition id="3d06aebb-2fb3-4995-e0c7-99d488f8312d" from="23017d0c-08ca-4a59-9649-c6912b819001" to="7462aae9-da1c-43f0-d741-a4586879de77">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="1a84f7ca-3391-4e2e-daed-7f6d10abfa50" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A5D80104157F AS DateTime), CAST(0x0000A7E000EDDBC2 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (73, N'68696ea3-00ab-4b40-8fcf-9859dbbde378', N'办公用品(SplitJoinTest)', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="41b3619c-fe14-4eb4-bd70-7e37c94571ae" name="仓库" code="Role_QT" outerId="25"/>
		<Participant type="Role" id="c400a31a-9973-44a4-b0bb-6fe88e6b092a" name="综合部" code="Role_Finance_Manager" outerId="36"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="办公用品(SplitJoinTest)" id="68696ea3-00ab-4b40-8fcf-9859dbbde378">
			<Description>null</Description>
			<Activities>
				<Activity id="e3c8830d-290b-4c1f-bc6d-0e0e78eb0bbf" name="开始" code="null">
					<Description>undefined</Description>
					<ActivityType type="StartNode"/>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="80" top="191" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="c8a6ab46-06ab-485c-a5bc-d6f18db5c2bc" name="仓库签字" code="null">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="41b3619c-fe14-4eb4-bd70-7e37c94571ae"/>
					</Performers>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined">
						<Widget left="200" top="197" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="a44d219c-c60e-468c-b5ab-3f5159ac24a4" name="Or分支节点" code="null">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="326" top="191" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="e60084e4-517a-4892-a290-517159f1b7f4" name="综合部签字" code="null">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c400a31a-9973-44a4-b0bb-6fe88e6b092a"/>
					</Performers>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined">
						<Widget left="418" top="90" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="ce3343b6-930d-4962-a2b9-2c4c4b2dab06" name="财务部签字" code="null">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c400a31a-9973-44a4-b0bb-6fe88e6b092a"/>
					</Performers>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined">
						<Widget left="418" top="280" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="10c7be47-c556-45ad-9db3-696160a3888a" name="Or合并节点" code="null">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Join" gatewayDirection="OrJoin"/>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/merge.png">
						<Widget left="570" top="183" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="0fdff3c0-be97-43d6-b4ff-90d52efb5d6f" name="总经理签字" code="null">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c400a31a-9973-44a4-b0bb-6fe88e6b092a"/>
					</Performers>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined">
						<Widget left="670" top="183" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="76f7ef75-b538-40c8-b529-0849ca777b94" name="结束" code="null">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="820" top="183" width="38" height="38"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="a13fbc66-7e62-4dea-a4e6-ea094a231ef6" from="e3c8830d-290b-4c1f-bc6d-0e0e78eb0bbf" to="c8a6ab46-06ab-485c-a5bc-d6f18db5c2bc">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
				<Transition id="8dfbbbb7-674f-420a-99cb-5eefb53efbf2" from="c8a6ab46-06ab-485c-a5bc-d6f18db5c2bc" to="a44d219c-c60e-468c-b5ab-3f5159ac24a4">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
				<Transition id="7b4e4be7-a74d-4a8b-b2ce-bb367b0186be" from="a44d219c-c60e-468c-b5ab-3f5159ac24a4" to="ce3343b6-930d-4962-a2b9-2c4c4b2dab06">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[surplus == "正常"]]>
						</ConditionText>
					</Condition>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
				<Transition id="df3ba298-3f28-4b30-983e-5a5c10bf19a6" from="a44d219c-c60e-468c-b5ab-3f5159ac24a4" to="e60084e4-517a-4892-a290-517159f1b7f4">
					<Description></Description>
					<Receiver/>
					<Condition type="Express">
						<ConditionText>
							<![CDATA[surplus == "超量"]]>
						</ConditionText>
					</Condition>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
				<Transition id="280a25b7-3175-40ef-af80-0e6c7f13e019" from="ce3343b6-930d-4962-a2b9-2c4c4b2dab06" to="10c7be47-c556-45ad-9db3-696160a3888a">
					<Description></Description>
					<Receiver/>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
				<Transition id="c6170a27-8b54-41e9-84e5-d89e5820b30f" from="e60084e4-517a-4892-a290-517159f1b7f4" to="10c7be47-c556-45ad-9db3-696160a3888a">
					<Description></Description>
					<Receiver/>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
				<Transition id="9ba78022-6dbf-4245-97de-04a42013f3e9" from="10c7be47-c556-45ad-9db3-696160a3888a" to="0fdff3c0-be97-43d6-b4ff-90d52efb5d6f">
					<Description></Description>
					<Receiver/>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
				<Transition id="f395dcc2-c4ae-42c2-a6fb-e0cd21ff8e7c" from="0fdff3c0-be97-43d6-b4ff-90d52efb5d6f" to="76f7ef75-b538-40c8-b529-0849ca777b94">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="14e1451a-a796-4626-f719-8de1ecd2db45" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A60100F7C975 AS DateTime), CAST(0x0000A7C301126290 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (104, N'b2a18777-43f1-4d4d-b9d5-f92aa655a93f', N'Ask for leave', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="c3057cbe-72fb-46d5-f8d1-bedbc41ee5c4" name="testrole" code="testcode" outerId="21"/>
		<Participant type="Role" id="565f2976-3dee-4796-9dbd-e7691705bfd6" name="部门经理" code="depmanager" outerId="2"/>
		<Participant type="Role" id="075d956b-fbaa-41da-8b2a-be24e7df7b2c" name="人事经理" code="hrmanager" outerId="3"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="Ask for leave" id="b2a18777-43f1-4d4d-b9d5-f92aa655a93f">
			<Description>null</Description>
			<Activities>
				<Activity id="849b95d4-6461-402a-f9f1-f443ced9b31a" name="Start" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="171" top="138" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="73a34903-b489-4dd5-9b28-a074a32f844b" name="End" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="818" top="142" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="b8d61c50-edfa-4edc-e890-7f0e84afa521" name="Submit Request" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="c3057cbe-72fb-46d5-f8d1-bedbc41ee5c4"/>
					</Performers>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined">
						<Widget left="312" top="138" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="0b41c280-b2dd-47eb-a074-73d56cb83e5b" name="" code="">
					<Description>undefined</Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="498" top="138" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="6bd98004-cd04-4f3a-bf21-ca232dcd0533" name="Dept Manager Approve" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="565f2976-3dee-4796-9dbd-e7691705bfd6"/>
					</Performers>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined">
						<Widget left="632" top="65" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="6dbedb92-b128-4ae7-a9c8-3d8826d4c481" name="HR Manager Approve" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="075d956b-fbaa-41da-8b2a-be24e7df7b2c"/>
					</Performers>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined">
						<Widget left="633" top="203" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="7529e098-6a9f-4755-8d2a-12e69dc46068" from="849b95d4-6461-402a-f9f1-f443ced9b31a" to="b8d61c50-edfa-4edc-e890-7f0e84afa521">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined"/>
				</Transition>
				<Transition id="8050dd82-3a34-42c7-a994-15a3fe9b4a2d" from="b8d61c50-edfa-4edc-e890-7f0e84afa521" to="0b41c280-b2dd-47eb-a074-73d56cb83e5b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined"/>
				</Transition>
				<Transition id="09abe631-68b9-4cfb-f3e9-d43692817c14" from="0b41c280-b2dd-47eb-a074-73d56cb83e5b" to="6bd98004-cd04-4f3a-bf21-ca232dcd0533">
					<Description>days &amp;lt;= 3</Description>
					<Receiver type="Superior"/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days <= 3]]>
						</ConditionText>
					</Condition>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined"/>
				</Transition>
				<Transition id="33be7303-e246-48a1-ba83-ac038f1a06f5" from="0b41c280-b2dd-47eb-a074-73d56cb83e5b" to="6dbedb92-b128-4ae7-a9c8-3d8826d4c481">
					<Description>days &amp;gt; 3</Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText>
							<![CDATA[days > 3]]>
						</ConditionText>
					</Condition>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined"/>
				</Transition>
				<Transition id="c7dc0035-5230-4b38-e625-506ea9cfb117" from="6bd98004-cd04-4f3a-bf21-ca232dcd0533" to="73a34903-b489-4dd5-9b28-a074a32f844b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined"/>
				</Transition>
				<Transition id="7dcd8bc6-99d9-4081-fdc6-f94c36f01907" from="6dbedb92-b128-4ae7-a9c8-3d8826d4c481" to="73a34903-b489-4dd5-9b28-a074a32f844b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="93aa293c-56fe-4eba-9042-eba072084d15" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A6EC00F3F9FB AS DateTime), CAST(0x0000A7E000EDBDE9 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (108, N'4b979adf-cbfd-4bd9-815f-5615beb1b313', N'test', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="test" id="4b979adf-cbfd-4bd9-815f-5615beb1b313">
			<Description>null</Description>
			<Activities>
				<Activity id="9f41c22d-0218-487c-c433-b5fdedfbf529" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="08ad725d-350a-4477-e1d2-5c22baf2085f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="139" top="146" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="2a727fac-62c0-441a-d04c-23b1c29fb18b" name="申请" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="08ad725d-350a-4477-e1d2-5c22baf2085f" style="undefined">
						<Widget left="287" top="146" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="c6f14d9b-00f6-4ca2-d1e0-eb91920bb1da" name="部门经理审批" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="08ad725d-350a-4477-e1d2-5c22baf2085f" style="undefined">
						<Widget left="443" top="144" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="bbff8124-4ced-4155-9631-839a649d8792" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="08ad725d-350a-4477-e1d2-5c22baf2085f" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="601" top="151" width="38" height="38"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="e0989e81-06d1-492b-a01a-69a71f06acbb" from="9f41c22d-0218-487c-c433-b5fdedfbf529" to="2a727fac-62c0-441a-d04c-23b1c29fb18b">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="08ad725d-350a-4477-e1d2-5c22baf2085f" style="undefined"/>
				</Transition>
				<Transition id="39cc6ef1-8cd5-421c-d480-847cd0497c9a" from="2a727fac-62c0-441a-d04c-23b1c29fb18b" to="c6f14d9b-00f6-4ca2-d1e0-eb91920bb1da">
					<Description></Description>
					<Receiver type="Superior"/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="08ad725d-350a-4477-e1d2-5c22baf2085f" style="undefined"/>
				</Transition>
				<Transition id="1aa3d3ee-d2ea-4b5e-e91a-280bf16aef1d" from="c6f14d9b-00f6-4ca2-d1e0-eb91920bb1da" to="bbff8124-4ced-4155-9631-839a649d8792">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="08ad725d-350a-4477-e1d2-5c22baf2085f" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A73201214B8A AS DateTime), CAST(0x0000A7E000EDA07D AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (109, N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', N'报价加签(SignForwareTest)', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants>
		<Participant type="Role" id="28e71769-f197-4fe0-fd9f-63474956dc60" name="业务员(Sales)" code="salesmate" outerId="9"/>
		<Participant type="Role" id="24b1a282-d4d4-4461-febb-2f28eb31f48f" name="打样员(Tech)" code="techmate" outerId="10"/>
	</Participants>
	<WorkflowProcesses>
		<Process name="报价加签(SignForwareTest)" id="1bc22da3-47e3-4a0a-be81-6d7297ad3aca">
			<Description>null</Description>
			<Activities>
				<Activity id="1f303f19-71aa-4879-c501-f4d0f448f0a2" name="开始" code="">
					<Description>undefined</Description>
					<ActivityType type="StartNode" trigger="null"/>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="165" top="120" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="7462aae9-da1c-43f0-d741-a4586879de77" name="结束" code="">
					<Description>undefined</Description>
					<ActivityType type="EndNode"/>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="768" top="124" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="791d9d3a-882d-4796-cffc-84d9fca76afd" name="业务员提交" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="28e71769-f197-4fe0-fd9f-63474956dc60"/>
					</Performers>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="undefined">
						<Widget left="303" top="121" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="23017d0c-08ca-4a59-9649-c6912b819001" name="业务员确认" code="">
					<Description>undefined</Description>
					<ActivityType type="TaskNode"/>
					<Performers>
						<Performer id="28e71769-f197-4fe0-fd9f-63474956dc60"/>
					</Performers>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="undefined">
						<Widget left="621" top="123" width="67" height="27"/>
					</Geography>
				</Activity>
				<Activity id="36cf2479-e8ec-4936-8bcd-b38101e4664a" name="板房加签" code="">
					<Description>undefined</Description>
					<ActivityType type="MultipleInstanceNode" complexType="SignForward" mergeType="Parallel" compareType="Percentage" completeOrder="60"/>
					<Performers>
						<Performer id="24b1a282-d4d4-4461-febb-2f28eb31f48f"/>
					</Performers>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/samll_multiple_instance_task.png">
						<Widget left="472" top="119" width="67" height="27"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="50f7acb2-99d0-4877-e116-5bf19433bb89" from="1f303f19-71aa-4879-c501-f4d0f448f0a2" to="791d9d3a-882d-4796-cffc-84d9fca76afd">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="undefined"/>
				</Transition>
				<Transition id="87651a0d-81e5-4d6f-9ef3-ed0be0011c8f" from="791d9d3a-882d-4796-cffc-84d9fca76afd" to="36cf2479-e8ec-4936-8bcd-b38101e4664a">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="undefined"/>
				</Transition>
				<Transition id="63031ecf-2116-47a3-a0d8-f920dc5bee11" from="36cf2479-e8ec-4936-8bcd-b38101e4664a" to="23017d0c-08ca-4a59-9649-c6912b819001">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="undefined"/>
				</Transition>
				<Transition id="3d06aebb-2fb3-4995-e0c7-99d488f8312d" from="23017d0c-08ca-4a59-9649-c6912b819001" to="7462aae9-da1c-43f0-d741-a4586879de77">
					<Description></Description>
					<Receiver/>
					<Condition type="Expression">
						<ConditionText/>
					</Condition>
					<Geography parent="eecf35d9-78eb-4a9d-eddc-576d1ce7dc8c" style="undefined"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', NULL, CAST(0x0000A73500B6998A AS DateTime), CAST(0x0000A7E000ED8C2F AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (110, N'6d1678e4-c608-4db7-9c85-ad95d9fda5b0', N'test', N'1', 1, NULL, NULL, NULL, N'\', N'<?xml version="1.0" encoding="UTF-8"?>
<Package>
	<Participants/>
	<WorkflowProcesses>
		<Process name="test" id="6d1678e4-c608-4db7-9c85-ad95d9fda5b0">
			<Description></Description>
			<Activities>
				<Activity id="05c357fc-4cf6-4f0f-c869-2d988f4777ad" name="开始" code="">
					<Description></Description>
					<ActivityType type="StartNode"/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">
						<Widget left="168" top="140" width="32" height="32"/>
					</Geography>
				</Activity>
				<Activity id="d465f4e8-d6e2-488f-924a-b4adb4b77aba" name="Task" code="">
					<Description></Description>
					<ActivityType type="TaskNode"/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="undefined">
						<Widget left="280" top="140" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="781d097c-dec6-4aaf-f0ce-f6069b02d19e" name="结束" code="">
					<Description></Description>
					<ActivityType type="EndNode"/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">
						<Widget left="720" top="137" width="38" height="38"/>
					</Geography>
				</Activity>
				<Activity id="d0cfeab5-0109-493b-c3dd-2255c41476c8" name="Subprocess" code="">
					<Description></Description>
					<ActivityType type="SubProcessNode" subId=""/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="rounded">
						<Widget left="430" top="140" width="72" height="32"/>
					</Geography>
				</Activity>
				<Activity id="8f737530-a72b-429f-ff1b-2251897a61b8" name="gateway-split" code="">
					<Description></Description>
					<ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection=""/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">
						<Widget left="580" top="140" width="72" height="32"/>
					</Geography>
				</Activity>
			</Activities>
			<Transitions>
				<Transition id="4e8aeaff-6c41-4ca7-dc3e-81a5d6db5189" from="05c357fc-4cf6-4f0f-c869-2d988f4777ad" to="d465f4e8-d6e2-488f-924a-b4adb4b77aba">
					<Description></Description>
					<Receiver/>
					<Condition/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="null"/>
				</Transition>
				<Transition id="f108e4ce-c7f9-4440-9e59-980eb26aae3f" from="d465f4e8-d6e2-488f-924a-b4adb4b77aba" to="d0cfeab5-0109-493b-c3dd-2255c41476c8">
					<Description></Description>
					<Receiver/>
					<Condition/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="null"/>
				</Transition>
				<Transition id="e595dcb9-f968-4a46-cb91-4298d3e68340" from="d0cfeab5-0109-493b-c3dd-2255c41476c8" to="8f737530-a72b-429f-ff1b-2251897a61b8">
					<Description></Description>
					<Receiver/>
					<Condition/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="null"/>
				</Transition>
				<Transition id="26637d03-e7ac-428c-ae28-8f89bcdd270e" from="8f737530-a72b-429f-ff1b-2251897a61b8" to="781d097c-dec6-4aaf-f0ce-f6069b02d19e">
					<Description></Description>
					<Receiver/>
					<Condition/>
					<Geography parent="d3e48ef5-6394-40e3-8c07-6a93fdf0a8e0" style="null"/>
				</Transition>
			</Transitions>
		</Process>
	</WorkflowProcesses>
	<Layout>
		<Swimlanes/>
	</Layout>
</Package>', N'', CAST(0x0000A83B00E836F6 AS DateTime), CAST(0x0000A83B00FEE575 AS DateTime))
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (111, N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'办公用品(SplitJoinTest)', N'1', 1, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?> <Package>  <Participants>   <Participant type="Role" id="114e7e8d-574c-42c2-eb1c-3d7160516ba3" name="普通员工" code="employees" outerId="1"/>   <Participant type="Role" id="595410fc-2f24-4708-bacd-0eb38b17e7fc" name="人事经理" code="hrmanager" outerId="3"/>   <Participant type="Role" id="c9694802-fcb1-4cad-ad9e-aae9894305a6" name="总经理" code="generalmanager" outerId="8"/>   <Participant type="Role" id="db7031ac-c0b4-4691-d6e0-195e66be6fe1" name="财务经理" code="finacemanager" outerId="14"/>  </Participants>  <WorkflowProcesses>   <Process name="办公用品(SplitJoinTest)" id="3a8ce214-fd18-4fac-95c0-e7958bc1b2f8">    <Description>null</Description>    <Activities>     <Activity id="e52d0836-9f98-4b70-d485-6b01b8cc277e" name="开始" code="">      <Description></Description>      <ActivityType type="StartNode" trigger="null"/>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">       <Widget left="92" top="147" width="38" height="38"/>      </Geography>     </Activity>     <Activity id="30929bbb-c76e-4604-c956-f26feb4aa22e" name="结束" code="">      <Description></Description>      <ActivityType type="EndNode" trigger="null"/>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">       <Widget left="876" top="150" width="38" height="38"/>      </Geography>     </Activity>     <Activity id="4db4a153-c8fc-45df-b067-9d188ae19a41" name="仓库签字" code="">      <Description></Description>      <ActivityType type="TaskNode"/>      <Performers>       <Performer id="114e7e8d-574c-42c2-eb1c-3d7160516ba3"/>      </Performers>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined">       <Widget left="245" top="146" width="67" height="27"/>      </Geography>     </Activity>     <Activity id="eb492ba8-075a-46e4-b95f-ac071dd3a43d" name="Gateway" code="">      <Description></Description>      <ActivityType type="GatewayNode" gatewaySplitJoinType="Split" gatewayDirection="OrSplit"/>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/fork.png">       <Widget left="414" top="147" width="38" height="38"/>      </Geography>     </Activity>     <Activity id="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49" name="行政部签字" code="">      <Description></Description>      <ActivityType type="TaskNode"/>      <Performers>       <Performer id="595410fc-2f24-4708-bacd-0eb38b17e7fc"/>      </Performers>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined">       <Widget left="553" top="26" width="67" height="27"/>      </Geography>     </Activity>     <Activity id="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" name="总经理签字" code="">      <Description></Description>      <ActivityType type="TaskNode"/>      <Performers>       <Performer id="c9694802-fcb1-4cad-ad9e-aae9894305a6"/>      </Performers>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined">       <Widget left="544" top="296" width="67" height="27"/>      </Geography>     </Activity>     <Activity id="9414c43c-0c8c-4c0b-b65d-16203288c7ca" name="财务签字" code="">      <Description></Description>      <ActivityType type="TaskNode"/>      <Performers>       <Performer id="db7031ac-c0b4-4691-d6e0-195e66be6fe1"/>      </Performers>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined">       <Widget left="555" top="151" width="67" height="27"/>      </Geography>     </Activity>     <Activity id="932f7fa0-2d4c-4257-c158-b8b181af2d0a" name="财务主管" code="">      <Description></Description>      <ActivityType type="TaskNode"/>      <Performers>       <Performer id="db7031ac-c0b4-4691-d6e0-195e66be6fe1"/>      </Performers>      <Actions>       <Action type="ExternalMethod" name="" assembly="" interface="" method=""/>      </Actions>      <Boundaries>       <Boundary event="Timer" expression=""/>      </Boundaries>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined">       <Widget left="734" top="150" width="72" height="32"/>      </Geography>     </Activity>    </Activities>    <Transitions>     <Transition id="81fdf756-ecd5-43c0-e2b3-25770aab5dee" from="e52d0836-9f98-4b70-d485-6b01b8cc277e" to="4db4a153-c8fc-45df-b067-9d188ae19a41">      <Description></Description>      <Receiver/>      <Condition type="Expression">       <ConditionText/>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="69c1ba54-acb0-4b4e-ff03-3f6cf572e98a" from="4db4a153-c8fc-45df-b067-9d188ae19a41" to="eb492ba8-075a-46e4-b95f-ac071dd3a43d">      <Description></Description>      <Receiver/>      <Condition type="Expression">       <ConditionText/>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="8d776249-f3c6-4397-817f-44880b34a451" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49">      <Description>正常</Description>      <Receiver/>      <Condition type="Expression">       <ConditionText>        <![CDATA[surplus = "normal"]]>       </ConditionText>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="e40270aa-834a-455d-ffd6-b3f72feeeadc" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149">      <Description>超量</Description>      <Receiver/>      <Condition type="Expression">       <ConditionText>        <![CDATA[surplus = "overamount"]]>       </ConditionText>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="952b3594-fe40-427f-a27a-f2650226aeca" from="c3cbb3cc-fa60-42ad-9a10-4ec2638aff49" to="932f7fa0-2d4c-4257-c158-b8b181af2d0a">      <Description></Description>      <Receiver/>      <Condition type="Expression">       <ConditionText/>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="fd39de26-d9e9-425e-c952-dd8c37d329d6" from="12c6c0d2-1d23-4ed1-8d58-ddc4268f3149" to="932f7fa0-2d4c-4257-c158-b8b181af2d0a">      <Description></Description>      <Receiver/>      <Condition type="Expression">       <ConditionText/>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="6af8936c-a467-470a-f389-d0a3dcc3739b" from="eb492ba8-075a-46e4-b95f-ac071dd3a43d" to="9414c43c-0c8c-4c0b-b65d-16203288c7ca">      <Description>正常</Description>      <Receiver/>      <Condition type="Expression">       <ConditionText>        <![CDATA[surplus = "normal"]]>       </ConditionText>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="ec4b9497-c187-40a0-af21-1bc3401eb2cf" from="9414c43c-0c8c-4c0b-b65d-16203288c7ca" to="932f7fa0-2d4c-4257-c158-b8b181af2d0a">      <Description></Description>      <Receiver/>      <Condition type="Expression">       <ConditionText/>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>     <Transition id="4b8a68d6-ef32-420a-93e7-33c7e4b80360" from="932f7fa0-2d4c-4257-c158-b8b181af2d0a" to="30929bbb-c76e-4604-c956-f26feb4aa22e">      <Description></Description>      <Receiver type="Default"/>      <Condition type="null">       <ConditionText/>      </Condition>      <Geography parent="45f1609b-0b5c-4cc0-c912-80b1c5474364" style="undefined"/>     </Transition>    </Transitions>   </Process>  </WorkflowProcesses>  <Layout>   <Swimlanes/>   <Groups/>  </Layout> </Package>', NULL, CAST(0x0000A9C8014A7EB6 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (112, N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'子流程Main(SubProcessMain)', N'1', 1, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>  <Package>   <Participants>    <Participant type="Role" id="dbb4dcfd-a288-4bc6-a2ba-0288dcd51ea3" name="普通员工" code="employees" outerId="1"/>    <Participant type="Role" id="89e87b2b-6c39-43f3-c647-2a968f1899c1" name="人事经理" code="hrmanager" outerId="3"/>   </Participants>   <WorkflowProcesses>    <Process name="子流程Main(SubProcessMain)" id="805a2af4-5196-4461-8b94-ec57714dfd9d">     <Description>null</Description>     <Activities>      <Activity id="39778075-73b1-43ed-d49f-da9c2e26d58c" name="开始" code="">       <Description></Description>       <ActivityType type="StartNode" trigger="None"/>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">        <Widget left="100" top="192" width="32" height="32"/>       </Geography>      </Activity>      <Activity id="f8de1810-2db4-4f9d-fea1-2b6d33d02c24" name="结束" code="">       <Description></Description>       <ActivityType type="EndNode" trigger="null"/>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">        <Widget left="712" top="192" width="38" height="38"/>       </Geography>      </Activity>      <Activity id="1122ea0a-6c06-42f7-9b2f-72c1ddea38a5" name="申请" code="">       <Description></Description>       <ActivityType type="TaskNode"/>       <Performers>        <Performer id="dbb4dcfd-a288-4bc6-a2ba-0288dcd51ea3"/>       </Performers>       <Actions>        <Action type="ExternalMethod" name="" assembly="" interface="" method=""/>       </Actions>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="undefined">        <Widget left="230" top="195" width="72" height="32"/>       </Geography>      </Activity>      <Activity id="1689ba04-cebc-4ae3-d7af-2075b81f99c4" name="财务内部审批子流程" code="">       <Description></Description>       <ActivityType type="SubProcessNode" subId="f0782fc8-43f1-4520-bed9-f37fcbdede99"/>       <Actions>        <Action type="null" name="null" assembly="null" interface="null" method="null"/>       </Actions>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="rounded">        <Widget left="400" top="195" width="72" height="32"/>       </Geography>      </Activity>      <Activity id="a89e17ef-e213-4d2d-d4d1-20dcec40d6c2" name="归档" code="">       <Description></Description>       <ActivityType type="TaskNode"/>       <Performers>        <Performer id="89e87b2b-6c39-43f3-c647-2a968f1899c1"/>       </Performers>       <Actions>        <Action type="ExternalMethod" name="" assembly="" interface="" method=""/>       </Actions>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="undefined">        <Widget left="560" top="195" width="72" height="32"/>       </Geography>      </Activity>     </Activities>     <Transitions>      <Transition id="dc8f24ea-c33c-4bce-c8eb-d2f66edfa64d" from="39778075-73b1-43ed-d49f-da9c2e26d58c" to="1122ea0a-6c06-42f7-9b2f-72c1ddea38a5">       <Description></Description>       <Receiver type="Default"/>       <Condition type="null">        <ConditionText/>       </Condition>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="undefined"/>      </Transition>      <Transition id="cee2428c-7fd1-4864-db3d-585df2bb39a4" from="1122ea0a-6c06-42f7-9b2f-72c1ddea38a5" to="1689ba04-cebc-4ae3-d7af-2075b81f99c4">       <Description></Description>       <Receiver type="Default"/>       <Condition type="null">        <ConditionText/>       </Condition>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="undefined"/>      </Transition>      <Transition id="32e5ddd3-cf50-4843-d49c-e46a68737361" from="1689ba04-cebc-4ae3-d7af-2075b81f99c4" to="a89e17ef-e213-4d2d-d4d1-20dcec40d6c2">       <Description></Description>       <Receiver type="Default"/>       <Condition type="null">        <ConditionText/>       </Condition>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="undefined"/>      </Transition>      <Transition id="9c371cfd-d68d-44bb-8258-6b6cb729fe42" from="a89e17ef-e213-4d2d-d4d1-20dcec40d6c2" to="f8de1810-2db4-4f9d-fea1-2b6d33d02c24">       <Description></Description>       <Receiver type="Default"/>       <Condition type="null">        <ConditionText/>       </Condition>       <Geography parent="d17de2f4-0697-419d-e36c-051c484e7832" style="undefined"/>      </Transition>     </Transitions>    </Process>   </WorkflowProcesses>   <Layout>    <Swimlanes/>    <Groups/>   </Layout>  </Package>', NULL, CAST(0x0000A9C8014ABB62 AS DateTime), NULL)
INSERT [dbo].[WfProcess] ([ID], [ProcessGUID], [ProcessName], [Version], [IsUsing], [AppType], [PageUrl], [XmlFileName], [XmlFilePath], [XmlContent], [Description], [CreatedDateTime], [LastUpdatedDateTime]) VALUES (113, N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'子流程Inter(SbuProcess)', N'1', 1, NULL, NULL, NULL, NULL, N'<?xml version="1.0" encoding="UTF-8"?>  <Package>   <Participants>    <Participant type="Role" id="a23858bf-9761-4090-d52a-acaa7042fddb" name="普通员工" code="employees" outerId="1"/>    <Participant type="Role" id="4bd70ef2-55b3-4e1e-d830-c20fb375764a" name="部门总监" code="lll" outerId="2"/>    <Participant type="Role" id="5ad32fc2-3eb8-41a2-c8d0-d7fc492ea5aa" name="打样员(Tech)" code="techmate" outerId="10"/>   </Participants>   <WorkflowProcesses>    <Process name="子流程Inter(SbuProcess)" id="f0782fc8-43f1-4520-bed9-f37fcbdede99">     <Description>null</Description>     <Activities>      <Activity id="5df97972-5296-4192-b1a8-4d16c946590f" name="开始" code="">       <Description></Description>       <ActivityType type="StartNode" trigger="None"/>       <Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event.png">        <Widget left="170" top="230" width="32" height="32"/>       </Geography>      </Activity>      <Activity id="3d5cc2f8-2528-419b-a1ee-00d45ff2101a" name="结束" code="">       <Description></Description>       <ActivityType type="EndNode" trigger="null"/>       <Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="symbol;image=scripts/mxGraph/src/editor/images/symbols/event_end.png">        <Widget left="660" top="230" width="38" height="38"/>       </Geography>      </Activity>      <Activity id="dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1" name="提交申请" code="">       <Description></Description>       <ActivityType type="TaskNode"/>       <Performers>        <Performer id="5ad32fc2-3eb8-41a2-c8d0-d7fc492ea5aa"/>       </Performers>       <Actions>        <Action type="ExternalMethod" name="" assembly="" interface="" method=""/>       </Actions>       <Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined">        <Widget left="310" top="230" width="72" height="32"/>       </Geography>      </Activity>      <Activity id="498222f9-5b4c-46d3-b6df-878db77d4f77" name="审批" code="">       <Description></Description>       <ActivityType type="TaskNode"/>       <Performers>        <Performer id="4bd70ef2-55b3-4e1e-d830-c20fb375764a"/>       </Performers>       <Actions>        <Action type="ExternalMethod" name="" assembly="" interface="" method=""/>       </Actions>       <Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined">        <Widget left="480" top="214" width="72" height="32"/>       </Geography>      </Activity>     </Activities>     <Transitions>      <Transition id="7729a977-a90c-4609-f2f3-0671dfcb4e7d" from="5df97972-5296-4192-b1a8-4d16c946590f" to="dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1">       <Description></Description>       <Receiver type="Default"/>       <Condition type="null">        <ConditionText/>       </Condition>       <Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined"/>      </Transition>      <Transition id="1196dad5-2635-48e7-e972-58ab81661c21" from="dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1" to="498222f9-5b4c-46d3-b6df-878db77d4f77">       <Description></Description>       <Receiver type="Default"/>       <Condition type="null">        <ConditionText/>       </Condition>       <Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined"/>      </Transition>      <Transition id="ac9f6a7b-fd1d-4653-918d-d4a3659113fb" from="498222f9-5b4c-46d3-b6df-878db77d4f77" to="3d5cc2f8-2528-419b-a1ee-00d45ff2101a">       <Description></Description>       <Receiver type="Default"/>       <Condition type="null">        <ConditionText/>       </Condition>       <Geography parent="ef28d3c7-ba79-4034-8c15-f4bf0509347e" style="undefined"/>      </Transition>     </Transitions>    </Process>   </WorkflowProcesses>   <Layout>    <Swimlanes/>    <Groups/>   </Layout>  </Package>', NULL, CAST(0x0000A9C8014C4B8F AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[WfProcess] OFF
/****** Object:  Table [dbo].[WfLog]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[WfLog](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EventTypeID] [int] NOT NULL,
	[Priority] [int] NOT NULL,
	[Severity] [nvarchar](50) NOT NULL,
	[Title] [nvarchar](256) NOT NULL,
	[Message] [nvarchar](500) NULL,
	[StackTrace] [nvarchar](4000) NULL,
	[InnerStackTrace] [nvarchar](4000) NULL,
	[RequestData] [nvarchar](2000) NULL,
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Log] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[WfLog] ON
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (57, 2, 1, N'HIGH', N'流程流转异常', N'当前流程没有运行节点，状态异常！', N'   在 Slickflow.Engine.Business.Manager.ActivityInstanceManager.GetRunningNode(WfAppRunner runner, TaskViewEntity& taskView) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Business\Manager\ActivityInstanceManager.cs:行号 169
   在 Slickflow.Engine.Core.Runtime.WfRuntimeManagerFactory.CreateRuntimeInstanceAppRunning(WfAppRunner runner, WfExecutedResult& result) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Core\Runtime\WfRuntimeManagerFactory.cs:行号 173
   在 Slickflow.Engine.Service.WorkflowService.Run(IDbConnection conn, IDbTransaction trans) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 750', NULL, N'{"AppName":"SignTogeterPrice","AppInstanceID":"MI-TOGETHER-1099","ProcessGUID":"9fb4bca4-5674-4181-a010-f0e730e166dd","UserID":"40","UserName":"Susan","NextActivityPerformers":{"36cf2479-e8ec-4936-8bcd-b38101e4664a":[{"UserID":"30","UserName":"Jack"}]}}', CAST(0x0000A9C801537623 AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (58, 2, 1, N'HIGH', N'流程流转异常', N'当前子流程:[财务内部审批子流程]并没有到达结束状态，主流程无法向下执行。', N'   在 Slickflow.Engine.Core.Runtime.WfRuntimeManagerAppRunning.ExecuteInstanceImp(IDbSession session) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Core\Runtime\WfRuntimeManagerAppRunning.cs:行号 75
   在 Slickflow.Engine.Core.Runtime.WfRuntimeManager.Execute(IDbSession session) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Core\Runtime\WfRuntimeManager.cs:行号 102', NULL, N'{"AppName":"ExpenseAccount","AppInstanceID":"SUB-P-1099","ProcessGUID":"805a2af4-5196-4461-8b94-ec57714dfd9d","UserID":"50","UserName":"Hansam","NextActivityPerformers":{"a89e17ef-e213-4d2d-d4d1-20dcec40d6c2":[{"UserID":"20","UserName":"Meilinda"}]}}', CAST(0x0000A9C80153766E AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (59, 2, 1, N'HIGH', N'流程流转异常', N'当前子流程:[财务内部审批子流程]并没有到达结束状态，主流程无法向下执行。', N'   在 Slickflow.Engine.Core.Runtime.WfRuntimeManagerAppRunning.ExecuteInstanceImp(IDbSession session) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Core\Runtime\WfRuntimeManagerAppRunning.cs:行号 75
   在 Slickflow.Engine.Core.Runtime.WfRuntimeManager.Execute(IDbSession session) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Core\Runtime\WfRuntimeManager.cs:行号 108
   在 Slickflow.Engine.Service.WorkflowService.Run(IDbConnection conn, IDbTransaction trans) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 759', NULL, N'{"AppName":"ExpenseAccount","AppInstanceID":"SUB-P-1099","ProcessGUID":"805a2af4-5196-4461-8b94-ec57714dfd9d","UserID":"50","UserName":"Hansam","NextActivityPerformers":{"a89e17ef-e213-4d2d-d4d1-20dcec40d6c2":[{"UserID":"20","UserName":"Meilinda"}]}}', CAST(0x0000A9C80153766E AS DateTime))
INSERT [dbo].[WfLog] ([ID], [EventTypeID], [Priority], [Severity], [Title], [Message], [StackTrace], [InnerStackTrace], [RequestData], [Timestamp]) VALUES (60, 2, 1, N'HIGH', N'流程返签异常', N'未将对象引用设置到对象的实例。', N'   在 Slickflow.Engine.Service.WorkflowService.<>c__DisplayClass78_0.<Reverse>g__runtimeInstance_OnWfProcessReversed|1(Object sender, WfEventArgs args) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 1194
   在 Slickflow.Engine.Core.Runtime.WfRuntimeManager.Callback(WfExecutedResult result) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Core\Runtime\WfRuntimeManager.cs:行号 130
   在 Slickflow.Engine.Core.Runtime.WfRuntimeManager.Execute(IDbSession session) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Core\Runtime\WfRuntimeManager.cs:行号 118
   在 Slickflow.Engine.Service.WorkflowService.Reverse(IDbConnection conn, IDbTransaction trans) 位置 D:\GitHub\Slickflow\NET\Slickflow\Source\Slickflow.Engine\Service\WorkflowService.cs:行号 1161', NULL, N'{"AppName":"SamplePrice","AppInstanceID":"SEQ-P-1099","ProcessGUID":"072af8c3-482a-4b1c-890b-685ce2fcc75d","UserID":"10","UserName":"Long"}', CAST(0x0000A9C80153768B AS DateTime))
SET IDENTITY_INSERT [dbo].[WfLog] OFF
/****** Object:  Table [dbo].[SysUserResource]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysUserResource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ResourceID] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysUserResource] ON
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (1, 7, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (2, 7, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (3, 7, 4)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (4, 7, 5)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (5, 8, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (6, 8, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (7, 8, 4)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (8, 8, 5)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (9, 11, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (10, 11, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (11, 11, 6)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (12, 12, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (13, 12, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (14, 12, 6)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (15, 9, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (16, 9, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (17, 9, 7)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (18, 10, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (19, 10, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (20, 10, 7)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (21, 13, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (22, 13, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (23, 13, 8)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (24, 14, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (25, 14, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (26, 14, 8)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (27, 15, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (28, 15, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (29, 15, 9)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (30, 15, 10)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (31, 16, 1)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (32, 16, 2)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (33, 16, 9)
INSERT [dbo].[SysUserResource] ([ID], [UserID], [ResourceID]) VALUES (34, 16, 10)
SET IDENTITY_INSERT [dbo].[SysUserResource] OFF
/****** Object:  Table [dbo].[SysUser]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysUser] ON
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (1, N'陈小星')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (2, N'hugfuy')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (3, N'测试')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (4, N'李颖')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (5, N'张恒丰')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (6, N'路天明')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (7, N'陈盖茨')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (8, N'白菲特')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (9, N'张明')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (10, N'李杰')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (11, N'飞羽')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (12, N'雪莉')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (13, N'杰米')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (14, N'旺财')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (15, N'大汉')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (16, N'小威')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (17, N'崔红')
INSERT [dbo].[SysUser] ([ID], [UserName]) VALUES (18, N'金兰')
SET IDENTITY_INSERT [dbo].[SysUser] OFF
/****** Object:  Table [dbo].[SysRoleUser]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysRoleUser](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[UserID] [int] NOT NULL
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysRoleUser] ON
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (1, 8, 1)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (2, 7, 2)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (3, 4, 3)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (4, 3, 4)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (5, 2, 5)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (6, 1, 6)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (7, 9, 7)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (8, 9, 8)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (9, 10, 11)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (10, 10, 12)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (11, 11, 9)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (12, 11, 10)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (13, 12, 13)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (14, 12, 14)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (15, 13, 15)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (16, 13, 16)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (17, 14, 17)
INSERT [dbo].[SysRoleUser] ([ID], [RoleID], [UserID]) VALUES (19, 2, 17)
SET IDENTITY_INSERT [dbo].[SysRoleUser] OFF
/****** Object:  Table [dbo].[SysRoleGroupResource]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysRoleGroupResource](
	[ID] [int] NOT NULL,
	[RgType] [smallint] NOT NULL,
	[RgID] [int] NOT NULL,
	[ResourceID] [int] NOT NULL,
	[PermissionType] [smallint] NOT NULL
) ON [PRIMARY]
GO
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (1, 1, 9, 1, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (2, 1, 9, 2, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (3, 1, 9, 4, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (4, 1, 9, 5, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (5, 1, 10, 1, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (6, 1, 10, 2, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (7, 1, 10, 6, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (8, 1, 11, 7, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (9, 1, 12, 8, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (10, 1, 13, 9, 1)
INSERT [dbo].[SysRoleGroupResource] ([ID], [RgType], [RgID], [ResourceID], [PermissionType]) VALUES (11, 1, 13, 10, 1)
/****** Object:  Table [dbo].[SysRole]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysRole](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RoleCode] [varchar](50) NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysRole] ON
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (1, N'employees', N'普通员工')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (2, N'depmanager', N'部门经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (3, N'hrmanager', N'人事经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (4, N'director', N'主管总监')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (7, N'deputygeneralmanager', N'副总经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (8, N'generalmanager', N'总经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (9, N'salesmate', N'业务员(Sales)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (10, N'techmate', N'打样员(Tech)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (11, N'merchandiser', N'跟单员(Made)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (12, N'qcmate', N'质检员(QC)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (13, N'expressmate', N'包装员(Express)')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (14, N'finacemanager', N'财务经理')
INSERT [dbo].[SysRole] ([ID], [RoleCode], [RoleName]) VALUES (21, N'testcode', N'testrole')
SET IDENTITY_INSERT [dbo].[SysRole] OFF
/****** Object:  Table [dbo].[SysResource]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysResource](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ResourceType] [smallint] NOT NULL,
	[ParentResourceID] [int] NOT NULL,
	[ResourceName] [nvarchar](50) NOT NULL,
	[ResourceCode] [varchar](100) NOT NULL,
	[OrderNo] [smallint] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysResource] ON
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (1, 1, 0, N'生产订单系统', N'SfDemo.Made', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (2, 2, 1, N'生产订单流程', N'SfDemo.Made.POrder', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (4, 5, 2, N'同步订单', N'SfDemo.Made.POrder.SyncOrder', 1)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (5, 5, 2, N'分派订单', N'SfDemo.Made.POrder.Dispatch', 2)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (6, 5, 2, N'打样', N'SfDemo.Made.POrder.Sample', 3)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (7, 5, 2, N'生产', N'SfDemo.Made.POrder.Manufacture', 4)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (8, 5, 2, N'质检', N'SfDemo.Made.POrder.QCCheck', 5)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (9, 5, 2, N'称重', N'SfDemo.Made.POrder.Weight', 6)
INSERT [dbo].[SysResource] ([ID], [ResourceType], [ParentResourceID], [ResourceName], [ResourceCode], [OrderNo]) VALUES (10, 5, 2, N'发货', N'SfDemo.Made.POrder.Delivery', 7)
SET IDENTITY_INSERT [dbo].[SysResource] OFF
/****** Object:  Table [dbo].[SysEmployeeManager]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SysEmployeeManager](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[EmpUserID] [int] NOT NULL,
	[ManagerID] [int] NOT NULL,
	[MgrUserID] [int] NOT NULL,
 CONSTRAINT [PK_SysEmployeeManager] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[SysEmployeeManager] ON
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (1, 1, 6, 2, 5)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (2, 4, 10, 5, 17)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (4, 6, 9, 3, 5)
INSERT [dbo].[SysEmployeeManager] ([ID], [EmployeeID], [EmpUserID], [ManagerID], [MgrUserID]) VALUES (5, 4, 10, 7, 18)
SET IDENTITY_INSERT [dbo].[SysEmployeeManager] OFF
/****** Object:  Table [dbo].[SysEmployee]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysEmployee](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DeptID] [int] NOT NULL,
	[EmpCode] [varchar](50) NOT NULL,
	[EmpName] [nvarchar](50) NOT NULL,
	[UserID] [int] NULL,
	[Mobile] [varchar](20) NULL,
	[EMail] [varchar](100) NULL,
	[Remark] [nvarchar](500) NULL,
 CONSTRAINT [PK_SYSEMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysEmployee] ON
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (1, 2, N'0001', N'路天明', 6, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (2, 2, N'0002', N'张经理', 5, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (3, 3, N'0003', N'金经理', 18, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (4, 4, N'0004', N'阿杰', 10, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (5, 4, N'0005', N'崔经理', 17, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (6, 2, N'0010', N'张明', 9, NULL, NULL, NULL)
INSERT [dbo].[SysEmployee] ([ID], [DeptID], [EmpCode], [EmpName], [UserID], [Mobile], [EMail], [Remark]) VALUES (7, 4, N'0030', N'金兰', 18, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[SysEmployee] OFF
/****** Object:  Table [dbo].[SysDepartment]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SysDepartment](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DeptCode] [varchar](50) NOT NULL,
	[DeptName] [nvarchar](100) NOT NULL,
	[ParentID] [int] NOT NULL,
	[Description] [nvarchar](500) NULL,
 CONSTRAINT [PK_SYSDEPARTMENT] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[SysDepartment] ON
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (1, N'CP', N'SlickOne科技', 0, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (2, N'TH', N'技术部', 1, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (3, N'HR', N'人事部', 1, NULL)
INSERT [dbo].[SysDepartment] ([ID], [DeptCode], [DeptName], [ParentID], [Description]) VALUES (4, N'FN', N'财务部', 1, NULL)
SET IDENTITY_INSERT [dbo].[SysDepartment] OFF
/****** Object:  StoredProcedure [dbo].[pr_sys_UserSave]    Script Date: 01/01/2019 20:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_UserSave]
   @userID			int,
   @userName		varchar(100)

AS

BEGIN

	SET NOCOUNT ON
	-- 检查条件
	IF EXISTS(SELECT 1 
			  FROM SysUser 
			  WHERE ID<>@userID 
				AND (UserName=@userName)
			  )
		RAISERROR ('插入或编辑用户数据失败: 有重复的名称已经存在!', 16, 1)

    --插入或者编辑				
	BEGIN TRY
		IF (@userID>0)
			UPDATE SysUser
			SET UserName=@userName
			WHERE ID=@userID
		ELSE
		    INSERT INTO SysUser(UserName)
		    VALUES(@userName)
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('插入或编辑用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_UserDelete]    Script Date: 01/01/2019 20:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_UserDelete]
   @userID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		DELETE FROM SysRoleUser WHERE UserID=@userID
		DELETE FROM SysUser WHERE ID=@userID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleUserDelete]    Script Date: 01/01/2019 20:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleUserDelete]
   @userID			int,
   @roleID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		IF (@userID = -1)
			DELETE FROM SysRoleUser WHERE RoleID=@roleID
		ELSE
			DELETE FROM SysRoleUser WHERE UserID=@userID AND RoleID=@roleID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除角色下的用户数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleSave]    Script Date: 01/01/2019 20:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleSave]
   @roleID			int,
   @roleCode		varchar(50),
   @roleName		nvarchar(100)

AS

BEGIN

	SET NOCOUNT ON
	-- 检查条件
	IF EXISTS(SELECT 1 
			  FROM SysRole 
			  WHERE ID<>@roleID 
				AND (RoleCode=@roleCode OR RoleName=@roleName)
			  )
		RAISERROR ('插入或编辑角色数据失败: 有重复的名称或者编码已经存在!', 16, 1)

    --插入或者编辑				
	BEGIN TRY
		IF (@roleID>0)
			UPDATE SysRole
			SET RoleCode=@roleCode, RoleName=@roleName
			WHERE ID=@roleID
		ELSE
		    INSERT INTO SysRole(RoleCode, RoleName)
		    VALUES(@roleCode, @roleName)
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('插入或编辑角色数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_RoleDelete]    Script Date: 01/01/2019 20:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[pr_sys_RoleDelete]
   @roleID			int

AS

BEGIN

	SET NOCOUNT ON
    --删除操作				
	BEGIN TRY
		DELETE FROM SysRoleUser WHERE RoleID=@roleID
		DELETE FROM SysRole WHERE ID=@roleID
	END TRY
	BEGIN CATCH
			DECLARE @error int, @message varchar(4000)
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('删除角色数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[pr_sys_DeptUserListRankQuery]    Script Date: 01/01/2019 20:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pr_sys_DeptUserListRankQuery]
   @roleIDs				varchar(8000),
   @curUserID			int,
   @receiverType			int

AS

BEGIN
    --ReceiverType= 1 上司
    --ReceiverType= 2 同级
    --ReceiverType= 3 下属
	SET NOCOUNT ON
	
    DECLARE @error int, @message varchar(4000)
    
    --Activity节点需要定义接收者类型，前提也需要定义角色信息
	IF (@receiverType = 0)
		BEGIN
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('无效的接收者类型@receiverType！查询失败: %d: %s', 16, 1, @error, @message)
		END
	ELSE IF (@roleIDs = '')
		BEGIN
			SELECT @error = ERROR_NUMBER()
				, @message = ERROR_MESSAGE();
			RAISERROR ('无效的角色定义@@roleIDs！查询失败: %d: %s', 16, 1, @error, @message)
		END
		
	--ReceiverType=0, throw an error
	DECLARE @tblRoleIDS as TABLE(ID int)
	
	INSERT INTO @tblRoleIDS(ID)
	SELECT ID 
	FROM dbo.fn_com_SplitString(@roleIDs)
	
	BEGIN TRY
		IF (@receiverType = 1)	--上司
			BEGIN
				SELECT 
					U.ID AS UserID,
					U.UserName
				FROM SysUser U
				INNER JOIN SysEmployeeManager EM
					ON U.ID = EM.MgrUserID
				INNER JOIN SysRoleUser RU
				    ON U.ID = RU.UserID
				INNER JOIN @tblRoleIDS R
				    ON R.ID = RU.RoleID
				WHERE EM.EmpUserID = @curUserID
			END
		ELSE IF (@receiverType = 2) --同级
			BEGIN
				SELECT 
					U.ID AS UserID,
					U.UserName
				FROM SysUser U
				INNER JOIN SysEmployeeManager EM
					ON U.ID = EM.EmpUserID
				INNER JOIN SysRoleUser RU
				    ON U.ID = RU.UserID
				INNER JOIN @tblRoleIDS R
				    ON R.ID = RU.RoleID
				WHERE EM.MgrUserID IN
					(
						SELECT 
							MgrUserID
						FROM SysEmployeeManager
						WHERE EmpUserID = @curUserID
					)
			END
		ELSE IF (@receiverType = 3) --下属
			BEGIN
				SELECT 
					U.ID AS UserID,
					U.UserName
				FROM SysUser U
				INNER JOIN SysEmployeeManager EM
					ON U.ID = EM.EmpUserID
				INNER JOIN SysRoleUser RU
				    ON U.ID = RU.UserID
				INNER JOIN @tblRoleIDS R
				    ON R.ID = RU.RoleID
				WHERE EM.MgrUserID = @curUserID
			END
		
	END TRY
	BEGIN CATCH
		SELECT @error = ERROR_NUMBER()
			, @message = ERROR_MESSAGE();
		RAISERROR ('查询员工上司下属关系数据失败: %d: %s', 16, 1, @error, @message)
	END CATCH
END
GO
/****** Object:  Table [dbo].[WfActivityInstance]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfActivityInstance](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ActivityGUID] [varchar](100) NOT NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[ActivityType] [smallint] NOT NULL,
	[ActivityState] [smallint] NOT NULL,
	[WorkItemType] [smallint] NOT NULL,
	[AssignedToUserIDs] [nvarchar](1000) NULL,
	[AssignedToUserNames] [nvarchar](2000) NULL,
	[BackwardType] [smallint] NULL,
	[BackSrcActivityInstanceID] [int] NULL,
	[GatewayDirectionTypeID] [smallint] NULL,
	[CanRenewInstance] [tinyint] NOT NULL,
	[TokensRequired] [int] NOT NULL,
	[TokensHad] [int] NOT NULL,
	[ComplexType] [smallint] NULL,
	[MergeType] [smallint] NULL,
	[MIHostActivityInstanceID] [int] NULL,
	[CompareType] [smallint] NULL,
	[CompleteOrder] [float] NULL,
	[SignForwardType] [smallint] NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[EndedDateTime] [datetime] NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_WfActivityInstance] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfActivityInstance] ON
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2526, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'9b78486d-5b8f-4be4-948e-522356e84e79', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375DC AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375DD AS DateTime), CAST(0x0000A9C8015375DD AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2527, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375DD AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375E8 AS DateTime), CAST(0x0000A9C8015375E8 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2528, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375E8 AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375EC AS DateTime), CAST(0x0000A9C8015375EC AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2529, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'cab57060-f433-422a-a66f-4a5ecfafd54e', N'业务员确认', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375EC AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375F0 AS DateTime), CAST(0x0000A9C8015375F0 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2530, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'b53eb9ab-3af6-41ad-d722-bed946d19792', N'结束', 2, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375F1 AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375F1 AS DateTime), CAST(0x0000A9C8015375F1 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2531, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'9b78486d-5b8f-4be4-948e-522356e84e79', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375F5 AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375F5 AS DateTime), CAST(0x0000A9C8015375F5 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2532, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375F6 AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375FA AS DateTime), CAST(0x0000A9C8015375FA AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2533, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375FA AS DateTime), N'10', N'Long', CAST(0x0000A9C8015375FD AS DateTime), CAST(0x0000A9C8015375FD AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2534, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'cab57060-f433-422a-a66f-4a5ecfafd54e', N'业务员确认', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375FD AS DateTime), N'10', N'Long', CAST(0x0000A9C801537600 AS DateTime), CAST(0x0000A9C801537600 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2535, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'b53eb9ab-3af6-41ad-d722-bed946d19792', N'结束', 2, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537601 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537601 AS DateTime), CAST(0x0000A9C801537601 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2536, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'e52d0836-9f98-4b70-d485-6b01b8cc277e', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537604 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537604 AS DateTime), CAST(0x0000A9C801537604 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2537, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'4db4a153-c8fc-45df-b067-9d188ae19a41', N'仓库签字', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537605 AS DateTime), N'10', N'Long', CAST(0x0000A9C80153760A AS DateTime), CAST(0x0000A9C80153760A AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2538, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'eb492ba8-075a-46e4-b95f-ac071dd3a43d', N'Gateway', 8, 4, 0, NULL, NULL, 0, NULL, 1, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537610 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537610 AS DateTime), CAST(0x0000A9C801537610 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2539, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'c3cbb3cc-fa60-42ad-9a10-4ec2638aff49', N'行政部签字', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537611 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537614 AS DateTime), CAST(0x0000A9C801537614 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2540, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'932f7fa0-2d4c-4257-c158-b8b181af2d0a', N'财务主管', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537614 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537617 AS DateTime), CAST(0x0000A9C801537617 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2541, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'30929bbb-c76e-4604-c956-f26feb4aa22e', N'结束', 2, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537618 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537618 AS DateTime), CAST(0x0000A9C801537618 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2542, 997, N'SignTogeterPrice', N'MI-TOGETHER-1099', N'9fb4bca4-5674-4181-a010-f0e730e166dd', N'1f303f19-71aa-4879-c501-f4d0f448f0a2', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C80153761B AS DateTime), N'10', N'Long', CAST(0x0000A9C80153761B AS DateTime), CAST(0x0000A9C80153761B AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2543, 997, N'SignTogeterPrice', N'MI-TOGETHER-1099', N'9fb4bca4-5674-4181-a010-f0e730e166dd', N'791d9d3a-882d-4796-cffc-84d9fca76afd', N'业务员提交', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C80153761C AS DateTime), N'10', N'Long', CAST(0x0000A9C801537620 AS DateTime), CAST(0x0000A9C801537620 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2544, 998, N'SignForwardPrice', N'MI-FORWARD-1099', N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', N'1f303f19-71aa-4879-c501-f4d0f448f0a2', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537645 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537645 AS DateTime), CAST(0x0000A9C801537645 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2545, 998, N'SignForwardPrice', N'MI-FORWARD-1099', N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', N'791d9d3a-882d-4796-cffc-84d9fca76afd', N'业务员提交', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537645 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537648 AS DateTime), CAST(0x0000A9C801537648 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2546, 999, N'ExpenseAccount', N'SUB-P-1099', N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'39778075-73b1-43ed-d49f-da9c2e26d58c', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C80153764C AS DateTime), N'30', N'Jack', CAST(0x0000A9C80153764D AS DateTime), CAST(0x0000A9C80153764D AS DateTime), N'30', N'Jack', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2547, 999, N'ExpenseAccount', N'SUB-P-1099', N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'1122ea0a-6c06-42f7-9b2f-72c1ddea38a5', N'申请', 4, 4, 1, N'30', N'Jack', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C80153764D AS DateTime), N'30', N'Jack', CAST(0x0000A9C801537652 AS DateTime), CAST(0x0000A9C801537652 AS DateTime), N'30', N'Jack', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2548, 999, N'ExpenseAccount', N'SUB-P-1099', N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'1689ba04-cebc-4ae3-d7af-2075b81f99c4', N'财务内部审批子流程', 5, 1, 1, N'50', N'Hansam', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C801537652 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2549, 1000, N'ExpenseAccount', N'SUB-P-1099', N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'5df97972-5296-4192-b1a8-4d16c946590f', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C801537654 AS DateTime), N'30', N'Jack', CAST(0x0000A9C801537654 AS DateTime), CAST(0x0000A9C801537654 AS DateTime), N'30', N'Jack', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2550, 1000, N'ExpenseAccount', N'SUB-P-1099', N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1', N'提交申请', 4, 4, 1, N'50', N'Hansam', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C801537655 AS DateTime), N'50', N'Hansam', CAST(0x0000A9C80153765E AS DateTime), CAST(0x0000A9C80153765E AS DateTime), N'50', N'Hansam', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2551, 1000, N'ExpenseAccount', N'SUB-P-1099', N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'498222f9-5b4c-46d3-b6df-878db77d4f77', N'审批', 4, 4, 1, N'30', N'Jack', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'50', N'Hansam', CAST(0x0000A9C80153765E AS DateTime), N'30', N'Jack', CAST(0x0000A9C801537663 AS DateTime), CAST(0x0000A9C801537663 AS DateTime), N'30', N'Jack', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2552, 1000, N'ExpenseAccount', N'SUB-P-1099', N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'3d5cc2f8-2528-419b-a1ee-00d45ff2101a', N'结束', 2, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C801537664 AS DateTime), N'30', N'Jack', CAST(0x0000A9C801537664 AS DateTime), CAST(0x0000A9C801537664 AS DateTime), N'30', N'Jack', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2553, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'9b78486d-5b8f-4be4-948e-522356e84e79', N'开始', 1, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537671 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537672 AS DateTime), CAST(0x0000A9C801537672 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2554, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537673 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537676 AS DateTime), CAST(0x0000A9C801537676 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2555, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537676 AS DateTime), N'10', N'Long', CAST(0x0000A9C801537679 AS DateTime), CAST(0x0000A9C801537679 AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2556, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'cab57060-f433-422a-a66f-4a5ecfafd54e', N'业务员确认', 4, 4, 1, N'10', N'Long', 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C80153767A AS DateTime), N'10', N'Long', CAST(0x0000A9C80153767D AS DateTime), CAST(0x0000A9C80153767D AS DateTime), N'10', N'Long', 0)
INSERT [dbo].[WfActivityInstance] ([ID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [ActivityType], [ActivityState], [WorkItemType], [AssignedToUserIDs], [AssignedToUserNames], [BackwardType], [BackSrcActivityInstanceID], [GatewayDirectionTypeID], [CanRenewInstance], [TokensRequired], [TokensHad], [ComplexType], [MergeType], [MIHostActivityInstanceID], [CompareType], [CompleteOrder], [SignForwardType], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [LastUpdatedDateTime], [EndedDateTime], [EndedByUserID], [EndedByUserName], [RecordStatusInvalid]) VALUES (2557, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'b53eb9ab-3af6-41ad-d722-bed946d19792', N'结束', 2, 4, 0, NULL, NULL, 0, NULL, 0, 0, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C80153767D AS DateTime), N'10', N'Long', CAST(0x0000A9C80153767E AS DateTime), CAST(0x0000A9C80153767E AS DateTime), N'10', N'Long', 0)
SET IDENTITY_INSERT [dbo].[WfActivityInstance] OFF
/****** Object:  View [dbo].[vw_SysRoleUserView]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_SysRoleUserView]
AS
SELECT  dbo.SysRoleUser.ID,
    dbo.SysRole.ID as RoleID, 
	dbo.SysRole.RoleName, 
	dbo.SysRole.RoleCode, 
	dbo.SysUser.ID as UserID,
	dbo.SysUser.UserName
FROM         dbo.SysRole LEFT JOIN
             dbo.SysRoleUser ON dbo.SysRole.ID = dbo.SysRoleUser.RoleID LEFT JOIN
             dbo.SysUser ON dbo.SysRoleUser.UserID = dbo.SysUser.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[24] 2[17] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "SysRole"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 110
               Right = 180
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysRoleUser"
            Begin Extent = 
               Top = 4
               Left = 313
               Bottom = 108
               Right = 455
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SysUser"
            Begin Extent = 
               Top = 165
               Left = 175
               Bottom = 254
               Right = 317
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SysRoleUserView'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_SysRoleUserView'
GO
/****** Object:  Table [dbo].[WfTasks]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[WfTasks](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityInstanceID] [int] NOT NULL,
	[ProcessInstanceID] [int] NOT NULL,
	[AppName] [nvarchar](50) NOT NULL,
	[AppInstanceID] [varchar](50) NOT NULL,
	[ProcessGUID] [varchar](100) NOT NULL,
	[ActivityGUID] [varchar](100) NOT NULL,
	[ActivityName] [nvarchar](50) NOT NULL,
	[TaskType] [smallint] NOT NULL,
	[TaskState] [smallint] NOT NULL,
	[EntrustedTaskID] [int] NULL,
	[AssignedToUserID] [varchar](50) NOT NULL,
	[AssignedToUserName] [nvarchar](50) NOT NULL,
	[CreatedByUserID] [varchar](50) NOT NULL,
	[CreatedByUserName] [nvarchar](50) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[LastUpdatedDateTime] [datetime] NULL,
	[LastUpdatedByUserID] [varchar](50) NULL,
	[LastUpdatedByUserName] [nvarchar](50) NULL,
	[EndedByUserID] [varchar](50) NULL,
	[EndedByUserName] [nvarchar](50) NULL,
	[EndedDateTime] [datetime] NULL,
	[RecordStatusInvalid] [tinyint] NOT NULL,
	[RowVersionID] [timestamp] NULL,
 CONSTRAINT [PK_SSIP_WfTasks] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[WfTasks] ON
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1679, 2527, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C8015375DD AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375E7 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1680, 2528, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C8015375E8 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375EC AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1681, 2529, 994, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'cab57060-f433-422a-a66f-4a5ecfafd54e', N'业务员确认', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C8015375EC AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375F0 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1682, 2532, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C8015375F6 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375F9 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1683, 2533, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C8015375FA AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C8015375FC AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1684, 2534, 995, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'cab57060-f433-422a-a66f-4a5ecfafd54e', N'业务员确认', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C8015375FD AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537600 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1685, 2537, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'4db4a153-c8fc-45df-b067-9d188ae19a41', N'仓库签字', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C801537605 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C80153760A AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1686, 2539, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'c3cbb3cc-fa60-42ad-9a10-4ec2638aff49', N'行政部签字', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C801537611 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537614 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1687, 2540, 996, N'OfficeIn', N'10998', N'3a8ce214-fd18-4fac-95c0-e7958bc1b2f8', N'932f7fa0-2d4c-4257-c158-b8b181af2d0a', N'财务主管', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C801537614 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537617 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1688, 2543, 997, N'SignTogeterPrice', N'MI-TOGETHER-1099', N'9fb4bca4-5674-4181-a010-f0e730e166dd', N'791d9d3a-882d-4796-cffc-84d9fca76afd', N'业务员提交', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C80153761C AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537620 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1689, 2545, 998, N'SignForwardPrice', N'MI-FORWARD-1099', N'1bc22da3-47e3-4a0a-be81-6d7297ad3aca', N'791d9d3a-882d-4796-cffc-84d9fca76afd', N'业务员提交', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C801537646 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537648 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1690, 2547, 999, N'ExpenseAccount', N'SUB-P-1099', N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'1122ea0a-6c06-42f7-9b2f-72c1ddea38a5', N'申请', 1, 4, NULL, N'30', N'Jack', N'30', N'Jack', CAST(0x0000A9C80153764D AS DateTime), NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C801537651 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1691, 2548, 999, N'ExpenseAccount', N'SUB-P-1099', N'805a2af4-5196-4461-8b94-ec57714dfd9d', N'1689ba04-cebc-4ae3-d7af-2075b81f99c4', N'财务内部审批子流程', 1, 1, NULL, N'50', N'Hansam', N'30', N'Jack', CAST(0x0000A9C801537653 AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1692, 2550, 1000, N'ExpenseAccount', N'SUB-P-1099', N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'dd5055f1-cdc1-4c2c-89ad-fc8f54d262a1', N'提交申请', 1, 4, NULL, N'50', N'Hansam', N'30', N'Jack', CAST(0x0000A9C801537655 AS DateTime), NULL, NULL, NULL, N'50', N'Hansam', CAST(0x0000A9C80153765D AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1693, 2551, 1000, N'ExpenseAccount', N'SUB-P-1099', N'f0782fc8-43f1-4520-bed9-f37fcbdede99', N'498222f9-5b4c-46d3-b6df-878db77d4f77', N'审批', 1, 4, NULL, N'30', N'Jack', N'50', N'Hansam', CAST(0x0000A9C80153765E AS DateTime), NULL, NULL, NULL, N'30', N'Jack', CAST(0x0000A9C801537663 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1694, 2554, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'3c438212-4863-4ff8-efc9-a9096c4a8230', N'业务员提交', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C801537673 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537675 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1695, 2555, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'eb833577-abb5-4239-875a-5f2e2fcb6d57', N'板房签字', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C801537677 AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C801537679 AS DateTime), 0)
INSERT [dbo].[WfTasks] ([ID], [ActivityInstanceID], [ProcessInstanceID], [AppName], [AppInstanceID], [ProcessGUID], [ActivityGUID], [ActivityName], [TaskType], [TaskState], [EntrustedTaskID], [AssignedToUserID], [AssignedToUserName], [CreatedByUserID], [CreatedByUserName], [CreatedDateTime], [LastUpdatedDateTime], [LastUpdatedByUserID], [LastUpdatedByUserName], [EndedByUserID], [EndedByUserName], [EndedDateTime], [RecordStatusInvalid]) VALUES (1696, 2556, 1001, N'SamplePrice', N'SEQ-P-1099', N'072af8c3-482a-4b1c-890b-685ce2fcc75d', N'cab57060-f433-422a-a66f-4a5ecfafd54e', N'业务员确认', 1, 4, NULL, N'10', N'Long', N'10', N'Long', CAST(0x0000A9C80153767A AS DateTime), NULL, NULL, NULL, N'10', N'Long', CAST(0x0000A9C80153767C AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[WfTasks] OFF
/****** Object:  View [dbo].[vwWfActivityInstanceTasks]    Script Date: 01/01/2019 20:39:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vwWfActivityInstanceTasks]
AS
SELECT     dbo.WfTasks.ID AS TaskID, dbo.WfActivityInstance.AppName, dbo.WfActivityInstance.AppInstanceID, dbo.WfActivityInstance.ProcessGUID, 
                      dbo.WfProcessInstance.Version, dbo.WfTasks.ProcessInstanceID, dbo.WfActivityInstance.ActivityGUID, dbo.WfTasks.ActivityInstanceID, 
                      dbo.WfActivityInstance.ActivityName, dbo.WfActivityInstance.ActivityType, dbo.WfActivityInstance.WorkItemType, 
                      dbo.WfActivityInstance.CreatedByUserID AS PreviousUserID, dbo.WfActivityInstance.CreatedByUserName AS PreviousUserName, 
                      dbo.WfActivityInstance.CreatedDateTime AS PreviousDateTime, dbo.WfTasks.TaskType, dbo.WfTasks.EntrustedTaskID, dbo.WfTasks.AssignedToUserID, 
                      dbo.WfTasks.AssignedToUserName, dbo.WfTasks.CreatedDateTime, dbo.WfTasks.LastUpdatedDateTime, dbo.WfTasks.EndedDateTime, 
                      dbo.WfTasks.EndedByUserID, dbo.WfTasks.EndedByUserName, dbo.WfTasks.TaskState, dbo.WfActivityInstance.ActivityState, dbo.WfTasks.RecordStatusInvalid, 
                      dbo.WfProcessInstance.ProcessState, dbo.WfActivityInstance.ComplexType, dbo.WfActivityInstance.MIHostActivityInstanceID, 
                      dbo.WfProcessInstance.AppInstanceCode, dbo.WfProcessInstance.ProcessName, dbo.WfProcessInstance.CreatedByUserName, 
                      dbo.WfProcessInstance.CreatedDateTime AS PCreatedDateTime, CASE WHEN MIHostActivityInstanceID IS NULL THEN ActivityState ELSE
                          (SELECT     ActivityState
                            FROM          dbo.WfActivityInstance a
                            WHERE      a.ID = dbo.WfActivityInstance.MIHostActivityInstanceID) END AS MiHostState
FROM         dbo.WfActivityInstance INNER JOIN
                      dbo.WfTasks ON dbo.WfActivityInstance.ID = dbo.WfTasks.ActivityInstanceID INNER JOIN
                      dbo.WfProcessInstance ON dbo.WfActivityInstance.ProcessInstanceID = dbo.WfProcessInstance.ID
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[23] 4[53] 2[13] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "WfActivityInstance"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 253
            End
            DisplayFlags = 280
            TopColumn = 22
         End
         Begin Table = "WfTasks"
            Begin Extent = 
               Top = 126
               Left = 38
               Bottom = 245
               Right = 249
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "WfProcessInstance"
            Begin Extent = 
               Top = 246
               Left = 38
               Bottom = 365
               Right = 255
            End
            DisplayFlags = 280
            TopColumn = 10
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 3930
         Alias = 2145
         Table = 2595
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWfActivityInstanceTasks'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwWfActivityInstanceTasks'
GO
/****** Object:  Default [DF__HrsLeave__LeaveT__22AA2996]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[HrsLeave] ADD  DEFAULT ((0)) FOR [LeaveType]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_State]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_State]  DEFAULT ((0)) FOR [ActivityState]
GO
/****** Object:  Default [DF_WfActivityInstance_WorkItemType]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_WfActivityInstance_WorkItemType]  DEFAULT ((0)) FOR [WorkItemType]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_CanInvokeNextActivity]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_CanInvokeNextActivity]  DEFAULT ((0)) FOR [CanRenewInstance]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_TokensRequired]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_TokensRequired]  DEFAULT ((1)) FOR [TokensRequired]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_CreatedDateTime]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfActivityInstance_RecordStatusInvalid]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfActivityInstance] ADD  CONSTRAINT [DF_SSIP_WfActivityInstance_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_WfProcess_Version]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_Version]  DEFAULT ((1)) FOR [Version]
GO
/****** Object:  Default [DF_WfProcess_IsUsing]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_WfProcess_IsUsing]  DEFAULT ((0)) FOR [IsUsing]
GO
/****** Object:  Default [DF_SSIP-WfPROCESS_CreatedDateTime]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcess] ADD  CONSTRAINT [DF_SSIP-WfPROCESS_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_WfProcessInstance_Version]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_Version]  DEFAULT ((1)) FOR [Version]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_State]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_State]  DEFAULT ((0)) FOR [ProcessState]
GO
/****** Object:  Default [DF_WfProcessInstance_ParentProcessInstanceID]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_ParentProcessInstanceID]  DEFAULT ((0)) FOR [ParentProcessInstanceID]
GO
/****** Object:  Default [DF_WfProcessInstance_InvokedActivityInstanceID]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_WfProcessInstance_InvokedActivityInstanceID]  DEFAULT ((0)) FOR [InvokedActivityInstanceID]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_CreatedDateTime]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfProcessInstance_RecordStatus]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfProcessInstance] ADD  CONSTRAINT [DF_SSIP_WfProcessInstance_RecordStatus]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_SSIP_WfTasks_IsCompleted]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_IsCompleted]  DEFAULT ((0)) FOR [TaskState]
GO
/****** Object:  Default [DF_SSIP_WfTasks_CreatedDateTime]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfTasks_RecordStatusInvalid]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTasks] ADD  CONSTRAINT [DF_SSIP_WfTasks_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  Default [DF_WfTransitionInstance_IsBackwardFlying]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_WfTransitionInstance_IsBackwardFlying]  DEFAULT ((0)) FOR [FlyingType]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_ConditionParseResult]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_ConditionParseResult]  DEFAULT ((0)) FOR [ConditionParseResult]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_CreatedDateTime]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_CreatedDateTime]  DEFAULT (getdate()) FOR [CreatedDateTime]
GO
/****** Object:  Default [DF_SSIP_WfTransitionInstance_RecordStatusInvalid]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTransitionInstance] ADD  CONSTRAINT [DF_SSIP_WfTransitionInstance_RecordStatusInvalid]  DEFAULT ((0)) FOR [RecordStatusInvalid]
GO
/****** Object:  ForeignKey [FK_WfActivityInstance_ProcessInstanceID]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfActivityInstance]  WITH NOCHECK ADD  CONSTRAINT [FK_WfActivityInstance_ProcessInstanceID] FOREIGN KEY([ProcessInstanceID])
REFERENCES [dbo].[WfProcessInstance] ([ID])
GO
ALTER TABLE [dbo].[WfActivityInstance] CHECK CONSTRAINT [FK_WfActivityInstance_ProcessInstanceID]
GO
/****** Object:  ForeignKey [FK_WfTasks_ActivityInstanceID]    Script Date: 01/01/2019 20:39:36 ******/
ALTER TABLE [dbo].[WfTasks]  WITH NOCHECK ADD  CONSTRAINT [FK_WfTasks_ActivityInstanceID] FOREIGN KEY([ActivityInstanceID])
REFERENCES [dbo].[WfActivityInstance] ([ID])
GO
ALTER TABLE [dbo].[WfTasks] CHECK CONSTRAINT [FK_WfTasks_ActivityInstanceID]
GO
