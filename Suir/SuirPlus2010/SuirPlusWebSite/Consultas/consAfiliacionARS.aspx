
<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consAfiliacionARS.aspx.vb" Inherits="Consultas_consAfiliacionARS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script type="text/javascript">

        if (top != self) top.location.replace(location.href);

    </script>
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

    </script>
    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <div class="header">
        Consulta de Afiliación ARS</div>
    <br />
    <table border="0" cellpadding="1" cellspacing="1" class="consultaTabla" style="font-size: 13pt;
        color: #006699; font-family: Verdana" width="370">
        <tr>
            <td>
                <table id="Table1" cellpadding="0" cellspacing="0" class="td-content">
                    <tr>
                        <td style="width: 455px">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" style="text-align: center; width: 455px;">
                            No de Cédula: (sin guiones)
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 12px; text-align: center; width: 455px;" valign="top">
                            <asp:TextBox onKeyPress="checkNum()" ID="txtnodocumento" runat="server" MaxLength="11"></asp:TextBox><asp:RegularExpressionValidator
                                ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtnodocumento"
                                Display="Dynamic" ErrorMessage="Debe ser numérico el valor" ValidationExpression="\d*"></asp:RegularExpressionValidator>
                        </td>
                    </tr>                  
                    <tr> 
                        <td align="center" style="width: 455px">
                            <asp:Button ID="btBuscarRef" runat="server" Enabled="True" EnableViewState="False"
                                Text="Buscar" />
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" /><br /><br />
                            
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 455px">
                        </td>
                    </tr>
                </table>
                <asp:Label ID="lblError" runat="server" CssClass="error" Font-Size="8pt" Visible="False"></asp:Label>
            </td>
        </tr>
    </table>
    <br />
    <asp:Panel ID="pnlInfo" runat="server" Visible="False" Width="543px">
        <table border="0" cellpadding="0" cellspacing="0" id="TABLE2" runat="server" 
            visible="true">
            <tr>
                <td colspan="2" id="TD1" runat="server">
                    <asp:Label ID="Label8" runat="server" Text="Datos de la Persona" CssClass="subHeader"
                        Font-Size="Small"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 106px">
                    <asp:Label ID="Label5" runat="server" Text="Nombre:" Font-Size="Small"></asp:Label>
                </td>
                <td style="width: 416px">
                    <asp:Label ID="lblNombre" runat="server" Font-Bold="True" Font-Size="Small" CssClass="subHeader"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 106px">
                    <asp:Label ID="Label6" runat="server" Text="ARS:" Font-Size="Small"></asp:Label>
                </td>
                <td style="width: 416px">
                    <asp:Label ID="lblARS" runat="server" Font-Bold="True" Font-Size="Small" CssClass="subHeader"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 106px; height: 16px">
                    <asp:Label ID="Label7" runat="server" Text="Estatus:" Font-Size="Small"></asp:Label>
                </td>
                <td style="width: 416px; height: 16px;">
                    <asp:Label ID="lblStatus" runat="server" Font-Bold="True" Font-Size="Small" CssClass="subHeader"></asp:Label>
                </td>
            </tr>
           <%-- <tr>
                <td style="width: 106px; height: 16px">
                    <asp:Label ID="Label2" runat="server" Font-Size="Small" Text="Tipo Afiliación:"></asp:Label>
                </td>
                <td style="width: 416px; height: 16px">
                    <asp:Label ID="lblTipoAfiliacion" runat="server" Font-Bold="True" Font-Size="Small"
                        CssClass="subHeader"></asp:Label>
                </td>
            </tr>--%>
            <tr>
                <td style="height: 16px">
                    <asp:Label ID="Label2" runat="server" Font-Size="Small" Text="Tipo Afiliación:"></asp:Label>
                    <asp:Label ID="Label9" runat="server" Font-Size="Small" Text="Tipo Solicitud:"></asp:Label>
                </td>
                <td style="width: 464px; height: 16px">
                    <asp:Label ID="lblTipoAfiliacion" runat="server" Font-Bold="True" Font-Size="Small"
                        CssClass="subHeader"></asp:Label>
                    <asp:Label ID="lblTipoSolicitud" runat="server" Font-Bold="True" Font-Size="Small"
                        CssClass="subHeader"></asp:Label>
                </td>
            </tr>
              <tr>
                <td style="height: 8px">
                    <asp:Label ID="Label4" runat="server" Font-Size="Small" Text="Fecha Solicitud:"
                        Width="98px" Height="17px" style="margin-right: 0px"></asp:Label>
                     
                     <asp:Label ID="Label3" runat="server" Font-Size="Small" Text="Fecha Afiliacion:"
                        Width="106px" Height="16px" style="margin-right: 0px"></asp:Label>

                </td>
                <td style="width: 464px; height: 8px">
                    <asp:Label ID="lblFechaSolicitud" runat="server" Font-Bold="True" Font-Size="Small"
                        CssClass="subHeader"></asp:Label>
                    <asp:Label ID="lblFechaAfiliacion" runat="server" CssClass="subHeader" 
                        Font-Bold="True" Font-Size="Small"></asp:Label>
                    
                    <asp:Label ID="lblFecha" runat="server" Font-Bold="True" Font-Size="Small"
                        CssClass="subHeader"></asp:Label>
                </td>
            
              </tr>

           <%-- <tr>
                <td style="width: 106px; height: 16px">
                    <asp:Label ID="Label3" runat="server" Font-Size="Small" Text="Fecha Afiliación:"
                        Width="94px"></asp:Label>
                </td>
                <td style="width: 416px; height: 16px">
                    <asp:Label ID="lblFechaAfiliacion" runat="server" Font-Bold="True" Font-Size="Small"
                        CssClass="subHeader"></asp:Label>
                </td>
            </tr>--%>

        </table>
    </asp:Panel>
    <br />
    <br />
    <asp:Panel ID="pnlNucleo" runat="server" Visible="False" Width="543px">
        <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="Small" EnableViewState="False"
            Height="20px" Width="256px" CssClass="subHeader">Composición del Núcleo Familiar</asp:Label><br />
        <asp:GridView ID="gvNucleoFamiliar" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="NOMBRE" HeaderText="Nombres">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:TemplateField HeaderText="Tipo">
                    <ItemTemplate>
                        <asp:Label ID="lblTipo" runat="server" Text='<%# iif(eval("Parentesco") = "TITULAR","Titular","Dependiente") %>'></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="Left" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Parentesco">
                    <ItemTemplate>
                        <asp:Label ID="lblPare" runat="server" Text='<%# iif(eval("Parentesco") = "TITULAR"," ",eval("Parentesco")) %>'></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="Left" />
                </asp:TemplateField>
                <asp:BoundField DataField="ESTATUS" HeaderText="Estatus" />
                <asp:TemplateField HeaderText="No. Documento">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# formateaCedula(ValidarNull(eval("Cedula"))) %>'></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
                <asp:TemplateField HeaderText="NSS">
                    <ItemTemplate>

                            <asp:Label ID="Label2" runat="server" Text='<%# formateaNSS(ValidarNull(eval("NSS"))) %>'></asp:Label>
                            <%--<asp:Label ID="Label10" runat="server" Text='<%# formateaNSS(iif(ValidarNull(eval("NSS")) = " ", ValidarNull(eval("NSS")), DBNull .Value)) %>'></asp:Label>--%>

                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>
    <br />
    <table border="0" cellpadding="0" cellspacing="0">
        <tr>
            <td style="width: 578px">
                <span style="font-size: 9pt"><span style="color: #006699"><strong>Notas:
                    <br />
                    <br />
                </strong>1 – Si usted aparece afiliado en una ARS distinta a la de su elección, entonces
                    deberá contactar a la DIDA al teléfono 809-472-1900 opción 6.
                    <br />
                    <br />
                    2 – Si usted no aparece afiliado o aparece con afiliación en estatus PENDIENTE <strong>
                        <span style="text-decoration: underline">y es un trabajador(a) asalariado(a)</span></strong>,
                    se debe a que su empleador <span style="text-decoration: underline"><strong>NO le ha
                        registrado </strong></span>en la Tesorería de la Seguridad Social, en este caso
                    deberá contactar a la DIDA para informar sobre su situación.<br />
                    <br />
                    3 – Si su núcleo familiar está incompleto, debe contactar directamente a su ARS
                    para informarle de la situación de sus dependientes que no aparecen registrados.
                    <br />
                </span></span>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />

</asp:Content>

