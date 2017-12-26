<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ayudaSalario.aspx.vb" Inherits="Novedades_ayudaSalario" title="Novedades - Ayuda Salario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

<TABLE id="Table1" width="350">
				<TR>
					<TD class="Header">
                        <strong><span style="font-size: 8pt">
						Ayuda de&nbsp;salarios </span></strong>
					</TD>
				</TR>
				<TR>
					<TD class="subHeader"><BR>
						Diferencias entre Salario Cotizable para la Seguridad Social y Salario 
						Cotizable y otros ingresos para fines del ISR
					</TD>
				</TR>
				<TR>
					<TD>
						<BR>
							Para un Trabajador que ganó en el período 01-2005<BR>
							<BR>
							$26,000.00 de sueldo
							<BR>
							$8,000.00 de comisión
							<BR>
							$4,000.00 de incentivos y
							<BR>
							$1,500.00 de horas extras
							<BR>
							<BR>
							Si además, este mismo trabajador, tiene un saldo a favor disponible de 
							$8,000.00, para el período que se está reportando.
							<BR>
							<BR>
							Entonces:
							<BR>
							<BR>
							Su salario cotizable para la Seguridad Social, de acuerdo a la Resolución 72-03 
							del CNSS de fecha 29 de abril del 2003, será:<BR>
							<BR>
							<TABLE class="list" id="Table2" cellSpacing="1" cellPadding="1" width="90%" align="center"
								border="0">
								<TR>
									<TD class="listheader" align="left">
                                        <strong><span style="font-size: 8pt; text-decoration: underline">Concepto</span></strong></TD>
									<TD class="listheader" align="Right">
                                        <strong><span style="font-size: 8pt; text-decoration: underline">Valor</span></strong></TD>
								</TR>
								<TR>
									<TD align="left">Sueldo</TD>
									<TD align="right">&nbsp;&nbsp; $26,000.00</TD>
								</TR>
								<TR>
									<TD align="left">Comisión</TD>
									<TD align="right">&nbsp;&nbsp;&nbsp; $8,000.00</TD>
								</TR>
								<TR>
									<TD align="left">Salario cotizable Seg. Social</TD>
									<TD align="right">RD$34,000.00</TD>
								</TR>
							</TABLE>
							<BR>
							Por otro lado, los datos que se deberán registrar para fines del cálculo del 
							Salario Neto Imponible correspondientes al ISR (IR-4) se reportarán de la 
							siguiente forma:<BR>
							<BR>
							<TABLE class="list" id="Table3" cellSpacing="1" cellPadding="1" width="90%" align="center"
								border="0">
								<TR>
									<TD class="listheader" align="left">
                                        <strong><span style="font-size: 8pt; text-decoration: underline">Concepto</span></strong></TD>
									<TD class="listheader" align="Right">
                                        <strong><span style="font-size: 8pt; text-decoration: underline">Valor</span></strong></TD>
								</TR>
								<TR>
									<TD align="left">Salario cotizable ISR</TD>
									<TD align="right">&nbsp;&nbsp; $26,000.00</TD>
								</TR>
								<TR>
									<TD align="left">ComisiónOtros ingresos (Comisión,&nbsp; incentivos, horas extras, 
										etc.)</TD>
									<TD align="right">&nbsp;&nbsp;&nbsp; $13,500.00</TD>
								</TR>
								<TR>
									<TD align="left">Saldo a Favor del período</TD>
									<TD align="right">RD$8,000.00</TD>
								</TR>
							</TABLE>
							<BR>
							El sistema que genera el Volante de Liquidación para las retenciones del ISR a 
							asalariados, calculará automáticamente el ISR correspondiente, el saldo 
							compensado y el saldo por compensar.
						
					</TD>
				</TR>
				<TR>
					<TD align="center">
						<P><BR>
							<INPUT onclick="window.close();" type="button" value="Cerrar Ventana">
						</P>
					</TD>
				</TR>
			</TABLE>
</asp:Content>

