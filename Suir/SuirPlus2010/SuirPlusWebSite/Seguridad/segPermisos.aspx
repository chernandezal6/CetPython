<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="segPermisos.aspx.vb" Inherits="Seguridad_segPermisos" title="Gestión de Permisos" %>
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
	<div class="header">Gestión de Permisos</div>
	<br />
	<table border="0" width="100%" id="table1" style="BORDER-COLLAPSE: collapse" runat="server"
		cellspacing="2" cellpadding="1">
		<tr>
			<td valign="top">
			    <!-- Panel de listado -->
			    <asp:updatepanel runat="server" id="updPermiso" updatemode="Conditional">
			        <contenttemplate>
			            <asp:panel id="pnlListado" Runat="server">
					        <asp:Button id="btnNuevoPermiso" runat="server" Text="Crear Permiso"></asp:Button>
					        <asp:Label id="lblErrorPermisos" runat="server" EnableViewState="False" Visible="False" CssClass="error"></asp:Label>
					        <br />
                            <br />
					        <asp:gridview id="dgPermisos" runat="server" CssClass="list" AutoGenerateColumns="False">
						        <Columns>
							        <asp:BoundField DataField="id_permiso" HeaderText="Cod."></asp:BoundField>
							        <asp:BoundField DataField="permiso_des" HeaderText="Descripci&#243;n"></asp:BoundField>
							        <asp:BoundField DataField="seccion_des" HeaderText="Secci&#243;n"></asp:BoundField>
							        <asp:BoundField DataField="direccion_electronica" HeaderText="URL"></asp:BoundField>
							        <asp:BoundField DataField="status" HeaderText="Estatus"></asp:BoundField>
							        <asp:templatefield headertext="Acciones">
								        <ItemTemplate>
									        <asp:ImageButton id="imgEdit" runat="server" ImageUrl="../images/editar.gif" ToolTip="Editar"
										        BorderWidth="0px" CommandName="Editar" commandargument='<%# Eval("ID_Permiso") %>'>
								            </asp:ImageButton>&nbsp;
									        <asp:ImageButton id="imgDelete" runat="server" ImageUrl="../images/error.gif" ToolTip="Borrar"
										        BorderWidth="0px" onclientclick="return confirm('Esta seguro de eliminar este permiso?')" CommandName="Borrar" commandargument='<%# Eval("ID_Permiso") %>'>
									        </asp:ImageButton>&nbsp;
									        <asp:ImageButton id="imgUser" runat="server" ImageUrl="../images/usuarios.gif" ToolTip="Usuarios que tienen este Permiso"
										        BorderWidth="0px" CommandName="Usuarios" commandargument='<%# Eval("ID_Permiso") %>'>
									        </asp:ImageButton>&nbsp;
									        <asp:ImageButton id="imgRole" runat="server" ImageUrl="../images/roles_new.gif" ToolTip="Roles que tienen este permiso"
										        BorderWidth="0px" CommandName="Roles" commandargument='<%# Eval("ID_Permiso") %>'>
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
        		<asp:updatepanel runat="server" id="updDetalle" updatemode="Conditional">
		            <contenttemplate>
		                <asp:panel id="pnlDetalle" Runat="server" Visible="False">
		                    <fieldset style="Width: 390px">
		                        <legend>
		                            <asp:Label id="lblCrearModificar" runat="server" text="Creación/Modificación de Permisos"></asp:Label>
		                        </legend>
                                <div style="height: 8px;"></div>
			                    <table class="td-content" id="Table2" cellspacing="1" cellpadding="1" border="0" style="width: 336px">
				                    <tr>
					                    <td align="right">Descripción&nbsp;</td>
					                    <td class="labelData" colspan="3">
						                    <asp:TextBox id="txtDescripcion" runat="server" Width="320px"></asp:TextBox>
						                    <asp:RequiredFieldValidator id="reqFieldDescripcion" runat="server" Visible="False" CssClass="error" ControlToValidate="txtDescripcion"
							                    ErrorMessage="El campo de Descripcion es obligatorio" Display="Dynamic">*</asp:RequiredFieldValidator>
					                    </td>
				                    </tr>
			                        <tr>
			                            <td colspan="4" style="height: 6px">
			                            </td>
			                        </tr>
				                    <tr>
					                    <td align="right" style="height: 33px">URL&nbsp;</td>
					                    <td class="labelData" colspan="3" style="height: 33px">
						                    <asp:TextBox id="txtURL" runat="server" Width="320px"></asp:TextBox>
						                    <asp:RequiredFieldValidator id="reqFieldURL" runat="server" Visible="False" CssClass="error" ControlToValidate="txtURL"
							                    ErrorMessage="El campo de URL es obligatorio" Display="Dynamic">*</asp:RequiredFieldValidator>
					                    </td>
				                    </tr>
				                    <tr>
					                    <td align="right">Sección&nbsp;</td>
					                    <td class="labelData" colspan="3" valign="top">
						                    <asp:dropdownlist id="ddlSeccion" runat="server" CssClass="dropDowns"></asp:dropdownlist>
					                        &nbsp;<span style="font-weight: normal; color: #444444">Orden Menú</span>
                                            <asp:TextBox ID="txtOrdenMenu" runat="server" onKeyPress="checkNum()" MaxLength="3" Width="35px"></asp:TextBox>
					                    </td>
				                    </tr>
				                    <tr>
					                    <td align="right">Estatus&nbsp;</td>
					                    <td class="labelData" colspan="3">
						                    <asp:dropdownlist id="ddlEstatus" runat="server" CssClass="dropDowns">
							                    <asp:ListItem Value="A" Selected="True">Activo</asp:ListItem>
							                    <asp:ListItem Value="I">InActivo</asp:ListItem>
						                    </asp:dropdownlist>
					                    </td>
				                    </tr>
                                    <tr>
					                    <td align="right">Tipo&nbsp;</td>
					                    <td class="labelData" colspan="3">
						                    <asp:dropdownlist id="ddlTipoPermiso" runat="server" CssClass="dropDowns">
							                    <asp:ListItem Value="M" Selected="True">Menu</asp:ListItem>
							                    <asp:ListItem Value="O">Objeto</asp:ListItem>
						                    </asp:dropdownlist>
					                    </td>
				                    </tr>
                                     <tr>
					                    <td align="right">Usa Cuota&nbsp;</td>
					                    <td class="labelData" colspan="3">
						                    <asp:dropdownlist id="ddlCuota" runat="server" CssClass="dropDowns">
							                    <asp:ListItem Value="N" Selected="True">No</asp:ListItem>
							                    <asp:ListItem Value="S">Si</asp:ListItem>
						                    </asp:dropdownlist>
					                    </td>
				                    </tr>		
				                    <tr>
					                    <td colspan="4">
						                    <hr style="height:1px; width:100%" />
					                    </td>
				                    </tr>
				                    <tr>
					                    <td colspan="4"></td>
				                    </tr>
				                    <tr>
					                    <td class="error" valign="top" align="left" colspan="3" style="width:60%">
						                    <asp:Label id="lblMensajeDeError" runat="server" EnableViewState="False" Visible="False">* Información obligatoria. </asp:Label><br />
						                    <asp:validationsummary id="valSum" runat="server" Visible="False" CssClass="error" ForeColor=" " width="248px"></asp:validationsummary>
				                        </td>
					                    <td align="right" style="width:40%">
						                    <asp:button id="btAceptar" runat="server" Text="Aceptar"></asp:button>&nbsp;
						                    <asp:button id="btCancelarEdit" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>&nbsp;
					                    </td>
				                    </tr>
			                    </table>
		                    </fieldset></asp:panel>
			        </contenttemplate>
			    </asp:updatepanel>			            
			</td>
			<td style="width: 1%"></td>
			<td valign="top">
				<asp:updatepanel runat="server" id="updPermisos" updatemode="conditional">
				    <contenttemplate>
			            <asp:panel id="pnlUsuariosAsociados" Runat="server" Visible="False">
					        <asp:Label id="lblUsuariosHeader" runat="server" CssClass="subHeader">Usuarios en el Permiso</asp:Label>
					        <br /><br />
					        <asp:Button id="btAgregarUsuario" runat="server" Text="Agregar Usuario"></asp:Button>
					        <asp:Button id="btCancelarUsr" runat="server" Text="Cancelar"></asp:Button>
					        <br />
					        <asp:Label id="lblErrorUsrAsoc" runat="server" EnableViewState="False" Visible="False" CssClass="error"></asp:Label>
					        <br />
					        <asp:gridview id="dgUsuarios" runat="server" Visible="False" CssClass="list" AutoGenerateColumns="False">
						        <Columns>
							        <asp:BoundField DataField="id_Usuario" HeaderText="Usuario"></asp:BoundField>
							        <asp:BoundField DataField="Nombre" HeaderText="Nombre"></asp:BoundField>
							        <asp:TemplateField HeaderText="Remover">
								        <ItemStyle HorizontalAlign="Center"></ItemStyle>
								        <ItemTemplate>
									        <asp:ImageButton id="imgDelete" runat="server" CommandName="Borrar" BorderWidth="0px" ToolTip="Borrar"
										        ImageUrl="../images/error.gif" onclientclick="return confirm('Esta seguro de eliminar este usuario?')" commandargument='<%# Eval("ID_Usuario") %>'>
									        </asp:ImageButton>
								        </ItemTemplate>
							        </asp:TemplateField>
						        </Columns>
					        </asp:gridview>
				        </asp:panel>
				    </contenttemplate>
				</asp:updatepanel>
			    <asp:updatepanel runat="server" id="updRoles" updatemode="conditional">
			        <contenttemplate>
				        <asp:panel id="pnlRolesAsociados" Runat="server" Visible="False">
					        <asp:Label id="lblRolesHeader" runat="server" CssClass="subHeader">Roles asociados al Permiso</asp:Label>
					        <br /><br />
					        <asp:Button id="btAgregarRole" runat="server" Text="Agregar Role"></asp:Button>
					        <asp:Button id="btCancelarPerm" runat="server" Text="Cancelar"></asp:Button>
					        <br />
					        <asp:Label id="lblErroAsocRoles" runat="server" EnableViewState="False" Visible="False" CssClass="error"></asp:Label>
					        <br />
					        <asp:gridview id="dgRoles" runat="server" Visible="False" CssClass="list" AutoGenerateColumns="False">
						        <Columns>
							        <asp:BoundField DataField="Roles_Des" HeaderText="Descripci&#243;n"></asp:BoundField>
							        <asp:TemplateField HeaderText="Remover">
								        <ItemStyle HorizontalAlign="Center"></ItemStyle>
								        <ItemTemplate>
									        <asp:ImageButton id="imgDelete" runat="server" ImageUrl="../images/error.gif" ToolTip="Borrar"
										        BorderWidth="0px" onclientclick="return confirm('Esta seguro de eliminar este role?')" CommandName="Borrar" commandargument='<%# Eval("ID_Role") %>'>
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
	<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>