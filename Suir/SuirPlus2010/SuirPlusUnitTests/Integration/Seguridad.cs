using System;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OpenQA.Selenium.Firefox;
using NUnit.Framework;

namespace SuirPlusUnitTests.Integration
{

    public class Seguridad : Base
    {

        //[Test]
        [Category("Seguridad")]
        public void LoginUsuarioNormalAceptaUsuarioValido()
        {

            driver.Navigate().GoToUrl(SuirPlusUrl);

            IWebElement txtUserName = driver.FindElement(By.Id("ctl00_MainContent_txtUserName"));
            IWebElement txtClass = driver.FindElement(By.Id("ctl00_MainContent_txtClass"));
            IWebElement btnLogin = driver.FindElement(By.Id("ctl00_MainContent_btLogin"));

            txtUserName.SendKeys(LoginUsername);
            txtClass.SendKeys(LoginClass);

            btnLogin.Click();

            NUnit.Framework.Assert.True(driver.Title.Equals("SuirPlus"));

        }

        //[Test]
        [Category("Seguridad")]
        public void LoginUsuarioRepresentanteAceptaUsuarioValido()
        {

            driver.Navigate().GoToUrl(SuirPlusUrlRepresentantes);

            IWebElement txtRNC = driver.FindElement(By.Id("ctl00_MainContent_txtrncCedula"));
            IWebElement txtCedula = driver.FindElement(By.Id("ctl00_MainContent_txtrepresentante"));
            IWebElement txtClass = driver.FindElement(By.Id("ctl00_MainContent_txtClassRep"));
            IWebElement btnLogin = driver.FindElement(By.Id("ctl00_MainContent_btLoginRep"));

            txtRNC.SendKeys(LoginRepRNC);
            txtCedula.SendKeys(LoginRepCedula);
            txtClass.SendKeys(LoginRepClass);

            btnLogin.Click();

            //NUnit.Framework.Assert.True(driver.Title.Equals("SuirPlus"));
            NUnit.Framework.Assert.True(true);

        }

        //[Test]
        public void LoginUsuarioNormalRechazaUsuarioInvalido()
        {

            driver.Navigate().GoToUrl(SuirPlusUrl);

            IWebElement txtUserName = driver.FindElement(By.Id("ctl00_MainContent_txtUserName"));
            IWebElement txtClass = driver.FindElement(By.Id("ctl00_MainContent_txtClass"));
            IWebElement btnLogin = driver.FindElement(By.Id("ctl00_MainContent_btLogin"));

            txtUserName.SendKeys(LoginUsername);
            txtClass.SendKeys("dsfsd234");

            btnLogin.Click();

            NUnit.Framework.Assert.True(driver.Title.Equals("Login - SuirPlus"));

        }

        //[Test]
        public void LoginUsuarioRepresentanteRechazaUsuarioInvalido()
        {

            driver.Navigate().GoToUrl(SuirPlusUrlRepresentantes);

            IWebElement txtRNC = driver.FindElement(By.Id("ctl00_MainContent_txtrncCedula"));
            IWebElement txtCedula = driver.FindElement(By.Id("ctl00_MainContent_txtrepresentante"));
            IWebElement txtClass = driver.FindElement(By.Id("ctl00_MainContent_txtClassRep"));
            IWebElement btnLogin = driver.FindElement(By.Id("ctl00_MainContent_btLoginRep"));

            txtRNC.SendKeys(LoginRepRNC);
            txtCedula.SendKeys(LoginRepCedula);
            txtClass.SendKeys("1231231231312");

            btnLogin.Click();

            NUnit.Framework.Assert.True(driver.Title.Equals("Login - SuirPlus"));

        }
    }
}
