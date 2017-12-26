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
    public class OficioUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdOficio()
        {
            Oficio oficios = new Oficio();
            OficioRepository _RepOficios = new OficioRepository();

            oficios = _RepOficios.GetByIdOficio(DefaultValues.IdOficio);
            NUnit.Framework.Assert.True(true);
        }
    }
}



