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
    public class NacionalidadUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdAplicacion()
        {
            Nacionalidad nacionalidades = new Nacionalidad();
            NacionalidadRepository _RepAplicaciones = new NacionalidadRepository();

            nacionalidades = _RepAplicaciones.GetByIdNacionalidad(DefaultValues.IdNacionalidad);
            NUnit.Framework.Assert.True(true);
        }
        [Test]
        [Category("EntityFrameworkData")]
        public void GetAllNacionalidades()
        {
            NacionalidadRepository _RepNacionalidad = new NacionalidadRepository();
            NUnit.Framework.Assert.Greater(_RepNacionalidad.GetAllNacionalidad().Count, 0);
        }
    }
}
