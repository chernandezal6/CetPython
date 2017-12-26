<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Info.aspx.vb" Inherits="Solicitudes_Info" title="Info" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

			<TABLE align="center" id="Table0" cellSpacing="0" cellPadding="0" width="550" border="0">
				<TR>
					<TD><asp:panel id="pnlMsn1" Visible="False" Runat="server" width="100%">
							<TABLE id="Table1" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
										<asp:Button id="btnAceptar1" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn2" Visible="False" Runat="server" width="100%">
							<TABLE id="Table2" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Registro de Empresa o Negocio:</div>
										<P align="justify"><FONT face="Tahoma" size="2">El empleador se comunica con el Call 
												Center del Gobierno para registrar su empresa o negocio en la base de datos de 
												la Tesorería de la Seguridad Social. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">El representante cuestiona al empleador 
												si desea la información general o desea registrarse de inmediato para generarle 
												el ticket.</FONT></P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si el empleador informa que solo 
												desea saber la información, el Representante informa los datos que debe tener a 
												mano al momento de registrarse: </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de cédula de la persona que 
												llama o del representante de la empresa o negocio ante la TSS - RNC o Cédula 
												que identifica la empresa o negocio (la cédula se utiliza para los negocios de 
												único dueño). - Razón Social (en el caso de los negocios de único dueño, la 
												razón social es el nombre y apellidos del dueño. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Nombre Comercial </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Dirección, Teléfono, Fax, Correo 
												Electrónico. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Ofrece asistencia adicional según 
												Script y se despide. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si el empleador informa que desea 
												registrarse de inmediato, pregunte si tiene el número de RNC y la cédula del 
												representante de la empresa. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Si no lo tiene, informa que debe 
												llamarnos con la información a mano. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Si lo tiene procede a crear el ticket 
												de la siguiente manera: </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- En la página de la TSS elige crear 
												solicitud y en tipo de solicitud “Registro de Empresa”, completa datos de RNC y 
												número de cédula del representante de la empresa, da click en aceptar para que 
												el sistema le solicite el teléfono de contacto y genere el número de ticket. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Informe el número de ticket al 
												representante de la empresa e informe que en un día laborable una persona de la 
												TSS le llamará para verificar los datos e informarle sobre su CLASS (Clave de 
												Acceso a la Seguridad Social), en ese momento también puede registrar su nómina 
												para lo que necesitará: </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- No. de cédula de cada uno de sus 
												trabajadores </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Salario mensual </FONT>
										</P>
										<P align="justify"><FONT size="2"><FONT face="Tahoma">- Fecha de ingreso Una vez el 
													empleador obtiene su CLASS debe registrar su nómina a través de la página Web 
													de Tesorería o abrir un ticket con una solicitud realizada al Centro de 
													Contacto. Mensualmente debe reportar sus novedades (ingresos, salidas, cambios 
													de salarios).</FONT> </FONT>
										</P>
									</TD>
								</TR>
							</TABLE>
							<TABLE id="Table22" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar2" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn3" Visible="False" Runat="server" width="100%">
							<TABLE id="Table3" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Solicitud de Recuperación del CLASS<br />
                                        </div>
										
										<div align="center" class="header2">(Clave de Acceso a la Seguridad Social)</div>
										<P align="justify"><FONT face="Tahoma" size="2">Consiste en que el empleador solicita 
												el “reseteo” de su CLASS, para esto se abre un ticket y un operador del Call 
												Center de la Tesorería de Seguridad Social se comunicará con el representante 
												de la empresa que realiza la solicitud. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">El representante selecciona en 
												solicitud “Recuperación de Clave de Acceso” y completa el ticket con las 
												siguientes informaciones del empleador: </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de RNC o Cédula de la empresa 
												o negocio </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de cédula del representante 
												del negocio que está previamente registrado en la TSS.</FONT></P>
										<P align="justify"><FONT face="Tahoma" size="2">El sistema desplegará el número de 
												solicitud, informe al empleador dicho número y que en un día laborable un 
												operador de la TSS le estará contactando para darle su nuevo número de Class.</FONT></P>
									</TD>
								</TR>
							</TABLE>
							<TABLE id="Table55" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar3" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn4" Visible="False" Runat="server" width="100%">
							<TABLE id="Table4" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Solicitud de Estado de Cuentas:</div>
										<P align="justify"><FONT face="Tahoma" size="2">Consiste en que el empleador solicita 
												su estado de cuenta (balance pendiente) de Seguridad Social, de retenciones de 
												asalariados (IR-3) o de otras retenciones (IR-17). </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Consulte con el empleador si tiene 
												acceso al servicio de Internet. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si tiene acceso a Internet, informe 
												que puede acceder a la página web: www.tss.gov.do desde Servicio elija 
												“Consulta Deuda por Empleador” o desde Acceso a Representante utilizando su 
												RNC, Cédula y Class (Clave de Acceso a la Seguridad Social). </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si NO tiente acceso a internet, el 
												empleador debe suministrar los siguientes datos: </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de RNC o Cédula de la empresa 
												o negocio. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de cédula del representante 
												del negocio que está previamente registrado en la TSS.</FONT></P>
										<P align="justify"><FONT face="Tahoma" size="2">&nbsp;El estado de cuentas será 
												desplegado en pantalla, suministre la información al empleador.</FONT></P>
										<P align="justify"><FONT face="Tahoma" size="2">&nbsp;Estarán disponibles dos botones, 
												uno para envío por mail y otro para envío por fax. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Si el operador del CCG selecciona envío 
												por fax el sistema desplegará en pantalla el número de fax que tiene registrado 
												el empleador permitiéndole cambiarlo Si el operador selecciona envío por mail, 
												el sistema verificará que dicho representante tenga un mail asociado.</FONT></P>
									</TD>
								</TR>
							</TABLE>
							<TABLE id="Table25" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar4" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn5" Visible="False" Runat="server" width="100%">
							<TABLE id="Table5" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar5" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn6" Visible="False" Runat="server" width="100%">
							<TABLE id="Table6" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar6" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn7" Visible="False" Runat="server" width="100%">
							<TABLE id="Table7" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Solicitud de Información Pública:</div>
										<P align="justify"><FONT face="Tahoma" size="2">Consiste en realizar una solicitud de 
												información pública amparada en la Ley General de Libre Acceso a la Información 
												Pública. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">El representante desde Crear Solicitud 
												elige “Información Pública” y solicita los siguientes datos al ciudadano: </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de cédula </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Empresa o institución a que pertenece 
												(no obligatorio) </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Cargo que ocupa (no obligatorio) </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Detalle de la información que 
												solicita </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Motivo de su solicitud </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Dirección completa del solicitante </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Correo electrónico (no obligatorio) </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Teléfonos donde contactarle (celular 
												y teléfono) obligatorio Se abre un ticket y el encargado de la Oficina de 
												Acceso a la Información se comunicará con el solicitante para dar respuesta a 
												su solicitud en tres (3) días laborables.</FONT></P>
									</TD>
								</TR>
							</TABLE>
							<TABLE id="Table77" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar7" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn8" Visible="False" Runat="server" width="100%">
							<TABLE id="Table8" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Solicitud de Envío de Facturas x E-mail 
												y Actualización de Correo Electrónico</div>
										<P align="justify"><FONT face="Tahoma" size="2">Consiste en que el empleador solicita 
												que su factura le llegue por mail cada mes a partir del próximo corte. (Los 
												cortes son los 15 de cada mes). </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">El empleador debe dar los siguientes 
												datos: </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de RNC o Cédula de la empresa 
												o negocio. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Número de cédula del representante 
												del negocio que está previamente registrado en la TSS. El representante 
												confirma la razón social y el nombre del representante de la empresa y procede 
												a registrar el correo electrónico de dicho representante. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Informe al representante de la empresa 
												que a partir del próximo corte su factura será enviada por mail.</FONT></P>
									</TD>
								</TR>
							</TABLE>
							<TABLE id="Table28" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar8" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn9" Visible="False" Runat="server" width="100%">
							<TABLE id="Table9" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Solicitud de Carácter General:</div>
										<P><FONT face="Tahoma" size="2">El empleador se comunica con el Call Center del 
												Gobierno para registrar su empresa o negocio en la base de datos de la 
												Tesorería de la Seguridad Social. El representante cuestiona al empleador si 
												desea alguna solicitud en particular, en caso de que no se encuentre respuesta 
												para la solicitud que hace el representante, entonces se procederá a llenar una 
												solicitud de carácter general lo mas explícita posible. </FONT>
										</P>
										<P><FONT face="Tahoma" size="2">-En la página de la TSS elige crear solicitud general 
												con la cédula y los números de teléfono de la persona que llama, da click en 
												aceptar para que el sistema le genere el número de ticket. Informe el número de 
												ticket al representante de la empresa e informe que en un día laborable una 
												persona de la TSS le llamará para dar respuesta a su solicitud.</FONT></P>
										<div align="center">
											<asp:Button id="btnAceptar9" runat="server" Text="Aceptar"></asp:Button></div>
									</TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn10" Visible="False" Runat="server" width="100%">
							<TABLE id="Table10" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Consulta de Número de Seguridad Social 
												(NSS):</div>
										<P align="justify"><FONT face="Tahoma" size="2">Consiste en ofrecer al ciudadano cual 
												es su NSS con solo dar su número de cédula (disponible a través de la página 
												Web). </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">En Crear Solicitud elija Consulta de 
												NSS y digite el número de cédula del ciudadano. Verifique el nombre que aparece 
												en pantalla con el ciudadano y si está correcto informe el número de NSS al 
												ciudadano. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Si NO está correcto el nombre del 
												ciudadano entonces debe verificar el número de cédula ya que se digitó la 
												cédula de otra persona.</FONT></P>
									</TD>
								</TR>
							</TABLE>
							<TABLE id="Table20" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar10" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn11" Visible="False" Runat="server" width="100%">
							<TABLE id="Table11" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD>
										<div align="center" class="header">Consulta de Cálculo de Aportes:</div>
										<P align="justify"><FONT face="Tahoma" size="2">Consiste en informar al ciudadano 
												cuanto le debe descontar su patrón por concepto de seguridad social. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">El ciudadano debe informar su salario. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">El Sistema le dirá cuanto se le va a 
												descontar y cuanto se le acumulará en su Cuenta de Capitalización para su 
												pensión.</FONT></P>
									</TD>
								</TR>
							</TABLE>
							<TABLE id="Table21" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar11" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn12" Visible="False" Runat="server" width="100%">
							<TABLE id="Table12" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD style="height: 788px">
										<div align="center" class="header">Registro de Nóminas y de Novedades:</div>
										<P align="justify"><FONT face="Tahoma" size="2">Consiste en registrar la nómina de la 
												empresa por primera vez o reportar una o varias novedades. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">Las Novedades abarcan:</FONT></P>
										<P align="justify"><FONT face="Tahoma" size="2">- Ingresos de los trabajadores </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Salidas de los trabajadores </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Cambios de salario de los 
												trabajadores </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Otras remuneraciones (comisiones, 
												vacaciones, horas nocturnas, horas extras, 
                                            <br />
                                            bonificaciones, etc.) </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Pregunte si la empresa tiene acceso 
												al servicio de Internet. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si tiene acceso, refiéralo a la pag. 
												Web www.tss.gov.do, desde “ACCESO A REPRESENTANTE”. En esta opción le solicita 
												la información de su RNC, cédula del representante de la empresa y su número de 
												Clave. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si el representante de la empresa 
												informa que NO tiene Clave, proceda de acuerdo al punto de “Recuperación de 
												Clave”. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si la persona que llama de la empresa 
												NO tiene acceso a internet, entonces accede a Información General y crea un 
												ticket con el número de cédula del representante de la empresa y teléfonos de 
												contacto de la empresa. Informa que en un día laborable un operador de la TSS 
												le estará contactando. </FONT>
										</P>
										<P align="justify"><FONT face="Tahoma" size="2">- Si la persona que llama informa NO es 
												el representante de la empresa y desea ser agregado como tal, el representante 
												informa que espere la llamada del operador de la TSS.</FONT></P>
									</TD>
								</TR>
							</TABLE>
							<BR>
							<TABLE id="Table23" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
										<asp:Button id="btnAceptar12" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel><asp:panel id="pnlMsn13" Visible="False" Runat="server" width="100%">
							<TABLE id="Table13" cellSpacing="0" cellPadding="0" width="100%" border="0">
								<TR>
									<TD align="center">
                                        <br />
										<asp:Button id="btnAceptar13" runat="server" Text="Aceptar"></asp:Button></TD>
								</TR>
							</TABLE>
						</asp:panel></TD>
				</TR>
			</TABLE>
</asp:Content>

