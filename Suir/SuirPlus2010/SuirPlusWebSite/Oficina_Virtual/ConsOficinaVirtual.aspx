<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ConsOficinaVirtual.aspx.vb" Inherits="Oficina_Virtual_ConsOficinaVirtual" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        //var Ruta = "http://" + location.host + "/Oficina_Virtual/"

        //function Redireccionar() {
        //    window.location.href = Ruta + "/OficinaVirtual.aspx?nro_documento="+;
        //}
        //$("#Regresar").click(function () {

        //});

        $(function () {
            var str = "<%= Request.QueryString("Tipo")%>";
            debugger;
            if(str == ""){
                $("#infoTitulo").show();
            }
            else{
                SelectCons(str);
            }
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="PanelCons">
        <div id="infoTitulo" class="panel panel-primary Center" style="border-color: #EFEFEF; display: none;" runat="server">
            <div class="panel-heading" style="text-align: center; height: 32px;">
                <h4 id="Titulo" runat="server">No selecciono ninguna consulta
                </h4>
            </div>
        </div>
    </div>
    
    <%--
    <hr/>    
    <div id="infoLibre" class="panel panel-primary Center" style="border-color: #EFEFEF;" runat="server">
        <div class="panel-heading" style="height: 32px;">
            <h4>
                Consulta Ciudadano
            </h4>
        </div>
        <div class="panel-body">
            <table>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Nombre: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNombre" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Apellido: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblApellido" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">NSS: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNSS" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Fecha de Nacimiento: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblFechaNac" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
            </table>    
        </div>
    </div>
    <div class="bs-example">
        
        <div class="center-block bs-example" data-example-id="bordered-table" style="max-width:800px; width:50%; margin:auto;">           
            <asp:GridView ID="gvNucleoFamiliar" runat="server" AutoGenerateColumns="False"
             Width="600px" EnableViewState="False" CssClass="table table-bordered">                   
                <Columns>
                    <asp:BoundField DataField="NOMBRES" HeaderText="Nombre">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="TIPO" HeaderText="Tipo">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PARENTESCO" HeaderText="Parentesco">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="ID_NSS" HeaderText="NSS">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>                    
                </Columns>
            </asp:GridView>       
        </div>
    </div>
    <hr />
    <div style="text-align:center">
        <asp:Button ID="btnRegresar" runat="server" CssClass="btn btn-primary" Text="Regresar"/>
    </div>--%>    
</asp:Content>

