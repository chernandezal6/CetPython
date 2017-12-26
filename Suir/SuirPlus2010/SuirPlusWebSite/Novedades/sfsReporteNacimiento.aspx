<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsReporteNacimiento.aspx.vb" Inherits="Novedades_sfsReporteNacimiento" title="Reporte de Nacimiento" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script language="javascript" type="text/javascript">
	
            
            $(function pageLoad(sender, args) {

                // Datepicker
                $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
                $(".fecha").datepicker($.datepicker.regional['es']);
            });
 </script>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <fieldset style="width: 585px; margin-left: 60px">
            <legend class="header" style="font-size: 14px">Reporte de Nacimiento</legend>
            <br />
            <table class="td-content" id="Table1" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
				<tr>
					<td>
					<br />
					<span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Afiliada</span>
						<table style="margin-left: 60px">
							<tr>
							    
							    
								<td>Cédula o NSS:</td>
								<td><asp:textbox id="txtCedulaNSS" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic">*</asp:requiredfieldvalidator></td>
								<td align="right"><asp:button id="btnConsultar" runat="server" Text="Buscar"></asp:button>
									<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2">
                                    <asp:RegularExpressionValidator ID="regExpRncCedula0" runat="server" 
                                        ControlToValidate="txtCedulaNSS" Display="Dynamic" 
                                        ErrorMessage="NSS o Cédula inválida." Font-Bold="True" 
                                        ValidationExpression="^[0-9]+$"></asp:RegularExpressionValidator>
                                </td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		    <br />
		    <asp:label id="lblMsg" cssclass="error" style="margin-left: 17px" EnableViewState="False" Runat="server"></asp:label>
		    <div id="divConsulta" visible="false" runat="server">
                <table cellspacing="0" cellpadding="0" style="margin-left: 17px" width="93%">
					    <tr>
						    <td>
                                <br />
    							
                                <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
    							
                                <br />
						    </td>
					    </tr>
				    </table>
			    <br />
            </div>
            <div class="td-content" id="fiedlsetDatos" runat="server" visible="false" style="width: 543px; margin-left: 17px">
                <br />
                <span style="margin-left: 18px">Fecha de Nacimiento:</span>
                <asp:TextBox ID="txtFeNac"  CssClass="fecha" onkeypress="return false;"
                    style="margin-left: 7px" runat="server" ></asp:TextBox>
                
                <br />
                <span style="margin-left: 00px">NSS Lactante (opcional):</span>
                <asp:TextBox ID="tbnssLactante" style="margin-left: 9px" runat="server" />
                <asp:requiredfieldvalidator id="RequiredFieldValidator3" runat="server" 
                    ControlToValidate="tbnssLactante" Display="Dynamic" ValidationGroup="Lactante">*</asp:requiredfieldvalidator>
                <asp:Button ID="btnLactante" style="margin-left:8px;" runat="server" Text="Buscar" ValidationGroup="Lactante" Width="90px" />
									    &nbsp;
                <br />
                <span style="margin-left: 00px">Cantidada de Lactantes :</span>&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:DropDownList ID="ddlLactantes" runat="server" CssClass="dropDowns">
                    <asp:ListItem>1</asp:ListItem>
                    <asp:ListItem>2</asp:ListItem>
                    <asp:ListItem>3</asp:ListItem>
                    <asp:ListItem>4</asp:ListItem>
                    <asp:ListItem>5</asp:ListItem>
                    <asp:ListItem>6</asp:ListItem>
                    <asp:ListItem>7</asp:ListItem>
                    <asp:ListItem>8</asp:ListItem>
                </asp:DropDownList>
                <br />
                <br />  
                <div id="dinfoLactante" runat="server" visible="false" style="text-align: left;">
                    <table>
                        <tr>
                            <td align="right"><span>Nombres:</span></td>
                            <td style="width: 120px">
                                <asp:TextBox ID="lblNombreLact" cssclass="labelData"  runat="server" /><asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
                                    ControlToValidate="lblNombreLact" Display="Dynamic" ValidationGroup="Guardar">*</asp:RequiredFieldValidator>
                            </td>
                            <td style="width: 91px">Primer<span> Apellido:</span></td>
                            <td>
                                <asp:TextBox ID="lblpApellidoLact" runat="server" cssclass="labelData">
                                </asp:TextBox>
                            </td>
                            <td>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
                                    ControlToValidate="lblpApellidoLact" Display="Dynamic" 
                                    ValidationGroup="Guardar">*</asp:RequiredFieldValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><span>Segundo Apellido:</span></td>
                            <td style="width: 120px">
                                <asp:TextBox ID="lblsApellidoLact" runat="server" cssclass="labelData" />
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
                                    ControlToValidate="lblNombreLact" Display="Dynamic" ValidationGroup="Guardar">*</asp:RequiredFieldValidator>
                            </td>
                            <td align="right" style="width: 91px"><span>NUI (opcional):</span></td>
                            <td>
                                <asp:TextBox ID="lblNUILact" runat="server" cssclass="labelData" onKeyPress="checkNum()" />
                            </td>
                            <td>
                                <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" 
                                    ControlToValidate="lblNUILact" CssClass="error" Display="Dynamic" 
                                    ErrorMessage="NUI inválido." ValidationExpression="\d{11}" 
                                    ValidationGroup="Guardar"></asp:RegularExpressionValidator>
                            </td>
                        </tr>
                        <tr>
                            <td align="right"><span>Sexo:</span></td>
                            <td style="width: 97px">
                                <asp:DropDownList  ID="ddlSexoLact" cssclass="labelData"  runat="server" >
                                    <asp:ListItem Value="M">Masculino</asp:ListItem>
                                    <asp:ListItem Value="F">Femenino</asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td align="right" style="width: 91px">&nbsp;</td>
                            <td align="left" colspan="2">
                                <br />
                                <asp:Button ID="btnInsertLact" runat="server" Text="Insertar" 
                                    ValidationGroup="Guardar" Width="68px" />
                                <asp:Button ID="btnCancelar0" runat="server" CausesValidation="False" 
                                    Text="Cancelar" />
                            </td>
                        </tr>
                    </table>
                </div>
                <br />
                <br />    
            </div>
                <br />
                <div id="divConfirmarNombre" runat="server" visible=false>
                <table ID="Table2" cellpadding="0" cellspacing="0" class="td-content" 
                    style="margin-left: 17px; width: 550px">
                    <tr>
                        <td>
                            <br />
                            <asp:Label ID="lblMsg0" Runat="server" cssclass="error" EnableViewState="False" 
                                style="margin-left: 17px">Nota: Ya existe un lactante 
                            registrado con este nombre</asp:Label>
                            &nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="btnContinuar" runat="server" Text="Continuar" Width="68px" />
                            <asp:Button ID="btnCancelar2" runat="server" Text="Cancelar" Width="68px" />
                            <br />
                        </td>
                    </tr>
                </table>
                </div>
                <br />
                <div ID="fiedlsetDatos1" runat="server" class="td-content" 
                    style="width: 543px; margin-left: 17px" visible="false">
                    <span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">
                    Lactantes :</span>
                    <br />
                    <br />
                    <asp:GridView ID="gvLactantes" runat="server" AutoGenerateColumns="False" 
                        EnableViewState="False" Width="539px">
                        <Columns>
                            <asp:BoundField DataField="NOMBRELACTANTE" HeaderText="Nombre" />
                            <asp:BoundField DataField="fecha_nacimiento" DataFormatString="{0:d}" 
                                HeaderText="Fecha Nacimiento">
                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="id_nss_lactante" HeaderText="NSS">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="sexo" HeaderText="Sexo">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                    <br />
                </div>
        </fieldset><br />
&nbsp;<uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
            <br />
            <fieldset  runat="server" id="fsNovedades"  
                style="width: 1024px"  visible="false">
                <legend class="header" style="font-size: 14px">Aplicar Novedades</legend>
                <asp:Button ID="btnAplicar" ValidationGroup="n" runat="server"  style="margin-left: 360px;" Text="Aplicar novedades" />
                <br />
                <br />
                <uc2:ucGridNovPendientes ID="ucGridNovPendientes1" runat="server" />
            </fieldset>
            <br />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>



