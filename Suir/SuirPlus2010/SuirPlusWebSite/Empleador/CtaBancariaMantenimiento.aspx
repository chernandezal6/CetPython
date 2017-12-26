<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CtaBancariaMantenimiento.aspx.vb" Inherits="Empleador_CtaBancariaMantenimiento" title="Cambiar Cuentas Bancarias" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc1" %>

<%@ Register src="../Controles/ucCuentaBancaria.ascx" tagname="ucCuentaBancaria" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    
<script type="text/javascript" language="javascript">
 
   $(function () {

       $('#ctl00_MainContent_ucCuentaBancaria1_txtNumeroCuenta2').live("cut copy paste", function (e) {
           e.preventDefault();
       });
   });
   
</script>
    
    <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" 
                                 runat="server" />
    <div class="header">
        Registro Cuenta Receptora de Reembolsos de Subsidio<br />
        <br />
   </div>
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
<ContentTemplate>
   <table>
      <tr>
        <td>
            <div ID="divCuentaBancariaActual" runat="server" 
                         style="FLOAT: left; WIDTH: 446px; MARGIN-RIGHT: 10px" 
                visible="true">
                      <br />
                    
                          <br />
                             <table cellpadding="0" cellspacing="0" class="td-content">
                                 <tr>
                                     <td style="width: 137px">
                                         <br />
                                         Banco Múltiple</td>
                                     <td style="width: 250px">
                                         <br />
                                         <asp:Label ID="lblIdEntidadRecaudadora" runat="server" CssClass="labelData"></asp:Label>
                                     </td>
                                 </tr>
                                 <tr>
                                     <td style="width: 137px">
                                         Titular de Cuenta</td>
                                     <td style="margin-left: 40px; width: 250px;">
                                         <asp:Label ID="lblRNCoCedulaDuenoCuenta" runat="server" 
                                             CssClass="labelData"></asp:Label>
                                     </td>
                                 </tr>
                                 <tr>
                                     <td style="width: 137px">
                                         Nro de Cuenta</td>
                                     <td style="width: 250px">
                                         <asp:Label ID="lblNroCuenta" runat="server" CssClass="labelData"></asp:Label>
                                     </td>
                                 </tr>
                                 <tr>
                                     <td style="width: 137px">
                                         Tipo de Cuenta</td>
                                     <td style="width: 250px">
                                         <asp:Label ID="lblTipoCuenta" runat="server" CssClass="labelData"></asp:Label>
                                     </td>
                                 </tr>
                                 <tr>
                                     <td style="width: 137px">
                                         &nbsp;</td>
                                     <td style="width: 250px">
                                         &nbsp;</td>
                                 </tr>
                             </table>
                            
                             <br />
                         <br />
                         <asp:Button id="btnCambiarCuenta" runat="server" Text="Cambiar Cuenta" 
                          CausesValidation="False" Width="92px"></asp:Button>
                        &nbsp;<br />
                    </div>
                  </td>
                 </tr>
              <tr>
                <td>
                <br />
                    
                    <div ID="divCambiarCuenta" runat="server" visible="false">
                        <uc2:ucCuentaBancaria ID="ucCuentaBancaria1" runat="server" />
                        <br />
                    </div>
                <br />
                <br />
                  </td>
                 </tr>
              <tr>
                <td>
                         <div ID="divHistoricoCuentas" runat="server" 
                             style="FLOAT: left; WIDTH: 687px; MARGIN-RIGHT: 10px" visible="False">
                             <fieldset>
                                 <legend >Histórico de Cuentas</legend>
                                 <br />
                                 <asp:GridView ID="gvHistoricoCuentas" runat="server" 
                                     EnableViewState="False" Width="660px" AutoGenerateColumns="False">
                                     <Columns>
                                         <asp:BoundField DataField="ult_fecha_act" HeaderText="Fecha Actualización" />
                                         <asp:BoundField DataField="cuenta_banco" HeaderText="Cuenta Bancaria" />
                                         <asp:BoundField DataField="tipo_cuenta" HeaderText="Tipo de Cuenta" />
                                         <asp:BoundField DataField="entidadrecaudadora" HeaderText="Banco Múltiple" />
                                     </Columns>
                                 </asp:GridView>
                                 <br />
                             </fieldset>
                             <br />
                             <br />
                         </div>
                  </td>
                 </tr>
                </table>
        </ContentTemplate>
</asp:UpdatePanel>
</asp:Content>

