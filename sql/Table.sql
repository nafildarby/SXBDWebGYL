----系统入库表
CREATE TABLE [dbo].[T_GYL_WhsIncome](
	[Id] [varchar](36) NOT NULL,
	[IncomeCode] [nvarchar](30) NULL,
	[IncomeType] [int] NULL,
	[RegistId] [varchar](36) NULL,
	[InspectionId] [varchar](36) NULL,
	[SupplierId] [varchar](36) NULL,
	[WhsId] [varchar](36) NULL,
	[IncomeBatch] [nvarchar](30) NULL,
	[IncomeDate] [date] NULL,
	[Note] [nvarchar](200) NULL,
	[StatusFlag] [int] NULL,
	[CreateTime] [datetime] NULL,
	[OpId] [varchar](36) NULL,
	[OpName] [nvarchar](50) NULL,
	[OpTime] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'入库编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'Id'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'入库单号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'IncomeCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'入库单类型' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'IncomeType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'到货登记编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'RegistId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'质检编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'InspectionId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'供货商编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'SupplierId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'仓库编号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'WhsId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'入库批号' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'IncomeBatch'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'入库日期' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'IncomeDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'备注' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'Note'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'状态' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'StatusFlag'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'创建时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'CreateTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'操作人' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'OpId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'操作人姓名' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'OpName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'操作时间' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome', @level2type=N'COLUMN',@level2name=N'OpTime'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'仓库管理--入库单表' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'T_GYL_WhsIncome'
GO



----流程定义表
CREATE TABLE [dbo].[T_GYL_Flow](
	[Id] [BIGINT] IDENTITY(1,1) NOT NULL,
	[Name] [VARCHAR](200) NOT NULL,
	[Code] [VARCHAR](200) NOT NULL,
	[StartDate] [DATE] NOT NULL,
	[Status] [INT] NOT NULL,
	[Description] [VARCHAR](MAX) NOT NULL,
 CONSTRAINT [PK_T_GYL_Flow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO