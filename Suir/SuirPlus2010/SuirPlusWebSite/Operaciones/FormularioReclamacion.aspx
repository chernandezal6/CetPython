<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="FormularioReclamacion.aspx.vb" Inherits="sys_FormularioReclamacion" %>

<%@ Register src="../Controles/UCTelefono.ascx" tagname="UCTelefono" tagprefix="uc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">

    function ValidateAcuerdo(e) {

        var carCode = (window.event) ? window.event.keyCode : e.which;

        if ((carCode < 48) || (carCode > 57)) {

            if (window.event) //IE       
                window.event.returnValue = null;
            else //Firefox       
                e.preventDefault();

        }

    }


    function modelesswin(url) {
        window.open(url, "", "width=800px,height=1300px").print();
    }

    $(function pageLoad(sender, args) {

        // Datepicker
        $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

        $("#ctl00_MainContent_txtFechaDesde").datepicker($.datepicker.regional['es']);
        $("#ctl00_MainContent_txtFechaHasta").datepicker($.datepicker.regional['es']);

    });
    </script>

 
</script>

<span class="header">Formulario de Reclamación</span><br/><br/>
<fieldset runat="server" id="fsPrincipal" style="width:500px" >
<div>
    
		<br />
    
		<table cellspacing="0" cellpadding="0" width="450x">
			
			<tr>
				<td align="right">Tipo Reclamación:</td>
				<td>
                            <asp:DropDownList ID="ddlTipoReclamacion" runat="server" CssClass="dropDowns" 
                                AutoPostBack="True">
                                <asp:ListItem  value="0">--Seleccione--</asp:ListItem>                                                        
	                            </asp:DropDownList>
					</td>
			</tr>		
			<tr runat="server" id="trCertificaciones" visible="false">
				<td align="right"> Tipo de Certificación:</td>
				<td> <asp:DropDownList ID="ddlTipoCert" runat="server" CssClass="dropDowns" 
                        AutoPostBack="True">
                                            </asp:DropDownList></td>
			</tr>
				<tr runat="server" id="trRNC" visible="false">
				<td align="right">Rnc:</td>
				<td><asp:textbox id="txtRNC" runat="server" MaxLength="11" Width="88px" 
                        onKeyPress="ValidateAcuerdo(event)"></asp:textbox>
				    &nbsp;&nbsp;<asp:regularexpressionvalidator id="Regularexpressionvalidator2" runat="server" 
                        Display="Dynamic" ControlToValidate="txtRNC"
						ErrorMessage="*" ValidationExpression="^(\d{9})$">Rnc Inválida.</asp:regularexpressionvalidator></td>
			</tr>
			  <tr id="trCedula" runat="server" visible="false">
                                        <td align="right" valign="top">
                                            <asp:Label ID="lblcedulaValidar" runat="server" EnableViewState="False" Text="Cédula"></asp:Label></td>
                                        <td style="width: 282px; height: 19px">
                                            <asp:TextBox ID="txtCedula" runat="server" MaxLength="11"></asp:TextBox>
                                            &nbsp;
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="txtCedula"
                                                Display="Dynamic" ErrorMessage="*" ValidationExpression="^(\d{11})$">Cédula Inválida.</asp:RegularExpressionValidator></td>
                                    </tr>
			 <tr id="trFechaDesde" runat="server" visible="false">
                                        <td align="right">
                                            Desde</td>
                                        <td style="width: 282px">
                                            <asp:TextBox ID="txtFechaDesde" runat="server" Width="80px"></asp:TextBox>
                                                                                            
                                        </td>
                                    </tr>
                                    <tr id="trFechaHasta" runat="server" visible="false">
                                        <td align="right">
                                            Hasta</td>
                                        <td style="width: 282px">
                                            <asp:TextBox ID="txtFechaHasta" runat="server" Width="80px"></asp:TextBox>
                                           
                                      </td>
                                    </tr>
                                    <tr id="trBotones" runat="server" visible="false">                                       
                                        <td colspan="2" style="text-align:center">
                                            <asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>
				                            <asp:button id="btnCancelar" runat="server" Text="Cancelar" 
                        CausesValidation="False"></asp:button>
                                        </td>
                                    </tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
          </table>
    
</div>
</fieldset><br />
    <asp:Label ID="lblMensaje" runat="server" Visible="False" CssClass="error"></asp:Label>
    <asp:UpdatePanel ID="upInfoEmpleador" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

        <table id="table1" cellspacing="0" cellpadding="0" border="0" width="550px">
	<tr>
		<td>
		
		<asp:panel id="pnlInfo" Runat="server" Visible="false">  
		  <fieldset style="width:525px" >	                        
                <table cellspacing="2" runat="server" id="tblEmpleador" cellpadding="0" width="500px">
				    <tr>
                        <td align="right">
                            Razon Social:</td>
                        <td colspan="3">
                            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Telefono:</td>
                        <td>
                            <uc1:UCTelefono ID="UCTelefono1" runat="server" />
                        </td>
                        <td align="right">
                            Ext.:</td>
                        <td>
                            <asp:TextBox ID="txtExt" runat="server" Width="50px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Contacto:</td>
                        <td>
                            <asp:TextBox ID="txtContacto" runat="server" Width="200px"></asp:TextBox>
                        </td>
                        <td align="right">
                            Cargo:</td>
                        <td>
                            <asp:TextBox ID="txtCargo" runat="server" Width="200px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" valign="top">
                            Email:</td>
                        <td>
                            <asp:TextBox ID="txtEmail" runat="server" Width="200px"></asp:TextBox>
                            <br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" 
                                ControlToValidate="txtEmail" Display="Dynamic" 
                                ErrorMessage="Correo Electrónico Inválido" 
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                        </td>
                        <td align="right" valign="top">
                            Fax:</td>
                        <td valign="top">
                            <uc1:UCTelefono ID="UCFax" runat="server" />
                        </td>
                    </tr>
                    <tr>
                        <td align="right" nowrap="nowrap">
                            &nbsp;</td>
                        <td colspan="3">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                    </tr>
				</table>
				
				<TABLE id="tblCiudadano" runat="server" visible="false" cellSpacing="0" cellPadding="0" Width="100%" border="0">

						<TR vAlign="top">
							<TD width="12%">
								<DIV align="right">Nombre del individuo&nbsp;</DIV>
							</TD>
							<TD width="50%">
                                <asp:Label cssclass="labelData" id="lblNombre" runat="server"></asp:Label></TD>
						</TR>
						<TR><TD width="12%"></TD>
                            <td width="12%">
                            </td>
                        </TR>	
						<TR vAlign="top">
							<TD width="12%" >
								<DIV align="right">NSS&nbsp;
								</DIV>
							</TD>
							<TD width="50%" >
                                <asp:Label cssclass="labelData" id="lblNSS" runat="server"></asp:Label></TD>
						</TR>
						<TR><TD width="12%"></TD>
                            <td width="12%">
                            </td>
                        </TR>	
						
						<TR vAlign="top">
							<TD width="12%" >
								<DIV align="right">Cédula&nbsp;</DIV>
							</TD>
							<TD width="50%">
                                <asp:Label cssclass="labelData" id="lblCedulaCiudadano" runat="server"></asp:Label></TD>
						</TR>
						</TABLE>
				
				<asp:Panel ID="pnlCancelacionRef" runat="server" Visible="false">
                    <div>
                    <fieldset width="510px">				    
				    <table id="gvTable" cellspacing="2" cellpadding="0" width="500px">
				        <tr>
                            <td><strong>
                                <asp:Label ID="Label3" runat="server" CssClass="labelData">Recálculo/Cancelación Notificación de Pago</asp:Label>
                                <br />
                                </strong></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:GridView ID="gvNotificaciones" runat="server" AutoGenerateColumns="False" >
                                
                                    <Columns>
                                        <asp:BoundField DataField="id_referencia" HeaderText="Notificaciones de pago">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>
                                                                             
                                        <asp:TemplateField HeaderText="Seleccione la NP a Afectar">
                                          <ItemTemplate>
                                            <asp:CheckBox ID="cblCancelacion" runat="server"/>                                            
                                          </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>                                        
 
                                    </Columns>
                                
                                </asp:GridView>
                            </td>
                        </tr>
				    </table>
				    </fieldset>
				    </div>
				</asp:Panel>
				<asp:Panel ID="pnlBajaRNC" runat="server" Visible="false">
                    <div>
                    <fieldset width="510px">
 				        <table cellspacing="0" cellpadding="0" width="520px">
				        <tr>
					        <td valign="top">                       
		                        <table cellspacing="0" cellpadding="0" width="250px">
		                        <tr>
								<td align="center" colspan="2"><strong><asp:label id="Label1" runat="server" 
                                        CssClass="labelData">Rnc/Cédula con el que opera actualmente</asp:label>
                                    <br />
                                    <br />
                                    </strong>
							    </td>
							    </tr>
			                    <tr>
				                    <td align="left">Rnc/Cédula:</td>
				                    <td>&nbsp;<asp:textbox id="txtBajaRncAct" runat="server" MaxLength="11" 
                                            Width="88px" onKeyPress="ValidateAcuerdo(event)"></asp:textbox>
				                        &nbsp;<asp:button id="btnConsBaja1" runat="server" Text="Consultar" ValidationGroup="BajaRncAct"></asp:button>
					                    </td>
			                    </tr>
			                    <tr>
				                    <td align="left" valign="top" nowrap="nowrap">Razon Social:</td>
				                    <td>
                                        <asp:Label ID="lblRazonSocialActual" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
			                    </tr>
                                    <tr>
                                        <td align="left" colspan="2">
                                            <asp:RequiredFieldValidator ID="Requiredfieldvalidator2" runat="server" 
                                                ControlToValidate="txtBajaRncAct" Display="Dynamic" ErrorMessage="*" 
                                                ValidationGroup="BajaRncAct">Debe digitar un Rnc/Cédula</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="Regularexpressionvalidator1" runat="server" 
                                                ControlToValidate="txtBajaRncAct" Display="Dynamic" ErrorMessage="*" 
                                                ValidationExpression="^(\d{9}|\d{11})$" ValidationGroup="BajaRncAct">Rnc/Cédula Inválida.</asp:RegularExpressionValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" colspan="2">
                                            &nbsp;</td>
                                    </tr>
                              </table>
                             </td>
                             
                             <td valign="top">                             
                                <table cellspacing="0" cellpadding="0" width="250px">
                                <tr>
                                <td align="center" colspan="2"><strong><asp:label id="Label2" runat="server" 
                                        CssClass="labelData">Rnc/Cédula con el que no está operando</asp:label>
                                    <br />
                                    <br />
                                    </strong>
							    </td>
							    </tr>
			                    <tr>
				                    <td align="left">Rnc/Cédula:</td>
				                    <td>&nbsp;<asp:textbox id="txtBajaRncNoOpera" runat="server" MaxLength="11" 
                                            Width="88px" onKeyPress="ValidateAcuerdo(event)"></asp:textbox>
				                        &nbsp;<asp:button id="btnConsBaja2" runat="server" Text="Consultar" ValidationGroup="BajaRncNoOpera"></asp:button>
					                    </td>
			                    </tr>
			                    <tr>
				                    <td align="left" valign="top">Razon Social:</td>
				                    <td>
                                        <asp:Label ID="lblRazonSocialNoOpera" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
			                    </tr>
                                    <tr>
                                        <td colspan="2" align="left">
                                            <asp:RequiredFieldValidator ID="Requiredfieldvalidator3" runat="server" 
                                                ControlToValidate="txtBajaRncNoOpera" Display="Dynamic" ErrorMessage="*" ValidationGroup="BajaRncNoOpera">Debe digitar un Rnc/Cédula</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="Regularexpressionvalidator4" runat="server" 
                                                ControlToValidate="txtBajaRncNoOpera" Display="Dynamic" ErrorMessage="*" ValidationGroup="BajaRncNoOpera"
                                                ValidationExpression="^(\d{9}|\d{11})$">Rnc/Cédula Inválida.</asp:RegularExpressionValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right" colspan="2">
                                            &nbsp;</td>
                                    </tr>
                              </table>                             
                            </td>
                        </tr>
                        </table>
                    </fieldset>
                    </div>				    
				</asp:Panel>
						<asp:Panel ID="pnlNotPagadas" runat="server" Visible="false">
                    <div>
                    <fieldset width="510px">				    
				    <table id="Table2" cellspacing="2" cellpadding="0" width="500px">
				        <tr>
                            <td><strong>
                                <asp:Label ID="Label4" runat="server" CssClass="labelData">Notificaciones de Pagos Pagadas</asp:Label>
                                <br />
                                </strong></td>
                        </tr>
                        <tr>
                            <td>
                                <asp:GridView ID="gvNotPagadas" runat="server" AutoGenerateColumns="False" >
                                
                                    <Columns>
                                        <asp:BoundField DataField="id_referencia" HeaderText="Notificaciones de pago">
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:BoundField>                                        
                                        
                                        <asp:BoundField DataField="Status" HeaderText="Status" />
                                        <asp:BoundField DataField="periodo_factura" HeaderText="Periodo" />
                                        
                                        <asp:TemplateField HeaderText="N.P. a afectar">
                                          <ItemTemplate>
                                            <asp:CheckBox ID="chkAfectar"  runat="server"/>                                            
                                          </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>                                        
 
                                    </Columns>
                                
                                </asp:GridView>
                                 <asp:Panel ID="pnlNavigation" runat="server" Visible="False">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="&lt;&lt; Primera"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="&lt; Anterior"></asp:LinkButton>
                                &nbsp; Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>
                                ] de
                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                &nbsp;
                                <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="Próxima &gt;"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="Última &gt;&gt;"></asp:LinkButton>
                                &nbsp;
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Total de archivos&nbsp;
                                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                            </td>
                        </tr>
				    </table>
				    </fieldset>
				    </div>
				</asp:Panel>
	            <br />
		        <br />		
			<asp:Panel ID="pnlFirmas" runat="server" Visible="false">
				<table cellspacing="0" cellpadding="0" width="520px">
				<tr>
					<td>
                        <asp:Label ID="lblTituloMotivo" runat="server" CssClass="labelData">Explique brevemente el motivo de su solicitud</asp:Label>
                        <br />
                        <br />
                        <asp:TextBox ID="txtMotivo" runat="server" TextMode="MultiLine" Height="80px" 
                            Width="510px"></asp:TextBox>
					</td>
				</tr>
				
				</table>	
			
			    <br />
		        <br />
		        <br />			
	            <table cellspacing="0" cellpadding="0" width="520px">
				<tr>
					<td>
						<table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">

							<tr>
								<td align="center"><strong><asp:label id="lblSolicitante" runat="server" 
                                        CssClass="labelData">Solicitante</asp:label></strong>
							    </td>
							</tr>
							<tr>
								<td align="left" style="width:9">
								    <br />
								<asp:label id="lblFirma" runat="server">Firma:</asp:label>								
								    &nbsp; _______________________________________</td>
								
							</tr>
							 
							<tr>	
								<td align="left" style="width:9">
                                    <br />
                                    <asp:label id="lblCedula" runat="server" >Cédula:</asp:label>
								    _______________________________________</td>
								
							</tr>														
						</table>
					</td>
                    
                       
                            <td>
                            
						<table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">

							<tr>
								<td align="center"><strong><asp:label id="lblRepresentate" runat="server" 
                                        CssClass="labelData">Representante</asp:label>
							    </td>
							</tr>

							<tr>
								<td align="left" style="width:9">
								    <br />
								<asp:label id="lblFirmaRep" runat="server">Firma:</asp:label>								
								    &nbsp; _______________________________________</td>
								
							</tr>
							 
							<tr>	
								<td align="left" style="width:9">
                                    <br />
                                    <asp:label id="lblCedulaRep" runat="server" >Cédula:</asp:label>
								    _______________________________________</td>
								
							</tr>																
						</table>                            
 
                            </td>
                        </tr>
			</table>	
			
				<br />
		        <br />
		        <br />
				<table cellspacing="0" cellpadding="0" width="520px">
				
				    <tr>
                        <td style="text-align:right">
                            <asp:Button ID="btnGuardar" runat="server" Text="Guardar" />
                        </td>
                    </tr>
				
				</table>			
			</asp:Panel>			
			
				
				
			</fieldset></asp:panel>	
		

	    </td>
	</tr>
</table>

<asp:panel id="pnlFinal" runat="server" Visible="False" Width="100%">
                    
                   <TABLE id="Table4" cellSpacing="0" cellPadding="0" Width="520px" border="0">	
					<TR vAlign="top">
						<TD colSpan="2" style="height: 12px" width="12%">
							<div align="center">
                                <asp:Label ID="lblConfirmacion" runat="server" CssClass="subHeader" EnableViewState="False">La Reclamacion fue creada satisfactoriamente</asp:Label>&nbsp;<br />
                            </div>
						</TD>
					</TR>
					<TR><TD></TD>
                        <td style="height: 12px">
                        </td>
                    </TR>
					<TR vAlign="top">
						<TD>
							<DIV align="right">Número de Reclamacion&nbsp;</DIV>
						</TD>
						<TD width="50%">
							<asp:Label id="lblNoReclamacion" runat="server" cssclass="labelData"></asp:Label>&nbsp;
						</TD>
					</TR>
					<TR vAlign="top">
						<TD>
							<DIV align="right">Tipo de Reclamacion&nbsp;</DIV>
						</TD>
						<TD width="50%">
							<asp:Label cssclass="labelData" id="lblTipoReclamacion" runat="server"></asp:Label></TD>
					</TR>
					<TR><TD></TD>
                        <td>
                        </td>
                    </TR>
					</TABLE>
					
					<table id="Table10" cellSpacing="0" cellPadding="0" Width="520px" border="0" language="javascript" onclick="return Table10_onclick()">
					<TR>
						<TD width="100%">
							<HR SIZE="1" id="HR1" language="javascript" onclick="return HR1_onclick()" style="width: 100%">
						</TD>
					</TR>
					<TR>
						<TD vAlign="bottom" align="center"><INPUT id=btnVerCert 
                                onclick="javascript:modelesswin('VerReclamacion.aspx?NoRec=<%= NoReclamacion %>')" 
                                type=button value="Ver Reclamacion" class="Button">
							<asp:button id="btnNuevaCert" runat="server" Text="Nueva Reclamacion"></asp:button></TD>
					</TR>
				    </TABLE> 
         </asp:panel>


    </ContentTemplate>
    <Triggers > 
    <asp:PostBackTrigger ControlID="btnGuardar" />
    </Triggers>
    </asp:UpdatePanel>

</asp:Content>

