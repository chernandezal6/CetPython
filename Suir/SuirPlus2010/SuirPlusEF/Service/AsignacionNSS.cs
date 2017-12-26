using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using System;
using System.Data;
using System.Linq;
using SuirPlusEF.Framework;
using System.Collections.Generic;

namespace SuirPlusEF.Service
{
    public class AsignacionNSS
    {
        protected ServiceResult ServiceResult {get;set;}
        private TipoAsignacionEnum myTipoAsignacionEnum { get; set; }
        protected Repositories.HistoricoDocumentoRepository _RepHis;
        //protected Repositories.ExtranjeroMIPRepository _RepExtranjeroMIP;
        protected Repositories.CiudadanoRepository _RepCiu;
        protected ServEvaluacionVisual servEvaluacionVisual;

        public AsignacionNSS(){}

        public AsignacionNSS(TipoAsignacionEnum tipo) {
            this.myTipoAsignacionEnum = tipo;
            
            this.ServiceResult = new ServiceResult();
            this.ServiceResult.ServiceExecuted = true;
            
             _RepCiu = new Repositories.CiudadanoRepository();
            servEvaluacionVisual = new ServEvaluacionVisual();
             
        }
        //Cedula
        public ServiceResult ProcesarCedulaValidaciones(DocumentoCedula doc){
            
            return ServiceResult;
        }
        public ServiceResult ProcesarCedulaEvaluacionVisualValidaciones(DocumentoCedula doc){            
            if (servEvaluacionVisual.CEDEstaEncola(doc))
            {
               Console.WriteLine($"La cedula {doc.NumeroConGuiones()} ya existe en la cola de Evaluacion Visual");
               ServiceResult.AddErrorMessage($"La cedula {doc.NumeroConGuiones()} ya existe en la cola de Evaluacion Visual"); 
               ServiceResult.ServiceExecuted = true;
                return ServiceResult;
            }
            ServiceResult.ServiceExecuted = false;
            return ServiceResult;
        }        
        //public ServiceResult ProcesarCedulaCoincidencias(DocumentoCedula doc, Ciudadano ciu, ref RespuestaSerCoincidenciasCuidadano res, ref IList<Ciudadano> coincidencias ){
            
        //    Console.WriteLine($"Entre a buscar coincidencias");
        //    // Servicio de Buscar las coincidencias
        //    ConincidenciasCuidadano coincidenciasCiu = new ConincidenciasCuidadano();            
        //    coincidencias = coincidenciasCiu.Procesar(ciu,ref res);
        //    Console.WriteLine($"salí a buscar coincidencias");
        //    ServiceResult.ServiceExecuted = true;
        //    ServiceResult.AddMessage($"Se ejecutó la busqueda de coincidiencias, este es el resultado: {res.ToString()}.");
        //    return ServiceResult;
        //}
        //ProcesarCedula
        public ServiceResult ProcesarCedula(int idSolicitud,DocumentoCedula doc, ref RespuestaSerAsignacionNSSEnum respuesta, ref DocumentoNSS nss) { 
            // Confirmar si existe o no en Ciudadanos
            int existe = 0;
            Ciudadano ciu = _RepCiu.GetByNroDocumento(doc.NumeroSinGuiones(),"C",ref existe);
            Console.WriteLine($"Se encuentra en ciudadano? {doc.NumeroSinGuiones()}={existe}");
            if (existe > 0)
            {
                //Si ya existe en Ciudadanos, solo queda devolver el NSS.
                nss = new DocumentoNSS(ciu.IdNSS.ToString());
                respuesta = RespuestaSerAsignacionNSSEnum.NSSExiste;

                ServiceResult.ServiceExecuted = true;
                ServiceResult.AddMessage($"La cedula {doc.NumeroConGuiones()} ya tiene el NSS {ciu.IdNSS} asignado.");
                
                return ServiceResult;
            }
            else
            {
                ServiceResult.AddMessage("No existe en la tabla de Ciudadanos. Se va a buscar en la cola de evaluacion visual");
                Console.WriteLine("No existe en la tabla de Ciudadanos. Se va a buscar en la cola de evaluacion visual");
                this.ProcesarCedulaEvaluacionVisualValidaciones(doc);
                Console.WriteLine($"El ciudadano esta en cola? {ServiceResult.ServiceExecuted}");
                if (ServiceResult.ServiceExecuted)
                {
                    nss = null;
                    respuesta = RespuestaSerAsignacionNSSEnum.ExisteEvaluacionVisual;
                    return ServiceResult;
                }

                ServiceResult.AddMessage("El ciudadano no existe en la cola de evaluacion visual. Se va a buscar en el WS de la JCE");
                Console.WriteLine("El ciudadano no existe en la cola de evaluacion visual. Se va a buscar en el WS de la JCE");
                //Buscar en el WS de la JCE

                WebServiceCedula wsCED = new WebServiceCedula();
                    WebServiceCedulaModel wsCEDModel = new WebServiceCedulaModel();
                    var wsServiceResult = wsCED.ConsultaByCedula(doc, ref wsCEDModel);
                    
                    if (!wsServiceResult.ServiceExecuted){
                       if (wsServiceResult.Exception != null){
                           ServiceResult.Exception = wsServiceResult.Exception;
                       }
                       ServiceResult.AddErrorMessages(wsServiceResult.MessagesList.ToList());
                       return ServiceResult; 
                    }
                    
                    if (!wsCED.MatchFound){
                        ServiceResult.AddErrorMessage($"La cedula {doc.NumeroConGuiones()} no se encuentra en nuestra base de datos ni en el webservice de la JCE.");
                        Console.WriteLine($"La cedula {doc.NumeroConGuiones()} no se encuentra en nuestra base de datos ni en el webservice de la JCE.");
                        nss = null;
                        respuesta = RespuestaSerAsignacionNSSEnum.DocumentoNoEncontrado;
                        return ServiceResult;
                    }

                    //Si esta en el WS de la JCE
                    ciu = wsCEDModel.CiudadanoModel;
                    
                    ServiceResult.AddMessage($"El ciudadano se encuentra en la JCE con la Cedula {ciu.NroDocumento}");
                    Console.WriteLine($"El ciudadano se encuentra en la JCE con la Cedula {ciu.NroDocumento}");

                RespuestaSerCoincidenciasCuidadano res = new RespuestaSerCoincidenciasCuidadano();
                IList<Ciudadano> coincidencias = null;
                //this.ProcesarCedulaCoincidencias(doc, ciu, ref res, ref coincidencias);
                Console.WriteLine($"respuesta de las coincidencias {res}");
                switch (res)
                    {
                        case RespuestaSerCoincidenciasCuidadano.SeEncontraronCoincidencias:
                        // Mandar a Evaluacion Visual
                        servEvaluacionVisual.EnviarCola(idSolicitud,ciu, coincidencias);
                            nss = null;
                            respuesta = RespuestaSerAsignacionNSSEnum.EnviadoEvaluacionVisual;
                            return ServiceResult;

                        case RespuestaSerCoincidenciasCuidadano.NoSeEncontraronCoincidencias:
                            // Mandar a Insertar en Ciudadanos y devolver NSS
                            _RepCiu.Insertar(ref ciu);
                            nss = ciu.DocumentoNSS;
                            respuesta = RespuestaSerAsignacionNSSEnum.NSSAsignado;
                            return ServiceResult;

                        //case RespuestaSerCoincidenciasCuidadano.SeEncontroUnaCoincidenciaExacta:
                        //    _RepCiu.Actualizar(coincidencias.First(), ref ciu);

                        //    nss = ciu.DocumentoNSS;
                        //    respuesta = RespuestaSerAsignacionNSSEnum.NSSActualizado;
                        //    return ServiceResult;

                        default:
                            break;
                    }

                }
                return ServiceResult;
            }

        //NUI
        public ServiceResult ProcesarNUIValidaciones(DocumentoNUI doc)
        {
            return ServiceResult;
        }
        public ServiceResult ProcesarNUIEvaluacionVisualValidaciones(DocumentoNUI doc)
        {
            if (servEvaluacionVisual.NUIEstaEnCola(doc))
            {
                ServiceResult.AddErrorMessage($"El NUI {doc.NumeroConGuiones()} ya existe en la cola de Evaluacion Visual");
                ServiceResult.ServiceExecuted = true;
                return ServiceResult;
            }
            ServiceResult.ServiceExecuted = false;
            return ServiceResult;
        }
        //public ServiceResult ProcesarNUICoincidencias(DocumentoNUI doc, Ciudadano ciu, ref RespuestaSerCoincidenciasCuidadano res, ref IList<Ciudadano> coincidencias)
        //{
        //    // Servicio de Buscar las coincidencias
        //    Console.WriteLine($"Entre a buscar coincidencias");
        //    // Servicio de Buscar las coincidencias
        //    ConincidenciasCuidadano coincidenciasCiu = new ConincidenciasCuidadano();
        //    coincidencias = coincidenciasCiu.Procesar(ciu, ref res);
        //    Console.WriteLine($"salí a buscar coincidencias");
        //    ServiceResult.ServiceExecuted = true;
        //    ServiceResult.AddMessage($"Se ejecutó la busqueda de coincidiencias, este es el resultado: {res.ToString()}.");
        //    return ServiceResult;
        //}

        //ProcesarNUI
        public ServiceResult ProcesarNUI(int idSolicitud, DocumentoNUI doc, ref RespuestaSerAsignacionNSSEnum respuesta, ref DocumentoNSS nss)
        {
            // Confirmar si existe o no en Ciudadanos
            int existe = 0;
            Ciudadano ciu = _RepCiu.GetByNroDocumento(doc.NumeroSinGuiones(),"U", ref existe);
            Console.WriteLine($"El NUI Se encuentra en ciudadano? {doc.NumeroSinGuiones()}={existe}");
            if (existe > 0)
            {
                //Si ya existe en Ciudadanos, solo queda devolver el NSS.
                nss = new DocumentoNSS(ciu.IdNSS.ToString());
                respuesta = RespuestaSerAsignacionNSSEnum.NSSExiste;

                ServiceResult.ServiceExecuted = true;
                ServiceResult.AddMessage($"El NUI {doc.NumeroConGuiones()} ya tiene el NSS {ciu.IdNSS} asignado.");

                return ServiceResult;
            }
            else
            {
                ServiceResult.AddMessage("No existe en la tabla de Ciudadanos. Se va a buscar en la cola de evaluacion visual");
                Console.WriteLine("No existe en la tabla de Ciudadanos. Se va a buscar en la cola de evaluacion visual");
                this.ProcesarNUIEvaluacionVisualValidaciones(doc);
                Console.WriteLine($"El ciudadano NUI esta en cola? {ServiceResult.ServiceExecuted}");
                if (ServiceResult.ServiceExecuted)
                {
                    nss = null;
                    respuesta = RespuestaSerAsignacionNSSEnum.ExisteEvaluacionVisual;
                    return ServiceResult;
                }

                ServiceResult.AddMessage("El ciudadano no existe en la cola de evaluacion visual. Se va a buscar en el WS-NUI de la JCE");
                Console.WriteLine("El ciudadano no existe en la cola de evaluacion visual. Se va a buscar en el WS-NUI de la JCE");

                //Buscar en el WS de la JCE
                WebServiceNUI wsNUI = new WebServiceNUI();
                WebServiceNUIModel wsNUIModel = new WebServiceNUIModel();
                var wsServiceResult = wsNUI.ConsultaByNUI(doc, ref wsNUIModel);

                if (!wsServiceResult.ServiceExecuted)
                {
                    if (wsServiceResult.Exception != null)
                    {
                        ServiceResult.Exception = wsServiceResult.Exception;
                    }
                    ServiceResult.AddErrorMessages(wsServiceResult.MessagesList.ToList());
                    return ServiceResult;
                }

                if (!wsNUI.MatchFound)
                {
                    ServiceResult.AddErrorMessage($"El NUI {doc.NumeroConGuiones()} no se encuentra en nuestra base de datos ni en el webservice de la JCE.");
                    Console.WriteLine($"El NUI {doc.NumeroConGuiones()} no se encuentra en nuestra base de datos ni en el webservice de la JCE.");
                    nss = null;
                    respuesta = RespuestaSerAsignacionNSSEnum.DocumentoNoEncontrado;
                    return ServiceResult;
                }

                //Si esta en el WS de la JCE
                ciu = wsNUIModel.CiudadanoModel;

                ServiceResult.AddMessage($"El ciudadano se encuentra en la JCE con el NUI {ciu.NroDocumento}");
                Console.WriteLine($"El ciudadano se encuentra en la JCE con el NUI {ciu.NroDocumento}");

                RespuestaSerCoincidenciasCuidadano res = new RespuestaSerCoincidenciasCuidadano();
                IList<Ciudadano> coincidencias = null;
                //this.ProcesarNUICoincidencias(doc, ciu, ref res, ref coincidencias);
                Console.WriteLine($"respuesta de las coincidencias {res}");
                switch (res)
                {
                    case RespuestaSerCoincidenciasCuidadano.SeEncontraronCoincidencias:
                        // Mandar a Evaluacion Visual
                        servEvaluacionVisual.EnviarCola(idSolicitud, ciu, coincidencias);
                        nss = null;
                        respuesta = RespuestaSerAsignacionNSSEnum.EnviadoEvaluacionVisual;
                        return ServiceResult;

                    case RespuestaSerCoincidenciasCuidadano.NoSeEncontraronCoincidencias:
                        // Mandar a Insertar en Ciudadanos y devolver NSS
                        _RepCiu.Insertar(ref ciu);
                        nss = ciu.DocumentoNSS;
                        respuesta = RespuestaSerAsignacionNSSEnum.NSSAsignado;
                        return ServiceResult;

                    //case RespuestaSerCoincidenciasCuidadano.SeEncontroUnaCoincidenciaExacta:
                    //    // Mandar a actualizar en Ciudadanos y devolver NSS
                    //    _RepCiu.Actualizar(coincidencias.First(), ref ciu);
                    //    nss = ciu.DocumentoNSS;
                    //    respuesta = RespuestaSerAsignacionNSSEnum.NSSActualizado;
                    //    return ServiceResult;

                    default:
                        break;
                }

            }
            return ServiceResult;
        }

        //Extanjeros
        public ServiceResult ProcesarExtranjerosEV_Validaciones(string NroExpediente)
        {

            if (servEvaluacionVisual.ExpedienteEstaEnCola(NroExpediente))
            {
                ServiceResult.AddErrorMessage($"El Nro. de expediente {NroExpediente} ya existe en la cola de Evaluacion Visual");
                ServiceResult.ServiceExecuted = false;
            }

            return ServiceResult;
        }
        public ServiceResult ProcesarExtranjeros_PonerEnCola(DetalleSolicitudes detGeneralNSS) {

            //poner en cola
            var result = servEvaluacionVisual.EnviarColaExtranjero(detGeneralNSS);

            return ServiceResult;
        }
        //ProcesarExtranjeros
        //public ServiceResult ProcesarExtranjeros(DetalleSolicitudes detGeneralNSS, ref RespuestaSerAsignacionNSSEnum respuesta, ref DocumentoNSS nss)
        //{
        //    // Confirmar si existe o no en el historico de documentos
        //    int existe = 0;
        //    HistoricoDocumento his = _RepHis.GetByNroExpediente(detGeneralNSS.Documento, detGeneralNSS.IdTipoDocumento, ref existe);

        //    if (existe > 0)
        //    {
        //        //Si ya existe en el historico de documentos con el mismo tipoDocumento, solo queda devolver el NSS.
        //        nss = new DocumentoNSS(his.IdNSS.ToString());
        //        respuesta = RespuestaSerAsignacionNSSEnum.NSSExiste;

        //        ServiceResult.ServiceExecuted = true;
        //        ServiceResult.AddMessage($"El nro. de expediente {detGeneralNSS.Documento} ya tiene el NSS {his.IdNSS} asignado.");

        //        return ServiceResult;
        //    }
        //    else
        //    {
        //        ServiceResult.AddMessage("No existe en la tabla de historico de documentos. Se va a buscar en la tabla de extranjeros del MIP");
        //        ExtranjeroMIP ext = _RepExtranjeroMIP.GetByNroExpediente(detGeneralNSS.Documento, ref existe);
        //        if (existe > 0)
        //        {
        //            //se verifica si esta en cola de evaluacion visual
        //            this.ProcesarExtranjerosEV_Validaciones(detGeneralNSS.Documento);
        //            //si esta en cola se termina el flujo y se da respuesta
        //            if (!ServiceResult.ServiceExecuted)
        //            {
        //                nss = null;
        //                respuesta = RespuestaSerAsignacionNSSEnum.ExisteEvaluacionVisual;
        //                return ServiceResult;
        //            }
        //            else
        //            {
        //            //si no esta en cola, se inserta en evaluacion visual
        //                this.ProcesarExtranjeros_PonerEnCola(detGeneralNSS);
        //                nss = null;
        //                respuesta = RespuestaSerAsignacionNSSEnum.EnviadoEvaluacionVisual;
        //                return ServiceResult;
        //            }
        //        }
        //        else
        //        {
        //            //si no existe se debe terminar el fluejo, acutalizar la solicitud y dar una respuesta
        //            nss = null;
        //            respuesta = RespuestaSerAsignacionNSSEnum.DocumentoNoEncontrado;
        //            return ServiceResult;
        //        }

        //    }

        //}
        //

        /// <summary>
        /// Nuevo metodo para procesar las solicitudes de asignacion de extranjero, interactuando con la base de datos
        /// </summary>
        /// <param name="solicitud"></param>
        /// <param name="usurName"></param>
        /// <returns></returns>
        public void ProcesarSolicitud(int solicitud, string userName)
        {
            //parametros de entrada
            Oracle.ManagedDataAccess.Client.OracleParameter p_solicitud = new Oracle.ManagedDataAccess.Client.OracleParameter();
            p_solicitud.ParameterName = "p_id_solicitud";
            p_solicitud.Value = solicitud;
            p_solicitud.Direction = System.Data.ParameterDirection.Input;
            p_solicitud.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Int32;
          
            Oracle.ManagedDataAccess.Client.OracleParameter p_userName = new Oracle.ManagedDataAccess.Client.OracleParameter();
            p_userName.ParameterName = "p_ult_usuario_act";
            p_userName.Value = userName;
            p_userName.Direction = System.Data.ParameterDirection.Input;
            p_userName.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2;

            //parametro de salida
            Oracle.ManagedDataAccess.Client.OracleParameter p_resultado = new Oracle.ManagedDataAccess.Client.OracleParameter();
            p_resultado.ParameterName = "p_resultado";
            p_resultado.Direction = System.Data.ParameterDirection.Output;
            p_resultado.OracleDbType = Oracle.ManagedDataAccess.Client.OracleDbType.Varchar2;
            p_resultado.Size = 500;


            OracleDbContext db = new OracleDbContext();
            db.Database.ExecuteSqlCommand("begin NSS_VALIDAR_SOLICITUD(:p_id_solicitud,:p_ult_usuario_act,:p_resultado); end;", p_solicitud, p_userName, p_resultado);

            if (p_resultado.Value.ToString() == "OK")
            {
                Console.WriteLine("Solicitud procesada exitosamente!" );
            }
            else
            {
                Console.WriteLine("Error al ejecutar el proceso " +  p_resultado.Value.ToString());            
            }                      
           
        }

        public enum TipoAsignacionEnum {

                AsignacionNSS = 1,
                ActualizacionDatos = 2
            }

        public enum RespuestaSerAsignacionNSSEnum {
                NSSAsignado = 1,
                NSSActualizado = 2,
                NSSExiste = 3,
                EnviadoEvaluacionVisual = 4,
                ExisteEvaluacionVisual = 5,
                DocumentoNoEncontrado = 6
            }

        public enum EstatusSolicitudNSSEnum
        {
            Pendiente = 1,
            NSS_Asignado = 2,
            NSS_Existe = 3,
            Registro_Enviado_a_Evaluacion_Visual = 4,
            Numero_de_Documento_no_Encontrado = 5,
            Registro_Rechazado = 6,
            Registro_Actualizado = 7
        }
    }
}
