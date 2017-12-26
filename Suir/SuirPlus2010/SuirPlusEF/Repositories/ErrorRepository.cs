using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class ErrorRepository : Framework.BaseObject<Error>,Framework.IBaseRepository<Error>
    {
        public Error GetById(int id)
        {
            throw new NotImplementedException();
        }

        public Error GetByIdError(string id) {
            return db.Errores.FirstOrDefault(x => x.IdError == id);
        }

    }
}
