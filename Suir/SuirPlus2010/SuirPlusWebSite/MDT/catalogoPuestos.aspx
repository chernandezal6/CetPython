<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="catalogoPuestos.aspx.vb" Inherits="MDT_catalogoPuestos" %>

    <%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="~/Controles/ucExportarExcel.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <br />
    <% If 1 = 2 Then
    %>
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>
    <script type="text/javascript">


        $(function () {


            var Params = {
                pPageSize: 25,
                pCurrentPage: 1,
                pCriterio: $("#txtBusqueda").val(),
                pSortColumn: '',
                pSortOrder: ''
            };

            function filtrarPuestos() {
                Params.pCriterio = $("#txtBusqueda").val();
                $("#Ocupaciones").jqGrid().trigger("reloadGrid");
            }
            var ColNames = ['Id', 'Descripción'];
            var ColModel = [
                { name: '0', index: '0', sortable: false, width: 20, align: "center" },
                { name: '1', index: '1', sortable: false }
            ];

            Util.Grid('MDT.asmx', 'getPuestos', 'Ocupaciones', 'OcupacionesPager', ColNames, ColModel, Params, 'Ocupaciones', 25);

            $("#txtBusqueda").keyup(filtrarPuestos);
            

        });


    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <span class="header">Catálogo de Puestos</span>
    <br />
    <table>
        <tr>
            <td>
                <table class="td-content">
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" placeholder="Ingrese criterio de busqueda..." id="txtBusqueda"
                                value="" style="width: 200px; height: 25px;" />
                            <img src="../images/zoom.png" id="imgBuscar" />
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
    <br />
    <table id="Ocupaciones">
    </table>
    <div id="OcupacionesPager">
    </div>
    <br />
      <uc1:ucExportarExcel ID="UcExp" runat="server"/>
</asp:Content>
