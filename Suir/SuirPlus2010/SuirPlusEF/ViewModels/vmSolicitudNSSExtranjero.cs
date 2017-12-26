using iTextSharp.text;
using SuirPlusEF.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.ViewModels
{
    public class vmSolicitudNSSExtranjero
    {
        public string TipoDocumento { get; set; }
        public string NoDocumento { get; set; }
        public string Nombres { get; set; }
        public string PrimerApellido { get; set; }
        public string SegundoApellido { get; set; }
        public DateTime FechaNacimiento { get; set; }
        public string IdNacionalidad { get; set; }
        public string Sexo { get; set; }
        public byte[] Imagen { get; set; }

    }
}
