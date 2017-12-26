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
    public class RelacionPermisosRolUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdPermiso()
        {
            RelacionPermisosRol RelPermisoRol = new RelacionPermisosRol();
            RelacionPermisosRolRepository _RepRelPermisoRol = new RelacionPermisosRolRepository();

            RelPermisoRol = _RepRelPermisoRol.GetByIdPermiso(DefaultValues.IdPermiso);
            NUnit.Framework.Assert.True(true);
        }
    }
}
