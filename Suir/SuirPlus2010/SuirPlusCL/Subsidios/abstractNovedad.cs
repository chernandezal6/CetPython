using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SuirPlus.DataBase;
using System.Data;

namespace SuirPlus.Subsidios
{
    public abstract class abstractNovedad: FrameWork.Objetos
    {
       
        public Solicitud Solicitud { get; set; }

        public int id { get; set; }
        public int NSS { get; set; }
        public int Secuencia { get; set; }

        public int RegistroPatronal { get; set; }

        public DateTime FechaRegistro { get; set; }
        
        public DateTime FechaUltimaAct { get; set; }

        public string UltimoUsrAct { get; set; }

        public DateTime Fecha_Registro_Mod { get; set; }

        public String Retroactiva { get; set; }

        public override void CargarDatos()
        {
            throw new NotImplementedException();
        }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            throw new NotImplementedException();
        }

    }
}
