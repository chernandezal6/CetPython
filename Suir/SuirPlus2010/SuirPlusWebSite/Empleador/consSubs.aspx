<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consSubs.aspx.vb" Inherits="Empleador_consSubs" title="Embarazos Reportados" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc2" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <br />
    
    <uc2:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
  <div class="header">Consulta de Embarazos Reportados</div>            
            
    <br />
                <table class="td-content" id="Table1" style="width: 550px"  cellspacing="0" cellpadding="0">
				<tr>
					<td>
					<br />
						<table style="margin-left: 60px">
							<tr>
								<td>Cédula:</td>
								<td><asp:textbox id="txtCedula" runat="server" Width="100px" MaxLength="11"></asp:textbox>
                                    <asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" 
                                        ControlToValidate="txtCedula" Display="Dynamic" ValidationGroup="filtro">*</asp:requiredfieldvalidator></td>
								<td align="right"><asp:button id="btnConsultar" runat="server" Text="Buscar" 
                                        ValidationGroup="filtro"></asp:button>
									<asp:button id="btnLimpiar" runat="server" Text="Limpiar" 
                                        CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2">
                                    <asp:RegularExpressionValidator ID="regExpRncCedula0" runat="server" 
                                        ControlToValidate="txtCedula" Display="Dynamic" 
                                        ErrorMessage="Cédula inválida." Font-Bold="True" 
                                        ValidationExpression="^[0-9]+$" ValidationGroup="filtro"></asp:RegularExpressionValidator>
                                </td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
            <asp:Label ID="lblMensaje" runat="server" cssclass="error"></asp:Label>
            <br />
            
    <br />
           
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
       
           <div id="divEmbarazadas" runat="server">
            <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
            <br />
            <table>
                <tr>
                    <td>
                        
                           <asp:GridView ID="gvEmbarazos" runat="server" AutoGenerateColumns="False" 
                                Width="935px">
                               <Columns>
                                   <asp:BoundField DataField="Nombre" HeaderText="Nombre" >
                                       <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                   </asp:BoundField>
                                   <asp:BoundField DataField="Cedula" HeaderText="Cédula" />
                                   <asp:BoundField DataField="Fecha_Estimada_de_Parto" 
                                       HeaderText="Fecha Estimada de Parto" DataFormatString="{0:d}" >
                                       <ItemStyle HorizontalAlign="Center" />
                                   </asp:BoundField>
                                   <asp:BoundField DataField="Fecha_de_Diagnostico" 
                                       HeaderText="Fecha de Diagnóstico" DataFormatString="{0:d}" >
                                       <ItemStyle HorizontalAlign="Center" />
                                   </asp:BoundField>
                                   <asp:BoundField DataField="Fecha_de_Registro_de_Embarazo" 
                                       HeaderText="Fecha de Registro de Embarazo" DataFormatString="{0:d}" >
                                       <ItemStyle HorizontalAlign="Center" />
                                   </asp:BoundField>
                                   <asp:TemplateField HeaderText="Info Maternidad">
                                   <ItemTemplate>
                                       
                                        <asp:LinkButton id="lnkImprimir" runat="server" CommandName="Imprimir" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.Cedula") %>'>[Ver Más]</asp:LinkButton>
			    
                                   </ItemTemplate>
                                       <ItemStyle HorizontalAlign="Center" />
                                   </asp:TemplateField>
             
                               </Columns>
                           </asp:GridView>
                          
                    </td>
                </tr>
                <tr>
                   <td style="height: 14px">
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
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total de Empleados:&nbsp;<asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                        <br />
                    </td>
                </tr>
            </table>
       </div>
       
    </ContentTemplate>
    <Triggers>
        <asp:PostBackTrigger ControlID="ucExportarExcel1" />
        <asp:PostBackTrigger ControlID="btnConsultar" />
        <asp:PostBackTrigger ControlID="btnLimpiar" />
    </Triggers>
    </asp:UpdatePanel>
           
        
       
    <br />
</asp:Content>

