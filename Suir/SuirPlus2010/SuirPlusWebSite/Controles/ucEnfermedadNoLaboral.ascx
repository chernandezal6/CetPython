<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucEnfermedadNoLaboral.ascx.vb" Inherits="Controles_ucEnfermedadNoLaboral" %>
<asp:UpdatePanel runat="server" UpdateMode="Conditional" ID="udPanel">
    <Triggers>
        <asp:PostBackTrigger ControlID="gvNovedades"  />
    </Triggers>
    <ContentTemplate>

        <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>

        <asp:GridView ID="gvNovedades" runat="server" CellPadding="4" Width="800PX" AutoGenerateColumns="False"
            DataKeyNames="ID_MOVIMIENTO,ID_LINEA">
            <Columns>
                <asp:BoundField DataField="NO_DOCUMENTO" HeaderText="Documento" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                <asp:BoundField DataField="NOMBRE" HeaderText="Nombre" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                <asp:BoundField DataField="Nomina_des" HeaderText="Nomina" ItemStyle-HorizontalAlign="Center"></asp:BoundField>

                <asp:TemplateField HeaderText="Salario SS" ItemStyle-HorizontalAlign="Center">
                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                    <ItemTemplate>
                        <%#FormatNumber(Eval("SALARIO_SS"))%>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="periodo_aplicacion" HeaderText="Periodo Desde" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                <asp:BoundField DataField="sfs_secuencia" HeaderText="Periodo Hasta" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:ImageButton CausesValidation="False" ID="iBtnBorrar" runat="server"
                            ToolTip="Borrar" ImageUrl="../images/error.gif"
                            CommandName="Borrar" BorderWidth="0px"></asp:ImageButton>&nbsp;
				<asp:Label ID="lblIdMov" runat="server" Text='<%# Eval("ID_MOVIMIENTO") %>'
                    Visible="False">
                </asp:Label>
                        <asp:Label ID="lblIdLinia" runat="server" Text='<%# Eval("ID_LINEA") %>'
                            Visible="False">
                        </asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        
    </ContentTemplate>
</asp:UpdatePanel>
