using System;
using Microsoft.AspNetCore.Mvc.RazorPages;
using DocuSign.eSign.Api;
using DocuSign.eSign.Client;
using DocuSign.eSign.Model;
using static DocuSign.eSign.Api.EnvelopesApi;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Mvc;

namespace qs_csharp.Pages
{
    public class ListEnvelopesModel : PageModel
    {
        private const int envelopesAgeDays = -10;

        // Additional constants
        private const string basePath = "https://demo.docusign.net/restapi";

        public ListEnvelopesModel(IOptions<DocusignSettings> config)
        {
            this.config = config;
        }

        private readonly IOptions<DocusignSettings> config;



        public void OnGet([FromQuery(Name = "page")] string page)
        {

            // Constants need to be set:
            string accessToken = config.Value.AccessToken;
            string accountId = config.Value.AccountId;


            // List the user's envelopes created in the last 10 days
            // 1. Create request options
            // 2. Use the SDK to list the envelopes

            // 1. Create request options
            ListStatusChangesOptions options = new ListStatusChangesOptions();
            DateTime date = DateTime.Now.AddDays(envelopesAgeDays);
            options.fromDate = date.ToString("yyyy/MM/dd");

            // 2. Use the SDK to list the envelopes
            ApiClient apiClient = new ApiClient(basePath);
            apiClient.Configuration.AddDefaultHeader("Authorization", "Bearer " + accessToken);
            EnvelopesApi envelopesApi = new EnvelopesApi(apiClient.Configuration);
            //EnvelopesInformation results = envelopesApi.ListStatusChanges(accountId, options);

            string EnvelopeId = page;

            if (string.IsNullOrEmpty(page))
                return;


            var resultsEnvelope = envelopesApi.GetEnvelope(accountId, EnvelopeId);

            // Prettyprint the results
            string json = JsonConvert.SerializeObject(resultsEnvelope);
            string jsonFormatted = JValue.Parse(json).ToString(Formatting.Indented);
            ViewData["results"] = jsonFormatted;


            var resultsRecipents = envelopesApi.ListRecipients(accountId, EnvelopeId);

            // Prettyprint the results
            json = JsonConvert.SerializeObject(resultsRecipents);
            jsonFormatted = JValue.Parse(json).ToString(Formatting.Indented);
            ViewData["resultsRecipents"] = jsonFormatted;

            var resultsDocuments = envelopesApi.ListDocuments(accountId, EnvelopeId);

            // Prettyprint the results
            json = JsonConvert.SerializeObject(resultsDocuments);
            jsonFormatted = JValue.Parse(json).ToString(Formatting.Indented);
            ViewData["resultsDocuments"] = jsonFormatted;

            return;
        }
    }
}
