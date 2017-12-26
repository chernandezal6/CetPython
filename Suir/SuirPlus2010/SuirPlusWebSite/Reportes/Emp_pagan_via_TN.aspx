<%@ Page Title="Empleadores que Pagan Vía Tesorería Nacional" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Emp_pagan_via_TN.aspx.vb" Inherits="Reportes_Emp_pagan_via_TN" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Empleadores que Pagan Vía Tesorería Nacional"> 
        </asp:Label>
    </div>
    <br />
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
    <br />
    <asp:Panel ID="pnlEmp_pagan_via_TN" runat="server" Visible="false">
        <rsweb:ReportViewer ID="rvEmp_pagan_via_TN" runat="server" Font-Names="Verdana"
            Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="90" PageCountMode="Estimate">
            <LocalReport ReportPath="Reportes\Empleadores_Pagan_Via_TN.rdlc"></LocalReport>
        </rsweb:ReportViewer>
    </asp:Panel>
    <br />

</asp:Content>

