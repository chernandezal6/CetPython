using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;
using SuirPlusEF.Framework;
using Oracle.ManagedDataAccess.Client;
using System.Data;

namespace SuirPlusEF.Repositories
{
    public class DetEvaluacionVisualRepository : Framework.BaseObject<DetalleEvaluacionVisual>, Framework.IBaseRepository<DetalleEvaluacionVisual>
    {
        public DetEvaluacionVisualRepository() : base() { }
        public DetEvaluacionVisualRepository(Framework.OracleDbContext context) : base(context) { }

        public DetalleEvaluacionVisual GetById(int id)
        {
            return db.DetEvaluacionVisual.FirstOrDefault(x => x.IdDetalleEvaluacionVisual == id);
        }
        public DetalleEvaluacionVisual GetByIdEvaluacion(int Id)
        {
            return db.DetEvaluacionVisual.FirstOrDefault(x => x.IdEvaluacionVisual == Id);
        }
        public IList<Grid> GetEvaluacionMaestroExt(int solicitud)
        {
            var data =
                from ds in db.DetalleSolicitudes
                join n in db.Nacionalidad on ds.IdNacionalidad equals n.IdNacionalidad
                join c in db.Ciudadanos on ds.IdNSSAsignado equals c.IdNSS into c1
                from c2 in c1.DefaultIfEmpty()

                where (ds.IdSolicitud == solicitud) && (ds.IdEstatus == 4)
                select new Grid
                {
                    IdTipoDoc = ds.TipoDocumento.IdTipoDocumento,
                    registro = ds.IdRegistro,
                    TipoDoc = ds.TipoDocumento.Descripcion,
                    NroDocumento = ds.Documento,
                    Nombres = ds.Nombres,
                    PrimerApellido = ds.PrimerApellido,
                    SegundoApellido = ds.SegundoApellido,
                    sexo = ds.Sexo,
                    Nacionalidad = n.Descripcion,
                    FechaNacimiento = ds.FechaNacimiento,
                    Imagen = ds.IMAGEN_SOLICITUD
                };
            return data.ToList();
        }
        public IList<Grid> GetEvaluacionDetalleExt(int solicitud)
        {
            var data =
                from de in db.DetEvaluacionVisual
                join e in db.EvaluacionVisuales on de.IdEvaluacionVisual equals e.IdEvaluacionVisual
                join ds in db.DetalleSolicitudes on e.IdRegistro equals ds.IdRegistro
                join c in db.Ciudadanos on de.IdNSS equals c.IdNSS into cd
                from c2 in cd.DefaultIfEmpty()
                join td in db.TipoDocumentos on c2.TipoDocumento equals td.IdTipoDocumento
                join n in db.Nacionalidad on c2.IdNacionalidad equals n.IdNacionalidad
                where (ds.IdSolicitud == solicitud) && (ds.IdEstatus == 4)
                select new Grid
                {
                    Solicitud = ds.IdSolicitud,
                    Nss = c2.IdNSS,
                    IdTipoDoc = td.IdTipoDocumento,
                    TipoDoc = td.Descripcion,
                    NroDocumento = c2.NroDocumento,
                    Nombres = c2.Nombres,
                    PrimerApellido = c2.PrimerApellido,
                    SegundoApellido = c2.SegundoApellido,
                    sexo = c2.Sexo,
                    Nacionalidad = n.Descripcion,
                    FechaNacimiento = c2.FechaNacimiento
                };
            return data.ToList();
        }
        public IList<Grid> GetEvaluacionMaestroNac(int registro)
        {
            var data =
                from ds in db.DetalleSolicitudes
                join de in db.EvaluacionVisuales on ds.IdRegistro equals de.IdRegistro
                where ds.IdRegistro == registro
                select new Grid
                {
                    Nss = ds.IdNSSAsignado,
                    IdTipoDoc = ds.TipoDocumento.IdTipoDocumento,
                    TipoDoc = ds.TipoDocumento.Descripcion,
                    NroDocumento = ds.Documento,
                    Nombres = ds.Nombres,
                    PrimerApellido = ds.PrimerApellido,
                    SegundoApellido = ds.SegundoApellido,
                    sexo = ds.Sexo,
                    FechaNacimiento = ds.FechaNacimiento,
                    Municipio = ds.MunicipioActa,
                    AñoActa = ds.AnoActa,
                    NumeroActa = ds.NumeroActa,
                    FolioActa = ds.FolioActa,
                    LibroActa = ds.LibroActa,
                    OficialiaActa = ds.OficialiaActa,
                    Imagen = ds.IMAGEN_SOLICITUD
                };
            return data.ToList();
        }
        public IList<Grid> GetEvaluacionDetalleNac(int solicitud)
        {
            var data =
                from de in db.DetEvaluacionVisual
                join e in db.EvaluacionVisuales on de.IdEvaluacionVisual equals e.IdEvaluacionVisual
                join ds in db.DetalleSolicitudes on e.IdRegistro equals ds.IdRegistro
                join c in db.Ciudadanos on de.IdNSS equals c.IdNSS
                where (ds.IdSolicitud == solicitud) && (ds.IdEstatus == 4)
                select new Grid
                {
                    Nss = c.IdNSS,
                    NroDocumento = c.NroDocumento,
                    IdTipoDoc = c.TipoDocumento,
                    TipoDoc = c.TipoDocumento,
                    Nombres = c.Nombres,
                    PrimerApellido = c.PrimerApellido,
                    SegundoApellido = c.SegundoApellido,
                    sexo = c.Sexo,
                    FechaNacimiento = c.FechaNacimiento,
                    Municipio = c.IdMunicipio,
                    AñoActa = c.AnoActa,
                    NumeroActa = c.NumeroActa,
                    FolioActa = c.FolioActa,
                    LibroActa = c.LibroActa,
                    OficialiaActa = c.OficialiaActa
                };
            return data.ToList();
        }
        public DataTable GetNssEvaluacion(string solicitud, string tipo, int pageNum, int pageSize)
        {
            try
            {
                var result = SuirPlus.Empresas.Consultas.getSolicitudEvaluacionVisual(solicitud, tipo, pageNum, pageSize);
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public class Grid
        {
            public int? Nss { get; set; }
            public string Identificador { get; set; }
            public string Expediente { get; set; }
            public int registro { get; set; }
            public string NroDocumento { get; set; }
            public string Nombres { get; set; }
            public string PrimerApellido { get; set; }
            public string SegundoApellido { get; set; }
            public string sexo { get; set; }
            public System.Nullable<DateTime> FechaNacimiento { get; set; }
            public string Municipio { get; set; }
            public string AñoActa { get; set; }
            public string NumeroActa { get; set; }
            public string FolioActa { get; set; }
            public string LibroActa { get; set; }
            public string OficialiaActa { get; set; }
            public byte[] Imagen { get; set; }
            public int Solicitud { get; set; }
            public DateTime FechaSolicitud { get; set; }
            public string TipoSolicitud { get; set; }
            public string ErrorDes { get; set; }
            public string IdTipoDoc { get; set; }
            public string TipoDoc { get; set; }
            public string Nacionalidad { get; set; }
            public string Ars { get; set; }
            public string Apellidos

            {
                get
                {
                    return PrimerApellido + " " + SegundoApellido;
                }
            }
            public string NumeroDocumento
            {
                get
                {
                    return IdTipoDoc + "-" + NroDocumento;
                }
            }


        }

        /// <summary>
        /// Metodo para asignar un nuevo nss a un solicitante
        /// </summary>
        /// <param name="IdDetalleSolicitud"></param>
        /// <param name="ult_usuario_act"></param>
        public void NSSInsertarCiudadano(int IdDetalleSolicitud, string ult_usuario_act)
        {
            //para pasar parametros a un stored procedure oracle, se necesita definirlos como se muestra a continuación.
            try
            {
                //parametros de entrada
                OracleParameter[] arrParam = new OracleParameter[3];

                arrParam[0] = new OracleParameter("p_id_registro", OracleDbType.Int32);
                arrParam[0].Value = IdDetalleSolicitud;

                arrParam[1] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2);
                arrParam[1].Value = ult_usuario_act;

                arrParam[2] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 500);
                arrParam[2].Direction = ParameterDirection.InputOutput;

                OracleDbContext db = new OracleDbContext();
                db.Database.ExecuteSqlCommand("declare p_sre_ciudadano SRE_CIUDADANOS_T%ROWTYPE; begin NSS_INSERTAR_CIUDADANO(:p_id_registro,p_sre_ciudadano,:p_ult_usuario_act,:p_resultado); end;", arrParam);

                if (arrParam[2].Value.ToString() != "OK")
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Metodo para actualizar los datos del ciudadano con los datos de la junta
        /// </summary>
        /// <param name="IdDetalleSolicitud"></param>
        /// <param name="ult_usuario_act"></param>
        public void NSSActualizarCiudadano(int IdDetalleSolicitud, string ult_usuario_act, int nss)
        {
            try
            {
                OracleParameter[] arrParam = new OracleParameter[4];

                arrParam[0] = new OracleParameter("p_nss", OracleDbType.Int32);
                arrParam[0].Value = nss;

                arrParam[1] = new OracleParameter("p_id_registro", OracleDbType.Int32);
                arrParam[1].Value = IdDetalleSolicitud;

                arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2);
                arrParam[2].Value = ult_usuario_act;

                arrParam[3] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 500);
                arrParam[3].Direction = ParameterDirection.InputOutput;

                OracleDbContext db = new OracleDbContext();
                db.Database.ExecuteSqlCommand("declare p_sre_ciudadano SRE_CIUDADANOS_T%ROWTYPE; begin p_sre_ciudadano.id_nss := :p_nss; NSS_ACTUALIZAR_CIUDADANO(:p_id_registro,p_sre_ciudadano,:p_ult_usuario_act,:p_resultado); end;", arrParam);

                if (arrParam[3].Value.ToString() != "OK")
                {
                    throw new Exception(arrParam[3].Value.ToString());
                }
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        /// <summary>
        /// Metodo para rechazar o actualizar una solicitud
        /// </summary>
        /// <param name="IdDetalleSolicitud"></param>
        /// <param name="IdStatus"></param>
        /// <param name="IdError"></param>
        /// <param name="IdNss"></param>
        /// <param name="ult_usuario_act"></param>
        public void NSSRechazarSolicitud(int IdDetalleSolicitud, int IdStatus, string IdError, int IdNss, string ult_usuario_act)
        {
            try
            {
                OracleParameter[] arrParam = new OracleParameter[6];

                arrParam[0] = new OracleParameter("p_id_registro", OracleDbType.Int32);
                arrParam[0].Value = IdDetalleSolicitud;

                arrParam[1] = new OracleParameter("p_id_estatus", OracleDbType.Int32);
                arrParam[1].Value = IdStatus;

                arrParam[2] = new OracleParameter("p_id_error", OracleDbType.Varchar2);
                arrParam[2].Value = IdError;

                arrParam[3] = new OracleParameter("p_id_nss", OracleDbType.Int32);
                if (IdNss > 0)
                {
                    arrParam[3].Value = IdNss;
                }
                else
                {
                    arrParam[3].Value = DBNull.Value;
                }


                arrParam[4] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2);
                arrParam[4].Value = ult_usuario_act;

                arrParam[5] = new OracleParameter("p_resultado", OracleDbType.NVarchar2, 500);
                arrParam[5].Direction = ParameterDirection.InputOutput;

                OracleDbContext db = new OracleDbContext();
                db.Database.ExecuteSqlCommand("begin NSS_ACTUALIZAR_SOLICITUD(:p_id_registro,:p_id_estatus,:p_id_error,:p_id_nss,:p_ult_usuario_act,:p_resultado); end;", arrParam);

                if (arrParam[5].Value.ToString() != "OK")
                {
                    throw new Exception(arrParam[5].Value.ToString());
                }

            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }
    }
}