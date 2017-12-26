<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consEnfermedadPagos.aspx.vb" Inherits="Empleador_consEnfermedadPagos" title="Historico Pagos Enfermedad Comun" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc1" %>
<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucexportarexcel" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header"><span style="font-size: 20px">
        <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
        Historial de Pagos y Errores del 
        Subsidio por Enfermedad Comun<br />
        </span><br /> </div>
        <asp:UpdatePanel ID="upInfo" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
        <div>
        
            <table ID="Table1" cellpadding="0" cellspacing="0" class="td-content" 
                style="width: 550px">
                <tr>
                    <td>
                        <br />
                        <table style="margin-left: 60px">
                            <tr>
                                <td>
                                    Cédula:</td>
                                <td>
                                    <asp:TextBox ID="txtCedula" runat="server" MaxLength="11" Width="100px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                        ControlToValidate="txtCedula" Display="Dynamic" ValidationGroup="filtro">*</asp:RequiredFieldValidator>
                                </td>
                                <td align="right">
                                    <asp:Button ID="btnConsultar" runat="server" Text="Buscar" 
                                        ValidationGroup="filtro" />
                                    <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" 
                                        Text="Limpiar" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <asp:RegularExpressionValidator ID="regExpRncCedula0" runat="server" 
                                        ControlToValidate="txtCedula" Display="Dynamic" ErrorMessage="Cédula inválida." 
                                        Font-Bold="True" ValidationExpression="^[0-9]+$" ValidationGroup="filtro"></asp:RegularExpressionValidator>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <br />
        
        </div>
        <asp:Panel ID="pnlMaternidadPago" runat="server" Visible="false">
            </td>
            <fieldset style="width:800px;">
                <legend>Pagos a Cuenta Bancaria</legend>
                <br />
                <asp:GridView ID="gvPagosCBanco" runat="server" AutoGenerateColumns="False" Width="758px">
                    <Columns>
                        <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" />
                        <asp:TemplateField HeaderText="Cedula">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%#formateaRNC(Eval("Cedula"))%>'></asp:Label>
                            </ItemTemplate>
                            </asp:TemplateField>
                        <asp:BoundField DataField="TipoCuenta" HeaderText="Tipo Cuenta" />
                        <asp:BoundField DataField="CuentaBanco" HeaderText="Cuenta Banco" />
                        <asp:BoundField DataField="Cuota" HeaderText="Cuota" />
                        <asp:BoundField DataField="MontoSubsidio" HeaderText="Monto Subsidio" 
                            DataFormatString="{0:c}" />
                        <asp:TemplateField HeaderText="Periodo">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("Periodo")) %>'></asp:Label>
                            </ItemTemplate>
                            </asp:TemplateField>
                        <asp:BoundField DataField="FechaDispersion" HeaderText="Fecha Dispersion" 
                            DataFormatString="{0:d}" />
                    </Columns>
            </asp:GridView>
            <br />
            </fieldset>
            
            <asp:Panel ID="pnlNavegacion" runat="server" Height="50px">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="height: 24px">
                            <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" 
                                CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                Text="&lt;&lt; Primera"></asp:LinkButton>
                            &nbsp;|
                            <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" 
                                CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="&lt; Anterior"></asp:LinkButton>
                            &nbsp; Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>
                            ] de
                            <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                            &nbsp;
                            <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" 
                                CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="Próxima &gt;"></asp:LinkButton>
                            &nbsp;|
                            <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" 
                                CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                Text="Última &gt;&gt;"></asp:LinkButton>
                            &nbsp;
                            <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Total de Registros:
                            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                            &nbsp;<uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        <br />
       <asp:Label ID="lblMensajeMaternidadPago" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label> 
    </asp:Panel>
       <asp:Panel ID="pnlPagoNotificaiones" runat="server" Visible="false">
           </td>
           <fieldset style="width:650px;">
            <legend> Pagos por Notificación de Pago</legend>
            <br />
                    <asp:GridView ID="gvPagosNotificaciones" runat="server" AutoGenerateColumns="False" Width="614px">
                    <Columns>
                        <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" />
                        <asp:TemplateField HeaderText="Cedula">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%#formateaRNC(Eval("Cedula"))%>'></asp:Label>
                            </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Cuota" HeaderText="Cuota" />
                        <asp:BoundField DataField="MontoSubsidio" HeaderText="Monto Subsidio" 
                            DataFormatString="{0:c}" />
                        <asp:TemplateField HeaderText="Periodo">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("Periodo")) %>'></asp:Label>
                            </ItemTemplate>
                            </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <br />
           </fieldset>
           <asp:Panel ID="pnlNavegacion0" runat="server" Height="50px">
               <table cellpadding="0" cellspacing="0">
                   <tr>
                       <td style="height: 24px">
                           <asp:LinkButton ID="btnLnkFirstPageNP" runat="server" CommandName="First" 
                               CssClass="linkPaginacion" Text="&lt;&lt; Primera"></asp:LinkButton>
                           &nbsp;|
                           <asp:LinkButton ID="btnLnkPreviousPageNP" runat="server" CommandName="Prev" 
                               CssClass="linkPaginacion" Text="&lt; Anterior"></asp:LinkButton>
                           &nbsp; Página [<asp:Label ID="lblCurrentPageNP" runat="server"></asp:Label>
                           ] de
                           <asp:Label ID="lblTotalPagesNP" runat="server"></asp:Label>
                           &nbsp;
                           <asp:LinkButton ID="btnLnkNextPageNP" runat="server" CommandName="Next" 
                               CssClass="linkPaginacion" Text="Próxima &gt;"></asp:LinkButton>
                           &nbsp;|
                           <asp:LinkButton ID="btnLnkLastPageNP" runat="server" CommandName="Last" 
                               CssClass="linkPaginacion" Text="Última &gt;&gt;"></asp:LinkButton>
                           &nbsp;
                           <asp:Label ID="lblPageSizeNP" runat="server" Visible="False"></asp:Label>
                           <asp:Label ID="lblPageNumNP" runat="server" Visible="False"></asp:Label>
                       </td>
                   </tr>
                   <tr>
                       <td>
                           Total de Registros:
                           <asp:Label ID="lblTotalRegistrosNP" runat="server" CssClass="error"></asp:Label>
                           &nbsp;<uc1:ucExportarExcel ID="ucExportarExcel2" runat="server" />
                       </td>
                   </tr>
               </table>
           </asp:Panel>
        <br />
    <asp:Label ID="lblMensajeNotif" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
    </asp:Panel>
        <asp:Panel ID="pnlPagoErrores" runat="server" Visible="false">
            </td>
            <fieldset style="width:900px;">
                <legend>Pagos con Error</legend>
                <br />
                 <asp:GridView ID="gvPagosErrores" runat="server" AutoGenerateColumns="False" Width="854px">
                    <Columns>
                        <asp:BoundField DataField="TipoCuenta" HeaderText="Tipo Cuenta" />
                        <asp:BoundField DataField="CuentaBanco" HeaderText="Cuenta Banco" />
                        <asp:TemplateField HeaderText="Cedula">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%#formateaRNC(Eval("Cedula"))%>'></asp:Label>
                            </ItemTemplate>
                            </asp:TemplateField>
                        <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" />
                        <asp:BoundField DataField="Cuota" HeaderText="Cuota" />
                        <asp:BoundField DataField="MontoSubsidio" HeaderText="Monto Subsidio" 
                            DataFormatString="{0:c}" />
                        <asp:TemplateField HeaderText="Periodo">
                            <ItemTemplate>
                                <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("Periodo")) %>'></asp:Label>
                            </ItemTemplate>
                            </asp:TemplateField>
                        <asp:BoundField DataField="Error" HeaderText="Error" />
                    </Columns>
                </asp:GridView>
                <br />
            </fieldset>
       
            <asp:Panel ID="pnlNavegacion1" runat="server" Height="50px">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="height: 24px">
                            <asp:LinkButton ID="btnLnkFirstPageE" runat="server" CommandName="First" 
                                CssClass="linkPaginacion" Text="&lt;&lt; Primera"></asp:LinkButton>
                            &nbsp;|
                            <asp:LinkButton ID="btnLnkPreviousPageE" runat="server" CommandName="Prev" 
                                CssClass="linkPaginacion" Text="&lt; Anterior"></asp:LinkButton>
                            &nbsp; Página [<asp:Label ID="lblCurrentPageE" runat="server"></asp:Label>
                            ] de
                            <asp:Label ID="lblTotalPagesE" runat="server"></asp:Label>
                            &nbsp;
                            <asp:LinkButton ID="btnLnkNextPageE" runat="server" CommandName="Next" 
                                CssClass="linkPaginacion" Text="Próxima &gt;"></asp:LinkButton>
                            &nbsp;|
                            <asp:LinkButton ID="btnLnkLastPageE" runat="server" CommandName="Last" 
                                CssClass="linkPaginacion" Text="Última &gt;&gt;"></asp:LinkButton>
                            &nbsp;
                            <asp:Label ID="lblPageSizeE" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="lblPageNumE" runat="server" Visible="False"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Total de Registros:
                            <asp:Label ID="lblTotalRegistrosE" runat="server" CssClass="error"></asp:Label>
                            &nbsp;<uc1:ucExportarExcel ID="ucExportarExcel3" runat="server" />
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        <br />
    <asp:Label ID="lblMensajeError" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
    </asp:Panel>
   </ContentTemplate>
   <Triggers>
        <asp:PostBackTrigger  ControlID="ucExportarExcel1"/>
        <asp:PostBackTrigger  ControlID="ucExportarExcel2"/>
        <asp:PostBackTrigger  ControlID="ucExportarExcel3"/>
   </Triggers>
  </asp:UpdatePanel>
</asp:Content>

