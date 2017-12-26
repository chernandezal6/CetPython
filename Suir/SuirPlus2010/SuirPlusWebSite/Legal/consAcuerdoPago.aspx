<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consAcuerdoPago.aspx.vb" Inherits="Legal_consAcuerdoPago" title="Consulta de Acuerdos de Pago" %>

<%@ register src="../Controles/Legal/ucDocumentosLeyFacPago.ascx" tagname="ucDocumentosLeyFacPago"
    tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="javascript" type="text/javascript">

           /* function ValidateAcuerdo(e)
       	    {
       	     
	        var valor =  document.getElementById('ctl00_MainContent_txtAcuerdo').value
           
             var carCode = (window.event) ? window.event.keyCode : e.which;
            
           if(carCode!=8) 
           {
               if(valor.substring(0,1).toUpperCase()== "A")
	            {
    	        
	               if(valor.length >= 7)
                   {
                         if (window.event) //IE       
                         window.event.returnValue = null;     
                         else //Firefox       
                         e.preventDefault(); 
                   }
    	        	        
	                if ((carCode < 48) || (carCode > 57))
                    {
                         if (window.event) //IE       
                         window.event.returnValue = null;     
                         else //Firefox       
                         e.preventDefault(); 
                     }        
    	        
	            }
	            else
	            {
    	        
	              if(valor.length >= 4)
                  {
                         if (window.event) //IE       
                         window.event.returnValue = null;     
                         else //Firefox       
                         e.preventDefault(); 	
                  }
    	             
    	               
                    if (carCode == 97 || carCode == 65)
                    {
                          document.getElementById('ctl00_MainContent_txtAcuerdo').value = 'AO-'
                         if (window.event) //IE       
                         window.event.returnValue = null;     
                         else //Firefox       
                         e.preventDefault(); 
                    }                
                 
                  
                    if ((carCode < 48) || (carCode > 57))
                    {                     
                        
                         if (window.event) //IE       
                         window.event.returnValue = null;     
                         else //Firefox       
                         e.preventDefault(); 
         
    	            }
	            }
              }
            }*/
              $(function pageLoad(sender, args)
            {     
                // Datepicker
                $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
                $(".fecha").datepicker($.datepicker.regional['es']); 

            });
         
    </script>

    <asp:updatepanel id="updBuscar" runat="server" updatemode="Conditional">
        <contenttemplate>    
            <div class="header">Consulta de Acuerdos de Pago</div>
            <br />
            <table class="td-content" style="width: 370px" cellpadding="1" cellspacing="0">
                <tr>
                    <td align="right" style="width: 21%" nowrap="nowrap">
                        Nro. Acuerdo:
                    </td>
                    <td style="width: 121px">
                        &nbsp;<asp:TextBox ID="txtAcuerdo" onKeyPress="ValidateAcuerdo(event);" runat="server" EnableViewState="False" width="88px"></asp:TextBox>&nbsp;
                    </td>
                    <td align="right" style="width: 58px; height: 33px">
                        RNC:
                    </td>
                    <td style="width: 125px; height: 33px">
                        &nbsp;<asp:TextBox ID="txtRNC" runat="server" EnableViewState="False" MaxLength="11" width="95px"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                            Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$" SetFocusOnError="True" EnableViewState="False">RNC o Cédula Inválido</asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 21%; height: 23px;">
                        Razón Social:
                    </td>
                    <td colspan="3" style="height: 23px">
                        &nbsp;<asp:TextBox ID="txtRazonSocial" runat="server" EnableViewState="False" width="270px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 21%">
                        Fecha Inicial:
                    </td>
                    <td style="width: 121px">
                        &nbsp;<asp:TextBox ID="txtDesde" runat="server" width="69px" CssClass="fecha"></asp:TextBox>
                        &nbsp;
                    </td>
                    <td align="right" style="width: 58px" nowrap="nowrap">
                        Fecha Final:</td>
                    <td>
                        &nbsp;<asp:TextBox ID="txtHasta" runat="server" width="69px" CssClass="fecha" ></asp:TextBox>
                        &nbsp;
                    </td>
                 </tr>
                <tr>
                    <td align="right" style="width: 21%">
                        Estado:</td>
                    <td style="width: 121px">
                        &nbsp;<asp:dropdownlist cssclass="dropDowns" id="ddlStatus" runat="server">
                        </asp:dropdownlist></td>
                    <td colspan="2" style="text-align: center">
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CausesValidation="False" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" /></td>
                </tr>
                <tr>
                    <td colspan="4" style="height: 15px">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
                    </td>
                </tr>
            </table>
            <asp:Panel ID="pnlTaps" runat="server" Visible="false">
                <table id="tblTabPanels" style="width: 370px" cellpadding="0" cellspacing="0">
                <tr>
                    <td>
                     <ajaxToolkit:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0">
            
                        <ajaxToolkit:TabPanel id="tpDatosGenerales" runat="server" HeaderText="Datos Generales">
                            <ContentTemplate>
                                <asp:Panel ID="pnlInfoEmpleador" runat="server" Visible="False">
                                
                                    <table cellpadding="3" cellspacing="0" id="tblInfoEmpleador" runat="server" style="width: 370px" class="td-content" >
                            <tr runat="server">
                                <td align="right" style="text-align: left" colspan="2" runat="server" >
                                    <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Empleador:"></asp:Label></td>
                            </tr>
                            <tr runat="server">
                                <td align="right" style="width: 94px" runat="server">
                                        <asp:Label ID="Label2" runat="server" Text="R.N.C:"></asp:Label></td>
                                <td runat="server">
                                    <asp:Label ID="lblRnc" runat="server" Font-Bold="True"></asp:Label></td>
                            </tr>
                            <tr runat="server">
                                <td align="right" style="width: 94px" runat="server">
                                        <asp:Label ID="lbltxtRazonSocial" runat="server" Text="Razón Social:"></asp:Label></td>
                                <td runat="server">
                                    <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label></td>
                            </tr>
                            <tr runat="server">
                                <td align="right" style="width: 94px" runat="server">
                                        <asp:Label ID="lbltxtNombreComercial" runat="server" Text="Nombre Comercial:"></asp:Label></td>
                                <td runat="server">
                                    <asp:Label ID="lblNombreComercial" runat="server" Font-Bold="True"></asp:Label></td>
                            </tr>
                            </table>
                                </asp:Panel>
                                <br />
                                <asp:Panel ID="pnlRepresentantes" runat="server" Visible="False">
                                    <table>                               
                                <tr>
                                    <td align="right" style="text-align: left" colspan="2" >
                                        <asp:Label ID="Label4" runat="server" CssClass="subHeader" 
                                            Text="Representantes:" Width="237px"></asp:Label>
                                            <br />
                                        <asp:GridView ID="gvRepresentantes" runat="server" AutoGenerateColumns="False">
                                            <Columns>
                                                <asp:TemplateField HeaderText="Nombre">
                                                    <EditItemTemplate>
                                                        <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("Nombre") %>'></asp:TextBox>
                                                    </EditItemTemplate>
                                                    <ItemTemplate>
                                                        <asp:Label ID="Label2" runat="server" Text='<%# Bind("Nombre") %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Cedula/Pasaporte">
                                                 <ItemTemplate>
                                                 <a target="_blank" href=' <%# "../Consultas/consCiudadano.aspx?NoDocumento=" & eval("no_documento")%>'><%#formateaRNC(Eval("no_documento"))%></a>
                                                   </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Telefono">
                                                    <ItemTemplate>
                                                    <asp:Label ID="Label3" runat="server" Text='<%# formateaTelefono(ValidarNull(eval("telefono_1"))) %>'></asp:Label>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="Email" HeaderText="Email" />
                                                <asp:TemplateField HeaderText="Tipo">
                                                   <ItemTemplate>
                                                        <asp:Label ID="Label1" runat="server" Text='<%#IIF(Eval("Tipo_Representante")="A","Administrador","Normal") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>  
                                </table>  
                                </asp:Panel>                    
                                <br />    
                                <asp:Panel ID="pnlAcuerdos" runat="server" Visible="False">
                                <table id="tblData" cellpadding="0" cellspacing="0" runat="server" visible="False">
                                <tr runat="server">
                                <td align="right" style="text-align: left" colspan="2" runat="server" >
                                    <asp:Label ID="Label5" runat="server" CssClass="subHeader" 
                                        Text="Acuerdos de Pago:"></asp:Label></td>
                                        
                                </tr>
                                    <tr>
                                        <td><br />
                                            <asp:gridview id="gvData" runat="server" autogeneratecolumns="False" cellpadding="2">
                                                <columns>
                                                    <asp:TemplateField HeaderText="Acuerdo">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label1" runat="server" Text='<%# IIF(eval("TIPO") = 3,"AO-" & EVAL("ID_acuerdo"), "AE-" & EVAL("ID_acuerdo"))  %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                    <asp:boundfield headertext="Tipo" datafield="TipoDesc">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                    </asp:boundfield>
                                                    <asp:boundfield datafield="descripcion_status" headertext="Estado" >
                                                        <ItemStyle Wrap="False" />
                                                    </asp:boundfield>
                                                    <asp:boundfield headertext="Fecha" datafield="Fecha_Registro" dataformatstring="{0:d}" htmlencode="False">
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                    </asp:boundfield>                        
                                                    <asp:BoundField DataField="fecha_anulacion" DataFormatString="{0:d}" 
                                                        HeaderText="Anulado" >
                                                        <ItemStyle Wrap="False" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Inicia">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("Periodo_Ini")) %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="Termina">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label13" runat="server" Text='<%# FormateaPeriodo(eval("Periodo_Fin")) %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateField>
                                                    <asp:TemplateField HeaderText="R.N.C.">
                                                       <ItemTemplate>
                                                            <a target="_blank"  href=' <%# "../Consultas/consEmpleador.aspx?rnc=" & eval("Rnc_o_Cedula")%>'><%#formateaRNC(Eval("Rnc_o_Cedula"))%>
                                                        </a>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                    </asp:TemplateField>
                                                   <asp:boundfield headertext="Razón Social" datafield="razon_social">
                                                        <HeaderStyle Wrap="False" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                    </asp:boundfield>
                                                   <asp:boundfield headertext="Firmado Por" datafield="Nombres">
                                                       <HeaderStyle Wrap="False" />
                                                       <ItemStyle Wrap="False" />
                                                    </asp:boundfield>
                                                    <asp:boundfield headertext="Registrado por" datafield="usuario_registra">
                                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                    </asp:boundfield>
                                                      <asp:BoundField DataField="fechapago" DataFormatString="{0:d}" 
                                                        HeaderText="Fecha Pago" >
                                                        <ItemStyle Wrap="False" />
                                                    </asp:BoundField>    
                                                    <asp:templatefield headertext="Imagen">                           
                                                        <itemtemplate>
                                                            <a target="_blank" href=' <%# "verImagenAcuerdoPago.aspx?idAcuerdo=" & eval("ID_ACUERDO") & "&tipoAcuerdo=" & eval("tipo") %>'>[Ver]
                                                          </a>
                                                        </itemtemplate>
                                                        <itemstyle horizontalalign="Center" />
                                                    </asp:templatefield>
                                                     
                                                     <asp:templatefield headertext="Reimprimir">
                                                    <itemtemplate>
                                                    <a target="_blank" href=' <%# IIF(eval("TIPO") = 3,"adpImprimirAcuerdoPagoPopUp.aspx?idAcuerdoPago=" & eval("ID_ACUERDO") & "&tipoAcuerdo=" & eval("tipo"),"adpImprimirAcuerdoPagoPopUp.aspx?idAcuerdoPago=" & eval("ID_ACUERDO") & "&tipoAcuerdo=" & eval("tipo")) %>'> [Ver]
                                                         </a>                  
                                                    </itemtemplate>
                                                         <HeaderStyle HorizontalAlign="Center" />
                                                         <ItemStyle HorizontalAlign="Center" />                                     
                                                </asp:templatefield>  
                                                                                                         
                                                </columns>
                                            </asp:gridview>
                                        </td>
                                    </tr>
                                </table>
                                </asp:Panel>  
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        
                        <ajaxToolkit:TabPanel id="tpDetalleAP" runat="server" HeaderText="Detalle del Acuerdo de Pago">
                            <ContentTemplate>
                                <asp:Panel ID="pnlDetalleAcuerdo" runat="server" Visible="False">
                                    <table id="Table1" cellpadding="0" cellspacing="0" runat="server">
                                    <tr>
                                    <td align="right" style="text-align: left" runat="server" >
                                        &nbsp;</td>
                                    </tr>
                                        <tr>
                                            <td>
                                                <asp:gridview id="gvDetalleAcuerdo" runat="server" autogeneratecolumns="False" 
                                                    cellpadding="2">
                                                    <columns>                                                
                                                        <asp:BoundField DataField="Cuota" HeaderText="Cuota">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="id_referencia" HeaderText="Referencia">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="status_des" HeaderText="Status" />
                                                        <asp:BoundField DataField="FECHA_LIMITE_PAGO" DataFormatString="{0:d}" 
                                                            HeaderText="Fecha limite Pago" HtmlEncode="False">
                                                            <HeaderStyle Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="FECHA_PAGO" DataFormatString="{0:d}" 
                                                            HeaderText="Fecha Pago" HtmlEncode="False">
                                                            <HeaderStyle Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Banco" HeaderText="Banco" >
                                                            <ItemStyle Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="TOTAL_GENERAL_FACTURA" DataFormatString="{0:c}" 
                                                            HeaderText="Monto Total" HtmlEncode="False">
                                                            <HeaderStyle Wrap="False" />
                                                            <ItemStyle HorizontalAlign="Right" />
                                                        </asp:BoundField>                                             
                                                    </columns>
                                                </asp:gridview>
                                            </td>
                                        </tr>
                                    </table>
                                    </asp:Panel>  
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        
                        <ajaxToolkit:TabPanel id="tpHistorialAP" runat="server" HeaderText="Historial del Acuerdo de Pago">
                            <ContentTemplate>
                        <asp:Panel ID="pnlHistorial" runat="server" Visible="False">
                        <br />
                        <table id="Table2" cellpadding="0" cellspacing="0" runat="server">
                            <tr>
                                <td>
                                    <asp:gridview id="gvHistorial" runat="server" autogeneratecolumns="False" cellpadding="2">
                                        <columns>                                             
                                            <asp:BoundField DataField="StatusDesc" HeaderText="Status" />
                                            <asp:BoundField DataField="nombre_usuario" HeaderText="Usuario" />
                                            <asp:BoundField DataField="fecha" HeaderText="Fecha" />
                                                                                         
                                        </columns>
                                    </asp:gridview>
                                </td>
                            </tr>
                        </table>
                        </asp:Panel> 
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
                        
                        <ajaxToolkit:TabPanel id="tpInfoBanco" runat="server" HeaderText="Bancos">
                            <ContentTemplate>
                                <asp:Panel ID="pnlInfoBanco" runat="server" Visible="False">
                                <br />                    
                                <table id="Table3" cellpadding="0" cellspacing="0" runat="server">
                                <tr>
                                <td>
                                    
                                    <asp:Label ID="lblDisponible" runat="server" CssClass="labelData" Text="Disponibles para pago"></asp:Label>
                                    &nbsp<asp:LinkButton ID="lnkBtnSiLabel" runat="server" Enabled="false">
                                    <img src='../images/ok.gif' alt=''/></asp:LinkButton>
                                    &nbsp&nbsp&nbsp&nbsp
                                    <asp:Label ID="lblNoDisponible" runat="server" CssClass="labelData" Text="No disponibles para pago"></asp:Label>
                                    &nbsp<asp:LinkButton ID="lnkBtnNoLabel" runat="server" Enabled="false">
                                    <img src='../images/error.gif' alt=''/></asp:LinkButton>

                                    </td>
                                </tr>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="gvInfoBanco" runat="server" AutoGenerateColumns="False" EnableTheming="True" Width="421px" >
                                            <Columns>
                                                <asp:BoundField DataField="referencia" HeaderText="Nro. Referencia">
                                                    <HeaderStyle Wrap="False" />
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Nomina" HeaderText="Nomina" >
                                                    <ItemStyle Wrap="False" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Periodo" HeaderText="Periodo">
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="Total_General" DataFormatString="{0:c}" HeaderText="Total"
                                                    HtmlEncode="False">
                                                    <ItemStyle HorizontalAlign="Right" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Pagar">
                                                    <ItemTemplate>
                                                        <asp:Label id="lblPuedePagar" runat="server" Text='<%# Eval("puede_pagar") %>' Visible="False"></asp:Label>                                          
                                                        <asp:LinkButton ID="lnkBtnSi" runat="server" Visible="false" Enabled="false">
                                                        <img src='../images/ok.gif' alt=''/></asp:LinkButton>
                                                        <asp:LinkButton ID="lnkBtnNo" runat="server" Visible="false" Enabled="false">
                                                        <img src='../images/error.gif' alt=''/></asp:LinkButton>
                                                        
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                         </td>
                                    </tr>
                                </table>
                                </asp:Panel> 
                            </ContentTemplate>
                        </ajaxToolkit:TabPanel>
            
                    </ajaxToolkit:TabContainer>
                    </td>
                </tr>
            </table>
            </asp:Panel>

            
            <ajaxtoolkit:autocompleteextender id="ACRazonSocial" runat="server" completionlistcssclass="autocomplete_completionListElement"
                completionlisthighlighteditemcssclass="autocomplete_highlightedListItem" completionlistitemcssclass="autocomplete_listItem"
                servicemethod="getRSList" servicepath="~/Services/AutoComplete.asmx" targetcontrolid="txtRazonSocial">
            </ajaxtoolkit:autocompleteextender>
          <br />
        </contenttemplate>
        <triggers>
            <asp:asyncpostbacktrigger controlid="btnBuscar" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnLimpiar" eventname="Click" />
        </triggers>
    </asp:updatepanel>
    
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 23px; bottom: 2%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
     
</asp:Content>