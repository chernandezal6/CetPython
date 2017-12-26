<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="empIr17.aspx.vb" Inherits="Empleador_empIr17" title="Declaración del IR-17" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<uc1:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
	<table id="Table4" style="width: 550px">
		<tr>
			<td style="width: 150px"><img src="../images/LogoNewDGII.jpg" width="150" height="69" alt="" /></td>
			<td valign="bottom">
                <asp:Label ID="lblTitulo1" runat="server" CssClass="header"></asp:Label></td>
		</tr>
	</table>    
	<iframe frameborder="0" src="empFormIr17.aspx" width="690" height="800" scrolling="no" style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
	</iframe>
</asp:Content>

