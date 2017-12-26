<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsAsignacionNSSEmpleador.aspx.vb" Inherits="Asignacion_NSS_ConsAsignacionNSSEmpleador" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
     <script type="text/javascript">
        $(function () {
            var curr_year = new Date().getFullYear();
            $(".Calendario").datepicker({
                dateFormat: 'dd/mm/yy',
                changeMonth: true,
                changeYear: true,
                yearRange: '1900:' + curr_year,
                numberOfMonths: 1
            });
        });
    </script> 
    <div class="bigtitle">
        <span class="header">Consulta de solicitudes de asignación de NSS por empleador</span>
    </div>
    <br />
    <table class="td-content" style="width: 270px">
        <tr>
            <td></td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap">RNC:</td>
            <td>
                <asp:Label ID="lblRnc" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap">Razón social:</td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td style="text-align: right">Estatus: </td>
            <td>
                <asp:DropDownList ID="ddlEstatus" runat="server" AutoPostBack="true" TabIndex="1"></asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td style="text-align: right" nowrap="nowrap">Fecha Desde: </td>
            <td>
                <asp:TextBox ID="txtFechaDesde" runat="server" TabIndex="2" CssClass="Calendario"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td style="text-align: right" nowrap="nowrap">Fecha Hasta: </td>
            <td>
                <asp:TextBox ID="txtFechaHasta" runat="server" TabIndex="3" CssClass="Calendario"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td colspan="2" style="width: 80%; text-align: center">
                <asp:Button ID="btBuscar" runat="server" Text="Buscar" />&nbsp;
                <asp:Button ID="btLimpiar" runat="server" Text="Limpiar" CausesValidation="false" />
                <br />
                <br />
            </td>
        </tr>
    </table>
    <br />
    <asp:Label ID="lblMensajeError" runat="server" Visible="False" CssClass="error" Font-Size="Small"></asp:Label><br />
    <asp:Label ID="lblmensaje" runat="server" Visible="False" EnableViewState="False" CssClass="label-Blue" Font-Size="Small"></asp:Label><br />
    <asp:GridView ID="gvSolicitudGeneral" runat="server" AutoGenerateColumns="False" Width="90%">
        <Columns>
            <asp:BoundField HeaderText="Solicitud" DataField="Solicitud" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Tipo Solicitud" DataField="TipoSolicitud" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Fecha Solicitud" DataField="FechaSolicitud" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Estatus" DataField="Estatus" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Motivo" DataField="MotivoRechazo" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Tipo Documento Solicita" DataField="TipoDoc" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Documento Solicita" DataField="Expediente" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Apellidos" DataField="Apellidos" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Sexo" DataField="Sexo" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Fecha Nacimiento" DataField="FechaNacimiento" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="NSS" DataField="Nss" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="No. Documento" DataField="NroDoc" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Imagen" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:ImageButton ID="ibImagen" runat="server" ImageUrl="~/images/pdf.png" CommandName="VerSol" CommandArgument='<%# Eval("Solicitud")%>' />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Certificación" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:ImageButton ID="ibCertificacion" runat="server" Visible="false" ImageUrl="~/images/pdf_blue.png" CommandName="VerCer" CommandArgument='<%# Eval("Solicitud")%>' />
                    <asp:Button ID="btnCertificacion" runat="server" Visible="false" Text="Crear Certificación" CommandName="Crear" CommandArgument='<%# Eval("Solicitud") & "," & Eval("Nss")%>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />

    <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
        <table cellpadding="0" cellspacing="0" width="550px">
            <tr>
                <td style="height: 24px">
                    <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                    [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                    <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                    <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                    &nbsp;<uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                </td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>

