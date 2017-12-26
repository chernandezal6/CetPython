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
    public class LiqInfotepUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByRefInfotep(){
            LiquidacionInfotep liqInfotep = new LiquidacionInfotep();
            LiquidacionInfotepRepository _RepLiqInfotep = new LiquidacionInfotepRepository();

            liqInfotep = _RepLiqInfotep.GetByIdReferenciaInfotep(DefaultValues.IdReferenciaTSS);
            NUnit.Framework.Assert.True(true);
        }        
    }
}
