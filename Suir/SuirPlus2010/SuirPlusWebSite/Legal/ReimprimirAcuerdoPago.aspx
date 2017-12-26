<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ReimprimirAcuerdoPago.aspx.vb" Inherits="Legal_ReimprimirAcuerdoPago" title="Reimprimir Acuerdo de Pago" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="javascript" type="text/javascript">
//	    function ValidateAcuerdo()
//	    {

//            var valor =  document.getElementById('ctl00_MainContent_txtAcuerdo').value
//            var carCode = event.keyCode;
//            
//            if(valor.substring(0,1).toUpperCase() == "A")
//	        {
//	        	        
//	        	if(valor.length >= 7)
//               {
//                    event.cancelBubble = true	
//                    event.returnValue = false;	
//               }
//	            if ((carCode < 48) || (carCode > 57))
//                {
//                    event.cancelBubble = true	
//                    event.returnValue = false;	
//                 }        
//	        
//	        }
//	        else
//	        {
//	        
//	            if(valor.length >= 4)
//              {
//                    event.cancelBubble = true	
//                    event.returnValue = false;	
//              }
//	               
//                if (carCode == 97 ||carCode == 65)
//                {
//                      document.getElementById('ctl00_MainContent_txtAcuerdo').value = 'AO-'
//                      event.cancelBubble = true	
//                      event.returnValue = false;          
//              	
//                }
//            
//                if ((carCode < 48) || (carCode > 57))
//                {
//                    event.cancelBubble = true	
//                    event.returnValue = false;	
//                 }        
//	        
//	        }
//            
//        }
    </script>
    <asp:updatepanel id="updAcuerdos" runat="server" updatemode="Conditional">
        <contenttemplate>

            <div class="header">Reimprimir Acuerdos de Pago por Empleador</div>
            <br />
            <br />
            <table class="tblWithImagen" cellspacing="1" cellpadding="1" border="0">
                <tr>
                    <td rowspan="4">
                    <img src="../images/Legal.jpg" alt=""/>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:label id="lbltxtRNC" runat="server" font-bold="True" text="RNC/Cédula"></asp:label>
                    </td>
                    <td>
                        &nbsp;<asp:textbox id="txtRNC" runat="server" enableviewstate="False" maxlength="11" onKeyPress="checkNum()"></asp:textbox>
                        <asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" controltovalidate="txtRNC"
                            display="Dynamic" errormessage="RegularExpressionValidator" setfocusonerror="True"
                            validationexpression="^(\d{9}|\d{11})$">RNC o Cédula Inválido</asp:regularexpressionvalidator>
                        &nbsp;&nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:label id="lblAcuerdo" runat="server" text="Nro. Acuerdo" font-bold="true"></asp:label>
                    </td>
                    <td>
                        &nbsp;<asp:textbox id="txtAcuerdo" runat="server" onkeypress="ValidateAcuerdo();"></asp:textbox></td>
                </tr>
                <tr>
                    <td>
                    </td>
                    <td>
                        <asp:button id="btnBuscar" runat="server" text="Buscar" />&nbsp;
                        <asp:button id="btnLimpiar" runat="server" text="Cancelar" />
                    </td>
                </tr>
            </table>
            <asp:label id="lblMensaje" runat="server" cssclass="label-Resaltado"></asp:label>
            <br />
            <br />
            <asp:panel id="pnlAcuerdo" runat="server" visible="false">
                <fieldset style="width:400px">
                    <legend>Información del Empleador</legend>
                    <div style="height:4px"></div>
                    <table id="tbl_info" class="td-content" cellspacing="1" cellpadding="1" width="400px">
                        <tr>
                            <td style="width: 95px" align="right">
                                <asp:label id="lblRazonSocial" text="Razón Social:" runat="server"></asp:label>&nbsp;
                            </td>
                            <td>
                                <asp:label id="txtRazonSocial" runat="server" font-bold="true"></asp:label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 95px" align="right">
                                <asp:label id="lblNombreComercial" text="Nombre Comercial:" runat="server"></asp:label>&nbsp;
                            </td>
                            <td>
                                <asp:label id="TxtNombreComercial" runat="server" font-bold="true"></asp:label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 95px" align="right">
                                <asp:label id="lblTelefono" text="Teléfono:" runat="server"></asp:label>&nbsp;
                            </td>
                            <td>
                                <asp:label id="txtTelefono" runat="server" font-bold="true"></asp:label>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <fieldset>
                    <legend>Acuerdos de Pagos del Empleador</legend>
                    <div style="height:4px"></div>
                    <asp:gridview id="gvAcuerdos" runat="server" autogeneratecolumns="False" onrowcommand="gvAcuerdos_RowCommand">
                        <columns>
                            <asp:TemplateField HeaderText="Nro.">
                                
                                <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%#  IIF(eval("TIPO") = 3,"AO-" & EVAL("ID_acuerdo") , "AE-" & EVAL("ID_acuerdo"))  %>'></asp:Label>
                                   
                                    </ItemTemplate>
          
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:boundfield datafield="acuerdo" headertext="Descripci&#243;n" >
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle Width="200px" />
                            </asp:boundfield>
                            <asp:boundfield datafield="status" headertext="Estado" >
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle Width="70px" />
                            </asp:boundfield>
                            <asp:boundfield datafield="cuotas" headertext="Cuota" >
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Right" Width="50px" />
                            </asp:boundfield>
                            <asp:boundfield datafield="periodo_ini" headertext="Per&#237;odo Inicial">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="95px" />
                            </asp:boundfield>
                            <asp:boundfield datafield="periodo_fin" headertext="Per&#237;odo Final">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" Width="95px" />
                            </asp:boundfield>
                            <asp:templatefield headertext="Mostrar">
                                <itemtemplate>
                                    <asp:linkbutton id="lnkIdAcuerdo" runat="server" text="[Ver]" commandargument='<%# Eval("id_acuerdo") & "|" & Eval("tipo") %>' />
                                </itemtemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:templatefield>
                        </columns>
                    </asp:gridview>
                </fieldset>
            </asp:panel>            
        </contenttemplate>
        <triggers>
            <asp:asyncpostbacktrigger controlid="btnBuscar" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnLimpiar" eventname="Click" />
        </triggers>
    </asp:updatepanel>

</asp:Content>