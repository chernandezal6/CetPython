<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="AsignacionSalarialEmpresa.aspx.vb" Inherits="Empleador_IngresarSectorEmpleadores" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

   <asp:UpdatePanel ID="upBotones" runat="server" UpdateMode="Conditional">
      
        <ContentTemplate>
        
        <div id="head" class="header" ><span>Asignación de Sector Salarial</span></div> 
        <div id="ElContenido">
            <br /> 
            <table class="td-content" style="width: 350px" cellpadding="1" cellspacing="0">
                <tr>
                    <td align="right" style="width: 20%">
                        RNC&nbsp;
                    </td>
                    <td style="width: 65%">
                        <asp:TextBox ID="txtRNC" onKeyPress="checkNum()" runat="server" EnableViewState="False"
                            MaxLength="11"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                            Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$"
                            SetFocusOnError="True" EnableViewState="False">RNC o Cédula Inválido</asp:RegularExpressionValidator>
                    </td>
                </tr>
              <tr>
                    <td align="right" style="width: 20%">
                        Razón Social&nbsp;
                    </td>
                    <td style="width: 65%">
                        <asp:TextBox ID="txtRazonSocial" runat="server" Width="261px" 
                            EnableViewState="False" Height="16px"></asp:TextBox>
                    </td>
                </tr>
             
              <tr>
                    <td align="right" style="width: 20%">
                    </td>
                    <td style="width: 65%">
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%">
                    </td>
                    <td style="width: 65%">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                    </td>
                </tr>
                
            </table>
            
            <ajaxToolkit:AutoCompleteExtender ID="acRazonSocial" runat="server" CompletionListCssClass="autocomplete_completionListElement"
                CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem" CompletionListItemCssClass="autocomplete_listItem"
                MinimumPrefixLength="2" ServiceMethod="getRSList" ServicePath="~/Services/AutoComplete.asmx"
                TargetControlID="txtRazonSocial">
            </ajaxToolkit:AutoCompleteExtender>
              <br />
             
             <table id="OtroAlgo2">
               <tr>
                  <td >
                  
                     <div ID="divDetalleEmpresa" runat="server" align="left" Visible="false">
                   <fieldset>
                                 <legend>Detalle Del Empleador</legend>
                                 <br />
                                 <table id="OtroAlgo">
                                    <tr>
                                        <td>
                                            <table>
                                                <tr>
                                                    <td>
                                                        RNC/Cédula</td>
                                                    <td align="left">
                                                        <asp:Label ID="lblRNC" runat="server" CssClass="labelData" />
                                                    </td>
                                                    <td >
                                                        Registro Patronal</td>
                                                    <td style="text-align: left;">
                                                        <asp:Label ID="lblRegPatronal" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="text-align: left;">
                                                        <div>
                                                            Razón Social</div>
                                                        <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="text-align: left; width=250px;">
                                                        <div>
                                                            Sector Económico</div>
                                                        <asp:Label ID="lblSectorEconomico" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="4" style="text-align: left;">
                                                        <div>
                                                            Nombre Comercial</div>
                                                        <asp:Label ID="lblNombreComercial" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left;">
                                                        Tipo de Empresa
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblTipoEmpresa" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style="text-align: left; ">
                                                        Fax</td>
                                                    <td style="text-align: left;">
                                                        <asp:Label ID="lblFax" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left;">
                                                        Segundo Teléfono
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblTelefono2" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style="text-align: left; ">
                                                        Primer Teléfono</td>
                                                    <td style="text-align: left; width:100px;">
                                                        <asp:Label ID="lblTelefono1" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left;">
                                                        Email</td>
                                                    <td style=" text-align: left; width:100px;">
                                                        <asp:Label ID="lblEmail" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style="text-align: left; ">
                                                        Calle</td>
                                                    <td style="text-align: left;">
                                                        <asp:Label ID="lblCalle" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2" style="text-align: left;">
                                                        Representantes</td>
                                                    <td style="text-align: left; ">
                                                        &nbsp;</td>
                                                    <td style="text-align: left;">
                                                        &nbsp;</td>
                                                </tr>
                                            </table>
                                        </td>
                                        <td >
                                            <table>
                                                <tr>
                                                    <td style=" text-align: left;">
                                                        &nbsp; Número
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblNumero" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        Municipio </td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style=" text-align: left;">
                                                        &nbsp; Edificio</td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblEdificio" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        Sector</td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblSector" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style=" text-align: left;">
                                                        &nbsp; Piso
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblPiso" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        Provincia</td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblProvincia" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style=" text-align: left;">
                                                        &nbsp; Apartamento</td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblApartamento" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        &nbsp;</td>
                                                    <td style=" text-align: left;">
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left;">
                                                        &nbsp; Inicio de&nbsp;&nbsp; Operaciones</td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblFechaInicioOperacion" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style="text-align: left">
                                                        Fecha Registro</td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblFechaRegistro" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style=" text-align: left;">
                                                        &nbsp; Fecha&nbsp;&nbsp; Constitución</td>
                                                    <td style=" text-align: left;">
                                                        <asp:Label ID="lblFechaConstitucion" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style=" text-align: left;">
                                                        &nbsp;</td>
                                                    <td style=" text-align: left;">
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: left; height: 37px;">
                                                        &nbsp; Administración Local</td>
                                                    <td style=" text-align: left; height: 37px;">
                                                        <asp:Label ID="lblAdministracionLocal" runat="server" 
                                                            CssClass="labelData"></asp:Label>
                                                    </td>
                                                    <td style="height: 37px; text-align: left">
                                                        Estatus</td>
                                                    <td style=" text-align: left; height: 37px;">
                                                        <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                 </table>
                               
                                 
                             <asp:DataList ID="dtRepresentante" runat="server" RepeatColumns="2" ShowFooter="False"
                                    ShowHeader="False" CellSpacing="5">
                                    <ItemTemplate>
                                        <table class="tblContact" cellspacing="0" cellpadding="3" style="width: 300px;">
                                            <tr>
                                                <td class="tdContactHeader" colspan="3">
                                                    <asp:Label ID="lblRepresentante" runat="server" Text='<%# Eval("NOMBRE") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 25%">
                                                    Cédula/Pasaporte:
                                                </td>
                                                <td colspan="2">
                                                    <asp:Label ID="lblRedCedula" runat="server" Text='<%# formatCedula(Eval("NO_DOCUMENTO")) %>'>
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Teléfono:
                                                </td>
                                                <td colspan="2">
                                                    <asp:Label ID="lblRepTelefono" runat="server" Text='<%# formatTelefono(Eval("TELEFONO_1")) %>'
                                                        Width="150px"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Email:
                                                </td>
                                                <td colspan="2">
                                                    <asp:Label ID="lblRepEmail" runat="server" Text='<%# Eval("EMAIL") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Tipo:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblTipo" runat="server" Text='<%#IIF(Eval("Tipo_Representante")="A","Administrador","Normal") %>' />
                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:DataList>
                             <br />
                             <br />
                             <table id="AsignarSectorSalarial" width="100%">
                            <tr>
                                <td style="text-align: center;font-size:medium;font-weight:bold">
                                    Capital:
                                    <asp:Label ID="lblCapital" runat="server" CssClass="labelData" 
                                        Font-Size="Small"></asp:Label>
                                </td>
                                </tr>
                                <tr>
                                
                                <td style="text-align: center; font-size: medium; font-weight: bold;">
                                    Sector Salarial:
                                    <asp:DropDownList ID="ddlescalasalarial" runat="server">
                                    </asp:DropDownList>
                                   
                                  
                                </td>
                            </tr>
                            
                              
                          
                                <tr>
                                
                                <td style="text-align: center;">
                                    <asp:Button ID="btnAsignarEscala" runat="server" Text="Asignar Sector Salarial" 
                                        
                                        ToolTip="Asignar Escala  Salarial" />
                                   
                                   <asp:Button ID="btnvolverlistado" runat="server" Text="Volver Al Listado" 
                                        ToolTip="Volver al Listado" />
                                   
                                  
                                </td>
                            </tr>
                            
                              
                          
                             </table>        
                                
                    </fieldset>
               </div>
                   
              <asp:Panel ID="pnlGridEmpleadores" runat="server" Visible="false" Width="100%">
              
                <table id="Table1" cellpadding="0" cellspacing="0" style="width: 51%">
                    <tr>
                        <td style="height: 103px">
                            <asp:GridView ID="gvEmpleadores" runat="server" AutoGenerateColumns="False" Width="680px">
                                <Columns>
                                    <asp:BoundField DataField="RNC_O_CEDULA" HeaderText="RNC">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ID_REGISTRO_PATRONAL" HeaderText="Reg. Patronal">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RAZON_SOCIAL" HeaderText="Raz&#243;n Social">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NOMBRE_COMERCIAL" HeaderText="Nombre Comercial">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                      <asp:TemplateField HeaderText="Teléfono 1" >
                                        <ItemStyle HorizontalAlign="Center" Wrap = "false" />
                                        <ItemTemplate>
                                            <asp:Label ID="lklTelefono" runat="server" Text='<%# formatTelefono(Eval("TELEFONO_1")) %>'>
                                            </asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Teléfono 2">
                                        <ItemStyle HorizontalAlign="Center" Wrap = "false" />
                                        <ItemTemplate>
                                            <asp:Label ID="lkltelefono1" runat="server" Text='<%# formatTelefono(Eval("TELEFONO_2")) %>'>
                                            </asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemStyle HorizontalAlign="Center" Wrap = "false"/>
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkVer" runat="server" CommandArgument='<%# Eval("ID_REGISTRO_PATRONAL") %>'
                                                CommandName="Ver" Text="[Ver]">
                                            </asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                        <tr>
                          <td>
                          
                              <asp:Label ID="lblMensajeAsignacion" runat="server" CssClass="error" 
                                  EnableViewState="False"></asp:Label>
                          
                          </td>
                        </tr>
                    </tr>
                </table>
            </asp:Panel>
                  </td>
               </tr>
             </table>
             
              <br />
</div>                    
        </ContentTemplate>
        
    </asp:UpdatePanel>
   
</asp:Content>

