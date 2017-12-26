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
    public class ErrorUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdError()
        {
            Error error = new Error();
            ErrorRepository _RepError = new ErrorRepository();

            error = _RepError.GetByIdError(DefaultValues.IdError);
            NUnit.Framework.Assert.True(true);
        }
    }
}
