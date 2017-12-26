Imports SuirPlus
Partial Class Seguridad_segSecciones
    Inherits BasePage

    Private Estatus As Modo

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Not Page.IsPostBack Then
            Me.CargaInicial()
        Else
            Me.Estatus = viewstate().Item("Modo")
        End If

    End Sub

    Private Sub CargaInicial()
        Me.llenarDataGridSecciones()
    End Sub

    Private Sub llenarDataGridSecciones()

        Me.dgSecciones.DataSource = Seguridad.Seccion.getSecciones(-1)
        Me.dgSecciones.DataBind()

    End Sub

    Private Sub limpiarCampos()
        Me.txtDescripcion.Text = ""
    End Sub

    Private Sub MostrarArriba()

        Me.pnlDetalle.Visible = False
        Me.pnlListado.Visible = True

        Me.llenarDataGridSecciones()

    End Sub
    Private Sub MostrarAbajo()

        Me.pnlDetalle.Visible = True
        Me.pnlListado.Visible = False

        Me.txtDescripcion.Text = ""

    End Sub

    Private Sub btnNuevaSeccion_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNuevaSeccion.Click

        Me.Estatus = Modo.Nuevo
        Me.lblCrearModificar.Text = "Crear Sección"

        viewstate().Add("Modo", Me.Estatus)
        Me.MostrarAbajo()

    End Sub

    Private Sub btnCancelar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar.Click

        Me.MostrarArriba()

    End Sub

    Private Sub btnAceptar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAceptar.Click

        Dim Resultado As String = String.Empty
        If Me.Estatus = Modo.Nuevo Then

            Resultado = Seguridad.Seccion.nuevaSeccion(Me.txtDescripcion.Text, Me.UsrUserName)
            If Resultado = "0" Then
                Me.MostrarArriba()
            Else
                Me.lblMensajeDeError.Text = Utilitarios.Utils.sacarMensajeDeError(Resultado)
                Me.lblMensajeDeError.Visible = True
            End If

        ElseIf Me.Estatus = Modo.Edicion Then

            Resultado = Me.EditarSeccion(viewstate().Item("IDSeccion"))

        End If

        If Resultado = "0" Then
            Me.MostrarArriba()
        Else
            Me.lblMensajeDeError.Text = Utilitarios.Utils.sacarMensajeDeError(Resultado)
            Me.lblMensajeDeError.Visible = True
        End If

    End Sub

    Private Sub prepararEditarSeccion()
        Me.Estatus = Modo.Edicion
        Me.lblCrearModificar.Text = "Modificar Sección"

        ViewState().Add("Modo", Me.Estatus)

        Me.MostrarAbajo()

        Dim Seccion As New Seguridad.Seccion(ViewState().Item("IDSeccion"))

        Me.txtDescripcion.Text = Seccion.Descripcion

    End Sub

    Private Function EditarSeccion(ByVal IDSeccion As Int32) As String

        Dim Sec As New Seguridad.Seccion(IDSeccion)

        Sec.Descripcion = Me.txtDescripcion.Text

        Return Sec.GuardarCambios(Me.UsrUserName)

    End Function

    Private Sub BorrarSeccion(ByVal IDSeccion As Int32)

        Seguridad.Seccion.borrarSeccion(IDSeccion)
        Me.MostrarArriba()

    End Sub

    Protected Sub dgSecciones_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)
        Dim IDSeccion As Int32 = CType(e.CommandArgument, Int32)

        ViewState().Add("IDSeccion", IDSeccion)

        Select Case e.CommandName
            Case "Editar"
                Me.prepararEditarSeccion()
            Case "Borrar"
                Me.BorrarSeccion(IDSeccion)
        End Select

    End Sub
End Class
