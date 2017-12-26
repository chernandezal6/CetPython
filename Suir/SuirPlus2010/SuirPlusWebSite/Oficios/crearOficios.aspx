<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="crearOficios.aspx.vb" Inherits="Oficios_crearOficios" Title="Creación de Oficios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <% If 1 = 2 Then
    %>
    <script src="../Script/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../Script/jquery-ui-1.8.11.custom.min.js" type="text/javascript"></script>
    <%
    End If
    %>
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		
            Me.PermisoRequerido = 55
			
        End Sub
    </script>
    <script language="javascript" type="text/javascript">

        function modelesswin(url) {
            window.open(url, "", "width=800px,height=1300px").print();
        }

        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

        function UploadValidate() {

            for (var i = 1; i < 11; i++) {
                var fileName = document.getElementById("ctl00_MainContent_FileUp" + i).value;
                var ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
                var name = fileName.substring(fileName.lastIndexOf('\\') + 1)
                if (ext != "") {
                    if (ext == "doc" || ext == "docx" || ext == "xls" || ext == "xlsx" || ext == "jpg" || ext == "jpeg" || ext == "png" || ext == "gif" || ext == "tiff" || ext == "tif" || ext == "pdf") {
                        $("#ctl00_MainContent_btnAceptar").disabled = false;
                        $("#ctl00_MainContent_lblMsg").html("")
                        $("#ctl00_MainContent_OcultaResultado").val("false");
                    }
                    else {
                        $("#ctl00_MainContent_btnAceptar").disabled = true;
                        $("#ctl00_MainContent_OcultaResultado").val("true");
                        $("#ctl00_MainContent_lblMsg").html("El Formato de archivo " + name + " desconocido.")
                        $("#ctl00_MainContent_lblMsg").css('color', 'RED');
                        break;
                    }
                }
            }

        }

        function Resultado() {
            var Booleano = $("#ctl00_MainContent_OcultaResultado").val();

            if (Booleano == "true") {
                return false;
            }
            else {
                return true;
            }
        }


    </script>
    <script type="text/javascript">

        function Check_Click(objRef) {
            //Get the Row based on checkbox
            var row = objRef.parentNode.parentNode;

            //Get the reference of GridView
            var GridView = row.parentNode;

            //Get all input elements in Gridview
            var inputList = GridView.getElementsByTagName("input");

            for (var i = 0; i < inputList.length; i++) {
                //The First element is the Header Checkbox
                var headerCheckBox = inputList[0];

                //Based on all or none checkboxes
                //are checked check/uncheck Header Checkbox
                var checked = true;
                if (inputList[i].type == "checkbox" && inputList[i] != headerCheckBox) {
                    if (!inputList[i].checked) {
                        checked = false;
                        break;
                    }
                }
            }
            headerCheckBox.checked = checked;

        }
        function checkAll(objRef) {
            var GridView = objRef.parentNode.parentNode.parentNode;
            var inputList = GridView.getElementsByTagName("input");
            for (var i = 0; i < inputList.length; i++) {
                var row = inputList[i].parentNode.parentNode;
                if (inputList[i].type == "checkbox" && objRef != inputList[i]) {
                    if (objRef.checked) {
                        inputList[i].checked = true;
                    }
                    else {
                        if (row.rowIndex % 2 == 0) {
                            row.style.backgroundColor = "#C2D69B";
                        }
                        else {
                            row.style.backgroundColor = "white";
                        }
                        inputList[i].checked = false;
                    }
                }
            }
        }

        function ChangeDropDown() {
            $('.sizeText').val("");
        }

    </script>
    <style>
        .sizeText {
            font-size: 10pt;
        }
    </style>
    <span class="header">Creación de Oficios</span>
    <br />
    <asp:UpdatePanel runat="server" ID="Up1" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:HiddenField ID="OcultaResultado" runat="server" Value="false" />
            <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="Small"></asp:Label>
            <asp:HiddenField ID="resultadoFecha" runat="server" />
            <!-- Panel de creacion de oficios -->
            <asp:Panel ID="pnlForm" runat="server">
                <table>
                    <tr>
                        <td class="header"></td>
                    </tr>
                    <tr>
                        <td>
                            <table class="td-content" cellspacing="2" cellpadding="2" style="width: 450px">
                                <tr>
                                    <td colspan="2"></td>
                                </tr>
                                <tr>
                                    <td valign="top">A:
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="lblDestinatario" runat="server"></asp:Label></b><br />
                                        Tesorero de la Seguridad Social:
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">DE:
                                    </td>
                                    <td>
                                        <b>
                                            <asp:Label ID="lblRemitente" runat="server"></asp:Label>
                                        </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top">Acción:
                                    </td>
                                    <td valign="top">
                                        <asp:DropDownList ID="ddAcciones" runat="server" AutoPostBack="True" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        &nbsp;<font color="red">*</font>&nbsp;
                                        <asp:DropDownList ID="ddSeleccion" runat="server" Visible="False" AutoPostBack="True"
                                            CssClass="dropDowns">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr runat="server" id="trEmpleador" visible="False">
                                    <td valign="top">
                                        <asp:Label ID="lblRNC" runat="server" Text="Empleador<br />(RNC o Cédula)" />
                                    </td>
                                    <td valign="top">
                                        <asp:TextBox ID="txtRncCedula" runat="server" MaxLength="11" CausesValidation="True"
                                            AutoPostBack="True"></asp:TextBox>&nbsp;<font class="label"><font color="red">*</font>&nbsp;
                                                <asp:RequiredFieldValidator ID="rfvRnc" runat="server" CssClass="error" Display="Dynamic"
                                                    ControlToValidate="txtRncCedula" ErrorMessage="Debe ingresar el RNC o Cédula del empleador."
                                                    EnableViewState="False" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" CssClass="error"
                                                    ControlToValidate="txtRncCedula" ErrorMessage="RNC o Cédula invalido." ValidationExpression="^(\d{9}|\d{11})$"
                                                    EnableViewState="False" SetFocusOnError="True"></asp:RegularExpressionValidator></font>
                                    </td>
                                </tr>
                                <tr id="tr_sector_salarial" runat="server" visible="false">
                                    <td>
                                        <asp:Label ID="lblSector_Salarial" runat="server" Text="Sector Salarial" />
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddSector_Salarial" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <%--<tr runat="server" id="trCiudadano" visible="false">
							<td style="WIDTH: 111px" valign="top">
							    <asp:label id="lblNSS" runat="server" text="NSS" />
							</td>
							<td valign="top" style="width: 540px">
								<asp:textbox id="txtNSS" runat="server" onKeyPress="checkNum()" causesvalidation="True" autopostback="true"></asp:textbox>&nbsp;<font class="label"><font color="red">*</font>&nbsp;
									<asp:requiredfieldvalidator id="Requiredfieldvalidator1" runat="server" CssClass="error" Display="Dynamic" ControlToValidate="txtNSS"
										ErrorMessage="Debe ingresar el NSS del ciudadano." enableviewstate="False" setfocusonerror="True"></asp:requiredfieldvalidator>
                                    </font></td>
						</tr>--%>
                                <tr> 
                                    <td colspan="2">
                                        <asp:Panel ID="pnlFechas" runat="server" Width="100%" Visible="false">
                                            <table border="0" cellpadding="2" cellspacing="2">
                                                <tr>
                                                    <td colspan="2">Calcular recargo hasta periodo:
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="top">Mes&nbsp;
                                                        <asp:DropDownList ID="ddMesPeriodo" runat="server" CssClass="dropDowns">
                                                            <asp:ListItem Value="-1">-- Seleccione un Mes --</asp:ListItem>
                                                            <asp:ListItem Value="01">Enero</asp:ListItem>
                                                            <asp:ListItem Value="02">Febrero</asp:ListItem>
                                                            <asp:ListItem Value="03">Marzo</asp:ListItem>
                                                            <asp:ListItem Value="04">Abril</asp:ListItem>
                                                            <asp:ListItem Value="05">Mayo</asp:ListItem>
                                                            <asp:ListItem Value="06">Junio</asp:ListItem>
                                                            <asp:ListItem Value="07">Julio</asp:ListItem>
                                                            <asp:ListItem Value="08">Agosto</asp:ListItem>
                                                            <asp:ListItem Value="09">Septiembre</asp:ListItem>
                                                            <asp:ListItem Value="10">Octubre</asp:ListItem>
                                                            <asp:ListItem Value="11">Noviembre</asp:ListItem>
                                                            <asp:ListItem Value="12">Diciembre</asp:ListItem>
                                                        </asp:DropDownList>
                                                        &nbsp;Año&nbsp;
                                                        <asp:DropDownList ID="ddAnioPeriodo" runat="server" CssClass="dropDowns">
                                                        </asp:DropDownList>
                                                        <br />
                                                        <span style="color: navy;">Seleccione 06/2003 para cancelar todos los recargos.</span>
                                                    </td>
                                                </tr>
                                </tr>
                            </table>
            </asp:Panel>
            <asp:Panel ID="pnlPeriodos" runat="server" Width="100%" Visible="false">
                <table border="0" cellpadding="2" cellspacing="2">
                    <tr>
                        <td colspan="2">Seleccione el Periodo:
                        </td>
                    </tr>
                    <tr>
                        <td valign="top">Mes&nbsp;
                            <asp:DropDownList ID="ddMesPeriodo2" runat="server" CssClass="dropDowns">
                                <asp:ListItem Value="-1">-- Seleccione un Mes --</asp:ListItem>
                                <asp:ListItem Value="01">Enero</asp:ListItem>
                                <asp:ListItem Value="02">Febrero</asp:ListItem>
                                <asp:ListItem Value="03">Marzo</asp:ListItem>
                                <asp:ListItem Value="04">Abril</asp:ListItem>
                                <asp:ListItem Value="05">Mayo</asp:ListItem>
                                <asp:ListItem Value="06">Junio</asp:ListItem>
                                <asp:ListItem Value="07">Julio</asp:ListItem>
                                <asp:ListItem Value="08">Agosto</asp:ListItem>
                                <asp:ListItem Value="09">Septiembre</asp:ListItem>
                                <asp:ListItem Value="10">Octubre</asp:ListItem>
                                <asp:ListItem Value="11">Noviembre</asp:ListItem>
                                <asp:ListItem Value="12">Diciembre</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;Año&nbsp;
                            <asp:DropDownList ID="ddAnioPeriodo2" runat="server" CssClass="dropDowns">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    </tr>
                </table>
            </asp:Panel>
            </td> </tr>
            <tr>
                <td valign="top">Observación:
                </td>
                <td valign="top">
                    <asp:TextBox ID="txtObservacion" runat="server" TextMode="MultiLine" Height="56px"
                        Width="99%"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="2"></td>
            </tr>
            <tr>
                <td valign="top" colspan="2">
                    <font color="#ff0000">*</font>Información Obligatoria.
                </td>
            </tr>
            </table>
            <br />
            <asp:Panel ID="pnlMotivo" runat="server" Visible="false" Width="100%">
                <table class="td-content" id="table1" cellspacing="0" cellpadding="0" style="width: 450px">
                    <tr>
                        <td colspan="2" class="subHeader" style="height: 17px">Seleccione un Motivo:
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="height: 9px"></td>
                    </tr>
                    <tr>
                        <td colspan="2" style="height: 38px">
                            <asp:RadioButtonList ID="rbMotivos" RepeatDirection="Vertical" runat="server" RepeatLayout="Table"
                                DataTextField="TEXTO_MOTIVO" DataValueField="ID_MOTIVO">
                            </asp:RadioButtonList>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlRepresentantes" runat="server" Visible="false" Width="100%">
                <asp:GridView ID="gvRepresentantes" AutoGenerateColumns="False" runat="server" Width="450px">
                    <Columns>
                        <asp:TemplateField HeaderText="Cedula" ItemStyle-CssClass="Horizontal">
                            <%--ItemStyle-HorizontalAlign="Justify" ItemStyle-Width="50px" >--%>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkRepresentates" runat="server" Text='<%# Eval("NO_DOCUMENTO")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="Horizontal" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="ID_NSS" HeaderText="Cedula"></asp:BoundField>
                        <asp:BoundField DataField="NOMBRE" HeaderText="Nombre del Representante"></asp:BoundField>
                    </Columns>
                </asp:GridView>
            </asp:Panel>
            <br />
            <asp:Panel ID="PnlDocumentos" runat="server" Visible="false" Width="100%">
                <table class="td-content" cellspacing="0" cellpadding="0" style="width: 450px">
                    <tr>
                        <td colspan="2" class="subHeader" style="height: 17px">Documentos de Trabajadores
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="height: 9px">Seleccione cantidad de documentos:
                            <asp:DropDownList ID="ddlCantidadDocumentos" CssClass="dropDowns" runat="server"
                                AutoPostBack="True">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr valign="middle">
                        <td id="tdDocumentos" runat="server"></td>
                        <td id="tdInformacionDocumento" runat="server" style="font-size: 8pt; font-weight: bold; color: Blue;"></td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlCancelacionNSS" runat="server">
                <table class="td-content" cellspacing="0" cellpadding="0" style="width: 450px">
                    <tr>
                        <td colspan="2" class="subHeader" style="height: 17px">Cancelacion de NSS:
                        </td>
                    </tr>
                    <tr>
                        <td>Seleccione Nómina:<asp:DropDownList ID="ddlNominas" runat="server" CssClass="dropDowns"
                            AutoPostBack="true">
                        </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                            <asp:GridView ID="gvCancelacionNSS" runat="server" AutoGenerateColumns="false">
                                <Columns>
                                    <asp:TemplateField>
                                        <HeaderTemplate>
                                            <asp:CheckBox ID="chkAll" runat="server" onclick="checkAll(this);" AutoPostBack="true"
                                                OnCheckedChanged="CheckBox_CheckChanged" />
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chk" runat="server" onclick="Check_Click(this)" AutoPostBack="true"
                                                OnCheckedChanged="CheckBox_CheckChanged" />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ID_NSS" HeaderText="NSS" HtmlEncode="false" />
                                    <asp:BoundField DataField="NOMBRES" HeaderText="Nombres" HtmlEncode="false" />
                                    <asp:BoundField DataField="APELLIDOS" HeaderText="Apellidos" HtmlEncode="false" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <br />
                            <asp:GridView ID="gvSeleccion" runat="server" AutoGenerateColumns="false">
                                <Columns>
                                    <asp:BoundField DataField="ID_NSS" HeaderText="NSS" />
                                    <asp:BoundField DataField="NOMBRES" HeaderText="NOMBRES" />
                                    <asp:BoundField DataField="APELLIDOS" HeaderText="APELLIDOS" />
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td id="trPaginacion" runat="server">
                            <asp:LinkButton ID="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                CommandName="First" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                            <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion"
                                Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                            Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                            <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                            <asp:LinkButton ID="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                CommandName="Next" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                            <asp:LinkButton ID="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                CommandName="Last" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                            <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            <br />
                            Total de registros&nbsp;
                            <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server" />
                        </td>
                    </tr>
                    <tr id="trTodos" runat="server" visible="false">
                        <td>
                            <asp:CheckBox ID="chkTodos" runat="server" AutoPostBack="true" />&nbsp;Seleccionar
                            todos los empleados
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlNotificacionPago" runat="server" Visible="false" Width="100%">
                <table class="td-content" style="width: 480px">
                    <tr>
                        <td valign="top" colspan="2" style="height: 28px;">
                            <table cellspacing="1" cellpadding="0" width="100%" border="0">
                                <tr>
                                    <td colspan="5" class="subHeader" style="height: 17px">Notificaciones de Pago
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 9px"></td>
                                </tr>
                                <tr class="listHeader">
                                    <td style="width: 4%; height: 12px;">&nbsp;
                                    </td>
                                    <td style="width: 10%; height: 12px;">&nbsp;Notificación
                                    </td>
                                    <td style="width: 60%; height: 12px;">&nbsp;Nómina
                                    </td>
                                    <td style="width: 28%; height: 12px;" align="right">&nbsp;Monto Original
                                    </td>
                                    <td style="width: 38%; height: 12px;" align="right">&nbsp;Recargos
                                    </td>
                                </tr>
                                <asp:DataList ID="dlNotificaciones" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
                                    <ItemTemplate>
                                        <tr class="listItem">
                                            <td>
                                                <asp:CheckBox runat="server" ID="chkMarcado" Checked="false" />
                                            </td>
                                            <td style="width: 20px">
                                                <asp:Label ID="lblNotificacion" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ID_REFERENCIA") %>' />
                                            </td>
                                            <td>
                                                <asp:Label ID="Label1" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"nominades") %>' />
                                            </td>
                                            <td align="right">
                                                <asp:Label ID="lblMonto" Visible="False" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MONTO_ORIGINAL")%>' />
                                                <%# formatnumber(DataBinder.Eval(Container.DataItem,"MONTO_ORIGINAL")) %>
                                            </td>
                                            <td align="right">
                                                <asp:Label Visible="False" ID="lblRecargo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"RECARGOS")%>' />
                                                <%# formatnumber(DataBinder.Eval(Container.DataItem,"RECARGOS")) %>
                                            </td>
                                            <td>
                                                <asp:Label Visible="False" ID="lblTipoFactura" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ID_TIPO_FACTURA")%>' />
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                    <AlternatingItemTemplate>
                                        <tr class="listAltItem">
                                            <td>
                                                <asp:CheckBox runat="server" ID="chkMarcado" Checked="false" />
                                            </td>
                                            <td style="width: 20px">
                                                <asp:Label ID="lblNotificacion" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ID_REFERENCIA") %>' />
                                            </td>
                                            <td>
                                                <asp:Label ID="Label2" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"nominades") %>' />
                                            </td>
                                            <td align="right">
                                                <asp:Label ID="lblMonto" Visible="False" runat="server" Text='<%# DataBinder.Eval(Container.DataItem,"MONTO_ORIGINAL")%>' />
                                                <%# formatnumber(DataBinder.Eval(Container.DataItem,"MONTO_ORIGINAL")) %>
                                            </td>
                                            <td align="right">
                                                <asp:Label Visible="False" ID="lblRecargo" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"RECARGOS")%>' />
                                                <%# formatnumber(DataBinder.Eval(Container.DataItem,"RECARGOS")) %>
                                            </td>
                                            <td>
                                                <asp:Label Visible="False" ID="lblTipoFactura" runat="server" Text='<%#DataBinder.Eval(Container.DataItem,"ID_TIPO_FACTURA")%>' />
                                            </td>
                                        </tr>
                                    </AlternatingItemTemplate>
                                </asp:DataList>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" colspan="2" style="width: 639px"></td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Panel ID="pnlCargaArchivo" runat="server" Visible="False">
                <table class="td-content" cellspacing="0" cellpadding="0" style="width: 450px">
                    <tr>
                        <td colspan="2" class="subHeader" style="height: 17px">Carga de Archivo:
                        </td>
                    </tr>
                    <td colspan="2" style="height: 9px">Seleccione el archivo:
                        <asp:FileUpload ID="upCargaArchivo" runat="server" />
                        <asp:RegularExpressionValidator ID="FileUpLoadValidator" runat="server" ErrorMessage="Solamente se permite extension (.txt)"
                            ValidationExpression=".*(\.txt|\.TXT)$" ControlToValidate="upCargaArchivo" Display="Dynamic"></asp:RegularExpressionValidator>
                    </td>
                </table>
                <br />
            </asp:Panel>
            <asp:Panel ID="pnlDocumentacionAdjunta" runat="server" Visible="false">
                <table class="td-content" cellspacing="0" cellpadding="0" style="width: 450px">
                    <tr>
                        <td colspan="2" class="subHeader" style="height: 17px">Documentación adjunta
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="height: 9px">Seleccione cantidad de archivos:
                            <asp:DropDownList ID="ddlCantidadAdjunto" CssClass="dropDowns" runat="server" AutoPostBack="true">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td id="tdCantidadAdjunto" style="height: 38px" colspan="2" runat="server"></td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlMostrarNSS" runat="server" Visible="false">
                <table class="td-content" cellspacing="0" cellpadding="0" style="width: 450px">
                    <tr>
                        <td colspan="2" class="subHeader" style="height: 17px">
                            <span class="MaskedEditBlurNegative">Archivo con errores, los siguientes NSS no están cancelados o no existen: </span>
                            <br />
                            <asp:ListBox ID="lstNSS" runat="server" Width="100px"></asp:ListBox>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                <tr>
                    <td style="height: 9px"></td>
                </tr>
                <tr>
                    <td valign="top" align="right" colspan="2" style="height: 17px">
                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" OnClientClick="return Resultado();"></asp:Button>&nbsp;&nbsp;
                        <asp:Button ID="btnCancelar" runat="server" Text="Limpiar"></asp:Button>
                    </td>
                </tr>
            </table>
            </td> </tr> </table> </asp:panel>
            <!-- Fin del panel de creación de oficios -->
            <!-- Panel de oficio creado -->
            <asp:Panel ID="pnlRecibo" runat="server" Visible="False">
                <br />
                <table class="td-content" cellspacing="0" cellpadding="0" width="470">
                    <tr>
                        <td>
                            <table cellspacing="0" cellpadding="0" width="100%" border="0">
                                <tr>
                                    <td class="subHeader">
                                        <div style="text-align: center">
                                            <br />
                                            El oficio fue generado satisfactoriamente<br />
                                            <br />
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <table cellspacing="0" cellpadding="0" width="100%" border="0">
                                            <tr>
                                                <td style="width: 1%">&nbsp;
                                                </td>
                                                <td style="width: 21%">Oficio No.
                                                </td>
                                                <td style="width: 2%">&nbsp;
                                                </td>
                                                <td style="width: 76%">
                                                    <asp:Label ID="lblOficioNo" runat="server" Font-Bold="True"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>RNC o Cédula
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblRncCedula" runat="server" Font-Bold="True"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>Acción
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblAccion" runat="server" Font-Bold="True"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>&nbsp;
                                                </td>
                                                <td>Generado Por
                                                </td>
                                                <td>&nbsp;
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblGeneradoPor" runat="server" Font-Bold="True"></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:HyperLink ID="hlVerDocumento" runat="server" NavigateUrl="javascript:modelesswin('oficioDoc.aspx')"><br />
                Ver Documento</asp:HyperLink>&nbsp;|
                                        <asp:LinkButton ID="lnkbtnNuevo" runat="server">Nuevo Oficio</asp:LinkButton>
                                        <div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <br />
                <br />
            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnAceptar" />
            <asp:PostBackTrigger ControlID="ddlCantidadAdjunto" />
            <asp:PostBackTrigger ControlID="gvCancelacionNSS" />

        </Triggers>
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
