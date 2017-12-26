<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsConfirmacionLactancia.aspx.vb" Inherits="Novedades_sfsConfirmacionLactancia" title="Confirmar Solicitud" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent"  Runat="Server">
<asp:UpdatePanel ID="UpdatePanel1" runat="server">
   <ContentTemplate>
   
    <fieldset style="width: 585px; margin-left: 60px">
        </span>
       <legend class="header" style="font-size: 14px; font-weight: normal;">Confirmar los 
           datos de la Solicitud </legend>
       <br />
            <table style="width: 100%">
                <tr>
                    <td>
                        <table cellpadding="0" cellspacing="0" style="margin-left: 17px" width="93%">
                            <tr>
                                <td>
                                    <br />
                                    <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td >
                        
                        <div ID="fiedlsetDatos0" runat="server" class="td-content" 
                            style="width: 543px; margin-left: 17px" visible="True">
                            <br />
                            <span style="margin-left: 12px">&nbsp;&nbsp;&nbsp; Fecha de Nacimiento:</span>
                            <asp:Label ID="lblFechaNacimiento" runat="server" CssClass="labelData"></asp:Label>
                            <br />
                            <span style="margin-left: 12px">Cantidada de Lactantes :</span>
                            <asp:Label ID="lblCantidadLactantes" runat="server" CssClass="labelData"></asp:Label>
                            <br />
                            <br />
                        </div>
                        <br />
                        
                        <asp:GridView ID="gvLactantes" runat="server" AutoGenerateColumns="False" style="margin-left:17px;">
                            <Columns>
                                <asp:BoundField DataField="NSS" HeaderText="NSS" />
                                <asp:BoundField DataField="Nombres" HeaderText="Nombres" />
                                <asp:BoundField DataField="PrimerApellido" HeaderText="Primer Apellido" />
                                <asp:BoundField DataField="SegundoApellido" HeaderText="Segundo Apellido" />
                                <asp:BoundField DataField="NUI" HeaderText="NUI" />
                                <asp:BoundField DataField="Sexo" HeaderText="Sexo" />
                            </Columns>
                        </asp:GridView>
                        
                        <br />
                        
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Label ID="lblMsg" Runat="server" cssclass="error" EnableViewState="False" 
                            style="margin-left: 17px"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div ID="fiedlsetDatos" runat="server">
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button 
                                ID="btnRegistrar" runat="server" 
                                style="margin-left: 62px; width: 90px; height: 19px;" Text="Confirmar" 
                                ValidationGroup="fecha" />
                            <asp:Button ID="btnCancelarGeneral" runat="server" 
                                style="margin-left: 4px; width: 90px; height: 19px;" Text="Cancelar" />
                        </div>
                    </td>
                </tr>
        </table>
       <br />
</fieldset>
       <br />
<br />

</ContentTemplate>
</asp:UpdatePanel>
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Procesando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>

</asp:Content>

