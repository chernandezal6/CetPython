<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CtaBancariaNueva.aspx.vb" Inherits="Empleador_CtaBancariaNueva" title="Nueva Cuenta Bancaria" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc1" %>

<%@ Register src="../Controles/ucCuentaBancaria.ascx" tagname="ucCuentaBancaria" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script type="text/javascript" language="javascript">
    
   function checkItNoPaste(evt)
   {
       evt = (evt) ? evt : window.event;
       input= evt.target || evt.srcElement;
       input.setAttribute('maxLength', input.value.length + 1); 
   }
   
</script>
    <div class="header">
        <br />
        Registro Cuenta Receptora de Reembolsos de Subsidio<br />     
        <br />
        <asp:Label ID="lblCuentaNovededad" runat="server" CssClass="label-Blue" 
            Text="Antes de agregar esta novedad, la empresa debe tener una cuenta bancaria activa en el sistema." 
            Visible="False"></asp:Label>
        <br />
        <br />
        
      </div>
         <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
         <div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
               <uc2:ucCuentaBancaria ID="ucCuentaBancaria1" runat="server" />
                 <br />
                 <br />
            </ContentTemplate>
        </asp:UpdatePanel>
        <br />
        <br />
        </div>
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />
<br />

<br />
<br />

                                
    </asp:Content>

