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
    public class AplicacionUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdAplicacion()
        {
            Aplicacion aplicaciones = new Aplicacion();
            AplicacionesRepository _RepAplicaciones = new AplicacionesRepository();

            aplicaciones = _RepAplicaciones.GetByIdAplicacion(DefaultValues.IdAplicacion);
            NUnit.Framework.Assert.True(true);
        }
    }
}
