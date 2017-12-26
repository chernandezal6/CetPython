Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils


Partial Class Empleador_verMensajeEmpleador
    Inherits BasePage

    Public id_mensaje As Integer

    Protected Sub Page_Load1(sender As Object, e As EventArgs) Handles Me.Load

        id_mensaje = Context.Request.QueryString("id")

        BindMensajeEmpleador(UsrRegistroPatronal, id_mensaje)
        Me.lblError.Visible = False
        Me.lblError.Text = String.Empty
    End Sub


    Protected Sub BindMensajeEmpleador(ByVal id_registro_patronal As Integer, ByVal id_mensaje As Integer)
        Dim dtMensaje As New DataTable
        Dim resultadoMsj As String
        Dim status As String

        Try
            dtMensaje = SuirPlus.Empresas.Empleador.getMensajeLeer(UsrRegistroPatronal, id_mensaje)

            If dtMensaje.Rows.Count > 0 Then
                'llenamos el grid y los labels'

                Me.pnlMensajes.Visible = True
                lblDestino.Text = dtMensaje.Rows(0)("razon_social").ToString()
                lblFechaMsj.Text = dtMensaje.Rows(0)("fecha_registro").ToString()
                lblEmisor.Text = "Tesoreria de la Seguridad Social"
                lblAsunto.Text = dtMensaje.Rows(0)("asunto").ToString()
                status = dtMensaje.Rows(0)("status").ToString()
                lblMensaje.Visible = True
                lblMensaje.Text = dtMensaje.Rows(0)("descripcion_mensaje").ToString()
                divArchivarMensaje.Visible = True


                If status = "A" Then
                    btnArchivar.Visible = False
                    btnArchivar.EnableViewState = False
                    divArchivarMensaje.Visible = False
                End If

                Try
                    resultadoMsj = SuirPlus.Empresas.Empleador.ActualizarMensajeEmpleador(UsrRegistroPatronal, id_mensaje, UsrUserName)

                Catch ex As Exception
                    Me.lblError.Visible = True
                    Me.lblError.Text = ex.Message
                End Try

            Else
                Me.lblError.Visible = True
                lblError.Text = "No hay data para mostrar"
            End If
            dtMensaje = Nothing



        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub


    Protected Sub LnkBtvolver_Click(sender As Object, e As EventArgs) Handles LnkBtvolver.Click
        Response.Redirect("empManejoMensajes.aspx")
    End Sub

    Protected Sub btnArchivar_Click(sender As Object, e As ImageClickEventArgs) Handles btnArchivar.Click
        Dim resultadoMsj As String

        Try
            resultadoMsj = SuirPlus.Empresas.Empleador.MarcarMensajeArchivado(UsrRegistroPatronal, id_mensaje, UsrUserName)
            Me.lblError.Visible = True
            Me.lblError.Text = "Mensaje Archivado"

        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try


    End Sub

    Protected Sub lnkBtArchivar_Click(sender As Object, e As EventArgs) Handles lnkBtArchivar.Click
        Dim resultadoMsj As String

        Try
            resultadoMsj = SuirPlus.Empresas.Empleador.MarcarMensajeArchivado(UsrRegistroPatronal, id_mensaje, UsrUserName)
            Me.lblError.Visible = True
            Me.lblError.Text = "Mensaje Archivado"


        Catch ex As Exception
            Me.lblError.Visible = True
            Me.lblError.Text = ex.Message
        End Try
    End Sub
End Class
