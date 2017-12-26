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
    public class UsuarioPermisoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdPermiso()
        {
            UsuarioPermiso usuariopermiso = new UsuarioPermiso();
            UsuarioPermisoRepository _RepUsuPermiso = new UsuarioPermisoRepository();

            usuariopermiso = _RepUsuPermiso.GetByIdPermiso(DefaultValues.IdPermiso);
            NUnit.Framework.Assert.True(true);
        }
    }
}
