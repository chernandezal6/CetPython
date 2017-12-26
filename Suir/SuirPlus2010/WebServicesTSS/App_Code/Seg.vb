Imports Microsoft.VisualBasic
Imports System.Data

Public Class Seg
    Public Shared Function CheckUserPass(ByVal UserName As String, ByVal Password As String, ByRef Mensaje As String, ByVal Servidor As String) As Boolean

        UserName = UserName.ToUpper()
        Password = Password.ToUpper()


        Try
            If SuirPlus.Seguridad.Autenticacion.Login(UserName, Password, "", 1, Servidor) Then
                Return True
            Else
                Mensaje = " | Devolvio Ok"
                Return False
            End If

        Catch ex As Exception

            Try
                If SuirPlus.Seguridad.Autenticacion.Login(UserName, Password, "", 1, Servidor) Then
                    Return True
                Else
                    Mensaje = " | Devolvio Ok"
                    Return False
                End If

            Catch ex2 As Exception

            End Try


            Mensaje = ex.ToString()
            Return False

        End Try

        Mensaje = " | Devolvio Fuera"
        Return False

    End Function

    Public Shared Function isInRole(ByVal UserName As String, ByVal role As String) As Boolean
        Try
            Return SuirPlus.Seguridad.Autorizacion.isInRol(UserName, role)
        Catch ex As Exception
            Return False
        End Try

    End Function

    Public Shared Function isInPermiso(ByVal UserName As String, ByVal permiso As String) As Boolean
        Try
            Return SuirPlus.Seguridad.Autorizacion.isInPermiso(UserName, permiso)
        Catch ex As Exception
            Return False
        End Try

    End Function

    Public Shared Function CheckUserPass(ByVal UserName As String, ByVal Password As String, ByVal Servidor As String) As Boolean

        Return CheckUserPass(UserName, Password, "", Servidor)

    End Function

    Public Shared Sub AgregarErrorTecnico(ByRef ds As DataSet, ByVal Mensaje As String)

        Try

            Dim dtError As New DataTable("DetalleTecnico")

            Dim myColumn As DataColumn
            Dim myRow As DataRow

            myColumn = New DataColumn("Detalle")
            dtError.Columns.Add(myColumn)

            If Len(Trim(Mensaje)) > 0 Then
                myRow = dtError.NewRow
                myRow("Detalle") = Mensaje
                dtError.Rows.Add(myRow)
            End If

            ds.Tables.Add(dtError)
        Catch ex As Exception

        End Try


    End Sub

    Public Shared Sub AgregarMensajeDeError(ByRef ds As DataSet, ByVal Mensaje As String)

        Try

            Dim dtError As New DataTable("Errores")

            Dim myColumn As DataColumn
            Dim myRow As DataRow

            myColumn = New DataColumn("Mensaje")
            dtError.Columns.Add(myColumn)

            If Len(Trim(Mensaje)) > 0 Then
                myRow = dtError.NewRow
                myRow("Mensaje") = Mensaje
                dtError.Rows.Add(myRow)
            End If

            ds.Tables.Add(dtError)
        Catch ex As Exception

        End Try

    End Sub

End Class

