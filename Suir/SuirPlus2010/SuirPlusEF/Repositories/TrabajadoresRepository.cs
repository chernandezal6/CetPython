using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;
using System.Security.Cryptography;

namespace SuirPlusEF.Repositories
{
    public class TrabajadoresRepository : Framework.BaseObject<Models.Trabajador>, Framework.IBaseRepository<Models.Trabajador>
    {
        public TrabajadoresRepository() : base() { }
        public TrabajadoresRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Trabajador GetById(int id)
        {
            return db.Trabajadores.FirstOrDefault();
        }


    }
}
