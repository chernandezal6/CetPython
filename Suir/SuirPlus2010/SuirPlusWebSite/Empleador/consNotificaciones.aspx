<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consNotificaciones.aspx.vb" Inherits="Empleador_consNotificaciones"
    Title="Estado de Cuentas" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc2" %>
<%@ Register Src="../Controles/ucSolicitudByRNC.ascx" TagName="ucSolicitudByRNC"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <uc2:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <fieldset style="width: 400px">
        <legend>Datos Generales</legend>
        <br />
        <asp:Label ID="lblRNC" runat="server" CssClass="lbl" Style="font-size: 11px"></asp:Label><br />
        <asp:Label ID="lblRazonSocial" runat="server" CssClass="lbl" Style="font-size: 11px"></asp:Label><br />
    </fieldset>
    <br />
    <br />
   <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server">--%>
        <%--<--%><%--ContentTemplate>--%>
            <ajaxToolkit:TabContainer ID="tbContainer" runat="server" ActiveTabIndex="0" AutoPostBack="True">
                <ajaxToolkit:TabPanel ID="EstadoDeCuentas" runat="server" HeaderText="EstadoDeCuentas">
                    <ContentTemplate>
                        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 100%">
                            <tr>
                                <td>
                                    <img id="imgTSS" runat="server" height="60" src="../images/logoTSShorizontal.gif"
                                        width="185" />
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</img></img></img><asp:Label
                                        ID="lblTituloSS" runat="server" CssClass="subHeader"> Notificaciones de la Seguridad Social</asp:Label>
                                    <asp:DropDownList ID="ddlStatusTSS" runat="server" AutoPostBack="True" CssClass="dropDowns"
                                        OnSelectedIndexChanged="ddlStatusTSS_SelectedIndexChanged">
                                        <asp:ListItem Value="VIVE">Vigente &amp; Vencida</asp:ListItem>
                                        <asp:ListItem Value="PAAC">Pagada</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:GridView ID="dgNotificaciones" runat="server" ShowFooter="True" AutoGenerateColumns="False"
                                        Width="840px">
                                        <Columns>
                                            <asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:BoundField>
                                            <asp:BoundField DataField="status" HeaderText="Status">
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:BoundField>
                                            <asp:BoundField DataField="Nomina_des" HeaderText="Nomina"></asp:BoundField>
                                            <asp:TemplateField HeaderText="Per&#237;odo">
                                                <ItemTemplate>
                                                    <asp:Label runat="server" Text='<%# FormatearPeriodo(Eval("Periodo_Factura")) %>'></asp:Label>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="FECHA_EMISION" HeaderText="Emisi&#243;n" DataFormatString="{0:d}"
                                                HtmlEncode="False">
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            </asp:BoundField>
                                            <asp:BoundField DataField="total_importe" HeaderText="Importe" HtmlEncode="False"
                                                DataFormatString="{0:n}">
                                                <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                                <FooterStyle HorizontalAlign="Right" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="total_recargo" HeaderText="Recargos" HtmlEncode="False"
                                                DataFormatString="{0:n}">
                                                <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                                <FooterStyle HorizontalAlign="Right" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="total_interes" HeaderText="Intereses" HtmlEncode="False"
                                                DataFormatString="{0:n}">
                                                <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                                <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                            </asp:BoundField>
                                            <asp:BoundField DataField="monto_ajuste" HeaderText="Monto Ajuste" HtmlEncode="False"
                                                DataFormatString="{0:n}">
                                                <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                                <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                            </asp:BoundField>
                                            <asp:BoundField DataField="total_general" HeaderText="Total" HtmlEncode="False" DataFormatString="{0:n}">
                                                <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                                <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                            </asp:BoundField>
                                        </Columns>
                                        <FooterStyle Font-Bold="True" />
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblAvisoBancos" runat="server" CssClass="label-Blue" EnableViewState="False"></asp:Label>&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>&nbsp;
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <HeaderTemplate>
                        Notificaciones de Pago de la TSS
                    </HeaderTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="Liquidaciones" runat="server" HeaderText="Liquidaciones">
                    <HeaderTemplate>
                        Liquidaciones del ISR
                    </HeaderTemplate>
                    <ContentTemplate>
                        <img id="imgDGII" runat="server" height="69" src="../images/LogoNewDGII.jpg" width="150" /><asp:Label
                            ID="lblTituloISR" runat="server" CssClass="subHeader"> Liquidaciones del ISR</asp:Label>
                        <asp:DropDownList ID="ddlStatusISR" runat="server" AutoPostBack="True" CssClass="dropDowns"
                            OnSelectedIndexChanged="ddlStatusISR_SelectedIndexChanged">
                            <asp:ListItem Value="VIVE">Vigente &amp; Vencida</asp:ListItem>
                            <asp:ListItem Value="PAAC">Pagada</asp:ListItem>
                            <asp:ListItem Value="EX">Exentas</asp:ListItem>
                        </asp:DropDownList>
                        <asp:GridView ID="dgLiquidaciones" runat="server" ShowFooter="True" AutoGenerateColumns="False"
                            Width="840px">
                            <Columns>
                                <asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="status" HeaderText="Status">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Per&#237;odo">
                                    <ItemTemplate>
                                        <asp:Label runat="server" Text='<%# FormatearPeriodo(Eval("Periodo_Factura")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="FECHA_EMISION" HeaderText="Emisi&#243;n" DataFormatString="{0:d}"
                                    HtmlEncode="False">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="total_importe" HeaderText="Importe" HtmlEncode="False"
                                    DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="total_recargo" HeaderText="Recargos" HtmlEncode="False"
                                    DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="total_interes" HeaderText="Intereses" HtmlEncode="False"
                                    DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="total_general" HeaderText="Total" HtmlEncode="False" DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                </asp:BoundField>
                            </Columns>
                            <FooterStyle Font-Bold="True" />
                        </asp:GridView>
                        <br />
                        <br />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                    <ajaxToolkit:TabPanel ID="PreLiquidacion" runat="server" HeaderText="Pre-Liquidación">
                    <HeaderTemplate>
                        Pre-Liquidación del ISR
                    </HeaderTemplate>
                    <ContentTemplate>
                        <img id="img2" runat="server" height="69" src="../images/LogoNewDGII.jpg" width="150" /><asp:Label
                            ID="Label7" runat="server" CssClass="subHeader">Pre-Liquidación</asp:Label>
                        <asp:GridView ID="gvPreLiquidaciones" runat="server" ShowFooter="True" AutoGenerateColumns="False"
                            Width="500px">
                            <Columns>
                                <asp:TemplateField HeaderText="Per&#237;odo">
                                    <ItemTemplate>
                                        <asp:Label ID="lblPeriodo" runat="server" Text='<%# Eval("Periodo")  %>'></asp:Label>
                                        <asp:Label Visible="false" ID="lblTipo" runat="server" Text='<%# Eval("Id_tipo_factura")  %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateField>
                                <asp:BoundField DataField="tipo_liquidacion" HeaderText="Tipo Liquidacion">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="Total_pagado" HeaderText="Total Pagado" HtmlEncode="False"
                                    DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                </asp:BoundField>
                            </Columns>
                            <FooterStyle Font-Bold="True" />
                        </asp:GridView>
                        <br />
                        <br />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="INFOTEP" runat="server" HeaderText="INFOTEP">
                    <HeaderTemplate>
                        INFOTEP
                    </HeaderTemplate>
                    <ContentTemplate>
                        <img id="imgINF" runat="server" height="77" src="../images/LogoInfotep.jpg" width="108" /><asp:Label
                            ID="lblTituloINF" runat="server" CssClass="subHeader">Liquidaciones del INFOTEP</asp:Label>
                        <asp:DropDownList ID="ddlStatusINF" runat="server" AutoPostBack="True" CssClass="dropDowns"
                            OnSelectedIndexChanged="ddlStatusINF_SelectedIndexChanged">
                            <asp:ListItem Value="VIVE">Vigente &amp; Vencida</asp:ListItem>
                            <asp:ListItem Value="PAAC">Pagada</asp:ListItem>
                        </asp:DropDownList>
                        <asp:GridView ID="dgLiqINF" runat="server" ShowFooter="True" AutoGenerateColumns="False"
                            Width="840px">
                            <Columns>
                                <asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="status" HeaderText="Status">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Per&#237;odo">
                                    <ItemTemplate>
                                        <asp:Label runat="server" Text='<%# FormatearPeriodo(Eval("Periodo_Factura")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="FECHA_EMISION" HeaderText="Emisi&#243;n" DataFormatString="{0:d}"
                                    HtmlEncode="False">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="total_general" HeaderText="Total" HtmlEncode="False" DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                </asp:BoundField>
                            </Columns>
                            <FooterStyle Font-Bold="True" />
                        </asp:GridView>
                        <br />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
               <%-- SE COMENTO A SOLICITUD DEL TASK 8194--%>
                 <%--<ajaxToolkit:TabPanel Visible="true" ID="MDT" runat="server" HeaderText="MDT">
                    <HeaderTemplate>
                        Ministerio de Trabajo
                    </HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <img id="img1" runat="server" src="../images/LogoMDT.jpg" />
                                </td>
                                <td>
                                    <asp:Label ID="Label4" runat="server" CssClass="subHeader">Formularios del Ministerio de Trabajo</asp:Label>
                                    <asp:DropDownList ID="ddlStatusMDT" runat="server" AutoPostBack="True" CssClass="dropDowns"
                                        OnSelectedIndexChanged="ddlStatusMDT_SelectedIndexChanged">
                                        <asp:ListItem Value="VIVE">Vigente &amp; Vencida</asp:ListItem>
                                        <asp:ListItem Value="PAAC">Pagada</asp:ListItem>
                                    </asp:DropDownList>
                                </td>
                            </tr>
                        </table>
                        <asp:GridView ID="dgPlanillasMDT" runat="server" ShowFooter="True" AutoGenerateColumns="False"
                            Width="840px">
                            <Columns>
                                <asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="tipo_formulario" HeaderText="Tipo Formulario">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="status" HeaderText="Status">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Per&#237;odo">
                                    <ItemTemplate>
                                        <asp:Label ID="Label6" runat="server" Text='<%# FormatearPeriodo(Eval("Periodo_Factura")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="FECHA_EMISION" HeaderText="Emisi&#243;n" DataFormatString="{0:d}"
                                    HtmlEncode="False">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="total_general" HeaderText="Total" HtmlEncode="False" DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                </asp:BoundField>
                            </Columns>
                            <FooterStyle Font-Bold="True" />
                        </asp:GridView>
                        <br />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>--%>
            
                <ajaxToolkit:TabPanel ID="Solicitudes" runat="server" HeaderText="Solicitudes">
                    <ContentTemplate>
                        <asp:Label ID="Label1" runat="server" CssClass="header" Text="Solicitudes Realizadas a traves de *GOB o www.tss.gov.do"></asp:Label>&nbsp;<br />
                        &nbsp;<br />
                        <uc1:ucSolicitudByRNC ID="ucSolByRNC" runat="server" />
                        <br />
                    </ContentTemplate>
                    <HeaderTemplate>
                        Solicitudes Realizadas
                    </HeaderTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="CRM" runat="server" HeaderText="Registros en Nuestro CRM">
                    <HeaderTemplate>
                        CRM - TSS
                    </HeaderTemplate>
                    <ContentTemplate>
                        <asp:Label ID="Label2" runat="server" CssClass="header" Text="Registros en Nuestro Sistema de CRM"></asp:Label>&nbsp;<br />
                        &nbsp;&nbsp;<br />
                        <asp:GridView ID="gvCRM" runat="server" AutoGenerateColumns="False" CellPadding="3">
                            <Columns>
                                <asp:TemplateField HeaderText="Categoria:">
                                    <ItemTemplate>
                                        <asp:Label ID="lblCategoria" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.tipo_registro_des") %>'></asp:Label>
                                        <br />
                                        <asp:Label ID="lblAsunto" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Asunto") %>'></asp:Label><br />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Contactos">
                                    <ItemTemplate>
                                        <asp:Label ID="Label5" runat="server" Text="Contacto:"></asp:Label>
                                        <asp:Label ID="lblContactoEmpleador" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.Contacto") %>'></asp:Label><br />
                                        <asp:Label ID="Label8" runat="server" Text="Representante TSS:"></asp:Label>
                                        <asp:Label ID="lblRepTSS" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.nombre") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="registro_des" HeaderText="Comentario">
                                    <ItemStyle Width="400px" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Fecha_Registro" HeaderText="Fecha" />
                            </Columns>
                        </asp:GridView>
                        <br />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="Certificaciones" runat="server" HeaderText="Certificaciones">
                    <HeaderTemplate>
                        Certificaciones
                    </HeaderTemplate>
                    <ContentTemplate>
                        <asp:Label ID="Label3" runat="server" CssClass="header" Text="Certificaciones Solicitadas y/o Emitidas"></asp:Label>&nbsp;<br />
                        <br />
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="3">
                            <Columns>
                                <asp:BoundField DataField="ID_CERTIFICACION" HeaderText="Nro." />
                                <asp:BoundField DataField="TIPO_CERTIFICACION_DES" HeaderText="Tipo de Certificaci&#243;n" />
                                <asp:BoundField DataField="FECHA_CREACION" HeaderText="Fecha" />
                                <asp:BoundField DataField="NOMBRE" HeaderText="Representante" />
                            </Columns>
                        </asp:GridView>
                        <br />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
            </ajaxToolkit:TabContainer>
       <%-- </%--ContentTemplate>--%>
   <%-- </asp:UpdatePanel>--%>
    <br />
    <table border="0" cellpadding="0" cellspacing="0" visible="false" runat="server">
        <tr>
            <td style="width: 849px">
                <asp:Label ID="lblAvisos" runat="server" CssClass="subHeader">Avisos Importantes</asp:Label><br />
                <br />
                Puede realizar sus pagos en cualesquiera de las sucursales de los bancos BHD, POPULAR,
                PROGRESO, RESERVAS Y SANTA CRUZ, en efectivo, cheque del mismo banco o cheque de
                otro banco a nombre de la Dirección General de Impuestos Internos.
            </td>
        </tr>
    </table>
    <br />
</asp:Content>
