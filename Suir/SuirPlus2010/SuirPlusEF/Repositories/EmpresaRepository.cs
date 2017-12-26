using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Repositories
{
    public class EmpresaRepository : Framework.BaseObject<Models.Empresa>, Framework.IBaseRepository<Models.Empresa>
    {

        public EmpresaRepository() : base() { }
        public EmpresaRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public Empresa GetById(int id) {
            throw new NotImplementedException();
        }

        //public Empresa GetByRNC(string RncCedula) {
        //    return db.Empresas.FirstOrDefault(x => x.RncCedula == RncCedula);
        //}

        public Empresa GetByRegistroPatronal(int? RegistroPatronal) {
            return db.Empresas.FirstOrDefault(x => x.IdRegistroPatronal == RegistroPatronal);
        }
    }
}
