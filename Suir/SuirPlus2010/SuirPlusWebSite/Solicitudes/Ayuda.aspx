<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Ayuda.aspx.vb" Inherits="Solicitudes_Ayuda" title="Ayuda" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >

<head class = "header" runat="server">
    <title>Importante</title>
</head>
<body>
    <form id="form1" runat="server">
        <br />
	       <div align="left" class="header">Información Importante</div>
        <br />
			<TABLE align="left" class="td-note" id="Table2" cellSpacing="1" cellPadding="1" width="400" border="0">
				<TR>
					<TD class="LabelDataGreen" align="left" style="width: 396px"></TD>
				</TR>
				<TR>
					<TD align="left" valign="middle" style="width: 396px">
						<div align="left">&nbsp;
							<asp:Label cssClass="label-Resaltado" id="lblInfo" runat="server"></asp:Label></div>
					</TD>
				</TR>
				<TR>
					<TD style="width: 396px"></TD>
				</TR>
			</TABLE>
    </form>
</body>
</html>
