<%@ Page Title="" Language="VB" MasterPageFile="~/Site.master" AutoEventWireup="false" CodeFile="import-upload.aspx.vb" Inherits="administration_imports_and_updates_import_upload" %>

<%@ MasterType VirtualPath="~/Site.master" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeadingContent" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divOptionsContainer">
        <table border="0" width="" align="left" cellspacing="0" cellpadding="0">
            <colgroup>
                <col width="100px" />
                <col width="400px" />
            </colgroup>
            <tr>
                <td id="tdClassHead" class="FieldHeadingAC">Class</td>
            </tr>
            <tr>
                <td>
					<!-- LIST OF CLASSES FOR WHICH THE CURRENT USER HAS PERMISSION TO IMPORT. POPULATED FROM THE CODE BEHIND -->
                    <asp:ListBox runat="server" ID="lstClasses" SelectionMode="Multiple" CssClass="ClassList" onmouseup="lstClick();" onmousedown="ResetFrame();" Style="width: 200px;" /></td>
                <td>
					<!-- IFRAME CONTAINING THE UPLOAD CONTROL -->
                    <iframe id="formSubmit" src="import-upload-form.aspx?user=<%=Master.UsrName%>" width="600" height="600" frameborder="0"></iframe>
                    <img id="imgLoadingGif" src="../../images/ajax_loader.gif" alt="loading" style="margin-top: 20px; width: 20px; height: 20px; display: none;" />
                </td>
            </tr>
            <tr style="height: 50px;">
                <td>
                    <p id="pListError" style="color: red; visibility: hidden;">Select a class.</p>
                </td>
            </tr>
        </table>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ReportContent" runat="Server">
    <script type="text/javascript">
        var lstClasses = document.getElementById('<%=lstClasses.ClientId %>');
		var imgLoadingGif = document.getElementById("imgLoadingGif");
		var tdClassHead = document.getElementById("tdClassHead");
		var iframe;

        /********************************* RESETFRAME *********************************
		DESCRIPTION: RESETS THE FRAME FROM AN ERROR.
		FUNCTIONALITY: SHOULD AN ERROR OCCUR IN THE DATABASE UPON UPLOAD, FOR EXAMPLE A RIGHT TRUNCATION ERROR, IT GETS DISPLAYED IN THE IFRAME.
						THIS ERROR GETS RESET TO THE ORIGINAL UPLOAD CONTROL ON A MOUSEDOWN EVENT TO ALLOW THE USER TO RETRY IMPORT WITHOUT A PAGE REFRESH.
		PARAMETERS: 
		*/
		function ResetFrame() {
			// SET IFRAME SOURCE BACK TO ORIGINAL
		    document.getElementById("formSubmit").src = "import-upload-form.aspx?user=<%=Master.UsrName%>";
		}

		/********************************* lSTCLICK *********************************
		DESCRIPTION: VERIFIES WHICH OPTION IS SELECTED AND EITHER HIDES OR DISPLAYS
				THE REPORT BUTTON
		FUNCTIONALITY: IF AN INTAKE HAS NO REPORTS ASSOCIATED WITH IT, THE REPORT
				BUTTON IS HIDDEN FROM THE USER. OTHERWISE IT IS DISPLAYED.
		PARAMETERS: 
		*/
		function lstClick() {
		    var div;
		    var form;
		    var input;
		    var button;
		    var iframe;
		    var formSubmit;
		    var forms;
		    var formInfo;
		    var formFields;
		    var labelField;
		    var table;
		    var tr;
		    var td;
		    
            // GET FRAME CONENTS
		    iframe = document.getElementById("formSubmit").contentDocument;

            // GET DIV. THIS DIV WILL CONTAIN ALL OF THE IMPORT FUNCTION UPLOAD FIELDS FOR THE SELECTED CLASS
		    formSubmit = iframe.getElementById("formSubmit");

		    // FETCH ALL FUNCTIONS FOR THE GIVEN CASETYPE/CLASS COMBINATION.
		    // EACH FUNCTION IS TURNED INTO A FORM.
            // FUNCTIONS ARE SPLIT BY '='.
		    forms = PostAjax("id=" + lstClasses.options[lstClasses.selectedIndex].value).split("=")

            // FOR EACH FUNCTION
		    for (var formsIndex = 0; formsIndex < forms.length - 1; formsIndex++) {
		        // EACH FUNCTION HAS FORM ATTRIBUTES.
		        // 0 - FUNCTION ID
		        // 1 - FUNCTION FORM TITLE
		        // 2 - FUNCTION PROCEDURES (COMMA SEPARATED)
		        // 3 - FUNCTION FORM FILE INPUTS

                // SPLIT FORM ATTRIBUTES
		        formInfo = forms[formsIndex].split(";");

                // CREATE FORM
		        form = iframe.createElement("form");
		        form.id = "form" + formsIndex;
		        form.action = "";
		        form.method = "post";
		        form.enctype = "multipart/form-data";
		        formSubmit.appendChild(form);

                // CREATE TABLE FOR FORM
		        table = iframe.createElement("table");
		        form.appendChild(table);
		        table.style.borderCollapse = "collapse";
                tr = iframe.createElement("tr");
		        table.appendChild(tr);

                // CREATE FUNCTION FORM TITLE CELL
		        td = iframe.createElement("td");
		        td.colSpan = "2";
		        tr.appendChild(td);
		        labelField = iframe.createElement("h3");
		        td.appendChild(labelField);
		        labelField.innerHTML = formInfo[1];
		        td.appendChild(labelField);

		        td = iframe.createElement("td");
		        tr.appendChild(td);

                // CREATE HIDDEN FUNCTION ID INPUT, TO BE PASSED TO SERVER
		        input = iframe.createElement("input");
		        input.id = "inputId";
		        input.name = "inputId";
		        td.appendChild(input);
		        input.style.display = "none";
		        input.value = formInfo[0];

		        // CREATE HIDDEN FUNCTION PROCEDURES INPUT, TO BE PASSED TO SERVER
		        input = iframe.createElement("input");
		        input.id = "inputProcs";
		        input.name = "inputProcs";
		        td.appendChild(input);
		        input.style.display = "none";
		        input.value = formInfo[2];

		        // CREATE HIDDEN FUNCTION FILE LIST INPUT, TO BE PASSED TO SERVER
		        input = iframe.createElement("input");
		        input.id = "inputFields";
		        input.name = "inputFields";
		        td.appendChild(input);
		        input.style.display = "none";
		        input.value = formInfo[3];

                // SPLIT FILE INPUTS
		        formFields = formInfo[3].split(",");

                // FOR EACH FILE
		        for (var formFieldsIndex = 0; formFieldsIndex < formFields.length; formFieldsIndex++) {
		            tr = iframe.createElement("tr");
		            tr.style.border = "solid thin";
		            table.appendChild(tr);

                    // DISPLAY FILE NAME
		            td = iframe.createElement("td");
		            td.style.width = "200px";
		            tr.appendChild(td);
		            labelField = iframe.createElement("h5");
		            td.appendChild(labelField);
		            labelField.innerHTML = formFields[formFieldsIndex];
		            labelField.style.cssFloat = "left";

                    // CREATE FILE INPUT
		            td = iframe.createElement("td");
		            tr.appendChild(td);
		            input = iframe.createElement("input");
		            input.id = "input" + formsIndex + formFieldsIndex;
		            input.name = formFields[formFieldsIndex];
		            input.type = "file";
		            input.accept = ".csv";
		            
		            td.appendChild(input);
		        }

		        tr = iframe.createElement("tr");
		        table.appendChild(tr);

		        td = iframe.createElement("td");
		        td.colSpan = "2";
		        td.style.textAlign = "center";
		        tr.appendChild(td);

                // CREATE SUBMIT BUTTON
		        button = iframe.createElement("input");
		        button.type = "submit";
		        button.name = "button" + formsIndex;
		        button.id = "button" + formsIndex;
		        button.value = "Upload";
		        
		        td.appendChild(button);
		        button.onclick = function () {
		            var tableRecord;
		            var flag = 0;

                    // GET FORM TABLE
		            var table = this.parentNode.parentNode.parentNode;
		            var thisForm = table.parentNode;

                    // TOTAL NUMBER OF FILES IS EQUAL TO TOTAL RECORDS SUBTRACTED BY HEADER TABLE RECORD AND SUBMIT BUTTON RECORD
		            var inputFileCount = table.children.length - 2;

                    // FOR EACH FILE
		            for(index = 0; index < inputFileCount; index++) {
		                tableRecord = table.children[index + 1];

                        // CHECK IF FILE WAS SELECTED
		                if (tableRecord.children[1].lastChild.files.length == 0) {
		                    flag = 1;
		                    tableRecord.children[0].lastChild.style.color = "red";
		                } else {
		                    tableRecord.children[0].lastChild.style.color = "#696969";
		                }
		            }
                    
                    // IF FILE INPUT IS MISSING A FILE, ALERT AND PREVENT POSTING
		            if (flag == 1) {
		                alert("Missing file(s) for that function.");
		                return false;
		            } else {
		                this.style.display = "none";
		                return true;
		            }
		        };
		    }
		}

		/********************************* SHOWLOADINGIMG *********************************
		DESCRIPTION: DISPLAYS LOADING GIF
		FUNCTIONALITY: 
		PARAMETERS: 
		*/
		function showLoadingImg() {
		    imgLoadingGif.style.display = "";
		}

		/********************************* HIDELOADINGIMG *********************************
		DESCRIPTION: HIDES LOADING GIF
		FUNCTIONALITY: 
		PARAMETERS: 
		*/
		function hideLoadingImg() {
		    imgLoadingGif.style.display = "none";
		}

		/********************************* SETREPORTIFRAMESRC *********************************
		DESCRIPTION: DOWNLOADS POST-IMPORT REPORTS
		FUNCTIONALITY: CREATES THE IFRAME CONTAINING THE PAGE THAT DOWNLOADS THE REPORT XLSX.
					EXCEL IS SAVED ON SERVER IN A PREDETERMINED LOCATION. PASSES THE FILENAME TO 
					BE DOWNLOADED IN THE DOWNLOAD PAGE.
		PARAMETERS: 
			REPORT - STRING. THE REPORT FILENAME.
		*/
		function setReportIFrameSrc(report) {
		    var src;
		    var iframe = document.createElement('iframe');
			
		    iframe.style.visibility = 'hidden';
		    iframe.style.width = '0px';
		    iframe.style.height = '0px';
		    iframe.src = "excel-download.aspx?file=" + report;

		    document.getElementById("divOptionsContainer").appendChild(iframe);
		}


		function removeReportIFrame() {
		    document.getElementById("divOptionsContainer").removeChild(iframe);
		}

		function PostAjax(params) {
		    var AjaxRequest = new XMLHttpRequest();

		    // OPEN ADDRESS TO BE POSTED TO, MATH.RANDOM PREVENTS CACHING IN IE
		    AjaxRequest.open("POST", '/AJAX/ajx-import-form.aspx?t=' + Math.random(), false);
		    AjaxRequest.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		    // SEND PARAMETER STRING
		    AjaxRequest.send(params);
		    // RETURN POTENTIAL ERROR MESSAGE
		    return AjaxRequest.responseText;
		}
    </script>
</asp:Content>