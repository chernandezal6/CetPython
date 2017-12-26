<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consReportedePagosdeSubsidiosdelSFS.aspx.vb" Inherits="Consultas_consReportedePagosdeSubsidiosdelSFS" %>



<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
    <%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc2" %>
         <asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
          <script language="javascript" type="text/javascript">

              $(document).ready(function () {

                  var desde = $("#<%=txtFechaDesde.ClientID %>").attr('id');

                  var dates = $(".fecha").datepicker({
                      dateFormat: 'd/mm/yy',
                      defaultDate: "+1w",
                      changeMonth: true,
                      numberOfMonths: 3,
                      onSelect: function (selectedDate) {
                          var option = this.id == desde ? "minDate" : "maxDate",
                					instance = $(this).data("datepicker"),
                					date = $.datepicker.parseDate(
                						instance.settings.dateFormat ||
                						$.datepicker._defaults.dateFormat,
                						selectedDate, instance.settings);
                          dates.not(this).datepicker("option", option, date);
                      }
                  });
              });

             
              

    </script>
          

         <span class="header">Reporte de pagos de Subsidios del SFS</span>
           <br/>
            <br/>
             <br/>
     
          <div style="float: left; width: auto;" id="div1" runat="server" visible="true">
               
      
                <fieldset style="width: 450px; height: 130px;">
                <table cellpadding="0" width="450" style="left">
                    <tr>
                        <td align="right" valign="middle" style ="width: auto;" >
                            Cédula:
                        </td>
                        <td align="left" valign="top" style ="width: auto;">
                            <asp:TextBox ID="txtCedula" runat="server" EnableViewState="False" MaxLength="11"  ></asp:TextBox>
                                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCedula"
                                Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$"
                                SetFocusOnError="True" EnableViewState="False">Cédula Inválida</asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    
                    <tr>
                        <td align="right">
                            Tipo:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTipoSubsidio" runat="server" CssClass="dropDowns">
                                <asp:ListItem Selected="True" Value=""><--Todos--></asp:ListItem>
                                <asp:ListItem Value="M">Maternidad</asp:ListItem>
                                <asp:ListItem Value="E">Enfermedad Común</asp:ListItem>
                                <asp:ListItem Value="L">Lactancia</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Fecha Registro (*):
                        </td>
                        <td>
                            <asp:TextBox ID="txtFechaDesde" class="fecha" runat="server"></asp:TextBox>
                      
                            &nbsp;&nbsp;&nbsp;&nbsp;
                      
                            <asp:TextBox ID="txtFechaHasta" class="fecha" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Fecha Pago (*):
                        </td>
                        <td>
                            <asp:TextBox ID="txtFechaDesdePago" class="fecha" runat="server"></asp:TextBox>
                              &nbsp;&nbsp;&nbsp;&nbsp;
                      
                            <asp:TextBox ID="txtFechaHastaPago" class="fecha" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <br />
                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="botones" />
                            &nbsp;
                            <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" Text="Limpiar"
                                CssClass="botones" />
                        </td>
                    </tr>
                    <%--<tr>
                        <td align="center" colspan="2">
                            </td>
                    </tr>--%>
                    <tr>
                    <td>
                        **Campos opcionales
                        </td>
                    </tr>
                </table>
            </fieldset>
            
           
             
          <div>
                    <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"
                        Visible="false" Font-Size="10pt"></asp:Label>
                   
           </div>
             <br/>
             <br/>
             <asp:Panel runat="server" ID="pnlPagosSubsidiosSFS" Visible="false">
           
                <div style="float: left; width:auto;" id="divPagos" runat="server" visible="true">
                    <fieldset >
                        <legend style="text-align: left">Pagos de subsidios del SFS</legend>
                        <br />
                         <table cellpadding="0" cellspacing="0" >
                        <asp:GridView ID="gvPagosSubsidios" runat="server" AutoGenerateColumns="False" CellPadding="3"
                            Style="width: 600px;" >
                            <Columns>
                              <asp:BoundField DataField="nombres" HeaderText="Nombres">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                                    <ItemStyle HorizontalAlign="left" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="tipo_subsidio" HeaderText="Tipo Susbsidio">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="nro_pago" HeaderText="Nro Pago">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="status_pago" HeaderText="Estatus Pago">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                     </asp:BoundField>
                                      <asp:BoundField DataField="periodo" HeaderText="Periodo">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                     </asp:BoundField>
                                     <asp:BoundField DataField="fecha_pago" HeaderText="Fecha Pago" 
                                    DataFormatString="{0:d}" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                     </asp:BoundField>
                                     <asp:BoundField DataField="fecha_registro" HeaderText="Fecha de Registro" 
                                    DataFormatString="{0:d}" HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                     </asp:BoundField>
                                <asp:TemplateField HeaderText="Monto Susbsidio">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# FormateaSalario(eval("monto_subsidio")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:TemplateField>
                               
                                <asp:BoundField DataField="via_pago" HeaderText="Via Pago">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Nro Referencia">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# FormateaReferencia(eval("nro_referencia")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="cuenta_banco" HeaderText="Cuenta Bancaria">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                               </Columns>
                        </asp:GridView>
                        <tr>
                        <td>
                        <table width="100%">
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                    CommandName="First" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion"
                                    Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                                Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                                <asp:LinkButton ID="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                    CommandName="Next" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                    CommandName="Last" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                                Total de registros&nbsp;
                                <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server" />
                            </td>
                        </tr>      
                         <tr>
                            <td>
                                <uc2:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                                &nbsp; |&nbsp;
                                <asp:LinkButton ID="LnkBtvolver" runat="server" CssClass="linkPaginacion" Text="Volver encabezado >> "
                                    Visible="false"> </asp:LinkButton>&nbsp;
                            </td>
                            
                        </tr>
                     </table>
                       </td>
                        </tr>
                     </table>
                    </fieldset>
                       
                </div>
          </asp:panel>
       </div>
      
       
          <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />
             <br />

</asp:Content>

