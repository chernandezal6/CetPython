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
    public class ProvinciaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdAplicacion()
        {
            Provincia provincias = new Provincia();
            ProvinciaRepository _RepProvincias = new ProvinciaRepository();

            provincias = _RepProvincias.GetByIdProvincia(DefaultValues.IdProvincia);
            NUnit.Framework.Assert.True(true);
        }
    }
}
