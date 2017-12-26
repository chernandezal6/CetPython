<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="Usuarios.aspx.vb" Inherits="Seguridad_Usuarios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <% If 1 = 2 Then
    %>
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>
    <script type="text/javascript">
        $(function () {
            $("#btnBuscar").button();
            $("#btnBuscar").click(function () {
                var Criterio = $("#txtBusqueda").val();
                console.log(Criterio);

                var Params = new Object();
                Params.pPageSize = 25;
                Params.pCurrentPage = 1;
                Params.pCriterio = Criterio;
                Params.pSortColumn = '';
                Params.pSortOrder = '';

                var ColNames = ['Usuario', 'Nombre', 'Estatus', 'Email'];
                var ColModel = [
                { name: '0', index: '0', sortable: false, width: 15, align: "center" },
                { name: '1', index: '1', sortable: false, width: 40, align: "left" },
                { name: '2', index: '2', sortable: false, width: 15, align: "center" },
                { name: '3', index: '3', sortable: false, width: 30, align: "left" }
            ];

                Util.Grid('ModuloSeguridad.asmx', 'listarUsuarios', 'Usuarios', 'UsuariosPager', ColNames, ColModel, Params, 'Usuarios', 25);
                $("#Usuarios").jqGrid().trigger("reloadGrid");

            });
        });








//            $("#btnBuscar").button();
//            $("#btnBuscar").click(function () {
//                if ($("#txtBusqueda").val() != "") {
//                    var Parametros = {
//                        pPageSize: 25,
//                        pCurrentPage: 1,
//                        pCriterio: $("#txtBusqueda").val(),
//                        pSortColumn: '',
//                        pSortOrder: ''
//                    };

//                    BuscarUsuarios(Parametros);
//                }
//            });
//        });

//        function BuscarUsuarios(Params) {

//            console.log('antes del refresh');
//            $("#btnBuscar").click(function () {
//                if (Params.pCriterio != $("#txtBusqueda").val()) {
//                    Params.pCriterio = $("#txtBusqueda").val();
//                    filtrarUsuarios();
//                }
//            });

//            function filtrarUsuarios() {
//                            
//              //  Params.pCriterio = $("#txtBusqueda").val();
//               $("#Usuarios").jqGrid().trigger("reloadGrid");
//            }
//            var ColNames = ['Usuario', 'Nombre', 'Estatus', 'Email'];
//            var ColModel = [
//                { name: '0', index: '0', sortable: false, width: 15, align: "center" },
//                { name: '1', index: '1', sortable: false, width: 40, align: "left" },
//                { name: '2', index: '2', sortable: false, width: 15, align: "center" },
//                { name: '3', index: '3', sortable: false, width: 30, align: "left" }
//            ];

//            Util.Grid('ModuloSeguridad.asmx', 'listarUsuarios', 'Usuarios', 'UsuariosPager', ColNames, ColModel, Params, 'Usuarios', 25);
// 
//        }



    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <span class="header">Usuarios</span>
    <br />
    <table>
        <tr>
            <td>
                <table class="td-busqueda">
                    <tr>
                        <td>
                            <input type="text" placeholder="Ingrese criterio de busqueda..." id="txtBusqueda"
                                value="" style="width: 200px; height: 25px;" />
                            <%--<input id="btnBuscar" type="button" value="Buscar" />--%>
                            <span id="btnBuscar" title="Buscar">Buscar</span>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <br />
    <table id="Usuarios">
    </table>
    <div id="UsuariosPager">
    </div>
</asp:Content>
