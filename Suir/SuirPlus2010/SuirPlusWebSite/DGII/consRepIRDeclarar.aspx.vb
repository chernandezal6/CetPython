Imports SuirPlus.Utilitarios

Partial Class DGII_consRepIRDeclarar
    Inherits BasePage


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            Me.lblTitulo.Text += " " & Utils.getPeriodoIR13.ToString()
        End If

    End Sub

    Private Sub btDeclarar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btDeclarar.Click

        Dim ir As New SuirPlus.Empresas.Facturacion.ResumenDeclaracionIR13(Utils.getPeriodoIR13, Me.UsrRNC)
        ir.MarcarProcesado()
        Response.Redirect("consRepIR.aspx")

    End Sub

    Private Sub Button1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Button1.Click

        Response.Redirect("consRepIR.aspx")

    End Sub

End Class
