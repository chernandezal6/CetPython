using System.Linq;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class DetalleParametroRepository: Framework.BaseObject<Models.DetalleParametro>, Framework.IBaseRepository<Models.DetalleParametro>
    {
        public DetalleParametroRepository() : base() { }
        public DetalleParametroRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public DetalleParametro GetById(int id)
        {
            return db.DetalleParametro.FirstOrDefault(x => x.IdParametro == id);
        }

        public DetalleParametro GetByIdActivo(int id)
        {
            return db.DetalleParametro.FirstOrDefault(x => x.IdParametro == id && x.FechaFin.HasValue == false);
        }
    }
}
