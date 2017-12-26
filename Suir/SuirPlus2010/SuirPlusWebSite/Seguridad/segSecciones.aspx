<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="segSecciones.aspx.vb" Inherits="Seguridad_segSecciones" title="Secciones" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	
	<script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
	        Me.RoleRequerido = 10
			
	    End Sub
	</script>
			
    <asp:updatepanel id="updGeneral" runat="server" updatemode="Conditional">
        <contenttemplate>
	        <div class="header">Gestión de Secciones</div>
	        <br />
	        <asp:panel id="pnlListado" Runat="server">
		        <asp:Button id="btnNuevaSeccion" runat="server" Text="Crear Sección"></asp:Button>
		        <br />
		        <br />
		        <asp:gridview id="dgSecciones" runat="server" AutoGenerateColumns="False" onrowcommand="dgSecciones_RowCommand">
			        <Columns>
				        <asp:BoundField DataField="Seccion_des" HeaderText="Descripci&#243;n"></asp:BoundField>
				        <asp:TemplateField headertext="Acciones">
					        <ItemTemplate>
						        <asp:ImageButton id="imgEditar" runat="server" ToolTip="Editar" ImageUrl="../images/editar.gif"
							        CommandName="Editar" commandargument='<%# Eval("ID_Seccion") %>'>
						        </asp:ImageButton>&nbsp;
						        <asp:ImageButton id="imbDelete" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
							        CommandName="Borrar" onclientclick="return confirm('Estas seguro de eliminar esta sección?')" commandargument='<%# Eval("ID_Seccion") %>'>
						        </asp:ImageButton>&nbsp;
					        </ItemTemplate>
				        </asp:TemplateField>
			        </Columns>
		        </asp:gridview>
	        </asp:panel>
	        <asp:panel id="pnlDetalle" Runat="server" Visible="False">
	            <fieldset style="width: 350px">
	                <legend>
	                    <asp:label id="lblCrearModificar" runat="server" text="Crear/Modificar Sección"></asp:label>
	                </legend>
                    <div style="height: 8px;"></div>	                
		            <table class="td-content" id="Table2" cellspacing="1" cellpadding="1" width="350" border="0">
			            <tr>
				            <td class="error" colspan="4" style="height: 6px"></td>
			            </tr>
			            <tr>
				            <td align="right">Descripción&nbsp;</td>
				            <td class="labelData" colspan="3">
					            <asp:TextBox id="txtDescripcion" runat="server" Width="270px" causesvalidation="True"></asp:TextBox>
                                <asp:requiredfieldvalidator id="reqFieldURL" runat="server" controltovalidate="txtDescripcion"
                                    cssclass="error" display="Dynamic"
                                    setfocusonerror="True">Debes indicar el nombre de la sección</asp:requiredfieldvalidator></td>
			            </tr>
			            <tr>
				            <td colspan="4"></td>
			            </tr>
			            <tr>
				            <td colspan="4">
					            <hr style="height:1px; width:100%" />
				            </td>
			            </tr>
			            <tr>
				            <td class="error" valign="top" align="left" style="width:50%;" colspan="3">
					            <asp:Label id="lblMensajeDeError" runat="server" Visible="False" EnableViewState="False"></asp:Label><br />
				            </td>
				            <td align="right" style="width:50%;">
					            <asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>&nbsp;
					            <asp:button id="btnCancelar" runat="server" Text="Cancelar" causesvalidation="False"></asp:button>&nbsp; 
					            &nbsp;<br />
				            </td>
			            </tr>
		            </table>
	            </fieldset>
	        </asp:panel>
        </contenttemplate>
        <triggers>
            <asp:asyncpostbacktrigger controlid="btnNuevaSeccion" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnAceptar" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnCancelar" eventname="Click" />
        </triggers>
    </asp:updatepanel>
</asp:Content>