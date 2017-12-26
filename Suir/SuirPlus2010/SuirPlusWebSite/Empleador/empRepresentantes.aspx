<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="empRepresentantes.aspx.vb" Inherits="Empleador_empRepresentantes" title="Representantes" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc3" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc2" %>

<%@ Register Src="../Controles/UCTelefono.ascx" TagName="UCTelefono" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

			<div class="header">Representantes
                <uc3:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
			</div>
			<asp:label id="lblMensajeDeError" runat="server" Visible="False" CssClass="error" EnableViewState="False"></asp:label><BR>
			<!-- Panel de listado --><asp:panel id="pnlListado" Runat="server">
				<asp:Button id="btnNuevoRep" runat="server" Text="Nuevo Representante"></asp:Button>
				<BR>
                <asp:GridView ID="dgRepresentantes" runat="server" AutoGenerateColumns=false>
                
                <Columns>
						<asp:BoundField DataField="nombre" HeaderText="Nombre"></asp:BoundField>
						<asp:BoundField DataField="NO_DOCUMENTO" HeaderText="Documento"></asp:BoundField>
						<asp:BoundField DataField="telefono_1" HeaderText="Tel&#233;fono"></asp:BoundField>
						<asp:BoundField DataField="email" HeaderText="E-mail"></asp:BoundField>
						<asp:TemplateField>
							<HeaderTemplate>
								Resetear CLASS
							</HeaderTemplate>
							<ItemTemplate>
								<center>
									<asp:ImageButton id="iBtnRecuperar" runat="server" ToolTip="Resetear CLASS" ImageUrl="../images/permisos.gif"
										CommandName="Recuperar" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.NO_DOCUMENTO") %>' BorderWidth="0px"></asp:ImageButton>
								</center>
							</ItemTemplate>
						</asp:TemplateField>
						<asp:TemplateField>
							<ItemTemplate>
								<asp:ImageButton id="iBtnEditar" runat="server" ToolTip="Editar" ImageUrl="../images/editar.gif"
									CommandName="Editar" BorderWidth="0px" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.NO_DOCUMENTO") %>'></asp:ImageButton>&nbsp;
								<asp:ImageButton id="iBtnBorrar" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
									CommandName="Borrar" BorderWidth="0px" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.id_nss") %>'></asp:ImageButton>&nbsp;
								<asp:Label id="lblID" runat="server" Visible="false" Text='<%# DataBinder.Eval(Container, "DataItem.id_nss") %>'></asp:Label>
							</ItemTemplate>
						</asp:TemplateField>
					</Columns>
                
                </asp:GridView>
			</asp:panel>
			<!-- Fin del panel de listado -->
				<asp:Panel id="pnlTmpRep" Runat="server">
					<TABLE class="td-note" width="520" border="0">
						<TR>
							<TD class="error" colSpan="2" style="text-align: center"><FONT color="blue">El Representante fue agregado 
									satisfactoriamente.</FONT>
                                <br />
							</TD>
						</TR>
						<TR>
							<TD style="text-align: right">Nombre del Representante
							</TD>
							<TD style="text-align: left;">
								<asp:Label id="lblTmpRepNombre" runat="server" Font-Bold="True"></asp:Label></TD>
						</TR>
						<TR>
							<TD style="text-align: right">CLASS
							</TD>
							<TD style="text-align: left">
								<asp:Label id="lblTmpRepClass" runat="server" Font-Bold="True"></asp:Label></TD>
						</TR>
                        <tr>
                            <td colspan="2" style="text-align: center">
                                <br />
                                <asp:Button ID="btnVolver" runat="server" Text="Volver" /></td>
                        </tr>
					</TABLE>
				</asp:Panel>
				
			<!-- Panel de detalle -->
			<asp:panel id="pnlDetalle" Visible="False" Runat="server"><!-- Panel temporal de representantes ingresados -->
				
				
				<TABLE class="td-content" cellSpacing="0" cellPadding="0" width="520" border="0">
					<TR>
						<TD class="error" align="left" colSpan="4" height="7"></TD>
					</TR>
					<TR>
						<TD class="subHeader" align="left" colSpan="4">Información General</TD>

					</TR>
					<TR>
						<TD class="error" align="left" colSpan="4" height="7">
                            <asp:label id="lblRepMsg" runat="server" EnableViewState="False" CssClass="error"></asp:label>

						</TD>
					</TR>

						<TR>
							<TD align="left" colSpan="4">	
                                <asp:Panel id="pnlNuevaInfoGeneral" Runat="server">				
                                <uc2:UCCiudadano ID="ucRepresentante" runat="server" />
                            </asp:Panel>				
							</TD>
						</TR>
						<tr>
						<td colSpan="4">
						<asp:Panel id="pnlInfoGeneral" Runat="server">
						<table>
                        <TR>
							<TD align="right">Nombre&nbsp;</TD>
							<TD class="labelData" colSpan="3">
								<asp:Label id="lblNombre" runat="server"></asp:Label></TD>
						</TR>
                        <TR>
							<TD align="right">Cédula&nbsp;</TD>
							<TD class="labelData" colSpan="3">
								<asp:Label id="lblCedula" runat="server"></asp:Label></TD>
						</TR>
						<TR>
							<TD align="right">NSS&nbsp;</TD>
							<TD class="labelData" colSpan="3">
								<asp:Label id="lblNss" runat="server"></asp:Label></TD>
						</TR>
					
						</table>
						</asp:Panel>
						</td>
						</tr>

					
					<TR>
						<TD colSpan="4" height="10"></TD>
					</TR>
					<TR>
						<TD class="subHeader" align="left" colSpan="4" style="height: 12px">Datos del Representante</TD>
					</TR>
					<TR>
						<TD colSpan="4" height="10"></TD>
					</TR>
					<TR>
						<TD align="center" colSpan="4"></TD>
					</TR>
					<TR>
						<TD align="right">Tipo de Representante&nbsp;</TD>
						<TD colSpan="3">
							<asp:DropDownList id="ddTipo" runat="server" CssClass="dropDowns">
								<asp:ListItem Value="N">Normal</asp:ListItem>
								<asp:ListItem Value="A">Administrador</asp:ListItem>
							</asp:DropDownList></TD>
					</TR>
					<TR>
						<TD align="right">Teléfono&nbsp; #1&nbsp;</TD>
						<TD colSpan="3">
                            <uc1:UCTelefono ID="ucRepTelefono1" runat="server" />
							<asp:Label id="Label2" runat="server" CssClass="error">*</asp:Label>ext.
							<asp:textbox id="txtRepExt1" runat="server" MaxLength="4" Width="48px"></asp:textbox></TD>
					</TR>
					<TR>
						<TD align="right">Teléfono&nbsp; #2&nbsp;</TD>
						<TD colSpan="3">
                            <uc1:UCTelefono ID="ucRepTelefono2" runat="server" />
                            ext.
							<asp:textbox id="txtRepExt2" runat="server" MaxLength="4" Width="48px"></asp:textbox></TD>
					</TR>
					<TR>
						<TD align="right">Email&nbsp;</TD>
						<TD colSpan="3">
<%--							<asp:textbox id="txtRepEmail" runat="server" MaxLength="50" Width="240px"></asp:textbox>
							<asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" CssClass="error" ControlToValidate="txtRepEmail"
								ErrorMessage="Formato Invalido" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:regularexpressionvalidator>--%>
                            <asp:textbox id="txtRepEmail" runat="server" MaxLength="50" Width="240px"></asp:textbox>
                            <br />
                            <asp:RequiredFieldValidator ID="reqFieldEmail" runat="server"
                                ControlToValidate="txtRepEmail" ErrorMessage="El Email es requerido" 
                                Display="Dynamic"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtRepEmail"
                                ErrorMessage="Correo electrónico Inválido." SetFocusOnError="True" 
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                                Display="Dynamic"></asp:RegularExpressionValidator>

                    </TD>

					</TR>
					<TR>
						<TD align="right"></TD>
						<TD colSpan="3">
							<asp:CheckBox id="chkboxNotificacionMail" runat="server" Text="  Deseo recibir notificación via e-mail" Checked="True"></asp:CheckBox></TD>
					</TR>
					<TR>
						<TD colSpan="4" height="10"></TD>
					</TR>
					<TR>
						<TD class="subHeader" align="left" colSpan="4" style="height: 14px">Nóminas Asignadas</TD>
					</TR>
					<TR>
						<TD colSpan="4" height="10"></TD>
					</TR>
					<TR>
						<TD colSpan="4" height="10">
                            <%--<asp:GridView ID="dgNominas" runat="server" AutoGenerateColumns=false>
                            
                          <Columns>
									<asp:TemplateField>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
										<ItemTemplate>
											<asp:CheckBox id="chbSelecciona" runat="server" BorderWidth="0px"></asp:CheckBox>
											<asp:Label id=lblID runat="server" Visible="False" Text='<%# DataBinder.Eval(Container, "DataItem.id_nomina") %>'>
											</asp:Label>
										</ItemTemplate>
									</asp:TemplateField>
									<asp:BoundField DataField="nomina_des" HeaderText="Descripci&#243;n"></asp:BoundField>
                                    <asp:BoundField DataField="tipo_des" HeaderText="Tipo"></asp:BoundField>                                    
									<%--<asp:TemplateField HeaderText="Tipo">
										<ItemTemplate>
											<asp:Label runat="server" Text='<%# getTipoNom(DataBinder.Eval(Container, "DataItem.tipo_nomina")) %>' ID="Label1">
											</asp:Label>
										</ItemTemplate>
									</asp:TemplateField>--%>
               <asp:panel id="Panel1" Runat="server" AutoGenerateColumns=false>
				<asp:Button id="Button1" runat="server" Text="Nueva Nómina"></asp:Button>
				
                <br />
                <asp:GridView ID="dgNominas" runat="server" AutoGenerateColumns="false">
                <Columns>	
                        <asp:TemplateField>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
										<ItemTemplate>
											<asp:CheckBox id="chbSelecciona" runat="server" BorderWidth="0px"></asp:CheckBox>	
                                            <asp:Label id=lblID runat="server" Visible="False" Text='<%# DataBinder.Eval(Container, "DataItem.id_nomina") %>'></asp:Label>									
										</ItemTemplate>
									</asp:TemplateField>					
						<asp:BoundField DataField="nomina_des" HeaderText="Descripci&#243;n"></asp:BoundField>
                        <asp:BoundField DataField="tipo_des" HeaderText="Tipo"></asp:BoundField>                                   
		
				</Columns>
            </asp:GridView>
			<BR>

			</asp:panel>
								
					</TR>
					<TR>
						<TD colSpan="4">
							<HR SIZE="1">
						</TD>
					</TR>
					<TR>
						<TD colSpan="4">
							<TABLE width="100%">
								<TR>
									<TD vAlign="top" align="left" width="80%"><FONT color="red">*</FONT> Información 
										obligatoria.</TD>
									<TD align="right" nowrap="nowrap">
										<asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>
										&nbsp;<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
										<BR>
									</TD>
								</TR>
							</TABLE>
						</TD>
					</TR>
				</TABLE>
			</asp:panel>

</asp:Content>

