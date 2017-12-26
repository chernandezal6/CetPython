Imports System.Data
Imports SuirPlusEF.Repositories


Partial Class Controles_ucCaptcha
    Inherits System.Web.UI.UserControl

    Protected dt As DataTable
    Dim captchaData As New CaptchaRepository
    Private myIdRespuesta As Integer
    Private ruta As String
    Private State As Boolean


    Public WriteOnly Property IdRespuesta() As Integer
        Set(ByVal Value As Integer)
            myIdRespuesta = Value
        End Set
    End Property
    Public WriteOnly Property capturarRuta() As String
        Set(ByVal Value As String)
            ruta = Value
        End Set
    End Property
    Dim v_Respuesta1 As DateTime
    Public Property Respuesta1() As DateTime
        Get
            If hdRespuesta1.Value <> Nothing Then
                v_Respuesta1 = Convert.ToDateTime(hdRespuesta1.Value)
            End If

            Return v_Respuesta1
        End Get
        Set(ByVal value As DateTime)
            hdRespuesta1.Value = value
        End Set
    End Property
    Public Property Respuesta2() As String
        Get
            Return hdRespuesta2.Value
        End Get
        Set(ByVal value As String)
            hdRespuesta2.Value = value
        End Set
    End Property
    Dim v_Campo1 As DateTime
    Public Property Campo1() As DateTime
        Get
            v_Campo1 = Convert.ToDateTime(hdCampo1.Value)
            Return v_Campo1
        End Get
        Set(ByVal value As DateTime)
            hdCampo1.Value = value
        End Set
    End Property
    Public Property Campo2() As String
        Get
            Return hdCampo2.Value
        End Get
        Set(ByVal value As String)
            hdCampo2.Value = value
        End Set
    End Property
    Public Property IsValid() As Boolean
        Get
            Return Hdstate.Value
        End Get
        Set(ByVal value As Boolean)
            Hdstate.Value = value
        End Set
    End Property
    Private Sub cargaInicial()
        Session("respuesta") = myIdRespuesta
    End Sub
    Public Overrides Sub DataBind()

        If Not Page.IsPostBack Then
            myIdRespuesta = Session("respuesta")
        Else
            Me.cargaInicial()
        End If

        bindGrid(ruta)
    End Sub

    Public Event RespuestaCaptchaClicked As EventHandler
    Public Event SalirCaptchaClicked As EventHandler

    Private Sub RespuestaCaptchaClick()
        RaiseEvent RespuestaCaptchaClicked(Me, EventArgs.Empty)
    End Sub

    Private Sub SalirCaptchaClick()
        RaiseEvent SalirCaptchaClicked(Me, EventArgs.Empty)
    End Sub

    Protected Sub Button_Click(sender As Object, e As EventArgs)
        ValidacionStatus()
        RespuestaCaptchaClick()
    End Sub
    Protected Sub Button2_Click(sender As Object, e As EventArgs)
        SalirCaptchaClick()
    End Sub

    Protected Sub bindGrid(ByVal path As String)

        Dim info = captchaData.PreguntaCaptcha(path)
        Try
            Dim table1 = New HtmlTable()
            table1.Border = 1
            table1.CellPadding = 3
            table1.CellSpacing = 3


            Dim row = New HtmlTableRow
            Dim cell = New HtmlTableCell
            For Each item In info
                row = New HtmlTableRow
                cell = New HtmlTableCell()
                row.Align = HorizontalAlign.Center

                Dim Elemento = ""
                If item.ObjetoHTML = "D" Then
                    Elemento = "<input type='text' id=" + item.CampoRepuesta + " name='repval1' runat='server' style='width: 190px;'  class='date' />"
                Else
                    Elemento = "<input type='text' id=" + item.CampoRepuesta + " name='repval2' runat='server'  style='width: 190px; text-transform:uppercase;' placeholder='Escriba solo el apellido'/>"
                End If

                cell.InnerHtml = "<strong>" + item.Pregunta + "</strong></br> " + Elemento
                row.Cells.Add(cell)
                table1.Rows.Add(row)
            Next

            row = New HtmlTableRow
            cell = New HtmlTableCell()
            row.Align = "center"
            Dim btnValidar As New Button()
            btnValidar.Text = "Validar"
            btnValidar.CssClass = "Button"
            AddHandler btnValidar.Click, AddressOf Button_Click
            Dim btnsalir As New Button()
            btnsalir.Text = "Cancel"
            btnsalir.CssClass = "buttonLeft"
            AddHandler btnsalir.Click, AddressOf Button2_Click


            cell.Controls.Add(btnValidar)
            cell.Controls.Add(btnsalir)
            row.Cells.Add(cell)
            table1.Rows.Add(row)

            pnlcaptcha.Controls.Add(table1)


        Catch ex As Exception

        End Try


    End Sub

    Public Sub Visibilidad(state As Boolean)
        pnlcaptcha.Visible = state
    End Sub



    Public Sub ValidacionStatus()

        '        Respuesta1 = CDate(Respuesta1).ToString("d/M/yyyy")

        Dim Resultado As Boolean = False
        If Campo1 = Respuesta1 And Campo2 = Respuesta2.ToUpper() Then
            Resultado = True
        Else
            Resultado = False
        End If

        IsValid = Resultado



    End Sub

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            IsValid = False
        End If

    End Sub


End Class
