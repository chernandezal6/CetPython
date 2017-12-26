<%@ Page Title="Cuentas x Cobrar Auditoría" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CxC_Auditoria.aspx.vb" Inherits="Reportes_CxC_Auditoria" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="divTitulo" class="header">
        <asp:Label ID="lblTitulo" runat="server" Text="Cuentas x Cobrar Auditoría"> 
        </asp:Label>
    </div>
    <br />
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
    <br />
    <asp:Panel ID="pnlCxCAuditoria" runat="server" Visible="false">
        <rsweb:ReportViewer ID="rvCxCAuditoria" runat="server" Font-Names="Verdana"
            Font-Size="8pt" Height="600px" Width="100%" ZoomPercent="90">
            <LocalReport ReportPath="Reportes\CxC_Auditoria.rdlc"></LocalReport>
        </rsweb:ReportViewer>
    </asp:Panel>
    <br />

</asp:Content>

