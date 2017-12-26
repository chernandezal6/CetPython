<%@ Page Language="VB"  AutoEventWireup="false" CodeFile="ayudaNovedades.aspx.vb" Inherits="Novedades_ayudaNovedades" title="Ayuda Novedades" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Ayuda Novedades</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table width="350">
				<tr>
					<td class="Header">
                        <strong><span style="font-size: 8pt">
						Ayuda de novedades </span></strong>
					</td>
				</tr>
				<tr>
					<td class="subHeader" style="height: 30px"><BR>
						Sobre los salarios y otros ingresos reportados
					</td><br />
				</tr>
				<tr>
					<td style="height: 237px">
						<p> 
							El monto del salario cotizable para la Seguridad Social y para el ISR, así como 
							los otros ingresos serán utilizados para el cálculo de las retenciones y 
							aportes del SDSS y del ISR para el período en que está reportando.
						</P>
						<p>
						    El monto del salario reportado para Infotep solo será tomado en cuenta para 
						    las liquidaciones por este concepto. Si se deja en 0.00 se tomará por defecto 
						    el mismo salario reportado para el SDSS.
						</p>						
						<p>
                            <span style="font-size: 8pt"><strong>Ejemplo </strong></span>
							
							Si está dando ingreso a un trabajador, debe reportar <STRONG>únicamente la 
							proporción de lo percibido</STRONG> por el trabajador en el período que 
							reporta y actualizar los datos del mismo nuevamente el mes siguiente.
						</p>						
						<p> 
						    Si está dando salida a un trabajador, debe reportar <STRONG>únicamente la proporción 
							de lo percibido</STRONG> por el trabajador en el período que reporta. No 
							deberá reportar nuevamente al trabajador ya que quedará dado de baja para el 
							siguiente período.							
						</p>
					</td>
				</tr>
				<TR>
					<TD align="center">
						<p><br />
							<input type="button" onclick="window.close();" value="Cerrar Ventana" />
						</p>
					</TD>
				</TR>
			</table>
    </div>
    </form>
</body>
</html>
