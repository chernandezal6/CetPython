<%@ Page Title="Envio Novedades Rectroactivas" Language="VB" MasterPageFile="~/SuirPlus.master"
    AutoEventWireup="false" CodeFile="EnvioNovedadesRectroactivas.aspx.vb" Inherits="Afiliacion_EnvioNovedadesRectroactivas" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div id="Titulo" class="header" style="text-align: left">
        Envío&nbsp;de Novedades RectroActivas</div>
    <table id="Table3" cellspacing="0">
        <tr>
            <td>
                <div id="divImpersonar" style="height: 15px;">
                </div>
                <asp:Panel ID="pnlCargaArchivo" runat="server">
                    <table cellpadding="2" cellspacing="0" class="tblWithImagen" style="width: 425px;">
                        <tr>
                            <td style="height: 12px;" class="listheadermultiline" colspan="2">
                            </td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td rowspan="2" style="width: 100px">
                                <img alt="archivo.jpg" height="80" src="../images/archivos.jpg" width="179" />
                            </td>
                            <td>
                                <%--Tipo Proceso
                            <br />
                            <asp:DropDownList ID="ddlProceso" runat="server" CssClass="dropDowns">
                            </asp:DropDownList>--%>
                                RNC/Cedula:<br />
                                <asp:TextBox ID="txtRncCedula" runat="server" Width="117px" AutoPostBack="true"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 100%">
                                <br />
                                Buscar Archivo<br />
                                <asp:FileUpload ID="fuArchivo" runat="server" />
                                <asp:RegularExpressionValidator ID="fuArchivoValidator" runat="server" ErrorMessage="Solamente se permite extension (.txt)"
                                ValidationExpression=".*(\.txt|\.TXT)$" ControlToValidate="fuArchivo" Display="Dynamic"></asp:RegularExpressionValidator>
                                &nbsp;<asp:LinkButton ID="lnkBtnCargarArchivo" runat="server">Cargar...</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px">
                            </td>
                            <td style="width: 100px">
                            </td>
                        </tr>
                    </table>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
                </asp:Panel>
                <br />
                <asp:Panel ID="pnlRepresentantes" runat="server" Visible="false" Width="100%">
                    <asp:GridView ID="gvRepresentantes" AutoGenerateColumns="False" runat="server" Width="450px">
                        <Columns>
                            <asp:TemplateField HeaderText="Cedula" ItemStyle-CssClass="Horizontal">
                                <ItemTemplate>
                                    <asp:RadioButton ID="rbSelector" runat="server" Text='<%# Eval("NO_DOCUMENTO")%>'
                                        OnCheckedChanged="rbSelector_CheckedChanged" AutoPostBack="true" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="ID_NSS" HeaderText="Cedula"></asp:BoundField>
                            <asp:BoundField DataField="NOMBRE" HeaderText="Nombre del Representante"></asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
                <br />
                <asp:Panel ID="pnlError" runat="server" Visible="False">
                    <table id="table1" border="0" class="tblWithImagen" width="485px;">
                        <tr>
                            <td align="center" class="listheadermultiline">
                                &nbsp;Mensaje de Error
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                &nbsp;
                                <asp:Button ID="btnErrorCargaArchivo" runat="server" Text="Volver atrás" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Panel ID="pnlEstatus" runat="server" Visible="false">
                    <table id="Table2" cellspacing="0" class="tblWithImagen" style="width: 485px;">
                        <tr>
                            <td class="HeaderPopup" colspan="3">
                                &nbsp;Estatus de Envio
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 15%;" rowspan="4">
                                &nbsp;<img alt="status.jpg" height="55" src="../images/status_files.jpg" width="82" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 21%;">
                                Número de Envío:
                            </td>
                            <td>
                                &nbsp;<asp:Label ID="lblNumeroArchivo" runat="server" CssClass="subHeader"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 21%;">
                                &nbsp;<span>Nombre del Archivo:</span>
                            </td>
                            <td>
                                &nbsp;<asp:Label ID="lblNombreArchivo" runat="server" CssClass="subHeader"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 21%;">
                                &nbsp;<span>Fecha de Carga:</span>
                            </td>
                            <td>
                                &nbsp;<asp:Label ID="lblFechaCarga" runat="server" CssClass="subHeader"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                &nbsp;Nota: Verifique los resultados de su envío en 5 minutos.
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                &nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center" style="height: 10px;">
                                <asp:LinkButton ID="lnkBtnCerrar" runat="server" OnClientClick="location.reload();">
                                <img alt="cancel" height="12" src="../images/cancel.gif" />&nbsp;Cerrar Ventana</asp:LinkButton>
                                                               
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <asp:Button ID="Magia" runat="server" CssClass="Magia" />
               <%-- <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
                    OkControlID="lnkBtnCerrar" PopupControlID="pnlEstatus" TargetControlID="Magia"
                    OnOkScript="Ok()">
                </ajaxToolkit:ModalPopupExtender>--%>
                 <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" BackgroundCssClass="modalBackground"
                    OkControlID="lnkBtnCerrar" PopupControlID="pnlEstatus" TargetControlID="Magia" OnOkScript="Ok()">
                </ajaxToolkit:ModalPopupExtender>
            </td>
        </tr>
    </table>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
