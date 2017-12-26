using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class DetalleSolicitudesRepository : Framework.BaseObject<Models.DetalleSolicitudes>, Framework.IBaseRepository<Models.DetalleSolicitudes>
    {
        public DetalleSolicitudesRepository() : base() { }
        public DetalleSolicitudesRepository(Framework.OracleDbContext context) : base(context) { }

        public DetalleSolicitudes GetBySolicitud(int id)
        {        

            return db.DetalleSolicitudes.FirstOrDefault(x => x.IdSolicitud == id);
        }

        public DetalleSolicitudes GetByRegistro(int id)
        {

            return db.DetalleSolicitudes.FirstOrDefault(x => x.IdRegistro == id);
        }

        public DetalleSolicitudes GetBySolicitudExpediente(string Expediente)
        {
            return db.DetalleSolicitudes.FirstOrDefault(x => x.Documento == Expediente);
        }

        public List<Grid> GetBySolicitudExpediente1(string Expediente)
        {
          
            var query = from ds in db.DetalleSolicitudes
                        join e in db.EstatusNSS on ds.estatus.IdEstatus equals e.IdEstatus                                                 
                        join td in db.TipoDocumentos on ds.IdTipoDocumento equals td.IdTipoDocumento
                        where ds.Documento == Expediente 
                        select new Grid
                        {
                          Documento = ds.Documento,
                          Tipo = ds.TipoDocumento.Descripcion.ToUpper(),
                          Nombres = ds.Nombres.ToUpper(),
                          PrimerApellido = ds.PrimerApellido.ToUpper(),
                          SegundoApellido = ds.SegundoApellido.ToUpper(),
                          Sexo = ds.Sexo,
                          FechaNacimiento =  ds.FechaNacimiento,
                          Estatus = e.DESCRIPCION.ToUpper(),
                          NSS =  ds.IdNSSAsignado
                        };
            return query.ToList();
        }       

        public DetalleSolicitudes GetById(int id)
        {
            throw new NotImplementedException();
        }
    }

    public class Grid {
        public string Documento { get; set;}
        public string Tipo { get; set; }
        public string Nombres { get; set; }
        public string PrimerApellido { get; set; }
        public string SegundoApellido { get; set; }
        public string Sexo { get; set; }
        public System.Nullable<DateTime> FechaNacimiento { get; set; }
        public string Estatus { get; set; }
        public Int32? NSS { get; set; }
        

        public string Apellidos { get {
                return PrimerApellido + " " + SegundoApellido;
            } }
    }

}
