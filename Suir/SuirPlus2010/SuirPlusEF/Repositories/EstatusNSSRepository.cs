using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Framework;
using SuirPlusEF.Models;
using System.Collections;

namespace SuirPlusEF.Repositories
{
    public class EstatusNSSRepository : Framework.BaseObject<Models.EstatusNSS>, Framework.IBaseRepository<Models.EstatusNSS>
    {
        public EstatusNSSRepository() : base() { }
        public EstatusNSSRepository(Framework.OracleDbContext context) : base(context) { }

        public EstatusNSS GetById(int id)
        {
            return db.EstatusNSS.FirstOrDefault(x => x.IdEstatus == id);
        }

        public IList GetAllEstatus()
        {
            var query = (from t in db.EstatusNSS
                         select new { t.IdEstatus, t.DESCRIPCION });

            return query.ToList();
        }

    }
}
