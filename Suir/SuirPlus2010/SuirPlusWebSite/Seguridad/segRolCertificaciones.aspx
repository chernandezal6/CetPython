<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="segRolCertificaciones.aspx.vb" Inherits="Seguridad_segRolCertificaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">Gestión de Roles para Certificaciones</div>
	<br />

    <table id="table1" style="BORDER-COLLAPSE: collapse" width="25%" border="0" runat="server">
        <tr>
            <td>
                <asp:Panel ID="pnlRolCertificaciones" runat="server">
                    <fieldset>
                        <legend>                            
                            <asp:Label ID="lblCrearRolCertificacion" runat="server" Text="Crear Rol Certificación">
                            </asp:Label>
                        </legend>

                         <table class="td-content" id="Table2" cellspacing="1" cellpadding="1" width="350" border="0">
					                <tr>
						                <td colspan="4" style="height: 6px"></td>
					                </tr>					              
					                <tr>
						                <td align="right">Roles&nbsp;</td>
						                <td class="labelData" colspan="3">
							                <asp:dropdownlist id="ddlRoles" runat="server" CssClass="dropDowns" AutoPostBack="true" TabIndex="1">     
							                </asp:dropdownlist>
						                </td>
                                        <td></td>
					                </tr>
                                    <tr>
						                <td align="right">Certificaciones&nbsp;</td>
						                <td class="labelData" colspan="3">
							                <asp:dropdownlist id="ddlCertificacion" runat="server" CssClass="dropDowns" AutoPostBack="true" TabIndex="2">								               
							                </asp:dropdownlist>
						                </td>
                                        <td></td>
					                </tr>
					                <tr>
						                <td colspan="4"></td>
					                </tr>
					                <tr>
						                <td colspan="4">
							               
						                </td>
                                        <td></td>
					                </tr>
					                <tr>	
                                        <td></td>					                
						                <td align="right" style="width: 40%">
							                <asp:button id="btnAsignar" runat="server" Text="Asignar"></asp:button>	
                                            <asp:button id="btnLimpiar" runat="server" Text="Limpiar"></asp:button>						                
						                </td>
                                        <td></td> 
                                        <td></td>                                       
					                </tr>
                                    <tr><td></td></tr>
                                    <tr>
                                        <td></td>
                                        <td style="width: 80%">                                                                                     
                                            <asp:Label id="lblMensaje" runat="server" CssClass="label-Blue" Visible="False" style="width: 80%" Width="90px" />	
                                            <asp:Label id="lblerror" runat="server" CssClass="error" Visible="False" style="width: 80%" Width="90px" />                                       
                                        </td>
                                        <td>                                            
                                        </td>                                       
                                    </tr>
				                </table>
                    </fieldset>

                </asp:Panel>
            </td>
        </tr>
    </table>
</asp:Content>

