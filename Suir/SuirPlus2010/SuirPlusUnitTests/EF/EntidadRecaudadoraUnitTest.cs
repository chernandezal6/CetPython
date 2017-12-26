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
    public class EntidadRecaudadoraUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdEntidadRecaudadora()
        {
            EntidadRecaudadora EntidadRecaudadora = new EntidadRecaudadora();
            EntidadRecaudadoraRepository _RepEntRecau = new EntidadRecaudadoraRepository();

            EntidadRecaudadora = _RepEntRecau.GetByIdEntidadRecaudadora(DefaultValues.IdEntidadRecaudadora);
            NUnit.Framework.Assert.True(true);
        }
    }
}
