<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="MenorAMayorCedulado.aspx.vb" Inherits="Mantenimientos_MenorAMayorCedulado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">

        function modelesswin(url) {
            //(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px");
            newwindow = window.open(url, '', 'height=1300px,width=800px');
            newwindow.print();
        }
        //var newwindow;
        //function poptastic(url) {
        //    newwindow = window.open(url, 'Editar_Documentos', 'height=300,width=500,left=400,top=200');
        //    if (window.focus) { newwindow.focus() }
        //}
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }
        function pageLoad(sender, args) {
            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));
            $(".fecha").datepicker($.datepicker.regional['es']);

            $(".dialog").dialog({
                bgiframe: true,
                autoOpen: false,
                height: 300,
                width: 350,
                modal: true
            });
            $('.resetClass').click(function () {
                $('.dialog').dialog('open');
                $('.dialog').parent().appendTo($("form"));
            });
        }
    </script>
    <style>
        .titulos {
            color: #006699;
            font-size: 13px;
            font-weight: bold;
        }
    </style>


    <div class="header">
        Evaluación de Menor a Mayor de Edad
    </div>
    <br />
    <div class="titulos">
        Registro Principal
    </div>
    <br />
    <table class="td-content" style="width: 350px" cellpadding="1" cellspacing="0">
        <tr>
            <td style="width: 35%"></td>
            <td style="width: 65%"></td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">No. Documento: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblNoDocumento" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Nombres: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblNombres" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Apellidos: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblApellidos" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Sexo: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblSexo" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Fecha de Nacimiendo: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblFechaN" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Municipio del Acta: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblMunicipioActa" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Año del Acta: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblAnoActa" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Numero de Acta: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblNumeroActa" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Folio de Acta: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblFolioActa" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Libro de Acta: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblLibroActa" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 20%">Oficialia: &nbsp;
            </td>
            <td align="left" style="width: 20%">
                <asp:Label ID="lblOficialia" CssClass="labelData" runat="server" Text=""></asp:Label>
            </td>
        </tr>
        <tr>
            <td style="width: 20%"></td>
            <td style="width: 65%">
                <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
            </td>
        </tr>
    </table>
    <br />
    <div>
        <asp:Button runat="server" ID="btnInsertarPadre" Text="Insertar Registro Principal"/>
    </div>
    <br />
    <div class="titulos">
        Lista de Concidencias
    </div>
    <br />
    <asp:UpdatePanel ID="upEmpleadores" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Panel ID="pnlGridEmpleadores" runat="server" Width="100%">
                <table id="Table1" cellpadding="5px" cellspacing="0" style="width: 90%">
                    <tr>
                        <td>
                            <asp:GridView ID="gvPadre" runat="server" AutoGenerateColumns="False" Width="85%" >
                                <Columns>
                                    <asp:BoundField DataField="ID_NSS" HeaderText="No. NSS">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NOMBRES" HeaderText="Nombres">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PRIMER_APELLIDO" HeaderText="Primer Apellido">
                                        <ItemStyle HorizontalAlign="Left" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SEGUNDO_APELLIDO" HeaderText="Segundo Apellido">
                                        <ItemStyle HorizontalAlign="Left" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="SEXO" HeaderText="Sexo">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FECHA_NACIMIENTO" DataFormatString="{0:d}" HtmlEncode="false" HeaderText="Fecha Nacimiento">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MUNICIPIO_ACTA" HeaderText="Municipio Acta">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ANO_ACTA" HeaderText="Año Acta">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NUMERO_ACTA" DataFormatString="{0:000}" HeaderText="Numero de Acta">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FOLIO_ACTA" HeaderText="Folio de Acta">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="LIBRO_ACTA" HeaderText="Libro de Acta">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="OFICIALIA_ACTA" HeaderText="Oficialía">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:TemplateField>
                                        <ItemStyle HorizontalAlign="Center" Wrap="False"/>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="btnCancelar" runat="server" CommandArgument='<%# Eval("ID_NSS")%>' CommandName="RE" Text="[Cancelar]"/>
                                            <asp:LinkButton ID="btnActualizar" runat="server" CommandArgument='<%# Eval("ID_NSS")%>' CommandName="OK" Text="[Actualizar]"/>
                                            <%--<asp:LinkButton ID="lnkVer" runat="server" CommandArgument='<%# Eval("ID_REGISTRO_PATRONAL") & "|" & Eval("RNC_O_CEDULA") %>'
                                                CommandName="Ver" Text="[Ver]">
                                            </asp:LinkButton>--%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                        </td>
                    </tr>
            </asp:Panel>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
</asp:Content>

