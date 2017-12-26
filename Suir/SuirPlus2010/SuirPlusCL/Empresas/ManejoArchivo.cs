using System;
using System.Data;
using System.Web;
using System.IO;
using System.Text;
using SuirPlus;
using SuirPlus.Utilitarios;
using SuirPlus.DataBase;
using System.Collections;
using System.Configuration;
using SuirPlus.Empresas.Facturacion;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.Empresas.SubsidiosSFS;
using Microsoft.VisualBasic;
using ICSharpCode.SharpZipLib.Zip;
namespace SuirPlus.Empresas
{

    /// <summary>
    /// 111
    /// </summary>
    public class Archivo
    {

        #region "Miembros y variables privadas"

        private string myNombreAchivo;
        private string myNombreArchivoGenerado;
        private int myNumero;
        private string username;
        private int nss;
        private string rncArchivo;
        private string rncEmpleador;
        private int myCodigoError;
        private string myMensajeError;
        private string myResultado;
        private string myProceso;
        private string myTipoProceso;
        private DateTime myFechaCarga;
        private string myEstatus;
        private int myTotalRegistros;
        private int myRegistrosValidos;
        private int myRegistrosInvalidos;
        private string myUsuarioCarga;

        private MemoryStream myResultFile = new MemoryStream();
        private StreamReader readerFile;

        #endregion

        #region "Propiedades"

        /// <summary>
        /// Se obtiene el nombre original del archivo que se cargo
        /// </summary>
        public string NombreAchivo
        {
            get
            {
                return myNombreAchivo;
            }
        }

        /// <summary>
        /// Se obtiene el nombre que le fue asignado al archivo por SuirPlus.
        /// </summary>
        public string NombreArchivoGenerado
        {
            get
            {
                return myNombreArchivoGenerado;
            }
        }

        /// <summary>
        /// El número de referencia del archivo.
        /// </summary>
        public int Numero
        {
            get
            {
                return myNumero;
            }
        }

        /// <summary>
        /// Mensaje de resultado que viene de la base de datos.
        /// </summary>
        public string Resultado
        {
            get
            {
                return this.myResultado;
            }
        }

        /// <summary>
        /// Se obtiene el proceso que afecta el archivo.
        /// </summary>
        public string Proceso
        {
            get
            {
                return this.myProceso;
            }
        }

        /// <summary>
        /// Indica el tipo del proceso al que pertenece el archivo.
        /// </summary>
        public string TipoProceso
        {
            get
            {
                return this.myTipoProceso;
            }
        }

        /// <summary>
        /// Fecha en la que se cargo el archivo.
        /// </summary>
        public DateTime FechaCarga
        {
            get
            {
                return this.myFechaCarga;
            }
        }

        /// <summary>
        /// Se obtiene el estatus que tiene el archivo.
        /// </summary>
        public string Estatus
        {
            get
            {
                return this.myEstatus;
            }
        }

        /// <summary>
        /// Se obtiene el total de registros contenido en el archivo.
        /// </summary>
        public int TotalRegistros
        {
            get
            {
                return this.myTotalRegistros;
            }
        }

        /// <summary>
        /// Usuario que cargó originalmente el archivo
        /// </summary>
        public string UsuarioCarga
        {
            get
            {
                return this.myUsuarioCarga;
            }
        }

        /// <summary>
        /// Se obtiene la cantidad de registros validos del archivo.
        /// </summary>
        public int RegistrosValidos
        {
            get
            {
                return this.myRegistrosValidos;
            }
        }

        /// <summary>
        /// Se  obtiene la cantidad de registros invalidos del archivo.
        /// </summary>
        public int RegistrosInvalidos
        {
            get
            {
                return this.myRegistrosInvalidos;
            }
        }



        #endregion

        #region "Funciones publicas"

        public Archivo(int id_referencia, string rnc)
        {
            this.myNumero = id_referencia;
            this.rncArchivo = rnc;
            this.cargaDatos();
        }

        /// <summary>
        /// Enumerado utilizado para definir los tipos de archivos que maneja el SUIR plus.
        /// </summary>
        /// <remarks>Autor: Ronny J. Carreras, Fecha: 09/11/2004</remarks>
        public enum SuirArchivoType
        {
            AutodeterminacionMensual,
            AutodeterminacionRetroactiva,
            NovedadesPeriodo,
            NovedadesAtrasadas,
            FacturaAuditoria,
            CreditoFacturaAuditoria,
            Recaudacion,
            Aclaracion,
            CancelacionesAutorizaciones,
            DependientesAdicionales,
            Rectificativa,
            DeclaracionFinalIR3,
            Bonificacion,
            DevolucionAportes,
            NovedadesPensionados,
            TraspasoPensionados,
            ValidacionRegimenSubsidiado,
            PlanillaDGT3,
            PlanillaDGT4,
            EstatusDefinitivoAuditoria,
            MovimientoTrabajadores,
            PagoRetroactivoEnfermedadNoLaboral
        }


        public Archivo(string FileName, Stream data, SuirArchivoType tipoArchivo, string username, int nss, string rncEmpleador, string IPAddress)
        {

            if (FileName != null)
            {

                //Asignamos los valores las propiedades.
                string tmpNombreArchivo = Path.GetFileName(FileName);
                myNombreAchivo = tmpNombreArchivo;
                Stream myArchivoStream = data;

                //Verificamos si el arhivo viene Zipiado.
                if (Path.GetExtension(tmpNombreArchivo).ToUpper() == ".ZIP")
                {
                    myArchivoStream = getArchivoSinComprimir(data);

                }


                //Verificamos si la extension del archivo es valida.
                if (!esExtensionValida())
                {
                    //Asignamos el código del error y
                    //procedemos a buscar la descripcion pasandole el codigo de error a la funcion desarrollada para estos fines
                    myCodigoError = 200;
                    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                    throw new Exception(myMensajeError);
                }

                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de auditoria.
                if (tipoArchivo == SuirArchivoType.FacturaAuditoria)
                {

                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    //verificamos que el usuario tenga el role para el envio del archivo.
                    if (!esUsuarioPermitidoCargarArchivoAuditoria(username))
                    {
                        myCodigoError = 203;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    this.username = username;
                    this.GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

                }


                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de auditoria.
                if (tipoArchivo == SuirArchivoType.EstatusDefinitivoAuditoria)
                {

                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    this.username = username;
                    this.GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

                }


                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de Credito factura auditoria.
                if (tipoArchivo == SuirArchivoType.CreditoFacturaAuditoria)
                {

                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    //verificamos que el usuario tenga el role para el envio del archivo.
                    if (!esUsuarioPermitidoCargarArchivoAuditoria(username))
                    {
                        myCodigoError = 203;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    this.username = username;
                    this.GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

                }

                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de pago
                //retroactivo por enfermedad no laboral.
                //if (tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral)
                //{

                //    //Verificamos que el archivo sea valido para el procesos que se escogió.
                //    if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                //    {
                //        myCodigoError = 207;
                //        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                //        throw new Exception(myMensajeError);
                //    }

                //    //verificamos que el usuario tenga el role para el envio del archivo.

                //    this.username = username;
                //    this.GuardarArchivo(myArchivoStream, tipoArchivo, IPAddress);

                //}



                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de banco.
                if ((tipoArchivo == SuirArchivoType.Aclaracion) || (tipoArchivo == SuirArchivoType.Recaudacion))
                {

                    //Mandamos a decencriptar el archivo

                    decifrarArchivo(myArchivoStream);

                    //Verificamos que el nombre del archivo comiense con DGII-
                    if (!esNombreValido())
                    {
                        myCodigoError = 208;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    // TODO Verificamos que el archivo este encriptado.

                    //Verificamos que el usuario que está enviando el archivo tiene permiso para cargar archivo de la entidad que esta en el archivo.
                    if (!esUsuarioPermitidoCargarArchivo(this.readerFile, username))
                    {

                        myCodigoError = 203;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);

                    }

                    //asignamos el username que esta cargando el archivo.
                    this.username = username;


                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(this.readerFile, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    //Guardamos el archivo de los bancos.
                    this.GuardarArchivo(this.readerFile,IPAddress);

                }

                //Verificamos si el representante tiene permiso a cargar el archivo del RNC que esta en el archivo.		
                if (
                    (tipoArchivo == SuirArchivoType.AutodeterminacionMensual) ||
                    (tipoArchivo == SuirArchivoType.AutodeterminacionRetroactiva) ||
                    (tipoArchivo == SuirArchivoType.NovedadesAtrasadas) ||
                    (tipoArchivo == SuirArchivoType.NovedadesPeriodo) ||
                    (tipoArchivo == SuirArchivoType.DependientesAdicionales) ||
                    (tipoArchivo == SuirArchivoType.Rectificativa) ||
                    (tipoArchivo == SuirArchivoType.DeclaracionFinalIR3) ||
                    (tipoArchivo == SuirArchivoType.Bonificacion) ||
                    (tipoArchivo == SuirArchivoType.DevolucionAportes) ||
                    (tipoArchivo == SuirArchivoType.TraspasoPensionados) ||
                    (tipoArchivo == SuirArchivoType.PlanillaDGT3) ||
                    (tipoArchivo == SuirArchivoType.PlanillaDGT4) ||
                    (tipoArchivo == SuirArchivoType.MovimientoTrabajadores)||
                    (tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral)
                    )
                {

                    //Verificamos que los parametros requeridos sean proporcionado.
                    if ((username == null) || (username == string.Empty))
                    {
                        throw new Exception("El parametro username debe ser proporcionado");
                    }
                    else
                    {
                        this.username = username;
                        this.nss = nss;
                    }


                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (esValidoParaElProceso(myArchivoStream, tipoArchivo) == false)
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    string rnc = string.Empty;
                    string mensaje = string.Empty;
                    string periodo = string.Empty;
                    if (!(tipoArchivo == SuirArchivoType.TraspasoPensionados) || !(tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral))
                    {
                        rnc = getRNC(myArchivoStream);
                    }


                    if ((tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral))
                    {
                        rnc = getRNC_PR(myArchivoStream);
                    }

                    //Aqui se pone la pregunta al metodo que devuelve la marca y se devuelve un msj de error.
                    ////////
                    if (tipoArchivo == SuirArchivoType.DependientesAdicionales || tipoArchivo == SuirArchivoType.DevolucionAportes)
                    {
                        periodo = "0";
                    }
                    else
                    {
                        periodo = this.getPeriodo(myArchivoStream);
                    }
                    //Verificamos que el RNC del empleador este en el archivo.
                    if (rnc == null)
                    {
                        myCodigoError = 150;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    if (tipoArchivo == SuirArchivoType.DevolucionAportes)
                    {
                        rncEmpleador = rnc;

                    }

                    //Verificamos que el rnc empleador no este en blanco.
                    if ((rncEmpleador == string.Empty) || (rncEmpleador == null))
                    {
                        throw new Exception("El parametro RNC del Empleador debe ser proporcionado");
                    }
                    else
                    {
                        this.rncEmpleador = rncEmpleador;
                    }


                    if (periodo == null)
                    {
                        if (!(tipoArchivo == SuirArchivoType.TraspasoPensionados) && !(tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral))
                        {
                            myCodigoError = 83;
                            myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                            throw new Exception(myMensajeError);
                        }
                    }


                    switch (tipoArchivo)
                    {

                        case SuirArchivoType.Rectificativa:
                            //Si el tipo de archivo es rectificativa, hacemos varias validaciones particulares para este archivo.
                            //Verificamos que el periodo sea del año anterior al actual y que el empleador realmente pueda hacer rectificativa para el periodo enviado.
                            //if(this.esAnioAnterior(periodo) == false)
                            //{
                            //    throw new Exception("El año del periodo rectificativo debe ser anterior al actual");
                            //}

                            if (this.puedeEnviarRectificativa(ref mensaje, rnc, periodo) == false)
                            {
                                throw new Exception(mensaje);
                            }

                            break;

                        case SuirArchivoType.AutodeterminacionRetroactiva:
                            ////Si el archivo es de tipo AR verificamos que el estatus de cobro no sea de legal
                            //// de ser asi retornamos un mensaje de error.
                            //if(this.isEmpleadorEnLegal(rnc))
                            //{
                            //    myCodigoError = 202;
                            //    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                            //    throw new Exception(myMensajeError);
                            //}

                            Empleador emp = new Empleador(rnc);

                            //if (HttpContext.Current.Session["TipoUsuario"].ToString() != "Usuario")
                            //{
                            //    //Si el empleador no tiene un status de cobro normal o de rectificacion retornamos un mensaje de error.
                            //    if (emp.StatusCobro != StatusCobrosType.Normal && emp.StatusCobro != StatusCobrosType.Rectificacion)
                            //    {
                            //        myCodigoError = 202;
                            //        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                            //        throw new Exception(myMensajeError);
                            //    }
                            //}
                            ////Verificamos que si esta en rectificacion el tipo de usuario no sea tipo 2 (Representante)
                            if (HttpContext.Current.Session["TipoUsuario"].ToString() == "2" & emp.StatusCobro == StatusCobrosType.Rectificacion)
                            {
                                myCodigoError = 202;
                                myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                                throw new Exception(myMensajeError);
                            }


                            break;

                        case SuirArchivoType.Bonificacion:

                            //Verificamos que no haya una factura de bonos pagada o autorizada.
                            if (LiquidacionInfotep.existeFacturaBonosPagada(rnc, periodo))
                            {
                                myCodigoError = 215;
                                myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                                throw new Exception(myMensajeError);
                            }

                            break;
                    }
                       
                    //Verificamos que el rnc del archivo sea igual que el rnc de la empresa del usuario que esta logueado.

                    if (!(tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral))
                    {
                        if (getRNC(myArchivoStream) != rncEmpleador)
                        {
                            if (!(tipoArchivo == SuirArchivoType.TraspasoPensionados))
                            {
                                myCodigoError = 206;
                                myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                                throw new Exception(myMensajeError);
                            }
                        }

                    }

                    else


                    {

                        if (getRNC_PR(myArchivoStream) != rncEmpleador)
                        {
                           
                                myCodigoError = 206;
                                myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                                throw new Exception(myMensajeError);
                            
                        }
                    
                    }

                    if ((tipoArchivo != SuirArchivoType.DevolucionAportes) && (tipoArchivo != SuirArchivoType.TraspasoPensionados))
                    {

                        if (nss == 0)
                        {
                            throw new Exception("El nss del representante es requerido para realizar esta operacion.");
                        }
                        else
                        {
                            if (!isRepresentante(ref mensaje, this.nss, rnc))
                            {
                                throw new Exception(mensaje);
                            }
                        }
                    }

                    //Guardamos el archivo					
                    GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

                }

                //Validacion de regimen subsidiado no requiere pre-validaciones
                if (tipoArchivo == Archivo.SuirArchivoType.ValidacionRegimenSubsidiado)
                {
                    //Guardamos el archivo					
                    GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);
                }

            }

            else
            {
                //TODO: Disparar el mensaje que le pertenece
                throw new Exception("El archivo enviado no puede ser nulo");
            }

        }


        public Archivo(HttpPostedFile archivo, SuirArchivoType tipoArchivo, string username, int nss, string rncEmpleador, string IPAddress)
        {

            if (archivo != null)
            {

                //Asignamos los valores las propiedades.
                string tmpNombreArchivo = Path.GetFileName(archivo.FileName);
                myNombreAchivo = Path.GetFileName(archivo.FileName);
                Stream myArchivoStream = archivo.InputStream;

                //Verificamos si el arhivo viene Zipiado.
                if (Path.GetExtension(tmpNombreArchivo).ToUpper() == ".ZIP")
                {
                    myArchivoStream = getArchivoSinComprimir(archivo.InputStream);

                }


                //Verificamos si la extension del archivo es valida.
                if (!esExtensionValida())
                {
                    //Asignamos el código del error y
                    //procedemos a buscar la descripcion pasandole el codigo de error a la funcion desarrollada para estos fines
                    myCodigoError = 200;
                    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                    throw new Exception(myMensajeError);
                }

                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de auditoria.
                if (tipoArchivo == SuirArchivoType.FacturaAuditoria)
                {

                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    //verificamos que el usuario tenga el role para el envio del archivo.
                    if (!esUsuarioPermitidoCargarArchivoAuditoria(username))
                    {
                        myCodigoError = 203;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    this.username = username;
                    this.GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

                }

                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de credito factura auditoria.
                if (tipoArchivo == SuirArchivoType.CreditoFacturaAuditoria)
                {

                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    //verificamos que el usuario tenga el role para el envio del archivo.
                    if (!esUsuarioPermitidoCargarArchivoAuditoria(username))
                    {
                        myCodigoError = 203;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    this.username = username;
                    this.GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

                }

                if (tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral)
                {

                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    this.username = username;
                    this.GuardarArchivo(myArchivoStream, tipoArchivo, IPAddress);

                }

                //Evaluamos ciertas condiciones que se deben cumplir para procesar un archivo de banco.
                if ((tipoArchivo == SuirArchivoType.Aclaracion) || (tipoArchivo == SuirArchivoType.Recaudacion))
                {

                    //Mandamos a decencriptar el archivo
                    decifrarArchivo(myArchivoStream);

                    //Verificamos que el nombre del archivo comiense con DGII-
                    if (!esNombreValido())
                    {
                        myCodigoError = 208;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    // TODO Verificamos que el archivo este encriptado.

                    //Verificamos que el usuario que está enviando el archivo tiene permiso para cargar archivo de la entidad que esta en el archivo.
                    if (!esUsuarioPermitidoCargarArchivo(this.readerFile, username))
                    {

                        myCodigoError = 203;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);

                    }

                    //asignamos el username que esta cargando el archivo.
                    this.username = username;


                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (!esValidoParaElProceso(this.readerFile, tipoArchivo))
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    //Guardamos el archivo de los bancos.
                    this.GuardarArchivo(this.readerFile,IPAddress);

                }

                //Verificamos si el representante tiene permiso a cargar el archivo del RNC que esta en el archivo.		
                if (
                    (tipoArchivo == SuirArchivoType.AutodeterminacionMensual) ||
                    (tipoArchivo == SuirArchivoType.AutodeterminacionRetroactiva) ||
                    (tipoArchivo == SuirArchivoType.NovedadesAtrasadas) ||
                    (tipoArchivo == SuirArchivoType.NovedadesPeriodo) ||
                    (tipoArchivo == SuirArchivoType.DependientesAdicionales) ||
                    (tipoArchivo == SuirArchivoType.Rectificativa) ||
                    (tipoArchivo == SuirArchivoType.Bonificacion) ||
                    (tipoArchivo == SuirArchivoType.MovimientoTrabajadores)
                    )
                {

                    //Verificamos que los parametros requeridos sean proporcionado.
                    if ((username == null) || (username == string.Empty))
                    {
                        throw new Exception("El parametro username debe ser proporcionado");
                    }
                    else
                    {
                        this.username = username;
                        this.nss = nss;
                    }


                    //Verificamos que el rnc empleador no este en blanco.
                    if ((rncEmpleador == string.Empty) || (rncEmpleador == null))
                    {
                        throw new Exception("El parametro RNC del Empleador debe ser proporcionado");
                    }
                    else
                    {
                        this.rncEmpleador = rncEmpleador;
                    }


                    //Verificamos que el archivo sea valido para el procesos que se escogió.
                    if (esValidoParaElProceso(myArchivoStream, tipoArchivo) == false)
                    {
                        myCodigoError = 207;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }


                    string rnc = getRNC(myArchivoStream);
                    string mensaje = string.Empty;
                    string periodo = string.Empty;
                    ////////
                    if (tipoArchivo != SuirArchivoType.DependientesAdicionales)
                    {
                        periodo = this.getPeriodo(myArchivoStream);
                    }
                    else
                    {
                        periodo = "0";
                    }
                    //Verificamos que el RNC del empleador este en el archivo.
                    if (rnc == null)
                    {
                        myCodigoError = 150;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    if (periodo == null)
                    {
                        myCodigoError = 83;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }





                    switch (tipoArchivo)
                    {

                        case SuirArchivoType.Rectificativa:
                            //Si el tipo de archivo es rectificativa, hacemos varias validaciones particulares para este archivo.
                            //Verificamos que el periodo sea del año anterior al actual y que el empleador realmente pueda hacer rectificativa para el periodo enviado.
                            //if(this.esAnioAnterior(periodo) == false)
                            //{
                            //    throw new Exception("El año del periodo rectificativo debe ser anterior al actual");
                            //}

                            if (this.puedeEnviarRectificativa(ref mensaje, rnc, periodo) == false)
                            {
                                throw new Exception(mensaje);
                            }

                            break;

                        case SuirArchivoType.AutodeterminacionRetroactiva:
                            ////Si el archivo es de tipo AR verificamos que el estatus de cobro no sea de legal
                            //// de ser asi retornamos un mensaje de error.
                            //if(this.isEmpleadorEnLegal(rnc))
                            //{
                            //    myCodigoError = 202;
                            //    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                            //    throw new Exception(myMensajeError);
                            //}

                            Empleador emp = new Empleador(rnc);

                            //Si el empleador no tiene un status de cobro normal o de rectificacion retornamos un mensaje de error.
                            if (emp.StatusCobro != StatusCobrosType.Normal && emp.StatusCobro != StatusCobrosType.Rectificacion)
                            {
                                myCodigoError = 202;
                                myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                                throw new Exception(myMensajeError);
                            }

                            //Verificamos que si esta en rectificacion el tipo de usuario no sea tipo 2 (Representante)
                            if (HttpContext.Current.Session["TipoUsuario"].ToString() == "2" & emp.StatusCobro == StatusCobrosType.Rectificacion)
                            {
                                myCodigoError = 202;
                                myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                                throw new Exception(myMensajeError);
                            }


                            break;

                        case SuirArchivoType.Bonificacion:

                            //Verificamos que no haya una factura de bonos pagada o autorizada.
                            if (LiquidacionInfotep.existeFacturaBonosPagada(rnc, periodo))
                            {
                                myCodigoError = 215;
                                myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                                throw new Exception(myMensajeError);
                            }

                            break;
                    }

                    //Verificamos que el rnc del archivo sea igual que el rnc de la empresa del usuario que esta logueado.
                    if (getRNC(myArchivoStream) != rncEmpleador)
                    {
                        myCodigoError = 206;
                        myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                        throw new Exception(myMensajeError);
                    }

                    if (nss == 0)
                    {
                        throw new Exception("El nss del representante es requerido para realizar esta operacion.");
                    }
                    else
                    {
                        if (!isRepresentante(ref mensaje, this.nss, rnc))
                        {
                            throw new Exception(mensaje);
                        }
                    }

                    //Guardamos el archivo					
                    GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

                }
            }

            else
            {
                //TODO: Disparar el mensaje que le pertenece
                throw new Exception("El archivo enviado no puede ser nulo");
            }

        }

        public Archivo(string FileName, Stream data, SuirArchivoType tipoArchivo, string username, string idars, string IPAddress)
        {

            if (FileName != null)
            {

                //Asignamos los valores las propiedades.
                string tmpNombreArchivo = Path.GetFileName(FileName);
                myNombreAchivo = tmpNombreArchivo;
                Stream myArchivoStream = data;

                //Verificamos si el arhivo viene Zipiado.
                if (Path.GetExtension(tmpNombreArchivo).ToUpper() == ".ZIP")
                {
                    myArchivoStream = getArchivoSinComprimir(data);

                }


                //Verificamos si la extension del archivo es valida.
                if (!esExtensionValida())
                {
                    //Asignamos el código del error y
                    //procedemos a buscar la descripcion pasandole el codigo de error a la funcion desarrollada para estos fines
                    myCodigoError = 200;
                    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                    throw new Exception(myMensajeError);
                }

                //Verificamos que el archivo sea valido para el procesos que se escogió.
                if (!esValidoParaElProceso(myArchivoStream, tipoArchivo))
                {
                    myCodigoError = 207;
                    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                    throw new Exception(myMensajeError);
                }

                //verificamos que el usuario tenga el role para el envio del archivo.
                if (!esUsuarioPermitidoCargarArchivoAfiliacion(username))
                {
                    myCodigoError = 203;
                    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                    throw new Exception(myMensajeError);
                }

                this.username = username;


                //Verificamos que los parametros requeridos sean proporcionado.
                if ((username == null) || (username == string.Empty))
                {
                    throw new Exception("El parametro username debe ser proporcionado");
                }


                string ARS = getARS(myArchivoStream);

                //Verificamos que el IDARS  este en el archivo.
                if (ARS == null)
                {
                    myCodigoError = 150;
                    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                    throw new Exception(myMensajeError);
                }

                //Verificamos que el ARS del archivo sea igual que el ARS de la empresa del usuario que esta logueado.
                if (getARS(myArchivoStream) != idars)
                {
                    myCodigoError = 206;
                    myMensajeError = Utilitarios.TSS.getErrorDescripcion(myCodigoError);
                    throw new Exception(myMensajeError);
                }


                //Guardamos el archivo					
                GuardarArchivo(myArchivoStream, tipoArchivo,IPAddress);

            }
            else
            {
                //TODO: Disparar el mensaje que le pertenece
                throw new Exception("El archivo enviado no puede ser nulo");

            }
        }


        private Stream getArchivoSinComprimir(Stream zipFile)
        {
            ZipInputStream zip = new ZipInputStream(zipFile);
            ZipEntry theEntry;
            string tmpFileName = string.Empty;
            MemoryStream tmpFile = new MemoryStream();
            int entry = 0;

            while ((theEntry = zip.GetNextEntry()) != null)
            {
                if (entry == 1)
                    throw new Exception("El archivo Zip solo puede contener 1 archivo.");

                tmpFileName = Path.GetFileName(theEntry.Name);
                if (tmpFileName != String.Empty)
                {
                    myNombreAchivo = tmpFileName;
                    int size = 256;
                    byte[] data = new byte[256];

                    while (true)
                    {
                        size = zip.Read(data, 0, data.Length);
                        if (size > 0)
                        {
                            tmpFile.Write(data, 0, size);
                        }
                        else
                        {
                            break;
                        }
                    }

                    entry++;

                }
            }

            zip.Close();
            return tmpFile;
        }


        public void cargaDatos()
        {

            DataTable dt = new DataTable();
            string cmdStr = "SRE_ARCHIVOS_PKG.get_Info_Archivo";
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = this.Numero;

            arrParam[1] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = this.rncArchivo;

            arrParam[2] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];

            }
            catch
            {
                //throw ex;
            }
            finally
            {
                this.myResultado = arrParam[2].Value.ToString();
                if (!Utilitarios.Utils.sacarMensajeDeError(myResultado).Equals("OK"))
                {
                    throw new Exception(Utilitarios.Utils.sacarMensajeDeError(myResultado));
                }
                this.myResultado = Utilitarios.Utils.sacarMensajeDeError(myResultado);
            }

            if (dt.Rows.Count > 0)
            {
                this.myProceso = dt.Rows[0]["tipo_movimiento_des"].ToString();
                this.myTipoProceso = dt.Rows[0]["id_tipo_movimiento"].ToString();
                this.myEstatus = dt.Rows[0]["status"].ToString();
                this.myResultado = dt.Rows[0]["error_des"].ToString();
                if (dt.Rows[0]["fecha_carga"].ToString() != string.Empty)
                {
                this.myFechaCarga = Convert.ToDateTime(dt.Rows[0]["fecha_carga"]);
                }      


                this.myRegistrosValidos = Convert.ToInt32(dt.Rows[0]["registros_ok"]);
                this.myRegistrosInvalidos = Convert.ToInt32(dt.Rows[0]["registros_bad"]);
                this.myTotalRegistros = Convert.ToInt32(dt.Rows[0]["Total_Registros"]);
                this.myUsuarioCarga = dt.Rows[0]["Usuario_Carga"].ToString();

            }

        }

        /// <summary>
        /// Función boleana que verifica si la extension de un archivo es válido.
        /// </summary>
        /// <remarks>Autor: Ronny J. Carreras, Fecha: 09/11/2004</remarks>
        /// <returns>True si la extension del archivo es .TXT, de lo contrario False.</returns>
        public bool esExtensionValida()
        {
            return (Path.GetExtension(myNombreAchivo.ToUpper()).Equals(".TXT") || (Path.GetExtension(myNombreAchivo.ToUpper()).Equals(".TSSE")));

        }


        /// <summary>
        /// Funcion utilizada para verificar si el archivo que es cargado es valido para el proceso seleccionado
        /// </summary>
        /// <param name="archivo">El archivo cargado por el usuario</param>
        /// <param name="tipoArchivo">El tipo de archivo que representa el proceso que va a afectar</param>
        /// <remarks>Autor: Ronny J. Carreras, Fecha: 10/11/2004</remarks>
        /// <returns></returns>
        public bool esValidoParaElProceso(Stream archivo, SuirArchivoType tipoArchivo)
        {
            if (archivo == null) throw new Exception(TSS.getErrorDescripcion(200));

            StreamReader rLectorArchivo;
            archivo.Position = 0;
            string linea = string.Empty;
            bool archivoValido = false;

            switch (tipoArchivo)
            {

                case SuirArchivoType.AutodeterminacionMensual:

                    //Si el tipo de archivo es de autodeterminacion mensual entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("AM"))) archivoValido = true;
                    }

                    break;

                case SuirArchivoType.AutodeterminacionRetroactiva:

                    //Si el tipo de archivo es de Autodeterminacion Retroactiva entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("AR"))) archivoValido = true;

                    }

                    break;

                case SuirArchivoType.FacturaAuditoria:

                    //Si el tipo de archivo es de factura de auditoria entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("RA"))) archivoValido = true;

                    }

                    break;

                case SuirArchivoType.CreditoFacturaAuditoria:

                    //Si el tipo de archivo es de Credito factura de auditoria entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("RC"))) archivoValido = true;

                    }

                    break;

                case SuirArchivoType.NovedadesAtrasadas:

                    //Si el tipo de archivo es de novdades atrasadas entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("NA"))) archivoValido = true;

                    }

                    break;

                case SuirArchivoType.NovedadesPeriodo:

                    //Si el tipo de archivo es de novedades de periodo entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == "E") && (linea.Substring(1, 2).ToUpper() == "NV")) archivoValido = true;

                    }

                    break;

                case SuirArchivoType.DependientesAdicionales:

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("RD"))) archivoValido = true;

                    }

                    break;

                case SuirArchivoType.DeclaracionFinalIR3:

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("DF"))) archivoValido = true;
                    }

                    break;

                case SuirArchivoType.Rectificativa:

                    rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                    try
                    {
                        linea = rLectorArchivo.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("RT"))) archivoValido = true;
                    }

                    break;

                case SuirArchivoType.Bonificacion:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("BO"))) archivoValido = true;
                        }

                        break;
                    }

                case SuirArchivoType.DevolucionAportes:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("DA"))) archivoValido = true;
                        }

                        break;
                    }

                case SuirArchivoType.NovedadesPensionados:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("PN"))) archivoValido = true;
                        }

                        break;
                    }

                case SuirArchivoType.TraspasoPensionados:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("PT"))) archivoValido = true;
                        }

                        break;
                    }

                case SuirArchivoType.ValidacionRegimenSubsidiado:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("VS"))) archivoValido = true;
                        }

                        break;
                    }

                case SuirArchivoType.PlanillaDGT3:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("T3"))) archivoValido = true;
                        }

                        break;
                    }

                case SuirArchivoType.PlanillaDGT4:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("T4"))) archivoValido = true;
                        }

                        break;
                    }

                case SuirArchivoType.EstatusDefinitivoAuditoria:
                    {

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("EA"))) archivoValido = true;
                        }

                        break;
                    }
                case SuirArchivoType.MovimientoTrabajadores:
                    {
                        //Si el tipo de archivo es de movimiento de trabajadores entonces verificamos que el header del archivo posteado
                        //corresponda con el proceso seleccionado.

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 2).ToUpper() == ("MO"))) archivoValido = true;
                        }

                        break;
                    }
                case SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral:
                    {
                        //Si el tipo de archivo es de movimiento de trabajadores entonces verificamos que el header del archivo posteado
                        //corresponda con el proceso seleccionado.

                        rLectorArchivo = new StreamReader(archivo, Encoding.UTF8);

                        try
                        {
                            linea = rLectorArchivo.ReadLine();
                        }
                        catch (Exception ex)
                        {
                            throw ex;
                        }

                        if (linea != string.Empty || linea != null)
                        {
                            if ((linea.Substring(0, 1).ToUpper() == ("E")) && (linea.Substring(1, 3).ToUpper() == ("PRE"))) archivoValido = true;
                        }

                        break;
                    }
            }



            return archivoValido;

        }


        public bool esValidoParaElProceso(StreamReader archivo, SuirArchivoType tipoArchivo)
        {

            if (archivo == null) throw new Exception(TSS.getErrorDescripcion(200));

            string linea = string.Empty;
            bool archivoValido = false;

            switch (tipoArchivo)
            {

                case SuirArchivoType.Recaudacion:

                    //Si el tipo de archivo es de recaudacion entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    try
                    {

                        this.myResultFile.Position = 0;
                        StreamReader arch = new StreamReader(this.myResultFile);
                        this.myResultFile.Position = 0;
                        linea = arch.ReadLine();

                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if (linea.Substring(0, 5) == ("EREEP")) archivoValido = true;

                    }

                    break;

                case SuirArchivoType.Aclaracion:

                    //Si el tipo de archivo es de recaudacion entonces verificamos que el header del archivo posteado
                    //corresponda con el proceso seleccionado.

                    try
                    {
                        StreamReader arch = new StreamReader(this.myResultFile);
                        this.myResultFile.Position = 0;
                        linea = arch.ReadLine();
                    }
                    catch (Exception ex)
                    {
                        throw ex;
                    }

                    if (linea != string.Empty || linea != null)
                    {
                        if (linea.Substring(0, 5) == ("EREAC")) archivoValido = true;
                    }

                    break;

            }

            return archivoValido;

        }


        /// <summary>
        /// Funcion utilizada para obtener el RNC del archivo que se esta cargando
        /// </summary>
        /// <param name="archivo">El archivo posteado.</param>
        /// <returns>Un cadena con el RNC de la empresa.</returns>
        public string getRNC(Stream archivo)
        {
            archivo.Position = 0;
            string linea = string.Empty;
            StreamReader rLectorArchivo2 = new StreamReader(archivo, Encoding.UTF8);
            linea = rLectorArchivo2.ReadLine();
            try
            {
                linea = linea.Substring(3, 11);

            }
            catch
            {
                return null;
            }

            return linea.Trim();
        }

        public string getRNC_PR(Stream archivo)
        {
            archivo.Position = 0;
            string linea = string.Empty;
            StreamReader rLectorArchivo2 = new StreamReader(archivo, Encoding.UTF8);
            linea = rLectorArchivo2.ReadLine();
            try
            {
                linea = linea.Substring(4, 11);

            }
            catch
            {
                return null;
            }

            return linea.Trim();
        }


        public string getARS(Stream archivo)
        {
            archivo.Position = 0;
            string linea = string.Empty;
            StreamReader rLectorArchivo2 = new StreamReader(archivo, Encoding.UTF8);
            linea = rLectorArchivo2.ReadLine();
            try
            {
                linea = linea.Substring(3, 2);

            }
            catch
            {
                return null;
            }

            return linea.Trim();
        }


        /// <summary>
        /// Funcion utilizada para obtener el periodo del archivo
        /// </summary>
        /// <param name="archivo">el archivo que posteo el empleador</param>
        /// <returns>una cadena representando el periodo en formato mesaño ej: "012006"</returns>
        public string getPeriodo(Stream archivo)
        {
            archivo.Position = 0;
            string periodo = string.Empty;
            StreamReader rLectorArchivo3 = new StreamReader(archivo, Encoding.UTF8);
            periodo = rLectorArchivo3.ReadLine();
            try
            {
                periodo = periodo.Substring(14, 6);
            }
            catch
            {
                return null;
            }

            return periodo.Trim();
        }

        /// <summary>
        /// Funcion utilizada para validar si el usuario que carga el archivo tiene permiso sobre la entidad especificada,
        /// en el archivo.
        /// </summary>
        /// <param name="nss">Número de seguridad social del representante.</param>
        /// <param name="rnc">RNC especificado en el header del archivo que se carga.</param>
        /// <param name="mensaje">Un mensaje pasado por referencia, para obtener el mensaje de resultado.</param>
        /// <returns>True si el representante tiene los privilegios suficiente para cargar archivo, de lo contrario retorna False.</returns>
        public bool isRepresentante(ref string mensaje, int nss, string rnc)
        {

            string resultado;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_nss", OracleDbType.Int32);
            arrParam[0].Value = nss;

            arrParam[1] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = rnc;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sre_representantes_pkg.Verifica_Representante", arrParam);
                resultado = arrParam[2].Value.ToString();
                resultado = Utils.sacarMensajeDeError(resultado);
            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            if (resultado.Equals("OK"))
            {
                mensaje = string.Empty;
                return true;
            }
            else
            {
                mensaje = resultado;
                return false;
            }

        }

        /// <summary>
        /// Funcion utilizada para verificar si el nombre del archivo es valido.
        /// </summary>
        /// <param name="fileName">Un cadena con el nombre del archivo cargado.</param>
        /// <returns>True si el nombre del archivo es correcto, de lo contrario retorna false.</returns>
        /// <remarks>Esta funcion es utilizada solo para verificar el nombre de los archivos de los bancos, la cual debe empezar con "DGII-"</remarks>
        public bool esNombreValido()
        {
            if (myNombreAchivo == null) { return false; }

            if (myNombreAchivo.ToUpper().Substring(0, 5).Equals("DGII-"))
            {
                return true;
            }
            else if (myNombreAchivo.ToUpper().Substring(0, 8).Equals("INFOTEP-"))
            {
                return true;
            }

            return false;

        }

        /// <summary>
        /// Funcion utilizada para verificar si el usuario que envia el archivo de los banco tiene permiso para enviarlo
        /// </summary>
        /// <param name="readerArchivo">el archivo que posteo el usuario</param>
        /// <param name="username">el username del usuario que posteo el archivo</param>
        /// <returns>true si el usuario tiene el role especifico para esta tarea y si el usuario tienen asigando la entidad recaudadora para la cual envia, de lo contrario retorna false.</returns>
        public bool esUsuarioPermitidoCargarArchivo(StreamReader readerArchivo, string username)
        {

            if ((readerArchivo == null) || (username == null)) { return false; }
            string entidadRecaudadora = string.Empty;
            this.myResultFile.Position = 0;
            entidadRecaudadora = readerArchivo.ReadLine();
            SuirPlus.Seguridad.Usuario usuario = new SuirPlus.Seguridad.Usuario(username);
            usuario.Roles = new Seguridad.Autorizacion(username).getRoles().Split(new char[] { '|' });


            try
            {
                // RAFAEL: Cambie el substring para iniciara en la posicion 11 anterior mente estaba en la 10

                return ((Convert.ToInt32(entidadRecaudadora.Substring(10, 2).Trim()) == Convert.ToInt32(usuario.IDEntidadRecaudadora)) && (usuario.IsInRole("57")));
            }
            catch
            {
                return false;
            }

        }


        /// <summary>
        /// Funcion utilizada para determinar si el año del periodo es un año menos que el actual.
        /// </summary>
        /// <param name="periodo"></param>
        /// <returns>True si el periodo es un año menor al actual, false de lo contrario</returns>
        public bool esAnioAnterior(string periodo)
        {
            periodo = periodo.Substring(2, 4);
            //DateTime fecha;			
            string compara = Convert.ToString((DateTime.Today.Year - 1));
            if (compara == periodo) return true;

            return false;

        }

        /// <summary>
        /// Funcion utilizada para verificar si el usuario que carga el archivo de Auditoria tiene permiso para hacerlo
        /// </summary>
        /// <param name="username">El username del usuario que carga el archivo</param>
        /// <returns>True o False si el usuario tiene el role para el envio del archivo.</returns>
        public bool esUsuarioPermitidoCargarArchivoAuditoria(string username)
        {

            if (username == null)
                return false;

            SuirPlus.Seguridad.Usuario usuario = new SuirPlus.Seguridad.Usuario(username);
            usuario.Permisos = new Seguridad.Autorizacion(username).getPermisos().Split(new char[] { '|' });
            return usuario.IsInPermiso("116");

        }

        public bool esUsuarioPermitidoCargarArchivoAfiliacion(string username)
        {

            if (username == null)
                return false;

            SuirPlus.Seguridad.Usuario usuario = new SuirPlus.Seguridad.Usuario(username);
            usuario.Permisos = new Seguridad.Autorizacion(username).getPermisos().Split(new char[] { '|' });
            return usuario.IsInPermiso("224");//Permiso en produccion


        }

        void decifrarArchivo(Stream archivo)
        {

            SuirPlus.CryptoHelp.CryptoProgressCallBack cpb = new SuirPlus.CryptoHelp.CryptoProgressCallBack(this.ProgressCallBackDecrypt);

            try
            {
                SuirPlus.CryptoHelp.CryptoHelp.DecryptFile(ref myResultFile, archivo, "elPasx4er3odj1rrelPasx4er3odj1rr", cpb);
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.Message);
                throw new Exception("Error decifrando el archivo. " + ex.Message.ToString());
            }

        }

        /// <summary>
        /// Funcion que se utiliza para saber si el empleador puede enviar un archivo rectificativo para un periodo dado.
        /// </summary>
        /// <param name="rnc">RNC del empleador</param>
        /// <param name="periodo">Periodo del archivo que se esta enviando</param>
        /// <param name="mensaje">Si la funcion retorna false, este contiene un mensaje con la razon del false.</param>
        /// <returns>true o false dependiendo si el empleador puede enviar archivo</returns>
        public bool puedeEnviarRectificativa(ref string mensaje, string rnc, string periodo)
        {
            string retorno;
            string cmdStr = "SRE_PROCESAR_RT_PKG.validar_pagos";
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc.Trim();

            arrParam[1] = new OracleParameter("p_periodo", OracleDbType.NVarchar2, 6);
            arrParam[1].Value = periodo.Trim();

            arrParam[2] = new OracleParameter("p_id_error", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_error_des", OracleDbType.NVarchar2, 1000);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                retorno = arrParam[2].Value.ToString();
                if (Convert.ToInt32(retorno) > 0)
                {
                    mensaje = arrParam[3].Value.ToString();
                    return false;
                }
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return true;

        }

        /// <summary>
        /// Utilizado para verificar si el estatus de cobro de un empleador esta en legal.
        /// </summary>
        /// <returns>True si esta en legal de lo contrario retorna false.</returns>
        /// <remarks>By Ronny Carreras</remarks>
       public static bool isEmpleadorEnLegal(string rnc)
        //public bool isEmpleadorEnLegal(string rnc)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[1].Direction = ParameterDirection.Output;

            bool retorno = false;
            string cmdStr = "sre_empleadores_pkg.IsEmpleadorEnLegal";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

                //Si el retorno es igual a uno..asignamos true
                if (arrParam[1].Value.ToString() == "1")
                    retorno = true;

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }

            return retorno;

        }

        void ProgressCallBackDecrypt(int min, int max, int value, bool done)
        {

            if (done)
            {
                myResultFile.Position = 0;
                StreamReader strReader = new StreamReader(myResultFile, Encoding.UTF8);
                myResultFile.Position = 0;
                readerFile = strReader;
            }

        }




        public static DataTable tipoArchivoDataSource(string username)
        {

            string cmdStr = "SRE_ARCHIVOS_PKG.GetTipoArchivo_Lista";
            DataTable dt = new DataTable();
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 35);
            arrParam[0].Value = username;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw new Exception("Error retornando tipos de procesos " + ex.Message.ToString());
            }

            return dt;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="texto">El texto que será insertado en la primera conluna del datatable.</param>
        /// <param name="valor">El valor que contiene el texto, este será insertado en la segunda columna del datatable.</param>
        /// <param name="dt">El datatable al que se le agregará las filas.</param>
        /// <returns>Un datarow que se utilizará para insertarse en un datatable</returns>
        protected static DataRow CrearFila(string texto, string valor, DataTable dt)
        {
            //Creamos un datarow usando el datatable definido en el metodo tipoArchivoDatasource
            DataRow dr = dt.NewRow();

            //la primera columna del datasource contiene el texto.
            dr[0] = texto;

            //La segunda columna de el datasource contiene el valor
            dr[1] = valor;

            return dr;
        }


        /// <summary>
        /// Metodo utilizado para obtener los 5 ultimos archivos cargados por un empleador.
        /// </summary>
        /// <param name="rnc">RNC del empleador</param>
        /// <returns>Un datatable con la informacion de los ultimos 5 archivos cargados.</returns>
        public static DataTable getLast5Archivos(string rnc)
        {
            OracleParameter[] arrParam = new OracleParameter[2];
            string cmdStr = "SRE_ARCHIVOS_PKG.get_Last_Rreferencia";

            arrParam[0] = new OracleParameter("p_rnc_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc.Trim();

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {

                    return ds.Tables[0];

                }

                return new DataTable("No Hay Data");

            }

            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }



        /// <summary>
        /// Metodo utilizado para obtener los 5 ultimos archivos cargados por el depto. de auditoria.
        /// </summary>
        /// <returns>Un datatable con la informacion de los ultimos 5 archivos cargados.</returns>
        public static DataTable getLast5ArchivosAuditoria()
        {
            OracleParameter[] arrParam = new OracleParameter[1];
            string cmdStr = "SRE_ARCHIVOS_PKG.get_Last_Rreferencia";

            arrParam[0] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {

                    return ds.Tables[0];

                }

                return new DataTable("No Hay Data");

            }

            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        /// <summary>
        /// Utilizado para extraer el detalle de la consulta de envio de archivos.
        /// </summary>
        /// <param name="idReferencia">El idReferencia del archivo que se desea consultar.</param>
        /// <returns>Un datatable con el detalle del archivo.</returns>
        public static DataTable getArchivoDetalle(int idReferencia)
        {
            OracleParameter[] arrParam = new OracleParameter[2];
            string cmdStr = "SRE_ARCHIVOS_PKG.get_Detalle_Archivo";

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = idReferencia;

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
        }

        //Metodo para paginacion
        //Creado por Gregorio Herrera
        public static DataTable getArchivoDetalle(int idReferencia, int pageNum, Int16 pageSize)
        {
            DataTable dt;

            OracleParameter[] arrParam = new OracleParameter[4];
            string cmdStr = "SRE_ARCHIVOS_PKG.getPage_Detalle_Archivo";

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = idReferencia;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            try
            {
                dt = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return dt;
        }

        /// <summary>
        /// get_PageDetArchivoAuditoria
        /// Metodo utilizado para mostrar el detalle de un archivo de auditoría paginado
        /// </summary>
        /// <param name="idReferencia"></param>
        /// <param name="pageNum"></param>
        /// <param name="pageSize"></param>
        /// Creado por Charlie L. Peña
        /// <returns></returns>
        public static DataTable get_PageDetArchivoAuditoria(int idReferencia, int pageNum, Int16 pageSize)
        {

            OracleParameter[] arrParam = new OracleParameter[4];


            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = idReferencia;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "SRE_ARCHIVOS_PKG.get_PageDetArchivoAuditoria";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (ds.Tables.Count > 0)
                {

                    return ds.Tables[0];

                }

                return new DataTable("No Hay Data");

            }

            catch (Exception ex)
            {

                Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }

        }
        //-------------------------------

        /// <summary>
        /// Utilizado para extraer el detalle de la consulta de envio de archivos de auditoria.
        /// </summary>
        /// <param name="idReferencia">El idReferencia del archivo que se desea consultar.</param>
        /// <returns>Un datatable con el detalle del archivo.</returns>
        public static DataTable getArchivoDetalleAuditoria(int idReferencia)
        {
            OracleParameter[] arrParam = new OracleParameter[2];
            string cmdStr = "SRE_ARCHIVOS_PKG.get_Detalle_Archivo_Auditoria";

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = idReferencia;

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
        }


        public static DataTable getInfoArchivoAuditoria(int idReferencia)
        {

            OracleParameter[] arrParam = new OracleParameter[3];
            string cmdStr = "SRE_ARCHIVOS_PKG.get_Info_Archivo_Auditoria";
            string resultado;
            DataTable dtArchivo;

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = idReferencia;

            arrParam[1] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {
                dtArchivo = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                resultado = arrParam[1].Value.ToString();
                if (!Utilitarios.Utils.sacarMensajeDeError(resultado).Equals("OK"))
                {
                    throw new Exception(Utilitarios.Utils.sacarMensajeDeError(resultado));
                }
            }

            return dtArchivo;
        }


        public static DataTable getArchivosPaginados(int IdRecepcion, string Tipo, DateTime? FechaDesde, DateTime? FechaHasta, int pageSize, int pageNum)
        {

            OracleParameter[] arrParam;
            String cmdStr = "SRE_ARCHIVOS_PKG.GetArchivosPage";
            string result = null;
            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("P_id_recepcion", OracleDbType.Double, 10);
            if (IdRecepcion != 0)
            {
                arrParam[0].Value = IdRecepcion;
            }
            else
            {
                arrParam[0].Value = DBNull.Value;
            }

            arrParam[1] = new OracleParameter("P_Tipo_Archivo", OracleDbType.NVarchar2, 2);
            if (Tipo != "0")
            {
                arrParam[1].Value = Tipo;
            }
            else
            {
                arrParam[1].Value = DBNull.Value;
            }



            arrParam[2] = new OracleParameter("P_Fecha_Desde", OracleDbType.Date);
            if (FechaDesde != null)
            {
                arrParam[2].Value = FechaDesde;
            }
            else
            {
                arrParam[2].Value = DBNull.Value;
            }

            arrParam[3] = new OracleParameter("P_Fecha_Hasta", OracleDbType.Date);
            if (FechaHasta != null)
            {
                arrParam[3].Value = FechaHasta;
            }
            else
            {
                arrParam[3].Value = DBNull.Value;
            }


            arrParam[4] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[4].Value = pageNum;

            arrParam[5] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[5].Value = pageSize;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[7].Direction = ParameterDirection.Output;

            try
            {
                //Ejecuamos el commando.
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                result = arrParam[6].Value.ToString();

                //Si el resultado es diferente de 0, entonces agregamos el error en el datatable para retornarlo.
                //de los contratario asignamos el datatable que viene en el dataset.
                if (result != "0")
                {
                    Utilitarios.Utils.agregarMensajeError(result, ref dt);
                }
                else
                {
                    return ds.Tables[0];
                }

                return new DataTable("No Hay Data");
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }


        }

        public static Byte[] getArchivoVS(int IdArchivo)
        {
            byte[] img = null;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_recepcion", OracleDbType.Int32);
            arrParam[0].Value = IdArchivo;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_io_cursor", OracleDbType.Blob);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "sre_archivos_pkg.getarchivovs";

            try
            {

                using (OracleConnection oConn = new OracleConnection(OracleHelper.getConnString()))
                {
                    using (OracleCommand oCommand = new OracleCommand())
                    {
                        oConn.Open();
                        oCommand.Connection = oConn;
                        oCommand.CommandType = CommandType.StoredProcedure;
                        oCommand.CommandText = cmdStr;
                        oCommand.Parameters.AddRange(arrParam);

                        int Resultado = oCommand.ExecuteNonQuery();

                        string result = arrParam[1].Value.ToString();

                        if (result == "0")
                        {

                            Oracle.ManagedDataAccess.Types.OracleBlob blob = (Oracle.ManagedDataAccess.Types.OracleBlob)arrParam[2].Value;

                            img = blob.Value;

                        }

                        oCommand.Connection.Close();

                    }
                }

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }

            return img;

        }

        public static string ProcesarArchivoOficio(string nombre_archivo, Stream dataArchivo, string IPAddress)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_Nombre_archivo", OracleDbType.NVarchar2, 100);
            arrParam[0].Value = nombre_archivo;

            arrParam[1] = new OracleParameter("p_id_tipo_movimiento", OracleDbType.NVarchar2, 100);
            arrParam[1].Value = "ACU";

            arrParam[2] = new OracleParameter("p_Id_recepcion", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_Nombre_almacenamiento", OracleDbType.NVarchar2, 100);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[4].Value = IPAddress;

            arrParam[5] = new OracleParameter("p_Msg_error", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SRE_ARCHIVOS_PKG.sre_recepcion_de_archivos_p", arrParam);
            }
            catch (OracleException oracleEx)
            {
                throw oracleEx;
            }
            catch (Exception ex)
            {
                throw ex;
            }

            var ArchivoGenerado = arrParam[3].Value.ToString();
            string ruta = string.Empty;

            SuirPlus.Config.Configuracion arch = new SuirPlus.Config.Configuracion(Config.ModuloEnum.ArchivosSuir);
            ruta = arch.FTPDir + ArchivoGenerado + ".txt";


            FileStream fs = new FileStream(ruta, FileMode.CreateNew, FileAccess.Write);
            byte[] data = new byte[2048];
            dataArchivo.Position = 0;
            int size = 0;

            StringBuilder sb = new StringBuilder();

            try
            {
                while (true)
                {
                    size = dataArchivo.Read(data, 0, data.Length);
                    if (size > 0)
                    {
                        fs.Write(data, 0, size);
                        //sb.Append("S:" + size.ToString() + "|" + "D:" + data.Length + "|");
                    }
                    else
                    {	//throw new Exception(sb.ToString());					
                        break;
                    }

                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            finally
            {
                fs.Flush();
                fs.Close();
                fs = null;
                dataArchivo = null;

            }

            return ArchivoGenerado;

        }


        #endregion

        #region "Seccion de metodos utilizados para grabar y mandar a procesar el archivo"

        /// <summary>
        /// Procedimiento utilizado para guardar el archivo posteado.
        /// </summary>
        /// <param name="archivo">ub objeto HttpPosted file, que representa el archivo posteado.</param>
        public void GuardarArchivo(Stream archivo, SuirArchivoType tipoArchivo, string IPAddress)
        {
            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_Nombre_archivo", OracleDbType.NVarchar2, 100);
            arrParam[0].Value = myNombreAchivo;
            arrParam[1] = new OracleParameter("p_id_tipo_movimiento", OracleDbType.NVarchar2, 100);
            if (tipoArchivo == SuirArchivoType.NovedadesPensionados)
            { arrParam[1].Value = "PN"; }
            else if (tipoArchivo == SuirArchivoType.TraspasoPensionados)
            { arrParam[1].Value = "PT"; }
            else if (tipoArchivo == SuirArchivoType.ValidacionRegimenSubsidiado)
            { arrParam[1].Value = "VS"; }
            else if (tipoArchivo == SuirArchivoType.PagoRetroactivoEnfermedadNoLaboral)
            { arrParam[1].Value = "PRE"; }

            else
            {
                arrParam[1].Value = DBNull.Value;
            }
            arrParam[2] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[2].Value = IPAddress;
            arrParam[3] = new OracleParameter("p_Id_recepcion", OracleDbType.Int32);
            arrParam[3].Direction = ParameterDirection.Output;
            arrParam[4] = new OracleParameter("p_Nombre_almacenamiento", OracleDbType.NVarchar2, 100);
            arrParam[4].Direction = ParameterDirection.Output;
            arrParam[5] = new OracleParameter("p_Msg_error", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SRE_ARCHIVOS_PKG.sre_recepcion_de_archivos_p", arrParam);
            }
            catch (OracleException oracleEx)
            {
                throw oracleEx;
            }
            catch (Exception ex)
            {
                throw ex;
            }

            myNumero = Int32.Parse(arrParam[3].Value.ToString());
            myNombreArchivoGenerado = arrParam[4].Value.ToString();
            string ruta = string.Empty;

            SuirPlus.Config.Configuracion arch = new SuirPlus.Config.Configuracion(Config.ModuloEnum.ArchivosSuir);

            if (tipoArchivo != SuirArchivoType.NovedadesPensionados)
            {
                // ["FOLDER_ARCHIVOS_SUIR"] 
                ruta = arch.FTPDir + myNombreArchivoGenerado;

            }
            else
            {
                // ["FOLDER_ARCHIVOS_PENSIONADOS"]
                ruta = arch.Archives_OK_DIR + myNombreArchivoGenerado;
            }

            FileStream fs = new FileStream(ruta, FileMode.CreateNew, FileAccess.Write);
            byte[] data = new byte[2048];
            archivo.Position = 0;
            int size = 0;

         //   StringBuilder sb = new StringBuilder();

            try
            {
                while (true)
                {
                    size = archivo.Read(data, 0, data.Length);
                    if (size > 0)
                    {
                        fs.Write(data, 0, size);
                        //sb.Append("S:" + size.ToString() + "|" + "D:" + data.Length + "|");
                    }
                    else
                    {	//throw new Exception(sb.ToString());					
                        break;
                    }

                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

            finally
            {
                fs.Flush();
                fs.Close();
                fs = null;
                archivo = null;
            }


            if (tipoArchivo != SuirArchivoType.NovedadesPensionados)
            {
                CargarArchivoABasedeDatos();
            }
            else
            {
                CargarArchivoABasedeDatosPen();

            }



        }

        public void GuardarArchivo(StreamReader archivo, string IPAddress)
        {

            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_Nombre_archivo", OracleDbType.NVarchar2, 100);
            arrParam[0].Value = myNombreAchivo;

            arrParam[1] = new OracleParameter("p_id_tipo_movimiento", OracleDbType.NVarchar2, 100);
            arrParam[1].Value = DBNull.Value;

            arrParam[2] = new OracleParameter("p_IPAddress", OracleDbType.NVarchar2, 16);
            arrParam[2].Value = IPAddress;

            arrParam[3] = new OracleParameter("p_Id_recepcion", OracleDbType.Int32);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_Nombre_almacenamiento", OracleDbType.NVarchar2, 100);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_Msg_error", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "SRE_ARCHIVOS_PKG.sre_recepcion_de_archivos_p", arrParam);
            }
            catch (OracleException oracleEx)
            {
                throw oracleEx;
            }
            catch (Exception ex)
            {
                throw ex;
            }

            this.myNumero = Convert.ToInt32(arrParam[3].Value.ToString());
            this.myNombreArchivoGenerado = arrParam[4].Value.ToString();

            try
            {

                //  ["FOLDER_ARCHIVOS_SUIR"] 
                SuirPlus.Config.Configuracion arch = new SuirPlus.Config.Configuracion(Config.ModuloEnum.ArchivosSuir);
                System.IO.FileStream writer = System.IO.File.OpenWrite(arch.FTPDir + myNombreArchivoGenerado);
                byte[] data = this.myResultFile.ToArray();
                writer.Write(data, 0, data.Length);
                writer.Flush();
                writer.Close();

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.Message);
                throw new Exception("Error grabando el archivo. " + ex.Message.ToString());
            }

            CargarArchivoABasedeDatos();

        }


        /// <summary>
        /// Procedimiento utilizado para cargar el archivo a la tabla SRE_ARCHIVOS_T.
        /// </summary>
        public void CargarArchivoABasedeDatos()
        {
            //estoy aqui			
            string cmdStr = "SRE_ARCHIVOS_PKG.Cargar_Archivo";
            string resultado = string.Empty;

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = this.myNumero;

            arrParam[1] = new OracleParameter("p_usuario_carga", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = this.username;

            arrParam[2] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {

                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                resultado = Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }

            if (!(resultado).Equals("OK"))
            {
                throw new Exception(resultado);
            }
        }

        public void CargarArchivoABasedeDatosPen()
        {

            string cmdStr = "SRE_ARCHIVOS_PKG.Cargar_Archivo_Pen";
            string resultado = string.Empty;

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_referencia", OracleDbType.Int32);
            arrParam[0].Value = this.myNumero;

            arrParam[1] = new OracleParameter("p_usuario_carga", OracleDbType.NVarchar2, 35);
            arrParam[1].Value = this.username;

            arrParam[2] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            try
            {

                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                resultado = Utilitarios.Utils.sacarMensajeDeError(arrParam[2].Value.ToString());

            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.Message);
                throw ex;
            }

            if (!(resultado).Equals("OK"))
            {
                throw new Exception(resultado);
            }
        }




        public static string isPagaDiscapacidad(int id_registro_patronal)
        {
            OracleParameter[] arrParam;
            String cmdStr = "SRE_PROCESAR_PR_PKG.isPagaDiscapacidad";

            DataTable dt = new DataTable();

            //Definimos nuestro arreglo de parametros.
            arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = id_registro_patronal;


            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;


            string result = string.Empty;
            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();

                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }




        //*******************
        public static DataTable getArchivo(int nroEnvio)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nroenvio", OracleDbType.Int32);
            arrParam[0].Value = nroEnvio;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "SRE_ARCHIVOS_PKG.getArchivo";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static string GuardarDocCertificacion(int nro_solicitud, int id_requisito, Stream  p_documento)
            {

                OracleParameter[] arrParam = new OracleParameter[4];

                arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2, 100);
                arrParam[0].Value = nro_solicitud;

                arrParam[1] = new OracleParameter("p_requisito", OracleDbType.NVarchar2, 100);
                arrParam[1].Value = id_requisito;

                arrParam[2] = new OracleParameter("p_documento", OracleDbType.Clob);
                arrParam[2].Value = p_documento;

                arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
                arrParam[3].Direction = ParameterDirection.Output;

                
                string result = string.Empty;
                try
                {
                    OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.InsertarDocs", arrParam);
                    result = arrParam[3].Value.ToString();
                    if (result != "0")
                    {
                        throw new Exception(arrParam[3].Value.ToString());
                        return result;
                    }
                    else
                    {
                        return null;
                    }
                }
                catch (Exception ex)
                {
                    throw ex;
                }           

            
            }
       
        #endregion


        

    }
}
