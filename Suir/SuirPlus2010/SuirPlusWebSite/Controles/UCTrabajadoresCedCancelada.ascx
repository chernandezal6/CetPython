<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCTrabajadoresCedCancelada.ascx.vb" Inherits="Controles_UCTrabajadoresCedCancelada" %>
<table id="Table1" cellspacing="0" cellpadding="0" style="width:80%">
    <tr id="trHeader" runat="server" visible="true">
        <td>
            <div class="header">Trabajadores con Cédula Cancelada</div>
        </td>
    </tr>
    <tr>
        <td>
            <div style="height:2px;"></div>
        </td>
    </tr>
    <tr>
        <td>
            <asp:GridView ID="gvTRabajadoresCedCancel" runat="server" Width="580px" autogeneratecolumns="False">
                <Columns>
                    <asp:BoundField DataField="ID_Nomina" HeaderText="ID N&#243;mina">
                        <ItemStyle HorizontalAlign="Center" width="80px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="tipo_des" HeaderText="Tipo"></asp:BoundField>
                    <asp:BoundField DataField="Nomina_Des" HeaderText="Descripci&#243;n">
                    </asp:BoundField>
                    <asp:BoundField DataField="Trabajadores" HeaderText="Empleados">
                        <ItemStyle HorizontalAlign="Center" width="80px"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="Fecha_Registro" HeaderText="Fecha Creaci&#243;n" HtmlEncode="False" DataFormatString="{0:d}">
                        <ItemStyle HorizontalAlign="Center" width="95px"></ItemStyle>
                    </asp:BoundField>

                    <asp:TemplateField HeaderText="Ver" >
                        <ItemStyle HorizontalAlign="Center"  Wrap="False" width="70px"></ItemStyle>
                        <ItemTemplate>
                            <asp:Label id="lblRegistroPatronal" Runat="server" Visible="False" Text='<%# Eval("ID_Registro_Patronal") %>'>
                            </asp:Label>
                            <asp:Label id="lblNomina" Runat="server" Visible="False" text='<%# Eval("id_nomina") %>'>
                            </asp:Label><img alt="Ver Detalle" src="../images/detalle.gif">&nbsp;
                           
                            <asp:HyperLink id="hlkDetalle" Runat="server">Detalle</asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
    <tr>
        <td>
            <asp:label id="lblResultado" Runat="server" EnableViewState="False" CssClass="error"></asp:label>
        </td>
    </tr>
    <tr>
        <td style="height: 15px;">
        </td>
    </tr>
</table>