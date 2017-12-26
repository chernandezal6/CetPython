<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDependienteAdicional.aspx.vb" Inherits="Consultas_consDependienteAdicional" title="Dependientes Adicionales por Titular" %>
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
	
	        Me.PermisoRequerido = 153
	
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
    
	<span class="header">Consulta de Titular por Dependiente</span>
	<br />
	<br />
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
							</asp:dropdownlist>
						</td>
						<td>&nbsp;<asp:textbox id="txtDocumento" onKeyPress="checkNum()" runat="server" MaxLength="11" OnKeyUp="Sel()" OnChange="Sel()"></asp:textbox>
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
							<asp:button id="btnBuscar" runat="server" Text="Buscar" Enabled="True" EnableViewState="False"></asp:button>&nbsp;
							<asp:button id="btnLimpiar" runat="server" Text="Limpiar"></asp:button></td>
					</tr>
				</table>
				<asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ValidationExpression="\d*" ControlToValidate="txtDocumento"
					ErrorMessage="Solo digite número en este campo" Display="Dynamic" font-size="Small"></asp:regularexpressionvalidator></td>
		</tr>
	</table>
	<br />
	<asp:Label id="lblError" runat="server" CssClass="error" EnableViewState="False" font-size="Small"></asp:Label><br />
	<table id="Table1" cellspacing="0" cellpadding="0" width="680" border="0">
		<tr>
			<td><asp:label id="lblTituloDependiente" CssClass="subHeader" Runat="server" Visible="False">Información del Dependiente</asp:label></td>
		</tr>
		<tr>
			<td>
			    <asp:gridview id="gvDependiente" runat="server" CssClass="list" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="razon_social" HeaderText="Empleador">
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="nomina_des" HeaderText="Nómina">
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="documento" HeaderText="Documento">
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="nombres" HeaderText="Nombres">
						    <headerstyle width="150px" />												
							<ItemStyle Wrap="False" HorizontalAlign="Left"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="apellidos" HeaderText="Apellidos">
							<ItemStyle Wrap="False" HorizontalAlign="Left" width="180px"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="fecha_registro" HeaderText="Fecha Ingreso" DataFormatString="{0:d}" HtmlEncode="false">
						    <headerstyle wrap="false" />
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:gridview>
			</td>
		</tr>
	</table>
	<br />
	<table id="tblDetalleTitutar" cellspacing="1" cellpadding="1" width="550px" border="0">
		<tr>
			<td><asp:label id="lblTitular" runat="server" CssClass="subHeader" Visible="False">Información del Titular</asp:label></td>
		</tr>
		<tr>
			<td>
			    <asp:gridview id="gvDetalleTitutar" runat="server" CssClass="list" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="id_nss" HeaderText="NSS">
						    <headerstyle width="80px" />
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="documento" HeaderText="No. Documento">
						    <headerstyle wrap="false" />
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="nombres" HeaderText="Nombres">
						    <headerstyle width="150px" />						
							<ItemStyle Wrap="False" HorizontalAlign="Left"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="apellidos" HeaderText="Apellidos">
						    <headerstyle width="180px" />												
							<ItemStyle Wrap="False" HorizontalAlign="Left"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="fecha_nacimiento" HeaderText="Fecha Nacimiento" DataFormatString="{0:d}" HtmlEncode="false">
						    <headerstyle wrap="false" />
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:gridview>
			</td>
		</tr>
	</table>
</asp:Content>

