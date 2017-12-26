<%@ Control Language="VB" AutoEventWireup="false" CodeFile="CaptchaImage.ascx.vb" Inherits="Controles_CaptchaImage" %>
&nbsp;
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

	</script>

<table style="width: 450px; text-align: left;">
   <tr align="center">
       <td align="center" style="width: 450px;">
    <asp:Image SkinID="Captcha" ID="imgCaptcha" runat="server" /></td>

   </tr>
   <tr align="center">
       <td align="center" width="450px" >
       <asp:TextBox id="CodeNumberTextBox" runat="server" onKeyPress="checkNum()" MaxLength="4"></asp:TextBox>       			
       </td >       
   </tr>
   <tr align="center">
       <td align="center" style="width: 450px" width="225px" >
               <asp:Label id="MessageLabel" runat="server"></asp:Label>    
       </td >       
   </tr>
    </table>