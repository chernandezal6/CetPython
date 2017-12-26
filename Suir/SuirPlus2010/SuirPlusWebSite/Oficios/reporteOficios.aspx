<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="reporteOficios.aspx.vb" Inherits="Oficios_reporteOficios" Title="Reporte de Oficios" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		
            Me.PermisoRequerido = 59
			
        End Sub
    </script>
    <script language="javascript" type="text/javascript">
        function modelesswin(url) {
            //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px")
            newwindow = window.open(url, '', 'height=1300px,width=800px');
            newwindow.print();
        }

    </script>

    <script type="text/javascript">
            $(function () {

            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

            $("#ctl00_MainContent_txtFechaDesde").datepicker($.datepicker.regional['es']);
            $("#ctl00_MainContent_txtFechaHasta").datepicker($.datepicker.regional['es']);

        });
    </script>

    <style>
    .titulo {
    color: #006699;
    font-family: Verdana,Tahoma,Arial;
    font-size: 14px;
    font-weight :bold;
}
    
    </style>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table cellspacing="0" cellpadding="0" width="85%" border="0">
                <tr>
                    <td class="header" style="height: 44px">
                        Reporte de Oficios<br />
                        <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label>
                        <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" ValidationExpression="^(\d{9}|\d{11})$"
                            ErrorMessage="RNC o Cédula invalido." ControlToValidate="txtRncCedula" CssClass="error">
                        </asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td style="height: 70px">
                        <table class="td-note" style="height: 60px" cellspacing="4" cellpadding="0" border="0">
                            <tr>
                                <td>
                                    Rnc o Cédula<br />
                                    <asp:TextBox ID="txtRncCedula" runat="server" MaxLength="11" Width="90px"></asp:TextBox>
                                </td>
                                <td valign="top">
                                    Número de Oficio<br />
                                    <asp:TextBox ID="txtOficio" runat="server" MaxLength="35" Width="90px"></asp:TextBox>
                                </td>
                                <td valign="top">
                                    Usuario<br />
                                    <asp:TextBox ID="txtUsuario" runat="server" MaxLength="35" Width="118px"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td valign="top">
                                    Fecha Inicio<br />
                                    <asp:TextBox ID="txtFechaDesde" runat="server" Width="70px"></asp:TextBox>
                                </td>
                                <td valign="top">
                                    Fecha Fin<br />
                                    <asp:TextBox ID="txtFechaHasta" runat="server" Width="70px"></asp:TextBox>
                                </td>
                                <td align="center">
                                    <br />
                                    <asp:Button ID="btnConsultar" runat="server" Text="Consultar"></asp:Button>&nbsp;
                                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar"></asp:Button>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <asp:GridView ID="gvOficios" runat="server" Width="100%" AutoGenerateColumns="False"
                            CellPadding="4">
                            <Columns>
                                <asp:TemplateField HeaderText="Oficio">
                                    <ItemTemplate>
                                        <a href="javascript:modelesswin('oficioDoc.aspx?codOficio=<%# DataBinder.Eval(Container,"DataItem.ID_OFICIO") %>')">
                                            <img src="../images/detalle.gif" style="border: 0px" width="15" height="12" alt="" /></a>
                                        <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ID_OFICIO") %>'
                                            ID="Label1">
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="RNC_O_CEDULA" HeaderText="RNC o C&#233;dula"></asp:BoundField>
                                <asp:BoundField DataField="RAZON_SOCIAL" HeaderText="Raz&#243;n Social"></asp:BoundField>
                                <asp:BoundField DataField="ACCION_DES" HeaderText="Acci&#243;n"></asp:BoundField>
                                <asp:BoundField DataField="Status Desc" HeaderText="Estatus"></asp:BoundField>
                                <asp:BoundField DataField="NOMBRE USUARIO SOLICITA" HeaderText="Usuario Solicita">
                                </asp:BoundField>
                                <asp:BoundField DataField="FECHA_SOLICITA" HeaderText="Fecha Solicita" DataFormatString="{0:d}"
                                    HtmlEncode="false"></asp:BoundField>
                                <asp:BoundField DataField="NOMBRE USUARIO PROCESA" HeaderText="Usuario Procesa">
                                </asp:BoundField>
                                <asp:BoundField DataField="FECHA_PROCESA" HeaderText="Fecha Procesa"></asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
                <tr id="trDetalleOficio" runat="server" visible="false">
                    <td><br />
                   <span class="titulo">Detalle de Oficio</span> 
                        <br /><br />
                        <asp:GridView ID="gvDetalleOficio" runat="server" Width="40%" AutoGenerateColumns="True"
                            CellPadding="4"  RowStyle-HorizontalAlign="Center">
                        </asp:GridView>
                    </td>
                </tr>
                <tr id="trDocumentacion" runat="server" visible="false">
                    <td>
                        <br />
                   <span class="titulo">Documentación</span> 
                        <br /><br />
                        <asp:GridView ID="gvDocumentacion" runat="server" Width="58%" AutoGenerateColumns="False"
                            CellPadding="4">
                            <Columns>
                                <asp:TemplateField HeaderText="Documentación">
                                    <ItemTemplate>
                                        <a href="javascript:modelesswin('oficioDocumentacion.aspx?idDoc=<%# DataBinder.Eval(Container,"DataItem.ID_DOC") %>')">
                                            <img src="../images/detalle.gif" style="border: 0px" width="15" height="12" alt="" /></a>
                                        <asp:Label runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ID_DOC") %>'
                                            ID="Label1">
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="ID_OFICIO" HeaderText="Nro.Oficio"></asp:BoundField>
                                <asp:BoundField DataField="DOCUMENTO" HeaderText="DATA" Visible="false"></asp:BoundField>
                                <asp:BoundField DataField="DOCUMENTO_NOMBRE" HeaderText="Nombre del Documento"></asp:BoundField>
                                <asp:BoundField DataField="DOCUMENTO_TIPO" HeaderText="Tipo de Documento"></asp:BoundField>
                            </Columns>
                        </asp:GridView>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <br />
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 5px; bottom: 0%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
