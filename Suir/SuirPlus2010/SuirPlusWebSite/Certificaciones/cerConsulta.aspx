<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="cerConsulta.aspx.vb" Inherits="Certificaciones_cerConsulta" Title="Consulta de certificación - TSS" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc2" %>

<%@ Register TagPrefix="uc1" TagName="UC_DatePicker" Src="../Controles/UC_DatePicker.ascx" %>

<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <script language="javascript" type="text/javascript">

        function modelesswin(url) {
            //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px")            
            newwindow = window.open(url, '', 'height=1300px,width=800px,left=400,top=200');
            newwindow.print();
        }

        $(function pageLoad(sender, args) {
            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
            $(".fecha").datepicker($.datepicker.regional['es']);
        });

        var newwindow;
        function poptastic(url) {
            newwindow = window.open(url, 'Editar_Certificación', 'height=400,width=600,left=400,top=200');
            if (window.focus) { newwindow.focus() }
        }

    </script>
    <div class="header" align="left">Consulta&nbsp;de Certificación</div>
    <br />



    <table class="td-content" cellspacing="0" cellpadding="0" width="500px" border="0">

        <tr valign="middle">
            <td align="right" nowrap="nowrap">&nbsp;
            </td>
            <td>&nbsp;</td>
            <td align="right" nowrap="nowrap">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right" nowrap="nowrap">Nro. Certificación:</td>
            <td>
                <asp:TextBox ID="txtNumero" runat="server" MaxLength="10" Width="75px"></asp:TextBox>
                <br />
                <%--                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                    ControlToValidate="txtNumero" Display="Dynamic" ErrorMessage="Solo Números"
                    ValidationExpression="\d*"></asp:RegularExpressionValidator>--%>
            </td>
            <td align="right" nowrap="nowrap">RNC o Cédula:</td>
            <td>
                <asp:TextBox ID="txtRnc" runat="server" MaxLength="11" Width="128px"></asp:TextBox>
                <br />
                <asp:RegularExpressionValidator ID="Regularexpressionvalidator2" runat="server"
                    ControlToValidate="txtRnc" Display="Dynamic" ErrorMessage="Solo Números"
                    ValidationExpression="\d*"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr valign="middle">
            <td align="right" nowrap="nowrap">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right" nowrap="nowrap">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right">Cédula:
            </td>
            <td>
                <asp:TextBox ID="txtCedula" runat="server" MaxLength="11" Width="75px"></asp:TextBox>
                <br />
                <asp:RegularExpressionValidator ID="Regularexpressionvalidator3"
                    runat="server" ControlToValidate="txtCedula" ErrorMessage="Solo Números"
                    ValidationExpression="\d*" Display="Dynamic"></asp:RegularExpressionValidator>
            </td>
            <td align="right">Estatus:</td>
            <td>
                <asp:DropDownList ID="dlEstatus" runat="server" CssClass="dropDowns">
                </asp:DropDownList>
            </td>
        </tr>
        <tr valign="middle">
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
            <td align="right">&nbsp;</td>
            <td>&nbsp;</td>
        </tr>
        <tr valign="middle">
            <td align="right">Fecha Inicial:
            </td>
            <td>
                <asp:TextBox ID="txtDesde" runat="server" Width="75px" CssClass="fecha"></asp:TextBox>
            </td>
            <td align="right" nowrap="nowrap">Fecha Final:</td>
            <td>
                <asp:TextBox ID="txtHasta" runat="server" Width="75px" CssClass="fecha"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td valign="bottom" align="center" colspan="4">
                <br />
                &nbsp;
						<asp:Button ID="btnConsultar" runat="server" Text="Consultar"></asp:Button>&nbsp;
						<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:Button><br />
                <br />
            </td>
        </tr>
    </table>
    <br />
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
    <asp:UpdatePanel ID="upConsCertificacion" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:GridView ID="gvCertificaciones" runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="ID_CERTIFICACION" HeaderText="Nro.">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Tipo" HeaderText="Tipo" />

                                <asp:BoundField DataField="Estatus_Desc" HeaderText="Estatus"></asp:BoundField>

                                <asp:TemplateField HeaderText="Comentario">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbComentario" runat="server" CommandName="Ver" CommandArgument='<%# eval("ID_CERTIFICACION") & "|" & container.dataitem("Comentario")%>'>
                                            <asp:Label ID="lblComentAjustado" runat="server" Text='<%# eval("Comentario")%>'></asp:Label>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="razon_social" HeaderText="Raz&#243;n Social">
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ID_NSS" HeaderText="NSS">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="NOMBRE" HeaderText="Nombre">
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Fecha" HeaderText="Registro" DataFormatString="{0:d}" HtmlEncode="False">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="USUARIO" HeaderText="Creada Por">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Ult_Usuario" HeaderText="Modificada Por">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:Label ID="lblActualizar" runat="server">
                     <a href="javascript:poptastic('EditCertificacion.aspx?codCert=<%#DataBinder.Eval(Container.DataItem,"ID_CERTIFICACION") %>');">[Actualizar]</a> 
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblprint" runat="server">
                     &nbsp;<a href="javascript:modelesswin('verCertificacion.aspx?codCert=<%#DataBinder.Eval(Container.DataItem,"ID_CERTIFICACION") %>&F=Hjndb1')">[Imprimir]</a>&nbsp;
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <a target="_blank" href=' <%# "verImagenCertificacion.aspx?idCertificacion=" & eval("ID_CERTIFICACION") %>'>[Documentos]</a>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbEntregar" runat="server" CommandName="Entregar" CommandArgument='<%# eval("ID_CERTIFICACION")%>'>
                                            <asp:Label ID="lblEntregar" runat="server"></asp:Label>
                                        </asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Descargar" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ibDescargar" runat="server" ImageUrl="~/images/pdf.png" CommandName='<%# Eval("Estatus_Desc")%>' CommandArgument='<%# Eval("id_certificacion")%>' />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>

                        <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
                            <table cellpadding="0" cellspacing="0" width="550px">
                                <tr>
                                    <td style="height: 24px">
                                        <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                                            OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                    [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                    <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                    <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                        <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                        Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                       
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <br />

                    </td>
                </tr>
            </table>

            <table width="400px">
                <tr>
                    <td>
                        <div id="divComentario" runat="server" align="center" visible="false">
                            <fieldset>
                                <legend>Comentario</legend>
                                <div align="left">
                                    <asp:Label ID="lblIdCertComentario" runat="server" CssClass="labelData"></asp:Label>
                                </div>
                                <br />

                                <asp:TextBox ID="txtComentario" runat="server" Height="40px" Width="360px"></asp:TextBox>
                                <br />
                            </fieldset>
                        </div>


                        <div id="divEntregar" align="center" runat="server" visible="false">
                            <fieldset id="fsEntregarCertificion" style="width: auto">

                                <legend>Entregar Certificación</legend>
                                <div align="left">
                                    <asp:Label ID="lblIdCertComentEntrega" runat="server" CssClass="labelData"></asp:Label>
                                </div>
                                <asp:Label ID="lblComentarioEntrega" runat="server" Text="Comentario"></asp:Label>
                                <asp:TextBox ID="txtComentarioEntrega" runat="server" Height="72px" TextMode="MultiLine"
                                    Width="98%"></asp:TextBox>

                                <br />
                                <br />

                                <asp:Button ID="btnEntregar" runat="server" Text="Entregar Certificación" />

                                &nbsp;
            <asp:Button ID="btnCancelarEntrega" runat="server" CausesValidation="False"
                Text="Cancelar" />

                            </fieldset>
                        </div>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
     <uc3:ucExportarExcel ID="ucExportarExcel1" runat="server" Visible="false" />
</asp:Content>

