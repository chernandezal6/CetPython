using System;
using System.Collections.Generic;
using System.Linq;
using SuirPlusEF.Models;
using System.Data;
using Oracle.ManagedDataAccess.Client;

namespace SuirPlusEF.Repositories
{
    public class SolicitudNSSRepository : Framework.BaseObject<SolicitudNSS>, Framework.IBaseRepository<SolicitudNSS>
    {
        public SolicitudNSSRepository() : base() { }
        public SolicitudNSSRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public SolicitudNSS GetById(int id)
        {
            Console.WriteLine("Mi nueva solicitud es: " + id);
            return db.SolicitudesNSS.FirstOrDefault(x => x.IdSolicitud == id);
        }
        public DetalleSolicitudes GetSolicitudProcesada(string nro_documento, string tipo)
        {
            return db.DetalleSolicitudes.FirstOrDefault(x => x.Documento == nro_documento && (x.IdEstatus == 2 || x.IdEstatus == 3 || x.IdEstatus == 7) && x.IdNSSAsignado.HasValue && x.IdTipoDocumento == tipo);
        }
        public DetalleSolicitudes GetSolicitudNss(int nss)        {            
            return db.DetalleSolicitudes.FirstOrDefault(x => x.IdNSSAsignado == nss);
        }        
        public class Grid
        {
            public Int32 Solicitud { get; set; }           
            public DateTime FechaSolicitud { get; set; }
            public string Estatus { get; set; }
            public string Nombres { get; set; }
            public string PrimerApellido { get; set; }
            public string SegundoApellido { get; set; }
            public string Sexo { get; set; }
            public System.Nullable<DateTime> FechaNacimiento { get; set; }
            public string TipoDoc { get; set; }
            public string NroDoc { get; set; }
            public string Expediente { get; set; }
            public Int32? Nss { get; set; }
            public string TipoSolicitud { get; set; }
            public string NombreUsuario { get; set; }
            public string ApellidoUsuario { get; set; }
            public string MotivoRechazo { get; set; }
            public Int32? NumeroControl { get; set; }
            public Int32? IdControl { get; set; }
            public byte[] Imagen { get; set; }
            public Int32? Certificacion { get; set; }


            public string UsuarioSolicita
            {
                get
                {
                    return NombreUsuario + " " + ApellidoUsuario ;
                }
            }
            public string Apellidos
            {
                get
                {
                    return PrimerApellido + " " + SegundoApellido;
                }
            }
        }
        public DataTable GetSolicitud(string solicitud, string tipo_documento, string nro_documento, string lote, string registro, int pageNum, int pageSize )
        {
            try
            {
                var result = SuirPlus.Empresas.Consultas.getSolicitudNSS(solicitud, tipo_documento, nro_documento, lote, registro, pageNum, pageSize);
                return result;
            }
            catch (Exception ex) {
                throw ex;
            }
         

        }

        public DataTable GetSolicitudRnc(string Rnc, string Estatus, string FechaDesde, string FechaHasta, int pageNum, int pageSize)
        {
            try
            {
                var result = SuirPlus.Empresas.Consultas.getSolicitudRnc(Rnc, Estatus,FechaDesde, FechaHasta, pageNum, pageSize);
                return result;
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }
    }    
}