<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="AfiliadoArl.aspx.vb" Inherits="Externos_AfiliadoArl" title="Afiliados ARL - TSS" %>
<%@ Register TagPrefix="uc1" TagName="ucInfoEmpleado" Src="../Controles/ucInfoEmpleado.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="javascript">
			
			function modelesswin(url){
			    //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scroll:no;dialogWidth:460px;dialogHeight:460px");
			    newwindow = window.open(url, '', 'height=460px,width=460px');
			    //newwindow.print();
			/** if (document.all&&window.print) //if ie5
			eval('window.showModalDialog(url,"","help:0;status:0;toolbar:0;dialogWidth:'+mwidth+'px;dialogHeight:'+mheight+'px")')
			else
			eval('window.open(url,"","width='+mwidth+'px,height='+mheight+'px")') **/
			}

			//configure el URL y la dimension de la ventana (ancho/alto)
			//modelesswin("http://yahoo.com",600,600)

			//Para cargar via link, Use algo parecido a esto:
			//<a href="javascript:modelesswin('http://yahoo.com',600,400)">Click Aqui</a>
			
		</script>
		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		        'PermisoRequerido = 90
			End Sub
		</script>

			<table>
				<tr>
					<td class="header">Consulta Afiliados ARL</td>
				</tr>
				<tr>
					<td height="5"></td>
				</tr>
			</table>
			<TABLE class="td-content" id="Table1" cellSpacing="0" cellPadding="0">
				<tr>
					<td rowSpan="4"><IMG src="../images/deuda.jpg" width="220" height="89">
					</td>
					<td>
						<table>
							<tr>
								<td>Cédula o NSS:</td>
								<td><asp:textbox id="txtCedulaNSS" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic">*</asp:requiredfieldvalidator></td>
							</tr>
							<tr>
								<td align="center" colSpan="2"><asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
									<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colSpan="2"><asp:regularexpressionvalidator id="regExpRncCedula" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic"
										ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="NSS o Cédula invalido."></asp:regularexpressionvalidator></td>
							</tr>
						</table>
					</td>
				</tr>
			</TABLE>
			<br>
			<asp:label id="lblMsg" cssclass="error" EnableViewState="False" Runat="server"></asp:label>
			
			<asp:panel id="pnlConsulta" Runat="server" Visible="False" width="550px">
				<TABLE cellSpacing="0" cellPadding="0" width="100%">
					<TR>
						<TD>
                            <br />
							<uc1:ucInfoEmpleado id="UcEmpleado" runat="server"></uc1:ucInfoEmpleado>
                            <br />
						</TD>
					</TR>
				</TABLE>
				<BR>
				<TABLE cellSpacing="0" cellPadding="0" width="550">
					<TR>
						<TD class="consultaHeaderBlue">
                            <asp:Label ID="lblNominaAct" runat="server" CssClass="subHeader" EnableViewState="False" Visible="False">Empleador(es) donde está laborando el trabajador</asp:Label></TD>
					</TR>
					<TR>
						<TD>
							<asp:GridView id="gvAfiliacionActiva" runat="server" Width="100%" Visible="False" AutoGenerateColumns="False">

								<Columns>
									<asp:Boundfield Visible="False" DataField="id_registro_patronal"></asp:Boundfield>
									<asp:Boundfield DataField="rnc_o_cedula" HeaderText="RNC">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:Boundfield>
									<asp:Boundfield DataField="Razon_Social" HeaderText="Raz&#243;n Social">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle Wrap="False" />
                                    </asp:Boundfield>
									<asp:Boundfield Visible="False" DataField="ID_Nomina"></asp:Boundfield>
									
						          <asp:TemplateField HeaderText="N&#243;mina">
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    <ItemTemplate>
                                    <asp:Label id="lblRegistroPatronal" Runat="server" Visible="False" Text='<%# Eval("ID_Registro_Patronal") %>' />                            
                                    <asp:Label id="lblNomina" Runat="server" Visible="False" text='<%# Eval("id_nomina") %>' />
                                    
                                    <asp:HyperLink id="hlnkNomActivo" Runat="server"></asp:HyperLink>
                                    </ItemTemplate>                        
                                      <HeaderStyle HorizontalAlign="Left" />
                                  </asp:TemplateField>  

                       		     </Columns>
							  </asp:GridView>
							</TD>
					</TR>
					<TR>
						<TD class="consultaHeaderBlue"><asp:Label ID="lblNominaAnt"
                                runat="server" CssClass="subHeader" EnableViewState="False" Visible="False">Empleadore(s) donde estuvo laborando el trabajador</asp:Label></TD>
					</TR>
					<TR>
						<TD>
							<asp:GridView id="gvAfiliacionInctiva" runat="server" Width="100%" Visible="False" AutoGenerateColumns="False">

								<Columns>
									<asp:Boundfield Visible="False" DataField="id_registro_patronal"></asp:Boundfield>
									<asp:Boundfield DataField="rnc_o_cedula" HeaderText="RNC">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:Boundfield>
									<asp:Boundfield DataField="Razon_Social" HeaderText="Raz&#243;n Social">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle Wrap="False" />
                                    </asp:Boundfield>
									<asp:Boundfield Visible="False" DataField="ID_Nomina"></asp:Boundfield>
									
						          <asp:TemplateField HeaderText="N&#243;mina">
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    <ItemTemplate>
                                    <asp:Label id="lblRegistroPatronal" Runat="server" Visible="False" Text='<%# Eval("ID_Registro_Patronal") %>' />                            
                                    <asp:Label id="lblNomina" Runat="server" Visible="False" text='<%# Eval("id_nomina") %>' />
                                    <asp:HyperLink id="hlnkNomInactivo" Runat="server"></asp:HyperLink>
                                    </ItemTemplate>                        
                                      <HeaderStyle HorizontalAlign="Left" />
                                  </asp:TemplateField>  
								</Columns>
							</asp:GridView></TD>
					</TR>
				</TABLE>
            </asp:panel>
</asp:Content>

