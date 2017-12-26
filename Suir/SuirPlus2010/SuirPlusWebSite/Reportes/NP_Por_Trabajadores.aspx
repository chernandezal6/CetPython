<%@ Page Title="Notificaciones de Pago por Trabajadores" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="NP_Por_Trabajadores.aspx.vb" Inherits="Reportes_NP_por_trabajadores" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<%@ Register Src="../Controles/ucInfoEmpleado.ascx" TagName="ucInfoEmpleado" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Notificaciones de Pago por Trabajadores"> 
        </asp:Label>
    </div>
    <br />
    <table>
        <tr>
            <td>
                <fieldset style="width: 300px">
                    <table>
                        <tr>
                            <td class="labelData" colspan="4">
                                <asp:Label ID="lblEncabezadoParam" runat="server" Text="Digite Su Nro. de Documento..."></asp:Label>
                                <br />
                                <br />
                            </td>
                        </tr>
                        <tr>
                            <td valign="middle">Nro. Documento:</td>
                            <td valign="middle">
                                <asp:TextBox ID="txtDocumento" runat="server" MaxLength="25" Width="150px"></asp:TextBox>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td align="center" colspan="4" rowspan="1">
                                <br />
                                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" CssClass="Button" />
                                &nbsp;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="Button"
                                    CausesValidation="False" />
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </td>
            <td>
                <div id="divInfoTrabajador" runat="server" visible="false">
                    <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
                </div>
            </td>
        </tr>
    </table>

    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
    <br />
    <asp:Panel ID="pnlNP_Por_Trabajadores" runat="server" Visible="false">
        <rsweb:ReportViewer ID="rvNP_Por_Trabajadores" runat="server" Font-Names="Verdana"
            Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="90" PageCountMode="Estimate">
            <LocalReport ReportPath="Reportes\NP_Por_Trabajadores.rdlc">
            </LocalReport>
        </rsweb:ReportViewer>

    </asp:Panel>




</asp:Content>
