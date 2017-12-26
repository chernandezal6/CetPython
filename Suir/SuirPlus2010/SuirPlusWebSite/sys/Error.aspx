<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="Error.aspx.vb" Inherits="sys_Error" title="Mensaje de Error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <span class="header">Mensaje de Error</span><br/><br/>
	<table class="td-content" id="table1" width="350" border="0">
		<tr>
			<td align="center">
				<asp:Label id="lblError" runat="server" EnableViewState="False" CssClass="error"></asp:Label></td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
	</table>
</asp:Content>

