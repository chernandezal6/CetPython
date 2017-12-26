<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="RegistroMenorExtranjero.aspx.vb" Inherits="Mantenimientos_RegistroMenorExtranjero" title="Menores Extrangeros" %>

<%@ Register src="../Controles/UCCiudadano.ascx" tagname="ucciudadano" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="header" align="left">
	
	<script language="javascript" type="text/javascript">

     </script>
<div class="header" align="left">Registro Menores Extranjeros<br />
    <br />
<asp:UpdatePanel runat="server" ID="upPanel2">
<ContentTemplate>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
    <asp:Label ID="lblMsg1" runat="server" CssClass="label-Blue" Font-Size="10pt" 
        Visible="False" style="font-weight: 700">Ciudadano creado exitosamente!</asp:Label>
    <br />
<asp:Panel ID="pnlGeneral0" runat="server" Visible="true">
<table border="0" cellpadding="0" cellspacing="0" style="width: 600px">
    <tr>
      <td style="text-align: justify">
    <table border="0" cellpadding="0" cellspacing="0" style="width: 640px" class="td-content">
        <tr>
            <td align="right" height="22">
                Nombres:&nbsp;</td>
            <td height="22">
            
                &nbsp;<asp:TextBox ID="txtNombres" runat="server" Width="200px" TabIndex="1"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ControlToValidate="txtNombres"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                    ControlToValidate="txtNombres" Display="Dynamic" 
                    ErrorMessage="Formato incorrecto!" 
                    ValidationExpression="^[a-zA-Z'.\s]{1,40}$" EnableClientScript="False" 
                    Enabled="False"></asp:RegularExpressionValidator>
            </td>
            <td align="right" colspan="1" nowrap="nowrap" height="22">
                Primer Apellido:</td>
            <td colspan="1" nowrap="nowrap" height="22">
                &nbsp;<asp:TextBox ID="txtPrimerApellido" runat="server" Width="200px" 
                    TabIndex="2"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtPrimerApellido"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                    ControlToValidate="txtPrimerApellido" Display="Dynamic" 
                    ErrorMessage="Formato incorrecto!" 
                    ValidationExpression="^[a-zA-Z'.\s]{1,40}$" EnableClientScript="False" 
                    Enabled="False"></asp:RegularExpressionValidator>
            </td>
        </tr>
        
        <tr>
            <td align="right" nowrap="noWrap" height="22">
                Segundo Apellido:&nbsp;</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtSegundoApellido" runat="server" Width="200px" 
                    TabIndex="3"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                    ControlToValidate="txtSegundoApellido" Display="Dynamic" 
                    ErrorMessage="Formato incorrecto!" 
                    ValidationExpression="^[a-zA-Z'.\s]{1,40}$" EnableClientScript="False" 
                    Enabled="False"></asp:RegularExpressionValidator>
            </td>
            <td align="right" nowrap="nowrap" height="22">
                Fecha Nacimeinto:</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtFechaNac" runat="server" Width="81px" TabIndex="4"></asp:TextBox>
                DD/MM/YYYY
                <asp:RequiredFieldValidator ID="RequiredFieldValidator11" runat="server" ControlToValidate="txtFechaNac"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td align="right" height="22" nowrap="nowrap">
                Sexo:&nbsp;</td>
            <td height="22">
                &nbsp;<asp:DropDownList ID="ddlSexo" runat="server" CssClass="dropDowns" 
                    TabIndex="5">
                    <asp:ListItem>M</asp:ListItem>
                    <asp:ListItem>F</asp:ListItem>
                </asp:DropDownList></td>
            <td align="right" height="22" nowrap="nowrap">
                Nacionalidad:</td>
            <td height="22">
                <asp:DropDownList ID="ddlNacionalidad" runat="server" CssClass="dropDowns" 
                    TabIndex="6">
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td align="right" colspan="4" height="22" nowrap="nowrap">
                <table ID="tblExtranjerosNombreComun" runat="server" style="width: 100%" 
                    visible="False">
                    <tr>
                        <td align="left" height="0px">
                            <asp:Label ID="lblMsg0" runat="server" CssClass="error" Font-Size="10pt">Este 
                            nombre ya esta registrado.</asp:Label>
                            &nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnNo" runat="server" Text="Ok" Height="16px" 
                                CausesValidation="False" />
                        </td>
                    </tr>
                    <tr>
                        <td align="left">
                            <asp:GridView ID="gvMenoresExtranjeros" runat="server" 
                                AutoGenerateColumns="False">
                                <Columns>
                                    <asp:BoundField DataField="ID_NSS" HeaderText="NSS" />
                                    <asp:BoundField DataField="NOMBRES" HeaderText="Nombres" />
                                    <asp:BoundField DataField="Primer_Apellido" HeaderText="Primer Apellido" />
                                    <asp:BoundField DataField="Segundo_Apellido" HeaderText="Segundo Apellido" />
                                    <asp:BoundField DataField="Fecha_Nacimiento" DataFormatString="{0:d}" 
                                        HeaderText="Fecha Nacimiento" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="4" nowrap="nowrap">
            <table runat="server" id="tblDatos" width="100%">
        <tr>
            <td align="right" nowrap="nowrap" height="22">
                
                Titular:</td>
            <td >
                <uc1:UCCiudadano ID="UCCiudadanoMadre" runat="server" />
            </td>
        </tr>      
            </table>
            </td>
        </tr>
       
          
        </table>
          <br />
        <br />
    </td>
   </tr>
 </table>
 
                     <div>
                      <table border="0" cellpadding="0" cellspacing="0" style="width: 600px" >
                            <tr>
                                <td align="left" class="subHeader">
                                    Anexar Imagen Acta Nacimiento:<br />
                                </td>
                            </tr>
                            <tr>
                                <td align="left" style="width: 88px">
                                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<asp:FileUpload ID="upLImagenCiudadano" 
                                        runat="server" Width="296px" TabIndex="9" />
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" 
                                        ControlToValidate="upLImagenCiudadano" Display="Dynamic" 
                                        ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="text-align: right;">
                                    <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" TabIndex="10" />
                                    <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" 
                                        Text="Limpiar" />
                                </td>
                            </tr>
                        </table>
                    </div>
</asp:Panel>
    <br />

    <div align="justify">
    </div>
</ContentTemplate>
<Triggers>
<asp:PostBackTrigger ControlID="btnAceptar" />
</Triggers>
    </asp:UpdatePanel>
</div>

        <br />
    </div>
</asp:Content>

