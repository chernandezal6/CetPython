using System;
using System.Collections.Generic;

namespace SuirPlusEF.Framework
{
    
    public class ServiceResult {
        
        public bool ServiceExecuted {get; set;}
        private string _message { get; set; }
        private List<string> _messages = new List<string>();
        public IEnumerable<string> MessagesList { get { return _messages; } }
        public string Message() {

            foreach(var m in MessagesList) {
                _message += m + Environment.NewLine;
            }
            return _message;
        }
        public void AddMessage(string Message){
            this._messages.Add(Message);
        }
        public Exception Exception{get; set;}
        public void AddErrorMessages(IList<string> errorMessages)
        {
            this.ServiceExecuted = false;
            
            foreach (var item in errorMessages)
            {
                this._messages.Add(item);
            }
            
        }
        public void AddErrorMessage(string errorMessage){
            this.ServiceExecuted = false;
            this._messages.Add(errorMessage);
        }
        
    }    
}