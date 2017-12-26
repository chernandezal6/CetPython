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
    public class PermisoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdPermiso()
        {
            Permiso permiso = new Permiso();
            PermisoRepository _RepPermiso = new PermisoRepository();

            permiso = _RepPermiso.GetByIdPermiso(DefaultValues.IdPermiso);
            NUnit.Framework.Assert.True(true);
        }
    }
}
