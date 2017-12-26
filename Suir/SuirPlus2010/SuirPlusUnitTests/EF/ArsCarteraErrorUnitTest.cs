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
    public class ArsCarteraErrorUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdError()
        {
            ArsCarteraError arscarteraerror = new ArsCarteraError();
            ArsCarteraErrorRepository _RepArsCarteraError = new ArsCarteraErrorRepository();

            arscarteraerror = _RepArsCarteraError.GetByIdError(DefaultValues.IdErrorCartera);
            NUnit.Framework.Assert.True(true);
        }
    }
}
