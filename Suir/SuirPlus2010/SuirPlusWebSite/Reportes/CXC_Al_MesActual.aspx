<%@ Page Title="Cuentas x Cobrar del Mes Actual" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CXC_Al_MesActual.aspx.vb" Inherits="Reportes_CXC_Al_MesActual" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Cuentas x Cobrar del Mes Actual"> 
        </asp:Label>
    </div>

    <div>
        <fieldset style="width: 380px; height: auto;">
            <table width="370px">
                <tr>
                    <td colspan="2" style="text-align: left"></td>
                </tr>

                <tr>
                    <td style="width: 100px"><asp:Label ID="lblProvincia" runat="server" CssClass="labelData" Text="Provincia:"> 
                    </asp:Label></td>
                    <td>
                        <asp:DropDownList ID="ddlProvincia" runat="server" CssClass="dropDowns">
                        </asp:DropDownList>
                    </td>
                </tr>
                 <tr>
                    <td style="width: 100px"><asp:Label ID="lblMonto" runat="server" CssClass="labelData" Text="Monto Desde:"> 
                    </asp:Label></td>
                    <td>
                        <asp:TextBox ID="txtMonto" Text="100000.00" runat="server" Width="128px"></asp:TextBox>
                    </td>
                </tr>

                <tr>
                    <td style="width: 100px"><asp:Label ID="lblPeriodosAtrazados" runat="server" CssClass="labelData" Text="Períodos atrazados:"> 
                    </asp:Label></td>
                    <td style="text-align: left">Desde: <asp:TextBox ID="txtDesde" Text="3" runat="server" Width="25px"></asp:TextBox>&nbsp;
                        Hasta:
                          <asp:TextBox ID="txtHasta" Text="5" runat="server" Width="25px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2" rowspan="1">
                        <br />
                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="Button" />
                        &nbsp;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="Button"
                            CausesValidation="False" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <br />
        <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
        <br />

        <asp:Panel ID="pnlCxCMesActual" runat="server" Visible="false">
            <rsweb:ReportViewer ID="ReportViewer1" runat="server" Font-Names="Verdana"
                Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="90" PageCountMode="Estimate">
                <LocalReport ReportPath="Reportes\CxC_Al_MesActual.rdlc"></LocalReport>
            </rsweb:ReportViewer>
        </asp:Panel>

    </div>

</asp:Content>

