<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="consPagosExcesosCiudadanos.aspx.vb" Inherits="Consultas_consPagosExcesosCiudadanos" %>

<%@ Register TagPrefix="recaptcha" Namespace="Recaptcha" Assembly="Recaptcha" %>
<%@ Register Src="~/Controles/ucCaptcha.ascx" TagPrefix="uc1" TagName="ucCaptcha" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .msg {
            font-size: 10pt;
        }
        .buttonLeft {
            margin-left:1px;
        }
    </style>
    <script type="text/javascript">

        //if (top != self) top.location.replace(location.href);

    </script>
    <img alt="Tesoreria de la Seguridad Social"
        src="../images/logoTSShorizontal.gif" />
    <div class="header">Consulta de reembolso por pagos en exceso del Seguro Familiar de Salud</div>
    <br />
    <b>
        <label id="lblAviso" runat="server" style="color: red; font-size: medium;"></label>
    </b>

    <script type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

        $(function () {
            $(".date").datepicker({
                dateFormat: 'dd/mm/yy',
                //defaultDate: "+1w",
                changeMonth: true,
                changeYear: true,
                numberOfMonths: 1,
                yearRange: "-100:+0"

            });

            $("#ui-datepicker-div").css('visibility', 'hidden');

            $(".date").click(function () {
                $("#ui-datepicker-div").css('visibility', 'visible');
            });
            


        });



    </script>

    <asp:HiddenField ID="hdcontador" runat="server" /> 
    <table border="0" cellpadding="1" cellspacing="1" class="consultaTabla" style="font-size: 13pt; color: #006699; font-family: Verdana"
        width="370">
        <tr>
            <td>
                <br />
                <table id="Table3" cellpadding="0" cellspacing="0" class="td-content">
                    <tr>
                        <td style="width: 455px">&nbsp;</td>
                    </tr>
                    <tr>
                        <td valign="top" style="text-align: center; width: 455px;">No de Cédula:
                            (sin guiones)</td>
                    </tr>
                    <tr>
                        <td style="height: 12px; text-align: center; width: 455px;" valign="top">
                            <asp:TextBox onKeyPress="checkNum()" ID="txtnodocumento" runat="server" MaxLength="11"></asp:TextBox>
                            <br />
                            <asp:RegularExpressionValidator
                                ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtnodocumento"
                                Display="Dynamic" ErrorMessage="Debe ser numérico el valor" ValidationExpression="\d*"></asp:RegularExpressionValidator></td>
                    </tr>

                    <tr>
                        <td colspan="2" style="height: 18px;" align="center">
                            <%--     <recaptcha:recaptchacontrol
                                            ID="recaptcha"
                                            runat="server"
                                            PublicKey="6Ld-od0SAAAAAL-7eV_JbD8brOewzWcL0AMig-ar"
                                            PrivateKey="6Ld-od0SAAAAAPmNITxMyGFHybQxFmewdLICP0lF" 
                                            AllowMultipleInstances="True"
                                            Theme="white"/>--%>
                            <uc1:ucCaptcha runat="server" ID="ucCaptcha1" />

                        </td>
                    </tr>
                    <tr id="BotonesBL" runat="server">
                        <td align="center" style="width: 455px">
                            <br />
                            <asp:Button ID="Btn_Buscar" runat="server" Enabled="True" EnableViewState="False"
                                Text="Buscar" />
                            <asp:Button ID="Btn_Limpiar" runat="server" Text="Limpiar" /></td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                        </td>
                    </tr>
                </table>
                <br />
                <asp:Label ID="lblError" runat="server" Visible="False" Font-Size="10pt"></asp:Label></td>
        </tr>
    </table>

    <br />
    <asp:Panel ID="pnlInfo" runat="server" Visible="False" Width="543px">
        <table border="0" cellpadding="0" cellspacing="0" id="TABLE4" runat="server" visible="true" width="370">
            <tr>
                <td colspan="2" id="TD2" runat="server">
                    <asp:Label ID="Label3" runat="server" Text="DATOS DE LA PERSONA" CssClass="subHeader" Font-Size="Small"></asp:Label>


                </td>
            </tr>
            <tr>
                <%--<td style="width: 106px; text-align: right;" >--%>
                <td style="width: 106px;" colspan="2">
                    <asp:Label ID="Label4" runat="server" Text="Nombre:" Font-Size="Small" Font-Bold="true"></asp:Label>

                    <%--</td>
            <td style="width: 416px" >--%>
                    <asp:Label ID="lblNombre" runat="server" Font-Size="Small"></asp:Label></td>
            </tr>
            <tr>
                <%-- <td style="width: 106px; text-align: right;" >--%>
                <td style="width: 106px;" colspan="2">
                    <asp:Label ID="Label9" runat="server" Text="Cédula:" Font-Size="Small" Font-Bold="true"></asp:Label><%--</td>
            <td style="width: 416px" >--%>
                    <asp:Label ID="lblCedula" runat="server" Font-Size="Small"></asp:Label></td>
            </tr>
        </table>

    </asp:Panel>
    <br />
    <asp:Panel ID="pnlPagos" runat="server" Visible="False" Width="543px">
        <asp:Label ID="Label11" runat="server" Font-Bold="True" Font-Size="Small" EnableViewState="False" Height="20px" Width="256px" CssClass="subHeader">DETALLE</asp:Label><br />
        <asp:GridView ID="gvPagoExcesoCiu" runat="server" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="descripcion" HeaderText="CONCEPTO" ItemStyle-Width="240px" />
                <asp:TemplateField HeaderText="VIA">
                    <ItemTemplate>
                        <asp:Label ID="lblCuenta" runat="server" Text='<%# Eval("nro_cuenta")%>' Font-Bold="true"></asp:Label>

                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="MONTO" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="80px">
                    <ItemTemplate>
                        <asp:Label ID="lblMonto" runat="server" Text='<%# Eval("monto")%>' Font-Bold="true"></asp:Label>

                    </ItemTemplate>
                </asp:TemplateField>
                <%--<asp:BoundField DataField="nro_cuenta" HeaderText="VIA" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Bold="true" />--%>
                <%--<asp:BoundField DataField="monto" HeaderText="MONTO" ControlStyle-Font-Bold="true" DataFormatString="{0:c}" ItemStyle-HorizontalAlign="Right" />--%>
            </Columns>
        </asp:GridView>




        <asp:Label ID="LblInfo" runat="server" Style="font-size: 10pt" Visible="false"></asp:Label>


    </asp:Panel>

    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
</asp:Content>

