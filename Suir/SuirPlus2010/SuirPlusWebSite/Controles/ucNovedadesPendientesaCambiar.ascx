<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucNovedadesPendientesaCambiar.ascx.vb"
    Inherits="Controles_ucNovedadesPendientesaCambiar" %>


<table class="td-content">

    <tr> 
        <td class="header" style="text-align: center;" nowrap="true">
            Novedades Pendientes A Cambiar
        </td>
    </tr>
    <tr style="text-align: right;">
        <td>
            <asp:Button ID="btnAplicarNovedad" runat="server" Text="Aplicar" />
        </td>
    </tr>
    <tr style="text-align: center;">
        <td>
            <asp:GridView ID="gvNovedadesPendientes" runat="server" Width="700px" AutoGenerateColumns="false">
                <Columns>
                
                    <asp:BoundField DataField="NO_DOCUMENTO" HeaderText="Documento"></asp:BoundField>
                    <asp:BoundField DataField="NOMBRE" HeaderText="Nombre completo"></asp:BoundField>
                    <asp:BoundField DataField="ID_NOVEDAD" HeaderText="Novedades Pendiente"></asp:BoundField>
                    <asp:BoundField DataField="DESCRIPCION" HeaderText="Tipo de Cambio"> 
                        <ItemStyle Width="200px" HorizontalAlign="Center"></ItemStyle>
                   </asp:BoundField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="btnEliminar" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif" 
                                CommandName="Borrar" CommandArgument='<%# Eval("ID_NSS") & "|" & Eval("tipo_cambio") & "|" & Eval("fecha_cambio")%>'>
                            </asp:ImageButton>
                         
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
    <tr>
        <td>
        
            <asp:Label ID="lbMensaje" runat="server" class="labelData"></asp:Label>
            <br />
            <asp:Label ID="lblMensajeError" runat="server" class="error"></asp:Label>
        </td>
    </tr>
</table>

