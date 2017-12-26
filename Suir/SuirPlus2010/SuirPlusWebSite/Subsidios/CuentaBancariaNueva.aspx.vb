Imports SuirPlus
Imports System.Data
Imports SuirPlus.Bancos.EntidadRecaudadora
Partial Class Subsidios_CuentaBancariaNueva
    Inherits BasePage

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Try

                Dim entidadesRecaudadoras As New DataTable
                entidadesRecaudadoras = getEntidadesParaSFS()
                ddlEntidadRecaudadora2.DataSource = entidadesRecaudadoras
                ddlEntidadRecaudadora2.DataTextField = "ENTIDAD_RECAUDADORA_DES"
                ddlEntidadRecaudadora2.DataValueField = "ID_ENTIDAD_RECAUDADORA"
                ddlEntidadRecaudadora2.DataBind()
                ddlEntidadRecaudadora2.Items.Insert(0, New ListItem("Seleccione", "0"))
            Catch ex As Exception
                Exepciones.Log.LogToDB(ex.ToString())
            End Try
        End If

    End Sub
End Class
