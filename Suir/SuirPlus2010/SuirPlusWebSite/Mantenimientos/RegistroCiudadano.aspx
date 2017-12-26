<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="RegistroCiudadano.aspx.vb" Inherits="Mantenimientos_RegistroCiudadano" title="Registro Ciudadano - TSS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	
	<script language="javascript" type="text/javascript">
	function checkNum()
	    {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
         }
         
     </script>
<div class="header" align="left">Registro Ciudadano<br />
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="10pt" Text="lblMsg" Visible="False"></asp:Label><br />
<asp:Panel ID="pnlGeneral" runat="server" Visible="true">
<table border="0" cellpadding="0" cellspacing="0" style="width: 600px">
    <tr>
      <td style="text-align: justify">
    <table border="0" cellpadding="0" cellspacing="0" style="width: 640px" class="td-content">
        <tr>
            <td align="right" height="22">
                Nro. Cédula:
            </td>
            <td height="22">
            
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="11" ID="txtcedula" runat="server" Width="91px" ></asp:TextBox>&nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtcedula"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
            <td align="right" colspan="1" nowrap="nowrap" height="22">
                Nombres:</td>
            <td colspan="1" nowrap="nowrap" height="22">
                &nbsp;<asp:TextBox ID="txtNombres" runat="server" Width="200px"></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNombres"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
        </tr>
        
        <tr>
            <td align="right" nowrap="noWrap" height="22">
                Primer Apellido:
            </td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtPrimerApellido" runat="server" Width="200px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtPrimerApellido"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
            <td align="right" nowrap="nowrap" height="22">
                Segundo Apellido:</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtSegundoApellido" runat="server" Width="200px"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right" height="22">
                Estado Civil:
            </td>
            <td height="22">
                &nbsp;<asp:DropDownList ID="ddlEstadoCivil" runat="server" CssClass="dropDowns">
                    <asp:ListItem Selected="True" Value="-1">&lt;--Seleccione--&gt;</asp:ListItem>
                    <asp:ListItem Value="S">Soltero(a)</asp:ListItem>
                    <asp:ListItem Value="C">Casado(a)</asp:ListItem>
                    <asp:ListItem Value="D">Divorciado(a)</asp:ListItem>
                </asp:DropDownList>
                <asp:Label ID="lblEstadoCivil" runat="server" CssClass="error" Font-Bold="False"
                    Font-Size="7pt" Text="Requerido" Visible="False"></asp:Label></td>
            <td align="right" height="22">
                Fecha Nacimeinto:</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtFechaNac" runat="server" Width="81px"></asp:TextBox>
                DD/MM/YYYY
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtFechaNac"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" CultureName="es-DO"
                    Mask="99/99/9999" MaskType="Date" TargetControlID="txtFechaNac" UserDateFormat="DayMonthYear">
                </ajaxToolkit:MaskedEditExtender>
            </td>
        </tr>
        <tr>
            <td align="right" height="22" nowrap="nowrap">
                &nbsp;Sexo:</td>
            <td height="22">
                &nbsp;<asp:DropDownList ID="ddlSexo" runat="server" CssClass="dropDowns">
                    <asp:ListItem Selected="True" Value="-1">&lt;--Seleccione--&gt;</asp:ListItem>
                    <asp:ListItem Value="M">Masculino</asp:ListItem>
                    <asp:ListItem Value="F">Femenino</asp:ListItem>
                </asp:DropDownList>
                <asp:Label ID="lblSexo" runat="server" CssClass="error" Font-Bold="False" Font-Size="7pt"
                    Text="Requerido" Visible="False"></asp:Label></td>
            <td align="right" height="22">
                Provincia:</td>
            <td height="22">
                &nbsp;<asp:DropDownList ID="ddlProvincia" runat="server" CssClass="dropDowns">
                </asp:DropDownList>&nbsp;</td>
        </tr>
        <tr>
            <td align="right" nowrap="noWrap" height="22">
                Tipo Sangre:</td>
            <td height="22">
                &nbsp;<asp:DropDownList ID="ddlTipoSangre" runat="server" CssClass="dropDowns">
                </asp:DropDownList></td>
            <td align="right" height="22">
                Nacionalidad:</td>
            <td height="22">
                &nbsp;<asp:DropDownList ID="ddlNacionalidad" runat="server" CssClass="dropDowns">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlNacionalidad"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right" height="22">
                Padre:</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtPadre" runat="server" Width="200px"></asp:TextBox></td>
            <td align="right" height="22">
                Nro. Cédula Ant.:</td>
            <td height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="11" ID="txtCedulaAnt" runat="server"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap" height="22">
                Madre:</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtMadre" runat="server" Width="200px"></asp:TextBox></td>
            <td align="right" height="22">
                </td>
            <td height="22">
                &nbsp;</td>
        </tr>
        </table>
          <br />
        <div class="subHeader" align="left">Datos Acta de Nacimiento:</div><br />
        <table border="0" cellpadding="0" cellspacing="0" style="width: 640px" class="td-content">
            <tr>
                <td align="right" style="width: 93px">
                </td>
            </tr>
        
        <tr>
            <td align="right" style="width: 93px;" height="22">
                Municipio:</td>
            <td colspan="9" height="22">
                &nbsp;<asp:DropDownList ID="ddlMunicipio" runat="server" CssClass="dropDowns">
                </asp:DropDownList></td>
        </tr>
        <tr>
            <td align="right" style="width: 93px" height="22">
                Oficialía:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="10" ID="txtOficialia" runat="server" Width="80px"></asp:TextBox></td>
            <td align="left" height="22">
                Libro:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="10" ID="txtLibro" runat="server" Width="80px"></asp:TextBox></td>
            <td align="left" height="22">
                Folio:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="10" ID="txtfolio" runat="server" Width="80px"></asp:TextBox></td>
            <td align="left" height="22">
                Nro.:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="10" ID="txtNroActa" runat="server" Width="80px"></asp:TextBox></td>
            <td align="left" height="22">
                Año:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="4" ID="txtAnoActa" runat="server" Width="50px"></asp:TextBox></td>
        </tr>
            <tr>
                <td align="right" style="width: 93px">
                </td>
            </tr>
    </table>
    <div align="center" style="text-align: right">
        <br />
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td align="left" class="subHeader"> Anexar Imagen Acta:<br />
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 88px">
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp; &nbsp;<asp:FileUpload ID="upLImagenCiudadano" runat="server" Width="296px" /></td>
            </tr>
        </table>
        <br />
                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
    </div>
    </td>
   </tr>
 </table>
</asp:Panel>
    <br />

    <div align="justify">
         <asp:Button ID="btnVolver" runat="server" Text="Volver" Visible="False" />
    </div>
</div>

</asp:Content>

