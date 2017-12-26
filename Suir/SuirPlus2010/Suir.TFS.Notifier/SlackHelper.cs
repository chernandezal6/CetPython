using Newtonsoft.Json;
using System;
using System.Collections.Specialized;
using System.Text;
using System.Net;
using System.Linq;

namespace Suir.TFS.Notifier
{
    public class SlackHelper
    {
        private readonly Uri _uri;
        private readonly Encoding _encoding = new UTF8Encoding();

        public SlackHelper()
        {
            string urlWithAccessToken = "https://hooks.slack.com/services/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";
            _uri = new Uri(urlWithAccessToken);
        }

        public void SendMsg(string AsignadoA, string AsignadoPor, string ID, string Titulo, string Tipo, ref string MensageEnviado, ref string RespuestaSlack)
        {

            string username = "johnny #5";
            string channel = "#prueba-procesos";
            string asignado_slack_username = "";
            string asignado_por_slack_username = "";

            ETCDHelper.GetUserInformation(AsignadoPor, ref asignado_por_slack_username, ref channel);
            ETCDHelper.GetUserInformation(AsignadoA, ref asignado_slack_username, ref channel);

            string ticket_link = "<http://kronos:8080/tfs/TFS2008_Collection/SuirGit/_workitems#_a=edit&id=" + ID + "&fullScreen=true|#" + ID + ">";
            string Mensaje = $"<@{asignado_slack_username}> usted tiene un nuevo {Tipo} {ticket_link} asignado por <@{asignado_por_slack_username}> \n {Titulo}";

            Payload payload = new Payload()
            {
                Channel = channel,
                Username = username,
                Text = Mensaje
            };

            SendMsg(payload, ref MensageEnviado, ref RespuestaSlack);
        }

        public void SendMsg(Payload payload, ref string MensageEnviado, ref string RespuestaSlack)
        {
            string payloadJson = JsonConvert.SerializeObject(payload);

            using (WebClient client = new WebClient())
            {
                NameValueCollection data = new NameValueCollection();
                data["payload"] = payloadJson;

                MensageEnviado = string.Join(",", data.AllKeys.Select(key => data[key]));

                var response = client.UploadValues(_uri, "POST", data);

                RespuestaSlack = _encoding.GetString(response);
            }
        }
    }

    public class Payload
    {
        [JsonProperty("channel")]
        public string Channel { get; set; }

        [JsonProperty("username")]
        public string Username { get; set; }

        [JsonProperty("text")]
        public string Text { get; set; }
    }
}
