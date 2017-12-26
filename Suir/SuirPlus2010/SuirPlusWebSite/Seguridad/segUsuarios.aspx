<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="segUsuarios.aspx.vb" Inherits="Seguridad_segUsuarios" Title="Gestión de Usuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init

            Me.RolesOpcionales = New String() {"54", "10", "53", "233"}
			
        End Sub
    </script>
    <div class="header">
        Gestión de Usuarios</div> 
    <br />
    <!-- Panel de listado -->
    <table id="tblCuadro" style="border-collapse: collapse" width="100%" border="0" runat="server">
        <tr>
            <td valign="top" style="width: 44%">
                <asp:UpdatePanel runat="server" ID="updListado" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Panel ID="pnlListado" runat="server">
                        <div style="height:auto">
                            <asp:Button ID="btnNuevoUsuario" runat="server" Text="Crear Usuario"></asp:Button>
                            <asp:Label ID="lblMensajeError" runat="server" EnableViewState="False" Visible="False"
                                CssClass="label-Resaltado"></asp:Label>
                            <br />
                            <br />
                            <fieldset>
                                <legend>Busqueda de Usuarios</legend>
                                <div style="height: 8px;">
                                    </div>
                                <table id="Table3" class="td-content" cellspacing="2" cellpadding="2" border="0">
                                    <tr>
                                        <td align="right">
                                            <asp:Label ID="Label7" runat="server">Usuario</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSrchUserName" runat="server" MaxLength="35"></asp:TextBox>
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="Label6" runat="server">Nombres</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSrchNombres" runat="server" MaxLength="40"></asp:TextBox>
                                        </td>
                                        <td align="right">
                                            <asp:Label ID="Label5" runat="server">Apellidos</asp:Label>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtSrchApellidos" runat="server" MaxLength="40"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:ImageButton ID="ImgBuscar" runat="server" ImageUrl="../images/buscar.gif" BorderWidth="0px"
                                                OnClick="ImgBuscar_Click"></asp:ImageButton>
                                        </td>
                                    </tr>
                                </table>
                                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"
                                    Visible="False"></asp:Label>
                                <br />
                                <asp:GridView ID="dgUsuarios" runat="server" CssClass="list" AutoGenerateColumns="False">
                                    <Columns>
                                        <asp:BoundField DataField="ID_Usuario" HeaderText="Usuario"></asp:BoundField>
                                        <asp:BoundField DataField="nombre" HeaderText="Nombre" HeaderStyle-Width="180px">
                                        </asp:BoundField>
                                        <asp:BoundField DataField="statusdesc" HeaderText="Status"></asp:BoundField>
                                        <asp:BoundField DataField="Email" HeaderText="Email"></asp:BoundField>
                                        <asp:TemplateField HeaderText="Acciones">
                                            <ItemTemplate>
                                                &nbsp;
                                                <asp:ImageButton ID="ImageButton10" runat="server" ImageUrl="../images/editar.gif"
                                                    BorderWidth="0px" ToolTip="Editar este usuario" CommandName="Editar" CommandArgument='<%# Eval("ID_Usuario") %>'>
                                                </asp:ImageButton>&nbsp;
                                                <asp:ImageButton ID="ImageButton9" runat="server" ImageUrl="../images/error.gif"
                                                    BorderWidth="0px" OnClientClick="return confirm('Estas seguro de eliminar este usuario?')"
                                                    ToolTip="Borrar este usuario" CommandName="Borrar" CommandArgument='<%# Eval("ID_Usuario") %>'>
                                                </asp:ImageButton>&nbsp;
                                                <asp:ImageButton ID="ImageButton12" runat="server" ImageUrl="../images/roles_new.gif"
                                                    BorderWidth="0px" ToolTip="Roles que tiene asignado este usuario" CommandName="Roles"
                                                    CommandArgument='<%# Eval("ID_Usuario") %>'></asp:ImageButton>&nbsp;
                                                <asp:ImageButton ID="imgBtnPermisos" runat="server" ImageUrl="../images/permisos.gif"
                                                    BorderWidth="0px" ToolTip="Permisos que tiene asignado este usuario" CommandName="Permisos"
                                                    CommandArgument='<%# Eval("ID_Usuario") %>'></asp:ImageButton>
                                                <asp:ImageButton ID="imgBtReseteo" runat="server" ImageUrl="../images/retornar.gif"
                                                    BorderWidth="0px" ToolTip="Reseteo de CLASS" CommandName="Reseteo" CommandArgument='<%# Eval("ID_Usuario") %>'>
                                                </asp:ImageButton>&nbsp;
                                                <asp:Label ID="lblID" runat="server" Text='<%# Eval("ID_Usuario") %>' Visible="False">
                                                </asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                </div>
                            </fieldset>
                        </asp:Panel>
                        <!-- Fin del panel de listado -->
                    </ContentTemplate>
                </asp:UpdatePanel>
                <asp:UpdatePanel runat="server" ID="updDetalle" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Panel ID="pnlDetalle" runat="server" Visible="False">
                            <fieldset style="width: 508px; height:508px">
                                <legend>
                                    <asp:Label ID="lblCrearModificar" runat="server" Text="Creación/Modificación de Usuarios"></asp:Label>
                                </legend>
                                <div style="height: 8px">
                                </div>
                                <table id="Table2" class="td-content" cellspacing="1" cellpadding="1" width="308"
                                    border="0">
                                    <tbody>
                                        <tr>
                                            <td style="width: 256px; text-align: right;" class="labelData">
                                                Usuario
                                            </td>
                                            <td align="right" style="text-align: left">
                                                <asp:TextBox ID="txtUserName" runat="server" Width="240px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqFieldUsuario" runat="server" ControlToValidate="txtUserName"
                                                    CssClass="error" Display="Dynamic" ErrorMessage="El campo de Usuario es obligatorio"
                                                    Visible="False">*</asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                Class&nbsp;
                                            </td>
                                            <td style="width: 256px" class="labelData">
                                                <asp:TextBox ID="txtPassword" runat="server" Width="240px" TextMode="Password">AdivinaEstePassword123</asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqFieldClass" runat="server" CssClass="error" Visible="False"
                                                    ControlToValidate="txtPassword" ErrorMessage="El campo de Class es obligatorio"
                                                    Display="Dynamic">*</asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                Nombres&nbsp;
                                            </td>
                                            <td style="width: 256px" class="labelData">
                                                <asp:TextBox ID="txtNombres" runat="server" Width="240px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqFieldNombres" runat="server" CssClass="error"
                                                    Visible="False" ControlToValidate="txtNombres" ErrorMessage="El campo de Nombres es obligatorio"
                                                    Display="Dynamic">*</asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                Apellidos&nbsp;
                                            </td>
                                            <td style="width: 256px" class="labelData">
                                                <asp:TextBox ID="txtApellidos" runat="server" Width="240px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqFieldApellidos" runat="server" CssClass="error"
                                                    Visible="False" ControlToValidate="txtApellidos" ErrorMessage="El campo de Apellidos es obligatorio"
                                                    Display="Dynamic">*</asp:RequiredFieldValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right" valign="top">
                                                Email&nbsp;
                                            </td>
                                            <td style="width: 256px" class="labelData" valign="top">
                                                <asp:TextBox ID="txtEmail" runat="server" Width="240px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="reqFieldEmail" runat="server" CssClass="error" Visible="False"
                                                    ControlToValidate="txtEmail" ErrorMessage="El campo de Email es obligatorio"
                                                    Display="Dynamic">*</asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                                    ErrorMessage="Correo electrónico erróneo." SetFocusOnError="True" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                Departamento
                                            </td>
                                            <td style="width: 256px" class="labelData">
                                                <asp:TextBox ID="txtDepartamento" runat="server" Width="240px"></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <div id="infoUsuario" runat="server">
                                                    <table width="100%">
                                                        <tr>
                                                            <td align="right">
                                                                Cambiar Class
                                                            </td>
                                                            <td style="width: 256px" class="labelData">
                                                                <asp:Label ID="lblCambiarClass" runat="server" Width="240px" ReadOnly="true"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right">
                                                                Ultimo login
                                                            </td>
                                                            <td style="width: 256px" class="labelData">
                                                                <asp:Label ID="lblUltLo" runat="server" Width="240px" ReadOnly="true"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right">
                                                                IP
                                                            </td>
                                                            <td style="width: 256px" class="labelData">
                                                                <asp:Label ID="lblIp" runat="server" Width="240px" ReadOnly="true"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right">
                                                                Ultima fecha actualización
                                                            </td>
                                                            <td style="width: 256px" class="labelData">
                                                                <asp:Label ID="lblUltFechaAc" runat="server" Width="240px" ReadOnly="true"></asp:Label>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td align="right">
                                                                Ultima usuario actualizo
                                                            </td>
                                                            <td style="width: 256px" class="labelData">
                                                                <asp:Label ID="lblUltUserAc" runat="server" Width="240px" ReadOnly="true"></asp:Label>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </td>
                                            <tr>
                                                <td align="right">
                                                    Entidad Recaudadora
                                                </td>
                                                <td style="width: 256px" class="labelData">
                                                    <asp:DropDownList ID="ddlEntidad" runat="server" CssClass="dropDowns" Width="240px">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Estatus&#160;
                                                </td>
                                                <td class="labelData" style="width: 256px">
                                                    <asp:DropDownList ID="ddlEstatus" runat="server" CssClass="dropDowns" Width="140px">
                                                        <asp:ListItem Selected="True" Value="A">Activo</asp:ListItem>
                                                        <asp:ListItem Value="I">Inactivo</asp:ListItem>
                                                         <asp:ListItem Value="B">Bloqueado</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Comentario
                                                </td>
                                                <td style="width: 256px" class="labelData">
                                                    <asp:TextBox ID="txtComen" runat="server" Width="240px" TextMode="multiline" Height="30px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <hr style="width: 100%" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td valign="middle" align="right" colspan="2">
                                                    <asp:Button ID="btnAceptar" OnClick="btnAceptar_Click" runat="server" Text="Aceptar">
                                                    </asp:Button>&nbsp;
                                                    <asp:Button ID="btnCancelar" OnClick="btnCancelar_Click" runat="server" Text="Cancelar"
                                                        CausesValidation="False"></asp:Button>&nbsp;
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="error" valign="top" align="left" colspan="2">
                                                    <asp:Label ID="lblMensajeDeError" runat="server" Visible="False" EnableViewState="False"
                                                        CssClass="label-Resaltado">* Información obligatoria.</asp:Label>
                                                    <asp:ValidationSummary ID="valSum" runat="server" CssClass="error" Visible="False"
                                                        ForeColor=" "></asp:ValidationSummary>
                                                    &nbsp;&nbsp;
                                                </td>
                                            </tr>
                                    </tbody>
                                </table>
                            </fieldset>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
            <td style="width: 1%">
            </td>
            <td valign="top" style="width: 50%">
                <asp:UpdatePanel runat="server" ID="updRoles" UpdateMode="conditional">
                    <ContentTemplate>
                        <asp:Panel CssClass="header" ID="pnlRolesAsociados" runat="server" Visible="False">
                            <asp:Label ID="lblRolesHeader" runat="server" CssClass="subHeader">Roles asociados al Permiso</asp:Label>
                            <br />
                            <br />
                            <asp:Button ID="btnAgregarRole" runat="server" Text="Agregar"></asp:Button>
                            <asp:Button ID="btnCancelarRole" runat="server" Text="Regresar" OnClick="btnCancelarRole_Click">
                            </asp:Button>
                            <br />
                            <asp:Label ID="lblErroAsocRoles" runat="server" EnableViewState="False" Visible="False"
                                CssClass="label-Resaltado"></asp:Label>
                            <br />
                            <asp:GridView ID="dgRoles" runat="server" Visible="False" CssClass="list" AutoGenerateColumns="False"
                                OnRowCommand="dgRoles_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="Roles_Des" HeaderText="Descripci&#243;n"></asp:BoundField>
                                    <asp:TemplateField HeaderText="Remover">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="imgDelete" runat="server" CommandName="Borrar" BorderWidth="0px"
                                                ToolTip="Borrar" OnClientClick="return confirm('Estas seguro de quitar al usuario de este role?')"
                                                CommandArgument='<%# Eval("ID_Role") %>' ImageUrl="../images/error.gif"></asp:ImageButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
                <asp:UpdatePanel runat="server" ID="updPermisos" UpdateMode="conditional">
                    <ContentTemplate>
                        <asp:Panel CssClass="header" ID="pnlPermisosAsociados" runat="server" Visible="False">
                            <asp:Label ID="lblPermisosHeader" runat="server" CssClass="subHeader">Permisos asociados al Role</asp:Label>
                            <br />
                            <br />
                            <asp:Button ID="btnAgregarPermiso" runat="server" Text="Agregar"></asp:Button>
                            <asp:Button ID="btnCancelarPermiso" runat="server" Text="Regresar" OnClick="btnCancelarPermiso_Click">
                            </asp:Button>
                            <br />
                            <asp:Label ID="lblErrorPermAsoc" runat="server" EnableViewState="False" Visible="False"
                                CssClass="label-Resaltado"></asp:Label>
                            <br />
                            <asp:GridView ID="dgPermisos" runat="server" Visible="False" CssClass="list" AutoGenerateColumns="False"
                                OnRowCommand="dgPermisos_RowCommand">
                                <Columns>
                                    <asp:BoundField DataField="permiso_des" HeaderText="Descripci&#243;n"></asp:BoundField>
                                    <asp:BoundField DataField="seccion_des" HeaderText="Secci&#243;n"></asp:BoundField>
                                    <asp:BoundField DataField="direccion_electronica" HeaderText="URL"></asp:BoundField>
                                    <asp:TemplateField HeaderText="Remover">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButton3" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
                                                OnClientClick="return confirm('Estas seguro de quitarle este permiso al usuario?')"
                                                CommandName="Borrar" BorderWidth="0px" CommandArgument='<%# Eval("ID_Permiso") %>'>
                                            </asp:ImageButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
    </table>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
