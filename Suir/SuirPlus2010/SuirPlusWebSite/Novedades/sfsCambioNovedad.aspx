<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsCambioNovedad.aspx.vb" Inherits="Novedades_sfsCambioNovedad" title="Modificar Novedad" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc2" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
 <script language="javascript" type="text/javascript">

     $(function pageLoad(sender, args) {
         // Datepicker dd
         $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
         $(".fecha").datepicker($.datepicker.regional['es']);
     });
    </script> 
    
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
   <ContentTemplate>
	<uc2:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <br />
    <div class="header">
        Modificar Novedad
    </div>
    <div ID="divMadre" runat="server" visible="false">
       <table cellspacing="0" cellpadding="0" width="93%">
		    <tr>
			    <td>
                    <br />
                    <br />
                    <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
                    <br />
			    </td>
		    </tr>
	    </table>
	</div>
    <br />
    <table style="width: 620px;">
        <tr>
            <td>
                <asp:Panel ID="pnlEmbarazo" runat="server">
                    <table id="table3" cellspacing="1" cellpadding="1" width="620" border="0">
						<tr>
							<td class="subHeader" colspan="3">Datos del Embarazo</td>
						</tr>
						<tr>
							<td style="WIDTH: 286px; HEIGHT: 14px"></td>
							<td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;" valign="top">Datos Actuales<br />
                            </td>
							<td style="HEIGHT: 14px" valign="top">&nbsp;<span style="color: #ff0000">Datos Nuevos<br />
                                </span></td>
						</tr>
						<tr>
                            <td style="WIDTH: 286px; color: #000000;" valign="middle">
                                Fecha de Diagnóstico</td>
                            <td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;">
                                <asp:Label ID="lblFechaDiagnostico" runat="server" 
                                    style="font-weight: 700; color: #FF0000;"></asp:Label>
                            </td>
                            <td style="WIDTH: 608px; HEIGHT: 14px">
                                <asp:TextBox ID="txtFechaDiagnostico" runat="server" CssClass="fecha" onkeypress="return false;"></asp:TextBox> 
                            </td>
                        </tr>
						<tr>
                            <td style="WIDTH: 286px; " valign="middle">
                                Fecha Estimada de Parto</td>
                            <td style="HEIGHT: 14px; text-align: left;" colspan="1">
                                <asp:Label ID="lblFechaEstimadaParto" runat="server" 
                                    style="font-weight: 700; color: #FF0000;"></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtFechaEstimadaParto" runat="server" CssClass="fecha" 
                                    onkeypress="return false;"></asp:TextBox>
                               
                            </td>
                        </tr>
						<tr style="color: #ff0000">
							<td style="WIDTH: 286px; color: #000000; height: 14px;">
                                Fecha Registro</td>
							<td style="WIDTH: 113px; color: #000000;" valign="middle" align="left">
								<asp:Label ID="lblFechaRegistroEmbarazo" runat="server"
                                    style="font-weight: 700"></asp:Label>
                            </td>
							<td style="WIDTH: 286px; HEIGHT: 14px">
                                &nbsp;</td>
						</tr>						
						
						<tr>
							<td style="WIDTH: 286px; height: 14px;">
                                Empresa que Reportó Embarazo</td>
							<td valign="middle" align="left" 
                                colspan="2">
								<asp:Label ID="lblRazonSocialEmbarazo" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
						</tr>
						<tr>
							<td colspan="3">
                                &nbsp;</td>
						</tr>
					</table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlLicencia" runat="server" Visible="false">
                      <table id="table1" cellspacing="1" cellpadding="1" width="620" border="0">
						<tr>
							<td class="subHeader" colspan="3">Datos de la Licencia</td>
						</tr>
						<tr>
							<td style="WIDTH: 286px; HEIGHT: 14px"></td>
							<td style="WIDTH: 122px; HEIGHT: 14px; text-align: left;" valign="top">Datos Actuales</td>
							<td style="HEIGHT: 14px; " valign="top">
                                &nbsp;<span style="color: #ff0000">Datos Nuevos<br />
                                </span></td>
						</tr>
						<tr>
                            <td style="WIDTH: 286px; color: #000000;" valign="middle">
                                Fecha de Licencia</td>
                            <td style="WIDTH: 122px; HEIGHT: 14px; text-align: left;">
                                <asp:Label ID="lblFechaLicencia" runat="server" 
                                    style="font-weight: 700; color: #FF0000;"></asp:Label>
                            </td>
                            <td style="HEIGHT: 14px; width: 608px;">
                                <asp:TextBox ID="txtFechaLicencia" runat="server" CssClass="fecha" onkeypress="return false;" ></asp:TextBox>
                              
                            </td>
                        </tr>
						  <tr>
                              <td style="WIDTH: 286px; HEIGHT: 14px">
                                  Fecha Registro</td>
                              <td style="WIDTH: 122px; HEIGHT: 14px; text-align: left;">
                                  <asp:Label ID="lblFechaRegistroLicencia" runat="server" 
                                      style="font-weight: 700"></asp:Label>
                              </td>
                              <td style="HEIGHT: 14px; width: 608px;">
                                  &nbsp;</td>
                          </tr>
						  <tr>
                              <td style="WIDTH: 286px; HEIGHT: 14px">
                                  Empresa que Reportó Licencia</td>
                              <td style="HEIGHT: 14px; text-align: left;" colspan="2">
                                  <asp:Label ID="lblRazonSocialLicencia" runat="server" style="font-weight: 700"></asp:Label>
                              </td>
                          </tr>
						
						<tr>
							<td style="WIDTH: 286px" valign="top">
                                &nbsp;</td>
							<td style="WIDTH: 122px; color: #ff0000;" valign="top" align="right">
								&nbsp;</td>
							<td style="width: 608px">
								&nbsp;</td>
						</tr>
					</table>
				</asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlNacimiento" runat="server" Visible="false">
                    <table id="table4" cellspacing="1" cellpadding="1" width="620" border="0">
						<tr>
							<td class="subHeader" colspan="4">Datos de los Lactantes<br />
                                <br />
                            </td>
						</tr>
						<tr>
							<td colspan="4">
                                <asp:GridView ID="gvNacimientoLactantes" runat="server" AutoGenerateColumns="False" 
                                    
                                    DataKeyNames="SECUENCIA_LACTANTE,ID_NSS_LACTANTE,NOMBRELACTANTE,FECHA_NACIMIENTO">
                                    <Columns>
                                        <asp:BoundField DataField="SECUENCIA_LACTANTE" HeaderText="Secuencia">
                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ID_NSS_LACTANTE" HeaderText="NSS" 
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="NOMBRELACTANTE" HeaderText="Nombre">
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="FECHA_NACIMIENTO" DataFormatString="{0:dd/MM/yyyy}" 
                                            HeaderText="Fecha Nacimiento Actual" >
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Fecha Nacimiento Nueva">
                                            <ItemTemplate>
                                                <asp:TextBox ID="tbFechaNacLact" runat="server" CssClass="fecha" onkeypress="return false;" 
                                                    Wrap="False" ></asp:TextBox>
                                                
                                                <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="tbFechaDefLact" ErrorMessage="*" ValidationGroup="Insertar"></asp:RequiredFieldValidator>--%>
                                               
                                            </ItemTemplate>
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
						</tr>
						<tr>
                            <td style="WIDTH: 286px; " valign="top">
                                &nbsp;</td>
                            <td style="WIDTH: 113px; color: #ff0000;" align="right" valign="top">
                                &nbsp;</td>
                            <td style="WIDTH: 7px; " align="right">
                                </td>
                            <td style="width: 608px;">
                                &nbsp;</td>
                        </tr>
					</table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlPerdidaEmbarazo" runat="server" Visible="false">
                      <table id="table5" cellspacing="1" cellpadding="1" width="620" border="0">
						<tr>
							<td class="subHeader" colspan="3">Datos de la Pérdida de Embarazo</td>
						</tr>
						<tr>
							<td style="WIDTH: 286px; HEIGHT: 14px"></td>
							<td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;" valign="top">Datos Actuales<br />
                            </td>
							<td style="HEIGHT: 14px; " valign="top">
                                &nbsp;<span style="color: #ff0000">Datos Nuevos<br />
                                </span></td>
						</tr>
						  <tr>
                              <td style="WIDTH: 286px; color: #000000;" valign="middle">
                                  Fecha de Pérdida Embarazo</td>
                              <td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;" valign="top">
                                  <asp:Label ID="lblFechaPerdidaEmbarazo" runat="server" 
                                      style="font-weight: 700; color: #FF0000;"></asp:Label>
                              </td>
                              <td style="HEIGHT: 14px; " valign="top">
                                  <asp:TextBox ID="txtFechaPerdidaEmbarazo" runat="server" CssClass="fecha"
                                      onkeypress="return false;" ></asp:TextBox>
                                  
                              </td>
                          </tr>
						<tr>
                            <td style="WIDTH: 286px; HEIGHT: 14px">
                                Fecha Registro</td>
                            <td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;">
                                <asp:Label ID="lblFechaRegistroPerdida" runat="server"  style="font-weight: 700"></asp:Label>
                            </td>
                            <td style="HEIGHT: 14px; width: 608px;">
                                &nbsp;</td>
                        </tr>
						  <tr>
                              <td style="WIDTH: 286px; HEIGHT: 14px">
                                  Empresa que Reportó Pérdida</td>
                              <td style="HEIGHT: 14px; text-align: left;" colspan="2">
                                  <asp:Label ID="lblRazonSocialPerdida" runat="server" style="font-weight: 700"></asp:Label>
                              </td>
                          </tr>
						
						<tr>
							<td style="WIDTH: 286px" valign="top">
                                &nbsp;</td>
							<td style="WIDTH: 113px; color: #ff0000;" valign="top" align="right">
								&nbsp;</td>
							<td style="width: 608px">
								&nbsp;</td>
						</tr>
					</table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlMuerteLactante" runat="server" Visible="false">
                    <table id="table6" cellspacing="1" cellpadding="1" width="620" border="0">
                        <tr>
							<td class="subHeader" colspan="4">Datos de Defunción de Lactante<br />
                                <br />
                            </td>
						</tr>
						<tr>
							<td colspan="4">
                                <asp:GridView ID="gvMuerteLactantes" runat="server" AutoGenerateColumns="False" 
                                    DataKeyNames="SECUENCIA_LACTANTE,ID_NSS_LACTANTE,NOMBRELACTANTE,FECHA_NACIMIENTO">
                                    <Columns>
                                        <asp:BoundField DataField="SECUENCIA_LACTANTE" HeaderText="Secuencia">
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="ID_NSS_LACTANTE" HeaderText="NSS" 
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="NOMBRELACTANTE" HeaderText="Nombre">
                                            <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                            <ItemStyle Wrap="False" HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="FECHA_NACIMIENTO" DataFormatString="{0:dd/MM/yyyy}" 
                                            HeaderText="Fecha Nacimiento" >
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Fecha Defunción Actual" 
                                            DataField="FECHA_DEFUNCION" DataFormatString="{0:dd/MM/yyyy}" >
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:TemplateField HeaderText="Fecha Defunción Nueva">
                                            <ItemTemplate>
                                                <asp:TextBox ID="tbFechaDefLact" runat="server" CssClass="fecha" onkeypress="return false;" 
                                                    Wrap="False" ></asp:TextBox>
                                           
                                                <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="tbFechaDefLact" ErrorMessage="*" ValidationGroup="Insertar"></asp:RequiredFieldValidator>--%>
                                            </ItemTemplate>
                                            <ItemStyle Wrap="False" HorizontalAlign="Right" />
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
						</tr>
						<tr>
                            <td style="WIDTH: 286px; " valign="top">
                                &nbsp;</td>
                            <td style="WIDTH: 113px; color: #ff0000;" align="right" valign="top">
                                &nbsp;</td>
                            <td style="WIDTH: 7px; " align="right">
                                </td>
                            <td style="width: 608px;">
                                &nbsp;</td>
                        </tr>
					</table>
                </asp:Panel>
            </td>
        </tr>    
        <tr>
            <td>
                <asp:Panel ID="pnlMuerteMadre" runat="server" Visible="false">
                    <table id="table7" cellspacing="1" cellpadding="1" width="620" border="0">
						<tr>
							<td class="subHeader" colspan="3">Datos de Defunción de la Madre</td>
						</tr>
						<tr>
							<td style="WIDTH: 286px; HEIGHT: 14px"></td>
							<td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;" valign="top">Datos Actuales</td>
							<td style="HEIGHT: 14px; " valign="top">
                                &nbsp;<span style="color: #ff0000">Datos Nuevos<br />
                                </span></td>
						</tr>
						<tr>
                            <td style="WIDTH: 286px; color: #000000;" valign="top">
                                Fecha de Muerte de la Madre</td>
                            <td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;" valign="top">
                                <asp:Label ID="lblFechaMuerteMadre" runat="server" 
                                    style="font-weight: 700; color: #FF0000;"></asp:Label>
                            </td>
                            <td style="HEIGHT: 14px; " valign="top">
                                <asp:TextBox ID="txtFechaMuerteMadre" runat="server" onkeypress="return false;" CssClass="fecha"></asp:TextBox>
                            </td>
                        </tr>
						<tr>
                            <td style="WIDTH: 286px; HEIGHT: 14px">
                                Fecha Registro</td>
                            <td style="WIDTH: 113px; HEIGHT: 14px; text-align: left;">
                                <asp:Label ID="lblFechaRegistroMuerte" runat="server" style="font-weight: 700"></asp:Label>
                            </td>
                            <td style="HEIGHT: 14px; width: 608px;">
                                &nbsp;</td>
                        </tr>
						  <tr>
                              <td style="WIDTH: 286px; HEIGHT: 14px">
                                  Empresa que Reportó Muerte</td>
                              <td style="HEIGHT: 14px; text-align: left;" colspan="2">
                                  <asp:Label ID="lblRazonSocialMuerte" runat="server" style="font-weight: 700"></asp:Label>
                              </td>
                          </tr>
						
						<tr>
							<td style="WIDTH: 286px" valign="top">
                                &nbsp;</td>
							<td style="WIDTH: 113px; color: #ff0000;" valign="top" align="right">
								&nbsp;</td>
							<td style="width: 608px">
								&nbsp;</td>
						</tr>
					</table>                
                </asp:Panel>
            </td>
        </tr>  
        <tr>
            <td>
             <asp:label id="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:label>
                <br />
            </td>
        </tr>         
        <tr>
            <td>
                <asp:Panel ID="pnlGeneral" runat="server" Visible="false">
                    <table id="table2" width="100%">
						<tr>
							<td valign="top" align="left" width="45%">&nbsp;</td>
							<td align="left" width="55%">
								<asp:button id="btnCambiar" runat="server" Text="Cambiar"></asp:button>&nbsp;
								<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button><br/>
							</td>
						</tr>
					</table>
                </asp:Panel>
            </td>
        </tr>                           
    </table>

    <fieldset  runat="server" id="fsNovedades" style="width: 1024px"  visible="False">
        <legend style="font-size: 14px">Aplicar Novedades</legend>
        <br />
        <asp:Button ID="btnAplicar" ValidationGroup="n" runat="server"  Text="Aplicar novedades" />
        <br />
        <br />
        <uc2:ucGridNovPendientes ID="ucGridNovPendientes1" runat="server" />
     </fieldset>
      </ContentTemplate>                     
</asp:UpdatePanel> 
</asp:Content>

