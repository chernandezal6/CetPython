<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCDetalleDependientesReferencia.ascx.vb" Inherits="Controles_UCDetalleDependientesReferencia" %>
<%@ Register Src="ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>

<asp:panel id="pnlNomina" Visible="false" Runat="server">
	<table class="td-content" id="Table2" cellspacing="0" cellpadding="0" width="400">
		<tr>
			<td class="header" colspan="2">Detalle Dependientes Adicionales</td>
		</tr>
		<tr>
			<td style="HEIGHT: 12px"></td>
		</tr>
		<tr>
			<td style="HEIGHT: 12px" align="right" width="20%">Empleador:&nbsp;</td>
			<td style="HEIGHT: 12px">
				<asp:label class="labelData" id="lblEmpleador" runat="server"></asp:label></td>
		</tr>
		<tr>
			<td style="HEIGHT: 12px" align="right" width="20%">Tipo Nómina:&nbsp;</td>
			<td style="HEIGHT: 12px">
				<asp:label class="labelData" id="lblNomina" runat="server"></asp:label></td>
		</tr>
		<tr>
			<td style="HEIGHT: 12px" align="right" width="20%">Referencia:&nbsp;</td>
			<td style="HEIGHT: 12px">
				<asp:label class="labelData" id="lblReferencia" runat="server"></asp:label></td>
		</tr>
	</table> 


<br />
<asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
<table id="tblDependientes" cellpadding="0" cellspacing="0" style="width: 80%" runat="server">
    <tr>
        <td style="height: 19px">
            <asp:DropDownList ID="ddlBusqueda" runat="server" CssClass="dropDowns">
                <asp:ListItem Value="A">Apellido</asp:ListItem>
                <asp:ListItem Value="D">Documento</asp:ListItem>
            </asp:DropDownList>
            <asp:TextBox ID="txtCriterio" runat="server" Width="188px"></asp:TextBox>
            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
            &nbsp;<uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
        </td>
    </tr>
    <tr>
        <td>
            <asp:GridView ID="gvDetalleDependiente" runat="server" Width="80%" autogeneratecolumns="false">
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
                      <asp:BoundField DataField="per_capita_adicional" HeaderText="Per capita" DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                     <asp:BoundField DataField="per_capita_fonamat" HeaderText="Monto Res.265-01" DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
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
            Total de Dependientes&nbsp;
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
         </td>
    </tr>
</table>
</asp:panel>