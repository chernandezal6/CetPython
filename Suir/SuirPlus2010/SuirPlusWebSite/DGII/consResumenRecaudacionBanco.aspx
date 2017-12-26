<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consResumenRecaudacionBanco.aspx.vb" Inherits="DGII_consResumenRecaudacionBanco" title="Consulta Resumen Recaudación por Banco" %>
<%@ Register TagPrefix="uc1" TagName="UC_DatePicker" Src="../Controles/UC_DatePicker.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
		        'Me.PermisoRequerido = 69
				
		    End Sub

              
		</script>
        
        <script language="javascript" type="text/javascript" >
            $(function pageLoad(sender, args) {

                // Datepicker
                $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

                $("#ctl00_MainContent_txtDesde").datepicker($.datepicker.regional['es']);
                $("#ctl00_MainContent_txtHasta").datepicker($.datepicker.regional['es']);

            });
    </script>
    
		
		<div class="header" align="left">Resumen Recaudación por Banco</div><br />

			<TABLE id="Table2" cellSpacing="1" cellPadding="1" border="0" width="550px">
				<TR>
					<TD>
			<TABLE id="Table1" cellSpacing="1" cellPadding="1" border="0">
				<TR>
					<TD align="right">
                        &nbsp;<asp:label id="lbltxtFechaIni" runat="server" Font-Bold="True">Desde: </asp:label></TD>
					<TD>
                        &nbsp;
                        <asp:TextBox ID="txtDesde" runat="server" Width="75px" ></asp:TextBox>
                     
                     </TD>
				</TR>
				<TR>
					<TD align="right">
                        &nbsp;<asp:label id="lbltxtFechaFin" runat="server" Font-Bold="True">Hasta: </asp:label></TD>
					<TD>
                        &nbsp;
                        <asp:TextBox ID="txtHasta" runat="server" Width="75px" ></asp:TextBox>
                       
                    </TD>
				</TR>
				<TR>
					<TD align="left" colSpan="2">
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;<br />
                        &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<asp:button id="btBuscar" runat="server" Text="Buscar" Enabled="True" EnableViewState="False"></asp:button>
                            <asp:button id="btnLimpiar" runat="server" Text="Limpiar" Enabled="True" EnableViewState="False"></asp:button><br />
                    </TD>
				</TR>
			</TABLE>
                        <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="10pt" Visible="False"></asp:Label>
			<asp:Panel ID="pnlPagos" runat="server" Visible="false" width="100%">
			<TABLE id="tblDetalle" cellSpacing="1" cellPadding="1" border="0">
				<TR>
					<TD colSpan="3"><asp:label id="Label1" runat="server" CssClass="subHeader">Pagos: </asp:label></TD>
				</TR>
				<TR>
					<TD colSpan="3">
					<asp:GridView id="gvDetalle" runat="server" AutoGenerateColumns="False">
							<Columns>
								<asp:Boundfield DataField="ID_ENTIDAD_RECAUDADORA" HeaderText="# Entidad"></asp:Boundfield>
								<asp:Boundfield DataField="ENTIDAD_RECAUDADORA_DES" HeaderText="Nombre Entidad"></asp:Boundfield>
								<asp:Boundfield DataField="total_importe" HeaderText="Importe" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="total_recargo" HeaderText="Recargo" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="total_intereses" HeaderText="Intereses" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="sub_total_pagos" HeaderText="Total" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
							</Columns>
							
						</asp:GridView></TD>
				</TR>
			</TABLE>
			</asp:Panel>
			<asp:Panel ID="pnlAclaraciones" runat="server" Visible="false" width="100%">
			<TABLE id="tblDetalle2" cellSpacing="1" cellPadding="1" border="0">
				<TR>
					<TD colSpan="3"><asp:label id="Label3" runat="server" CssClass="subHeader">Aclaraciones: </asp:label></TD>
				</TR>
				<TR>
					<TD colSpan="3"><asp:GridView id="gvDetalle2" runat="server" AutoGenerateColumns="False">

							<Columns>
								<asp:Boundfield DataField="ID_ENTIDAD_RECAUDADORA" HeaderText="# Entidad"></asp:Boundfield>
								<asp:Boundfield DataField="ENTIDAD_RECAUDADORA_DES" HeaderText="Nombre Entidad"></asp:Boundfield>
								<asp:Boundfield DataField="total_importe" HeaderText="Importe" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="total_recargo" HeaderText="Recargo" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="total_intereses" HeaderText="Intereses" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="sub_total_aclaraciones" HeaderText="Total" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
							</Columns>
						</asp:GridView></TD>
				</TR>
			</TABLE>
			</asp:Panel>
			<asp:Panel ID="pnlTotales" runat="server" Visible="false" width="100%">
			<TABLE id="tblDetalle3" cellSpacing="1" cellPadding="1" border="0">
				<TR>
					<TD colSpan="3"><asp:label id="Label4" runat="server" CssClass="subHeader">Totales: </asp:label></TD>
				</TR>
				<TR>
					<TD colSpan="3"><asp:GridView id="gvDetalle4" runat="server" AutoGenerateColumns="False">
							<Columns>
								<asp:Boundfield DataField="ID_ENTIDAD_RECAUDADORA" HeaderText="# Entidad"></asp:Boundfield>
								<asp:Boundfield DataField="ENTIDAD_RECAUDADORA_DES" HeaderText="Nombre Entidad"></asp:Boundfield>
								<asp:Boundfield DataField="sub_total_pagos" HeaderText="Sub-Total Pagos" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="sub_total_aclaraciones" HeaderText="Sub-Total Aclaraciones" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="Total" HeaderText="Totales" DataFormatString="{0:n}">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
							</Columns>
						</asp:GridView>
					</TD>
				</TR>
			</TABLE>
			</asp:Panel>
			
					</TD>
				</TR>
			</TABLE>			

</asp:Content>

