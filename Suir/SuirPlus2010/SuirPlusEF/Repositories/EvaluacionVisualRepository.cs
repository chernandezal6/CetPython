using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class EvaluacionVisualRepository : Framework.BaseObject<EvaluacionVisual>, Framework.IBaseRepository<EvaluacionVisual>
    {
        public EvaluacionVisualRepository() : base() { }
        public EvaluacionVisualRepository(Framework.OracleDbContext context) : base(context) { }

        public EvaluacionVisual GetByIdEvaluacion(int Id)
        {
            return db.EvaluacionVisuales.FirstOrDefault(x => x.IdEvaluacionVisual == Id);
        }

        public EvaluacionVisual GetById(int id)
        {
            throw new NotImplementedException();
        }

        public EvaluacionVisual GetByNroDocumentoEnCola(string documento)
        {

            EvaluacionVisual ev = new EvaluacionVisual();
           // ev = db.EvaluacionVisuales.FirstOrDefault(x => x.IdRegistro == idDetalleEvaluacionVisual && x.Estatus == "PE");
            return ev;
        }
    }
}
