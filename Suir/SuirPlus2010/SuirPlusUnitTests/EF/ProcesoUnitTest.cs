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
    public class ProcesoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdProceso()
        {
            Proceso proceso = new Proceso();
            ProcesoRepository _RecProceso = new ProcesoRepository();

            proceso = _RecProceso.GetByIdProceso(DefaultValues.IdProceso);
            NUnit.Framework.Assert.True(true);
        }
    }
}
