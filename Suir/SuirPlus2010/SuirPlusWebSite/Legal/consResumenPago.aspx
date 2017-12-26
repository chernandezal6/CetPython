<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consResumenPago.aspx.vb" Inherits="Legal_consResumenPago" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
            <div class="header">Consulta Resumen de Pago</div>
            <br />
            <table class="td-content" style="width: 370px" cellpadding="1" cellspacing="0">
                <tr><td>&nbsp;</td></tr>               
                <tr><td></td></tr>               
                <tr>
                    <td>
                        Período Desde: <asp:dropdownlist cssclass="dropDowns" id="ddlPeriodoIni" runat="server" AutoPostBack="True">
                        </asp:dropdownlist></td>
                    <td>
                        Período Hasta: <asp:dropdownlist cssclass="dropDowns" id="ddlPeriodoFin" runat="server" AutoPostBack="True" Enabled="False">
                        </asp:dropdownlist></td>
                </tr>
                <tr>
                     <td colspan="2" style="text-align: center">
                         &nbsp;</td>
                </tr>
                <tr>
                     <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar"/>
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
                     </td>
                </tr>
                <tr><td>&nbsp;</td></tr> 
                <tr><td></td></tr> 
            </table>

            <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            <br />
            <asp:Panel ID="pnlResumenPago" runat="server" Visible="False">
                <table style="width: 550px">                               
                <tr>
                    <td>
                        <asp:GridView ID="gvResumenPago" runat="server" AutoGenerateColumns="False" CellPadding="2" CellSpacing="1" Width="500px">
                            <Columns>
                                <asp:boundfield headertext="Período" datafield="Periodo">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:boundfield>  
                                <asp:boundfield datafield="PAGO_DEL_MES_SIN_REC" dataformatstring="{0:c}" headertext="Sin Recargos" htmlencode="False">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:boundfield>
                                <asp:boundfield datafield="PAGO_DEL_MES_CON_REC" dataformatstring="{0:c}" headertext="Con Recargos" htmlencode="False">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:boundfield>
                                <asp:boundfield headertext="Meses Anteriores" datafield="PAGOS_MESES_ANTERIORES" dataformatstring="{0:c}" htmlencode="False">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:boundfield>   
                                <asp:boundfield headertext="Total" datafield="Total" dataformatstring="{0:c}" htmlencode="False">
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:boundfield>                                                                                                                                    

                            </Columns>
                        </asp:GridView>
                        <br />
                        <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                    </td>
                </tr>  
                </table>  
                </asp:Panel> 
</asp:Content>

