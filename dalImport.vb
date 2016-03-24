Imports Microsoft.VisualBasic
Imports System.Web.Configuration
Imports System.Data.Odbc
Imports System.Data

Public Class dalImport
    Public Function ExecuteFunction(ByVal user As String, ByVal fields As String, ByVal procedure As String) As OdbcDataReader
        Dim dr As OdbcDataReader
        Dim conString As String = WebConfigurationManager.ConnectionStrings("NeedlesConnection").ConnectionString
        Dim con As New OdbcConnection(conString)
		
		'INTIALIZE COMMAND FOR THE GIVEN STORED PROCEDURE
        Dim cmd As OdbcCommand = New OdbcCommand("{call " & procedure & "(?,?)}", con)

        'SET COMMAND TYPE TO STORED PROCEDURE
        cmd.CommandType = CommandType.StoredProcedure
        cmd.Connection = con

        'ADD PARAMETERS
		
		'FIRST PARAMETER FOR IMPORT PROCEDURES IS ALWAYS THE CURRENT USER
        cmd.Parameters.Add("@user", OdbcType.VarChar, 8)
        cmd.Parameters("@user").Value = user

		'SECOND PARAMETER IS ALWAYS THE FILE PATHS STRING
        cmd.Parameters.Add("@fields", OdbcType.VarChar)
        cmd.Parameters("@fields").Value = fields

        'OPEN CONNECTION
        con.Open()

        dr = cmd.ExecuteReader(CommandBehavior.CloseConnection)

        'RETURN KEY VALUE PAIRS
        Return dr
    End Function
End Class