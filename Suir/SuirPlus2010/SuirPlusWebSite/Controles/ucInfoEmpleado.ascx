<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucInfoEmpleado.ascx.vb" Inherits="Controles_ucInfoEmpleado" %>
<script language="javascript" type="text/javascript">
<!--

function Table2_onclick() {

}

// -->
</script>


<TABLE class="td-content" id="Table2" cellSpacing="0" cellPadding="0" language="javascript" onclick="return Table2_onclick()" style="width:550px">
	<TR>
		<TD style="width: 100px; height: 12px;" align="right">
            <asp:Label ID="lblEmpleadolbl" runat="server"></asp:Label>
            :</TD>
		<TD style="width: 130px; height: 12px;" colspan="3" nowrap="nowrap"><asp:label cssclass="labelData" id="lblEmpleado" runat="server" Width="342%"></asp:label></TD>
	</TR>
    <tr>
        <td height="5px" style="width: 100px">
        </td>
        <td colspan="3" height="5px" nowrap="nowrap" style="width: 130px">
        </td>
    </tr>
    <tr>
        <td style="width: 100px; height: 12px" align="right">
            Fecha Nacimiento:</td>
        <td style="width: 137px; height: 12px">
            <asp:label cssclass="labelData" id="lblFechaNacimiento" runat="server"></asp:label></td>
        <td style="width: 36px; height: 12px" align="right">
            Cédula:</td>
        <td style="height: 12px">
            <asp:label cssclass="labelData" id="lblCedula" runat="server" /></td>
    </tr>
	<TR>
		<TD style="width: 100px" align="right">NSS:</TD>
		<TD style="width: 137px"><asp:label cssclass="labelData" id="lblNSS" runat="server" /></TD>
		<TD style="width: 36px" align="right">Sexo:</TD>
		<TD><asp:Label CssClass="labelData" ID="lblSexo" Runat="server" /></TD>
	</TR>
	
</TABLE>
