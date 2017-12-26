<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucDetalleAjuste.ascx.vb"
    Inherits="ucDetalleAjuste" %>
<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="ucExportarExcel.ascx" %>
<style type="text/css">
    p.MsoNormal
    {
        margin-bottom: .0001pt;
        font-size: 11.0pt;
        font-family: "Calibri" , "sans-serif";
        margin-left: 0in;
        margin-right: 0in;
        margin-top: 0in;
    }
    </style>
  <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="11pt" ForeColor="#006699"
        Width="287px">Detalle  de Ajuste para la Referencia: </asp:Label>
                <asp:Label ID="lblNoReferencia" runat="server" Font-Bold="True" Font-Size="11pt" ForeColor="#006699"></asp:Label><br />
<table id="table1" cellspacing="0" cellpadding="0" width="590" border="0">
    <tr>
        <td class="labelData">
            <br />
            <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            <br />
            <br />
  <asp:Label ID="Label2" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="#006699"
        Width="253px">Total de Ajustes </asp:Label>
            <br />
        </td>
    </tr>
    <tr>
        <td>
            
            <asp:GridView ID="gvMonto" Width="300px" runat="server" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
                    <asp:BoundField DataField="Monto" DataFormatString="{0:n}" HeaderText="Monto" >
                    <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
            
        </td>
    </tr>
    <tr>
        <td>
            
            &nbsp;&nbsp;<br />
            <br />
  <asp:Label ID="Label3" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="#006699"
        Width="253px">Detalle de Ajustes </asp:Label>
            <br />
        </td>
    </tr>
    <tr>
        <td>
            <asp:GridView ID="gvDetalle" runat="server" EnableViewState="False" AutoGenerateColumns="False"
                Width="590px">
                <Columns>
                    <asp:BoundField DataField="id_nss" HeaderText="NSS">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Cédula">
                        <ItemTemplate>
                            <asp:Label ID="Label1" runat="server" Text='<%# formateaDocumento(container.dataitem("no_documento")) %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Left" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="nombre" HeaderText="Nombre">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="Descripcion" HeaderText="Tipo Ajuste"></asp:BoundField>
                    <asp:BoundField DataField="Monto" HeaderText="Monto" DataFormatString="{0:n}" HtmlEncode="false">
                        <ItemStyle Wrap="False" HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Tipo" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblTipo" runat="server" Text='<%#eval("TIPO_AJUSTE") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="TIPO_AJUSTE" HeaderText="Ajuste"></asp:BoundField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
    <tr>
        <td>
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
        <td style="height: 12px">
            Total de Empleados&nbsp;
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
        </td>
    </tr>
</table>
<br />
<br />
<img src="../images/detalle.gif" alt="" />&nbsp;<asp:LinkButton ID="lnkEncabezado"
    runat="server">Encabezado</asp:LinkButton>&nbsp;
<uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
