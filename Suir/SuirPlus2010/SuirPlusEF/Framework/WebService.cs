using SuirPlusEF.Models;
using System;

namespace SuirPlusEF.Framework
{
    public abstract class WebService<T> where T : class
    {

        public string UrlString { get; set; }
        private Uri myURL;

        public Uri URL
        {
            get { return new Uri(this.UrlString); }
            set { myURL = value; }
        }

        protected ServiceResult ServiceResult;
        
        public bool MatchFound {get; set;}

        public Config Config { get; set; }

        public string AccessToken { get; set; }
        public string ServiceID { get; set; }

        public string ProxyUser { get; set; }


        public string UserName { get; set; }
        public string Password { get; set; }

        public WebService() {
            this.ServiceResult = new ServiceResult();
        }

    }
}
