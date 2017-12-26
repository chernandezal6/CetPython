using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SuirPlus.Subsidios
{
    public class Prestadora
    {
        public Int32 idPssCentro { get; set; }
        public String nombreCentro { get; set; }

        private String direccionCentro;

        public String DireccionCentro
        {
            get { return direccionCentro; }
            set 
            {
                if (String.IsNullOrEmpty(value))
                {
                    throw new ArgumentNullException("La dirección del centro es requerida."); 
                }


                direccionCentro = value;
            }
        }

        private String telefonoCentro;

        public String TelefonoCentro
        {
            get { return telefonoCentro; }
            set 
            {
                if (String.IsNullOrEmpty(value))
                {
                    throw new ArgumentNullException("el telefono del centro es requerido.");
                }
                telefonoCentro = value; 
            }
        }

       
        public String faxCentro { get; set; }
        public String emailCentro { get; set; }
    }
}
