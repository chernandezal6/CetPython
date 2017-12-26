<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ConsAfiliacionARS.aspx.vb" Inherits="Oficina_Virtual_ConsAfiliacionARS" %>
<asp:Content ID="Content3" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#navMenu").load("MenuOFV.html");
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="infoLibre" class="panel panel-primary Center" style="border-color: #EFEFEF;" runat="server">
        <div class="panel-heading" style="height: 32px;">
            <h4>
                Afiliación ARS
            </h4>
        </div>
        <div class="panel-body">
            <table>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Nombre: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNombre" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">ARS: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblARS" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Estatus: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblStatus" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trAfiliado1" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Tipo Afiliación: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblTipoAfiliacion" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trAfiliado2" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Fecha Afiliación: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblFechaAfiliacion" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trSolicitud1" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Tipo Solicitud: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblTipoSolicitud" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trSolicitud2" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Fecha Solicitud: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblFechaSolicitud" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
            </table>    
        </div>
    </div>
    <hr />
    <div class="bs-example">
        <div class="center-block bs-example" data-example-id="bordered-table" style="max-width: 800px; width: 50%; margin: auto;">
            <asp:GridView ID="gvNucleoFamiliar" runat="server" AutoGenerateColumns="False"
                Width="600px" EnableViewState="False" CssClass="table table-bordered">
                <Columns>
                    <asp:BoundField DataField="NOMBRE" HeaderText="Nombres">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
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
                    <asp:BoundField DataField="ESTATUS" HeaderText="NSS">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
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
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
    <div id="dvError" class="panel panel-primary Center" style="border-color: #EFEFEF; display:none;" runat="server">
        <div class="panel-heading" style="height: auto; background-color:#fff">
            <h5 id="txtError" style="font: bold 14px arial; color: #FF2400;" runat="server">
               
            </h5>
        </div>
    </div>
    <hr />
    <div style="text-align: center">
        <asp:Button ID="btnRegresar" runat="server" CssClass="btn btn-primary" Text="Regresar" />
    </div>
</asp:Content>

