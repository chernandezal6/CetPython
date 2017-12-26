<%@ Page Language="VB"  MasterPageFile="~/SuirPlus.master"  AutoEventWireup="false" CodeFile="verMensajeEmpleador.aspx.vb" Inherits="Empleador_verMensajeEmpleador" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<%--<head runat="server">--%>
    <%--<title></title>
</head>
<body>--%>
  <%--  <form id="form1" runat="server">--%>
    <div>
    
           <br \>
           <br \>
           <br \>
           <br \>

                     <asp:Panel ID="pnlMensajes" Width="800px" runat="server" Visible="false">       
                        <table class="tblWithImagen" Style="width:100%;" cellspacing="5px">
                               <tr>
                        <td class="HeaderPopup" colspan="5">
                            &nbsp;Mensaje
                        </td>                  
                    </tr>
                             <tr>
                                <td class="sel" style="width: 45px; height: 27px;">De:
                                    </td>
                                <td style="height: 27px" >
                                    <asp:Label ID="lblEmisor" runat="server" CssClass="lbl" Style="font-size: 15px"></asp:Label>
                                </td>
                                 <td style="height: 27px">
                                     <asp:ImageButton ID="btnArchivar" Enabled="true" runat="server" Width="25px" Height="20px" ToolTip="Archivar" ImageUrl="../images/folders1.png"
                                         CommandName="Archivar" ImageAlign="right" CommandArgument='<%# Eval("id_mensaje")&"|"& Eval("id_registro_patronal")%>'></asp:ImageButton>

                                     <div runat="server" id="divArchivarMensaje" align="right" visible="false">
                                         <asp:LinkButton ID="lnkBtArchivar" runat="server" Font-Size="Small" Text="Archivar " Visible="true"> </asp:LinkButton>

                                     </div>
                                     </td>

                            </tr>
                             <tr>
                                <td class="sel" style="width: 45px">Para:
                                    </td>
                                <td >
                                    <asp:Label ID="lblDestino" runat="server" CssClass="lbl" Style="font-size: 15px" ></asp:Label>
                                </td>
                            </tr>
                              <tr>
                                <td class="sel" style="width: 45px">Fecha:
                                    </td>
                                <td >
                                    <asp:Label ID="lblFechaMsj" runat="server" CssClass="lbl" Style="font-size: 15px"></asp:Label>
                                </td>
                            </tr>
                              <tr>
                                <td class="sel" style="width: 45px" >Asunto:
                                    </td>
                                <td >
                                    <asp:Label ID="lblAsunto" runat="server" CssClass="lbl" Style="font-size: 15px" ></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td class="sel" style="width: 45px">Mensaje:
                                    </td>
                                
                                       <td>
                                   </td>

                                <td>
                                    </td>
                                </tr>
       
                          <tr>
                                
                                <td class="sel" style="width: 45px; height: 25px;" colspan="10">
                                     <asp:Label ID="lblMensaje"  runat="server" CssClass="lbl" Style="font-size: 15px" ></asp:Label>
                                
                                    </td>
                                </tr>
                                   <asp:Label ID="lblError" runat="server" CssClass="error" visible="False"
          
                    Font-Size="10pt"></asp:Label>
                              
                               
                        </table>
                         
                                       <asp:LinkButton ID="LnkBtvolver" runat="server" Font-Size="Small" Text="<< Volver atras "
                                    Visible="true"> </asp:LinkButton>&nbsp;
                   </asp:Panel>


    </div>
  <%--  </form>--%>
<%--</body>--%>
</asp:Content>
