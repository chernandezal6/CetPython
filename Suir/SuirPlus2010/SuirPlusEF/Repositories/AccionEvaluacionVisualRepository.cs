using SuirPlusEF.Models;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{

    public class AccionEvaluacionVisualRepository : Framework.BaseObject<Models.AccionEvaluacionVisual>, Framework.IBaseRepository<Models.AccionEvaluacionVisual>
    {
        public AccionEvaluacionVisualRepository() : base() { }
        public AccionEvaluacionVisualRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public AccionEvaluacionVisual GetById(int id)
        {
            throw new NotImplementedException();
        }        

        public IList GetAllAccion()
        {
            var query = (from t in db.AccionEvaliacionVisual
                         orderby t.Descripcion ascending
                         select new { t.IdAccion, t.Descripcion });
            return query.ToList();
        }
    }
}
