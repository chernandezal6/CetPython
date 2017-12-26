<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consNominaDetalle.aspx.vb" Inherits="Consultas_consNominaDetalle" title="Detalle Nómina" %>

<%@ Register Src="../Controles/ucNominaDetalle.ascx" TagName="ucNominaDetalle" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <uc1:ucNominaDetalle ID="UcDetalleNomina" runat="server" />



</asp:Content>

