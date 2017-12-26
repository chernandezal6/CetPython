using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Firefox;
using OpenQA.Selenium.Chrome;

namespace SuirPlusUnitTests
{
    [TestFixture]
    public abstract class Base
    {
        public string SuirPlusUrl = "http://172.16.5.31";
        public string SuirPlusUrlRepresentantes = "http://172.16.5.31/Login.aspx?log=r";
        public string LoginUsername = "operaciones";
        public string LoginClass = "321";
        public string LoginRepRNC = "";
        public string LoginRepCedula = "";
        public string LoginRepClass = "";

        public IWebDriver driver;
        
        [SetUp]
        public void SetupTest()
        {
            this.driver = new ChromeDriver();
        }

        [TearDown]
        public void TearDown() {
            this.driver.Quit();
        }

    }
}
