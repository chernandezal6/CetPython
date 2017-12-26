<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="MantCalculoIR3.aspx.vb" Inherits="Empleador_MantCalculoIR3" title="Cálculo Inical de IR3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
				Me.PermisoRequerido = 144
				
			End Sub
		</script>	
		<div align="left" Class="header">Cálculo Inicial de IR3</div>
			
			<table id="Table1" cellspacing="1" cellpadding="1" border="0" style="width: 216px" class="td-content">

				<TR>
					<TD align="left" style="width: 33px; text-align: right;">
						<asp:label id="lblRNC" runat="server" Width="68px">RNC / Cédula:</asp:label></TD>
					<TD align="left" style="width: 200px"><asp:textbox id="txtRNC" runat="server" MaxLength="16"></asp:textbox></TD>
				</TR>
				<TR>
					<TD align="center" colspan="2" style="text-align: left"><asp:regularexpressionvalidator id="regExpRncCedula" runat="server" CssClass="error" ValidationExpression="^(\d{9}|\d{11})$"
							ErrorMessage="RNC o Cédula invalido." ControlToValidate="txtRNC"></asp:regularexpressionvalidator></TD>
				</TR>
				<tr>
					<TD align="center" colSpan="2" style="text-align: left; height: 20px;">
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                        <asp:button id="btCalculoIR3" runat="server" Text="Calcular" Enabled="True" EnableViewState="False"></asp:button></TD>
				</tr>

			</TABLE>
    <asp:Label ID="lblFormError" runat="server" CssClass="error"></asp:Label>

</asp:Content>

