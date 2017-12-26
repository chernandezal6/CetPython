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
    public class AccionUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdAccion()
        {
            Accion acciones = new Accion();
            AccionRepository _RepAcciones = new AccionRepository();

            acciones = _RepAcciones.GetByIdAccion(DefaultValues.IdAccion);
            NUnit.Framework.Assert.True(true);
        }
    }
}


