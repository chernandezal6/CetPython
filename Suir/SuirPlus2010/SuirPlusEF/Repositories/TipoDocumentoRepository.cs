using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;
using System.Collections;

namespace SuirPlusEF.Repositories
{
    public class TipoDocumentoRepository : Framework.BaseObject<Models.TipoDocumento>, Framework.IBaseRepository<Models.TipoDocumento> 
    {
        public TipoDocumentoRepository() : base() { }
        public TipoDocumentoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public TipoDocumento GetByIdTipoDocumento(string id)
        {
            return db.TipoDocumentos.FirstOrDefault(x => x.IdTipoDocumento == id);
        }
        public TipoDocumento GetById(int id)
        {
            throw new NotImplementedException();
        }
        // El parametro Extanjero es para especificar si el tipo de documento es de un extranjero o un nacional los valores son "S" o "N"
        public IList GetAllTipoDocumento()
        {
            var query = (from t in db.TipoDocumentos
                    where new[] { "G", "V", "I", }.Contains(t.IdTipoDocumento)
                         select new { t.IdTipoDocumento,t.Descripcion });

            return query.ToList();
        }
        public IList GetTipoDocumentoAsig()
        {
            var query = (from t in db.TipoDocumentos


                         where new[] { "G", "V", "I", "C", "U" }.Contains(t.IdTipoDocumento)
                         select new { t.IdTipoDocumento, t.Descripcion });

            return query.ToList();
        }
        public IList GetAllTipoDocumento1()
        {
            var query = (from t in db.TipoDocumentos
                         where new[] { "C", "U" }.Contains(t.IdTipoDocumento)
                         select new { t.IdTipoDocumento, t.Descripcion });

            return query.ToList();
        }
        public string GetTipoMascara(string tipo)
        {           
            var tipoDoc = (from t in db.TipoDocumentos
                           where t.IdTipoDocumento == tipo
                           select new { t.Mascara});

            return tipoDoc.ToString();
        }
        public IList GetAllTiposDocumento()
        {
            var query = (from t in db.TipoDocumentos
                         select new { t.IdTipoDocumento, t.Descripcion });

            return query.ToList();
        }
    }
}
