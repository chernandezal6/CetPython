<%@ Page Language="VB" MasterPageFile="~/SuirPlusNoAutenticado.master" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" title="Login - SuirPlus" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">    
    <script type="text/javascript">
        $(function () {
            var requestip = 0;
           
            $.getJSON('http://freegeoip.net/json/', function (location) {
                requestip = location.ip;
                $("#ctl00_MainContent_ipvalue").val(requestip);
            });

        });
    </script>
    <input type="hidden" id="ipvalue" value="0" runat="server">
    <div class="centered">       
        <table id="tblLoginUsuario" cellpadding="0" cellspacing="0" runat="server">
            <tr>
	            <td colspan="3" rowspan="1"><img alt="" src="images/SuirPLogin_r1_c1.gif" style="height:56px; width:330px; border:0px;" /></td>	        
            </tr>
		    <tr>
		        <td valign="top" rowspan="2" align="left">
		            <img alt="" src="images/SuirPLogin_r2_c1.gif" style="height:94px; width:38px; border:0px"; />
		         </td>
		        <td align="center">
			        <table id="table7" style="width:100%" cellspacing="0" border="0">
				        <tr>
					        <td class="header" colspan="2">Acceso de Usuarios</td>
				        </tr>
				        <tr>
					        <td colspan="2" style="height:10px;"></td>
				        </tr>

				        <tr>
					        <td align="right"><span style="font-size:11px;">Nombre de Usuario</span></td>
					        <td>
						        <asp:textbox id="txtUserName" runat="server"></asp:textbox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUserName"
                                    CssClass="error" ErrorMessage="Debe especificar el usuario." SetFocusOnError="True"
                                    ValidationGroup="Usuarios">*</asp:RequiredFieldValidator>
						    </td>
				        </tr>
				        <tr>
					        <td align="right"><span style="font-size:11px;">CLASS</span></td>
					        <td>
						        <asp:textbox id="txtClass" runat="server" TextMode="Password"></asp:textbox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtClass"
                                    CssClass="error" ErrorMessage="Debe específicar el class." SetFocusOnError="True"
                                    ValidationGroup="Usuarios">*</asp:RequiredFieldValidator></td>
				        </tr>
	                <tr>
                        <td colspan="2"  style="height: 18px;" align="center" > 
                           <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Usuarios" />
                        </td>
                    </tr>
			        </table>
			        <asp:button id="btLogin" runat="server" Text="Aceptar" ValidationGroup="Usuarios"></asp:button>&nbsp;
			        <asp:button id="Button1" runat="server" Text="Cancelar" CausesValidation="False"></asp:button><br /><br />			    
			        <asp:LinkButton id="lbtnCambioClass" runat="server">Cambie su CLASS</asp:LinkButton>&nbsp;|&nbsp;
                    <asp:LinkButton id="lbtnRecuperarClassUsuario" runat="server">Recupere su CLASS</asp:LinkButton></td>
		        <td valign="top" rowspan="2" align="right" style="width: 41px">
		            <img alt="" src="images/SuirPLogin_r2_c3.gif" style="height:94px; width:41px; border:0px;" />
		        </td>
		        <td>
		            <img alt="" src="images/spacer.gif" style="height:1px; width:1px; border:0px;" />
		        </td>
		        
	        </tr>  	   
        </table>
    </div>
    <div class="centered">													
	    <table id="tblRep" cellspacing="0" cellpadding="0" border="0" runat="server">									
		    <tr>
                <td colspan="3"><img alt="" src="images/SuirPLogin_r1_c1.gif" style="width:330px; height:56px; border:0;" /></td>            
            </tr>
		    <tr>
			    <td valign="top" rowspan="2">
			        <img alt="" src="images/SuirPLogin_r2_c1.gif" style="width:38px; height:94px; border:0;" />
			    </td>
			    <td align="center">
				    <table id="table4" style="border-spacing:1px; width:100%; border:0px;">
					    <tr>
						    <td colspan="2"><span class="header">Acceso de Representantes</span></td>
					    </tr>
					    <tr>
						    <td colspan="2" style="height:10px;"></td>
					    </tr>
					    <tr>
						    <td align="right"><span style="font-size:11px;">RNC o Cédula</span></td>
						    <td>
							    <asp:TextBox id="txtrncCedula" MaxLength="11" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtrncCedula"
                                    ErrorMessage="Debe incluir RNC o Cédula" SetFocusOnError="True" ValidationGroup="Representante">*</asp:RequiredFieldValidator></td>
					    </tr>
					    <tr>
						    <td align="right"><span style="font-size:11px;">Cédula</span></td>
						    <td>
							    <asp:TextBox id="txtrepresentante" MaxLength="25" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtrepresentante"
                                    ErrorMessage="Debe Incluir la cédula" SetFocusOnError="True" ValidationGroup="Representante">*</asp:RequiredFieldValidator></td>
					    </tr>
					    <tr>
						    <td align="right"><span style="font-size:11px;">CLASS</span></td>
						    <td>
							    <asp:textbox id="txtClassRep" runat="server" TextMode="Password">123</asp:textbox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtClassRep"
                                    ErrorMessage="Debe incluir el CLASS" SetFocusOnError="True" ValidationGroup="Representante">*</asp:RequiredFieldValidator></td>
					    </tr>

	                <tr>
                        <td colspan="2"  style="height: 18px;" align="center" runat="server" >
                            <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="Representante" />
                        </td>
                    </tr>
				    </table>
				    <asp:button id="btLoginRep" runat="server" Text="Aceptar" ValidationGroup="Representante"></asp:button>&nbsp;
				    <asp:button id="Button2" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
				    <br /><br />
				    <asp:LinkButton id="lbtnCambioClass2" runat="server">Cambie su CLASS</asp:LinkButton>&nbsp;|&nbsp;
                    <asp:LinkButton id="lbtnRecuperarClassRep" runat="server">Recupere su CLASS</asp:LinkButton></td>
			    <td valign="top" rowspan="2">
			        <img alt="" src="images/SuirPLogin_r2_c3.gif" style="width:41px; height:94px; border:0;"/>
			    </td>			
		    </tr>		
	    </table>
    </div>	
	<div class="centered">
        <br />
        <asp:Label id="lblError" runat="server" CssClass="error" Visible="False" EnableViewState="False"/>&nbsp;</div><br />
	<div class="centered">
	        <table>
	        <tr>
	             <td align="center">           
	                <img src="images/logoTSShorizontal.gif" alt="Logo TSS" style="width:185; height:60;" />                     	
                </td>
	        </tr>
            <tr>               
                <td>
                    <p>
                        Bienvenido al Sistema Único de Información del Sistema Dominicano de Seguridad 
	                    Social. Operado por la TSS con acceso las 24 horas los 7 días de la semana, el 
	                    cual&nbsp;le permite de una forma ágil, cómoda y segura registrar sus 
	                    obligaciones con la Seguridad Social y las retenciones de ISR de los 
	                    asalariados de su empresa o negocio.
	                    <br /><br />
                        Para 
                        acceder a este Sistema usted necesita su CLASS (Clave de Acceso a la Seguridad 
                        Social), además del número de RNC o cédula que identifica su empresa o negocio.
                        <br /><br />
                        Para solicitud de registro, seleccione la sección de "Servicios" en nuestra página Web
                        <a title="http://www.tss.gov.do/" href="http://www.tss.gov.do/" target="_blank">www.tss.gov.do</a>
                     </p>	
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

