<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaPinMDT.aspx.vb" Inherits="MDT_ConsultaPinMDT" %>




<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
   
    <span class="header">Consulta Pin MDT</span>
    <br />
    <br />
    <table cellpadding="0" cellspacing="0">
           <tr>
            <td>
               <%-- <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"
                    Font-Size="10pt"></asp:Label>--%>
                <br />
            </td>
            </tr>
        <tr>
            <td>
                <div style="float: left; width: auto;" id="divPin" runat="server" visible="false">
                    <fieldset>
                        <legend style="text-align: left">Balance disponible</legend>
                        <br />
                        <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"
                    Font-Size="10pt"></asp:Label>
                        <asp:GridView ID="gvPinMDT" runat="server" AutoGenerateColumns="False" CellPadding="3"
                            Style="width: 400px;">
                            <Columns>
                                <asp:BoundField DataField="recibo" HeaderText="Nro Recibo">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="codigo_aprobacion" HeaderText="Código Aprobación">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="representacion_local" HeaderText="Representación Local">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="monto_total" HeaderText="Monto Total">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="balance_disponible" HeaderText="Balance Disponible">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="Status" HeaderText="Estatus">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="fecha_pago" HeaderText="Fecha Pago" 
                                    DataFormatString="{0:d}" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                     </fieldset>
                </div>
            </td>
        </tr>
   
    <%--    --Historial de pagos--%>
        <tr>
            <td>
                <br />
                <br />
                <div style="float: left; width: auto;" id="divDet" runat="server" visible="false">
                    <fieldset>
                        <legend style="text-align: left">Historial de pagos</legend>
                        <br />
                        <asp:Label ID="LblErrorDet" runat="server" CssClass="error" EnableViewState="False"
                            Font-Size="10pt"></asp:Label>
                    </fieldset>
                </div>
            </td>
        </tr>
        <tr>
            <td>
            <br/>
             <br/>
                <div style="float: left; width: auto;" id="divDetPin" runat="server" visible="false">
                    <fieldset>
                        <legend style="text-align: left">Historial de pagos</legend>
                        <br />
                        <asp:GridView ID="gvDetPinMDT" runat="server" AutoGenerateColumns="False" CellPadding="3"
                            Style="width: 400px;">
                            <Columns>
                              <asp:BoundField DataField="recibo" HeaderText="Nro Recibo">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                               
                                <asp:BoundField DataField="codigo_aprobacion" HeaderText="Código Aprobación">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                  <asp:BoundField DataField="representacion_local" HeaderText="Representación Local">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <%--<asp:BoundField DataField="id_referencia" HeaderText="Nro Referencia">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="Nro Referencia">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# FormateaReferencia(eval("id_referencia")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="formulario" HeaderText="Formulario">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                               <asp:BoundField DataField="monto_pagado" HeaderText="Monto Pagado">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:BoundField>
                                   <asp:BoundField DataField="fecha_pago" HeaderText="Fecha Pago" 
                                    DataFormatString="{0:d}" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                                   <%--<asp:TemplateField HeaderText="Periodo">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("periodo_factura")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>--%>
                            </Columns>
                        </asp:GridView>
                        <table width="100%">
                        <tr>
                            <td>
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
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                                Total de registros&nbsp;
                                <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server" />
                            </td>
                        </tr>        
                    </table>
                    </fieldset>
                     
                </div>
            </td>
        </tr>
        </table>
        
</asp:Content>

