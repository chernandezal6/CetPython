
Partial Class Controles_UCTelefono
    Inherits System.Web.UI.UserControl

    Public Property AreaCode() As String
        Get
            Return Me.txtAreaCode.Text
        End Get
        Set(ByVal Value As String)
            Me.txtAreaCode.Text = Value
        End Set
    End Property

    Public Property Separador() As String
        Get
            Return Me.lblSeparador.Text
        End Get
        Set(ByVal Value As String)
            Me.lblSeparador.Text = Value
        End Set
    End Property

    Public Property NXX() As String
        Get
            Return Me.txtNXX.Text
        End Get
        Set(ByVal Value As String)
            Me.txtNXX.Text = Value
        End Set
    End Property

    Public Property Extension() As String
        Get
            Return Me.txtExtension.Text
        End Get
        Set(ByVal Value As String)
            Me.txtExtension.Text = Value
        End Set
    End Property

    Public Property PhoneNumber() As String
        Get
            Dim tmpPn, tmpAr, tmpNxx, tmpExt As String
            Try

                tmpAr = Trim(Me.txtAreaCode.Text)
                tmpNxx = Trim(Me.txtNXX.Text)
                tmpExt = Trim(Me.txtExtension.Text)

                If Not (tmpAr.Length = 3 And tmpNxx.Length = 3 And tmpExt.Length = 4) Then
                    Return ""
                End If

                'Validando que sean numerons enteros
                If IsNumeric(tmpNxx) And IsNumeric(tmpExt) Then

                    'Validando Codigo de Area
                    If Not IsNumeric(tmpAr) Then tmpAr = "809"


                    tmpPn = tmpAr + tmpNxx + tmpExt
                    tmpPn = tmpPn.PadLeft(10, " ")

                    Return tmpPn.Substring(0, 3) + Separador + tmpPn.Substring(3, 3) + Separador + tmpPn.Substring(6, 4)
                Else
                    Return ""
                End If

                Return ""

            Catch ex As Exception
                Return ex.ToString
            End Try

        End Get
        Set(ByVal Value As String)
            Dim tmpPn As String = Trim(Value)
            If tmpPn.Length > 0 Then

                tmpPn = tmpPn.Replace("-", "")
                tmpPn = tmpPn.PadLeft(10, " ")

                'Asignando valores
                Me.txtAreaCode.Text = IIf((Trim(tmpPn.Substring(0, 3) = "   ")), "809", Trim(tmpPn.Substring(0, 3)))
                Me.txtNXX.Text = Trim(tmpPn.Substring(3, 3))
                Me.txtExtension.Text = Trim(tmpPn.Substring(6, 4))

            Else

                'En caso de no enviar ningun numero 
                Me.txtAreaCode.Text = "809"
                Me.txtNXX.Text = ""
                Me.txtExtension.Text = ""

            End If

        End Set
    End Property

    Private Sub Page_PreRender(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.PreRender
        Me.txtAreaCode.Attributes("onkeyup") = Me.getPreFunction + "MoverAC();"
        Me.txtNXX.Attributes("onkeyup") = Me.getPreFunction + "MoverNXX();"
    End Sub

    Public Function getACName() As String
        Return Me.txtAreaCode.UniqueID
    End Function

    Public Function getNXXName() As String
        Return Me.txtNXX.UniqueID
    End Function

    Public Function getExtName() As String
        Return Me.txtExtension.UniqueID
    End Function

    Public Function getPreFunction() As String
        Return Me.UniqueID.Replace(":", "")
    End Function

End Class
