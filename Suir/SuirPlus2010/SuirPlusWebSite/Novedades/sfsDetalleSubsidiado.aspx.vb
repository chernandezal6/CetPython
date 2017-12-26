Imports System.Data
Imports SuirPlus.Empresas.SubsidiosSFS
Partial Class sfsDetalleSubsidiado
    Inherits BasePage

    Dim NroSolicitud As String
    Dim Cedula As String
    Dim Nombre As String
    Dim FechaRegistro As String
    Dim FechaRespuesta As String
    Dim Pin As String
    Dim Status As String

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        lblMsg.Text = String.Empty

        NroSolicitud = Request.QueryString.Item("Nro")
        Cedula = Request.QueryString.Item("Ced")
        Nombre = Request.QueryString.Item("Nom")
        FechaRegistro = Request.QueryString.Item("Fre")
        FechaRespuesta = Request.QueryString.Item("Frp")
        Pin = Request.QueryString.Item("Pin")
        Status = Request.QueryString.Item("Sta")

        If Not String.IsNullOrEmpty(NroSolicitud) Then
            lblNroSolicitud.Text = NroSolicitud
            lblCedula.Text = Cedula
            lblNombre.Text = Nombre
            lblFechaRegistro.Text = FechaRegistro
            lblFechaRespuesta.Text = FechaRespuesta
            lblPin.Text = Pin
            lblStatus.Text = Status

            LoadData()
        End If


    End Sub

    Private Sub LoadData()
        Try
            If Status.Equals("Registro rechazado por la SISALRIL") Or Status.Equals("Incompleto") Or Status.Equals("Cancelado") Then
                gvDetalle.DataSource = Nothing
                gvDetalle.DataBind()
            Else
                Dim dt As DataTable

                dt = EnfermedadComun.GetDetalleSubsidiadoEmpresa(NroSolicitud, Me.UsrRegistroPatronal)
                gvDetalle.DataSource = dt
                gvDetalle.DataBind()
            End If

        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try
    End Sub

    
End Class

