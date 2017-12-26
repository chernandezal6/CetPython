<%@ Page Title="Seguimiento Acuerdos de Pago Vencidos" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SeguimientoAcuerdosPagos.aspx.vb" Inherits="Legal_SiguimientoAcuerdosPagos" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Visible="False"></asp:Label><br />
    <fieldset style="width: 600px"><legend>Seguimiento Acuerdos de Pago Vencidos</legend>
        <table align="left" id="Table1" width="550">
            <tr>
                <td>
                    <asp:GridView ID="gvSeguimientoAcuerdosPago" runat="server" AutoGenerateColumns="False"
                        CellPadding="3" Width="100%">
                        <Columns>
                            <asp:TemplateField HeaderText="RNC">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnVer" runat="server" CausesValidation="false" CommandName="Ver"
                                        CommandArgument='<%#Eval("rnc_o_cedula")%>'><%# formateaRNC_Cedula(Eval("rnc_o_cedula"))%></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="id_acuerdo" HeaderText="Acuerdo de Pago">
                                <HeaderStyle Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="cuotas_atrasadas" HeaderText="Cuotas Atrasadas">
                                <ItemStyle HorizontalAlign="center" Wrap="False" />
                                <HeaderStyle Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="monto_atrasado" HeaderText="Monto Atrasado" DataFormatString="{0:n}"
                                HtmlEncode="False">
                                <HeaderStyle Wrap="False" />
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>

                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnCancelar" runat="server" CausesValidation="false" CommandName="Cancelar"
                                        CommandArgument='<%#Eval("id_acuerdo")%>'>Cancelar</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            
                            
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
    </fieldset>
</asp:Content>
