<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ManejoSolicitudesDetalle.aspx.vb" Inherits="Solicitudes_ManejoSolicitudesDetalle" Title="Manejo de Solicitudes" %>

<%@ Register TagPrefix="uc1" TagName="ucSolicitud" Src="../Controles/ucSolicitud.ascx" %>
<%@ Register Src="../Controles/ucTelefono2.ascx" TagName="ucTelefono2" TagPrefix="uc2" %>
<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <table class="td-content" id="Table2" width="550" runat="server">
        <tr>
            <td>
                <uc1:ucSolicitud ID="ucSol" runat="server"></uc1:ucSolicitud>
                <table class="td-content" id="Table1" width="100%" runat="server">
                    <tr id="status1" runat="server">
                        <td align="right">Estatus:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlEst" runat="server" CssClass="dropDowns"></asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td align="left" valign="top">Comentario:</td>
                        <td>
                            <asp:TextBox ID="txtComentario" runat="server" Width="455px" Height="70px" TextMode="MultiLine"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2" width="100%"></td>
                    </tr>
                    <tr>
                        <td align="right" colspan="2">
                            <asp:Button ID="btAct" runat="server" Text="Actualizar"></asp:Button>&nbsp;<asp:Button ID="btnEditar" runat="server" Text="Editar" Visible="false"></asp:Button>&nbsp;<input onclick="javascript: history.back();" type="button" value="Cancelar" class="Button"></td>
                    </tr>
                </table>
                <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label></td>
        </tr>
    </table>  

    <asp:Panel ID="pnlFormulario" runat="server" Visible="false">
        <div class="header">
            Ediccion Informacion del Empleador
        </div>
        <div style="height: 5px;">&nbsp;

        </div>

        <table>
            <tr>
                <td style="width: 590px">
                    <div id="contenido">
                        <span class="error" id="lblMsgContenido"></span>
                        
                                <table id="InfoEmpleador" runat="server" border="0" cellpadding="0" cellspacing="0" width="850" class="td-note">
                                    <tr>
                                        <td class="listheadermultiline">Información General
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div style="height: 5px;">
                                                &nbsp;
                                            </div>
                                        </td>
                                    </tr>

                                    <%-- <tr>
                                        <td>RNC/Cédula<br />
                                            <asp:TextBox ID="txtRNCCedula" runat="server" MaxLength="11"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" Display="Dynamic"
                                                SetFocusOnError="True" CssClass="error" ControlToValidate="txtRNCCedula" ValidationGroup="RNC"
                                                ValidationExpression="^(\d{9}|\d{11})$">RNC/Cédula Inválida</asp:RegularExpressionValidator>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtRNCCedula"
                                                CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True"
                                                ValidationGroup="RNC">*</asp:RequiredFieldValidator>
                                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar Empleador" ValidationGroup="RNC" />&nbsp;<asp:Image
                                                ID="imgBusqueda" runat="server" Visible="False" />
                                        </td>
                                    </tr>--%>
                                    <tr>
                                        <td>RNC/Cédula<br />
                                            <asp:TextBox ID="txtRNCCedula" runat="server" MaxLength="11" ReadOnly="True"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Razón Social<br />
                                            <asp:TextBox ID="txtRazonSocial" runat="server" ReadOnly="True" Width="449px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Nombre Comercial<br />
                                            <asp:TextBox ID="txtNombreComercial" runat="server" Width="449px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="error"
                                                Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtNombreComercial"
                                                ToolTip="Favor completar el nombre comercial">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Sector Salarial<br />
                                            <asp:DropDownList ID="ddlSectorSalarial" runat="server" CssClass="dropDowns">
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rqvSectorSalarial" runat="server" CssClass="error"
                                                Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlSectorSalarial"
                                                InitialValue="-1" SetFocusOnError="True" ToolTip="Favor específicar el sector salarial">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Sector Económico<br />
                                            <asp:DropDownList ID="ddlSectorEconomico" runat="server" CssClass="dropDowns">
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rqvSectorEconomico" runat="server" CssClass="error"
                                                Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlSectorEconomico"
                                                InitialValue="-1" SetFocusOnError="True" ToolTip="Favor específicar el sector económico">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Actividad<br />
                                            <asp:DropDownList ID="ddlActividad" runat="Server" CssClass="dropDowns">
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rqvActividad" runat="server" CssClass="error" Display="Dynamic"
                                                ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlActividad" SetFocusOnError="True"
                                                ToolTip="Favor específicar la actividad económica">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>Es Zona Franca<br />
                                            <asp:CheckBox ID="ChkEsZonaFranca" runat="server" AutoPostBack="True" OnCheckedChanged="ChkEsZonaFranca_CheckedChanged" />
                                        </td>
                                    </tr>
                                    <tr id="TrTipo" runat="server">
                                        <td>Tipo<br />
                                            <asp:DropDownList ID="ddlTipoZonaFranca" runat="Server" CssClass="dropDowns">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr id="TrParque" runat="server">
                                        <td>Parque<br />
                                            <asp:DropDownList ID="ddlParque" runat="Server" CssClass="dropDowns">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>

                                </table>

                        <div style="height: 3px;">
                            &nbsp;
                        </div>

                        <table id="InfoRepresenatnte" runat="server" border="0" cellpadding="0" cellspacing="0" class="td-note" width="850">
                            <tr>
                                <td class="listheadermultiline" colspan="4">Representante Principal
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 15%">Representante
                                </td>
                                <%--<td>
                                    <uc3:UCCiudadano ID="ucRepresentante" runat="server" />
                                </td>--%>
                                <td>
                                    <asp:Label ID="LblRepr" runat="server" CssClass="label-Blue" Style="margin-left: 0px;"></asp:Label>
                                </td>

                            </tr>
                            <tr>
                                <td style="width: 15%">Nro. de Documento
                                </td>
                                <td>
                                    <asp:TextBox ID="txtNroDocuemnto" runat="server" MaxLength="25"></asp:TextBox>

                                </td>
                            </tr>
                            <tr>
                                <td style="width: 15%">Teléfono 1
                                </td>
                                <td>
                                    <uc2:ucTelefono2 ID="RepTelefono1" runat="server" isValidEmpty="false" />
                                    &nbsp; Ext.
                                        <asp:TextBox ID="txtRepExt1" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                </td>
                               <%-- <td colspan="2"> Ext.
                                        <asp:TextBox ID="txtRepExt1" runat="server" Width="43px" MaxLength="4" ></asp:TextBox>
                                    
                                </td>--%>
                            </tr>
                            <tr>
                                <td style="width: 15%">Teléfono 2
                                </td>
                                <td>
                                    <uc2:ucTelefono2 ID="RepTelefono2" runat="server" />
                                    &nbsp; Ext.
                                        <asp:TextBox ID="txtRepExt2" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;
                                </td>
                            </tr>
                        </table>

                        <div style="height: 3px;">
                            &nbsp;
                        </div>                        

                        <table id="InfoDatos" runat="server" border="0" cellpadding="0" cellspacing="0" class="td-note" width="850">
                            <tr>
                                <td class="listheadermultiline" colspan="4">Dirección
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div style="height: 5px;">
                                        &nbsp;
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 10%">Calle
                                </td>
                                <td>
                                    <asp:TextBox ID="txtCalle" runat="server" Width="171px" MaxLength="150"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtCalle"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="error">*</asp:RequiredFieldValidator>
                                </td>
                                <td style="width: 10%">Número
                                </td>
                                <td>
                                    <asp:TextBox ID="txtNumero" runat="server" Width="63px" MaxLength="10"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtNumero"
                                        Display="Dynamic" SetFocusOnError="True" CssClass="error">*</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td>Edificio
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEdificio" runat="server" Width="171px" MaxLength="25"></asp:TextBox>
                                </td>
                                <td>Piso
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPiso" runat="server" Width="171px" MaxLength="2"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Apartamento
                                </td>
                                <td>
                                    <asp:TextBox ID="txtApartamento" runat="server" Width="171px" MaxLength="25"></asp:TextBox>
                                </td>
                                <td>Sector
                                </td>
                                <td>
                                    <asp:TextBox ID="txtSector" runat="server" Width="171px" MaxLength="150"></asp:TextBox>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtSector"
                                        CssClass="error" Display="Dynamic" SetFocusOnError="True">*</asp:RequiredFieldValidator>--%>
                                </td>
                            </tr>
                            <tr>
                                <td>Provincia
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlProvincia" runat="server" AutoPostBack="True" CssClass="dropDowns">
                                    </asp:DropDownList>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="ddProvincia"
                                                CssClass="error" Display="Dynamic" InitialValue="-1" SetFocusOnError="True" ToolTip="Selecciones una Provincia">*</asp:RequiredFieldValidator>--%>
                                </td>
                                <td>Municipio
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlMunicipio" runat="server" Width="171px" AutoPostBack="True" CssClass="dropDowns">
                                    </asp:DropDownList>
                                    <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddMunicipio"
                                                CssClass="error" Display="Dynamic" InitialValue="-1" SetFocusOnError="True" ToolTip="Selecciones un Municipio">*</asp:RequiredFieldValidator>--%>
                                </td>
                            </tr>
                            <tr>
                                <td>Teléfono 1
                                </td>
                                <td colspan="3">
                                    <uc2:ucTelefono2 ID="Telefono1" runat="server" ErrorMessage="*" isValidEmpty="false" />
                                    &nbsp;&nbsp; Ext.
                                        <asp:TextBox ID="txtExt1" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Teléfono 2
                                </td>
                                <td colspan="3">
                                    <uc2:ucTelefono2 ID="Telefono2" runat="server" />
                                    &nbsp;&nbsp; Ext.
                                        <asp:TextBox ID="txtExt2" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>Fax
                                </td>
                                <td>
                                    <uc2:ucTelefono2 ID="Fax" runat="server" isValidEmpty="true" />
                                </td>
                                <td>Email
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEmail" runat="server" ToolTip="Ej: alguien@mail.com" Width="171px"
                                        MaxLength="50"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;
                                </td>
                            </tr>

                        </table>

                        <div style="height: 3px;">
                            &nbsp;
                        </div>
                    </div>
                    

                    <div style="height: 3px;">
                        &nbsp;
                    </div>

                    <table id="InfArchivos" runat="server" border="0" cellpadding="0" cellspacing="0" width="850">
                        <tr>
                            <td>
                                <asp:GridView ID="gvarchivos" runat="server" AutoGenerateColumns="False" Width="850">
                                    <Columns>
                                        <asp:BoundField DataField="descripcion" HeaderText="Archivos Adjuntos" ItemStyle-HorizontalAlign="Center" />
                                        <asp:TemplateField HeaderText="Visualizar" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ibDescargar" runat="server" ImageUrl="~/images/pdf.png" CommandName='<%# Eval("id_requisito")%>' CommandArgument='<%# Eval("id_solicitud ")%>' />
                                                <%--<asp:HyperLink ID="ibDescargar" runat="server"
                                                ImageUrl="~/images/pdf.png" Target="_new" CommandName='<%# Eval("Estatus")%>' CommandArgument='<%# Eval("id_certificacion")%>'></asp:HyperLink>--%>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                    </table>

                    <div style="height: 3px;">
                        &nbsp;
                    </div>

                    <table id="InfoComentarioSol" runat="server" class="td-content" border="0" cellpadding="0" cellspacing="0" width="850">

                        <tr>
                            <td align="left" valign="top">Comentario:</td>
                            <td style="width: 200px">
                                <asp:TextBox ID="txtComentario1" runat="server" Width="455px" Height="70px" TextMode="MultiLine"></asp:TextBox>

                            </td>

                        </tr>
                        <tr>
                            <td align="left" colspan="2"></td>
                        </tr>
                    </table>

                    <div style="height: 3px;">
                        &nbsp;
                    </div>


                    <tr style="align-center">
                        <td align="center" colspan="2">
                            <asp:Button ID="btnAprobar" runat="server" Text="APROBAR"></asp:Button>&nbsp;<asp:Button ID="btnRechazar" runat="server" Text="RECHAZAR"></asp:Button>

                        </td>
                    </tr>
        </table>
        <br />

        <asp:Label ID="lblregistro" runat="server" CssClass="label-Blue" Style="margin-left: 280px;"></asp:Label>
        <asp:Label ID="lblerror" runat="server" CssClass="error" EnableViewState="False" Style="margin-left: 30px; font-size: 11pt;"></asp:Label>
        </asp:Panel>


</asp:Content>

