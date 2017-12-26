<%@ Page Language="VB" AutoEventWireup="false" CodeFile="verCertificacion.aspx.vb" Inherits="Certificaciones_verCertificacion" Title="Ver certificación" %>

<html>
<head runat="server">
</head>
<body onload="javascript:print();">
    <form runat="server" id="form1">
        <!--Encabezado de la certificacion-->
        <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>

                <td valign="top" align="center" height="86">
                    <asp:Label ID="lblEslogan" Font-Bold="True" Font-Size="Medium" runat="Server"></asp:Label>
                    <br>
                    <br>
                    <font size="+1"><A style="textdecorator: none" onclick="javascript:print()" href="#"> CERTIFICACION No. <strong>
							<asp:label id="lblNoCert" runat="server"></asp:label></strong></A></font>
                    <br>
                    <br>
                    <font size="+1">A QUIEN PUEDA INTERESAR</font>

                    <br>
                    <br />
                    <asp:Label ID="lblmsg" runat="server" CssClass="error" Visible="False"></asp:Label>
                    <br>
                </td>
            </tr>
        </table>

        <!--Primer parrafo de la certificacion-->
        <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td valign="top" height="17">
                    <div align="justify">
                        <asp:Label ID="lblPrimerParafo" runat="server" EnableViewState="False" Font-Size="10pt"></asp:Label></div>
                </td>
            </tr>
        </table>
        <!--Panel de Aporte Empleado por Empleador-->
        <asp:Panel ID="pnlAportePorEmpleador" runat="server" Visible="False" EnableViewState="False">
            <br>
            <table cellspacing="0" cellpadding="0" width="100%" border="1">
                <tr bgcolor="#003366">
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="10%">Período<br>
                        Efectividad
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="30%">No. Referencia
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="15%">Fecha Pago
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="10%">Pago Atrasado
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="20%">Salario Reportado RD$
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="20%">Aporte RD$
                    </td>
                </tr>
                <!--Datalist con el aporte del empleado por el empleador-->
                <asp:DataList ID="dlAporteEmpleadoEmpleador" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal">
                    <ItemTemplate>
                        <tr bgcolor="#e2edf5">
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# getPeriodo(DataBinder.Eval(Container.DataItem,"C_TIPO_FACTURA"),DataBinder.Eval(Container.DataItem,"PERIODO"),DataBinder.Eval(Container.DataItem,"C_MES_APLICACION")) %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# formateaReferencia(DataBinder.Eval(Container.DataItem,"NO_REFERENCIA")) %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%# DataBinder.Eval(Container.DataItem,"FECHA_PAGO") %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%#DataBinder.Eval(Container.DataItem,"Pago_Atrasado") %>
									</font>
                            </td>
                            <td align="right">
                                <font face="Tahoma" color="#003399" size="1">
										<%#formatnumber(DataBinder.Eval(Container.DataItem,"SALARIO")) %>
									</font>
                            </td>
                            <td align="right">
                                <font face="Tahoma" color="#003399" size="1">
										<%#formatnumber(DataBinder.Eval(Container.DataItem,"APORTE")) %>
									</font>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <AlternatingItemTemplate>
                        <tr bgcolor="#f6f6f6">
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# getPeriodo(DataBinder.Eval(Container.DataItem,"C_TIPO_FACTURA"),DataBinder.Eval(Container.DataItem,"PERIODO"),DataBinder.Eval(Container.DataItem,"C_MES_APLICACION")) %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# formateaReferencia(DataBinder.Eval(Container.DataItem,"NO_REFERENCIA")) %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%# DataBinder.Eval(Container.DataItem,"FECHA_PAGO") %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%#DataBinder.Eval(Container.DataItem,"Pago_Atrasado") %>
									</font>
                            </td>
                            <td align="right">
                                <font face="Tahoma" color="#003399" size="1">
										<%#formatnumber(DataBinder.Eval(Container.DataItem,"SALARIO")) %>
									</font>
                            </td>
                            <td align="right">
                                <font face="Tahoma" color="#003399" size="1">
										<%#formatnumber(DataBinder.Eval(Container.DataItem,"APORTE")) %>
									</font>
                            </td>
                        </tr>
                    </AlternatingItemTemplate>
                </asp:DataList><!--Fin Datalist con el aporte del empleado por el empleador-->
            </table>
        </asp:Panel>
        <!--Fin Panel de Aporte Empleado por Empleador-->
        <!--Panel de Aporte personal-->
        <asp:Panel ID="pnlAportePersonal" runat="server" Visible="False" EnableViewState="False">
            <!--DataList que muestra el detalle de la certificacion Tipo3 - Aporte Personal-->
            <br>
            <table cellspacing="0" cellpadding="0" width="100%" border="1">
                <tr bgcolor="#003366">
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="10%">Período<br>
                        Efectividad
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="30%">No. Referencia
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="15%">Fecha Pago
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="10%">Pago Atrasado
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="20%">Salario Reportado RD$
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="20%">Aporte RD$
                    </td>
                </tr>
                <!--Datalis que muestra los empleadores-->
                <asp:DataList ID="dlEmpleador" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal">
                    <ItemTemplate>
                        <tr bgcolor="#aabbcc">
                            <td align="CENTER">
                                <font face="Tahoma" color="#003399" size="1"><b>RNC</b></font>
                            </td>
                            <td align="left">
                                <font face="Tahoma" color="#003399" size="1">
										<asp:label id=lblRnc runat=server Font-Bold="True" text='<%# formateaRNC(DataBinder.Eval(Container.DataItem,"RNC")) %>' />
									</font>
                            </td>
                            <td align="left" colspan="7">
                                <font face="Tahoma" color="#003399" size="1">
										<asp:label id="lblRazonSocial" Font-Bold="True" runat=server text='<%#DataBinder.Eval(Container.DataItem,"RAZON_SOCIAL") %>' />
									</font>
                            </td>
                        </tr>
                        <asp:DataList ID="dlAportePersonal" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal">
                            <ItemTemplate>
                                <tr bgcolor="#e2edf5">
                                    <td align="center">
                                        <font face="Tahoma" color="#003399" size="1">
												<%# getPeriodo(DataBinder.Eval(Container.DataItem,"C_TIPO_FACTURA"),DataBinder.Eval(Container.DataItem,"PERIODO"),DataBinder.Eval(Container.DataItem,"C_MES_APLICACION")) %>
											</font>
                                    </td>
                                    <td align="center">
                                        <font face="Tahoma" color="#003399" size="1">
												<%# formateaReferencia(DataBinder.Eval(Container.DataItem,"NO_REFERENCIA")) %>
											</font>
                                    </td>
                                    <td align="center"><font face="Tahoma" color="#003399" size="1">
												<%# DataBinder.Eval(Container.DataItem,"FECHA_PAGO") %>
											</font>
                                    </td>
                                    <td align="center"><font face="Tahoma" color="#003399" size="1">
												<%# DataBinder.Eval(Container.DataItem,"Pago_Atrasado") %>
											</font>
                                    </td>
                                    <td align="right">
                                        <font face="Tahoma" color="#003399" size="1">
												<%#formatnumber(DataBinder.Eval(Container.DataItem,"SALARIO")) %>
											</font>
                                    </td>
                                    <td align="right">
                                        <font face="Tahoma" color="#003399" size="1">
												<%#formatnumber(DataBinder.Eval(Container.DataItem,"APORTE")) %>
											</font>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <AlternatingItemTemplate>
                                <tr bgcolor="#f6f6f6">
                                    <td align="center">
                                        <font face="Tahoma" color="#003399" size="1">
												<%#getPeriodo(DataBinder.Eval(Container.DataItem,"C_TIPO_FACTURA"),DataBinder.Eval(Container.DataItem,"PERIODO"),DataBinder.Eval(Container.DataItem,"C_MES_APLICACION")) %>
											</font>
                                    </td>
                                    <td align="center">
                                        <font face="Tahoma" color="#003399" size="1">
												<%# formateaReferencia(DataBinder.Eval(Container.DataItem,"NO_REFERENCIA")) %>
											</font>
                                    </td>
                                    <td align="center"><font face="Tahoma" color="#003399" size="1">
												<%# DataBinder.Eval(Container.DataItem,"FECHA_PAGO") %>
											</font>
                                    </td>
                                    <td align="center"><font face="Tahoma" color="#003399" size="1">
												<%# DataBinder.Eval(Container.DataItem,"Pago_Atrasado") %>
											</font>
                                    </td>
                                    <td align="right">
                                        <font face="Tahoma" color="#003399" size="1">
												<%#formatnumber(DataBinder.Eval(Container.DataItem,"SALARIO")) %>
											</font>
                                    </td>
                                    <td align="right">
                                        <font face="Tahoma" color="#003399" size="1">
												<%#formatnumber(DataBinder.Eval(Container.DataItem,"APORTE")) %>
											</font>
                                    </td>
                                </tr>
                            </AlternatingItemTemplate>
                        </asp:DataList>
                    </ItemTemplate>
                </asp:DataList>
            </table>
            <!--Fin del DataList que muestra el detalle de la certificacion Tipo3 - Aporte Personal-->
        </asp:Panel>
        <!--Panel de ingreso tardio-->
        <asp:Panel ID="pnlIngresoTardio" runat="server" Visible="False" EnableViewState="False">
            <br>
            <table cellspacing="0" cellpadding="0" width="100%" border="1">
                <tr bgcolor="#003366">
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" width="10%">NSS
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" width="12%">Cédula
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center">Nombres y Apellidos
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 10pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center">Estatus
                    </td>
                </tr>
                <!--Datalist del detalle de ingreso tardio-->
                <asp:DataList ID="dlIngresoTardio" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal">
                    <ItemTemplate>
                        <tr bgcolor="#e2edf5">
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1px">
										<%# formateaNSS(DataBinder.Eval(Container.DataItem,"NSS")) %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1px">
										<%# formateaRNC(DataBinder.Eval(Container.DataItem,"CEDULA")) %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1px">
										<%# DataBinder.Eval(Container.DataItem,"NOMBRE") %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1px">
										<%# DataBinder.Eval(Container.DataItem,"STATUS") %>
									</font>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:DataList><!--Fin del Datalist del detalle de ingreso tardio-->
            </table>
        </asp:Panel>
        <!--Fin del panel de ingreso tardio-->
        <!--Panel de la certificacion de capacidad-->


        <asp:Panel ID="pnlDiscapacidad" runat="server" Visible="False" EnableViewState="False">
            <br>
            <table cellspacing="0" cellpadding="0" width="100%" border="1">
                <tr bgcolor="#003366">
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="15%" nowrap="nowrap">RNC
                    </td>

                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center">Empleador
                    </td>
                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" nowrap="nowrap" width="8%">Nomina</td>
                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" width="12%">Salario<br>Reportado
                        </br>
                    </td>
                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" width="5%" nowrap="nowrap">Del 
							período
                    </td>
                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" width="8%" nowrap="nowrap">Con 
							fecha límite<br>de pago
                            </br>
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center" width="10%">Pagado En
                    </td>
                    <td align="center"
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        width="10%">Tipo de pago
                    </td>
                </tr>
                <!--Datalist del detalle de discapacidad-->
                <asp:DataList ID="dlDetalleDiscapacidad" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal">
                    <ItemTemplate>
                        <tr bgcolor="#e2edf5">
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# formateaRNC(DataBinder.Eval(Container.DataItem,"RNC")) %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# DataBinder.Eval(Container.DataItem,"razon_social") %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%#DataBinder.Eval(Container.DataItem, "Id_Nomina")%>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# formatnumber(DataBinder.Eval(Container.DataItem,"Salario_Cotizable")) %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%# formateaPeriodo(DataBinder.Eval(Container.DataItem,"periodo_factura")) %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%# String.Format("{0:d}", DataBinder.Eval(Container.DataItem,"FechaLimitePago")) %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%# String.Format("{0:d}", DataBinder.Eval(Container.DataItem,"fecha_pago")) %>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%# DataBinder.Eval(Container.DataItem,"TipoPago") %>
									</font>
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:DataList><!--Fin del Datalist del detalle de discapacidad-->
            </table>
        </asp:Panel>


        <!--Fin del Panel de la certificacion de capacidad-->




        <!--Inicio del Panel de la certificacion de deuda-->


        <asp:Panel ID="PnlDeuda" runat="server" Visible="False" EnableViewState="False">
            <br>
            <table cellspacing="0" cellpadding="0" width="90%" border="1">
                <tr bgcolor="#003366" align="center">
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="1%" nowrap="nowrap">Periodo Factura
                    </td>
                    <td style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma" align="center"
                        width="5%" nowrap="nowrap">Nro. Referencia
                    </td>
                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" width="4%">Estatus
                    </td>
                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" nowrap="nowrap" width="8%">Nomina</td>
                    <td
                        style="FONT-WEIGHT: bold; FONT-SIZE: 7pt; COLOR: #ffffff; FONT-FAMILY: Tahoma"
                        align="center" width="3%">Total</td>

                </tr>
                <!--Datalist del detalle de deuda-->
                <asp:DataList ID="DlDeuda" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal">
                    <ItemTemplate>
                        <tr bgcolor="#e2edf5" align="center">
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%# formateaPeriodo(DataBinder.Eval(Container.DataItem,"periodo_factura")) %>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%# formateaReferencia(DataBinder.Eval(Container.DataItem, "id_referencia"))%>
									</font>
                            </td>
                            <td align="center">
                                <font face="Tahoma" color="#003399" size="1">
										<%#DataBinder.Eval(Container.DataItem, "status_des")%>
									</font>
                            </td>


                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%#DataBinder.Eval(Container.DataItem, "nomina_des")%>
									</font>
                            </td>
                            <td align="center"><font face="Tahoma" color="#003399" size="1">
										<%#formateaSalario(DataBinder.Eval(Container.DataItem, "total_importe"))%>
									</font>
                            </td>

                        </tr>
                    </ItemTemplate>
                </asp:DataList><!--Fin del Datalist del detalle de deuda-->
            </table>
        </asp:Panel>




        <!--Fin del Panel de la certificacion de deuda-->



        <br>
        <!--Segundo Parrafo de la certificacion-->
        <table cellspacing="0" cellpadding="0" width="100%" border="0">
            <tr>
                <td>
                    <div align="justify">
                        <asp:Label ID="lblSegundoParrafo" runat="server" EnableViewState="False" Font-Size="10pt"></asp:Label></div>
                </td>
            </tr>
        </table>
        <!--Fin del Segundo Parrafo de la certificacion-->
        <br>
        <br>
        <br>
        <!--Session de la firma de la certificacion-->
        <table cellspacing="0" cellpadding="0" width="100%">
            <tr>
                <td>
                    <table cellspacing="0" cellpadding="0" width="300" align="left" border="0">
                        <tr>
                            <td>
                                <hr style="width: 100%">
                            </td>
                        </tr>
                        <tr runat="server" id="trImagenFirma" visible="false">
                            <td style="text-align: center">
                                <asp:Image ID="imgFirma" runat="server" /></td>
                        </tr>
                        <tr runat="server" id="trFirma" visible="false">
                            <td style="text-align: center"><strong>
                                <asp:Label ID="lblFirma" runat="server"></asp:Label></strong><br>
                                <asp:Label ID="lblPuestoFirma" runat="server"></asp:Label></td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <!--Fin de la firma-->
        <br>
        <br>
        <table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
            <tr>
                <td>
                    <hr style="width: 100%">
                </td>
            </tr>
            <tr>
                <td align="center"><strong>NO HAY NADA ESCRITO DEBAJO DE ESTA LINEA</strong>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>





