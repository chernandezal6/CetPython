<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SectoresSalariales.aspx.vb" Inherits="Mantenimientos_SectoresSalariales" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {
            Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);

            function EndRequestHandler(sender, args) {
                $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
                $(".fecha").datepicker($.datepicker.regional['es']);
            }

        });

        function checkNum(e) {
            var carCode = (window.event) ? window.event.keyCode : e.which;
            if (carCode != 8) {
                if ((carCode < 48) || (carCode > 57)) {
                    if (carCode == 46)
                        return;
                    else if (window.event) //IE       
                        window.event.returnValue = null;
                    else //Firefox       
                        e.preventDefault();
                }
            }
        }
    </script> 


    <asp:UpdatePanel ID="upSectoresSalariales" runat="server">
    <ContentTemplate>

    <asp:label ID="lbl_error" runat="server" Visible="False" CssClass="error"></asp:label>
    <br />
    <fieldset style="width: 375px">
        <legend>Sectores Salariales</legend>
        <table>
            <tr id="tr_agregar" runat="server" visible="false">
                <td>
                    <asp:label ID="lbl_descripcion" runat="server">Sector Salarial</asp:label>
                </td>
                <td>
                    <asp:TextBox ID="txt_descripcion" runat="server" Width="250px"></asp:TextBox>
                </td>
            </tr>
            <tr id="tr_mostrar" runat="server" visible="true">
                <td>
                    <asp:label ID="lbl_dropdown" runat="server">Sector Salarial</asp:label>
                </td>
                <td>
                    <asp:DropDownList ID="ddl_sectores_salarial" runat="server" 
                        CssClass="dropDowns" AutoPostBack="True"></asp:DropDownList>&nbsp;<asp:Button ID="btn_nuevo" runat="server" Text="Agregar" Visible="true" />
                </td>
            </tr>
            <tr>
                <td colspan="2"right" align="right">
                    <asp:Button ID="btn_grabar" runat="server" Text="Guardar" Visible="false" />&nbsp;
                    <asp:Button ID="btn_cancelar" runat="server" Text="Cancelar" Visible="false" />
                </td>
            </tr>
        </table>
    </fieldset>
    <br />
    <fieldset id="fsEscalaSalarial" runat="server" visible="false" style="width: 425px">
        <legend>Escala Salarial</legend>
        <table>
            <tr>
                <td>
                    <asp:Label ID="lbl_inicio" runat="server">Inicio</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txt_inicio" runat="server" CssClass="fecha" onkeypress="return false;" Width="70"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lbl_final" runat="server">Final</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txt_final" runat="server" CssClass="fecha" onkeypress="return false;" Width="70"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lbl_salario" runat="server">Salario</asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txt_salario" runat="server" onKeyPress="checkNum(event)"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td colspan="6" align="right">
                    <asp:Button ID="btn_agregar" runat="server" Text="Guardar" />&nbsp;  
                    <asp:Button ID="btn_cancelar_det" runat="server" Text="Cancelar" />  
                </td>
            </tr>
            <tr>
                <td colspan="6" align="right">
                    &nbsp;</td>
            </tr>
            <tr>

            <td colspan="6" align="right">
            <asp:GridView id="gvEscalasSalariales" runat="server" AutoGenerateColumns="False" OnRowCommand = "gvEscalasSalariales_RowCommand">
				<Columns>
					<asp:BoundField DataField="COD_SECTOR" HeaderText="Código Sector" Visible="false">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>					
					<asp:BoundField DataField="fecha_ini" HeaderText="Inicio" DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>                     
					<asp:BoundField DataField="fecha_fin" HeaderText="Fin" DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField> 
                                       
                    <asp:BoundField DataField="Salario_Minimo" HeaderText="Salario Minimo" DataFormatString="{0:c}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                        
					</asp:BoundField>
                    
                    <asp:BoundField DataField="ULT_USUARIO_ACT" HeaderText="Modificado Por">
                        <ItemStyle HorizontalAlign="Left" />
					</asp:BoundField>   
                    <asp:BoundField DataField="ULT_FECHA_ACT" HeaderText="Modificado En" 
                        HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>                              
                     <asp:Templatefield>
				     <ItemTemplate >                
                     <asp:Label id="lblSalarioMin" runat="server" text='<%# eval("Salario_Minimo") %>' Visible="false"></asp:Label>
                     <asp:ImageButton id="ibEditar" runat="server" BorderWidth="0px" CausesValidation="False"
						ImageUrl="../images/editar.gif" ToolTip="Editar Escala Salarial"></asp:ImageButton>
                     </ItemTemplate>
					</asp:Templatefield> 
                                                        
		          </Columns> 
			</asp:GridView>             
            </td>
            </tr>
        </table>
    </fieldset>    
    </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

