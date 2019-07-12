using DocuSign.eSign.Api;
using DocuSign.eSign.Client;
using DocuSign.eSign.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Options;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.IO;
using System.Threading.Tasks;

namespace qs_csharp.Pages
{
    public class EnvelopeTemplateInfo
    {
        [Required, StringLength(100)]
        public string ModeloId { get; set; }

        [Required, StringLength(100)]
        public string Name { get; set; }

        [Required, StringLength(100)]
        public string Email { get; set; }

        [Required, StringLength(100)]
        public string AssuntoEmail { get; set; }

        [Required, StringLength(10000)]
        public string CorpoEmail { get; set; }

    }

    public class SendEnvelopeWithTemplateModel : PageModel
    {

        [BindProperty]
        public EnvelopeTemplateInfo EnvelopeTemplateInfo { get; set; }

        // Constants need to be set:
        private const string docName = "World_Wide_Corp_lorem.pdf";

        // Additional constants
        private const string basePath = "https://demo.docusign.net/restapi";

        public SendEnvelopeWithTemplateModel(IOptions<DocusignSettings> config)
        {
            this.config = config;
        }

        private readonly IOptions<DocusignSettings> config;


        public void OnGet()
        {
            ViewData["nomeDestinatario"] = config.Value.UserFullName;
            ViewData["emailDestinatario"] = config.Value.UserEmail;
            ViewData["AssuntoEmail"] = "Entre com o  assunto do e-mail";
            ViewData["TemplateId"] = config.Value.TemplateId;
        }

        public async Task<IActionResult> OnPostAsync()
        {

            if (!ModelState.IsValid)
            {
                ViewData["results"] = $"Informações não preenchidas";

                return new PageResult();
            }


            // Constants need to be set:
            string accessToken = config.Value.AccessToken;
            string accountId = config.Value.AccountId;


            string signerName = EnvelopeTemplateInfo.Name;

            string signerEmail = EnvelopeTemplateInfo.Email;

            // Create the signer recipient object 
            Signer signer = new Signer
            {
                Email = signerEmail, Name = signerName,
                RecipientId = "1", RoutingOrder = "1"
            };
            
            // Create array of signer objects
            Signer[] signers = new Signer[] { signer };
            
            // Create recipients object
            Recipients recipients = new Recipients { Signers = new List<Signer>(signers) };
            
            // Bring the objects together in the EnvelopeDefinition
            EnvelopeDefinition envelopeDefinition = new EnvelopeDefinition
            {
                
                EmailSubject = EnvelopeTemplateInfo.AssuntoEmail,
                EmailBlurb = EnvelopeTemplateInfo.CorpoEmail,
                TemplateId = EnvelopeTemplateInfo.ModeloId,
                TemplateRoles = new List<TemplateRole> { new TemplateRole {  Email = signerEmail, Name = signerName, RoleName = "Teste" } },
                Status = "sent"                
            };

            // 2. Use the SDK to create and send the envelope
            ApiClient apiClient = new ApiClient(basePath);
            apiClient.Configuration.AddDefaultHeader("Authorization", "Bearer " + accessToken);
            EnvelopesApi envelopesApi = new EnvelopesApi(apiClient.Configuration);

            EnvelopeSummary results = envelopesApi.CreateEnvelope(accountId, envelopeDefinition);

            ViewData["results"] = $"Envelope status: {results.Status}. Envelope ID: {results.EnvelopeId}";

            return new PageResult();
        }

        /// <summary>
        /// This method read bytes content from the project's Resources directory
        /// </summary>
        /// <param name="fileName">resource path</param>
        /// <returns>return bytes array</returns>
        internal static byte[] ReadContent(string fileName)
        {
            byte[] buff = null;
            string path = Path.Combine(Directory.GetCurrentDirectory(), "Resources", fileName);
            using (FileStream stream = new FileStream(path, FileMode.Open, FileAccess.Read))
            {
                using (BinaryReader br = new BinaryReader(stream))
                {
                    long numBytes = new FileInfo(path).Length;
                    buff = br.ReadBytes((int)numBytes);
                }
            }

            return buff;
        }
    }
}
