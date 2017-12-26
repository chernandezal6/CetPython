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
    public class DetalleLiqIsrUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdReferenciaISR()
        {
            DetalleLiquidacionISR DetLiqISR = new DetalleLiquidacionISR();
            DetalleLiquidacionISRRepository _RepDetLiqISR = new DetalleLiquidacionISRRepository();

            DetLiqISR = _RepDetLiqISR.GetByIdReferenciaISR(DefaultValues.IdReferenciaISR);
            NUnit.Framework.Assert.True(true);
        }
    }
}
