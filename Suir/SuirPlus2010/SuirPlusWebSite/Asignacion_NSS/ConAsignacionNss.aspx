<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConAsignacionNss.aspx.vb" Inherits="Asignacion_NSS_ConAsignacionNss" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="bigtitle">
        <span class="header">Consulta estatus de solicitud de NSS</span>        
    </div>  
    <br />
     <script type="text/javascript">
        $(function () {
            var curr_year = new Date().getFullYear();
            $(".Calendario").datepicker({
                dateFormat: 'dd/mm/yy',                
                changeMonth: true,
                changeYear: true,
                yearRange: '1900:' + curr_year,
                changeyearRange: false,
                numberOfMonths: 1

            });
        });

    </script>

    <table class="td-content">
        <tr>
            <td nowrap="nowrap">Número Solicitud:</td>
            <td>
                <asp:TextBox ID="txtNumeroSol" runat="server" MaxLength="9"  EnableViewState="False" TabIndex="1" ></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtNumeroSol"
                    ErrorMessage="Solo números" ForeColor="Red" ValidationExpression="^\d+$"> 
                </asp:RegularExpressionValidator>
                
            </td>
        </tr>
             
        <tr>           
            <td nowrap="nowrap">Tipo Documento:</td>
            <td>
                <asp:DropDownList ID="ddlTipoDocumento" runat="server" AutoPostBack="true" TabIndex="2"></asp:DropDownList>                
            </td>
            <td nowrap="nowrap">Número de Documento:</td>
            <td>
                <asp:TextBox ID="txtNumeroDocumento" runat="server" MaxLength="25" Visible ="false" TabIndex="3"></asp:TextBox>
                <asp:TextBox ID="txtNroDocSinMask" runat="server" MaxLength="25" Visible ="false" TabIndex="3"></asp:TextBox>
                <ajaxToolkit:MaskedEditExtender 
                                ID="maskNroDocumento" 
                                Runat="Server"                                             
                                TargetControlID="txtNumeroDocumento"                                                   
                                MessageValidatorTip="True"                                
                                OnInvalidCssClass="MaskedEditError"
                                ErrorTooltipEnabled="True"
                                ClearMaskOnLostFocus="True"
                                MaskType="None"
                                Mask="None"                  
                                />
            </td>            
        </tr>   
        
   
    </table> 
   
    <table>
        <tr><td></td></tr>
        <tr>
        <td colspan="3">
            <asp:Button ID="btBuscar" runat="server" Text="Buscar" />&nbsp;
            <asp:Button ID="btLimpiar" runat="server" Text="Limpiar"  CausesValidation="false"/>
        </td>
    </table>    
         
    <asp:label id="lblMensajeError" runat="server" Visible="False" EnableViewState="False" CssClass="error" Font-Size="Small"></asp:label><br />
    <asp:label id="lblmensaje" runat="server" Visible="False" EnableViewState="False" CssClass="label-Blue" Font-Size="Small"></asp:label><br />
    <br />
    <asp:GridView ID="gvSolicitudGeneral" runat="server" AutoGenerateColumns="False" Width="90%">
                    <Columns>
                        <asp:BoundField HeaderText="Solicitud" DataField="Solicitud" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Tipo Solicitud" DataField="TipoSolicitud" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Fecha Solicitud" DataField="FechaSolicitud" HeaderStyle-HorizontalAlign="Center" dataformatstring="{0:dd/MM/yyyy}">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField HeaderText="Estatus" DataField="Estatus" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Motivo" DataField="MotivoRechazo" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField> 
                        <asp:BoundField HeaderText="Tipo Documento" DataField="TipoDoc" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>                          
                       <asp:BoundField HeaderText="Documento Solicita" DataField="Expediente" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="Center" HtmlEncode="false" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Apellidos" DataField="Apellidos" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>                        
                        <asp:BoundField HeaderText="Sexo" DataField="Sexo" HeaderStyle-HorizontalAlign="Center" HtmlEncode="false" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Fecha Nacimiento" DataField="FechaNacimiento" HeaderStyle-HorizontalAlign="Center" dataformatstring="{0:dd/MM/yyyy}">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="NSS" DataField="Nss" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Identificador" DataField="NroDoc" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Imagen Solicitud" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ibImagen" runat="server"  ImageUrl="~/images/pdf.png" CommandName="VerSol" CommandArgument='<%# Eval("ID_REGISTRO")%>' />
                                     </ItemTemplate>
                        </asp:TemplateField>                       
                        <asp:TemplateField HeaderText="Certificación" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ibCertificacion" runat="server" visible="false" ImageUrl="~/images/pdf_blue.png" CommandName="VerCer" CommandArgument='<%# Eval("ID_REGISTRO")%>'  />
                                        <asp:Button id="btnCertificacion" runat="server"  visible="false" Text="Crear Certificación" CommandName="Crear" CommandArgument='<%# Eval("ID_REGISTRO") & "," & Eval("Nss")%>'/>
                                     </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>
          </asp:GridView> 
    <br />    
        <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
            <table cellpadding="0" cellspacing="0" width="550px">
            <tr>
                <td style="height: 24px">
                    <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                    [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                    <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                    <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td><br />
                    Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
            </table>
            </asp:Panel>
</asp:Content>

