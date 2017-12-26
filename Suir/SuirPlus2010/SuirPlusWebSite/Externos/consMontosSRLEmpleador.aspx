<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consMontosSRLEmpleador.aspx.vb" Inherits="Externos_consMontosSRLEmpleador" title="Montos SRL-Empleador" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
					<div class="header">
						Consulta Montos SRL por&nbsp;Empleador
					</div>
					
					<div>
                        &nbsp;</div>
					
			<TABLE id="tblConsReferencia"	cellSpacing="1" cellPadding="1" width="429" align="left" border="0">

				<TR>
					
					<TD vAlign="top" style="width: 428px; height: 90px">
						<TABLE id="Table2" cellSpacing="0" cellPadding="0" align="left" border="0" style="width: 63%" class="td-content">
							<TR>
								<TD style="width: 70px">
                                    <br />
									<asp:label id="Label1" runat="server">RNC o Cédula</asp:label>&nbsp;
								</TD>
								<TD>
                                    <br />
                                    <asp:textbox id="txtRNC" runat="server" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" ErrorMessage="*" ControlToValidate="txtRNC" Display="Dynamic"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="regExpRncCedula" runat="server" CssClass="error" ErrorMessage="RNC o Cédula invalido."
										ControlToValidate="txtRNC" ValidationExpression="^(\d{9}|\d{11})$" Display="Dynamic"></asp:regularexpressionvalidator></TD>
							</TR>
							<TR>
								<TD style="width: 70px; height: 33px;">
									<asp:label id="Label2" runat="server">Periodo</asp:label>&nbsp;
								</TD>
								<TD style="height: 33px"><asp:textbox id="txtPeriodo" runat="server" MaxLength="6"></asp:textbox>&nbsp; 
									Ej. 200304<asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ErrorMessage="*" ControlToValidate="txtPeriodo" Display="Dynamic"></asp:requiredfieldvalidator><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" CssClass="error" ErrorMessage="Período nválido"
										ControlToValidate="txtPeriodo" ValidationExpression="\d{6}" Display="Dynamic"></asp:regularexpressionvalidator></TD>
							</TR>
							<TR>
								<TD align="center" colspan="2">
									<asp:button id="btBuscar" runat="server" Text="Buscar"></asp:button>&nbsp;
										<asp:button id="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False"></asp:button>&nbsp;
                                    <br />
									
								</TD>
							</TR>
						</TABLE>
						<asp:label id="lblMsg" runat="server" CssClass="error"></asp:label></TD>
					</TR>
					
					<tr>
                    <td style="width: 428px">
                        <br />
						<TABLE id="Table3" cellSpacing="1" cellPadding="1" width="100%" border="0">
                            <tr>
                                <td style="width: 85px">
                                </td>
                                <td>
                                </td>
                            </tr>
							<TR>
								<TD style="WIDTH: 85px"><asp:label id="lblRS" runat="server">Razón Social</asp:label></TD>
								<TD><asp:label id="lblRazonSocial" runat="server" Font-Bold="True" CssClass="labelData"></asp:label></TD>
							</TR>
							<TR>
								<TD style="WIDTH: 85px"><asp:label id="lblNC" runat="server">Nombre Comercial</asp:label></TD>
								<TD><asp:label id="lblNombreComercial" runat="server" Font-Bold="True" CssClass="labelData"></asp:label></TD>
							</TR>
                            <tr>
                                <td style="width: 85px">
                                </td>
                                <td>
                                </td>
                            </tr>
						</TABLE>
						<asp:GridView id="gvNotificaciones" runat="server" CssClass="list" Width="100%" AutoGenerateColumns="False"
							HorizontalAlign="Center">

							<Columns>
								<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia"></asp:BoundField>
								<asp:BoundField DataField="fecha_pago" HeaderText="Fecha Pago"></asp:BoundField>
								<asp:TemplateField HeaderText="Recargo SRL">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
									<ItemTemplate>
										<%# formatnumber(DataBinder.Eval(Container, "DataItem.TOTAL_RECARGO_SRL")) %>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Proporcion ARL SRL">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
									<ItemTemplate>
										<%# formatnumber(DataBinder.Eval(Container, "DataItem.TOTAL_PROPORCION_ARL_SRL")) %>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Operacion SISALRIL SRL">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
									<ItemTemplate>
										<%# formatnumber(DataBinder.Eval(Container, "DataItem.TOTAL_OPERACION_SISALRIL_SRL")) %>
									</ItemTemplate>
								</asp:TemplateField>
								<asp:TemplateField HeaderText="Aporte SRL">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
									<ItemTemplate>
										<%# formatnumber(DataBinder.Eval(Container, "DataItem.TOTAL_APORTE_SRL")) %>
									</ItemTemplate>
								</asp:TemplateField>
							</Columns>
						</asp:GridView>
					</TD>
				</TR>
			</TABLE>

</asp:Content>

