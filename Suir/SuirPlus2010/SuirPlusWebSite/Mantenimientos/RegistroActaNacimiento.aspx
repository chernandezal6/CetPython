<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="RegistroActaNacimiento.aspx.vb" Inherits="RegistroActaNacimiento" title="Registro Ciudadano - TSS" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc1" %>
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
<div class="header" align="left">Registro Acta De Nacimiento<br />
<asp:UpdatePanel runat="server" ID="upPanel1">
<ContentTemplate>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="10pt" Visible="false"></asp:Label><br />
<asp:Panel ID="pnlGeneral" runat="server" Visible="true">
<table border="0" cellpadding="0" cellspacing="0" style="width: 600px">
    <tr>
      <td style="text-align: justify">
    <table border="0" cellpadding="0" cellspacing="0" style="width: 640px" class="td-content">
        <tr>
            <td align="right" height="22">
                Nombres:&nbsp;</td>
            <td height="22">
            
                &nbsp;<asp:TextBox ID="txtNombres" runat="server" Width="200px" 
                     TabIndex="1"></asp:TextBox><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNombres"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
            <td align="right" colspan="1" nowrap="nowrap" height="22">
                Primer Apellido:</td>
            <td colspan="1" nowrap="nowrap" height="22">
                &nbsp;<asp:TextBox ID="txtPrimerApellido" runat="server" Width="200px" 
                     TabIndex="2"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtPrimerApellido"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
        </tr>
        
        <tr>
            <td align="right" nowrap="noWrap" height="22">
                Segundo Apellido:&nbsp;</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtSegundoApellido" runat="server" Width="200px" 
                     TabIndex="3"></asp:TextBox></td>
            <td align="right" nowrap="nowrap" height="22">
                Fecha Nacimeinto:</td>
            <td height="22">
                &nbsp;<asp:TextBox ID="txtFechaNac" runat="server" Width="81px" 
                    TabIndex="4"></asp:TextBox>DD/MM/YYYY
                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtFechaNac"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator>
                <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" CultureName="es-DO"
                    Mask="99/99/9999" MaskType="Date" TargetControlID="txtFechaNac" UserDateFormat="DayMonthYear">
                </ajaxToolkit:MaskedEditExtender>
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
            </td>
            <td height="22">
            </td>
        </tr>
        <tr>
            <td align="right" height="22" nowrap="nowrap">
                Número Unico de Identidad</td>
            <td height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" ID="txtNoIdentidad" runat="server" 
                    Width="200px" TabIndex="6" MaxLength="11"></asp:TextBox></td>
            <td align="right" height="22" nowrap="nowrap" style="text-align: left">
                <asp:Button ID="btnValidar" runat="server" Text="Validar" 
                    CausesValidation="False" OnClick="btnValidar_Click" TabIndex="7" /></td>
            <td height="22">
            </td>
        </tr>
        <tr>
            <td colspan="4" nowrap="nowrap">
            <table runat="server" id="tblDatos" width="100%">
              <tr>
            <td align="right" height="22">
                <br />
                <br />
                Padre:</td>
            <td height="22" colspan="3">
                &nbsp;&nbsp;<uc1:UCCiudadano ID="UCCiudadanoPadre" runat="server" />
            </td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap" height="22">
                <br />
                <br />
                Madre:</td>
            <td height="22" colspan="3">
                &nbsp;&nbsp;<uc1:UCCiudadano ID="UCCiudadanoMadre" runat="server" />
            </td>
        </tr>
                <tr>
                    <td  colspan="4"  nowrap="nowrap">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td colspan="4" height="22" nowrap="nowrap">
                        <span class="subHeader">Datos Acta de Nacimiento:</span></td>
                </tr>
                <tr>
                    <td colspan="4" height="22">
        <table border="0" cellpadding="0" cellspacing="0" style="width: 640px" class="td-content">
            <tr>
                <td align="right" style="width: 93px">
                </td>
            </tr>
        
        <tr>
            <td align="right" style="width: 93px;" height="22">
                Municipio:</td>
            <td colspan="9" height="22">
                &nbsp;<asp:DropDownList ID="ddlMunicipio" runat="server" CssClass="dropDowns" 
                    AutoPostBack="True" OnSelectedIndexChanged="ddlMunicipio_SelectedIndexChanged" 
                    TabIndex="8">
                </asp:DropDownList></td>
        </tr>
        <tr>
            <td align="right" style="width: 93px" height="22">
                Oficialía:</td>
            <td align="left" height="22">
                &nbsp;<asp:DropDownList ID="ddlOficilia" runat="server" CssClass="dropDowns" 
                    TabIndex="9">
                    <asp:ListItem>&lt;--Seleccione--&gt;</asp:ListItem>
                </asp:DropDownList></td>
            <td align="left" height="22">
                Libro:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox MaxLength="10" ID="txtLibro" 
                    runat="server" Width="80px" TabIndex="10"></asp:TextBox><asp:RequiredFieldValidator
                    ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtLibro" Display="Dynamic"
                    ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
            <td align="left" height="22">
                Año:</td>
            <td align="left" height="22">
                <asp:TextBox onKeyPress="checkNum()" MaxLength="4" ID="txtAnoActa" 
                    runat="server" Width="50px" TabIndex="11"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="txtAnoActa"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
            <td align="left" height="22">
                Folio:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="10" ID="txtfolio" 
                    runat="server" Width="80px" TabIndex="12"></asp:TextBox><asp:RequiredFieldValidator
                    ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtfolio" Display="Dynamic"
                    ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
            <td align="left" height="22">
                Nro.:</td>
            <td align="left" height="22">
                &nbsp;<asp:TextBox onKeyPress="checkNum()" MaxLength="10" ID="txtNroActa" 
                    runat="server" Width="80px" TabIndex="13"></asp:TextBox><asp:RequiredFieldValidator
                    ID="RequiredFieldValidator7" runat="server" ControlToValidate="txtNroActa" Display="Dynamic"
                    ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
        </tr>
            <tr>
                <td align="right" style="width: 93px">
                </td>
            </tr>
    </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" >
                       <span class="subHeader"> &nbsp;</span></td>
                </tr>
                <tr>
                    <td colspan="4" height="22">
        <table border="0" cellpadding="0" cellspacing="0" width="100%">
            <tr>
                <td align="left" class="subHeader"> Anexar Imagen Acta:<br />
                </td>
            </tr>
            <tr>
                <td align="left" style="width: 88px">
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                    &nbsp; &nbsp; &nbsp;<asp:FileUpload ID="upLImagenCiudadano" runat="server" 
                        Width="296px" TabIndex="14" /></td>
            </tr>
        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" height="22" style="text-align: right">
                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" TabIndex="15" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" /></td>
                </tr>
            
            </table>
            </td>
        </tr>
          </td>
        
       
       
          
        </table>
          <br />        
    <table border="0" cellpadding="0" cellspacing="0" style="width: 651px" class="td-content">

         <tr>
            <td>
                <asp:UpdatePanel ID="upnlNSSDuplicado" runat="server" UpdateMode="Conditional" Visible ="false" >
                    <ContentTemplate>
                        <fieldset id="fsNSSDuplicado" runat="server" style="height: auto">
                            <legend>Info NSS Duplicado</legend>
                            <table id="tblNSSDuplicados" runat="server">
                                <tr>
                                    <td align="right">NSS Duplicados: </td>
                                    <td nowrap="nowrap">
                                        <asp:DropDownList ID="ddlNSSDuplicados" runat="server" AutoPostBack="True" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        &nbsp;
                                        <%--<asp:LinkButton ID="lbHistóricoARS" runat="server">Ver Histórico</asp:LinkButton>
                                        <asp:LinkButton ID="lbVerActa" runat="server" Visible="false"> | Ver Acta</asp:LinkButton>--%>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td align="right">Nombres: </td>
                                    <td>
                                        <asp:Label ID="lblNombresNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Primer Apellido: </td>
                                    <td>
                                        <asp:Label ID="lblPrimerApellidoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Segundo Apellido </td>
                                    <td>
                                        <asp:Label ID="lblSegundoApellidoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Sexo: </td>
                                    <td>
                                        <asp:Label ID="lblSexoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Fecha Nacimeinto: </td>
                                    <td>
                                        <asp:Label ID="lblFechaNacNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Padre: </td>
                                    <td>
                                        <asp:Label ID="lblPadreNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Madre: </td>
                                    <td>
                                        <asp:Label ID="lblMadreNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Nacionalidad: </td>
                                    <td>
                                        <asp:Label ID="lblNacionalidadNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Provincia:</td>
                                    <td>
                                        <asp:Label ID="lblProvinciaNSS" runat="server" CssClass="labelData"></asp:Label>
                                        <asp:Label ID="lblProvinciaNSSDes" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Municipio: </td>
                                    <td>
                                        <asp:Label ID="lblMunicipioNSS" runat="server" CssClass="labelData"></asp:Label>
                                        <asp:Label ID="lblMunicipioNSSDes" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td align="center" width="60px">Oficialia</td>
                                    <td align="center" width="60px">Libro</td>
                                    <td align="center" width="60px">Folio</td>
                                    <td align="center" width="60px">Acta</td>
                                    <td align="center" width="60px">Año</td>
                                </tr>
                                <tr>
                                    <td align="center">
                                        <asp:Label ID="lblOficialiaNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="lblLibroNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="lblFolioNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="lblNroActaNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                    <td align="center">
                                        <asp:Label ID="lblAnoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
    <%--<div align="center" style="text-align: right">
        <br />
        <br />
        &nbsp;
    </div>--%>

    </td>
   </tr>
 </table>
</asp:Panel>
    <br />

    <div align="justify">
         <asp:Button ID="btnVolver" runat="server" Text="Volver" Visible="False" />
    </div>
</ContentTemplate>
<Triggers>
<asp:PostBackTrigger ControlID="btnAceptar" />
</Triggers>
    </asp:UpdatePanel>
</div>

</asp:Content>

