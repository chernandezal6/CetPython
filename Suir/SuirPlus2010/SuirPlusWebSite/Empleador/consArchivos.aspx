<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consArchivos.aspx.vb" Inherits="Empleador_consArchivos" title="Consulta de Recepción de Archivos" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc4" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc2" %>
<%@ Register Src="../Controles/UCDependientesAdicionales.ascx" TagName="UCDependientesAdicionales"
    TagPrefix="uc3" %>
<%@ Register Src="~/Controles/UCArchivosDetalle.ascx" TagName="UCArchivosDetalle" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
	        
	        Me.RolesOpcionales = New String() {31, 520}
	        
	    End Sub
	</script>
	<table cellspacing="0" cellpadding="0" width="100%"> 		
		<tr>
			<td>
				<span class="header">Consulta&nbsp;envíos de archivos</span>
			</td>
		</tr>
		<tr>
			<td height="10">
                <uc4:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
            </td>
		</tr>
		<tr>
			<td>
				<table class="td-content">
					<tr>
						<td>No. de Referencia:</td>
						<td><asp:textbox id="txtReferencia" runat="server"></asp:textbox><asp:requiredfieldvalidator id="reqTxtRef" runat="server" ControlToValidate="txtReferencia">*</asp:requiredfieldvalidator></td>
						<td><asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	<table>
		<tr>
			<td colspan="2" height="20"></td>
		</tr>
		<tr>
			<td width="1%"><img height="20" src="../images/pin.gif" width="20" alt="" /></td>
			<td class="subHeader" style="width: 1075px">Últimos&nbsp;archivos cargados</td>
		</tr>
		<tr>
			<td colspan="2">
			    <asp:GridView id="gvUltimosArchivos" runat="server" AutoGenerateColumns="False" Width="700px">
					<Columns>
						<asp:BoundField DataField="id_recepcion" HeaderText="Referencia">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
						<asp:BoundField DataField="Tipo_Movimiento_Des" HeaderText="Proceso"></asp:BoundField>
						<asp:BoundField DataField="Status" HeaderText="Estatus"></asp:BoundField>
						<asp:BoundField DataField="Fecha_Carga" HeaderText="Fecha Carga" HtmlEncode="false" DataFormatString="{0:d}">
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Registros_OK" HeaderText="Registros V&#225;lidos">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Registros_Bad" HeaderText="Registros Inv&#225;lidos">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Total_Registros" HeaderText="Total Registros">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:GridView>
			</td>
		</tr>
	</table>
	<br />
	<asp:label id="lblResultado" runat="server" CssClass="subHeader"></asp:label><asp:panel id="pnlResultado" runat="server" Visible="False">
		<table class="td-note" id="table1" cellspacing="3" cellpadding="0" width="600" border="0">
			<tr>
				<td class="LabelDataGreen" width="5%" style="height: 12px">Usuario:</td>
				<td style="width: 200px; height: 16px;"><asp:label id="lblusuario" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label></td>
				<td class="LabelDataGreen" width="5%" style="height: 16px">Proceso:</td>
				<td>
					<asp:label id="lblProceso" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label>
					<asp:Label id="lblTipoProceso" runat="server" Visible="False"></asp:Label>
				</td>
			</tr>
			<tr>
				<td class="LabelDataGreen" width="15%" style="height: 16px">Fecha carga:</td>
				<td style="width: 200px; height: 16px;">
					<asp:label id="lblFechaCarga" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label>
				</td>
				<td class="LabelDataGreen" width="5%">Estatus:</td>
				<td>
					<asp:label id="lblEstatus" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label>
				</td>				
			</tr>
			<tr>
				<td class="LabelDataGreen" width="15%">Resultado:</td>
				<td style="width: 200px">
					<asp:label id="lblMensajeResultado" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label></td>
			</tr>
			<tr>
				<td colspan="6">
					<table cellspacing="0" cellpadding="0" width="100%">
						<tr>
							<td class="LabelDataGreen" width="18%" style="height: 24px">Total Registros:</td>
							<td width="8%" style="height: 24px">
								<asp:label id="lblTotalRegistros" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label></td>
							<td class="LabelDataGreen" width="18%" style="height: 24px">Registros Válidos:</td>
							<td width="5%" style="height: 24px">
								<asp:label id="lblRegistrosValidos" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label></td>
							<td class="LabelDataGreen" width="20%" style="height: 24px">Registros Invalidos:</td>
							<td style="height: 24px">
								<asp:label id="lblRegistrosInvalidos" runat="server" CssClass="LabelDataGris" EnableViewState="False"></asp:label>
								<asp:LinkButton id="lnkVerRegistros" runat="server" Visible="False">Ver registros</asp:LinkButton></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
        <br />
        <uc1:UCArchivosDetalle ID="ctrlArchivos" runat="server" />
        </asp:panel>
</asp:Content>

