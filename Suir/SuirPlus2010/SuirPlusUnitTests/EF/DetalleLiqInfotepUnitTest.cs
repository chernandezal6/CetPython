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
    public class DetalleLiqInfotepUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdReferenciaInfotep()
        {
            DetalleLiquidacionInfotep DetLiqInfotep = new DetalleLiquidacionInfotep();
            DetalleLiquidacionInfotepRepository _RepDetLipInfotep = new DetalleLiquidacionInfotepRepository();

            DetLiqInfotep = _RepDetLipInfotep.GetByIdReferenciaInfotep(DefaultValues.IdReferenciaTSS);
            NUnit.Framework.Assert.True(true);
        }
    }
}
