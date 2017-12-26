<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ConsEmpReportados.aspx.vb" Inherits="Oficina_Virtual_ConsEmpReportados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#navMenu").load("MenuOFV.html");
            $("#SingleRecord").load("PanelConsCiudadano.aspx");
            setTimeout(function () {
                $("#Titulo").empty();
                $("#Titulo").html("Empleadores Reportados");
            }, 100);
        });        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="SingleRecord">
    </div>
    <div class="bs-example">
        <div class="center-block bs-example" data-example-id="bordered-table" style="max-width: 800px; width: 50%; margin: auto;">
            <asp:GridView ID="gvEmpleadoresR" runat="server" AutoGenerateColumns="False"
                Width="600px" EnableViewState="False" CssClass="table table-bordered">
                <Columns>
                    <asp:BoundField DataField="RNC_O_CEDULA" HeaderText="RNC">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="RAZON_SOCIAL" HeaderText="Razón Social">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="NOMBRE_COMERCIAL" HeaderText="Nombre Comercial">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="NOMINA_DES" HeaderText="Nomina">
                        <ItemStyle HorizontalAlign="Left" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SALARIO_SS" HeaderText="Salario" DataFormatString="{0:c}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" Wrap="false" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
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

