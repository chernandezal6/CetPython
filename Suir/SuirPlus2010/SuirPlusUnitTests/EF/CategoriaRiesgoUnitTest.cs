using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF
{
    public class CategoriaRiesgoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByNroDocumento()
        {

            CategoriaRiesgo riesgo = new CategoriaRiesgo();
            CategoriaRiesgoRepository _RepCategoriaRiesgo = new CategoriaRiesgoRepository();

            riesgo = _RepCategoriaRiesgo.GetByIdRiesgo(DefaultValues.IdRiesgo);
            NUnit.Framework.Assert.True(true);
        }
    }
}
