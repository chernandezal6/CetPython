<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaPensionado.aspx.vb" Inherits="Afiliacion_ConsultaPensionado" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="header" align="left">Consulta de Pensionado<br />
&nbsp;<br />
        </div>
<table class="td-content" style="width: 385px" cellpadding="1" cellspacing="0">
        <tr>
            <td align="right" style="width: 21%" nowrap="nowrap">
                Cedula:
            </td>
            <td>
                <asp:TextBox ID="txtCedula" runat="server"></asp:TextBox>
                 <asp:RegularExpressionValidator ID="RegularExpressionValidator5" runat="server" ControlToValidate="txtCedula"
                                                Display="Dynamic" ErrorMessage="*" ValidationExpression="^(\d{11})$">Cédula Inválida.</asp:RegularExpressionValidator>
            </td>
         </tr>
        <tr>
            <td align="right" style="width: 21%">
                No. Pensionado:</td>
            <td>
                <asp:TextBox ID="txtNoPensionado" runat="server"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator6" runat="server" 
                    ControlToValidate="txtNoPensionado" ErrorMessage="No. Pensionado Invalido." 
                    ValidationExpression="^[0-9]*$"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 21%">
                &nbsp;</td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" 
                    Text="Buscar" />
                &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" 
                    CausesValidation="False" />
            </td>
        </tr>
        <tr>
            <td colspan="2" style="height: 15px">
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            </td>
        </tr>
    </table> 
    <asp:Panel ID="pnlDatos" runat="server" Visible="False">
       
            
            
       <ajaxToolkit:TabContainer ID="TabContainer1" Width="800px" runat="server" 
            ActiveTabIndex="0">
            <ajaxToolkit:TabPanel ID="TabPanel1" runat="server" HeaderText="Datos Secretaria de Estado de Hacienda"><ContentTemplate><table style="width: 600px"><tr><td class="labelData" style="width: 173px">Carnet Pensionado:</td><td><asp:Label ID="lblNoPensionado" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 173px">Institución donde fue pensionado:</td><td><asp:Label ID="lblInstituto" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 173px; height: 16px;">Numero Documento:</td><td style="height: 16px"><asp:Label ID="lblNoDocumentoSeh" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 173px; height: 16px;">Nombre:</td><td style="height: 16px"><asp:Label ID="lblNombreSeh" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 173px; height: 16px;">Fecha Nacimiento:</td><td style="height: 16px"><asp:Label ID="lblFechaNacimiento" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 173px">Direccion:</td><td><asp:Label ID="lblDireccion" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 173px">Telefono:</td><td><asp:Label ID="lblTelefono" runat="server"></asp:Label></td></tr></table></ContentTemplate></ajaxToolkit:TabPanel>
            
            <ajaxToolkit:TabPanel ID="TabPanel2" runat="server" HeaderText="Datos J.C.E."><ContentTemplate><table style="width: 600px"><tr><td class="labelData" style="width: 106px">Nombre:</td><td><asp:Label ID="lblNombre" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Fecha Nacimiento:</td><td><asp:Label ID="lblFechaNacimientoJce" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Status:</td><td><asp:Label ID="lblStatus" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Fecha Afiliación:</td><td><asp:Label ID="Label4" runat="server"></asp:Label></td></tr></table></ContentTemplate></ajaxToolkit:TabPanel>

            <ajaxToolkit:TabPanel ID="TabPanel3" runat="server" HeaderText="Datos Afiliación"><ContentTemplate><table style="width: 600px"><tr><td class="labelData" style="width: 106px">ARS:</td><td><asp:Label ID="lblARS" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Estatus:</td><td><asp:Label ID="lblEstatus" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Fecha Afiliación:</td><td><asp:Label ID="lblFechaAfiliacion" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Fecha Baja:</td><td><asp:Label ID="lblFechaBaja" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Fecha Desafiliacion:</td><td><asp:Label ID="lblFechaDesafiliacion" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Fecha Registro:</td><td><asp:Label ID="lblFechaRegistro" runat="server"></asp:Label></td></tr><tr><td class="labelData" style="width: 106px">Documentos:</td><td><asp:LinkButton ID="lnkImagen" runat="server">Ver Documento</asp:LinkButton></td></tr></table></ContentTemplate></ajaxToolkit:TabPanel>       
     
            <ajaxToolkit:TabPanel ID="TabPanel4" runat="server" HeaderText="Listado de novedades de afiliación"><ContentTemplate><table style="width: 600px"><tr><td><asp:GridView ID="gvNovedades"  runat="server" AutoGenerateColumns="False"><Columns><asp:BoundField DataField="ars_des" HeaderText="ARS" /><asp:BoundField DataField="id_novedad" HeaderText="IDNovedad" ><ItemStyle HorizontalAlign="Center" /></asp:BoundField><asp:BoundField DataField="id_motivo_baja" HeaderText="Motivo" /><asp:BoundField DataField="estatus" HeaderText="Estatus" /><asp:BoundField DataField="fecha_carga" HeaderText="Fecha Carga" 
                                 DataFormatString="{0:d}" HtmlEncode="False" ><ItemStyle HorizontalAlign="Center" /></asp:BoundField></Columns></asp:GridView></td></tr></table></ContentTemplate></ajaxToolkit:TabPanel>  
                
            <ajaxToolkit:TabPanel ID="TabPanel5" runat="server" HeaderText="Dispersiones"><ContentTemplate><ajaxToolkit:TabContainer ID="tc1" runat="server"><ajaxToolkit:TabPanel ID="tpbase" runat="server" HeaderText="Resultados"><ContentTemplate><asp:Literal runat="server" ID="lblResultados" Text="0 Resultados"></asp:Literal></ContentTemplate></ajaxToolkit:TabPanel></ajaxToolkit:TabContainer></ContentTemplate></ajaxToolkit:TabPanel>
                
         </ajaxToolkit:TabContainer>
            
            
    </asp:Panel>

</asp:Content>

