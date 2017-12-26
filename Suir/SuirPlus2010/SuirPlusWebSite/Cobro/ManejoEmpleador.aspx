<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ManejoEmpleador.aspx.vb" Inherits="ManejoEmpleador" %>
<%@ Register TagPrefix="tss" TagName="Telefono" Src="~/Controles/ucTelefono2.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
     <div class="header">
         Manejo de Carteras
    </div>
    <table style="width: 100%">
         <tr>
             <td>
                 <table style="width: 100%">
        <tr>
            <td class="subHeader">
                <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
                <br />
&nbsp;</td>
            <td class="subHeader" style="text-align:center">
                &nbsp;
                 <fieldset>
                            <legend style="width:100px">Acciones</legend>
                            
                            Atras
                            <asp:ImageButton ID="imgAtras" runat="server" 
                                ImageUrl="~/images/btnfirston.gif" />
&nbsp;&nbsp;&nbsp;
                            <asp:ImageButton ID="imgSiguiente" runat="server" 
                                ImageUrl="~/images/btnlaston.gif" />
&nbsp;Siguiente<br />
                           <%-- Enviar Mail
                            <asp:ImageButton ID="imgEnviar" OnClientClick="javascript:alert('Correo enviado correctamente!!');" runat="server" 
                                ImageUrl="~/images/detalle.gif" />--%>
                </fieldset>
                </td>
        </tr>
        <tr>
            <td class="subHeader" >
                Info Empleador</td>
            <td class="subHeader" rowspan="6" valign="top" >
                <fieldset style="width:500px">
                            <legend style="width:100px">Registre Nuevo CRM</legend>
                             <table style="width: 500px">
                            <tr>
                                <td align="right" style="width:15%;">Tipo de Caso:</td>
                                <td>
                                    <asp:DropDownList ID="ddlTipoCaso" runat="server" CssClass="dropDowns" 
                                        Enabled="false">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlTipoCaso"
                                        CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" InitialValue="-1" ValidationGroup="CRMRegistro">Debe seleccionar el tipo de caso.</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="width:15%;">Estatus Cobro:</td>
                                <td>
                                    <asp:DropDownList ID="ddlStatusCobro" Width="440px" runat="server" CssClass="dropDowns">
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="ddlStatusCobro"
                                        CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" 
                                        InitialValue="-1" ValidationGroup="CRMRegistro">Debe seleccionar un Estatus.</asp:RequiredFieldValidator>
                                </td>
                            </tr>
                              <tr>
                                  <td align="right">Contacto:</td>
                                  <td>
                                      <asp:TextBox ID="txtContacto" runat="server" MaxLength="150" Width="241px" EnableViewState="False"></asp:TextBox>
                                      <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtContacto"
                                          CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True" ValidationGroup="CRMRegistro">El contacto es requerido.</asp:RequiredFieldValidator>
                                  </td>
                              </tr>
                              <tr>
                                  <td align="right">Descripción:</td>
                                  <td>
                                      <asp:TextBox ID="txtDescripcion" runat="server" Height="58px" MaxLength="150" TextMode="MultiLine" CssClass="input" Width="311px" EnableViewState="False"></asp:TextBox>
                                      <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtDescripcion"
                                          CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True" ValidationGroup="CRMRegistro">La descripción es requerida.</asp:RequiredFieldValidator>
                                  </td>
                              </tr>
                              <tr>
                                  <td align="right">
                                      Fecha Notificación:</td>
                                  <td>
                                      <asp:TextBox ID="txtFechaNotificacion" runat="server"></asp:TextBox>
                                      <ajaxToolkit:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1"
                                          ControlToValidate="txtFechaNotificacion" CssClass="error" Display="Dynamic" ErrorMessage="MaskedEditValidator1"
                                          TooltipMessage="Ej: 01/12/2007">Fecha Inválida</ajaxToolkit:MaskedEditValidator>
                                      <asp:CheckBox ID="chkNotificame" runat="server" EnableViewState="False" Text="Notifícame" />
                                      <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender1" runat="server" Mask="99/99/9999"
                                          MaskType="Date" TargetControlID="txtFechaNotificacion" CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="RD$" CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="" CultureName="es-DO" CultureThousandsPlaceholder="," CultureTimePlaceholder="" Enabled="True">
                                      </ajaxToolkit:MaskedEditExtender>
                                      <asp:requiredfieldvalidator id="RequiredFieldValidator5" runat="server" controltovalidate="txtFechaNotificacion"
                                          cssclass="error" display="Dynamic" errormessage="RequiredFieldValidator" initialvalue="-1"
                                          validationgroup="CRMRegistro">Debes digitar la fecha de notifiación.</asp:requiredfieldvalidator>
                                  </td>
                              </tr>
                              <tr>
                                  <td align="right">
                                      Email Adicional 1:</td>
                                  <td>
                                      <asp:TextBox ID="txtMailAdic1" runat="server" MaxLength="150" Width="242px" EnableViewState="False"></asp:TextBox>
                                      <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtMailAdic1"
                                          CssClass="error" Display="Dynamic" SetFocusOnError="True" ToolTip="Ejemplo: usuarios@domain.com">Email Inválido</asp:RegularExpressionValidator></td>
                              </tr>
                              <tr>
                                  <td align="right">
                                      Email Adicional 2:</td>
                                  <td>
                                      <asp:TextBox ID="txtMailAdic2" runat="server" MaxLength="150" Width="242px" EnableViewState="False"></asp:TextBox>
                                      <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtMailAdic2"
                                          CssClass="error" Display="Dynamic" SetFocusOnError="True" ToolTip="Ejemplo: usuarios@domain.com"
                                          ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Email Inválido</asp:RegularExpressionValidator></td>
                              </tr>
                              <tr>
                                  <td align="right">
                                  </td>
                                  <td align="center">
                                      <asp:Button ID="btnRegistrar" runat="server" Text="Registrar" OnClick="btnRegistrar_Click" ValidationGroup="CRMRegistro" />
                                      <input id="Reset1" class="Button" type="reset" value="Limpiar" /></td>
                              </tr>
                          </table>
                        </fieldset>
                          
                        <asp:Label ID="lblMensajeCRM" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                          <br />
                   <ajaxToolkit:TabContainer ID="TabContainer1" runat="server" 
                    ActiveTabIndex="0">
                    
                    <ajaxToolkit:TabPanel ID="TabPanel1" runat="server" HeaderText="CRM Cartera">
                    
                        <HeaderTemplate>
                            CRM Cartera
                        </HeaderTemplate>
                    
                    <ContentTemplate>
                            <table style="width:500px%" class="tblWithImagen" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="listheadermultiline" style="width:500px%">
                                    &nbsp;Último Registro</td>                                
                            </tr>
                            <tr>
                                <td>
                                    <asp:DataList ID="dlUltimosRegistros" runat="server" 
                                        RepeatDirection="Horizontal" Width="500px">
                                        <ItemTemplate>
                                            <tr class="listItem">
                                                <td class="listItem" style="width:25%">
                                                     <%#Eval("nombre") %>     
                                                    <br>
                                                    <em>
                                                      <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                       <%#Eval("asunto")%> 
                                                    </b>
                                                    <br>
                                                    Tipo de Registro:
                                                    <%#Eval("tipo_registro_des")%>
                                                    <br>
                                                    Estatus Cobro:
                                                    <%#Eval("descripcion")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des") %> 
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr class="listAltItem">
                                                <td class="listItem" style="width:25%">
                                                     <%#Eval("nombre") %>     
                                                    <br>
                                                    <em>
                                                      <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                       <%#Eval("asunto")%> 
                                                    </b>
                                                    <br>
                                                   Tipo de Registro:
                                                    <%#Eval("tipo_registro_des")%>
                                                    <br>
                                                    Estatus Cobro:
                                                    <%#Eval("descripcion")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des") %> 
                                                </td>
                                            </tr>
                                        </AlternatingItemTemplate>
                                    </asp:DataList>
                                   
                                </td>
                            </tr>
                          </table> 
                    </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                    <ajaxToolkit:TabPanel ID="TabPanel2" runat="server" HeaderText="Otros CRM">
                        <HeaderTemplate>
                            Otros CRM
                        </HeaderTemplate>
                    <ContentTemplate>
                       <table style="width:500px%" class="tblWithImagen" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="listheadermultiline" style="width:500px%">
                                    &nbsp;Último Registro</td>                                
                            </tr>
                            <tr>
                                <td>
                                    <asp:DataList ID="dtOtrosCRM" runat="server" 
                                        RepeatDirection="Horizontal" Width="500px">
                                          <ItemTemplate>
                                            <tr class="listItem">
                                                <td class="listItem" style="width:25%">
                                                     <%#Eval("nombre") %>     
                                                    <br>
                                                    <em>
                                                      <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                       <%#Eval("asunto")%> 
                                                    </b>
                                                    <br>
                                                    Tipo de Registro:
                                                    <%#Eval("tipo_registro_des")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des") %> 
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr class="listAltItem">
                                                <td class="listItem" style="width:25%">
                                                     <%#Eval("nombre") %>     
                                                    <br>
                                                    <em>
                                                      <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                       <%#Eval("asunto")%> 
                                                    </b>
                                                    <br>
                                                    Tipo de Registro:
                                                    <%#Eval("tipo_registro_des")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des") %> 
                                                </td>
                                            </tr>
                                        </AlternatingItemTemplate>
                                    </asp:DataList>
                                   
                                </td>
                            </tr>
                          </table> 
                    </ContentTemplate>
                       </ajaxToolkit:TabPanel>
                                    </ajaxToolkit:TabContainer></td>
        </tr>
        <tr>
            <td valign="top" >
            
                <ajaxToolkit:TabContainer ID="TabContainer3" runat="server" ActiveTabIndex="0">
                    <ajaxToolkit:TabPanel runat="server" HeaderText="Empresa" ID="TabPanel5">
                    <ContentTemplate>
                    
                        <table style="width: 80%">
                    <tr>
                        <td>
                            RNC</td>
                        <td>
                            <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                        <td>
                            RegistroPatronal</td>
                        <td>
                            <asp:Label ID="lblRegistro" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Razon Social</td>
                        <td colspan="3">
                            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Nombre Comercial</td>
                        <td colspan="3">
                            <asp:Label ID="lblNombreComercial" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                    </tr>
                            <tr>
                                <td>
                                    Direccion</td>
                                <td colspan="3">
                                    <asp:Label ID="lblDireccion" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                    <tr>
                        <td>
                            Telefono 1</td>
                        <td>
                            <tss:Telefono ID="ucTelefono1" runat="server" /> 
                              
                        </td>
                        <td>
                            Telefono 1</td>
                        <td>
                            <asp:Label ID="lblTelefono1" runat="server" CssClass="labelData"></asp:Label>
                            <asp:CheckBox ID="chkTel1" runat="server" AutoPostBack="True" 
                                Text="Marcar con el 1" />
                        </td>
                    </tr>
                            <tr>
                                <td>
                                    Telefono 2</td>
                                <td>
                                    <tss:Telefono ID="ucTelefono2" runat="server" />
                                </td>
                                <td>
                                    Telefono 2</td>
                                <td>
                                    <asp:Label ID="lblTelefono2" runat="server" CssClass="labelData"></asp:Label>
                                    <asp:CheckBox ID="chkTel2" runat="server" AutoPostBack="True" 
                                        Text="Marcar con el 1" />
                                </td>
                            </tr>
                    <tr>
                        <td>
                            Fax</td>
                        <td>
                           <tss:Telefono ID="ucFax" runat="server" />   
                        </td>
                        <td>
                            Email</td>
                        <td>
                            <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                    Display="Dynamic" ErrorMessage="Email Inválido" SetFocusOnError="True" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4" style="text-align:right">
                            <asp:Button ID="btnActualizar" runat="server" Text="Actualizar Datos" />
                        </td>
                    </tr>
                </table>
                    
                    </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                    <ajaxToolkit:TabPanel runat="server" HeaderText="Representantes" ID="TabPanel6">
                    <ContentTemplate>
                    <asp:DataList ID="dtRepresentante" runat="server" RepeatColumns="2" ShowFooter="False" ShowHeader="False" CellSpacing="5">
                                <ItemTemplate>
                                    <table class="tblContact" cellspacing="0" cellpadding="3" style="width:50%;">
                                        <tr>
                                            <td class="tdContactHeader" colspan="3">
                                                <asp:Label ID="lblRepresentante" runat="server" Text='<%# Eval("NOMBRE") %>' />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width:25%">Cédula/Pasaporte:</td>
                                            <td colspan="2"><asp:Label ID="lblRedCedula" runat="server" Text='<%# formatCedula(Eval("NO_DOCUMENTO")) %>'>
                                                </asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>Teléfono:</td>
                                            <td colspan="2"><asp:Label ID="lblRepTelefono" runat="server" Text='<%# formatTelefono(Eval("TELEFONO_1")) %>' Width="150px"></asp:Label></td>
                                        </tr>
                                        <tr>
                                            <td>Email:</td>
                                            <td colspan="2"><asp:Label ID="lblRepEmail" runat="server" Text='<%# Eval("EMAIL") %>' /></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Tipo:
                                            </td>
                                            <td colspan="2">
                                                <asp:label id="lblTipo" runat="server" text='<%#IIF(Eval("Tipo_Representante")="A","Administrador","Normal") %>' />
                                            </td>                                            
                                        </tr>
                                    </table>
                                   </ItemTemplate>
                                </asp:DataList>
                    
                    </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                </ajaxToolkit:TabContainer>
            </td>
        </tr>
        <tr>
            <td >
                &nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td class="subHeader">
                Notificaciones</td>
        </tr>
        <tr>
            <td valign="top" style="height:150px">
                <ajaxToolkit:TabContainer ID="TabContainer2" runat="server" ActiveTabIndex="0">
                    <ajaxToolkit:TabPanel runat="server"  HeaderText="Vencidas" ID="TabPanel3">
                
                        <HeaderTemplate>
                            Vencidas
                        </HeaderTemplate>
                
                <ContentTemplate>
                    <asp:Label ID="lblCantidadVencidas" CssClass="labelData" runat="server"></asp:Label>
                 <asp:GridView ID="dgNotificaciones" runat="server" AutoGenerateColumns="False" 
                    ShowFooter="True" Width="750px">
                    <Columns>
                        <asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="status" HeaderText="Status">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Nomina_des" HeaderText="Nomina" />
                        <asp:templatefield headertext="Período">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" 
                                    Text='<%# FormatearPeriodo(Eval("Periodo_Factura")) %>'></asp:Label>
                            </ItemTemplate>
                            <itemstyle horizontalalign="Center" />
                            <headerstyle horizontalalign="Center" />
                        </asp:templatefield>
                        <asp:BoundField DataField="FECHA_EMISION" dataformatstring="{0:d}" 
                            HeaderText="Emisión" htmlencode="False">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                          <asp:BoundField DataField="fecha_limite_pago" dataformatstring="{0:d}" 
                            HeaderText="Limite" htmlencode="False">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="total_importe" DataFormatString="{0:n}" 
                            HeaderText="Importe" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <footerstyle horizontalalign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="TOTAL_RECARGOS_FACTURA" DataFormatString="{0:n}" 
                            HeaderText="Recargos" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <footerstyle horizontalalign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="TOTAL_INTERES_FACTURA" DataFormatString="{0:n}" 
                            HeaderText="Intereses" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="total_general" DataFormatString="{0:n}" 
                            HeaderText="Total" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                    </Columns>
                    <FooterStyle Font-Bold="True" />
                </asp:GridView>
                <asp:Panel ID="pnlNavigation" runat="server" Visible="False">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="&lt;&lt; Primera"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="&lt; Anterior"></asp:LinkButton>
                                &nbsp; Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>
                                ] de
                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                &nbsp;
                                <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="Próxima &gt;"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="Última &gt;&gt;"></asp:LinkButton>
                                &nbsp;
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Total de archivos&nbsp;
                                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                
                </ContentTemplate>
                    
                    </ajaxToolkit:TabPanel>
                    <ajaxToolkit:TabPanel ID="TabPanel4" runat="server" HeaderText="Pagadas">
                    <ContentTemplate>
                        <asp:Label ID="lblCantidadPagadas" CssClass="labelData" runat="server"></asp:Label>
                        <asp:GridView ID="gvPagadas" runat="server" AutoGenerateColumns="False" 
                    ShowFooter="True" Width="750px" EmptyDataText="No hay data!!">
                    <Columns>
                        <asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="status" HeaderText="Status">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Nomina_des" HeaderText="Nomina" />
                        <asp:templatefield headertext="Período">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" 
                                    Text='<%# FormatearPeriodo(Eval("Periodo_Factura")) %>'></asp:Label>
                            </ItemTemplate>
                            <itemstyle horizontalalign="Center" />
                            <headerstyle horizontalalign="Center" />
                        </asp:templatefield>
                        <asp:BoundField DataField="FECHA_EMISION" dataformatstring="{0:d}" 
                            HeaderText="Emisión" htmlencode="False">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="FECHA_PAGO" dataformatstring="{0:d}" 
                            HeaderText="Pago" htmlencode="False">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="total_importe" DataFormatString="{0:n}" 
                            HeaderText="Importe" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <footerstyle horizontalalign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="TOTAL_RECARGOS_FACTURA" DataFormatString="{0:n}" 
                            HeaderText="Recargos" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <footerstyle horizontalalign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="TOTAL_INTERES_FACTURA" DataFormatString="{0:n}" 
                            HeaderText="Intereses" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="total_general" DataFormatString="{0:n}" 
                            HeaderText="Total" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        <FooterStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                    </Columns>
                    <FooterStyle Font-Bold="True" />
                </asp:GridView>
                    
                    </ContentTemplate>
                    </ajaxToolkit:TabPanel>
                </ajaxToolkit:TabContainer>
               
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
        </tr>
    </table>
</td>
            
         </tr>
         <tr>
             <td>
                 </td>
            
         </tr>
     </table>
</asp:Content>

