using SuirPlusEF.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.GenericModels
{
    public class DocumentoNUI : BaseDocument<DocumentoNUI>
    {

        public DocumentoNUI(string numero) : base(numero)
        {
            this.TipoDocumento = TipoDocumentoEnum.NUI;
        }
        

    }
}
