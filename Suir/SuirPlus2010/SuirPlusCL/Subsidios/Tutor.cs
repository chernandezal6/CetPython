using System;
using System.Collections.Generic;
using System.Linq;
using SuirPlus.DataBase;
using System.Data;
using Oracle.ManagedDataAccess.Client; 
namespace SuirPlus.Subsidios
{
    public class Tutor : FrameWork.Objetos    
    {

        public int NSS { get; set; }
        public string Telefono { get; set; }
        public string Email { get; set; }
        public string CuentaBanco { get; set; }

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
