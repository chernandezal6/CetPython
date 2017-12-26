<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucCaptcha.ascx.vb" Inherits="Controles_ucCaptcha" %>
<%--    <script src="//ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js" type="text/javascript"></script>
    <script type="text/javascript"> window.jQuery || document.write('<script src="../Script/jquery-1.5.2.min.js">\x3C/script>')</script>--%>

 <script type="text/javascript">

     $(function () {
              
         $("input[name='ctl00$MainContent$ucCaptcha1$ctl07']").click(function () {
                        
             var var1 = $("input[name='repval1']").val();
             var var2 = $("input[name='repval2']").val();

             $("#ctl00_MainContent_ucCaptcha1_hdRespuesta1").val(var1);
             $("#ctl00_MainContent_ucCaptcha1_hdRespuesta2").val(var2);
             
         });
     });
     
 </script>


<asp:Panel ID="pnlcaptcha" runat="server">
    <asp:HiddenField ID="hdCampo1" runat="server" />
    <asp:HiddenField ID="hdCampo2" runat="server" />
    <asp:HiddenField ID="hdRespuesta1" runat="server"  />
    <asp:HiddenField ID="hdRespuesta2" runat="server"  />
    <asp:HiddenField ID="Hdstate" runat="server"  />


</asp:Panel>
