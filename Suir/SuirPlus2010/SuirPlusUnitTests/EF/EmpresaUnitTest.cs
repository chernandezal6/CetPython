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
    public class EmpresaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByRNC()
        {
            Empresa empresa = new Empresa();
            EmpresaRepository _RepEmpresa = new EmpresaRepository();

            empresa = _RepEmpresa.GetByRegistroPatronal(DefaultValues.IdRegistroPatronal);
            NUnit.Framework.Assert.True(true);
        }
    }
}
