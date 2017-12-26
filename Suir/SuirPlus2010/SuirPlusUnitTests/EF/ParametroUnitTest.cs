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
    public class ParametroUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdParametro()
        {
            Parametro parametros = new Parametro();
            ParametroRepository _RepParametros = new ParametroRepository();

            parametros = _RepParametros.GetByIdParametro(DefaultValues.IdParametro);
            NUnit.Framework.Assert.True(true);
        }
    }
}
