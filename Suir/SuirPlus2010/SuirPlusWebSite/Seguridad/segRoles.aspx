<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="segRoles.aspx.vb" Inherits="Seguridad_segRoles" title="Roles" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<div class="header">Gestión de Roles</div>
	<br />
	<table id="table1" style="BORDER-COLLAPSE: collapse" width="100%" border="0" runat="server">
		<tr>
			<td valign="top" style="width:30%"> <!-- Panel de listado -->
			    <asp:updatepanel id="updListado" runat="server" updatemode="conditional">
			        <contenttemplate>
			            <asp:panel id="pnlListado" Runat="server">
					        <asp:Button id="btnNuevoRole" runat="server" Text="Crear Role"></asp:Button>
					        <br />					
					        <asp:Label id="lblMensajeError" runat="server" EnableViewState="False" Visible="False" CssClass="error"></asp:Label>
					        <br />
					        <asp:gridview id="dgRoles" runat="server" AutoGenerateColumns="False">
					            <Columns>
							        <asp:BoundField DataField="id_role" HeaderText="Codigo"></asp:BoundField>
							        <asp:BoundField DataField="Roles_des" HeaderText="Descripci&#243;n"></asp:BoundField>
							        <asp:BoundField DataField="status" HeaderText="Estatus"></asp:BoundField>
							        <asp:TemplateField headertext="Acciones">
								        <ItemTemplate>
									        <asp:ImageButton id="ImageButton1" runat="server" ToolTip="Editar" ImageUrl="../images/editar.gif"
										        CommandName="Editar" BorderWidth="0px" commandargument='<%# Eval("id_role") %>'>
									        </asp:ImageButton>&nbsp;
									        <asp:ImageButton id="Imagebutton4" runat="server" ToolTip="Borrar" commandargument='<%# Eval("id_role") %>' ImageUrl="../images/error.gif"
										        onclientclick="return confirm('Estas seguro de eliminar este role?')" CommandName="Borrar" BorderWidth="0px">
									        </asp:ImageButton>&nbsp;
									        <asp:ImageButton id="ImageButton8" runat="server" ToolTip="Usuarios Asociados a este Role" ImageUrl="../images/usuarios.gif"
										        CommandName="Usuarios" BorderWidth="0px" commandargument='<%# Eval("id_role") %>'>
									        </asp:ImageButton>&nbsp;
									        <asp:ImageButton id="ImageButton7" runat="server" ToolTip="Permisos asociados a este Role" ImageUrl="../images/permisos.gif"
										        CommandName="Permisos" BorderWidth="0px" commandargument='<%# Eval("id_role") %>'>
									        </asp:ImageButton>
								        </ItemTemplate>
							        </asp:TemplateField>
						        </Columns>
					        </asp:gridview>
				        </asp:panel>
	    	        </contenttemplate>
    		    </asp:updatepanel>
				<!-- Fin del panel de listado --> 
				<!-- Panel de detalle -->
				<asp:updatepanel id="updDetalle" runat="server" updatemode="Conditional">
				    <contenttemplate>
				        <asp:panel id="pnlDetalle" Runat="server" Visible="False">
				            <fieldset>
				                <legend>
				                    <asp:label id="lblCrearModificar" runat="server" text="Crear Role"></asp:label>
				                </legend>
                                <div style="height: 8px;"></div>				        
				                <table class="td-content" id="Table2" cellspacing="1" cellpadding="1" width="350" border="0">
					                <tr>
						                <td colspan="4" style="height: 6px"></td>
					                </tr>
					                <tr>
						                <td align="right">Descripción&nbsp;</td>
						                <td class="labelData" colspan="3">
							                <asp:TextBox id="txtDescripcion" runat="server" Width="300px"></asp:TextBox>
							                <asp:RequiredFieldValidator id="reqFieldDescripcion" runat="server" Visible="False" CssClass="error" ControlToValidate="txtDescripcion"
								                ErrorMessage="El campo de Descripcion es obligatorio" Display="Dynamic">*</asp:RequiredFieldValidator>
						                </td>
					                </tr>
					                <tr>
						                <td align="right">Estatus&nbsp;</td>
						                <td class="labelData" colspan="3">
							                <asp:dropdownlist id="ddlEstatus" runat="server" cssclass="dropDowns">
								                <asp:ListItem Value="A" Selected="True">Activo</asp:ListItem>
								                <asp:ListItem Value="I">InActivo</asp:ListItem>
							                </asp:dropdownlist>
						                </td>
					                </tr>
					                <tr>
						                <td colspan="4"></td>
					                </tr>
					                <tr>
						                <td colspan="4">
							                <hr style="height: 1px; width: 100%" />
						                </td>
					                </tr>
					                <tr>
						                <td class="error" valign="top" align="left" style="width: 57%" colspan="3">
							                <asp:validationsummary id="valSum" runat="server" Visible="False" CssClass="error" ForeColor=" "></asp:validationsummary>
						                </td>
						                <td align="right" style="width: 43%">
							                <asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>&nbsp;
							                <asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>&nbsp; 
							                &nbsp;
						                </td>
					                </tr>
				                </table>
				            </fieldset>
				        </asp:panel>
				    </contenttemplate>
				</asp:updatepanel>				
			</td>
			<td style="width:1%">
			</td>
			<td valign="top" style="width: 69%">
			    <asp:updatepanel id="updUsuario" runat="server" updatemode="Conditional">
			        <contenttemplate>
			            <asp:panel id="pnlUsuariosAsociados" Runat="server" Visible="False">
					        <asp:Label id="lblUsuariosHeader" runat="server" CssClass="subHeader">Usuarios asociados al Role</asp:Label>
					        <br />
					        <asp:Label id="lblErrorUsrAsoc" runat="server" EnableViewState="False" Visible="False" CssClass="error"></asp:Label>
					        <br />
					        <asp:Button id="btnAgregarUsuario" runat="server" Text="Agregar Usuario"></asp:Button>
					        <asp:Button id="btnCancelarUsr" runat="server" Text="Cancelar"></asp:Button>
					        <br /><br />
					        <asp:gridview id="dgUsuarios" runat="server" Visible="False" AutoGenerateColumns="False">
						        <Columns>
							        <asp:BoundField DataField="ID_Usuario" HeaderText="Usuario"></asp:BoundField>
							        <asp:BoundField DataField="Nombre" HeaderText="Nombre"></asp:BoundField>
							        <asp:TemplateField HeaderText="Remover">
								        <ItemStyle HorizontalAlign="Center"></ItemStyle>
								        <ItemTemplate>
									        <asp:ImageButton id="ImageButton2" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
										        CommandName="Borrar" BorderWidth="0px" onclientclick="return confirm('Estas seguro de eliminar este usuario?')" 
										        commandargument='<%# Eval("id_usuario") %>'>
									        </asp:ImageButton>
								        </ItemTemplate>
							        </asp:TemplateField>
						        </Columns>
					        </asp:gridview>
				        </asp:panel>
			        </contenttemplate>
			    </asp:updatepanel>
			    <asp:updatepanel id="updPermisos" runat="server" updatemode="conditional">
			        <contenttemplate>
				        <asp:panel id="pnlPermisosAsociados" Runat="server" Visible="False">
					        <asp:Label id="lblRolesHeader" runat="server" CssClass="subHeader">Permisos asociados al Role</asp:Label>
					        <br />
					        <asp:Label id="lblErrorPermAsoc" runat="server" EnableViewState="False" Visible="False" CssClass="error"></asp:Label>
					        <br />
					        <asp:Button id="btnAgregarPermiso" runat="server" Text="Agregar Permiso"></asp:Button>
					        <asp:Button id="btnCancelarRole" runat="server" Text="Cancelar"></asp:Button>
					        <br /><br />
					        <asp:gridview id="dgPermisos" runat="server" Visible="False" AutoGenerateColumns="False">
						        <Columns>
							        <asp:BoundField DataField="permiso_des" HeaderText="Descripci&#243;n"></asp:BoundField>
							        <asp:BoundField DataField="seccion_des" HeaderText="Secci&#243;n"></asp:BoundField>
							        <asp:BoundField DataField="direccion_electronica" HeaderText="URL"></asp:BoundField>
							        <asp:TemplateField HeaderText="Remover">
								        <ItemStyle HorizontalAlign="Center"></ItemStyle>
								        <ItemTemplate>
									        <asp:ImageButton id="ImageButton3" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
										        onclientclick="return confirm('Estas seguro de eliminar este permiso?')" 
										        CommandName="Borrar" BorderWidth="0px" commandargument='<%# Eval("id_permiso") %>'>
									        </asp:ImageButton>
								        </ItemTemplate>
							        </asp:TemplateField>
						        </Columns>
					        </asp:gridview>
				        </asp:panel>
			        </contenttemplate>
			    </asp:updatepanel>								
			</td>
		</tr>
	</table>
</asp:Content>