using SuirPlusEF.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class NacionalidadRepository : Framework.BaseObject<Models.Nacionalidad>, Framework.IBaseRepository<Models.Nacionalidad>
    {
        public NacionalidadRepository() : base() { }
        public NacionalidadRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Nacionalidad GetById(int id)
        {
            throw new NotImplementedException();
        }

        public Nacionalidad GetByIdNacionalidad(string IdNacionalidad)
        {
            return db.Nacionalidad.FirstOrDefault(x => x.IdNacionalidad == IdNacionalidad);
        }

        public IList GetAllNacionalidad()
        {
            var query = (from t in db.Nacionalidad 
                         orderby t.Descripcion ascending
                         select new { t.IdNacionalidad, t.Descripcion });
            return query.ToList();
        }
    }
}
