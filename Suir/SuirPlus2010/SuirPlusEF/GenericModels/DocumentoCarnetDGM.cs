using SuirPlusEF.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.GenericModels
{
    public class NroExpediente : BaseDocument<NroExpediente>
    {
        public NroExpediente(string numero) : base(numero)
        {
            this.TipoDocumento = TipoDocumentoEnum.CarnetDGM;
        }
    }
}
