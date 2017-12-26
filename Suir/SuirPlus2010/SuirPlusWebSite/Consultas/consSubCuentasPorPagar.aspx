<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consSubCuentasPorPagar.aspx.vb" Inherits="Consultas_consSubCuentasPorPagar" title="Consulta Subsidio de Cuentas Por Pagar" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
   <asp:UpdatePanel runat="server">
   <ContentTemplate>
           <div id="Div1" runat="server" class="subHeader">
                
               <span style="font-size: medium">
               Consulta de Cuentas por Pagar de Subsidios</span></div>
       <table class="td-content" style="width: 370px" cellpadding="1" cellspacing="0">
                <tr>
                    <td align="right" nowrap="nowrap" style="width: 74px">
                        RNC o Cédula:
                    </td>
                    <td style=" height: 33px; width: 134px;">
                        <asp:TextBox ID="txtRNC" runat="server" EnableViewState="False" MaxLength="11"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtRNC"
                        Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$" SetFocusOnError="True" EnableViewState="False">RNC o Cédula Inválido</asp:RegularExpressionValidator>
                    </td>
                    <td align="right" height: 33px" style="width: 72px">
                        Cédula Madre:
                    </td>
                    <td style="width: 136px; height: 26px">
                        <asp:TextBox ID="txtCedulaMadre" runat="server" MaxLength="11"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 74px">
                        Periodo Desde:
                    </td>
                    <td style="height: 26px; width: 134px;">
                    <asp:TextBox ID="txtDesde" runat="server"></asp:TextBox>
                    </td>
                    <td align="right" nowrap="nowrap">
                        Periodo Hasta:</td>
                    <td style="width: 136px">
                        <asp:TextBox ID="txtHasta" runat="server"></asp:TextBox>
                    </td>
                 </tr>
                <tr>
                    <td align="right" style="width: 74px">
                        Tipo Subsidio:
                    </td>
                    <td style="width: 134px; height: 26px; margin-left: 40px;">
                        <asp:DropDownList ID="DropDownList1" runat="server" CssClass="dropDowns">
                            <asp:ListItem Value="">&lt;Seleccione un tipo&gt;</asp:ListItem>
                            <asp:ListItem Value="M">Maternidad</asp:ListItem>
                            <asp:ListItem Value="L">Lactancia</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td colspan="2" align="center"> 
                        <asp:Button ID="btnBuscar" runat="server" CausesValidation="False" Text="Buscar"  />
                        <asp:Button ID="Button2" runat="server" Text="Limpiar" />
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="height: 15px">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error" 
                            EnableViewState="False"></asp:Label>
                    </td>
                </tr>
            </table>
           <br />
    <asp:Panel ID="pnlgvSubsidio" runat="server" Visible="False">
     <table>
      <tr>
                <td>
    <asp:GridView ID="gvDataCxC" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:TemplateField HeaderText="RNC o Cédula">
                <ItemTemplate>
                     <a target="_blank"  href=' <%# "../Consultas/consEmpleador.aspx?rnc=" & VerificaRNCoCedula(eval("Rnc_o_Cedula"))%>'><%#VerificaRNCoCedula(Eval("Rnc_o_Cedula"))%> 
                </ItemTemplate>
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField HeaderText="Razón Social" DataField="Razon_Social">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Left" Wrap="False" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Cédula">
                <ItemTemplate>
                   <a target="_blank" href=' <%# "../Consultas/consMaternidad.aspx?NoDoc=" & eval("no_documento")%>'><%#formateaCedula(Eval("no_documento"))%></a>
                </ItemTemplate>
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField DataField="Nombres" HeaderText="Nombre">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Left" Wrap="False" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Periodo">
                <ItemTemplate>
                    <asp:Label ID="Label1" runat="server" Text='<%# FormateaPeriodo(eval("PERIODO_PAGO")) %>'></asp:Label>
                </ItemTemplate>
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:TemplateField>
            <asp:BoundField DataField="NRO_PAGO" HeaderText="Nro de Pago">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="MONTO_SUBSIDIO" HeaderText="Monto Subsidio" 
                DataFormatString="{0:c}">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Right" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="desc_MOTIVO_NO_PAGO" HeaderText="Motivo No Pago">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="desc_STATUS" HeaderText="Estatus">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="tipo_subsidio" HeaderText="Tipo Subsidio">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="FECHA_REGISTRO" DataFormatString="{0:d}" 
                HeaderText="Fecha Registro">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="FECHA_OK" DataFormatString="{0:d}" 
                HeaderText="Fecha Ok">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="FECHA_CP" DataFormatString="{0:d}" 
                HeaderText="Fecha Completo Pago">
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField>
        </Columns>
    </asp:GridView>
       </td>              
            </tr>
     <tr>
                <td>
                    <asp:linkbutton id="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
	                    CommandName="First" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
                    <asp:linkbutton id="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion" Text="< Anterior"
	                    CommandName="Prev" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;
                    Página
	                    [<asp:label id="lblCurrentPage" runat="server"></asp:label>] de
                    <asp:label id="lblTotalPages" runat="server"></asp:label>&nbsp;
                    <asp:linkbutton id="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
	                    CommandName="Next" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
                    <asp:linkbutton id="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
	                    CommandName="Last" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;                    
                    <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                    <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                    
                    </td>                 
            </tr>           
            <tr>
                <td>
                    <br />
                    Total de registros&nbsp;
                    <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server"/>
                </td>
            </tr>
            </table>
    </asp:Panel>
    </table>
    </ContentTemplate>
    <Triggers>
        <asp:PostBackTrigger ControlID="ucExportarExcel1" />
    </Triggers>
   </asp:UpdatePanel> 
   <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 32px; bottom: 78%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress> 
</asp:Content>

