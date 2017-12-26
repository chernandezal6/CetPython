<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="empManejoArchivoPy.aspx.vb" Inherits="Empleador_empManejoArchivoPy" Title="Manejo de Archivos - SUIR Plus" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div id="Titulo" class="header" style="text-align: left">Envío&nbsp;de archivos</div>
    <table id="Table3" cellspacing="0">
        <tr>
            <td>
<%--                <div id="divImpersonar" style="height: 15px;">
                    <uc1:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
                </div>--%>
                <div style="width: 500px; text-align: justify">
                    <asp:Label ID="lblMensajeProceso" runat="server" CssClass="label-Blue"></asp:Label>
                </div>
                <br />
                <asp:Panel ID="pnlCargaArchivo" runat="server">
                    <table cellpadding="4" cellspacing="3" class="tblWithImagen"
                        style="width: 500px;">
                        <tr>
                            <td style="height: 12px;" class="listheadermultiline" colspan="2"></td>
                        </tr>
                        <tr>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td rowspan="2" style="width: 100px">
                                <img alt="archivo.jpg" height="80" src="../images/archivos.jpg" width="179" /></td>
                            <td>Tipo Proceso
                            <br />
                                <asp:DropDownList ID="ddlProceso" runat="server" CssClass="dropDowns">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td align="left" style="width: 100%">
                                <br />
                                Buscar Archivo<br />
                                <asp:FileUpload ID="fuArchivo" runat="server" />
                                &nbsp;<asp:LinkButton ID="lnkBtnCargarArchivo" runat="server"
                                    Font-Size="Medium">Cargar...</asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 100px"></td>
                            <td style="width: 100px"></td>
                        </tr>
                    </table>
                    <asp:RequiredFieldValidator ID="reqDdlTipoProceso" runat="server" ControlToValidate="ddlProceso"
                        CssClass="error" Display="Dynamic" ErrorMessage="Debe seleccionar el tipo de proceso." InitialValue="0"></asp:RequiredFieldValidator>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
                </asp:Panel>

                <br />

                <asp:Panel ID="pnlError" runat="server" Visible="False">
                    <table id="table1" border="0" class="tblWithImagen" width="485px;">
                        <tr>
                            <td align="center" class="listheadermultiline">&nbsp;Mensaje de Error
                            </td>
                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="center">&nbsp;
                            <asp:Button ID="btnErrorCargaArchivo" runat="server" Text="Volver atrás" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:Panel ID="pnlEstatus" runat="server" Visible="false">
                    <table id="Table2" cellspacing="0" class="tblWithImagen" style="width: 485px;">
                        <tr>
                            <td class="HeaderPopup" colspan="3">&nbsp;Estatus de Envio
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3"></td>
                        </tr>

                        <tr>
                            <td style="width: 15%;" rowspan="4">&nbsp;<img alt="status.jpg" height="55" src="../images/status_files.jpg" width="82" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 21%;">Número de Envío:
                            </td>
                            <td>&nbsp;<asp:Label ID="lblNumeroArchivo" runat="server" CssClass="subHeader"></asp:Label></td>
                        </tr>

                        <tr>
                            <td align="right" style="width: 21%;">&nbsp;<span>Nombre del Archivo:</span></td>
                            <td>&nbsp;<asp:Label ID="lblNombreArchivo" runat="server" CssClass="subHeader"></asp:Label></td>
                        </tr>
                        <tr>
                            <td align="right" style="width: 21%;">&nbsp;<span>Fecha de Carga:</span></td>
                            <td>&nbsp;<asp:Label ID="lblFechaCarga" runat="server" CssClass="subHeader"></asp:Label>
                            </td>

                        </tr>

                        <tr>
                            <td colspan="3">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="3">&nbsp;Nota: Verifique los resultados de su envío en 5 minutos.
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="3" align="center" style="height: 10px;">
                                <asp:LinkButton ID="lnkBtnCerrar" runat="server"><img alt="cancel" height="12" src="../images/cancel.gif" />&nbsp;Cerrar Ventana</asp:LinkButton>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>

                <asp:Button ID="Magia" runat="server" CssClass="Magia" />

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

