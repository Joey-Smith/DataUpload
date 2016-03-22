Imports System.IO

Partial Class administration_imports_and_updates_import_upload_form
    Inherits System.Web.UI.Page

    Protected Sub Page_LoadComplete(sender As Object, e As EventArgs) Handles Me.LoadComplete
        Dim bll As New bllImport

        If Request.Form.Count > 0 Then
		'VERIFY FILES WHERE UPLOADED
            If Request.Files.Count > 0 Then
			'GET THE CURRENT USER. THIS IS USED TO IDENTIFY THE IMPORTING STAFF IN THE DATABASE
                Dim user = Request.QueryString("user")
				'GET FIELDS CONTAINING UPLOADED FILES
                Dim fields As String() = Request.Form.Item("inputFields").Split(",")
				'GET LIST OF PROCEDURES ASSOCIATED WITH THE EXCECUTED FUNCTION
                Dim procs As String = Request.Form.Item("inputProcs")
				'GET THE FUNCTION ID
                Dim functionId As String = Request.Form.Item("inputId")
				'INITIALIZE FILE ARRAY
                Dim files(fields.Length - 1) As HttpPostedFile

				'FOR EACH FIELD, POPULATE FILE ARRAY AND VERIFY THAT FILE IS EXPECTED TYPE
                For index As Integer = 0 To fields.Length - 1
                    files(index) = Request.Files.Item(fields(index))

                    If Path.GetExtension(files(index).FileName) <> ".csv" Then
                        Response.Redirect("import-error.htm?error=One or more of the uploaded files are not of the correct type.")
                    End If
                Next
				
				'EXECUTE THE IMPORT FUNCTION AND CREATE THE REPORT DOWNLOAD IFRAME ON THE PARENT PAGE WITH THE RETURNED REPORT NAME
                dlScript.Text = "<script type='text/javascript'>parent.setReportIFrameSrc('" & bll.Import(user, functionId, fields, procs, files) & "');</script>"
            Else
                Response.Redirect("import-error.htm?error=No file selected")
            End If
        End If
    End Sub
End Class