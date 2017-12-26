<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consSolicitudFacilidadPago.aspx.vb" Inherits="Legal_consSolicitudFacilidadPago" title="Consulta de Solicitudes Ley Facilidades de Pago" %>

<%@ register src="../Controles/Legal/ucDocumentosLeyFacPago.ascx" tagname="ucDocumentosLeyFacPago"
    tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="javascript" type="text/javascript">
	function checkNum()
	    {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
             }
             $(function() {

                 // Datepicker
                 $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

                 $("#ctl00_MainContent_txtDesde").datepicker($.datepicker.regional['es']);
                 $("#ctl00_MainContent_txtHasta").datepicker($.datepicker.regional['es']);

             });
    </script>

    <asp:updatepanel id="updBuscar" runat="server" updatemode="Conditional">
        <contenttemplate>
            <div class="header">Consulta de Solicitudes Ley Facilidades de Pago</div>
            <br />
            <table class="td-content" style="width: 370px" cellpadding="1" cellspacing="0">
                <tr>
                    <td align="right" style="width: 21%">
                        Solicitud:
                    </td>
                    <td style="width: 121px">
                        &nbsp;<asp:TextBox ID="txtSolicitud" onKeyPress="checkNum()" runat="server" EnableViewState="False" width="88px"></asp:TextBox>&nbsp;
                    </td>
                    <td align="right" style="width: 108px; height: 33px">
                        RNC:
                    </td>
                    <td style="width: 125px; height: 33px">
                        &nbsp;<asp:TextBox ID="txtRNC" runat="server" EnableViewState="False" MaxLength="11" width="95px"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                            Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$" SetFocusOnError="True" EnableViewState="False">RNC o Cédula Inválido</asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 21%">
                        Razón Social:
                    </td>
                    <td colspan="3" style="height: 21px">
                        &nbsp;<asp:TextBox ID="txtRazonSocial" runat="server" EnableViewState="False" width="270px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 21%">
                        Fecha Inicial:
                    </td>
                    <td style="width: 121px">
                        &nbsp;<asp:TextBox ID="txtDesde" runat="server" width="69px"></asp:TextBox>
                        
                       
                    </td>
                    <td align="right" style="width: 108px">
                        Fecha Final:
                    </td>
                    <td>
                        &nbsp;<asp:TextBox ID="txtHasta" runat="server" width="69px"></asp:TextBox>
                       
                    </td>
                 </tr>
                 <tr>
                    <td align="center" style="text-align: right" >              Estado:</td>
                    <td align="center" style="text-align: left" >              &nbsp;<asp:dropdownlist id="ddlStatus" runat="server" cssclass="dropDowns">
                            <asp:listitem value="T">&lt;--Todos--&gt;</asp:listitem>
                            <asp:listitem value="A">Normal</asp:listitem>
                            <asp:listitem value="N">Cancelado</asp:listitem>
                            <asp:listitem value="C">Anulado por Oficio</asp:listitem>
                        </asp:dropdownlist></td>  
                    <td align="center" colspan="2" style="text-align: right">              
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CausesValidation="False" />&nbsp;
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />&nbsp; &nbsp;</td>            
                </tr>
                <tr>
                    <td colspan="4" style="height: 14px">
                        &nbsp;</td>
                </tr>
            </table>
            <ajaxtoolkit:autocompleteextender id="ACRazonSocial" runat="server" completionlistcssclass="autocomplete_completionListElement"
                completionlisthighlighteditemcssclass="autocomplete_highlightedListItem" completionlistitemcssclass="autocomplete_listItem"
                servicemethod="getRSList" servicepath="~/Services/AutoComplete.asmx" targetcontrolid="txtRazonSocial">
            </ajaxtoolkit:autocompleteextender>
           
         
                        <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label><br />
    
            <table id="tblData" cellpadding="0" cellspacing="0" runat="server" visible="false">
                <tr>
                    <td>
                        <asp:gridview id="gvData" runat="server" autogeneratecolumns="False" cellpadding="2">
                            <columns>
                                <asp:boundfield headertext="Solicitud" datafield="ID_Solicitud">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:boundfield>
                                <asp:boundfield headertext="Fecha" datafield="Fecha_Solicitud" dataformatstring="{0:d}" htmlencode="False">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:boundfield>                        
                                <asp:boundfield headertext="R.N.C." datafield="Rnc_o_Cedula">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:boundfield>                                                
                                <asp:boundfield headertext="Raz&#243;n Social" datafield="Razon_Social">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:boundfield>
                                <asp:boundfield headertext="Solicitado por" datafield="Nombre_Solicitante">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:boundfield>
                                <asp:boundfield datafield="Status" headertext="Estado" />
                                <asp:boundfield headertext="Registrado Por" datafield="Usuario_Registro">
                                    <ItemStyle HorizontalAlign="Left" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:boundfield>                        
                                <asp:templatefield headertext="Imagen">                           
                                    <itemtemplate>
                                        <a target="_blank" href=' <%# "viewDocumento.aspx?id=" & eval("ID_SOLICITUD") %>'>
                                           <img src= "../images/detalle.gif" style="border:0px;" alt="" /> Mostrar
                                        </a>
                                    </itemtemplate>
                                    <itemstyle horizontalalign="Center" />
                                </asp:templatefield>
                            </columns>
                        </asp:gridview>
                    </td>
                </tr>
            </table>
        </contenttemplate>
        <triggers>
            <asp:asyncpostbacktrigger controlid="btnBuscar" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnLimpiar" eventname="Click" />
        </triggers>
    </asp:updatepanel>
    
</asp:Content>