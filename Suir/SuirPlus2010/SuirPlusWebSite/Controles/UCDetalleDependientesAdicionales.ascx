<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCDetalleDependientesAdicionales.ascx.vb" Inherits="Controles_UCDetalleDependientesAdicionales" %>
<%@ Register src="ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>


<br />

<asp:panel id="pnlNomina" Runat="server">
    <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="11pt" ForeColor="#006699"
        Width="335px">Detalle Dependientes Adicionales</asp:Label><br />
<table id="tblDetalle" cellpadding="0" cellspacing="0" runat="server">
    <tr>
        <td>

<asp:Label ID="lblMensaje" runat="server" CssClass="error" font-size="9pt"></asp:Label><br />
            <br />
            <asp:DropDownList ID="ddlBusqueda" runat="server" CssClass="dropDowns">
                <asp:ListItem Value="A">Apellido</asp:ListItem>
                <asp:ListItem Value="D">Documento</asp:ListItem>
            </asp:DropDownList>
            <asp:TextBox ID="txtCriterio" runat="server" Width="185px"></asp:TextBox>
            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" /></td>
    </tr>
    
     </table> 
  
 <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
 <table>
    <tr>
        <td>
            <asp:GridView ID="gvDetalleDependiente" runat="server" autogeneratecolumns="false">
                <Columns>
                    <asp:BoundField DataField="Doc_Empleado" HeaderText="Doc. Titular">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Nombre_Empleado" HeaderText="Nombre del Titular">
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Doc_Dependiente" HeaderText="Doc. Dependiente">
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Nombre_Dependiente" HeaderText="Nombre del Dependiente" />
                    <asp:BoundField DataField="Fecha_Registro" DataFormatString="{0:d}" HeaderText="Fecha Ingreso" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
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
            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label></td>
    </tr>
    <tr>
        <td>
            <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
         </td>
    </tr>
     <tr>
         <td>
             <br />
             Total de Dependientes&nbsp;
             <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
         </td>
     </tr>
</table>

 </asp:panel>

</asp:panel>

<br />
<br />
            