<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consArchivoAuditoria.aspx.vb" Inherits="Operaciones_consArchivoAuditoria" title="Consulta envíos de archivos audítoria" %>
<%--Consulta auditoria de archivos--%>
<%@ Register Src="../Controles/UCArchivosDetalleAuditoria.ascx" TagName="UCArchivosDetalleAuditoria"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
            Me.PermisoRequerido = 126
        End Sub
    </script>

    <div class="header">Consulta&nbsp;envíos de archivos audítoria</div>
    <br />
    <asp:UpdatePanel ID="upMain" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
  <table>
	<tr>
		<td nowrap="nowrap">Nro. Envío:</td>
		<td><asp:textbox id="txtReferencia" runat="server" MaxLength="11"></asp:textbox>&nbsp;<asp:Button 
                ID="btnConsultar" runat="server" Text="Consultar" />
            <asp:RequiredFieldValidator ID="reqTxtRef" runat="server" 
                ControlToValidate="txtReferencia" CssClass="error" Display="Dynamic" 
                SetFocusOnError="True">El Nro. de envío es requerido.</asp:RequiredFieldValidator>
        </td>
	</tr>
</table>
    <asp:Label ID="lblResultado" runat="server" CssClass="error" EnableViewState="False"></asp:Label><br />
    <asp:Panel  ID="pnlUltimosArchivosAuditoria" runat="server" Visible="false">
	<table>
		<tr>
			<td width="1%"><img height="20" src="../images/pin.gif" width="20" alt="" /></td>
			<td class="subHeader" style="width: 1075px">Últimos&nbsp;archivos cargados</td>
		</tr>
		<tr>
			<td colspan="2">
			    <asp:GridView id="gvUltimosArchivos" runat="server" AutoGenerateColumns="False" Width="700px">
					<Columns>
						<asp:BoundField DataField="id_recepcion" HeaderText="Envío"></asp:BoundField>
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
</asp:Panel>
    <asp:Panel ID="pnlResultado" runat="server" Visible="False">

        <table id="table1" border="0" cellpadding="0" cellspacing="2" class="td-note" width="650">
            <tr>
                <td class="LabelDataGreen" width="5%" style="width: 10%">
                    Usuario:</td>
                <td>
                    <asp:Label ID="lblusuario" runat="server" CssClass="LabelDataGris"></asp:Label></td>
                <td class="LabelDataGreen" width="5%" style="width: 13%">
                    Proceso:</td>
                <td>
                    <asp:Label ID="lblProceso" runat="server" CssClass="LabelDataGris"></asp:Label>&nbsp;
                </td>
            </tr>
             <tr>
                <td class="LabelDataGreen" width="5%">
                    RNC:</td>
                <td>
                    <asp:Label ID="lblRNC" runat="server" CssClass="LabelDataGris"></asp:Label></td>
                <td class="LabelDataGreen" width="5%">
                    Fecha carga:</td>
                <td>
                    <asp:Label ID="lblFechaCarga" runat="server" CssClass="LabelDataGris"></asp:Label></td>
            </tr>
            <tr>
                <td class="LabelDataGreen" width="5%">
                    Razón Social:</td>
                <td colspan="3">
                    <asp:Label ID="lblRazonSocial" runat="server" CssClass="LabelDataGris"></asp:Label></td>
            </tr>           
            <tr>
                <td class="LabelDataGreen" width="15%">
                                Total Registros:</td>
                <td>
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="LabelDataGris"></asp:Label></td>
                <td class="LabelDataGreen" width="5%">
                    Estatus:</td>
                <td>
                    <asp:Label ID="lblEstatus" runat="server" CssClass="LabelDataGris"></asp:Label>
                </td>
            </tr>
            <tr>
                <td class="LabelDataGreen" width="15%">
                    Resultado:</td>
                <td colspan="3">
                    <asp:Label ID="lblMensajeResultado" runat="server" CssClass="LabelDataGris"></asp:Label></td>
            </tr>
            <tr>
                <td class="LabelDataGreen" width="15%">
                    Reg. Válidos:</td>
                <td>
                                <asp:Label ID="lblRegistrosValidos" runat="server" CssClass="LabelDataGris"></asp:Label></td>
                <td class="LabelDataGreen">
                    Reg. Invalidos:</td>
                <td>
                                <asp:Label ID="lblRegistrosInvalidos" runat="server" CssClass="LabelDataGris"></asp:Label>
                    &nbsp;<asp:LinkButton ID="lnkVerRegistros" runat="server" Visible="False">Ver registros</asp:LinkButton>
                    &nbsp;|&nbsp;                    
                    <asp:LinkButton ID="lnkVolver" runat="server" Visible="true">Volver al Encabezado</asp:LinkButton>
                    </td>
            </tr>           
        </table>
        <br>
         <br>

        <asp:UpdatePanel ID="upDetalle" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
               <uc1:UCArchivosDetalleAuditoria ID="UCArchivosDet" runat="server" Visible="true" />
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="lnkVerRegistros" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>  
              
    </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnConsultar" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>


</asp:Content>

