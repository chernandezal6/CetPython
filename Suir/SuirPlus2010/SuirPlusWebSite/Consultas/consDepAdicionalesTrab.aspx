<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDepAdicionalesTrab.aspx.vb" Inherits="Consultas_consDepAdicionalesTrab" title="Consulta de Dependientes por Trabajadores" %>
<%@ Register Src="../Controles/ucDependientes.ascx" TagName="ucDependientes" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
   <script language="javascript" type="text/javascript">
	function checkNum()
	    {
            var carCode = event.keyCode;
            
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
         }
         </script>
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
            Me.PermisoRequerido = 152
				
        End Sub
	</script>

    <script language="javascript" type="text/javascript">
        function Sel()
        {
            if ((document.aspnetForm.ctl00$MainContent$txtDocumento.value.length) !== 11)
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[1].selected = true;
            }
            else
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[0].selected = true;
            }
        }
    </script>

	<span class="header">Consulta de Dependientes por Titular</span>
	<br />
	<br />
	<asp:UpdatePanel runat="server" ID="UpDependiente" UpdateMode="Conditional">
	<ContentTemplate>
	<table id="Table2" cellspacing="0" cellpadding="0" width="25%" border="0">
		<tr>
			<td align="center" colspan="3">
				<table class="tblWithImagen" id="table5" style="BORDER-COLLAPSE: collapse" cellspacing="1" cellpadding="0">
					<tr>
						<td style="width: 20%" rowspan="4"><img height="90" src="../images/upcatriesgo.jpg" width="167" alt="" /></td>
					</tr>
					<tr>
						<td align="right" style="width: 15%">&nbsp;
						    <asp:dropdownlist id="drpTipoConsulta" runat="server" CssClass="dropDowns">
								<asp:ListItem Value="C" Selected="True">Cédula</asp:ListItem>
								<asp:ListItem Value="N">NSS</asp:ListItem>
							</asp:dropdownlist></td>
						<td>
						    &nbsp;<asp:textbox id="txtDocumento" onKeyPress="checkNum()" runat="server" MaxLength="16" OnKeyUp="Sel()" OnChange="Sel()"></asp:textbox>
					    </td>
					</tr>
					<tr>
						<td align="center" colspan="2"><asp:button id="btnBuscarRef" runat="server" EnableViewState="False" Enabled="True" Text="Buscar"></asp:button>&nbsp;&nbsp;<asp:button id="btnLimpiar" runat="server" Text="Limpiar"></asp:button></td>
					</tr>
				</table>
				<asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" Display="Dynamic" ErrorMessage="Solo digite número en este campo"
					ControlToValidate="txtDocumento" ValidationExpression="\d*" font-size="Small"></asp:regularexpressionvalidator>
		    </td>
		</tr>
	</table>
	<br />
	<asp:label id="LblError" runat="server" CssClass="error" EnableViewState="False" font-size="Small"></asp:label><br />
	<table cellspacing="0" cellpadding="0" border="0">
		<tr>
			<td style="height: 12px"><asp:label id="lblTitulo" CssClass="subHeader" Visible="False" Runat="server">Información del Titular</asp:label></td>
		</tr>
		<tr>
			<td>
			    <asp:gridview id="gvTrabajador" runat="server" CssClass="list" Width="550px" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="id_nss" HeaderText="NSS">
							<HeaderStyle Width="80px"></HeaderStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="no_documento" HeaderText="No. Documento">
						    <headerstyle wrap="false" />
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="nombres" HeaderText="Nombres">
							<HeaderStyle Width="150px"></HeaderStyle>
							<ItemStyle HorizontalAlign="Left"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="apellidos" HeaderText="Apellidos">
							<HeaderStyle Width="180px"></HeaderStyle>
							<ItemStyle HorizontalAlign="Left"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="fecha_nacimiento" HeaderText="Fecha Nacimiento" DataFormatString="{0:d}" HtmlEncode="false">
						    <headerstyle wrap="false" />
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:gridview>
				<br />
                <uc1:ucDependientes ID="UcDep" runat="server" Visible="false" EnableViewState="false" />
            </td>
		</tr>
	</table>
		</ContentTemplate>
	</asp:UpdatePanel>
</asp:Content>