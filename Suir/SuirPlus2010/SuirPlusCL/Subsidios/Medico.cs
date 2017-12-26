using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuirPlus.Empresas.SubsidiosSFS;
using System.Data;

namespace SuirPlus.Subsidios
{
    public class Medico
    {

        private String direccionMedico;

        public String DireccionMedico
        {
            get { return direccionMedico; }
            set 
            {
                direccionMedico = value; 
            }
        }

        private String telefonoMedico;

        public String TelefonoMedico
        {
            get { return telefonoMedico; }
            set 
            {
                telefonoMedico = value; 
            }
        }
                

        public Int32? PSS_Med { get; set; }
        public String NoDocumentoMedico { get; set; }
        public String NombreMedico { get; set; }
        public String emailMedico { get; set; }
        public String celularMedico { get; set; }
        public String Exequatur { get; set; }

        public static Medico ObtenerDetalleMedico(String cedula) 
        {
            try
            {
                var medico = SuirPlus.Empresas.SubsidiosSFS.EnfermedadComun.getMedico(cedula);   
                
                if (medico.Rows.Count > 0)
                {
                    var detallemedico = new Medico() 
                    {
                        PSS_Med = medico.Rows[0].Field<Int32?>("Nro_Medico"),
                        NombreMedico = medico.Rows[0].Field<String>("NOMBRES_MED"),
                        NoDocumentoMedico = medico.Rows[0].Field<String>("CEDULA_MED"),
                        TelefonoMedico = String.IsNullOrEmpty(medico.Rows[0].Field<String>("TEL_MED")) ? String.Empty : medico.Rows[0].Field<String>("TEL_MED"),
                        celularMedico = String.IsNullOrEmpty(medico.Rows[0].Field<String>("CEL_MED")) ? String.Empty : medico.Rows[0].Field<String>("CEL_MED"),
                        DireccionMedico = String.IsNullOrEmpty(medico.Rows[0].Field<String>("CEL_MED")) ? String.Empty : medico.Rows[0].Field<String>("CEL_MED")
                    };
                    return detallemedico;
                }

                Medico med = null;

                return med;

            }
            catch (Exception ex)
            {
                
                throw;
            }
        }

    }
}