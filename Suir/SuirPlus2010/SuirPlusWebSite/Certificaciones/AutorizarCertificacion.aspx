<%@ Page Title="Verificar Certificación" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="AutorizarCertificacion.aspx.vb" Inherits="Certificaciones_AutorizarCertificacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header" align="left">Detalle de la Certificación #<asp:Label 
        ID="lblIdCertificacion" runat="server" CssClass="header"
        Font-Bold="True" Font-Size="11pt"></asp:Label><br />
</div>
<table id="Table4" style="width: 550px">
	<tr>
	   <td>
     <div align="center">
        <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Font-Size="11pt"
        Visible="False"></asp:Label><br />
         &nbsp;</div> 
         
            
    <fieldset  style="width: 500px"> <legend>Información General</legend> 
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

</TABLE>

    </asp:panel>
    </fieldset>
    <table id="Table1" width="500px">
		<tr>
			<td style="width: 528px">
                <br />
                <br /><div align="right">
                <asp:LinkButton ID="lnkVerDocRequeridos" runat="server" CausesValidation="False">Ver Documentos Requeridos</asp:LinkButton>
                    &nbsp;
                    <asp:Label ID="Label1" runat="server" Font-Bold="False" Font-Size="Larger" Text="|"
                    Width="2px"></asp:Label>&nbsp;
                <asp:LinkButton ID="lnkVerCertificacion" runat="server" CausesValidation="False">Ver Certificación</asp:LinkButton>
                </div>	
                <br />
                <asp:Label ID="lblTituloComent" runat="server" CssClass="subHeader">Comentario</asp:Label>&nbsp;
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="txtComentario" ErrorMessage="El comentario es requerido."></asp:RequiredFieldValidator>
                <br />
                <asp:TextBox ID="txtComentario" runat="server" Height="72px" TextMode="MultiLine"
                    Width="98%"></asp:TextBox><br />
                </td>
		</tr>
	</table>	

    <table id="Table2" width="500px">
		<tr>
			<td align="right" style="width: 497px">	
	       
	    <asp:Button ID="btnAutorizar" runat="server" Text="Verificado" 
                    CausesValidation="False" />
        <asp:Button ID="btnRechazar" runat="server" Text="Rechazar" />
        <asp:Button ID="btnRegresar" runat="server" Text="Regresar" 
                    CausesValidation="False" />
         </td>
		</tr>
	</table>
	
	
        </td>
	  </tr>
	</table>
    
</asp:Content>

