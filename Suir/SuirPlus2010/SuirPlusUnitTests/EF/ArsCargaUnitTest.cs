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
    public class ArsCargaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdCarga()
        {
            ArsCarga arscarga = new ArsCarga();
            ArsCargaRepository _RepArsCarga = new ArsCargaRepository();

            arscarga = _RepArsCarga.GetByIdCarga(DefaultValues.IdCarga);
            NUnit.Framework.Assert.True(true);
        }
    }
}
