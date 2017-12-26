<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consArchivosProcesadosDiv.aspx.vb" Inherits="Bancos_consArchivosProcesadosDiv" title="Consulta de Archivos Procesados" %>

<%@ Register Src="../Controles/UC_DatePicker.ascx" TagName="UC_DatePicker" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header">Consulta de Archivos Procesados</div>
		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
		        Me.PermisoRequerido = 62
				
			End Sub
		</script>

    <br />
  <asp:Label ID="lblFormError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
<table>
    <tr>
        <td><asp:label id="Label1" runat="server" CssClass="subHeader" EnableViewState="False">Por Número Envío.: </asp:label></td>
    </tr>
</table>
<table id="table1" cellSpacing="1" cellPadding="1" border="0" class="td-content">
    <tr>
        <td>
            <span align="right"><asp:label id="Label3" runat="server" EnableViewState="False">Número de Envío:</asp:label></span>
        </td>
        <td><asp:textbox id="txtLote" runat="server" MaxLength="16"></asp:textbox></td>
        <td align="center" colSpan="2"><asp:button id="btBuscarRef" runat="server" Text="Buscar" Enabled="true" EnableViewState="False"></asp:button></td>
    </tr>
</table>
<br>
<table>
    <tr>
        <td><asp:label id="Label2" runat="server" CssClass="subHeader" EnableViewState="False">Por Fechas.: </asp:label></td>
    </tr>
</table>
<table id="table2" cellSpacing="1" cellPadding="1" border="0" class="td-content">
    <tr>
        <td>
            <span align="right"><asp:label id="lbltxtFechaIni" runat="server">Desde .:</asp:label></span>
        </td>
        <td><uc1:uc_datepicker id="ucFechaIni" runat="server"></uc1:uc_datepicker></td>
    </tr>
    <tr>
        <td style="HEIGHT: 8px">
            <span align="right"><asp:label id="lbltxtFechaFin" runat="server">Hasta .:</asp:label></span>
        </td>
        <td><uc1:uc_datepicker id="ucFechaFinal" runat="server"></uc1:uc_datepicker></td>
        <td align="center" colSpan="2"><asp:button id="btBuscarFecha" runat="server" Text="Buscar" Enabled="true" EnableViewState="False"></asp:button></td>
    </tr>
</table>
    <br />
    <table>
        <tr>
            <td>
               <asp:GridView ID="dgDetalle1" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center">
        <Columns>
            <asp:BoundField DataField="id_recepcion" HeaderText="No. Lote.:" />
            <asp:BoundField DataField="fecha_carga" HeaderText="Fecha Env&#237;o:" />
            <asp:BoundField DataField="entidad_recaudadora_des" HeaderText="Entidad Recaudadora" />
            <asp:BoundField DataField="status" HeaderText="Status:" />
            <asp:BoundField DataField="registros_ok" HeaderText="Registro Ok.:" />
            <asp:BoundField DataField="registros_bad" HeaderText="Registro AC/RC:" />
            <asp:TemplateField HeaderText="Archivo Respuesta:">
                <ItemTemplate>
                    <asp:LinkButton ID="linkrespuesta1" runat="server" CommandName="respuesta1">
                        <%#getArchivoCorrecto(Eval("nombre_archivo_respuesta"))%>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Archivo Nacha:">
                <ItemTemplate>
                    <asp:LinkButton id="lnkNacha1" runat="server" CommandName="nacha1">
                        <%# getArchivoCorrecto(Eval("nombre_archivo_nacha")) %>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField> 
            <asp:BoundField DataField="id_tipo_movimiento" HeaderText="Tipo Archivo:" />
        </Columns>
                   <RowStyle HorizontalAlign="Center" />
    </asp:GridView>
            </td>
        </tr>
        <tr>
            <td>
                  <asp:GridView ID="dgDetalle" runat="server" AutoGenerateColumns="False" HorizontalAlign="Center" CellPadding="1">
                    <Columns>
                        <asp:BoundField DataField="id_recepcion" HeaderText="No. Lote.:" />
                        <asp:BoundField DataField="fecha_carga" HeaderText="Fecha Env&#237;o:" />
                        <asp:BoundField DataField="entidad_recaudadora_des" HeaderText="Entidad Recaudadora" />
                        <asp:BoundField DataField="status" HeaderText="Status:" />
                        <asp:BoundField DataField="registros_ok" HeaderText="Registro Ok.:" />
                        <asp:BoundField DataField="registros_bad" HeaderText="Registro AC/RC:" />
                        <asp:TemplateField HeaderText="Archivo Respuesta:">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkRespuesta" runat="server" CommandName="respuesta">
                                    <%#getArchivoCorrecto(Eval("nombre_archivo_respuesta"))%>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Archivo Nacha:">
                            <ItemTemplate>
                                <asp:LinkButton id="lnkNacha" runat="server" CommandName="nacha">
                                    <%# getArchivoCorrecto(Eval("nombre_archivo_nacha")) %>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                   <asp:BoundField DataField="id_tipo_movimiento" HeaderText="Tipo Archivo:" />
                    </Columns>
                              <RowStyle HorizontalAlign="Center" />
                </asp:GridView>
                <asp:Panel ID="pnlNavigation" runat="server" Visible="False">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <asp:linkbutton id="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
	                                CommandName="First" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
                                <asp:linkbutton id="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion" Text="< Anterior"
	                                CommandName="Prev" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;
                                Página
	                                [<asp:label id="lblCurrentPage" runat="server"></asp:label>] de
                                <asp:label id="lblTotalPages" runat="server"></asp:label>&nbsp;
                                <asp:linkbutton id="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
	                                CommandName="Next" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
                                <asp:linkbutton id="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
	                                CommandName="Last" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;                    
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>                 
                        </tr>           
                        <tr>
                            <td>                         
                                Total de archivos&nbsp;
                                <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server"/>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
    
    <br />
    <asp:Panel ID="pnlResultado" runat="server" Visible="False">
        <table id="table8" border="0" cellpadding="0" cellspacing="3" class="td-note" width="650">
            <tr>
                <td class="LabelDataGreen" width="5%">
                    Estatus:</td>
                <td width="30%">
                    <asp:Label ID="lblEstatus" runat="server" CssClass="LabelDataGris"></asp:Label></td>
                <td class="LabelDataGreen" width="15%">
                    Resultado:</td>
                <td colspan="3">
                    <asp:Label ID="lblMensajeResultado" runat="server" CssClass="LabelDataGris"></asp:Label></td>
            </tr>
            <tr>
                <td class="LabelDataGreen" width="5%">
                    Usuario:</td>
                <td colspan="5">
                    <asp:Label ID="lblUsuario" runat="server" CssClass="LabelDataGris"></asp:Label></td>
            </tr>
        </table>
        <asp:GridView ID="dgError" runat="server" AutoGenerateColumns="False" Visible="False">
            <Columns>
                <asp:BoundField DataField="status" HeaderText="Status.:" />
                <asp:BoundField DataField="error_des" HeaderText="Error:" />
                <asp:BoundField DataField="Usuario_Carga" HeaderText="Usuario" />
            </Columns>
        </asp:GridView>
        <br>
    </asp:Panel>
  
</asp:Content>

