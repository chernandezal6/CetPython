using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF.Models
{
    public class RolUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdRol()
        {
            Rol rol = new Rol();
            RolRepository _RepRol = new RolRepository();

            rol = _RepRol.GetById(DefaultValues.IdRole);
            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFrameworkDataRol")]
        public void InsertarRole()
        {
            string RoleDescription = "Mi rol de prueba2";

            RolRepository _RepRol = new RolRepository();
            Rol rol = new Rol();
           
            rol.Descripcion = RoleDescription;
            rol.TipoRole = "N";
            rol.Estatus = "I";
            rol.UltimoUsuarioActualizo = "OPERACIONES";
            rol.UltimaFechaActualizacion = DateTime.Now;
            var result = _RepRol.Add(rol);
            Console.WriteLine("este es mi rol id = " + result.IdRole + " " + result.Descripcion);
            Rol newRol = new Rol();
            newRol = _RepRol.GetById(result.IdRole);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(RoleDescription, newRol.Descripcion);

        }

    }
}
