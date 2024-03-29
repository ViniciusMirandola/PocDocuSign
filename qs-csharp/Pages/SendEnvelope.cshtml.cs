﻿using DocuSign.eSign.Api;
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
    public class EnvelopeInfo
    {   

        [Required, StringLength(100)]
        public string Name { get; set; }

        [Required, StringLength(100)]
        public string Email { get; set; }

        [Required, StringLength(100)]
        public string AssuntoEmail { get; set; }
    }



    public class SendEnvelopeModel : PageModel
    {

        [BindProperty]
        public EnvelopeInfo EnvelopeInfo { get; set; }

        // Constants need to be set:
        private const string docName = "World_Wide_Corp_lorem.pdf";

        // Additional constants
        private const string basePath = "https://demo.docusign.net/restapi";

        public SendEnvelopeModel(IOptions<DocusignSettings> config)
        {
            this.config = config;
        }

        private readonly IOptions<DocusignSettings> config;


        public void OnGet()
        {
            ViewData["nomeDestinatario"] = config.Value.UserFullName;
            ViewData["emailDestinatario"] = config.Value.UserEmail;
            ViewData["AssuntoEmail"] = "Entre com o  assunto do e-mail";
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


            string signerName = EnvelopeInfo.Name;

            string signerEmail = EnvelopeInfo.Email;

            // Send envelope. Signer's request to sign is sent by email.
            // 1. Create envelope request obj
            // 2. Use the SDK to create and send the envelope

            // 1. Create envelope request object
            //    Start with the different components of the request
            //    Create the document object
            Document document = new Document
            {
                DocumentBase64 = Convert.ToBase64String(ReadContent(docName)),
                Name = "Lorem Ipsum",
                FileExtension = "pdf",
                DocumentId = "1",
                
            };

            Document[] documents = new Document[] { document };

            // Create the signer recipient object 
            Signer signer = new Signer
            {
                Email = signerEmail, Name = signerName,
                RecipientId = "1", RoutingOrder = "1"
            };

            // Create the sign here tab (signing field on the document)
            SignHere signHereTab = new SignHere
            {
                DocumentId = "1", PageNumber = "1", RecipientId = "1",
              TabLabel = "Sign Here Tab", XPosition = "195", YPosition = "147"
            };

            SignHere[] signHereTabs = new SignHere[] { signHereTab };

            // Add the sign here tab array to the signer object.
            signer.Tabs = new Tabs { SignHereTabs = new List<SignHere>(signHereTabs) };
            
            // Create array of signer objects
            Signer[] signers = new Signer[] { signer };

            // Create recipients object
            Recipients recipients = new Recipients { Signers = new List<Signer>(signers) };
            
            // Bring the objects together in the EnvelopeDefinition
            EnvelopeDefinition envelopeDefinition = new EnvelopeDefinition
            {
                EmailSubject = EnvelopeInfo.AssuntoEmail,
                Documents = new List<Document>(documents),
                Recipients = recipients,
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
