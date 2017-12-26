<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucEnfermedadComun.ascx.vb" Inherits="Controles_ucEnfermedadComun" %>
<%@ Register src="ucTelefono2.ascx" tagname="ucTelefono2" tagprefix="uc4" %>

<div ID="divDatosIniciales" runat="server"  visible="false">
        <table class="td-content" style="width: 550px; margin-left: 17px; ">
        <tr>
        <td colspan="2" width="100%">
            <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
            Datos Generales del Empleado(a)</span>
            <br />
        </td>
        </tr>
            <tr>
                <td width="20%">
                    <span style="margin-left: 5px">Dirección(*):</span>&nbsp;&nbsp;&nbsp;<br />
                </td>
                <td width="80%">
                    <asp:TextBox ID="txtTrabajadorDireccion" runat="server" 
                        Height="44px" TextMode="MultiLine" Width="260px" MaxLength="200" 
                        	style="border: 1px solid #B8D7FF; margin-left: 0px;"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
                        ControlToValidate="txtTrabajadorDireccion" Display="Dynamic" 
                        ValidationGroup="DatosIniciales">*</asp:RequiredFieldValidator>
                </td>
            </tr>
        <tr>
        <td width="20%">
            <span style="margin-left: 5px">Teléfono(*):</span>&nbsp;&nbsp;&nbsp;<br />
        </td>
        <td width="80%">
            <uc4:ucTelefono2 ID="txtTrabajadorTelefono" runat="server" />
        </td>
        </tr>
        <tr>
        <td width="20%">
            <span style="margin-left: 5px">Celular:</span>&nbsp;&nbsp;&nbsp;<br />
        </td>
        <td align="left" width="80%">
            <uc4:ucTelefono2 ID="txtTrabajadorCelular" runat="server" />
        </td>
        </tr>
        <tr>
        <td width="20%">
            <span style="margin-left: 5px">Correo Electrónico:</span>&nbsp;&nbsp;&nbsp;<br />
        </td>
        <td width="80%">
            <asp:TextBox ID="txtTrabajadorCorreo" runat="server" MaxLength="100" 
                Width="256px" ></asp:TextBox>
            &nbsp;<br />
            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                ControlToValidate="txtTrabajadorCorreo" ErrorMessage="Teléfono incorrecto" 
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Correo 
            electrónico incorrecto</asp:RegularExpressionValidator>
        </td>
        </tr>
        <tr>
        <td align="right" colspan="2" width="100%">
          <div id="divBotonesDatosIniciales" runat="server" >
            <asp:Button ID="btnRegistrarDatosIniciales" runat="server" Height="19px" 
                style="width: 90px;" Text="Registrar" ValidationGroup="DatosIniciales" />
              &nbsp;<br />
          
                <div ID="divSolicitudRegistrada" runat="server" style="text-align: right" visible="false">
                    <table style="width: 100%;">
                        <tr>
                            <td align="center">
                                <asp:Label ID="lblSolicitudRegistrada" Runat="server" cssclass="label-Blue" 
                        style="margin-left: 17px" Visible="False">Formulario generado exitosamente, ahora debe 
                                imprimirlo y entregarlo al trabajador(a) afectado por licencia médica para que 
                                su médico tratante lo complete. Una vez completado vuelva a esta pantalla para 
                                digitar los datos llenados por el médico. Para reimprimir el formulario puede 
                                entregarle el siguiente PIN al trabajador(a)</asp:Label>
                    <asp:Label ID="lblPin" runat="server" CssClass="label-Blue"></asp:Label>
                            </td>
                            <td valign="bottom">
                                <asp:Button ID="btnVerFormulario" runat="server"  
                        Text="Imprimir Formulario" ValidationGroup="DatosIniciales" 
                        Width="104px" />
                    <asp:Button ID="btnCompletar" runat="server" 
                        style="margin-left: 4px; width: 90px; height: 19px;" Text="Completar Datos" 
                        ValidationGroup="DatosIniciales" Visible="False" />
                            </td>
                        </tr>
                    </table>
                <br />
                </div>
                    
                    
                    
                    
              </div>
          </div> 