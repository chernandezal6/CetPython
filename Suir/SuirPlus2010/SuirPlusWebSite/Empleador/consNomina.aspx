<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consNomina.aspx.vb" Inherits="Empleador_consNomina" title="Consulta de Nóminas" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc5" %>
<%@ Register Src="../Controles/UCDependientesAdicionales.ascx" TagName="UCDependientesAdicionales" TagPrefix="uc4" %>
<%@ Register Src="../Controles/UCTrabajadoresCedCancelada.ascx" TagName="UCTrabajadoresCedCancelada" TagPrefix="uc3" %>
<%@ Register Src="../Controles/UCNominas.ascx" TagName="UCNominas" TagPrefix="uc2" %>
<%@ Register Src="../Controles/UCSubEncabezadoEmp.ascx" TagName="UCSubEncabezadoEmp" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
 <uc5:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <uc2:UCNominas ID="ctrlNomina" runat="server" visible="true" />
    <uc3:UCTrabajadoresCedCancelada ID="ctrlTrabajadoresCedCancelada" runat="server" visible="true" />
    <uc4:UCDependientesAdicionales ID="ctrlDependientesAdicionales" runat="server" visible="true" />
</asp:Content>