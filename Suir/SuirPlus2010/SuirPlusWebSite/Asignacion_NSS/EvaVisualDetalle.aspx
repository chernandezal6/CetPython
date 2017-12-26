<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="EvaVisualDetalle.aspx.vb" Inherits="Evaluacion_Visual_EvaVisualDetalle" %>

<script runat="server">

    Protected Sub gvDetalleExtranjero_RowDataBound1(sender As Object, e As GridViewRowEventArgs)

    End Sub
</script>


<asp:Content ID="body" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript">

        //function CallCoincidencias(RadButton) {
        //    PageMethods.SelectedCoincidencia(RadButton.value);           
        //}
      
        function modelesswin(url) {
            //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px");
            newwindow = window.open(url, '', 'height=1300px,width=800px');
            //newwindow.print();
        }


    </script>

    <div class="bigtitle">
        <span class="header">Evaluación visual</span>
    </div>
    <br />
    <fieldset style="width: 445px">
        <legend>Datos Solicitud</legend>
        <asp:Panel ID="pnlInfoSolicitud" runat="server" Visible="true">

            <table width="445" border="0">
                <tr>
                    <td align="right" nowrap="nowrap" style="font-size-adjust">Solicitud:
                    </td>
                    <td>
                        <asp:Label ID="lblSolicitud" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Tipo Solicitud:
                    </td>
                    <td>
                        <asp:Label ID="lblTipoSolicitud" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Fecha Solicitud:
                    </td>
                    <td>
                        <asp:Label ID="lblFechaSolicitud" runat="server" CssClass="labelData" DataFormatString="{0:dd/MM/yyyy}"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Motivo:
                    </td>
                    <td>
                        <asp:Label ID="lblMotivo" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td id="tdArs" align="right" nowrap="nowrap" runat="server">ARS Solicitante:
                    </td>
                    <td>
                        <asp:Label ID="lblArs" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>

            </table>
        </asp:Panel>
    </fieldset>
    <br />

    <div class="header">
        Registro Maestro
    </div>

    <table>
        <tr>
            <td>
                <asp:Panel ID="pnlExtranjeros" runat="server" Visible="true">
                    <asp:GridView ID="gvMaestroExtranjeros" runat="server" AutoGenerateColumns="False" Visible="true" CellPadding="5">
                        <Columns>
                           <asp:BoundField HeaderText="Tipo Documento" DataField="TipoDoc" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Número Documento" DataField="NumeroDocumento" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="left" />
                                <ItemStyle HorizontalAlign="left" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Apellidos" DataField="Apellidos" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="left" />
                                <ItemStyle HorizontalAlign="left" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Sexo" DataField="sexo" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Nacionalidad" DataField="Nacionalidad" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField> 
                            <asp:BoundField HeaderText="Fecha Nacimiento" DataField="FechaNacimiento" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>                           
                            <asp:TemplateField HeaderText="Imagen" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ibImagenEnc" runat="server" ImageUrl="~/images/pdf.png" CommandName="Ver" CommandArgument='<%# Eval("registro")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>                            
                        </Columns>
                    </asp:GridView>
                    <br />
                    <div class="header">
                        Coincidencia(s)
                    </div>
                    <asp:GridView ID="gvDetalleExtranjero" runat="server" AutoGenerateColumns="False" Visible="true" CellPadding="5">
                        <Columns>
                            <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>  
                                    <input id="radButton" type="radio" runat="server" value='<%# Eval("Nss")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="NSS" DataField="Nss" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>                            
                            <asp:BoundField HeaderText="Número Documento" DataField="NroDocumento" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Apellidos" DataField="Apellidos" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Sexo" DataField="sexo" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Nacionalidad" DataField="Nacionalidad" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField> 
                            <asp:BoundField HeaderText="Fecha Nacimiento" DataField="FechaNacimiento" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                             <asp:BoundField HeaderText="Estatus" DataField="Inhabilidad" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Periodo Cartera" DataField="periodo" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:MM-yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Imagen" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ibImagenDet" runat="server" ImageUrl="~/images/pdf.png" CommandName="VerDetalle" CommandArgument='<%# Eval("Nss")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                <asp:Panel ID="pnlNacionales" runat="server" Visible="false">
                    <asp:GridView ID="gvMaestroNacionales" runat="server" AutoGenerateColumns="False" Width="90%" Visible="true" AllowPaging="false">
                        <Columns>
                            <asp:BoundField HeaderText="Numero Documento" DataField="NumeroDocumento" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Apellidos" DataField="Apellidos" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Sexo" DataField="sexo" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Fecha Nacimiento" DataField="FechaNacimiento" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Municipio Acta" DataField="Municipio" HeaderStyle-HorizontalAlign="Left">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Año Acta" DataField="AñoActa" HeaderStyle-HorizontalAlign="Left">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Numero Acta" DataField="NumeroActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Folio Acta" DataField="FolioActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Libro Acta" DataField="LibroActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Oficialia Acta" DataField="OficialiaActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>                            
                            <asp:TemplateField HeaderText="Imagen" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ibImgnMaestro" runat="server" ImageUrl="~/images/pdf.png" CommandName="VerMaestro" CommandArgument='<%# Eval("registro")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <div class="header">
                        Coincidencia(s)
                    </div>
                    <asp:HiddenField ID="hdNSS" runat="server" />
                    <asp:GridView ID="gvDetalleNacionales" runat="server" AutoGenerateColumns="false" Visible="true" AllowPaging="false" Width="90%">
                        <Columns>
                            <asp:TemplateField HeaderText="" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>  
                                    <input id="radButton" type="radio" runat="server" value='<%# Eval("Nss")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="NSS" DataField="Nss" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Numero Documento" DataField="NroDocumento" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>                            
                            <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Apellidos" DataField="Apellidos" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Sexo" DataField="sexo" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Fecha Nacimiento" DataField="FechaNacimiento" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Municipio Acta" DataField="Municipio" HeaderStyle-HorizontalAlign="Left">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Año Acta" DataField="AnoActa" HeaderStyle-HorizontalAlign="Left">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Numero Acta" DataField="NumeroActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Folio Acta" DataField="folioActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Libro Acta" DataField="LibroActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Oficialia Acta" DataField="OficiliaActa" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Estatus" DataField="Inhabilidad" HeaderStyle-HorizontalAlign="Center">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField HeaderText="Periodo Cartera" DataField="periodo" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:MM-yyyy}">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Imagen" ItemStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ibImagen" runat="server" ImageUrl="~/images/pdf.png" CommandName="Ver" CommandArgument='<%# Eval("Nss")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </asp:Panel>
            </td>
        </tr>
    </table>
    <br />
    <br />
    <asp:UpdatePanel ID="upnlbotones" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:Button ID="btnActualizar" runat="server" Text="Actualizar" align="right" Style="font-size: medium" Visible="true" />
                    </td>
                    <td>
                        <asp:Button ID="btnAsignacion" runat="server" Text="Asignar" align="right" Style="font-size: medium" />
                    </td>
                    <td>
                        <asp:Button ID="btnRechazar" runat="server" Text="Rechazar" align="right" Style="font-size: medium" />
                    </td>
                    <td>
                        <asp:Button ID="btnListar" runat="server" Text="Listado" align="right" Style="font-size: medium" />
                    </td>
                    <td align="right" style="font-size: medium">Motivo Rechazo:
                    </td>
                    <td colspan="1" nowrap="nowrap">
                        <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="dropDowns" AutoPostBack="True" align="right" Style="font-size: medium">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false" Style="font-size: medium"></asp:Label>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>

</asp:Content>
