Imports iTextSharp
Imports iTextSharp.text
Imports iTextSharp.text.pdf
Imports System.IO
Imports iTextSharp.text.html.simpleparser
Imports iTextSharp.tool.xml

Partial Class sys_consCertificacionPdf
    Inherits BasePage


    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load
        Dim sb As New StringBuilder()
        sb.Append("<html><body>")
        sb.Append("<table cellSpacing='0' cellPadding='0' width='100%' border='0'>'")
        sb.Append("<tr>")
        sb.Append("<td vAlign='top' align='center'>")
        sb.Append("<span id='lblEslogan' style='font-size:14pt;font-weight:bold;'>Año por La Transparencia Y el Fortalecimiento Institucional</span>")
        sb.Append("<br/><br/>")
        sb.Append("<strong>CERTIFICACION No. </strong>")
        sb.Append("<span>96550</span><br/>")
        sb.Append("<br/>")
        sb.Append("<font size='10pt'>A QUIEN PUEDA INTERESAR</font>")
        sb.Append("<br/>")
        sb.Append("<br />")
        sb.Append("<br/>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("<table cellSpacing='0' cellPadding='0' width='100%' border='0'>")
        sb.Append("<tr>")
        sb.Append("<td vAlign='top'>")
        sb.Append("<div align='justify'><span id='lblPrimerParafo' style='font-size:10pt;'>Por medio de la presente hacemos constar que en los registros de la Tesorería de la Seguridad Social, la empresa <b>TESORERÝA DE LA SEGURIDAD SOCIAL...</b> con RNC/Cédula <b>4-01-51707-8</b>, a la fecha no presenta balance con atrasos en los pagos de los aportes a la Seguridad Social.<br/><br/>La presente certificación no significa necesariamente que <b>TESORERÝA DE LA SEGURIDAD SOCIAL...</b> haya realizado sus pagos en los plazos que establece la Ley 87-01, ni constituye un juicio de valor sobre la veracidad de las declaraciones hechas por este empleador a la Tesorería de la Seguridad Social, ni le exime de cualquier verificación posterior.<br/><br/></span></div>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("<br/>")
        sb.Append("<table cellSpacing='0' cellPadding='0' width='100%' border='0'>")
        sb.Append("<tr>")
        sb.Append("<td>")
        sb.Append("<div align='justify'><span id='lblSegundoParrafo' style='font-size:10pt;'>Esta certificación tiene una vigencia de 30 días, a partir de la fecha y se expide <b><u>totalmente gratis sin costo alguno</u></b> a solicitud de la parte interesada.<br/><br/>Dado en la ciudad de Santo Domingo, Republica Dominicana, a los 7 días del mes de Noviembre del año 2012.</span></div>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("<br/>")
        sb.Append("<br/>")
        sb.Append("<br/>")
        sb.Append("<table cellSpacing='0' cellPadding='0' width='100%'>")
        sb.Append("<tr>")
        sb.Append("<td>")
        sb.Append("<table cellSpacing='0' cellPadding='0' width='300' align='left' border='0'>")
        sb.Append("<tr>")
        sb.Append("<td>")
        sb.Append("<hr style='width: 100%'/>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td align='center'><strong><span id='lblFirma'>Sahadia Cruz de Valenzuela</span></strong><BR/>")
        sb.Append("<span id='lblPuestoFirma'>Gerente Centro Asistencia al Empleador</span></td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("<br/>")
        sb.Append("<br/>")
        sb.Append("<table cellSpacing='0' cellPadding='0' width='100%' align='center' border='0'>")
        sb.Append("<tr>")
        sb.Append("<td>")
        sb.Append("<hr style='width: 100%'/>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("<tr>")
        sb.Append("<td align='center'><strong>NO HAY NADA ESCRITO DEBAJO DE ESTA LINEA</strong>")
        sb.Append("</td>")
        sb.Append("</tr>")
        sb.Append("</table>")
        sb.Append("</body></html>")





        Dim attachment As String = "inline;attachment; filename=test.pdf"
        Response.AddHeader("content-disposition", attachment)
        Response.ContentType = "application/pdf"
        Dim stringWriter As New StringWriter(sb)

        Using document As New Document(iTextSharp.text.PageSize.LETTER, 72, 72, 72, 72)

            Dim writer As PdfWriter = PdfWriter.GetInstance(document, Response.OutputStream)

            document.Open()

            Dim stringReader As New StringReader(stringWriter.ToString())

            XMLWorkerHelper.GetInstance().ParseXHtml(writer, document, stringReader)
        End Using
        Response.[End]()

    End Sub


End Class
