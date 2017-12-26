<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsConsNovedades.aspx.vb" Inherits="Novedades_sfsCambioCuentaMadre" title="Consulta Novedades" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script language="javascript" type="text/javascript">

function numeralsOnly(evt) {
    evt = (evt) ? evt : event;
    var charCode = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode : 
        ((evt.which) ? evt.which : 0));
    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
        alert("Este campo solo permite valores numericos.");
        return false;
    }
    
    return true;
        
    
    
}
function checkNum()
	    {
            var carCode = event.keyCode;
            
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
         }
        
</script>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>                                           
         <uc2:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
           <table class="td-content" id="Table1" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
				        <tr>
                            <td align="left">
                                &nbsp;</td>
                        </tr>
				        <tr>
					        <td align="left">
						        <table style="margin-left: 60px">
							        <caption>
                                        <span style="font-size: large; font-weight: bold; color:#016BA5; font-family: Arial">
                                        Cambio de novedades del SFS</span>
                                         </caption>
                                        <tr>
                                            <td>
                                                Cédula o NSS:</td>
                                            <td>
                                                <asp:TextBox ID="txtCedulaNSS" runat="server" MaxLength="11" Width="100px"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                                    ControlToValidate="txtCedulaNSS" Display="Dynamic">*</asp:RequiredFieldValidator>
                                            </td>
                                            <td align="right">
                                                <asp:Button ID="btnConsultar" runat="server" Text="Buscar" />
                                                <asp:Button ID="btnCancelar" runat="server" CausesValidation="False" 
                                                    Text="Cancelar" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="center" colspan="2">
                                                <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" 
                                                    ControlToValidate="txtCedulaNSS" Display="Dynamic" 
                                                    ErrorMessage="NSS o Cédula invalido." Font-Bold="True" 
                                                    ValidationExpression="^[0-9]+$"></asp:RegularExpressionValidator>
                                            </td>
                                           </tr>
                                    <tr>
                                        <td align="center" colspan="2">
                                            &nbsp;</td>
                                    </tr>
                                   </table>
                                <span style="font-size: large; font-weight: bold; color:#016BA5; font-family: Arial">
                                <asp:Label ID="lblMsg1" Runat="server" cssclass="error" EnableViewState="False" 
                                    style="margin-left: 17px" Visible="False"></asp:Label>
                                </span>
                                <br />
					        </td>
				        </tr>
                            <caption>
                                <br />
                                <div ID="divConsulta" runat="server" style="text-align: left" visible="false">
                                   
                                    <tr>
                                        <td>
                                            <br />
                                               <uc1:ucInfoEmpleado ID="ucInfoEmpleado1" runat="server" />
                                             <br />
                                            <span style="font-size: large; font-weight: bold; color:#016BA5; font-family: Arial">
                                            <asp:Label ID="lblMsg2" Runat="server" cssclass="error" EnableViewState="False" 
                                                Visible="False" Text="Las 
                                            novedades de esta afiliada estan siendo manejadas por la Sisalril"></asp:Label>
                                            <br />
                                            </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <span style="font-size: large; font-weight: bold; color:#016BA5; font-family: Arial">
                                            Novedades de Maternidad<br />
                                            <asp:Label ID="lblMsg" Runat="server" cssclass="error" EnableViewState="False" 
                                                style="margin-left: 17px"></asp:Label>
                                            </span><br />
                                            <asp:GridView ID="gvNovedades" runat="server" AutoGenerateColumns="False" 
                                                Visible="False">
                                                <Columns>
                                                    <asp:BoundField DataField="novedad" HeaderText="Novedad">
                                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="fecha_evento" DataFormatString="{0:d}" 
                                                        HeaderText="Fecha de Reporte">
                                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:BoundField>
                                                    
                                                      <asp:TemplateField>
                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        <ItemTemplate>
                                                        <asp:Label ID="lblModifica" runat="server" Text='<%# Eval("Modifica") %>' Visible="False"></asp:Label>                      
                                                            <asp:linkbutton ID="lbtnCambiar" Text="[Cambiar]"  runat="server" 
                                                            CommandArgument='<%# container.dataitem("id_nss") & "|" & container.dataitem("id_tipo_novedad") %>' 
                                                            CommandName="Cambiar">
                                                            </asp:linkbutton>
                                                            <asp:linkbutton ID="lbtnEliminar" Text="[Eliminar]"  runat="server"
                                                            CommandArgument='<%# container.dataitem("id_nss") & "|" & container.dataitem("id_tipo_novedad") %>' 
                                                            CommandName="Eliminar"></asp:linkbutton>
                                                        </ItemTemplate>
                                                          </asp:TemplateField>  
                                                            <asp:BoundField DataField="modifica" HeaderText="modifica" Visible="False">
                                                          </asp:BoundField> 
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </div>
                        </caption>
                        </table>
			        <br />
                </div>
                
                <br />
                <br />          
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

