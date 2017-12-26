<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsReporteMuerte.aspx.vb" Inherits="Novedades_sfsReporteMuerte" title="Reporte de muerte madre" %>
<%@ Register Src="../Controles/ucInfoEmpleado.ascx" TagName="ucInfoEmpleado" TagPrefix="uc1" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>

<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
$(function pageLoad(sender, args) {

         // Datepicker
        $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
        $(".fecha").datepicker($.datepicker.regional['es']);
    });
</script>

    <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    
            <fieldset style="width: 585px; margin-left: 60px">
                <legend class="header" style="font-size: 14px">Reporte de Muerte Madre</legend>
                <br />
               <table class="td-content" id="Table1" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
			                <tr>
				                <%--<td rowspan="4"><img src="../images/deuda.jpg" alt="" width="220" height="89" />
				                </td>--%>
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
                                <asp:regularexpressionvalidator id="regExpRncCedula" runat="server" 
                                  ControlToValidate="txtCedulaNSS" Display="Dynamic"
									                ValidationExpression="^[0-9]+$" ErrorMessage="NSS o Cédula invalido." 
                                  Font-Bold="True"></asp:regularexpressionvalidator></td>
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
            							
                                        <uc1:ucInfoEmpleado ID="UcEmpleado" runat="server" />
                                        <br />
					                </td>
				                </tr>
			                </table>
			                <br />
                        </div>
                        
                        

            <div class="td-content" id="fiedlsetDatos" runat="server" visible="false" style="width: 93%; margin-left: 17px">
            <br />
            <br />
            <span style="margin-left: 12px">Fecha de Defunción:</span>
                <asp:TextBox ID="txtFeLi" runat="server" CssClass="fecha" onkeypress="return false;" Wrap="False"></asp:TextBox> 
             
                   <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="Insertar" runat="server" ControlToValidate="txtFeLi" ErrorMessage="*">*</asp:RequiredFieldValidator>
                                <asp:ImageButton ID="img1" ImageUrl="~/App_Themes/SP/images/Calendar.png" runat="server" />
            <ajaxToolkit:CalendarExtender runat="server" ID="c1" TargetControlID="txtFeLi" 
                    CssClass="yui" Animated="true" Format="dd/MM/yyyy" PopupButtonID="img1" />--%>
            <br />
            <br />
            <div id="divMurioLactante" runat="server" visible="false" >
            <label style="margin-left: 12px; font-size: 12px; font-weight: bold" for="rblLactantes" >
                ¿Murió algún lactante?</label>
                <asp:RadioButtonList ID="rblLactantes" style="margin-left: 16px" runat="server" AutoPostBack="true"
                    RepeatDirection="Horizontal" Width="38px">
                    <asp:ListItem>Si</asp:ListItem>
                    <asp:ListItem Selected="True">No</asp:ListItem>
                </asp:RadioButtonList>
                <br />
                </div>
                <fieldset id="fieldGrid" runat="server" visible="false">
<legend style="font-size: 11px;  color:#016BA5">Seleccione de la lista el o los lactantes que fallecieron</legend>
<br />
                <asp:GridView ID="gvLactantes" runat="server" AutoGenerateColumns="False"
                    DataKeyNames="SECUENCIA_LACTANTE,ID_NSS_LACTANTE,NOMBRELACTANTE,FECHA_NACIMIENTO">
                    <Columns>
                        <asp:BoundField DataField="SECUENCIA_LACTANTE" 
                            HeaderText="Secuencia" >
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ID_NSS_LACTANTE" ItemStyle-HorizontalAlign="Center" 
                            HeaderText="NSS" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="NOMBRELACTANTE" HeaderText="Nombre" >
                            <ItemStyle Wrap="False" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FECHA_NACIMIENTO" HeaderText="Fecha Nacimiento" 
                           HtmlEncode="false" DataFormatString="{0:dd/MM/yyyy}" >
                            <HeaderStyle Wrap="False" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Fecha de Defunción">
                            <ItemTemplate>
                                <asp:TextBox ID="tbFechaDefLact" runat="server" CssClass="fecha" onkeypress="return false;" Wrap="False"></asp:TextBox>
                              
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="tbFechaDefLact" ErrorMessage="*" ValidationGroup="Insertar"></asp:RequiredFieldValidator>--%>
                               
                            </ItemTemplate>
                            <HeaderStyle Wrap="False" />
                            <ItemStyle Wrap="False" />
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Murio?">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkbLactante" runat="server" Checked="false" />
                            </ItemTemplate>

<ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                </fieldset>
            <br />    
                <asp:Button ID="btnSubmit" 
                    style="margin-left: 385px; width: 90px; height: 19px;" 
                    ValidationGroup="Insertar" runat="server" Text="Insertar" />
                <asp:Button ID="btnCancelar1" style="margin-left: 10px; width: 90px" 
                    runat="server" Text="Cancelar" Visible="False" />
                
                
                <br />
                <br />
            </div>

            <br />
                <div style="margin-left: 16px;">
                <span id="errorSexo" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>
                <span id="errorSta" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>	
                <span id="errorG" runat="server" style="margin-left: 1px;" class="error" visible="false"></span>
                </div>
            </fieldset>
            <br />
            <br />
            
            <fieldset runat="server" id="fiedlsetDatos1" 
                   style="width: 1024px;" visible="false">
            <legend class="header" style="font-size: 14px"><span style="font-size: 14px">Aplicar novedades</span> 

                </legend>
                <asp:Button ID="btnAplicar" runat="server" ValidationGroup="n" style="margin-left: 360px; float: left " Text="Aplicar novedades" />
                <br />
                <br />
            <fieldset>
                <uc2:ucGridNovPendientes ID="ucGridNovPendientes" runat="server" />
            </fieldset>
        </fieldset>         
 
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Procesando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

