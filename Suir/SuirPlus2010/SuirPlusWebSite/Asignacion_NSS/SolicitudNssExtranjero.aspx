<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SolicitudNssExtranjero.aspx.vb" Inherits="Asignacion_NSS_SolicitudNssExtranjero" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server" >     

    <div class="bigtitle">
        <span class="header">Solicitud de asignación NSS para extranjeros</span>
    </div>  
    <br />  
   <asp:Label ID="lblmensaje" runat="server" CssClass="label-Blue" Font-Size="10pt"></asp:Label>
    <asp:Label ID="lblerror" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
     <script type="text/javascript">
        $(function () {
            var curr_year = new Date().getFullYear();
            $(".Calendario").datepicker({
                dateFormat: 'dd/mm/yy',
                changeMonth: true,
                changeYear: true,
                yearRange: '1900:' + curr_year,
                numberOfMonths: 1
            });
        });
    </script>   
    <script type = "text/javascript">
    function DisableButton() {
    document.getElementById("<%=btnProcesar.ClientID %>").disabled = true;
    }
    window.onbeforeunload = DisableButton;
    </script>

    <table border="0"  cellpadding="1" style="width:700px" class="td-content">
        <tr><td></td></tr>
        <tr>
                <td align="right">&nbsp;Tipo Documento:</td>
                <td style="width: 319px"><asp:DropDownList ID="ddlTipo" runat="server" CssClass="dropDowns" AutoPostBack="true" TabIndex="1"></asp:DropDownList>
                    
                </td>
                <td align="right" nowrap="nowrap">&nbsp;Número de Documento:</td>                
            <td>
                <asp:TextBox ID="txtNoDocumento" runat="server" MaxLength="25" style="width: 150px" TabIndex="2" Visible="false"></asp:TextBox>
                <asp:TextBox ID="txtNroDocSinMask" runat="server" MaxLength="25" style="width: 150px" TabIndex="2" Visible="false"></asp:TextBox>
                <asp:Button ID="btnValidar" runat="server" Text="Validar" Visible="true"></asp:Button>
                <ajaxToolkit:MaskedEditExtender 
                    ID="maskNroDocumento" 
                    Runat="Server"                                             
                    TargetControlID="txtNoDocumento"                                                   
                    MessageValidatorTip="True"                                
                    OnInvalidCssClass="MaskedEditError"
                    ErrorTooltipEnabled="True"
                    ClearMaskOnLostFocus="True"
                    MaskType="None"
                    Mask="None"                                
                    />
            </td>           
               
            </tr>
        <tr id="trNombreExt" runat="server" visible="false">
            <td></td>
            <td></td>
            <td colspan="3" align="center">
                <asp:Label ID="lblNombreExt" runat="server"  CssClass="LabelDataGris" ></asp:Label>                            
                <br />
                <br />
            </td>
        </tr>
        <tr>
            <td align="right" height="22">Nombres:&nbsp;</td>
            <td height="22" style="width: 319px">
                <asp:TextBox ID="txtNombres" runat="server" Width="200px"
                    TabIndex="3" MaxLength="50"></asp:TextBox><br />
                </td>&nbsp;
            <td align="right"  nowrap="nowrap" >Primer Apellido:</td>
            <td nowrap="nowrap">
                <asp:TextBox ID="txtPrimerApellido" runat="server" Width="207px"
                    TabIndex="4" MaxLength="40"></asp:TextBox>&nbsp;
                </td>
        </tr>
        <tr>
            <td align="right" nowrap="noWrap" height="22">Segundo Apellido:&nbsp;</td>
            <td height="22" style="width: 319px">
                <asp:TextBox ID="txtSegundoApellido" runat="server" Width="200px"
                    TabIndex="5" MaxLength="40"></asp:TextBox>
            </td>
            <td align="right" height="22" nowrap="nowrap">Sexo:&nbsp;</td>
            <td height="22">&nbsp;<asp:DropDownList ID="DdlSexo" runat="server" CssClass="dropDowns"
                TabIndex="6">               
                <asp:ListItem>M</asp:ListItem>
                <asp:ListItem>F</asp:ListItem>
                 </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td align="right" nowrap="nowrap" height="22">Fecha Nacimiento:</td>
            <td height="22" style="width: 319px">
                <asp:TextBox ID="txtFechaNac" runat="server" Width="81px"
                    TabIndex="7" CssClass="Calendario"></asp:TextBox>&nbsp;DD/MM/YYYY
                <%--<asp:RegularExpressionValidator runat="server" ControlToValidate="txtFechaNac" CssClass="Calendario"
                    ErrorMessage="Formato Invalido." />--%>
                <%--<cc1:MaskedEditExtender 
                    ID="MaskedFechaNacimiento"
                    runat="server"
                    TargetControlID="txtFechaNac"
                    Mask="99/99/9999"
                     UserDateFormat="DayMonthYear"                   
                    MaskType="DateTime"
                    MessageValidatorTip="true">
                </cc1:MaskedEditExtender>--%>
            </td>
             <td align="right" nowrap="nowrap">Nacionalidad:</td>
             <td><asp:DropDownList ID="ddlNacionalidad" runat="server" CssClass="dropDowns" Width="235px"
                TabIndex="8">
            </asp:DropDownList>
             </td>
           
        </tr>
        <tr><td></td></tr>
        <tr>
            <td align="left" class="subHeader" nowrap="nowrap" enabled="True">Anexar Imagen:
            </td>

            <td colspan="3" align="left" style="width: 103px">
                <asp:FileUpload ID="upLImagenSolicitud" runat="server" 
                    Width="296px" TabIndex="14"/>                
                <br />
                </td>
        </tr>
        <tr><td></td></tr>
        <tr>
            <td colspan="4"><br />                
                <asp:Button ID="btnProcesar" runat="server" Text="Procesar" Font-Size="Small"></asp:Button>
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" Font-Size="Small"></asp:Button>                
            </td>            
        </tr>
        <tr><td></td></tr>  

    </table> 
    <table>
         <tr>
            <td colspan="4" valign="top">
                <fieldset id="fsTSS" runat="server" visible="false"
                    style="height: auto; width: 450px">
                    <legend>Datos del Ciudadano</legend>
                    <asp:Panel ID="pnlInfoTSS" runat="server" Visible="false">
                        <table width="445">
                            <tr>
                                <td align="left" nowrap="nowrap" style="width: 30%">NSS:
                                </td>
                                <td>
                                    <asp:Label ID="lblNss" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap">Numero de Expediente:
                                </td>
                                <td>
                                    <asp:Label ID="lblNroExpediente" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap">Numero Identificador:
                                </td>
                                <td>
                                    <asp:Label ID="lblNroDocumento" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap">Tipo de Documento:
                                </td>
                                <td>
                                    <asp:Label ID="lblTipoDocumento" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap">Nombres:
                                </td>
                                <td>
                                    <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap">Primer Apellido:
                                </td>
                                <td>
                                    <asp:Label ID="lblPrimerApellido" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap">Segundo Apellido
                                </td>
                                <td colspan="2">
                                    <asp:Label ID="lblSegundoApellido" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap" style="height: 18px">Fecha Nacimiento:</td>
                                <td align="left" colspan="2" style="height: 18px">
                                    <asp:Label ID="lblFechaNacimiento" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="left" nowrap="nowrap">Sexo:
                                </td>
                                <td colspan="2" align="left">
                                    <asp:Label ID="lblSexo" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Nacionalidad:
                                </td>
                                <td>
                                    <asp:Label ID="lblNacionalidad" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>

                        </table>
                    </asp:Panel>

                    <div id="divmsgTSS" align="center" runat="server" visible="true" style="height: auto">
                        <br />
                        <asp:Label ID="lblciu" runat="server" Visible="false" CssClass="label-Blue" Font-Size="10pt"></asp:Label>
                        <br />                        
                    </div>
                    <br />
                    <div id="divGenerarCert" style="text-align:center" runat="server" visible="false">
                       <asp:Button id="btnCertificacion" runat="server" Text="Generar Certificación" CommandName="Crear" CommandArgument='<%# Eval("Solicitud") & "," & Eval("Nss")%>'/>
                    </div>
                    <div id="divVerCert" style="text-align:center" runat="server" visible="false">
                       <label id="lblcer" runat="server" class="label-Blue">Ver Certificación</label><asp:ImageButton ID="ibImagenCert" runat="server"  ImageUrl="~/images/pdf.png" CommandName="VerSol" CommandArgument='<%# Eval("Solicitud")%>' />
                    </div>

                </fieldset>
            </td>

        </tr>
    </table>
      
</asp:Content>