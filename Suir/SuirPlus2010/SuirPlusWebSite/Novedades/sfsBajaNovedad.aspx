<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsBajaNovedad.aspx.vb" Inherits="Novedades_sfsBajaNovedad" title="Baja Novedades SFS" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc1" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />

    <br />
    <div class="header">
        Baja De Novedades
    </div><br />
    <div style="text-align:left" class="labelData">
       Importante: Al elegir darle de baja a esta novedad, está eliminando información delicada para la empresa.
    </div>  <br />  
    <div ID="divMadre" runat="server" visible="false">
       <table cellspacing="0" cellpadding="0">
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
            <asp:Label ID="lblMensaje" runat="server" Text="" Visible="false" CssClass="error"></asp:Label>
            <br />
            <br />
            <table id="Table1" cellpadding="0" cellspacing="0" border="0" width="500px">
                <tr>
                    <td>
                    <asp:Panel ID="pnlEmbarazo" runat="server" visible="false">
                            <table id="table3" cellspacing="1" cellpadding="1" border="0">
						        <tr>
							        <td class="subHeader" colspan="2">Datos del Embarazo</td>
						        </tr>
						        <tr>
                                    <td align="left">
                                        Fecha Registro</td>
                                    <td align="left">
                                        <asp:Label ID="lblFechaRegistroEmbarazo" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
						        <tr>
							        <td align="left">
                                        Fecha de Diagnóstico</td>
							        <td align="left">
								        <asp:Label id="lblFechaDiagnostico" runat="server" CssClass="labelData"></asp:Label></td>
						        </tr>						
        						
						        <tr>
							        <td align="left">
                                        Fecha Estimada de Parto</td>
							        <td align="left">
								        <asp:Label id="lblFechaEstimadaParto" runat="server" CssClass="labelData"></asp:Label></td>
						        </tr>
						        <tr>
                                    <td align="left">
                                        Empresa que Reportó Embarazo</td>
                                    <td align="left">
                                        <asp:Label ID="lblRazonSocialEmbarazo" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        &nbsp;</td>
                                </tr>
					        </table>
                        </asp:Panel>
                    </td>
                </tr>
                
                 <tr>
                    <td>
                    <asp:Panel ID="pnlLicencia" runat="server" Visible="false">
                              <table id="table2" cellspacing="1" cellpadding="1" border="0">
						        <tr>
							        <td class="subHeader" colspan="2">Datos de la Licencia</td>
						        </tr>
						        <tr>
                                    <td align="left">
                                        Fecha Registro</td>
                                    <td align="left">
                                        <asp:Label ID="lblFechaRegistroLicencia" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
						          <tr>
                                      <td align="left">
                                          Fecha de Licencia</td>
                                      <td align="left">
                                          <asp:Label ID="lblFechaLicencia" runat="server" CssClass="labelData" 
                                              style="font-weight: 700" ></asp:Label>
                                      </td>
                                  </tr>
						        <tr>
							        <td align="left">
                                        Empresa que Reportó Licencia</td>
							        <td align="left">
								        <asp:Label id="lblRazonSocialLicencia" runat="server" 
                                            CssClass="labelData"></asp:Label></td>
						        </tr>						
        						
						        <tr>
							        <td colspan="2">
                                        &nbsp;</td>
						        </tr>
					        </table>
				        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td>
                    <asp:Panel ID="pnlNacimiento" runat="server" Visible="false">
                            <table id="table4" cellspacing="1" cellpadding="1"  border="0">
						        <tr>
							        <td class="subHeader">Datos de los Lactantes<br />
                                    </td>
						        </tr>
						        <tr>
							        <td>
                                        <asp:GridView ID="gvNacimientoLactantes" runat="server" AutoGenerateColumns="False" 
                                            
                                            DataKeyNames="SECUENCIA_LACTANTE,ID_NSS_LACTANTE,NOMBRELACTANTE,FECHA_NACIMIENTO">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Secuencia">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblSecuencia" runat="server" Text='<%# Bind("SECUENCIA_LACTANTE") %>'></asp:Label>
                                                    </ItemTemplate>                                                    
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                               
                                                <asp:BoundField DataField="SECUENCIA_LACTANTE" HeaderText="Secuencia">
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="NOMBRELACTANTE" HeaderText="Nombre" 
                                                    ItemStyle-HorizontalAlign="Center">
                                                    <HeaderStyle HorizontalAlign="Left" />
                                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="FECHA_NACIMIENTO" DataFormatString="{0:dd/MM/yyyy}" 
                                                    HeaderText="Fecha Nacimiento">
                                                    <HeaderStyle Wrap="False" />
                                                    <ItemStyle HorizontalAlign="Right" />
                                                </asp:BoundField>
                                                <asp:TemplateField>
                                                    <ItemStyle HorizontalAlign="Center" />
                                                    <ItemTemplate>
                                                        <asp:CheckBox ID="cbNacimiento" runat="server" Checked="false" />
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                               
                                            </Columns>
                                        </asp:GridView>
                                    </td>
						        </tr>
					        </table>
                        </asp:Panel>
                    </td>
                </tr>
                  <tr>
                    <td>
                    <asp:Panel ID="pnlPerdidaEmbarazo" runat="server" Visible="false">
                              <table id="table5" cellspacing="1" cellpadding="1" border="0">
						        <tr>
							        <td class="subHeader" colspan="2">Datos de la Pérdida de Embarazo</td>
						        </tr>
						        <tr>
                                    <td align="left">
                                        Fecha Registro</td>
                                    <td align="left">
                                        <asp:Label ID="lblFechaRegistroPerdida" runat="server" CssClass="labelData" ></asp:Label>
                                    </td>
                                </tr>
						          <tr>
                                      <td align="left">
                                          Fecha de Pérdida Embarazo</td>
                                      <td align="left">
                                          <asp:Label ID="lblFechaPerdidaEmbarazo" runat="server" CssClass="labelData" ></asp:Label>
                                      </td>
                                  </tr>
						        <tr>
							        <td align="left">
                                        Empresa que Reportó Pérdida</td>
							        <td align="left">
								        <asp:Label id="lblRazonSocialPerdida" runat="server" CssClass="labelData" ></asp:Label></td>
						        </tr>						
        						
						        <tr>
							        <td colspan="2">
                                        &nbsp;</td>
						        </tr>
					        </table>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td>
                    <asp:Panel ID="pnlMuerteLactante" runat="server" Visible="false">
                            <table id="table6" cellspacing="1" cellpadding="1" border="0">
                                <tr>
							        <td class="subHeader">Datos de Defunción de Lactante<br />
                                    </td>
						        </tr>
						        <tr>
							        <td>
                                        <asp:GridView ID="gvMuerteLactantes" runat="server" AutoGenerateColumns="False" 
                                    DataKeyNames="SECUENCIA_LACTANTE,ID_NSS_LACTANTE,NOMBRELACTANTE,FECHA_NACIMIENTO">
                                    <Columns>
                                        <asp:TemplateField HeaderText="Secuencia">
                                            <ItemTemplate>
                                                <asp:Label ID="lblSecuencia" runat="server" Text='<%# Bind("SECUENCIA_LACTANTE") %>'></asp:Label>
                                            </ItemTemplate>
                                            
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>
                                        <asp:BoundField DataField="SECUENCIA_LACTANTE" HeaderText="Secuencia">
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="NOMBRELACTANTE" HeaderText="Nombre" 
                                            ItemStyle-HorizontalAlign="Center">
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="FECHA_NACIMIENTO" DataFormatString="{0:dd/MM/yyyy}" 
                                            HeaderText="Fecha Nacimiento" >
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        <asp:BoundField HeaderText="Fecha Defunción " 
                                            DataField="FECHA_DEFUNCION" DataFormatString="{0:dd/MM/yyyy}" >
                                            <HeaderStyle Wrap="False" />
                                            <ItemStyle HorizontalAlign="Right" />
                                        </asp:BoundField>
                                        
                                        <asp:TemplateField>
                                            <ItemStyle HorizontalAlign="Center" />
                                            <ItemTemplate> 
                                                <asp:CheckBox ID="cbLactante" Checked="false" runat="server" /> 
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                                    </td>
						        </tr>

					        </table>
                        </asp:Panel>
                    </td>
                </tr> 
                <tr>
                    <td>
                    <asp:Panel ID="pnlMuerteMadre" runat="server" Visible="false">
                            <table id="table7" cellspacing="1" cellpadding="1" border="0">
						        <tr>
							        <td class="subHeader" colspan="2">Datos de Defunción de la Madre</td>
						        </tr>
						        <tr>
							        <td align="left">Fecha Registro</td>
							        <td align="left">
                                        <asp:Label ID="lblFechaRegistroMuerte" runat="server" CssClass="labelData" ></asp:Label>
                                    </td>
						        </tr>
						        <tr>
                                    <td align="left">
                                        Fecha de defunción</td>
                                    <td align="left">
                                        <asp:Label ID="lblFechaMuerteMadre" runat="server" CssClass="labelData" ></asp:Label>
                                    </td>
                                </tr>
						          <tr>
                                      <td align="left">
                                          Empresa que Reportó Muerte</td>
                                      <td align="left">
                                          <asp:Label ID="lblRazonSocialMuerte" runat="server" CssClass="labelData"></asp:Label>
                                      </td>
                                  </tr>
						        <tr>
							        <td colspan="2">
                                        &nbsp;</td>
						        </tr>						
        						
					        </table>                
                        </asp:Panel>
                    </td>
                </tr> 
		        <tr>
			        <td>
                    <br />  
                        <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                        <br />  <br /> 
                    <div style="text-align:center">
                        <asp:Button ID="btnBajaNovedad" runat="server" Text="Dar de Baja"/>
                        <asp:Button ID="btnVolver" runat="server" Text="Volver atras"/>
                    </div>  			        
                    </td>
                </tr>                               
            </table>        
</br>
<fieldset runat="server" id="fiedlsetDatos1" style="width: 1024px" 
           visible="false">
<legend class="header" style="width: 150px"><span style="font-size: 14px">Aplicar novedades</span> 

    </legend>
    <asp:Button ID="btnAplicar" runat="server" ValidationGroup="n" style="margin-left: 360px; float: left " Text="Aplicar novedades" />
    <br />
    <br />
    <fieldset>
        <uc2:ucGridNovPendientes ID="ucGridNovPendientes1" runat="server" />
        </fieldset>
</fieldset>

</asp:Content>

