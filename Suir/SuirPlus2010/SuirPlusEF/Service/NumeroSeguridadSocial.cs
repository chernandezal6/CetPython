using SuirPlusEF.Framework;
using SuirPlusEF.GenericModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Service
{
    public class NumeroSeguridadSocial:BaseModel
    {
        public NumeroSeguridadSocial() {
        }

        public override int AssignId(int id)
        {
            //este metodo es requerido para esta clase
            return 0;
        }

        public DocumentoNSS Crear(string tipoDocumento) {
            string myNSS = string.Empty;
            //buscamos la secuencia correspondiente segun el tipo de documento enviado
            switch (tipoDocumento)
            {                
                case "C": case "U": case "N": case "E":
                    this.myOracleSequenceName = "SRE_NSS_CIUDADANOS_SEQ";
                    break;

                case "P":
                    this.myOracleSequenceName = "SRE_NSS_EXTRANJEROS_SEQ";
                    break;

                case "T":
                    this.myOracleSequenceName = "SRE_NSS_TITULAR_SEQ";
                    break;

                default:
                    break;
            }
            if (this.myOracleSequenceName != string.Empty ) {
                this.GetNextSequence();
                if (this.myOracleNextSequence > 0) {               
                    //rellenamos con ceros a la izquierda
                    var nss = this.myOracleNextSequence.ToString().PadLeft(8,'0');
                    //buscamos el digito verificador
                    myNSS = nss + getDigitoVerificador(nss).ToString();
                }                
            }

            return new DocumentoNSS(myNSS);

        }
        private Int32 getDigitoVerificador(string nssSequence)
        {
            var valor = (Convert.ToInt32(nssSequence.Substring(0, 1)) * 4) + (Convert.ToInt32(nssSequence.Substring(1, 1)) * 5) +
                        (Convert.ToInt32(nssSequence.Substring(2, 1)) * 2) + (Convert.ToInt32(nssSequence.Substring(3, 1)) * 3) +
                        (Convert.ToInt32(nssSequence.Substring(4, 1)) * 7) + (Convert.ToInt32(nssSequence.Substring(5, 1)) * 9) +
                        (Convert.ToInt32(nssSequence.Substring(6, 1)) * 2) + (Convert.ToInt32(nssSequence.Substring(7, 1)) * 6);

            var digitoVerificador = valor % 9;

            return digitoVerificador;
        }
        
    }
}
