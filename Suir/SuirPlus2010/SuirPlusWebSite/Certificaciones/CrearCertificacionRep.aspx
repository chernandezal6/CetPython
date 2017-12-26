<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CrearCertificacionRep.aspx.vb" Inherits="Certificaciones_CrearCertificacionRep" title="Certificación - TSS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
				me.PermisoRequerido = 94
				
			End Sub
		</script>
		
		<script language="javascript" type="text/javascript">

			function modelesswin(url)
			{
			    //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px")
			    newwindow = window.open(url, '', 'height=1300px,width=800px,left=400,top=200');
			    newwindow.print();
			}	
			
			function test()
			{
			
			        try
			        {
			           showField(document.aspnetForm.ctl00$MainContent$drpTipoCert.value);
			        }
			        catch (e) 
			        {
			        }
			 
			   
			    
			}									
			
			function showField(campo)
			{
				document.getElementsByName('ctl00$MainContent$txtRnc').value = "";			
				document.getElementsByName('ctl00$MainContent$txtCedula').value = "";

				if(campo == '7' || campo == '3' || campo == 'A' || campo == 'B' || campo == '9'|| campo == '10')
				{	
				
					document.getElementById('trCedula').style.display = "";	
				    document.getElementById('trRnc').style.display = "none";
				}
				
				if(campo == '5' || campo == '6' || campo == '8' || campo== '4')
				{
					document.getElementById('trRnc').style.display = "";
					document.getElementById('trCedula').style.display = "none";
				}
				
				if(campo == '4')
				{
					document.getElementById('trFechaDesde').style.display = "";
					document.getElementById('trFechaHasta').style.display = "";
				}
				else
				{
					document.getElementById('trFechaDesde').style.display = "none";
					document.getElementById('trFechaHasta').style.display = "none";
				}
				
				if(campo == '2' || campo == 'C')
				{
					document.getElementById('trRnc').style.display = "";
					document.getElementById('trCedula').style.display = "";
				}
				
				if(campo == '12')
				{
					document.getElementById('trRnc').style.display = "";
					document.getElementById('trCedula').style.display = "none";
				}
				
			}
	
function Table10_onclick() {

}

function HR1_onclick() {
}


$(function() {

    // Datepicker
    $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

    $("#ctl00_MainContent_txtFechaDesde").datepicker($.datepicker.regional['es']);

    $("#ctl00_MainContent_txtFechaHasta").datepicker($.datepicker.regional['es']);

    

});

function btnVerCert_onclick() {

}

		</script>
		<div class="header" align="left">Creación de Certificación<br />
        </div>
        
        <div align="left"><asp:label cssClass="error" id="lblMsg" runat="server" 
                EnableViewState="False"></asp:label><br />
        &nbsp;</div>	
		<TABLE id="Tablegral" cellSpacing="0" cellPadding="0" width="550" border="0" class="td-content">
		<TR>
		<TD>
			<asp:panel id="pnlCreacion" Runat="server" Width="100%">
				<TABLE id="Table1" Width="100%" border="0">
					<TR>
						<TD>							
                                <div align="center" class="subHeader">Para crear una nueva certificación, elija el 
                                    tipo y complete los datos que le solicite el formulario.<br /> 
                                    <br />
                                    <br />
                                </div>
						
							<TABLE cellSpacing="0" cellPadding="0" Width="90%" border="0" align="center">
								<TR>
									<TD valign="top" align="right" nowrap="noWrap" style="width: 30%">Tipo de Certificación:</TD>
									<TD valign="top" style="height: 20px">
										&nbsp;<asp:dropdownlist cssclass="dropDowns" id="drpTipoCert" runat="server"></asp:dropdownlist>
                                        <br />
                                        <br />
                                    </TD>
								</TR>
										
											<TR id="trRnc">
												<TD align="right" valign="top" style="width: 30%">
                                                    <asp:Label ID="lblRNCValidar" runat="server" EnableViewState="False" Text="RNC"></asp:Label>
                                                    :<br /> &nbsp;</TD>
												<TD style="width: 282px; height: 19px;" valign="top">
                                                    &nbsp;<asp:TextBox ID="txtRnc" runat="server" MaxLength="11" Enabled="False"></asp:TextBox>
&nbsp;
													<br />
													<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" Display="Dynamic" ControlToValidate="txtRnc"
														ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="*">RNC o Cédula Inválida.</asp:RegularExpressionValidator>
                                                    <br />
                                                </TD>
											</TR>
											<TR id="trCedula">
												<TD align="right" valign="top" style="width: 30%">
                                                    <asp:Label ID="lblcedulaValidar" runat="server" EnableViewState="False" 
                                                        Text="Cédula:"></asp:Label>
                                                    <br />
                                                </TD>
												<TD style="width: 282px; height: 19px;" valign="top">
                                                    &nbsp;<asp:TextBox ID="txtCedula" runat="server" MaxLength="11"></asp:TextBox>
&nbsp;
													<br />
													<asp:RegularExpressionValidator id="RegularExpressionValidator2" runat="server" Display="Dynamic" ControlToValidate="txtCedula"
														ValidationExpression="^(\d{11})$" ErrorMessage="*">Cédula Inválida.</asp:RegularExpressionValidator>
                                                    <br />
                                                </TD>
											</TR>
	
											<TR id="trFechaDesde">
												<TD align="right" valign="top" style="width: 30%">Desde:<br /> &nbsp;</TD>
												<TD style="width: 282px" valign="top">
													&nbsp;<asp:TextBox id="txtFechaDesde" runat="server" Width="80px"></asp:TextBox>
                                                    <br />
                                                </TD>
											</TR>
											<TR id="trFechaHasta">
												<TD align="right" style="height: 17px; width: 30%;" valign="top">Hasta:<br /> &nbsp;</TD>
												<TD style="width: 282px; height: 17px;" valign="top">
													&nbsp;<asp:TextBox id="txtFechaHasta" runat="server" Width="80px"></asp:TextBox>                                                   
                                                    <br />
                                                </TD>
											</TR>
										

											<TR id="trFirma">
												<TD align="right" valign="top" style="width: 40%">Oficina - Firma Responsable:</TD>
											    <td valign="top">
                                                    &nbsp;<asp:DropDownList ID="dlFirmaResponsable" runat="server" CssClass="dropDowns">
                                                    </asp:DropDownList>
                                                    &nbsp;<br />
                                            </td>
											</TR>
											<TR>
												<TD colSpan="2" height="4">
													<br />
													</TD>
											</TR>
										<tr>
                                            <td align="center" colspan="2" style="height: 18px">
                                                <asp:Button ID="btnValidar" runat="server" Text="Validar" />
                                            </td>
                                </tr>
										</TABLE>
						            </TD>
					            </TR>
				             </TABLE>
			            </asp:panel>
			
		                   <asp:panel id="pnlConfirmacion" Runat="server" Visible="False" Width="100%">
                <DIV >
					<br />
					<asp:Label ID="lblTipoCert" runat="server" CssClass="subHeader"></asp:Label>                     
				</DIV>
					
     		</asp:panel>	
     		             <br />
     			           <asp:Panel id="pnlDatosEmpleador" Runat="server" Visible="false" Width="100%">

					<TABLE id="Table3" cellSpacing="0" cellPadding="0" Width="100%" border="0" language="javascript" onclick="return Table3_onclick()">
						<TR vAlign="top">
							<TD width="12%" valign="top">
								<DIV align="right">Razón Social: &nbsp;</DIV>
							</TD>
							<TD width="50%" valign="top">
                                <asp:Label cssclass="labelData" id="lblRazonSocial" runat="server"></asp:Label></TD>
						</TR>
						<TR><TD width="12%"></TD>
                            <td>
                            </td>
                        </TR>
						<TR vAlign="top">
							<TD width="12%" valign="top">
								<DIV align="right">RNC o Cédula: &nbsp;</DIV>
							</TD>
							<TD width="50%" valign="top">
                                <asp:Label cssclass="labelData" id="lblRncCedula" runat="server"></asp:Label>
                                <br />
                            </TD>
						</TR>
								
					</TABLE>
			    </asp:panel>
			
				           <asp:Panel id="pnlDatosCiudadanos" Runat="server" Visible="False" Width="100%">
					<TABLE id="Table5" cellSpacing="0" cellPadding="0" Width="100%" border="0">

						<TR vAlign="top">
							<TD width="12%" nowrap="nowrap" valign="top">
								<DIV align="right">Nombre: &nbsp;</DIV>
                                </TD>
							<TD width="50%" valign="top">
                                <asp:Label cssclass="labelData" id="lblNombre" runat="server"></asp:Label></TD>
						</TR>
						<TR><TD width="12%"></TD>
                            <td width="12%">
                            </td>
                        </TR>	
						<TR vAlign="top">
							<TD width="12%" valign="top" >
								<DIV align="right">NSS: &nbsp;</DIV>
							</TD>
							<TD width="50%" valign="top" >
                                <asp:Label cssclass="labelData" id="lblNSS" runat="server"></asp:Label></TD>
						</TR>
						<TR><TD width="12%"></TD>
                            <td width="12%">
                            </td>
                        </TR>	
						
						<TR vAlign="top">
							<TD width="12%" valign="top" >
								<DIV align="right">Cédula: &nbsp;</DIV>
							</TD>
							<TD width="50%" valign="top">
                                <asp:Label cssclass="labelData" id="lblCedula" runat="server"></asp:Label>
                                <br />
                            </TD>
						</TR>
						</TABLE>
				</asp:Panel>
					
				           <asp:Panel id="pnlFechas" Runat="server" Visible="False" Width="100%">
					<TABLE id="Table6" cellSpacing="0" cellPadding="0" width="100%" border="0">
						<TR vAlign="top">
							<TD width="12%" >
								<DIV align="right">Fecha desde: &nbsp;</DIV>
							</TD>
							<TD width="50%" valign="top">
                                <asp:label id="lblFechaDesde" runat="server" cssclass="labelData"></asp:label></TD>
						</TR>
						<TR><TD width="12%"></TD>
                            <td>
                            </td>
                        </TR>	
						<TR vAlign="top">
							<TD width="12%" valign="top" >
								<DIV align="right">Fecha hasta: &nbsp;</DIV>
							</TD>
							<TD width="50%" valign="top">
                                <asp:label id="lblFechaHasta" runat="server" cssclass="labelData"></asp:label></TD>
						</TR>
						</TABLE>
			   </asp:Panel>
			           <br />	
			               <asp:Panel id="pnlBotonCrear" Runat="server" Visible="False" EnableViewState="False" Width="100%">
				<TABLE id="Table7" cellSpacing="0" cellPadding="0" Width="100%" border="0">

					<TR align="left" valign="top">
						<TD align="right">&nbsp;</TD>					
					    <td width="78%">
                            &nbsp;</td>
					</TR>
									
				    <tr align="left" valign="top">
                        <td align="right" nowrap="nowrap" width="19%">
                            Documentos:&nbsp; </td>
                        <td width="71%">
                            &nbsp;<asp:FileUpload ID="flCargarImagenCert" runat="server" />
                            <br />
                        </td>
                    </tr>
                    <tr align="left" valign="top">
                        <td align="right" nowrap="nowrap">
                            &nbsp;</td>
                        <td width="78%">
                            &nbsp;</td>
                    </tr>
                    <tr align="left" valign="top">
                        <td align="right" nowrap="nowrap">
                            &nbsp;</td>
                        <td width="78%">
                            &nbsp;</td>
                    </tr>
									
				    <tr align="right" valign="top">
                        <td align="right" colspan="2">
                            <asp:Button ID="btnCrear" runat="server" Text="Crear Certificación" />
                            &nbsp;<asp:Button ID="btnVolver" runat="server" CssClass="Button" 
                                Text="Volver Atrás" />
                            <br />
                            &nbsp;
                        </td>
                    </tr>
									
				</TABLE>
			</asp:Panel>

				            <!-- Panel que muestra las observaciones que no son detallada -->
							<asp:Panel id="pnlObservacion" Runat="server" Visible="False" EnableViewState="False" Width="100%">
							    <p align="left">Observaciones:
								<asp:Label id="lblObservacion" runat="server" cssclass="LabelDataGreen"></asp:Label></p>
							</asp:Panel>
							
							<!--Panel que muesta la informacion del inicio de operaciones de un empleador.-->
							<asp:Panel id="pnlOperaciones" Runat="server" Visible="False" EnableViewState="False" Width="100%">
								<p align="right" style="text-align: right">Inicio de&nbsp;Operaciones:
									<asp:Label id="lblFechaInicioActividad" runat="server" cssclass="LabelDataGreen"></asp:Label></p>
							</asp:Panel>
							
							<!--Panel que muestra las facturas vencidas que tienen un empleador..-->
							<asp:Panel id="pnlFactVencidas" Runat="server" Visible="False" EnableViewState="False" Width="100%">
								<div class="LabelDataGreen" nowrap=nowrap>Facturas Vencidas</div>
								<asp:GridView id="gvFacturas" runat="server" Visible="False" AutoGenerateColumns="False" EnableViewState="False">
									<Columns>
										<asp:BoundField DataField="Periodo_Factura" HeaderText="Periodo">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="Fecha_Limite_Pago" HeaderText="Fecha L&#237;mite" DataFormatString="{0:d}" HtmlEncode="false" >
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="Total_General_Factura" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="false">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Right"></ItemStyle>
										</asp:BoundField>
									</Columns>
								</asp:GridView>
								<BR>
							</asp:Panel>
							
							<!--Panel que muestra las nominas activas que tiene un empleador..-->
							<asp:Panel id="pnlNominas" Runat="server" Visible="False" EnableViewState="False" Width="100%">
								<DIV><SPAN class="LabelDataGreen">Nóminas Registradas</SPAN>
									<asp:GridView id="gvNominas" runat="server" Visible="False" AutoGenerateColumns="False" EnableViewState="False">
										<Columns>
											<asp:BoundField DataField="ID_Nomina" HeaderText="ID">
												<ItemStyle HorizontalAlign="Center"></ItemStyle>
											</asp:BoundField>
											<asp:BoundField DataField="Nomina_des" HeaderText="N&#243;mina"></asp:BoundField>
											<asp:BoundField DataField="CANT_TRABAJADORES" HeaderText="Empleados">
												<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
												<ItemStyle HorizontalAlign="Center"></ItemStyle>
											</asp:BoundField>
											<asp:BoundField DataField="fecha_registro" HeaderText="Registro" DataFormatString="{0:d}" HtmlEncode="false">
												<ItemStyle HorizontalAlign="Center"></ItemStyle>
											</asp:BoundField>
										</Columns>
									</asp:GridView></DIV>
								<BR>
							</asp:Panel>
							
							<!--Panel que muesta el detalle de las nominas o facturan en la que esta un ciudadano que quiere realizar
								una certificacion de ultimo aporte.-->
							<asp:Panel id="pnlInfoUltimoAporte" Runat="server" Visible="False" EnableViewState="False" Width="100%">
								<asp:Label id="lblUltimoAporte" runat="server" CssClass="LabelDataGreen"></asp:Label>
								<asp:GridView id="gvUltimoAporte" runat="server" Visible="False" AutoGenerateColumns="False" EnableViewState="False">
									<Columns>
										<asp:BoundField DataField="RNC_O_CEDULA" HeaderText="RNC"></asp:BoundField>
										<asp:BoundField DataField="RAZON_SOCIAL" HeaderText="Raz&#243;n Social"></asp:BoundField>
									</Columns>
								</asp:GridView>
								<BR>
							</asp:Panel>
							
							<!--Panel que muesta la informacion de las facturas vigente o vencidas del periodo actual.-->
							<asp:Panel id="pnlFacturaPeriodoActual" Runat="server" Visible="False" EnableViewState="False" Width="100%">
								<div class="LabelDataGreen" nowrap=nowrap>
								    Empleador con facturas del perido actual.
								</div>
								<asp:GridView id="gvFacturaActual" runat="server"  Visible="False" AutoGenerateColumns="False" EnableViewState="False">
									<Columns>
										<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="nomina_des" HeaderText="N&#243;mina">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										</asp:BoundField>
										<asp:BoundField DataField="FECHA_LIMITE_PAGO" HeaderText="Fecha L&#237;mite" DataFormatString="{0:d}" HtmlEncode="false">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="TOTAL_GENERAL_FACTURA" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="false">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Right"></ItemStyle>
										</asp:BoundField>
									</Columns>
								</asp:GridView>
							<BR>
							</asp:Panel>
							
							<!-- Panel que muestra las operaciones registradas de un empleador comprendio entre un rango de periodos.   -->
							<asp:Panel id="pnlRegisroOperaciones" Runat="server" Visible="False" EnableViewState="False" Width="100%" >
								<div class="LabelDataGreen" nowrap=nowrap>
								    Este empleador muestra operaciones en los periodos especificado.
								</div>	
								<asp:GridView id="gvRegistroOperaciones" runat="server" Visible="False" AutoGenerateColumns="False" EnableViewState="False">
									<Columns>
										<asp:BoundField DataField="Periodo_Factura" HeaderText="Periodo">
											<HeaderStyle HorizontalAlign="Left"></HeaderStyle>
										</asp:BoundField>
										<asp:BoundField DataField="ID_Referencia" HeaderText="Referencia">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="Status" HeaderText="Estatus">
											<HeaderStyle HorizontalAlign="Left"></HeaderStyle>
										</asp:BoundField>
										<asp:BoundField DataField="Tipo_Factura" HeaderText="Origen">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Center"></ItemStyle>
										</asp:BoundField>
										<asp:BoundField DataField="Total_General_Factura" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="false">
											<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
											<ItemStyle HorizontalAlign="Right"></ItemStyle>
										</asp:BoundField>
									</Columns>
								</asp:GridView>
							</asp:Panel>
			
             <TABLE id="Table11" cellSpacing="0" cellPadding="0" width="100%" border="0">
			 <TR>
			 <TD>
	
		
			<asp:panel id="pnlFinal" Runat="Server" Visible="False" Width="100%">
                    
                   <TABLE id="Table4" cellSpacing="0" cellPadding="0" Width="100%" border="0">	
					<TR vAlign="top">
						<TD colSpan="2" style="height: 12px" width="12%">
							<div align="center">
                                <asp:Label ID="lblConfirmacion" runat="server" CssClass="subHeader" EnableViewState="False">La Certificación fue creada satisfactoriamente</asp:Label>&nbsp;<br />
                            </div>
						</TD>
					</TR>
					<TR><TD></TD>
                        <td style="height: 12px">
                        </td>
                    </TR>
					<TR vAlign="top">
						<TD>
							<DIV align="right">Número de Certificación:&nbsp;</DIV>
						</TD>
						<TD width="50%">
							<asp:Label id="lblNoCert" runat="server" cssclass="labelData"></asp:Label>&nbsp;
						    <br />
						    <br />
						</TD>
					</TR>
					<TR vAlign="top">
						<TD>
							<DIV align="right">Tipo de Certificación:&nbsp;</DIV>
						</TD>
						<TD width="50%">
							<asp:Label cssclass="labelData" id="lblTipoCert2" runat="server"></asp:Label>
                            <br />
                        </TD>
					</TR>
					<TR><TD></TD>
                        <td>
                        </td>
                    </TR>
					</TABLE>
					
					<asp:Panel id="pnlDatosEmpleador2" Runat="server" Visible="False" Width="100%" Wrap="False">
					<table id="Table9" cellSpacing="0" cellPadding="0" Width="100%" border="0">
					
						<TR vAlign="top">
							<TD style="height: 12px">
								<DIV align="right">Razón Socia:l&nbsp;</DIV>
							</TD>
							
							<TD width="50%" style="height: 12px">
								<asp:Label cssclass="labelData" id="lblRazonSocial2" runat="server"></asp:Label>&nbsp;</TD>
						</TR>
						<TR><TD></TD>
                            <td>
                            </td>
                        </TR>
						<TR vAlign="top">
							<TD style="height: 12px;">
								<DIV align="right">RNC o Cédula:&nbsp;</DIV>
							</TD>
							<TD width="50%" style="height: 12px">
								<asp:Label cssclass="labelData" id="lblRncCedula2" runat="server"></asp:Label>
                                <br />
                                <br />
                            </TD>
						</TR>
						</table>						
					</asp:Panel>
					
					
					<asp:Panel id="pnlDatosCiudadanos2" Runat="Server" Visible="False" Width="100%">
					<table id="Table8" cellSpacing="0" cellPadding="0" Width="100%" border="0">
						<TR vAlign="top">
							<TD>
								<DIV align="right">Nombre del individuo:&nbsp;</DIV>
							</TD>
							<TD width="50%">
								<asp:Label id="lblNombre2" runat="server" cssclass="labelData"></asp:Label></TD>
						</TR>
						<TR><TD></TD>
                            <td>
                            </td>
                        </TR>
						<TR vAlign="top">
							<TD style="height: 12px">
								<DIV align="right">NSS:&nbsp;</DIV>
							</TD>
							<TD width="50%">
								<asp:Label id="lblNSS2" runat="server" cssclass="labelData"></asp:Label></TD>
						</TR>
						<TR><TD></TD>
                            <td>
                            </td>
                        </TR>
						<TR vAlign="top">
							<TD>
								<DIV align="right">Cédula:&nbsp;</DIV>
							</TD>
							<TD width="50%">
								<asp:Label id="lblCedula2" runat="server" cssclass="labelData"></asp:Label>
                                <br />
                            </TD>
						</TR>
					</table>
					</asp:Panel>
					<table id="Table10" cellSpacing="0" cellPadding="0" Width="100%" border="0" language="javascript" onclick="return Table10_onclick()">
					<TR>
						<TD width="100%">
							<HR SIZE="1" id="HR1" language="javascript" onclick="return HR1_onclick()" style="width: 100%">
						</TD>
					</TR>
                     <TR>
						<TD vAlign="bottom" align="center">
                        
                            <asp:Button ID="btnVerCertificacion" runat="server" Text="Ver Certificación" 
                                Visible="False" />
                            &nbsp;
							<asp:button id="btnNuevaCert" runat="server" Text="Nueva Certificación"></asp:button>
                            <br />
                            <br />
                         </TD>
					</TR>                      
					

				    </TABLE> 
         </asp:panel>
         </td>
         </tr>
         </table>
    </td>
   </tr>
</table>
		<br>
    <br />
</asp:Content>

