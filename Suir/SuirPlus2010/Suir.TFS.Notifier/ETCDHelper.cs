using etcetera;
using Newtonsoft.Json;
using System;

namespace Suir.TFS.Notifier
{
    public class ETCDHelper
    {
        
        public ETCDHelper() {

        }

        public static void GetUserInformation(string UserName, ref string SlackUserName, ref string SlackChannel)
        {

            IEtcdClient client = new EtcdClient(new Uri("http://172.16.4.132:2379/v2/keys"));

            etcetera.EtcdResponse resp = client.Get("/slack_usernames", true);

            if (resp.Message == "Key not found")
            {

                SlackUserName = UserName;
                SlackChannel = "#mesa-de-ayuda";

            }
            else {

                string val = resp.Node.Value.ToString();
                dynamic respuesta = JsonConvert.DeserializeObject(val);

                foreach (var item in respuesta)
                {

                    if (UserName.ToUpper() == item.teamcity_username.ToString().ToUpper())
                    {
                        SlackUserName = item.slack_username.ToString().ToLower();
                        SlackChannel = item.channel.ToString().ToLower();
                        break;
                    }
                    else {
                        SlackUserName = UserName;
                        SlackChannel = "#mesa-de-ayuda";
                    }

                }
            }

        }

    }
}
