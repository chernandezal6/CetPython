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
    public class NominaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdNomina()
        {

            Nomina nomina = new Nomina();
            NominaRepository _RepNominas = new NominaRepository();

            nomina = _RepNominas.GetByIdNomina(DefaultValues.IdNomina); 
            NUnit.Framework.Assert.True(true);
        }
    }
}
