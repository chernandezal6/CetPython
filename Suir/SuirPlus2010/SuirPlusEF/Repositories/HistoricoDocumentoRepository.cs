using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.Models;

namespace SuirPlusEF.Repositories
{
    public class HistoricoDocumentoRepository : Framework.BaseObject<HistoricoDocumento>, Framework.IBaseRepository<HistoricoDocumento>
    {
        public HistoricoDocumentoRepository() : base() { }
        public HistoricoDocumentoRepository(Framework.OracleDbContext contexto) : base(contexto) { }

        public HistoricoDocumento GetByIdHistoricoDocumento(int id)
        {
            return db.HistoricoDocumentos.FirstOrDefault(x => x.Id == id);
        }

        public HistoricoDocumento GetByNroExpediente(string NroExpediente, string tipoDocumento, ref int existe)
        {
            existe = db.HistoricoDocumentos.Count(y => y.No_Documento == NroExpediente && y.Tipo_Documento == tipoDocumento);
            if (existe > 0)
            {
                var his = db.HistoricoDocumentos.FirstOrDefault(x => x.No_Documento == NroExpediente && x.Tipo_Documento == tipoDocumento);
                return his;
            }
            else
            {
                return null;
            }
        }

        public HistoricoDocumento GetById(int id)
        {
            throw new NotImplementedException();
        }
    }
}
