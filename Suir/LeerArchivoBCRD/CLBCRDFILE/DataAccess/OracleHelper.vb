Imports Oracle.DataAccess
Imports Oracle.DataAccess.Client
Imports Oracle.DataAccess.Types
Imports System.Text
Imports System.Data
Friend Class OracleHelper
    Private Shared Function getConnString() As String
        Dim connectionstring As String = Configuration.ConfigurationManager.AppSettings("oConnSuirPlus")
        Dim data() As Byte = Convert.FromBase64String(connectionstring)
        Return ASCIIEncoding.ASCII.GetString(data)
    End Function
    Public Shared Function IntProcedure(ByVal procedure As String, ByVal ParamArray parameters() As OracleParameter) As Int32
        Dim mycn As New OracleConnection(getConnString)
        Dim mycmd As OracleCommand = mycn.CreateCommand
        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = procedure

        For Each p As OracleParameter In parameters
            mycmd.Parameters.Add(p)
        Next

        Dim result As Int32 = 0
        Try
            mycn.Open()
            result = mycmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If mycn.State = ConnectionState.Open Then
                mycn.Close()
            End If
        End Try
        Return result
    End Function
    Public Shared Function IntProcedure(ByVal procedure As String) As Int32
        Dim mycn As New OracleConnection(getConnString)
        Dim mycmd As OracleCommand = mycn.CreateCommand
        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = procedure

        Dim result As Int32 = 0
        Try
            mycn.Open()
            result = mycmd.ExecuteNonQuery()
        Catch ex As Exception
            Throw ex
        Finally
            If mycn.State = ConnectionState.Open Then
                mycn.Close()
            End If
        End Try
        Return result
    End Function
    Public Shared Function ExecuteDatatable(ByVal procedure As String, ByVal ParamArray parameters() As OracleParameter) As DataTable
        Dim mycn As New OracleConnection(getConnString)
        Dim mycmd As OracleCommand = mycn.CreateCommand
        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = procedure

        For Each p As OracleParameter In parameters
            mycmd.Parameters.Add(p)
        Next

        Dim da As New OracleDataAdapter
        da.SelectCommand = mycmd

        Dim dt As New DataTable

        Try
            mycn.Open()
            da.Fill(dt)
            Return dt
        Catch ex As OracleException
            Throw ex
        Finally
            If mycn.State = ConnectionState.Open Then
                mycn.Close()
            End If
        End Try
    End Function
    Public Shared Function ExecuteDatatable(ByVal procedure As String) As DataTable
        Dim mycn As New OracleConnection(getConnString)
        Dim mycmd As OracleCommand = mycn.CreateCommand
        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = procedure

        Dim da As New OracleDataAdapter
        da.SelectCommand = mycmd

        Dim dt As New DataTable

        Try
            mycn.Open()
            da.Fill(dt)
            Return dt
        Catch ex As Exception
            Throw ex
        Finally
            If mycn.State = ConnectionState.Open Then
                mycn.Close()
            End If
        End Try

    End Function
    Public Shared Function ExecuteDataReader(ByVal procedure As String) As OracleDataReader
        Dim mycn As New OracleConnection(getConnString)
        Dim mycmd As OracleCommand = mycn.CreateCommand
        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = procedure

        Try
            mycn.Open()
            Dim odr As OracleDataReader = mycmd.ExecuteReader()
            Return odr
        Catch ex As Exception
            Throw ex
        Finally
            If mycn.State = ConnectionState.Open Then
                mycn.Close()
            End If
        End Try
    End Function
    Public Shared Function ExecuteDataReader(ByVal procedure As String, ByVal ParamArray parameters() As OracleParameter) As OracleDataReader
        Dim mycn As New OracleConnection(getConnString)
        Dim mycmd As OracleCommand = mycn.CreateCommand
        mycmd.CommandType = CommandType.StoredProcedure
        mycmd.CommandText = procedure

        For Each p As OracleParameter In parameters
            mycmd.Parameters.Add(p)
        Next

        Try
            mycn.Open()
            Dim odr As OracleDataReader = mycmd.ExecuteReader()
            Return odr
        Catch ex As Exception
            Throw ex
        Finally
            If mycn.State = ConnectionState.Open Then
                mycn.Close()
            End If
        End Try
    End Function
End Class
