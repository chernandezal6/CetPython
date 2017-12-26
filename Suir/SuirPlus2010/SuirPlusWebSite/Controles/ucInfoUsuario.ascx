<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucInfoUsuario.ascx.vb" Inherits="Controles_ucInfoUsuario" %>
<asp:panel id="pnlInfoUsuario" runat="server">
	<table cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td align="right" colspan="2" height="14">
				<asp:Label id="lblNombreUsuario" runat="server" CssClass="InfoUsuarioBold" Font-Underline="True"></asp:Label>&nbsp;
			</td>
		</tr>
		<tr>
			<td align="right" width="55">
				<asp:Image id="imgUsuario" runat="server" ImageUrl="~/images/iconorepresentante.gif"></asp:Image>&nbsp;
			</td>
			<td vAlign="bottom" align="right" width="65%">
				<asp:Label id="lblTipoUsuario" runat="server" CssClass="InfoUsuarioBold"></asp:Label>&nbsp;
				<BR>
				<asp:Label id="lblFechaActual" runat="server" CssClass="InfoUsuario"></asp:Label>&nbsp;
			</td>
			<td width="5"></td>
		</tr>
	</table>
	<br />
</asp:panel>
<!-- Panel de acceso al sistema --><asp:panel id="pnlAccesoSistema" runat="server">
	<table cellspacing="0" cellpadding="0">
		<tr>
			<td></td>
			<td class="userInfoLabelBold"></td>
		</tr>
		<tr>
			<td></td>
			<td class="userInfoLabelBold"></td>
		</tr>
	</table>
</asp:panel>
