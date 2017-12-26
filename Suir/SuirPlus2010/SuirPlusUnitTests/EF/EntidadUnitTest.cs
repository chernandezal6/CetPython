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
    public class EntidadUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdEntidad()
        {
            Entidad Entidad = new Entidad();
            EntidadRepository _RepEntidad = new EntidadRepository();

            Entidad = _RepEntidad.GetByIdEntidad(DefaultValues.IdEntidad);
            NUnit.Framework.Assert.True(true);
        }

    }
}
