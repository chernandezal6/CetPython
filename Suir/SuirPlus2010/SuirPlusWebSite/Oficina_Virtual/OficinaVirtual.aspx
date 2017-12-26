<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="OficinaVirtual.aspx.vb" Inherits="Oficina_Virtual_OficinaVirtual" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
        <script type="text/javascript">
            $(function () {
                $("#navMenu").load("MenuOFV.html");
                $("#btnGrCertificacion").click(function () {
                    $("#myModal").modal('show');
                });
            });
        </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <!-- Div que contiene todo el cuerpo de la página -->
    <div style="margin: auto; width: 80%;">
        <div style="text-align: -webkit-left; padding-left: 20px;">
            <h1 style="margin: 0;">Consultas del Seguro Familiar de Salud</h1>
            <hr style="float: left;" />
        </div>
        <table style="margin-left: 10px; width: 100%;">
        <tr>
            <td>
                <div style="margin-left: 10px">
                    <div class="row">
                        <div class="col-sm-6 col-md-4" style="width: 200px";>
                            <div class="thumbnail Sombras">
                                <img src="../images/enLinea.jpg" alt="...">
                                <div class="caption">
                                    <h4 id="leyenda3">Afiliación ARS</h4>
                                    <span style="font-size: 12px">Indica en cual ARS se encuentra afiliado actualmente y su nucleo familiar.</span>
                                    <br />
                                    <br />                                    
                                </div>
                                <div class="footerButton">
                                    <asp:Button ID="btnAfiliacionARS" runat="server" Text="Ver" CssClass="btn btn-primary" />
                                        </div>
                            </div>
                        </div>
                    </div>
                </div>
            </td>  
            <td>
                <div style="margin-left: 10px">
                    <div class="row">
                        <div class="col-sm-6 col-md-4" style="width: 200px";>
                            <div class="thumbnail Sombras">
                                <img src="../images/deuda.jpg" alt="...">
                                <div class="caption">
                                    <h4 id="leyenda2">Dispersión ARS</h4>
                                    <span style="font-size: 12px">Muestra la informacion de los integrates de su nucleo familiar.</span>
                                    <br />
                                    <br />                                    
                                </div>
                                <div class="footerButton">
                                    <asp:Button ID="btnConsDisARS" runat="server" Text="Ver" CssClass="btn btn-primary" />
                                        </div>
                            </div>
                        </div>
                    </div>
                </div>
            </td>          
        </tr>
        </table>

        <div style="text-align: -webkit-left; padding-left: 20px;">
            <h1 style="margin: 0;">Consultas como Empleado</h1>
            <hr style="float: left;" />
        </div>
        <table style="margin-left: 10px; width: 100%;">
            <tr>
                <td>
                <div style="margin-left: 10px">
                    <div class="row">
                        <div class="col-sm-6 col-md-4" style="width: 200px";>
                            <div class="thumbnail Sombras">
                                <img src="../images/enLinea.jpg" alt="...">
                                <div class="caption">
                                    <h4 id="leyenda">Empleadores Reportados</h4>
                                    <span style="font-size: 12px">Muestra la informacion de los empleadores que reportan.</span>
                                    <br />
                                    <br />
                                </div>
                                <div class="footerButton">
                                    <asp:Button  ID="btnEmpReportados" runat="server" Text="Ver" CssClass="btn btn-primary"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </td>
            <td>
                <div style="margin-left: 10px">
                    <div class="row">
                        <div class="col-sm-6 col-md-4" style="width: 200px";>
                            <div class="thumbnail Sombras">
                                <img src="../images/deuda.jpg" alt="...">
                                <div class="caption">
                                    <h4>Panel de Certificaciones</h4>
                                    <span style="font-size: 12px">Muestra la informacion de los integrates de su nucleo familiar.</span>
                                    <br />
                                    <br />                                    
                                </div>
                                <div class="footerButton">
                                    <asp:Button ID="btnConsCertificaciones" runat="server" Text="Ver" CssClass="btn btn-primary" />
                                        </div>
                            </div>
                        </div>
                    </div>
                </div>
            </td>    
            <td>
                <div style="margin-left: 10px">
                    <div class="row">
                        <div class="col-sm-6 col-md-4" style="width: 200px";>
                            <div class="thumbnail Sombras">
                                <img src="../images/enLinea.jpg" alt="...">
                                <div class="caption">
                                    <h4 id="leyenda5">Certificación de Aporte Personal</h4>
                                    <span style="font-size: 12px">Solicita una certificación de aporte personal.</span>
                                    <br />
                                    <br />
                                </div>                              
                                <div class="footerButton">
                                    <button id="btnGrCertificacion" type="button" class="btn btn-primary">Solicitar</button>                                   
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </td>
                <td></td>
            </tr>
        </table>

        
        <div style="text-align: -webkit-left; padding-left: 20px;">
            <h1 style="margin: 0;">Consultas del Seguro de Pensiones</h1>
        <hr style="float: left;" />
        </div>
        <table style="margin-left: 10px; width: 100%;">
            <tr>
                <td>
                <div style="margin-left: 10px">
                    <div class="row">
                        <div class="col-sm-6 col-md-4" style="width: 200px";>
                            <div class="thumbnail Sombras">
                                <img src="../images/deuda.jpg" alt="...">
                                <div class="caption">
                                    <h4 id="leyenda4">Afiliación AFP</h4>
                                    <span style="font-size: 12px">Indica en cual AFP se encuentra afiliado actualmente.</span>
                                    <br />
                                    <br />
                                    <br />                                    
                                </div>
                                <div class="footerButton">
                                    <asp:Button ID="btnAfiliacionAFP" runat="server" Text="Ver" CssClass="btn btn-primary" />
                                        </div>
                            </div>
                        </div>
                    </div>
                </div>
            </td>
            </tr>
        </table>
        <!-- PopUp De Aviso a la Solicitud de Certificación -->

        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <%--<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="false">&times;</span></button>--%>
                        <h4 class="modal-title" id="myModalLabel">Advertencia</h4>
                    </div>
                    <div id="divMensajeModal" class="modal-body">
                        Usted procederá a crear una certificación de aporte personal, seguro que desea continuar?
                    </div>
                    <div class="modal-footer">
                        <button id="btnClosePopUp" runat="server" type="button" class="btn btn-primary" data-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnCrearSolicitud" CssClass="btn btn-primary" runat="server" Text="Continuar" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Fin del PopUp -->
    </div>
    <!-- Fin del contenedor -->
</asp:Content>

