using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;
using SuirPlus.DataBase;
using System.IO;
using System.Globalization;

namespace SuirPlus.SolicitudesEnLinea
{

    public class Solicitudes : SuirPlus.FrameWork.Objetos
    {
        #region Propiedades

        private int myIdSolicitud;
        private int myIdTipoSolicitud;
        private string myTipoSolicitud;
        private int myIdStatus;
        private string myStatus;
        private int myIdOficinaEntrega;
        private string myOficinaEntrega;
        private string myRNC;
        private string myRepresentante;
        private string myRepresentanteNombre;
        private string myOperador;
        private string myOperadorNombre;
        private string myComentarios;
        private string myInfoSolicitud;
        private DateTime myFechaRegistro;
        private DateTime myFechaCierre = DateTime.MinValue;
        private string myUltUsuarioModifico;
        private string myUltUsuarioModificoNombre;
        private string myEntregadoA;
        private DateTime myFechaEntrega;
        private string myNombreComercial;
        private string myFax;
        private string myRazonSocial;
        private string myEmailRepresentante;
        private string myTelefono1;
        private string myTelefono2;

        private string mySolicitante;
        private string mySolicitanteInstitucion;
        private string mySolicitanteInformacion;
        private string mySolicitanteMotivo;
        private string mySolicitanteDireccion;
        private string mySolicitanteCelular;
        private string mySolicitanteFax;
        private string mySolicitanteEmail;
        private string mySolicitanteAutoridad;
        private string mySolicitanteMedio;
        private string mySolicitanteLugar;
        private string mySolicitanteCargo;
        private string mySolicitanteCedula;

        private structCancelacion myCancelacion;

        public structCancelacion Cancelacion
        {
            get { return this.myCancelacion; }
        }


        public int IdSolicitud
        {
            get { return this.myIdSolicitud; }
        }
        public int IdTipoSolicitud
        {
            get { return this.myIdTipoSolicitud; }
        }
        public string TipoSolicitud
        {
            get { return this.myTipoSolicitud; }
        }

        public int IdStatus
        {
            get { return this.myIdStatus; }
        }


        public string Status
        {
            get { return this.myStatus; }
        }
        public string OficinaEntrega
        {
            get { return this.myOficinaEntrega; }
        }
        public string RNC
        {
            get { return this.myRNC; }
        }

        public string Representante
        {
            get { return this.myRepresentante; }
        }
        public string RepresentanteNombre
        {
            get { return this.myRepresentanteNombre; }
        }
        public string Operador
        {
            get
            {
                if (myOperador == string.Empty)
                {
                    return myOperador;
                }
                else
                {
                    return myOperador.ToUpper();
                }

            }
        }
        public string OperadorNombre
        {


            get
            {
                if (myOperadorNombre == string.Empty)
                {
                    return myOperadorNombre;
                }
                else
                {
                    return myOperadorNombre.ToUpper();
                }

            }
        }
        public string Comentarios
        {
            get { return this.myComentarios; }
        }
        public string InfoSolicitud
        {
            get { return this.myInfoSolicitud; }
        }
        public DateTime FechaRegistro
        {
            get { return this.myFechaRegistro; }
        }
        public DateTime FechaCierre
        {
            get { return this.myFechaCierre; }
        }

        public string UltimoUsuarioModifico
        {
            get { return this.myUltUsuarioModifico; }
        }
        public string UltimoUsuarioModificoNombre
        {
            get { return this.myUltUsuarioModificoNombre; }
        }
        public string EntregadoA
        {
            get { return this.myEntregadoA; }
        }
        public DateTime FechaEntrega
        {
            get { return this.myFechaEntrega; }
        }

        public string NombreComercial
        {
            get { return this.myNombreComercial; }
        }

        public string Fax
        {
            get { return this.myFax; }
        }
        public string RazonSocial
        {
            get { return this.myRazonSocial; }
        }
        public string EmailRepresentante
        {
            get { return this.myEmailRepresentante; }
        }

        public string Telefono1
        {
            get { return this.myTelefono1; }
        }
        public string Telefono2
        {
            get { return this.myTelefono2; }
        }


        public string Solicitante
        {
            get { return this.mySolicitante; }
        }
        public string SolicitanteInstitucion
        {
            get { return this.mySolicitanteInstitucion; }
        }
        public string SolicitanteInformacion
        {
            get { return this.mySolicitanteInformacion; }
        }
        public string SolicitanteCargo
        {
            get { return this.mySolicitanteCargo; }
        }
        public string SolicitanteMotivo
        {
            get { return this.mySolicitanteMotivo; }
        }
        public string SolicitanteDireccion
        {
            get { return this.mySolicitanteDireccion; }
        }
        public string SolicitanteCelular
        {
            get { return this.mySolicitanteCelular; }
        }
        public string SolicitanteCedula
        {
            get { return this.mySolicitanteCedula; }
        }
        public string SolicitanteFax
        {
            get { return this.mySolicitanteFax; }
        }
        public string SolicitanteEmail
        {
            get { return this.mySolicitanteEmail; }
        }
        public string SolicitanteAutoridad
        {
            get { return this.mySolicitanteAutoridad; }
        }
        public string SolicitanteMedio
        {
            get { return this.mySolicitanteMedio; }
        }
        public string SolicitanteLugar
        {
            get { return this.mySolicitanteLugar; }
        }

        #endregion

        #region Metodos

        //*********************************************************


        public Solicitudes(int IdSolicitud)
        {
            this.myIdSolicitud = IdSolicitud;
            this.CargarDatos();
        }


        public static DataTable GetSolicitudesPorEmpresa(string RNC)
        {
            return null;
        }


        public string GetTipoSolicitud(int NroSolicitud)
        {
            if (isExisteIdSolicitud(NroSolicitud))
            {
                OracleParameter[] arrParam = new OracleParameter[2];

                arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
                arrParam[0].Value = NroSolicitud;

                arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
                arrParam[1].Direction = ParameterDirection.Output;

                string cmdStr = "sel_solicitudes_pkg.getTipoSolicitud";
                string result = string.Empty;

                try
                {
                    OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                    result = arrParam[1].Value.ToString();

                    return (result);

                }
                catch (Exception ex)
                {
                    throw ex;
                }
            }
            else
            {
                return string.Empty;
            }

        }

        public override void CargarDatos()
        {

            string TipoSolicitud;
            TipoSolicitud = GetTipoSolicitud(this.IdSolicitud);

            DataTable dt = null;

            if (TipoSolicitud != string.Empty)
            {
                switch (TipoSolicitud)
                {
                    case "2":
                        {
                            dt = getRegistroEmp(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);
                                this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                                this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                                this.myNombreComercial = dt.Rows[0]["nombre_comercial"].ToString();
                                this.myRepresentante = dt.Rows[0]["cedula"].ToString();
                                this.myRepresentanteNombre = dt.Rows[0]["Representante_Nombre"].ToString();
                                this.myTelefono1 = dt.Rows[0]["telefono1"].ToString();
                                this.myTelefono2 = dt.Rows[0]["telefono2"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myOperador = dt.Rows[0]["operador"].ToString();
                                this.myOperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myComentarios = dt.Rows[0]["comentarios"].ToString();
                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();
                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;

                        }
                    case "3":
                        {
                            dt = getRecuperacionClave(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);

                                this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myRazonSocial = dt.Rows[0]["Razon_Social"].ToString();
                                this.myRepresentante = dt.Rows[0]["representante"].ToString();
                                this.myRepresentanteNombre = dt.Rows[0]["Representante_Nombre"].ToString();
                                this.myNombreComercial = dt.Rows[0]["Nombre_Comercial"].ToString();
                                this.myOperador = dt.Rows[0]["operador"].ToString();
                                this.myOperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myComentarios = dt.Rows[0]["comentarios"].ToString();
                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();
                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;

                        }

                    case "4":
                        {
                            dt = getEstadoCuentaViaFax(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);

                                this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myRazonSocial = dt.Rows[0]["Razon_Social"].ToString();
                                this.myRepresentante = dt.Rows[0]["representante"].ToString();
                                this.myRepresentanteNombre = dt.Rows[0]["Representante_Nombre"].ToString();
                                this.myNombreComercial = dt.Rows[0]["Nombre_Comercial"].ToString();
                                this.myOperador = dt.Rows[0]["operador"].ToString();
                                this.myOperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myFax = dt.Rows[0]["fax"].ToString();
                                this.myComentarios = dt.Rows[0]["comentarios"].ToString();

                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;
                        }
                    case "5":
                        {

                            dt = getCancelacion(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myCancelacion.RNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                                this.myCancelacion.RepresentanteNombre = dt.Rows[0]["persona_contacto"].ToString();
                                this.myCancelacion.Cargo = dt.Rows[0]["cargo"].ToString();
                                this.myCancelacion.Telefono = dt.Rows[0]["telefono"].ToString();
                                this.myCancelacion.Motivo = dt.Rows[0]["motivo"].ToString();
                                this.myCancelacion.Comentarios = dt.Rows[0]["comentarios"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myCancelacion.Representante = dt.Rows[0]["Representante"].ToString();
                                this.myCancelacion.Operador = dt.Rows[0]["operador"].ToString();
                                this.myCancelacion.OperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();

                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();
                                this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                                this.myNombreComercial = dt.Rows[0]["nombre_comercial"].ToString();
                                this.myCancelacion.Fax = dt.Rows[0]["fax"].ToString();
                                this.myCancelacion.Email = dt.Rows[0]["email"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;

                        }
                    case "6":
                        {

                            dt = getCancelacion(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myCancelacion.RNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                                this.myCancelacion.RepresentanteNombre = dt.Rows[0]["persona_contacto"].ToString();
                                this.myCancelacion.Cargo = dt.Rows[0]["cargo"].ToString();
                                this.myCancelacion.Telefono = dt.Rows[0]["telefono"].ToString();
                                this.myCancelacion.RncCancelar = dt.Rows[0]["rnc_o_cedula_cancelar"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myCancelacion.Representante = dt.Rows[0]["Representante"].ToString();
                                this.myCancelacion.Operador = dt.Rows[0]["operador"].ToString();
                                this.myCancelacion.OperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myCancelacion.Motivo = dt.Rows[0]["motivo"].ToString();
                                this.myCancelacion.Comentarios = dt.Rows[0]["comentarios"].ToString();
                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();
                                this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                                this.myNombreComercial = dt.Rows[0]["nombre_comercial"].ToString();
                                this.myCancelacion.Fax = dt.Rows[0]["fax"].ToString();
                                this.myCancelacion.Email = dt.Rows[0]["email"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;
                        }
                    case "7":
                        {

                            dt = getInformacion(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);
                                this.mySolicitanteCedula = dt.Rows[0]["nro_documento"].ToString();
                                this.mySolicitante = dt.Rows[0]["solicitante"].ToString();
                                this.mySolicitanteInstitucion = dt.Rows[0]["institucion"].ToString();
                                this.mySolicitanteInformacion = dt.Rows[0]["informacion"].ToString();
                                this.mySolicitanteMotivo = dt.Rows[0]["motivo"].ToString();
                                this.mySolicitanteDireccion = dt.Rows[0]["direccion"].ToString();
                                this.myTelefono1 = dt.Rows[0]["telefono"].ToString();
                                this.mySolicitanteCelular = dt.Rows[0]["celular"].ToString();
                                this.mySolicitanteFax = dt.Rows[0]["fax"].ToString();
                                this.mySolicitanteEmail = dt.Rows[0]["email"].ToString();
                                this.mySolicitanteAutoridad = dt.Rows[0]["autoridad"].ToString();
                                this.mySolicitanteMedio = dt.Rows[0]["medio"].ToString();
                                this.mySolicitanteLugar = dt.Rows[0]["lugar"].ToString();

                                this.mySolicitanteCargo = dt.Rows[0]["cargo"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myOperador = dt.Rows[0]["operador"].ToString();
                                this.myOperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myComentarios = dt.Rows[0]["comentarios"].ToString();
                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;
                        }
                    case "8":
                        {
                            dt = getEnvioFacturasEmail(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);
                                this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                                this.myNombreComercial = dt.Rows[0]["Nombre_Comercial"].ToString();
                                this.myEmailRepresentante = dt.Rows[0]["email"].ToString();
                                this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myRepresentante = dt.Rows[0]["representante"].ToString();
                                this.myRepresentanteNombre = dt.Rows[0]["Representante_Nombre"].ToString();
                                this.myOperador = dt.Rows[0]["operador"].ToString();
                                this.myOperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myComentarios = dt.Rows[0]["comentarios"].ToString();
                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();
                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;

                        }
                    case "9":
                        {

                            dt = getInformacionGral(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);
                                this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                                this.myNombreComercial = dt.Rows[0]["Nombre_Comercial"].ToString();
                                this.myTelefono1 = dt.Rows[0]["telefono1"].ToString();
                                this.myTelefono2 = dt.Rows[0]["telefono2"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myRepresentante = dt.Rows[0]["representante"].ToString();
                                this.myRepresentanteNombre = dt.Rows[0]["Representante_Nombre"].ToString();
                                this.myOperador = dt.Rows[0]["operador"].ToString();
                                this.myOperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myComentarios = dt.Rows[0]["comentarios"].ToString();
                                this.mySolicitanteMotivo = dt.Rows[0]["motivo"].ToString();
                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;

                        }

                    case "12":
                        {

                            dt = getNovedades(IdSolicitud);

                            if (dt.Rows.Count > 0)
                            {
                                this.myRNC = dt.Rows[0]["rnc_o_cedula"].ToString();
                                this.myTipoSolicitud = dt.Rows[0]["Tipo_Solicitud"].ToString();
                                this.myIdTipoSolicitud = Convert.ToInt32(dt.Rows[0]["Id_Tipo_Solicitud"]);
                                this.myRazonSocial = dt.Rows[0]["razon_social"].ToString();
                                this.myNombreComercial = dt.Rows[0]["Nombre_Comercial"].ToString();
                                this.myIdStatus = Convert.ToInt32(dt.Rows[0]["status"]);
                                this.myStatus = dt.Rows[0]["Descripcion_Status"].ToString();
                                this.myRepresentante = dt.Rows[0]["representante"].ToString();
                                this.myRepresentanteNombre = dt.Rows[0]["Representante_Nombre"].ToString();
                                this.myOperador = dt.Rows[0]["operador"].ToString();
                                this.myOperadorNombre = dt.Rows[0]["Operador_Nombre"].ToString();
                                this.myComentarios = dt.Rows[0]["comentarios"].ToString();
                                this.myFechaRegistro = Convert.ToDateTime(dt.Rows[0]["fecha_registro"]);

                                if (dt.Rows[0]["fecha_cierre"] != DBNull.Value)
                                {
                                    this.myFechaCierre = Convert.ToDateTime(dt.Rows[0]["fecha_cierre"]);
                                }

                                if (dt.Rows[0]["fecha_entrega"] != DBNull.Value)
                                {
                                    this.myFechaEntrega = Convert.ToDateTime(dt.Rows[0]["fecha_entrega"]);
                                }

                                this.myUltUsuarioModifico = dt.Rows[0]["ult_usr_modifico"].ToString();

                                dt.Dispose();
                            }
                            else
                            {
                                throw new Exception("No se encontró la solicitud.");
                            }
                            break;

                        }
                }

            }

        }

        public static DataTable CargarDatos(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.CargarDatos";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public override String GuardarCambios(string UsuarioResponsable)
        {
            return "";
        }


        //*************************************************

        public static string crearSolicitud(int IdTipoSolicitud, int OficinaEntrega, string RncCedula, string Representante, string Operador, string Comentarios)
        {
            OracleParameter[] orParam = new OracleParameter[7];


            orParam[0] = new OracleParameter("p_id_tipo_solicitud", OracleDbType.Decimal);
            orParam[0].Value = IdTipoSolicitud;

            orParam[1] = new OracleParameter("p_id_oficina_entrega", OracleDbType.Decimal);
            orParam[1].Value = OficinaEntrega;

            orParam[2] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            orParam[2].Value = RncCedula;

            orParam[3] = new OracleParameter("p_representante", OracleDbType.NVarchar2, 20);
            orParam[3].Value = Representante;

            orParam[4] = new OracleParameter("p_operador", OracleDbType.NVarchar2, 35);
            orParam[4].Value = Operador;

            orParam[5] = new OracleParameter("p_comentarios", OracleDbType.Varchar2, 4000);
            orParam[5].Value = Comentarios;

            orParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[6].Direction = ParameterDirection.Output;

            try
            {
                string result = string.Empty;
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_Solicitud", orParam);
                result = orParam[6].Value.ToString();
                if (result.Split('|')[0].ToString() != "0")
                {
                    throw new Exception(result);
                }
                return (result);
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB("Error creando la solicitud... 1.1 crearSol -| " + ex.ToString());
                throw ex;
            }
        }


        /// <summary>
        /// Metodo utilizado para borrar una solicitud creada.
        /// </summary>
        /// <param name="NoSolicitud">El Nro. de la solicitu que se desea crear.</param>
        /// <remarks>By Ronny J. Carreras</remarks>
        public static void borrarSolicitud(string NoSolicitud)
        {
            OracleParameter[] orParam = new OracleParameter[2];
            string pkgName = "SEL_SOLICITUDES_PKG.BorrarSolicitud";
            string result = string.Empty;

            orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            orParam[0].Value = NoSolicitud;

            orParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[1].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, pkgName, orParam);
                result = orParam[1].Value.ToString();
                if (result != "0")
                {
                    throw new Exception(result);
                }
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB("Error borrando la solicitud... 3.Borrar -| " + ex.ToString());
                throw ex;
            }
        }

        public static string insertaHistoricoSol(String id_CodSol, String id_TipoSolicitud, String id_status)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = id_CodSol;
            arrParam[1] = new OracleParameter("p_id_tipo_solicitud", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = id_TipoSolicitud;
            arrParam[2] = new OracleParameter("p_status", OracleDbType.NVarchar2, 11);
            arrParam[2].Value = id_status;
            arrParam[3] = new OracleParameter("P_ResultNumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "Suirplus.sel_solicitudes_pkg.InsertarHistSol";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string crearRegistroEmpresa(string RncCedula, string RazonSocial, string NombreComercial, string CedulaRep, string Telefono1, string telefono2, string Comentarios, string Operador)
        {
            string NumSol;

            NumSol = crearSolicitud(2, 0, "", "", Operador, Comentarios);

            string[] Resultado;
            Resultado = NumSol.Split('|');

            if (Resultado[0].ToString().Equals("1"))
            {
                return NumSol;
            }

            NumSol = Resultado[1];

            OracleParameter[] orParam = new OracleParameter[8];

            orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            orParam[0].Value = NumSol;

            orParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            orParam[1].Value = RncCedula;

            orParam[2] = new OracleParameter("p_razon_social", OracleDbType.NVarchar2, 150);
            orParam[2].Value = RazonSocial;

            orParam[3] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2, 150);
            orParam[3].Value = NombreComercial;

            orParam[4] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 25);
            orParam[4].Value = CedulaRep;

            orParam[5] = new OracleParameter("p_telefono1", OracleDbType.NVarchar2, 15);
            orParam[5].Value = Telefono1;

            orParam[6] = new OracleParameter("p_telefono2", OracleDbType.NVarchar2, 15);
            orParam[6].Value = telefono2;

            orParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[7].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_RegistroEmp", orParam);
                return orParam[7].Value.ToString();
            }

            catch (Exception ex)
            {
                borrarSolicitud(NumSol);
                throw ex;
            }
        }


        public static string crearCancelacion(int IdTipoCancelacion, string RncCedula, string Persona_Contacto, string Cargo, string Telefono, string Tipo, string Motivo, string RncCedulaCancelar, string Comentarios, string Operador, string Fax, string Email)
        {

            string NumSol;

            NumSol = crearSolicitud(IdTipoCancelacion, 0, RncCedula, "", Operador, Comentarios);

            string[] Resultado;
            Resultado = NumSol.Split('|');

            if (Resultado[0].ToString().Equals("1"))
            {
                return NumSol;
            }

            NumSol = Resultado[1];

            OracleParameter[] orParam = new OracleParameter[11];

            orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            orParam[0].Value = NumSol;

            orParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            orParam[1].Value = RncCedula;

            orParam[2] = new OracleParameter("p_persona_contacto", OracleDbType.NVarchar2, 120);
            orParam[2].Value = Persona_Contacto;

            orParam[3] = new OracleParameter("p_cargo", OracleDbType.NVarchar2, 120);
            orParam[3].Value = Cargo;

            orParam[4] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 15);
            orParam[4].Value = Telefono;

            orParam[5] = new OracleParameter("p_tipo", OracleDbType.NVarchar2, 1);
            orParam[5].Value = Tipo;

            orParam[6] = new OracleParameter("p_motivo", OracleDbType.NVarchar2, 600);
            orParam[6].Value = Motivo;

            orParam[7] = new OracleParameter("p_rnc_o_cedula_cancelar", OracleDbType.NVarchar2, 11);
            orParam[7].Value = RncCedulaCancelar;

            orParam[8] = new OracleParameter("p_fax", OracleDbType.NVarchar2, 10);
            orParam[8].Value = Fax;

            orParam[9] = new OracleParameter("p_email", OracleDbType.NVarchar2, 50);
            orParam[9].Value = Email;

            orParam[10] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[10].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_Cancelacion", orParam);
                return "0" + "|" + NumSol;
            }

            catch (Exception ex)
            {
                borrarSolicitud(NumSol);
                throw ex;
            }
        }


        public static string crearDetCancelacion(int IdSolicitud, string IdReferencia, string Tipo)
        {


            OracleParameter[] orParam = new OracleParameter[4];

            orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            orParam[0].Value = IdSolicitud;

            orParam[1] = new OracleParameter("p_id_referencia", OracleDbType.NVarchar2, 16);
            orParam[1].Value = IdReferencia;

            orParam[2] = new OracleParameter("p_tipo", OracleDbType.NVarchar2, 1);
            orParam[2].Value = Tipo;

            orParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[3].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_Det_Cancelacion", orParam);
                return orParam[3].Value.ToString();
            }

            catch (Exception ex)
            {
                throw ex;
            }
        }

        //public static string crearSolicitudInformacion(string Cedula, string Institucion, string Informacion, string Motivo, string Direccion, string telefono, string Celular, string Cargo, string Comentarios, string Operador)
        //{

        //    string NumSol;

        //    NumSol = crearSolicitud(7, 0, "", "", Operador, Comentarios);
        //    string[] Resultado;
        //    Resultado = NumSol.Split('|');

        //    if (Resultado[0].ToString().Equals("1"))
        //    {
        //        return NumSol;
        //    }

        //    NumSol = Resultado[1];

        //    OracleParameter[] orParam = new OracleParameter[10];

        //    orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
        //    orParam[0].Value = NumSol;

        //    orParam[1] = new OracleParameter("p_nro_documento", OracleDbType.NVarchar2, 25);
        //    orParam[1].Value = Cedula;

        //    orParam[2] = new OracleParameter("p_institucion", OracleDbType.NVarchar2, 200);
        //    orParam[2].Value = Institucion;

        //    orParam[3] = new OracleParameter("p_informacion", OracleDbType.NVarchar2, 600);
        //    orParam[3].Value = Informacion;

        //    orParam[4] = new OracleParameter("p_motivo", OracleDbType.NVarchar2, 300);
        //    orParam[4].Value = Motivo;

        //    orParam[5] = new OracleParameter("p_direccion", OracleDbType.NVarchar2, 300);
        //    orParam[5].Value = Direccion;

        //    orParam[6] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 15);
        //    orParam[6].Value = telefono;

        //    orParam[7] = new OracleParameter("p_celular", OracleDbType.NVarchar2, 15);
        //    orParam[7].Value = Celular;

        //    orParam[8] = new OracleParameter("p_cargo", OracleDbType.NVarchar2, 200);
        //    orParam[8].Value = Cargo;

        //    orParam[9] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
        //    orParam[9].Direction = ParameterDirection.Output;

        //    try
        //    {
        //        OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_Informacion", orParam);
        //        return orParam[9].Value.ToString();
        //    }

        //    catch (Exception ex)
        //    {
        //        borrarSolicitud(NumSol);
        //        throw ex;
        //    }

        //}		

        public static string crearSolicitudInformacion(string NombreCompleto, string NroDocumento, string Direccion, string telefono, string Celular, string fax, string email, string Institucion, string Cargo, string Informacion, string Motivo, string autoridad, string medio, string lugar, string Comentarios, string Operador)
        {
            string NumSol;

            NumSol = crearSolicitud(7, 0, "", "", Operador, Comentarios);
            string[] Resultado;
            Resultado = NumSol.Split('|');
            if (Resultado[0].ToString().Equals("1"))
            {
                SuirPlus.Exepciones.Log.LogToDB("Error creando la solicitud... 1 crearSol -| " + NumSol);
                throw new Exception(NumSol);
            }
            NumSol = Resultado[1];

            OracleParameter[] orParam = new OracleParameter[16];

            orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Int32);
            orParam[0].Value = NumSol;
            orParam[1] = new OracleParameter("p_nombrecompleto", OracleDbType.Varchar2, 200);
            orParam[1].Value = NombreCompleto;
            orParam[2] = new OracleParameter("p_nro_documento", OracleDbType.Varchar2, 25);
            orParam[2].Value = NroDocumento;
            orParam[3] = new OracleParameter("p_direccion", OracleDbType.Varchar2, 300);
            orParam[3].Value = Direccion;
            orParam[4] = new OracleParameter("p_telefono", OracleDbType.Varchar2, 10);
            orParam[4].Value = telefono;
            orParam[5] = new OracleParameter("p_celular", OracleDbType.Varchar2, 10);
            orParam[5].Value = Celular;
            orParam[6] = new OracleParameter("p_fax", OracleDbType.Varchar2, 10);
            orParam[6].Value = fax;
            orParam[7] = new OracleParameter("p_email", OracleDbType.Varchar2, 100);
            orParam[7].Value = email;
            orParam[8] = new OracleParameter("p_institucion", OracleDbType.Varchar2, 200);
            orParam[8].Value = Institucion;
            orParam[9] = new OracleParameter("p_cargo", OracleDbType.Varchar2, 200);
            orParam[9].Value = Cargo;
            orParam[10] = new OracleParameter("p_informacion", OracleDbType.Varchar2, 600);
            orParam[10].Value = Informacion;
            orParam[11] = new OracleParameter("p_motivo", OracleDbType.Varchar2, 600);
            orParam[11].Value = Motivo;
            orParam[12] = new OracleParameter("p_autoridad", OracleDbType.NVarchar2, 200);
            orParam[12].Value = autoridad;
            orParam[13] = new OracleParameter("p_medio", OracleDbType.Varchar2, 200);
            orParam[13].Value = medio;
            orParam[14] = new OracleParameter("p_lugar", OracleDbType.Varchar2, 200);
            orParam[14].Value = lugar;
            orParam[15] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[15].Direction = ParameterDirection.Output;

            try
            {
                string result = string.Empty;
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_Informacion", orParam);

                result = orParam[15].Value.ToString();
                if (result.Split('|')[0].ToString() != "0")
                {
                    throw new Exception(result);
                }
                return (result);
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB("Error creando la solicitud... 2 crearSol -| " + ex.ToString());
                borrarSolicitud(NumSol);
                throw ex;
            }

        }


        public static string crearSolicitudInformacionGral(string RNC, string CedulaRep, string Informacion, string telefono1,
            string telefono2, string idProvincia, string Comentarios, string Operador)
        {

            string NumSol;

            NumSol = crearSolicitud(9, 0, RNC, CedulaRep, Operador, Comentarios);

            string[] Resultado;
            Resultado = NumSol.Split('|');

            if (Resultado[0].ToString().Equals("1"))
            {
                return NumSol;
            }

            NumSol = Resultado[1];

            OracleParameter[] orParam = new OracleParameter[6];

            orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            orParam[0].Value = NumSol;

            orParam[1] = new OracleParameter("p_informacion", OracleDbType.NVarchar2, 600);
            orParam[1].Value = Informacion;

            orParam[2] = new OracleParameter("p_telefono1", OracleDbType.NVarchar2, 15);
            orParam[2].Value = telefono1;

            orParam[3] = new OracleParameter("p_telefono2", OracleDbType.NVarchar2, 15);
            orParam[3].Value = telefono2;

            orParam[4] = new OracleParameter("p_Idprovincia", OracleDbType.NVarchar2, 6);
            orParam[4].Value = idProvincia;

            orParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[5].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_InformacionGral", orParam);
                return orParam[5].Value.ToString();
            }

            catch (Exception ex)
            {
                borrarSolicitud(NumSol);
                throw ex;
            }

        }


        public static string CambiarStatus(int IdSolicitud, int Status, string UsuarioModifico, string Comentarios)
        {

            OracleParameter[] orParam = new OracleParameter[5];

            orParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            orParam[0].Value = IdSolicitud;

            orParam[1] = new OracleParameter("p_Status", OracleDbType.Decimal);
            orParam[1].Value = Status;

            orParam[2] = new OracleParameter("p_Ultimo_Usuario", OracleDbType.NVarchar2, 35);
            orParam[2].Value = UsuarioModifico;

            orParam[3] = new OracleParameter("p_Comentarios", OracleDbType.NVarchar2, 4000);
            orParam[3].Value = Comentarios;

            orParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[4].Direction = ParameterDirection.Output;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.CambiarSolicitud", orParam);
                return orParam[4].Value.ToString();
            }



            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getRegistroEmp(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getRegistroEmp";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getCancelacion(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getCancelacion";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getDetCancelacion(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getDetCancelacion";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getSolicitud(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getSolicitud";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        /// <summary>
        /// Reporte para ver las solicitudes trabajadas por el CAE.
        /// by Charlie Peña
        /// </summary>
        /// <param name="fecha_desde"></param>
        /// <param name="fecha_hasta"></param>
        /// <returns></returns>
        public static DataTable getSolicitudes(DateTime fecha_desde, DateTime fecha_hasta)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[0].Value = fecha_desde;

            arrParam[1] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[1].Value = fecha_hasta;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getsolicitudes";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[3].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[3].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ds.Tables[0];

        }

        public static DataTable getPageSolicitudes(DateTime fecha_desde, DateTime fecha_hasta, Int16 pageNum, Int16 pageSize)
        {

            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[0].Value = fecha_desde;

            arrParam[1] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[1].Value = fecha_hasta;

            arrParam[2] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[2].Value = pageNum;

            arrParam[3] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[3].Value = pageSize;

            arrParam[4] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getPagesolicitudes";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[5].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[5].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ds.Tables[0];

        }

        public static DataTable getSolicitudesGeneral(string p_status, string p_usuario, string p_tipo_solicitud, DateTime p_fecha_desde, DateTime p_fecha_hasta, Int32 pageNum, Int32 pageSize)
        {

            OracleParameter[] arrParam = new OracleParameter[9];

            arrParam[0] = new OracleParameter("p_status", OracleDbType.Int32);
            if (!p_status.Equals("-1"))
            {
                arrParam[0].Value = Convert.ToInt32(p_status);
            }

            arrParam[1] = new OracleParameter("p_usuario", OracleDbType.NVarchar2,35);
            if (!p_usuario.Equals("0"))
            {
                arrParam[1].Value = p_usuario;
            }

            arrParam[2] = new OracleParameter("p_tipo_solicitud", OracleDbType.Int32);
            if (!p_tipo_solicitud.Equals("--Todos--"))
            {
                arrParam[2].Value = Convert.ToInt16(p_tipo_solicitud);
            }

            arrParam[3] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[3].Value = p_fecha_desde;


            arrParam[4] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[4].Value = p_fecha_hasta;


            arrParam[5] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[5].Value = pageNum;

            arrParam[6] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[6].Value = pageSize;

            arrParam[7] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[7].Direction = ParameterDirection.Output;

            arrParam[8] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[8].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getsolicitudesGeneral";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[8].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[8].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ds.Tables[0];

        }
        public static DataTable getHistoricoUsuarios(string p_id_solicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idsolicitud", OracleDbType.Int64);
            arrParam[0].Value = p_id_solicitud;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getHistoricoUsuarioSol";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ds.Tables[0];

        }

        public static DataTable getPageDetSolicitudes(int p_id_tipo_solicitud, DateTime fecha_desde, DateTime fecha_hasta, Int16 pageNum, Int16 pageSize)
        {

            OracleParameter[] arrParam = new OracleParameter[7];

            arrParam[0] = new OracleParameter("p_id_tipo_solicitud", OracleDbType.Int16);
            arrParam[0].Value = p_id_tipo_solicitud;

            arrParam[1] = new OracleParameter("p_fecha_desde", OracleDbType.Date);
            arrParam[1].Value = fecha_desde;

            arrParam[2] = new OracleParameter("p_fecha_hasta", OracleDbType.Date);
            arrParam[2].Value = fecha_hasta;

            arrParam[3] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[3].Value = pageNum;

            arrParam[4] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[4].Value = pageSize;

            arrParam[5] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[6].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getPageDetsolicitudes";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[6].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[6].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ds.Tables[0];

        }


        public static DataTable getRecuperacionClave(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getRecuperacionClave";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getEstadoCuentaViaFax(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getEstadoCuentaViaFax";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getEnvioFacturasEmail(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getEnvioFacturasEmail";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getInformacion(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getInformacion";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getInformacionGral(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getInformacionGral";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getNovedades(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getNovedades";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getSolicitud_RNC(string RNC)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNC;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getSolicitud_RNC";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getPageSolicitud_RNC(string RNC, Int16 pageNum, Int16 pageSize)
        {
            string Resultado = "0";

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNC;
            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int16);
            arrParam[1].Value = pageNum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[2].Value = pageSize;

            arrParam[3] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getpageSolicitud_RNC";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                Resultado = arrParam[4].Value.ToString();

                if (Resultado != "0")
                {
                    DataTable dt = new DataTable();
                    Utilitarios.Utils.agregarMensajeError(Resultado, ref dt);
                    return dt;
                }

                return ds.Tables[0];

            }
            catch (Exception ex)
            {
                throw new Exception(Resultado + " | " + ex.ToString());
            }

        }

        public static DataTable getSolicitud_Oficina(int IdOficina)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_oficina", OracleDbType.Decimal);
            arrParam[0].Value = IdOficina;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getSolicitud_Oficina";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getInfoEmpresa(string CodSol)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2, 10);
            arrParam[0].Value = CodSol;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getInfoEmpresa";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable getInfoEmpresaEdit(int IdSol)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.NVarchar2, 10);
            arrParam[0].Value = IdSol;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getInfoEmpresaEdit";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static DataTable getSolicitud_Status(int Status)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_status", OracleDbType.Decimal);
            arrParam[0].Value = Status;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getSolicitud_Status";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getStatus()
        {
            OracleParameter[] arrParam = new OracleParameter[1];

            arrParam[0] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getStatus";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getOficinas()
        {
            OracleParameter[] arrParam = new OracleParameter[1];

            arrParam[0] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getOficinas";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static DataTable getTiposSolicitudes()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            //arrParam[0] = new OracleParameter("p_FormServicio", OracleDbType.Varchar2);
            //if (!string.IsNullOrEmpty(FormServicio))
            //{
            //    arrParam[0].Value = FormServicio;
            //}
            //else
            //{
            //    arrParam[0].Value = DBNull.Value;

            //}


            arrParam[0] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getTipoSolicitudes";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getSolicitudesServicio()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            //arrParam[0] = new OracleParameter("p_FormServicio", OracleDbType.Varchar2);
            //if (!string.IsNullOrEmpty(FormServicio))
            //{
            //    arrParam[0].Value = FormServicio;
            //}
            //else
            //{
            //    arrParam[0].Value = DBNull.Value;

            //}


            arrParam[0] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getSolicitudesServicio";

            try
            {
                return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getSolicitud(int IdSolicitud, int Status, int Tiposolicitud, int IdOficina, string idProvincia, int Registros)
        {


            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_idSolicitud", OracleDbType.Decimal);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.Decimal);
            arrParam[1].Value = Status;

            arrParam[2] = new OracleParameter("p_tipoSolicitud", OracleDbType.Decimal);
            arrParam[2].Value = Tiposolicitud;

            arrParam[3] = new OracleParameter("p_IdOficina", OracleDbType.Decimal);
            arrParam[3].Value = IdOficina;

            arrParam[4] = new OracleParameter("p_IdProvincia", OracleDbType.NVarchar2, 5);
            arrParam[4].Value = idProvincia;

            arrParam[5] = new OracleParameter("p_registros", OracleDbType.Int32);
            arrParam[5].Value = Registros;

            arrParam[6] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getSolicitud";
            DataSet dsSol;

            try
            {
                dsSol = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[7].Value.ToString() != "0")
                {
                    throw new MissingFieldException(arrParam[6].Value.ToString());
                }
            }
            catch (OracleException)
            {
                throw new Exception("Nro. de Solicitud Inválido");
            }

            return dsSol.Tables[0];

        }


        public static void getAportes(string PeriodoFactura, double Salario, ref double AporteAfiliado, ref double AporteEmpleador, ref double CuentaPersonal)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_periodo_factura", OracleDbType.Int64);
            arrParam[0].Value = PeriodoFactura;

            arrParam[1] = new OracleParameter("p_salario", OracleDbType.Decimal);
            arrParam[1].Value = Salario;

            arrParam[2] = new OracleParameter("p_total_aportes_afiliados", OracleDbType.Decimal);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_total_aportes_empleador", OracleDbType.Decimal);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_cuenta_personal", OracleDbType.Decimal);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_pkg.get_aportes";

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                AporteAfiliado = Convert.ToDouble(arrParam[2].Value.ToString());
                AporteEmpleador = Convert.ToDouble(arrParam[3].Value.ToString());
                CuentaPersonal = Convert.ToDouble(arrParam[4].Value.ToString());

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static bool isRepresentanteEnEmpresa(string Rnc, string CedulaRepresentante)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = Rnc;

            arrParam[1] = new OracleParameter("p_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = CedulaRepresentante;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 100);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.isRepresentanteEnEmpresa";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();

                if (result == "1")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static bool isExisteIdSolicitud(int IdSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal, 10);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.IsIdSolicitudValido";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();

                if (result == "1")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getReferencias(string Rnc)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.Varchar2);
            arrParam[0].Value = Rnc;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getreferencias";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ds.Tables[0];

        }

        public static DataTable getResumenEmp(string CodSol)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_cod_sol", OracleDbType.Varchar2);
            arrParam[0].Value = CodSol;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.Get_Resumen_Emp";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return ds.Tables[0];

        }

        public static string getSolicitudByRNC(string rnc)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.getSolicitudByRNC";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result.Split('|')[0].ToString() != "0")
                {
                    throw new Exception(result.Split('|')[1].ToString());
                }
                return (result.Split('|')[1].ToString());

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static bool isValidaNroSolicitud(string NroSolicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Nro_Solicitud", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.isExisteNroSolicitud";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "1")
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        //Para Actualizar los pasos del historico de pasos
        public static bool ActualizarHistoricoPasos(string NroSolicitud)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_Nro_Solicitud", OracleDbType.NVarchar2, 7);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 1000);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.Actualizar_his_status";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return true;
                }
                else
                {
                    return false;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        // Agrega un codigo de solicitud para verificar en status en que se encuentra
        public static string crearSolicitudRegEmp(string NroSolicitud, string Usuario, int IdClaseEmp, string RNC_o_Cedula, string Comentarios2)
        {
            OracleParameter[] orParam = new OracleParameter[6];
            
            orParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.Varchar2);
            orParam[0].Value = NroSolicitud;
            
            orParam[1] = new OracleParameter("p_usuario", OracleDbType.Varchar2);
            orParam[1].Value = Usuario;

            orParam[2] = new OracleParameter("P_ID_CLASE_EMPRESA", OracleDbType.Decimal, 1);
            orParam[2].Value = IdClaseEmp;

            orParam[3] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2);
            orParam[3].Value = RNC_o_Cedula;

            orParam[4] = new OracleParameter("p_comentarios", OracleDbType.Varchar2, 4000);
            orParam[4].Value = Comentarios2;

            orParam[5] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            orParam[5].Direction = ParameterDirection.Output;

            try
            {
                string result = string.Empty;
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, "sel_solicitudes_pkg.Crear_RegEmpresa_Solicitud", orParam);
                result = orParam[5].Value.ToString();
                if (result[0].ToString() != "0")
                {
                    throw new Exception(result);
                }
                return (result);
            }

            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB("Error creando la solicitud... " + ex.ToString());
                throw ex;
            }
        }       

        public static DataTable getHistoricosolicitud(String Nro_solicitud,  String result)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = Nro_solicitud;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string cmdStri = "SEL_SOLICITUDES_PKG.getHistoricoSolicitudes";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                result = arrParam[1].Value.ToString();

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return new DataTable();
                }

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        //Devuelve el historico de los pasos que a recorrido el usuario
        public static DataTable getHistoricosolicitudes(String Nro_solicitud)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nro_solicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = Nro_solicitud;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;


            string cmdStri = "SEL_SOLICITUDES_PKG.getHistoricoSolicitudes";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        //Devuelve el ultimo paso donde estuvo el cliente
        public static DataTable GetHistoricoPasos(String NroSolicitud)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_COD_SOL", OracleDbType.NVarchar2, 7);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.Get_historico_pasos";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        //Devuelve el ultimo paso donde estuvo el cliente
        public static DataTable CargarComentario(String NroSolicitud)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_COD_SOL", OracleDbType.NVarchar2, 7);
            arrParam[0].Value = NroSolicitud;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.CargarComentario";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public static string InsertarHistoricoSol(String Nro_solicitud, String Tipo_solicitud, String Status)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.Varchar2);
            arrParam[0].Value = Nro_solicitud;

            arrParam[1] = new OracleParameter("p_id_tipo_solicitud", OracleDbType.Varchar2);
            arrParam[1].Value = Tipo_solicitud;

            arrParam[2] = new OracleParameter("p_status", OracleDbType.Varchar2);
            arrParam[2].Value = Status;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;


            string cmdStr = "SEL_SOLICITUDES_PKG.InsertarHistSol";            
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[3].Value.ToString();
                if (result != "0")
                {
                    throw new Exception(result.Split('|')[1].ToString());
                }
                return result;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /*Para Actualizar los archivos de una solicitud*/
        public static string ActualizarArchivoSolicitud(string idsolicitud, string id_requisito, string NombreArchivo, byte[] archivo, string tipoarchivo)
        {

            string result = string.Empty;
            if (id_requisito.Contains("'"))
            {
                id_requisito = id_requisito.Replace("'", "");
            }
            if (idsolicitud.Contains("'")) {
                idsolicitud = idsolicitud.Replace("'", "");
            }

            var numero2 = Convert.ToInt32(idsolicitud);

            var numero = Convert.ToInt32(id_requisito);


            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Decimal);
            arrParam[0].Value = numero2;

            arrParam[1] = new OracleParameter("p_id_requisito", OracleDbType.Decimal);
            arrParam[1].Value = numero;

            arrParam[2] = new OracleParameter("p_nombre_req", OracleDbType.Varchar2, 50);
            arrParam[2].Value = NombreArchivo;

            arrParam[3] = new OracleParameter("p_documento", OracleDbType.Blob);
            arrParam[3].Value = archivo;

            arrParam[4] = new OracleParameter("p_tipo_archivo", OracleDbType.Varchar2, 50);
            arrParam[4].Value = tipoarchivo;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;


            string cmdStri = "SEL_SOLICITUDES_PKG.ActRequisitos";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                result = arrParam[5].Value.ToString();

                if (result != "0")
                {
                    var r = result.Split('|').ToString();
                    result = r[1].ToString();
                }
                return result;
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /*Para insertar los archivos de las solicitudes creadas*/
        public static string InsertarArchivoSolicitud(string solicitud, string id_requisito, byte[] archivo, string nombreArchivo, string tipoarchivo)
        {
            
            string result = string.Empty;
            if (id_requisito.Contains("'")) {
             id_requisito = id_requisito.Replace("'", "");
            }
            var numero = Convert.ToInt32(id_requisito);


            OracleParameter[] arrParam = new OracleParameter[6];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = solicitud;

            arrParam[1] = new OracleParameter("p_id_requisito", OracleDbType.Decimal);
            arrParam[1].Value = numero;

            arrParam[2] = new OracleParameter("p_documento", OracleDbType.Blob);
            arrParam[2].Value = archivo;

            arrParam[3] = new OracleParameter("p_nombre_documento", OracleDbType.Varchar2,50);
            arrParam[3].Value = nombreArchivo;
            
            arrParam[4] = new OracleParameter("p_tipo_archivo", OracleDbType.Varchar2, 50);
            arrParam[4].Value = tipoarchivo;

            arrParam[5] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[5].Direction = ParameterDirection.Output;

                    
            string cmdStri = "SEL_SOLICITUDES_PKG.InsertarDocs";
            
            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam);
                result = arrParam[5].Value.ToString();

                if (result != "0") {
                    var r = result.Split('|').ToString();
                    result = r[1].ToString();
                    
                }
                
                
                return result;

            }

            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
            
           
        }

        public static DataTable MostrarRequisitosRegEmpresas(Int32 id_clase_empresa, string no_solicitud)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = no_solicitud;

            arrParam[1] = new OracleParameter("p_id_clase_empresa", OracleDbType.Int32);
            arrParam[1].Value = id_clase_empresa;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.SolicitudCargaDocs";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[3].Value.ToString() != "0")
                    throw new Exception(arrParam[3].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        //Para Validar si el usuario a registrar ya existe en seg_usuario_t
   
        //Para Validar los campos del login de RegNuevaEmpresa
        public static string isValidarUsuario(string Id_Usuario, string pass)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = Id_Usuario;

            arrParam[1] = new OracleParameter("p_class", OracleDbType.NVarchar2, 50);
            arrParam[1].Value = pass;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.isExisteUsuario";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString().Split('|')[1];
                return result; 

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

      
        //Para capturar las solicitudes por el usuario del login
        public static DataTable SolEnProceso(string Usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[0].Value = Usuario;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.SolEnProceso";

            try
            {                
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Solicitudes en Proceso");
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        //Para Obtener la cantidad de archivos en una solicitud que exista
        public static DataTable getCantidadDeDoc(string Codigo)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = Codigo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getcantidaddoc";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No Hay Archivos Cargados");
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        //Para validar si un Empleador tiene una solicitud de nueva empresa en proceso
        public static string isValidarSolEnProceso(string rnc_o_cedula)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = rnc_o_cedula;
          
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.isexistesolproceso";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable GetNombreUsuario(string Usuario)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[0].Value = Usuario;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.GetNombreUsuario";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("Usuario no registrado.");
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }


        public static string isValidarUsuarioReg(string Id_Usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = Id_Usuario;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.isExisteUsuario1";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string isValidarUsuarioReg2(string Id_Usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_usuario", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = Id_Usuario;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.isExisteUsuario2";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        public static string ConfirmarEmailRegEmp(string usuario, string email, string link_params, string accion)
        {
            OracleParameter[] arrParam = new OracleParameter[5];

            arrParam[0] = new OracleParameter("p_idusuario", OracleDbType.Varchar2, 300);
            arrParam[0].Value = usuario;
            arrParam[1] = new OracleParameter("p_email", OracleDbType.Varchar2, 300);
            arrParam[1].Value = email;
            arrParam[2] = new OracleParameter("p_link_params", OracleDbType.Varchar2, 4000);
            arrParam[2].Value = link_params;
            arrParam[3] = new OracleParameter("p_accion", OracleDbType.Varchar2, 1);
            arrParam[3].Value = accion;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "sre_representantes_pkg.ConfirmacionEmail";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                return ex.ToString();
            }

        }

        public static string ActualizaStatus(string CodSol, string status)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = CodSol;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = status;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.ActualizaStatus";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string ActStatusSol(string IdSol, string status)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_no_solicitud", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = IdSol;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.NVarchar2, 1);
            arrParam[1].Value = status;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.ActualizaStatus1";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static string ActualizaDatosEmpresa(string razonSocial, string nombreComercial, string sectorSalarial, string sectorEconomico, 
            string idActividad, string tipoZona, string parque, string calle, string numero, string apartamento, 
            string sector, string provincia, string idMunicipio, string tel1, string ext1, string tel2, string ext2, 
            string fax, string email, string R_Cedula_Pasaporte, string R_Telefono1, string R_Ext1, string R_Telefono2, string R_Ext2, string idCodSol)
        {
            OracleParameter[] arrParam = new OracleParameter[26];

            arrParam[0] = new OracleParameter("p_razon_social", OracleDbType.NVarchar2);
            arrParam[0].Value = razonSocial;

            arrParam[1] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2);
            arrParam[1].Value = nombreComercial;

            arrParam[2] = new OracleParameter("p_sector_salarial", OracleDbType.NVarchar2);
            arrParam[2].Value = sectorSalarial;

            arrParam[3] = new OracleParameter("p_id_sector_economico", OracleDbType.NVarchar2);
            arrParam[3].Value = sectorEconomico;

            arrParam[4] = new OracleParameter("p_id_actividad_eco", OracleDbType.NVarchar2);
            arrParam[4].Value = idActividad;

            arrParam[5] = new OracleParameter("p_tipo_zona_franca", OracleDbType.NVarchar2);
            arrParam[5].Value = tipoZona;

            arrParam[6] = new OracleParameter("p_parque", OracleDbType.NVarchar2);
            arrParam[6].Value = parque;

            arrParam[7] = new OracleParameter("p_calle", OracleDbType.NVarchar2);
            arrParam[7].Value = calle;

            arrParam[8] = new OracleParameter("p_numero", OracleDbType.NVarchar2);
            arrParam[8].Value = numero;

            arrParam[9] = new OracleParameter("p_apartamento", OracleDbType.NVarchar2);
            arrParam[9].Value = apartamento;

            arrParam[10] = new OracleParameter("p_sector", OracleDbType.NVarchar2);
            arrParam[10].Value = sector;

            arrParam[11] = new OracleParameter("p_provincia", OracleDbType.NVarchar2);
            arrParam[11].Value = provincia;

            arrParam[12] = new OracleParameter("p_id_municipio", OracleDbType.NVarchar2);
            arrParam[12].Value = idMunicipio;

            arrParam[13] = new OracleParameter("p_telefono_1", OracleDbType.NVarchar2);
            arrParam[13].Value = tel1;

            arrParam[14] = new OracleParameter("p_ext_1", OracleDbType.NVarchar2);
            arrParam[14].Value = ext1;

            arrParam[15] = new OracleParameter("p_telefono_2", OracleDbType.NVarchar2);
            arrParam[15].Value = tel2;

            arrParam[16] = new OracleParameter("p_ext_2", OracleDbType.NVarchar2);
            arrParam[16].Value = ext2;

            arrParam[17] = new OracleParameter("p_fax", OracleDbType.NVarchar2);
            arrParam[17].Value = fax;

            arrParam[18] = new OracleParameter("p_email", OracleDbType.NVarchar2);
            arrParam[18].Value = email;

            arrParam[19] = new OracleParameter("p_ced_rep", OracleDbType.NVarchar2);
            arrParam[19].Value = R_Cedula_Pasaporte;

            arrParam[20] = new OracleParameter("p_telefono_rep_1", OracleDbType.NVarchar2);
            arrParam[20].Value = R_Telefono1;

            arrParam[21] = new OracleParameter("p_ext_rep_1", OracleDbType.NVarchar2);
            arrParam[21].Value = R_Ext1;

            arrParam[22] = new OracleParameter("p_telefono_rep_2", OracleDbType.NVarchar2);
            arrParam[22].Value = R_Telefono2;

            arrParam[23] = new OracleParameter("p_ext_rep_2", OracleDbType.NVarchar2);
            arrParam[23].Value = R_Ext2;

            arrParam[24] = new OracleParameter("p_id_solicitud", OracleDbType.NVarchar2);
            arrParam[24].Value = idCodSol;

            arrParam[25] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[25].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.ActualizaInfoEmpresa";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[25].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable CargarAdjuntos(int IdSol)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_idSolicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = IdSol;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.CargarArchivos";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No ha relizado carga de archivo");
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable CargarAdjuntos(int IdSol, int idrequisito)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_idSolicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = IdSol;

            arrParam[1] = new OracleParameter("p_idrequisito", OracleDbType.NVarchar2);
            arrParam[1].Value = idrequisito;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.CargarArchivos";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[3].Value.ToString() != "0")
                    throw new Exception(arrParam[3].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("No ha relizado carga de archivo");
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable GetRepresentante(string NroDocuemnto)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_documento", OracleDbType.NVarchar2);
            arrParam[0].Value = NroDocuemnto;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getNombreRepresentante";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }
                return new DataTable("Error en el representante");
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }




        public static string ActStatusTmp(int IdSolicitud, string Status)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.NVarchar2);
            arrParam[0].Value = IdSolicitud;

            arrParam[1] = new OracleParameter("p_status", OracleDbType.NVarchar2);
            arrParam[1].Value = Status;
           
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.ActStatusEmpTmp";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[2].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        //Devuelve los datos de los archivos del usuario
        public static DataTable GetEditDoc(String idSolicitud)
        {
            var codigo = Convert.ToInt32(idSolicitud);
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("P_COD_SOL", OracleDbType.Int32);
            arrParam[0].Value = codigo;

            arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.GetEditDoc";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                else
                {
                    return ds.Tables[0];
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        //Devuelve el archivo especificado por el usuario
        public static Object GetEditArchivo(String idSolicitud, String Req)
        {
            var codigo = Convert.ToInt32(idSolicitud);
            var Requisito = Convert.ToInt32(Req);
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_solicitud", OracleDbType.Int32);
            arrParam[0].Value = codigo;

            arrParam[1] = new OracleParameter("p_id_requsito", OracleDbType.Int32);
            arrParam[1].Value = Requisito;

            arrParam[2] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[3].Direction = ParameterDirection.Output;

            string cmdStr = "sel_solicitudes_pkg.GetEditArchivo";
            DataSet ds;
            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[3].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[3].Value.ToString());
                }
                else
                {
                    var archivo = ds.Tables[0].Rows[0][0];
                    return archivo;
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        public static Object CambiarClave(String email)
        {
           
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_email", OracleDbType.NVarchar2, 50);
            arrParam[0].Value = email;
           
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            string cmdStr = "sre_representantes_pkg.ResetClassRegEmp";
            string result = string.Empty;

            try
            {
                OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
                if (result == "0")
                {
                    return result;
                }
                else if (result == "1")
                {
                    return result;
                }
                else
                {
                    throw new Exception(arrParam[1].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                throw new Exception(arrParam[1].Value.ToString());
            }
        }

        public static DataTable getEvaluacionDet(int registro)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro", OracleDbType.Int32);
            arrParam[0].Value = registro;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "NSS_Get_Evaluacion_Detalle";
            DataSet ds;

            try
            {
                ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[2].Value.ToString() != "0")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
                else
                {
                    return ds.Tables[0];
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







