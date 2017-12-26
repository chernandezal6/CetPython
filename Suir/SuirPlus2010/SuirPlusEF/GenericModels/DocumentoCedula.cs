using SuirPlusEF.Framework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.GenericModels
{
    public class DocumentoCedula : BaseDocument<DocumentoCedula>
    {

        public DocumentoCedula(string numero) : base(numero)
        {
            this.TipoDocumento = TipoDocumentoEnum.Cedula;
        }

        /// <summary>
        /// Primero 3 numeros de la cedula
        /// </summary>
        /// <returns></returns>
        public string Municipio() {
            return this.NumeroSinGuiones().Substring(0, 3);
        }

        /// <summary>
        /// Los numeros del medio de la cedula
        /// </summary>
        /// <returns></returns>
        public string Numero() {
            return this.NumeroSinGuiones().Substring(3, 7);
        }

        /// <summary>
        /// El digito verificador de la cedula
        /// </summary>
        /// <returns></returns>
        public string DigitoVerificador() {
            return this.NumeroSinGuiones().Substring(10, 1);
        }

    }
}
