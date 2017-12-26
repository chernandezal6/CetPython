Imports Microsoft.VisualBasic

Public Class Err

    'Private Shared Constante As String = "1|"

    Public Shared UsuarioPass As String = "10|Error en el Usuario o Password."
    Public Shared NoSePuedeAutorizar As String = "NO."

    Public Shared RNCNoValido As String = "11|Este RNC no se encuentra en nuestras bases de datos."

    ' NO se usa Public Shared NORefPendientes As String = "12|No tiene referencias pendientes"

    Public Shared RefNoValida As String = "13|Esta Referencia no se encuentra en nuestras bases de datos."
    Public Shared RefYaPagada As String = "14|Esta Referencia ya fue autorizada, pagada o cancelada."
    Public Shared RefYaPagadaTSS As String = "14|Esta Referencia ya fue autorizada, pagada,recalculada o revocada."
    Public Shared RefYaRepPagada As String = "15|Esta Referencia ya fue reportada como pagada."
    Public Shared UsuarioDiferente As String = "16|Debe cancelarla el usuario que la autorizó."
    Public Shared FacturaVigente As String = "17|Esta factura debe estar vigente o su total debe ser mayor que 0 parA ser autorizada."
    Public Shared FueraFechaPago As String = "18|Está fuera del período de pago para estos impuestos."
    Public Shared CodigoNominaInvalido As String = "19|Código de Nómina Inválido."
    Public Shared HabilParaPagar As String = "20|Si"
    Public Shared NoHabilParaPagar As String = "21|No"
    Public Shared MontoIncorrecto As String = "22|El monto de la referencia presenta cambios con lo solicitado inicialmente.  Favor revisar en el SUIRPLUS e iniciar el proceso de pago nuevamente."
    Public Shared DebePagarAnterior As String = "23|Debe pagar las facturas anteriores primero."
    Public Shared FacturaCancelada As String = "24|Esta factura esta cancelada."
    Public Shared MovimientosPendientes As String = "25|Tiene movimientos pendientes, debe entrar al SuirPlus y aplicarlos para proceder a pagar este Nro. de Referencia"
    Public Shared NSSinvalido As String = "26|NSS Inválido"
    Public Shared Criterio As String = "27|Debe específicar un criterio"
    Public Shared CedulaInhabilitada As String = "28|Cédula Inhabilitada, Razón: "
    Public Shared CedulaCancelada As String = "29|Cédula Cancelada, Razón: "
    Public Shared UsuarionAutorizado As String = "30|Usuario no autorizado."
    Public Shared EmpleadorLegal As String = "31|El estatus del empleador no permite que se realice este tipo de certificación. Se encuentra en Legal."
    Public Shared RNCRequerido As String = "32|El rnc del empleador es requerido para realizar esta certificación."
    Public Shared NoDisponiblePago As String = "33|Estas liquidaciones no estan disponibles para pago"

    Public Shared RNCInvalido As String = "34|El rnc es requerido para realizar el registro inicial del empleador en TSS."
    Public Shared RazonSocialInvalida As String = "35|La razón social es requerida para realizar el registro inicial del empleador en TSS."
    Public Shared NombreComercialErr As String = "36|El nombre comercial es requerido para realizar el registro inicial del empleador en TSS."
    Public Shared TipoEmpresaInvalido As String = "37|El tipo de empresa(PR=Privada) es requerido."
    Public Shared EsZonaFrancaErr As String = "38|Si el establecimiento es una zona franca(S=Si, N=No)."
    Public Shared TipoZonaFrancaErr As String = "39|Solo si es zona franca(el tipo es requerido y debe ser 1=Comercial, 2=Normal)."
    Public Shared IdZonaFrancaErr As String = "40|Solo si es zona franca, el Id correspondiente es requerido."
    Public Shared RepresentanteInvalido As String = "41|Representante inválido."
    Public Shared Email_RepresentanteErr As String = "42|Email Representante inválido."
    Public Shared NotificacionesxEmail_Rep As String = "43|El representante debe especificar si prefiere notificaciones por email(S/N)."
    Public Shared RepresentanteErr As String = "44|Error creando el representante."
    Public Shared EmpreadorExiste As String = "45|Este empleador ya existe."
    Public Shared EmpleadorErr As String = "46|Error creando el empleador."
    Public Shared SectorEconomicoErr As String = "47|Id sector económico inválido."
    Public Shared SectorSalarialErr As String = "48|Id sector salarial inválido."
    Public Shared ZonaFrancaErr As String = "49|Id zona franca inválido."
    Public Shared MunicipioErr As String = "50|Id municipio inválido."
    Public Shared Telefono1Err As String = "51|El teléfono1 es inválido."
    Public Shared Ext1Err As String = "52|La ext1 es inválida."
    Public Shared Telefono2Err As String = "53|El teléfono2 es inválido."
    Public Shared Ext2Err As String = "54|La ext2 es inválida."
    Public Shared FaxErr As String = "55|El fax es inválido."
    Public Shared EmailErr As String = "56|El email es inválido."
    Public Shared Tel1RepErr As String = "57|El teléfono1 del representante es inválido."
    Public Shared Ext1RepErr As String = "58|La ext1 del representante es inválida."
    Public Shared Tel2RepErr As String = "59|El Teléfono2 del representante es inválido."
    Public Shared Ext2RepErr As String = "60|La ext2 del representante es inválida."

    Public Shared CedulaErr As String = "61|Cédula inválida."
    Public Shared AñoErr As String = "62|Año inválido."
    Public Shared ServicioJCEErr As String = "63|ERROR CONSULTANDO SERVICIO JCE."
    Public Shared CedulaEnviadaEV As String = "64|REGISTRO CONSULTADO EXISTE, ENVIADO A EVALUACION VISUAL."
    Public Shared CedulaEnProcesoEV As String = "65|REGISTRO EN PROCESO DE EVALUACION VISUAL."
    Public Shared RNCoCedulaInvalida As String = "66|RNC inválido."





End Class

Public Class Msg

    Public Shared FacturaAutorizada As String = "Factura Autorizada"

End Class
