using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;
using SuirPlusEF.GenericModels;
using SuirPlusEF.Service;

namespace SuirPlusUnitTests.Generic
{
    public class DocumentUnitTest
    {
        string CedConGuiones = "000-1234567-3";
        string CedSinGuiones = "00012345673";

        [Test]
        [Category("Generic")]
        public void CedulaSinGuiones() {

            string CedulaConGuiones = "000-1234567-3";
            string CedulaSinGuiones = "00012345673";

            DocumentoCedula doc1 = new DocumentoCedula(CedulaConGuiones);
            DocumentoCedula doc2 = new DocumentoCedula(CedulaSinGuiones);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(CedulaSinGuiones, doc1.NumeroSinGuiones());
            NUnit.Framework.StringAssert.AreEqualIgnoringCase(CedulaSinGuiones, doc2.NumeroSinGuiones());
        }

        [Test]
        [Category("Generic")]
        public void CedulaConGuiones()
        {

            string CedulaConGuiones = "000-1234567-3";
            string CedulaSinGuiones = "00012345673";

            DocumentoCedula doc1 = new DocumentoCedula(CedulaConGuiones);
            DocumentoCedula doc2 = new DocumentoCedula(CedulaSinGuiones);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(CedulaConGuiones, doc1.NumeroConGuiones());
            NUnit.Framework.StringAssert.AreEqualIgnoringCase(CedulaConGuiones, doc2.NumeroConGuiones());
        }

        [Test]
        [Category("Generic")]
        public void NUISinGuiones() {

            string NUIConGuiones = "000-1234567-3";
            string NUISinGuiones = "00012345673";

            DocumentoNUI doc1 = new DocumentoNUI(NUIConGuiones);
            DocumentoNUI doc2 = new DocumentoNUI(NUISinGuiones);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(NUISinGuiones, doc1.NumeroSinGuiones());
            NUnit.Framework.StringAssert.AreEqualIgnoringCase(NUISinGuiones, doc2.NumeroSinGuiones());

            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("Generic")]
        public void NUIConGuiones()
        {

            string NUIConGuiones = "000-1234567-3";
            string NUISinGuiones = "00012345673";

            DocumentoNUI doc1 = new DocumentoNUI(NUIConGuiones);
            DocumentoNUI doc2 = new DocumentoNUI(NUISinGuiones);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(NUIConGuiones, doc1.NumeroConGuiones());
            NUnit.Framework.StringAssert.AreEqualIgnoringCase(NUIConGuiones, doc2.NumeroConGuiones());

            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("Generic")]
        public void MunicipioCedula()
        {            
            var municipio = "000";
            DocumentoCedula doc1 = new DocumentoCedula(CedConGuiones);
            DocumentoCedula doc2 = new DocumentoCedula(CedSinGuiones);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(municipio, doc1.Municipio());
            NUnit.Framework.StringAssert.AreEqualIgnoringCase(municipio, doc2.Municipio());
        }

        [Test]
        [Category("Generic")]
        public void NumerosIntermediosCedula()
        {
            var numerosIntermedios = "1234567";
            DocumentoCedula doc1 = new DocumentoCedula(CedConGuiones);
            DocumentoCedula doc2 = new DocumentoCedula(CedSinGuiones);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(numerosIntermedios, doc1.Numero());
            NUnit.Framework.StringAssert.AreEqualIgnoringCase(numerosIntermedios, doc2.Numero());
        }

        [Test]
        [Category("Generic")]
        public void DigitoVerificadorCedula()
        {
            var DigitoVerificador = "3";
            DocumentoCedula doc1 = new DocumentoCedula(CedConGuiones);
            DocumentoCedula doc2 = new DocumentoCedula(CedSinGuiones);

            NUnit.Framework.StringAssert.AreEqualIgnoringCase(DigitoVerificador, doc1.DigitoVerificador());
            NUnit.Framework.StringAssert.AreEqualIgnoringCase(DigitoVerificador, doc2.DigitoVerificador());
        }

    }
}
