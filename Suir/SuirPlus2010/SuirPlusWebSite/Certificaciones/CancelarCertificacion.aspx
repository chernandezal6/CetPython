<%@ Page Title="Cancelar Certificación" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CancelarCertificacion.aspx.vb" Inherits="Certificaciones_CancelarCertificacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header" style="width:550px">Cancelar Certificación</div><br />

<div align="left"><asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
</div> 
<div id="divInfo" runat="server" visible="false">
<div style="width:350px">
<fieldset>
<legend>Consulta de Certificación</legend>
<table>
<tr>
<td>
Nro. Certificación
</td>
<td>
    <asp:TextBox ID="txtNroCertificacion" runat="server"
    MaxLength="9"></asp:textbox><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Solo Números" ControlToValidate="txtNroCertificacion"
ValidationExpression="\d*"></asp:regularexpressionvalidator>
</td>
</tr>

<tr>
<td align="center" colspan="2">
    <br />
    <asp:Button ID="btnConsultar" runat="server" Text="Consultar" />
    &nbsp;
    <asp:Button ID="bntLimpiar" runat="server" Text="limpiar" />
</td>
</tr>
</table>


</fieldset>
</div>

<div id="divInfoCertificacion" runat="server" style="width:550px" visible="false">
<fieldset>
<legend>Generales de la Certificación</legend>
<table>
<tr>
<td>

    <asp:panel ID="pnlInfoEmpresa" runat="server" Visible="true" Width="470px" >
    <table id="Table3" width="470px">
		
      <tr>
        <td style="width: 111px" align="right">
            Tipo Certificación:</td>
        <td>
            <asp:Label ID="lblTipoCert" runat="server" CssClass="labelData"></asp:Label></td>

    </tr>
        
        <TR>
			<TD style="width: 111px" align="right">
                Rnc/Cédula:</TD>
            <td>
                <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label></td>
		</TR>
    <tr>
        <td style="width: 111px" align="right">
            Razón Social:</td>
        <td>
            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    
  <tr>
        <td style="width: 111px" align="right">
            Fecha Registro:</td>
        <td>
            <asp:Label ID="lblFechaReg" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
</TABLE>

    </asp:panel>

    <asp:panel ID="pnlInfoCiudadano" runat="server" Visible="true" Width="470px" >
    <table id="Table5" style="width: 470px">


    <tr>
        <td style="width: 111px" align="right">
            Tipo Certificación:</td>
        <td>
            <asp:Label ID="lblTipoCertCiu" runat="server" CssClass="labelData"></asp:Label></td>

    </tr>
    <tr>
        <td style="width: 111px" align="right">
            Nombres:</td>
        <td>
            <asp:Label ID="lblNombreCiu" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
        
    <tr>
        <td style="width: 111px" align="right">
            Tipo Documento:</td>
        <td>
            <asp:Label ID="lblTipoDocCiu" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>  
    <tr>      
        <td style="width: 111px" align="right">
            Nro. Documento:</td>
        <td>
            <asp:Label ID="lblNroDocCiu" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td style="width: 111px" align="right">
            NSS:</td>
        <td>
            <asp:Label ID="lblNssCiu" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    
    <tr>
       <td style="width: 111px" align="right">
            Fecha Registro:</td>
        <td>
            <asp:Label ID="lblFechaRegCertCiu" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>

<tr>

<td colspan="2">
        &nbsp;</td>
</tr>

        <tr>
            <td colspan="2">
                <asp:Label ID="lblTituloComent" runat="server" CssClass="subHeader">Comentario</asp:Label>
                &nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="txtComentario" ErrorMessage="El comentario es requerido."></asp:RequiredFieldValidator>
                <br />
                <asp:TextBox ID="txtComentario" runat="server" Height="72px" 
                    TextMode="MultiLine" Width="90%"></asp:TextBox>
                <br />
            </td>
        </tr>

</TABLE>

    </asp:panel>
</td>
</tr>
<tr>
<td colspan="2" align="center">
    <br />
<asp:Button ID="btnCancelar" runat="server" Text="Cancelar Certificación" />
</td>
</tr>
</table>
</fieldset>

</div>
</div>

</asp:Content>

