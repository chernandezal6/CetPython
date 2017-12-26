using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Framework
{
    public class BaseDocument<T> where T : class
    {
        private string myNumero { get; set; }

        public TipoDocumentoEnum TipoDocumento { get; set; }

        public BaseDocument(string numero) {

            this.myNumero = numero;

        }

        public string NumeroSinGuiones()
        {
            String doc = myNumero;
            doc = doc.Replace("-", String.Empty);

            //TODO: Falta validar la longitud y devolver ex.

            return doc;
        }

        public string NumeroConGuiones()
        {
            String doc = myNumero;
            doc = doc.Replace("-", String.Empty);

            doc = $"{doc.Substring(0, 3)}-{doc.Substring(3,7)}-{doc.Substring(10,1)}";

            //TODO: Falta validar la longitud y devolver ex.

            return doc;
        }

    }
    
    public enum TipoDocumentoEnum
    {
        NSS = 1,
        Cedula = 2,
        NUI = 3,
        Pasaporte = 4,
        CarnetDGM = 5

    }
}
