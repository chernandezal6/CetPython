
Partial Class Controles_UC_DatePicker
    Inherits System.Web.UI.UserControl


#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub


    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()


    End Sub

#End Region

    Public Property Day() As Integer
        Get
            Return drpDay.SelectedValue
        End Get
        Set(ByVal Value As Integer)
            Me.drpDay.SelectedValue = Value
        End Set
    End Property
    Public Property Month() As Integer
        Get
            Return Me.drpMonth.SelectedValue
        End Get
        Set(ByVal Value As Integer)
            Me.drpMonth.SelectedValue = Value
        End Set
    End Property
    Public Property Year() As Integer
        Get
            Return drpYear.SelectedValue
        End Get
        Set(ByVal Value As Integer)
            Me.drpYear.SelectedValue = Value
        End Set
    End Property
    Public Property dateValue() As Date
        Get

            Try
                Return New Date(Integer.Parse(drpYear.SelectedValue), Integer.Parse(drpMonth.SelectedValue), Integer.Parse(drpDay.SelectedValue))
            Catch ex As Exception
                Throw New Exception("Fecha invalida.")
            End Try

        End Get
        Set(ByVal Value As Date)
            viewstate("date") = Value
        End Set
    End Property

    Public ReadOnly Property stringDate() As String
        Get
            Return dateValue.Day.ToString.PadLeft(2, "0") & "/" & dateValue.Month.ToString.PadLeft(2, "0") & "/" & dateValue.Year.ToString.PadLeft(4, "0")
        End Get
    End Property

    Public WriteOnly Property EnableControls() As Boolean
        Set(ByVal Value As Boolean)
            viewstate("enabled") = Value
        End Set
    End Property

    'Cuando el control esta en modo de seleccion es posible que algun o todos los controles 
    'contengan opciones no validas para construir la fecha.  Esto es lo que determina si el control
    'esta valido o no.
    Public ReadOnly Property isValid() As Boolean
        Get
            Return (Me.drpDay.SelectedIndex <> 0 And Me.drpMonth.SelectedIndex <> 0 And Me.drpYear.SelectedIndex <> 0)
        End Get
    End Property

    'Coloca los drop downs del control en modo de seleccion
    Public Sub setSeleccionar()

        Me.drpDay.SelectedIndex = 0
        Me.drpMonth.SelectedIndex = 0
        Me.drpYear.SelectedIndex = 0

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Page.IsPostBack Then
            bindCombos()
        End If
    End Sub

    Private Sub bindCombos()
        Dim item As ListItem
        'Dias
        For i As Integer = 1 To 31
            item = New ListItem(i, i)
            Me.drpDay.Items.Add(item)
        Next

        'Agregando opcion de seleccion en DIA
        Me.drpDay.Items.Insert(0, "- Dia -")

        'Meses
        item = New ListItem("Enero", 1)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Febrero", 2)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Marzo", 3)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Abril", 4)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Mayo", 5)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Junio", 6)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Julio", 7)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Agosto", 8)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Septiembre", 9)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Octubre", 10)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Noviembre", 11)
        Me.drpMonth.Items.Add(item)

        item = New ListItem("Diciembre", 12)
        Me.drpMonth.Items.Add(item)

        'Agregando opcion de seleccion en MES
        Me.drpMonth.Items.Insert(0, "- Mes -")

        'años
        For x As Integer = Date.Now.Year - 109 To Date.Now.Year + 2
            item = New ListItem(x, x)
            drpYear.Items.Add(item)
        Next

        'Agregando opcion de seleccion en Año
        Me.drpYear.Items.Insert(0, "- Año -")

    End Sub


    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.PreRender

        If Not viewstate("date") Is Nothing Then
            Dim nDAte As Date = viewstate("date")
            Try
                Me.drpDay.SelectedValue = nDAte.Day
                Me.drpMonth.SelectedValue = nDAte.Month
                Me.drpYear.SelectedValue = nDAte.Year
            Catch ex As Exception
                nDAte = Date.Now
                Me.drpDay.SelectedValue = nDAte.Day
                Me.drpMonth.SelectedValue = nDAte.Month
                Me.drpYear.SelectedValue = nDAte.Year
            End Try

            viewstate.Remove("date")

        ElseIf Not Page.IsPostBack And viewstate("date") Is Nothing Then
            Me.drpDay.SelectedValue = Date.Now.Day
            Me.drpMonth.SelectedValue = Date.Now.Month
            Me.drpYear.SelectedValue = Date.Now.Year

        End If

        If Not viewstate("enabled") Is Nothing Then
            Dim enabled As Boolean = viewstate("enabled")
            Me.drpDay.Enabled = enabled
            Me.drpMonth.Enabled = enabled
            Me.drpYear.Enabled = enabled
        End If

    End Sub
End Class
