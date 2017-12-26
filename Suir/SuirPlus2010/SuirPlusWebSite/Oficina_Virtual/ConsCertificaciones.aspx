<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ConsCertificaciones.aspx.vb" Inherits="Oficina_Virtual_ConsCertificaciones"  %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#navMenu").load("MenuOFV.html");
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="infoLibre" class="panel panel-primary Center" style="border-color: #EFEFEF;" runat="server">
        <div class="panel-heading" style="height: 32px;">
            <h4 id="Titulo">Consulta Certificaciones
            </h4>
        </div>
        <div class="panel-body">
            <table>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Nombre: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNombre" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Apellido: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblApellido" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">NSS: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNSS" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Fecha de Nacimiento: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblFechaNac" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <hr />
    <%-- <asp:UpdatePanel ID="upConsCertificacion" runat="server" UpdateMode="Always">
        <ContentTemplate>--%>   


    <asp:GridView ID="gvCertificaciones" runat="server" 
                  AutoGenerateColumns="False" OnRowCommand="gvCertificaciones_RowCommand"
                  ViewStateMode="Disabled" CssClass="table table-bordered"
                  style="max-width: 800px; width: 50%; margin: auto;" >
        <Columns>
            <asp:BoundField DataField="no_certificacion" HeaderText="Nro.">
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
            <asp:BoundField DataField="Estatus_Desc" HeaderText="Estatus"></asp:BoundField>
            <%--<asp:TemplateField HeaderText="Comentario">
                <ItemTemplate>
                    <asp:LinkButton ID="lbComentario" runat="server" CommandName="Ver" CommandArgument='<%# eval("ID_CERTIFICACION") & "|" & container.dataitem("Comentario")%>'>
                        <asp:Label ID="lblComentAjustado" runat="server" Text='<%# eval("Comentario")%>'></asp:Label>
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField> --%>
            <asp:BoundField DataField="Fecha_Certificacion" HeaderText="Fecha Creación" DataFormatString="{0:d}" HtmlEncode="False">
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <%--<asp:TemplateField>
                <ItemTemplate>
                    <a target="_blank" href=' <%# "verImagenCertificacion.aspx?idCertificacion=" & eval("ID_CERTIFICACION") %>'>[Documentos]</a>
                </ItemTemplate>
            </asp:TemplateField>--%>
            <asp:TemplateField HeaderText="Descargar" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <asp:ImageButton ID="ibDescargar" runat="server" ImageUrl="~/images/pdf.png" CommandName='<%# Eval("Estatus_Desc")%>' CommandArgument='<%# Eval("id_certificacion")%>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>





    <%--  </ContentTemplate>
    </asp:UpdatePanel>--%>
    <div id="dvError" class="panel panel-primary Center" style="border-color: #EFEFEF; display: none;" runat="server">
        <div class="panel-heading" style="height: auto; background-color: #fff">
            <h5 id="txtError" style="font: bold 14px arial; color: #FF2400;" runat="server"></h5>
        </div>
    </div>
    <hr />
    <div style="text-align: center">
        <asp:Button ID="btnRegresar" runat="server" CssClass="btn btn-primary" Text="Regresar" />
    </div>
</asp:Content>

