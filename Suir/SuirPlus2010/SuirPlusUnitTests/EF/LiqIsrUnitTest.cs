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
    public class LiqIsrUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdRefISR()
        {
            LiquidacionISR liqISR = new LiquidacionISR();
            LiquidacionISRRepository _RepLiqISR = new LiquidacionISRRepository();

            liqISR = _RepLiqISR.GetIdReferenciaISR(DefaultValues.IdReferenciaISR);
            NUnit.Framework.Assert.True(true);
        }
    }
}
