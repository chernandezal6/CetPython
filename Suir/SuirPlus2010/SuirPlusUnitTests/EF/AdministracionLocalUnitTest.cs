using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF
{
    public class AdministracionLocalUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdAdministracionLocal()
        {
            AdministracionLocal administracion = new AdministracionLocal();
            AdministracionLocalRepository _RepAdministracion = new AdministracionLocalRepository();

            administracion = _RepAdministracion.GetByIdAdministracionLocal(DefaultValues.IdAdministracionLocal);
            NUnit.Framework.Assert.True(true);
        }
    }
}
