using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class CarnetDGMRepository : Framework.BaseObject<Models.CarnetDGM>, Framework.IBaseRepository<Models.CarnetDGM>
    {
        public CarnetDGMRepository() : base() { }
        public CarnetDGMRepository(Framework.OracleDbContext context) : base(context) { }

        public CarnetDGM GetByIdCarnet(int id)
        {
            return db.CarnetDGM.FirstOrDefault(x => x.Id == id);
        }

        public CarnetDGM GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
