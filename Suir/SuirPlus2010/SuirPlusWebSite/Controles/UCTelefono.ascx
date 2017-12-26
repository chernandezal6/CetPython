<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCTelefono.ascx.vb" Inherits="Controles_UCTelefono" %>

<script language="javascript" type="text/javascript">

function <%=getPreFunction()%>MoverAC()
{
	if (document.Form1("<%=getACName()%>").value.length == 3)document.Form1("<%=getNXXName()%>").focus()
}

function <%=getPreFunction()%>MoverNXX()
{
	if (document.Form1("<%=getNXXName()%>").value.length == 3)document.Form1("<%=getExtName()%>").focus()
}
    
function Validate(e) {

    var carCode = (window.event) ? window.event.keyCode : e.which;

            if ((carCode < 48) || (carCode > 57)) {

                if (window.event) //IE       
                    window.event.returnValue = null;
                else //Firefox       
                    e.preventDefault();

            }

}
     
</script>




<asp:TextBox id="txtAreaCode" Width="30px" runat="server" MaxLength="3" onKeyPress="Validate(event)">809</asp:TextBox>
&nbsp;-
<asp:TextBox id="txtNXX" Width="30px" runat="server" MaxLength="3" onKeyPress="Validate(event)"></asp:TextBox>&nbsp;-
<asp:TextBox id="txtExtension" Width="38px" runat="server" MaxLength="4" onKeyPress="Validate(event)"></asp:TextBox>
<asp:Label id="lblSeparador" runat="server" Visible="False">-</asp:Label>

