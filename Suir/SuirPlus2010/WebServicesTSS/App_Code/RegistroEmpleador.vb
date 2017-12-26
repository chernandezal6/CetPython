Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports SuirPlus

' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
'<System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://www.tss2.gov.do/wsTSS/TSS")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class RegistroEmpleador
    Inherits System.Web.Services.WebService
    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property

    Private myEmp As Empresas.Empleador

    <WebMethod(Description:="Metodo para realizar el registro inicial de un empleador en la TSS. <br><br>" & _
    "Esta función devuelve un String con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>30</b>|Usuario no autorizado <br>" & _
    "c) <b>34</b>|El rnc es requerido para realizar el registro inicial del empleador en TSS. <br>" & _
    "d) <b>35</b>|La razón social es requerida para realizar el registro inicial del empleador en TSS. <br>" & _
    "e) <b>36</b>|El nombre comercial es requerido para realizar el registro inicial del empleador en TSS. <br>" & _
    "f) <b>37</b>|El tipo de empresa(PR=Privada) es requerido. <br>" & _
    "g) <b>38</b>|Si el establecimiento es una zona franca(S=Si, N=No). <br>" & _
    "h) <b>39</b>|Solo si es zona franca(el tipo es requerido y debe ser 1=Comercial, 2=Normal). <br>" & _
    "i) <b>40</b>|Solo si es zona franca, el Id correspondiente es requerido. <br>" & _
    "j) <b>41</b>|Representante inválido. <br>" & _
    "k) <b>42</b>|Email Representante inválido. <br>" & _
    "l) <b>43</b>|El representante debe especificar si prefiere notificaciones por email(S/N). <br>" & _
    "m) <b>44</b>|Error creando el representante. <br>" & _
    "n) <b>45</b>|Este empleador ya existe. <br>" & _
    "o) <b>46</b>|Error creando el empleador. <br>" & _
    "p) <b>47</b>|Id sector económico inválido. <br>" & _
    "q) <b>48</b>|Id sector salarial inválido. <br>" & _
    "r) <b>49</b>|Id zona franca inválido. <br>" & _
    "s) <b>50</b>|Id municipio inválido. <br>" & _
    "t) <b>51</b>|El teléfono1 es inválido. <br>" & _
    "u) <b>52</b>|La ext1 es inválida. <br>" & _
    "v) <b>53</b>|El teléfono2 es inválido. <br>" & _
    "w) <b>54</b>|La ext2 es inválida. <br>" & _
    "x) <b>55</b>|El fax es inválido. <br>" & _
    "y) <b>56</b>|El email es inválido. <br>" & _
    "z) <b>57</b>|El teléfono1 del representante es inválido. <br>" & _
    "aa) <b>58</b>|La ext1 del representante es inválida. <br>" & _
    "bb) <b>59</b>|El teléfono2 del representante es inválido. <br>" & _
    "cc)<b>60</b>|La ext2 del representante es inválida. <br>" & _
    "")> _
    Public Function RegistroEmpleadorTSS(ByVal UserName As String, ByVal Password As String, ByVal Tipo_Empresa As String, ByVal Rnc_Cedula As String, ByVal Razon_Social As String, ByVal Nombre_Comercial As String, ByVal Id_Municipio As String,
                                        ByVal Calle As String, ByVal Numero As String, ByVal Edificio As String, ByVal Piso As String, ByVal Apartamento As String, ByVal Sector As String,
                                        ByVal Telefono1 As String, ByVal Ext1 As String, ByVal Telefono2 As String, ByVal Ext2 As String, ByVal Fax As String, ByVal Email As String,
                                        ByVal Sector_Salarial As String, ByVal Sector_Economico As String, ByVal Es_Zona_Franca As String,
                                        ByVal Id_Zona_Franca As String, ByVal Tipo_Zona_Franca As String, ByVal Documento_Representante As String, ByVal Notificacion_Email As String, ByVal Tel1_Representante As String, ByVal Ext1_Representante As String,
                                        ByVal Tel2_Representante As String, ByVal Ext2_Representante As String, ByVal Email_Representante As String) As String

        Try


            UserName = UserName.Trim
            Password = Password.Trim
            Tipo_Empresa = Tipo_Empresa.Trim
            Rnc_Cedula = Rnc_Cedula.Trim
            Razon_Social = Razon_Social.Trim
            Nombre_Comercial = Nombre_Comercial.Trim
            Id_Municipio = Id_Municipio.Trim
            Calle = Calle.Trim
            Numero = Numero.Trim
            Edificio = Edificio.Trim
            Piso = Piso.Trim
            Apartamento = Apartamento.Trim
            Sector = Sector.Trim
            Telefono1 = Telefono1.Trim
            Ext1 = Ext1.Trim
            Telefono2 = Telefono2.Trim
            Ext2 = Ext2.Trim
            Fax = Fax.Trim
            Email = Email.Trim
            Sector_Salarial = Sector_Salarial.Trim
            Sector_Economico = Sector_Economico.Trim
            Es_Zona_Franca = Es_Zona_Franca.Trim
            Id_Zona_Franca = Id_Zona_Franca.Trim
            Tipo_Zona_Franca = Tipo_Zona_Franca.Trim
            Documento_Representante = Documento_Representante.Trim
            Notificacion_Email = Notificacion_Email.Trim
            Tel1_Representante = Tel1_Representante.Trim
            Ext1_Representante = Ext1_Representante.Trim
            Tel2_Representante = Tel2_Representante.Trim
            Ext2_Representante = Ext2_Representante.Trim
            Email_Representante = Email_Representante.Trim




            'Set de validaciones necesarias para realizar un correcto registro inicial del empleador en TSS
            If Seg.CheckUserPass(UserName, Password, IP) = False Then
                Return Err.UsuarioPass
            Else
                If Not Seg.isInRole(UserName, "620") Then
                    Return Err.UsuarionAutorizado
                End If
            End If

            If (Tipo_Empresa <> "PR") Then 'And (Tipo_Empresa <> "PU") And (Tipo_Empresa <> "PC") Then
                Return Err.TipoEmpresaInvalido
            End If
            If (Rnc_Cedula = String.Empty) Or (Rnc_Cedula.Length <> 9 And Rnc_Cedula.Length <> 11) Then
                Return Err.RNCInvalido
            End If
            If Razon_Social = String.Empty Then
                Return Err.RazonSocialInvalida
            End If
            If Nombre_Comercial = String.Empty Then
                Return Err.NombreComercialErr
            End If
            If SuirPlus.Utilitarios.TSS.IsMunicipio(Id_Municipio) = "0" Then
                Return Err.MunicipioErr
            End If
            'contactos empleador
            If Not IsNumeric(Telefono1) Or Telefono1.Length <> 10 Then
                Return Err.Telefono1Err
            End If
            If Ext1 <> String.Empty Then
                If Not IsNumeric(Ext1) Or Ext1.Length > 4 Then
                    Return Err.Ext1Err
                End If
            End If
            If Telefono2 <> String.Empty Then
                If Not IsNumeric(Telefono2) Or Telefono2.Length <> 10 Then
                    Return Err.Telefono2Err
                End If
            End If
            If Ext2 <> String.Empty Then
                If Not IsNumeric(Ext2) Or Ext2.Length > 4 Then
                    Return Err.Ext2Err
                End If
            End If
            If Fax <> String.Empty Then
                If Not IsNumeric(Fax) Or Fax.Length <> 10 Then
                    Return Err.FaxErr
                End If
            End If

            If Email <> String.Empty Then
                Dim res = Regex.IsMatch(Email, "^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$")
                If Not res Then
                    Return Err.EmailErr
                End If
            End If

            If Sector_Salarial.Length > 9 Then
                Return Err.SectorSalarialErr
            End If

            Dim sectorSalarial As Integer?
            If Len(Sector_Salarial) > 0 Then
                If IsNumeric(Sector_Salarial) Then
                    sectorSalarial = CInt(Sector_Salarial)
                    If SuirPlus.Utilitarios.TSS.IsSectorSalarial(Sector_Salarial) = "0" Then
                        Return Err.SectorSalarialErr
                    End If
                Else
                    Return Err.SectorSalarialErr
                End If
            End If

            If Sector_Economico.Length > 9 Then
                Return Err.SectorEconomicoErr
            End If

            Dim sectorEconomico As Integer = 17
            If Sector_Economico <> String.Empty Then
                If IsNumeric(Sector_Economico) Then
                    sectorEconomico = CInt(Sector_Economico)
                    If SuirPlus.Utilitarios.TSS.IsSectorEconomico(Sector_Economico) = "0" Then
                        Return Err.SectorEconomicoErr
                    End If
                Else
                    Return Err.SectorEconomicoErr
                End If
            End If

            If Es_Zona_Franca <> String.Empty Then
                If (Es_Zona_Franca <> "S") And (Es_Zona_Franca <> "N") Then
                    Return Err.EsZonaFrancaErr
                End If
                If Es_Zona_Franca = "S" Then
                    If Id_Zona_Franca <> String.Empty Then
                        If SuirPlus.Utilitarios.TSS.IsZonaFranca(Id_Zona_Franca) = "0" Then
                            Return Err.ZonaFrancaErr
                        End If
                    Else
                        Return Err.IdZonaFrancaErr
                    End If
                    If Tipo_Zona_Franca <> String.Empty Then
                        If (Tipo_Zona_Franca <> "1") And (Tipo_Zona_Franca <> "2") Then
                            Return Err.TipoZonaFrancaErr
                        End If
                    Else
                        Return Err.TipoZonaFrancaErr
                    End If
                Else
                    If Id_Zona_Franca <> String.Empty Then
                        Return Err.IdZonaFrancaErr
                    End If
                    If Tipo_Zona_Franca <> String.Empty Then
                        Return Err.TipoZonaFrancaErr
                    End If
                End If
            Else
                If Tipo_Zona_Franca <> String.Empty Then
                    Return Err.TipoZonaFrancaErr
                End If
                If Id_Zona_Franca <> String.Empty Then
                    Return Err.IdZonaFrancaErr
                End If
            End If

            'representante
            Dim nss_Representante As String = String.Empty
            Dim tipoDoc_representante As String = String.Empty
            Dim resultado As String = String.Empty
            If Documento_Representante <> String.Empty Then
                If Documento_Representante.Length = 11 Then
                    tipoDoc_representante = "C"
                Else
                    tipoDoc_representante = "P"
                End If
            Else
                Return Err.RepresentanteInvalido
            End If

            resultado = Utilitarios.TSS.consultaCiudadano(tipoDoc_representante, Documento_Representante)
            If resultado.Split("|")(0) = "0" Then
                nss_Representante = resultado.Split("|")(3)
            Else
                Return Err.RepresentanteInvalido
            End If

            If (Notificacion_Email <> "N") And (Notificacion_Email <> "S") Then
                Return Err.NotificacionesxEmail_Rep
            End If

            'contactos representante
            If Not IsNumeric(Tel1_Representante) Or Tel1_Representante.Length <> 10 Then
                Return Err.Tel1RepErr
            End If

            If Ext1_Representante <> String.Empty Then
                If Not IsNumeric(Ext1_Representante) Or Ext1_Representante.Length > 4 Then
                    Return Err.Ext1RepErr
                End If
            End If
            If Tel2_Representante <> String.Empty Then
                If Not IsNumeric(Tel2_Representante) Or Tel2_Representante.Length <> 10 Then
                    Return Err.Tel2RepErr
                End If
            End If
            If Ext2_Representante <> String.Empty Then
                If Not IsNumeric(Ext2_Representante) Or Ext2_Representante.Length > 4 Then
                    Return Err.Ext2RepErr
                End If
            End If

            If Email_Representante = String.Empty Then
                Return Err.Email_RepresentanteErr
            Else
                Dim res = Regex.IsMatch(Email_Representante, "^([\w-]+\.)*?[\w-]+@[\w-]+\.([\w-]+\.)*?[\w]+$")
                If Not res Then
                    Return Err.Email_RepresentanteErr
                End If
            End If

            'Insertando empleador
            Dim strRet As String = SuirPlus.Empresas.Empleador.insertaEmpleador(sectorEconomico, _
                                                                                Id_Municipio, _
                                                                                Rnc_Cedula.Trim, _
                                                                                Razon_Social.Trim, _
                                                                                Nombre_Comercial.Trim, _
                                                                                Calle.Trim, _
                                                                                Numero.Trim, _
                                                                                Edificio.Trim, _
                                                                                Piso.Trim, _
                                                                                Apartamento.Trim, _
                                                                                Sector.Trim, _
                                                                                Telefono1.Trim, _
                                                                                Ext1.Trim, _
                                                                                Telefono2.Trim, _
                                                                                Ext2.Trim, _
                                                                                Fax.Trim, _
                                                                                Email.Trim, _
                                                                                Tipo_Empresa.Trim, _
                                                                                sectorSalarial, _
                                                                                Nothing, _
                                                                                Nothing, _
                                                                                Id_Zona_Franca, _
                                                                                Es_Zona_Franca, _
                                                                                Tipo_Zona_Franca, _
                                                                                UserName.Trim)

            '/****** Evaluando resultado de la insercion del empleador ****/

            'Insertado sin problemas
            If Split(strRet, "|")(0) = "0" Then

                'Obteniendo el nuevo codigo de Registro Patronal
                Dim tmpRegistroPatronal As Integer = Integer.Parse(Split(strRet, "|")(1))
                Dim tmpIdNomina As Integer
                Dim pass, retRep As String

                'Insertando Representante
                retRep = SuirPlus.Empresas.Representante.insertaRepresentante(Documento_Representante.Trim, _
                                                                                  tmpRegistroPatronal, _
                                                                                  "A", _
                                                                                  Notificacion_Email, _
                                                                                  Tel1_Representante.Trim, _
                                                                                  Ext1_Representante.Trim, _
                                                                                  Tel2_Representante.Trim, _
                                                                                  Ext2_Representante.Trim, _
                                                                                  Email_Representante.Trim, _
                                                                                  UserName.Trim)

                'Verificando posibles errores al crear el representante
                If Split(retRep, "|")(0) = "0" Then

                    pass = Split(retRep, "|")(1)

                    'Insertando Nomina
                    SuirPlus.Empresas.Nomina.insertaNomina(tmpRegistroPatronal, "Nómina Principal", "A", "N", Nothing)

                    'Opteniendo el nuevo numero de nomina
                    tmpIdNomina = Integer.Parse(SuirPlus.Empresas.Nomina.getNomina(tmpRegistroPatronal, -1).Rows(0).Item(1))

                    'Dando acceso a nomina
                    SuirPlus.Empresas.Representante.darAccesoNomina(tmpRegistroPatronal, tmpIdNomina, nss_Representante, UserName.Trim)
                Else
                    Return Err.RepresentanteErr
                End If

                Return tmpRegistroPatronal & "|El Empleador fue registrado satisfactoriamente en TSS. El class se le envió a la dirección de correo registrada."

            Else 'Ocurrio un error
                If Split(strRet, "|")(0) = "210" Then
                    Return Err.EmpreadorExiste
                End If
                Return Err.EmpleadorErr
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return ex.Message.ToString()
        End Try

    End Function
End Class